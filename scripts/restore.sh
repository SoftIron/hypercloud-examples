#!/bin/bash
set -e
now=$(date +%Y-%m-%d_%H-%M-%S)
args=("$@")
SSH_HOST="10.0.0.1"  # Static Node 1 Address

POOL=${args[0]}
DATASTORE_ID=${args[1]}

# Declare an array to store image IDs
declare -a image_ids

# Declare an array to store protected snapshots
declare -a protected_snapshots

# Function to check if a snapshot exists remotely
snapshot_exists() {
    local rbd_name="$1"
    local snapshot="$2"
    local snapshot_list=$(rbd --pool ${POOL} snap ls ${rbd_name} | grep -v NAME | awk '{print $2}')
    
    for existing_snapshot in $snapshot_list; do
        if [ "$existing_snapshot" == "$snapshot" ]; then
            return 0  # Snapshot exists
        fi
    done
    return 1  # Snapshot doesn't exist
}

# Sanity checks
if [ $# -lt 4 ]
   then echo Number of arguments passed: $#
      echo 'Use the format restore.sh _Pool_(rbd etc) _DataStore ID_(100) _snap_(without the @ symbol!) _rbd-name_'
      echo
      echo 'Get a list of pools with - ceph osd pool ls'
      echo
      echo 'Use - hypercloud datastore list - for a list of datastores'
      echo
      echo 'Get a list of volumes with - rbd --pool _poolname_ ls'
      echo
      echo 'Get a list of available snapshots with rbd --pool _poolname_ snap ls [rbd_name]'
      echo
      echo 'As many RBDs can be added as needed - with a minimum of 1'
      echo
      exit 1
fi

# Loop through the provided RBD arguments and check if snapshots exist
for ((i = 3; i < $#; i+=1)); do
    RBD=${args[$i]}
    SNAP=${args[2]}
    
    if ! snapshot_exists "$RBD" "$SNAP"; then
        echo "Snapshot '$SNAP' does not exist for RBD '$RBD'. Exiting."
        exit 1
    fi
done

# Function to protect and clone snapshots remotely
protect_and_clone_snapshot() {
    local rbd_name="$1"
    local snapshot="${args[2]}"
    local clone_name="restore-${rbd_name}"

    # Protect the snapshot
    if /usr/bin/rbd --pool ${POOL} snap protect ${rbd_name}@${snapshot}; then
        echo "Snapshot ${rbd_name}@${snapshot} protected successfully."
        protected_snapshots+=("${rbd_name}@${snapshot}")
    else
        echo "Failed to protect snapshot ${snapshot} for RBD ${rbd_name}. Exiting."
        exit 1
    fi
    
    # Clone the snapshot
    if /usr/bin/rbd clone --pool ${POOL} ${rbd_name}@${snapshot} ${POOL}/${clone_name}; then
        echo "Snapshot ${rbd_name}@${snapshot} cloned successfully."
    else
        echo "Failed to clone snapshot ${snapshot} for RBD ${rbd_name}. Exiting."
        exit 1
    fi
}

# Create an image for the first RBD
RBD1=${args[3]}

# Protect and clone the specified snapshot for the current RBD
protect_and_clone_snapshot "${RBD1}"
protected_snapshots+=("${rbd_name}@${snapshot}")

hcdisk0=$(oneimage create -d "${DATASTORE_ID}" --name "${RBD1}" --type "OS" --size "1024M")

# Extract the ID from the output and store it in a variable
image_id0=$(echo "$hcdisk0" | grep -oP 'ID:\s*\K\d+')

# Add the image ID to the array
image_ids+=("$image_id0")

# Loop through any images
if [ -n "${args[4]}" ]; then
    # Loop through the provided RBD arguments and process them
    for ((i = 4; i < $#; i+=1)); do
        RBD=${args[$i]}
        SNAP=${args[2]}

        # Protect and clone the specified snapshot for the current RBD
        protect_and_clone_snapshot "$RBD" "$SNAP"

        # Create an image for the current RBD
        hcdisk=$(oneimage create -d "${DATASTORE_ID}" --name "${RBD}" --type "DATABLOCK" --size "1024M")

        # Extract the ID from the output and store it in a variable
        image_id=$(echo "$hcdisk" | grep -oP 'ID:\s*\K\d+')

        # Add the image ID to the array
        image_ids+=("$image_id")
    done
fi

# Wait for the images to be created
for image_id in "${image_ids[@]}"; do
    while ! rbd --pool ${POOL} info one-${image_id} &> /dev/null; do
        echo "Waiting for RBD image creation..."
        sleep 5  # Adjust the sleep interval as needed
    done
done

# Remove the RBD volumes that were created for these disks
echo "Removing RBD volumes..."
for image_id in "${image_ids[@]}"; do
    ssh ${SSH_HOST} "rbd --pool ${POOL} rm one-${image_id}"
done

# Rename the snapshot clones to match the desired volume names
echo "Renaming snapshot clones..."
for ((i = 3; i < $#; i+=1)); do
    RBD=${args[$i]}
    SNAP=${args[2]}
    image_index=$((i - 3))  # Calculate the index of the corresponding image_id

    if [ "$image_index" -lt "${#image_ids[@]}" ]; then
        image_id="${image_ids[$image_index]}"
        ssh ${SSH_HOST} "rbd rename ${POOL}/restore-${RBD} ${POOL}/one-${image_id}"
        echo "Renamed RBD ${RBD} to one-${image_id}"
    else
        echo "No corresponding image_id found for RBD ${RBD}. Skipping renaming."
    fi
done

# Create a HyperCloud VM template with the disks and other settings
template_name="restore_template-${args[2]}"
template_file="${template_name}.txt"

# Use a here document to create the template
cat <<EOF > "${template_file}"
NAME = "${template_name}"
CONTEXT = [
  NETWORK = "YES",
  SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]"
]
EOF

# Loop through the image IDs and add DISK entries for each
target="a"  # Initialize the disk letter to 'a'

for ((i = 3; i < $#; i+=1)); do
    RBD=${args[$i]}
    cat <<EOF >> "${template_file}"
DISK = [
  IMAGE = "${RBD}",
  SOURCE = "${POOL}/one-${image_id}",
  TARGET = "vd${target}",
  POOL_NAME = "${POOL}",
  TM_MAD = "ceph",
  TYPE = "RBD",
  DRIVER = "raw"
]

EOF
    # Increment the disk letter
    target=$(echo -n "$target" | tr "a-z" "b-z_")
done

# Add the MEMORY and subsequent sections
cat <<EOF >> "${template_file}"
MEMORY = 1024
CPU = "1"
VCPU = "4"
NIC = [
  NETWORK = "Infrastructure Management Network",
  NETWORK_UNAME = "admin",
  SECURITY_GROUPS = "0"
]
GRAPHICS = [
  TYPE = "vnc",
  LISTEN = "0.0.0.0"
]
EOF

echo "Template ${template_file} created. It has been imported into OpenNebula."
hypercloud template create "${template_file}"

echo "When you have finished with the restore"
echo "run the following commands to unprotect"
echo "the snapshosts"
for ((i = 3; i < $#; i+=1)); do
    RBD=${args[$i]}
    snapshot="${args[2]}"
    echo "rbd --pool ${POOL} snap unprotect ${RBD}@${snapshot}"
done


exit 0

