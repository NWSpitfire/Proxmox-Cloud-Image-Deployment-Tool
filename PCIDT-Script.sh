#!/bin/bash

# Start script message
echo "Proxmox Cloud Image Deployment Tool"
echo "Version 1.0 - 2025"
echo "By NWSpitfire (Github)"
echo ""
echo ""
sleep 1

# Load config file if specified
if [[ -n "$1" && -f "$1" ]]; then
    echo "Loading configuration from $1"
    source "$1"
fi

# Prompt for VMID
if [[ -z "$VMID" ]]; then
    read -p "Enter VMID: " VMID
fi
if [[ -z "$VMID" ]]; then
    echo "VMID cannot be empty."
    exit 1
fi

# Prompt for VM Name
if [[ -z "$VM_NAME" ]]; then
    read -p "Enter VM Name: " VM_NAME
fi
if [[ -z "$VM_NAME" ]]; then
    echo "VM Name cannot be empty."
    exit 1
fi

# Prompt for cloud disk path
if [[ -z "$CLOUD_DISK" ]]; then
    read -p "Enter path to cloud disk image (.img or .qcow2): " CLOUD_DISK
fi
if [[ ! -f "$CLOUD_DISK" ]]; then
    echo "Cloud disk image not found at $CLOUD_DISK"
    exit 1
fi

# Prompt for target storage (default: local-lvm)
if [[ -z "$TARGET_STORAGE" ]]; then
    read -p "Enter target storage (default: local-lvm): " TARGET_STORAGE
    TARGET_STORAGE=${TARGET_STORAGE:-local-lvm}
fi

# Prompt for network bridge (default: vmbr0)
if [[ -z "$NET_BRIDGE" ]]; then
    read -p "Enter network bridge (default: vmbr0): " NET_BRIDGE
    NET_BRIDGE=${NET_BRIDGE:-vmbr0}
fi

# Prompt for Cloud-init username
if [[ -z "$CI_USER" ]]; then
    read -p "Enter Cloud-Init username: " CI_USER
fi
if [[ -z "$CI_USER" ]]; then
    echo "Cloud-Init Username cannot be empty."
    exit 1
fi

# Prompt for Cloud-init password
if [[ -z "$CI_PASSWORD" ]]; then
    read -s -p "Enter Cloud-Init password: " CI_PASSWORD
    echo
fi
if [[ -z "$CI_PASSWORD" ]]; then
    echo "Cloud-Init Password cannot be empty."
    exit 1
fi

# Prompt for DHCP setting
if [[ -z "$CI_USE_DHCP" ]]; then
    read -p "Use DHCP for networking? (yes/no) [yes]: " CI_USE_DHCP
    CI_USE_DHCP=${CI_USE_DHCP:-yes}
fi

# -- Begin Program --

# Create the VM with 1 CPU
echo "Creating VM $VMID ($VM_NAME)..."
qm create "$VMID" --name "$VM_NAME" --memory 2048 --cores 1 --net0 virtio,bridge="$NET_BRIDGE"

# Wait 10s to allow for VM creation on the backend
echo "Waiting 10s for VM creation to complete..."
sleep 10

# Import the cloud disk
echo "Importing cloud disk..."
qm importdisk "$VMID" "$CLOUD_DISK" "$TARGET_STORAGE"

# Determine imported disk name
IMPORTED_DISK="${TARGET_STORAGE}:vm-${VMID}-disk-0"

# Attach the disk as SCSI with virtio-scsi-pci controller
echo "Attaching imported disk as SCSI..."
qm set "$VMID" --scsihw virtio-scsi-pci --scsi0 "$IMPORTED_DISK"

# Add cloud-init disk
echo "Adding Cloud-Init disk..."
qm set "$VMID" --ide2 "${TARGET_STORAGE}:cloudinit"

# Set boot options
echo "Setting boot order to disk only..."
qm set "$VMID" --boot order=scsi0 --bootdisk scsi0 --bios seabios

# Add serial console
echo "Adding serial console..."
qm set "$VMID" --serial0 socket --vga serial0

# Set cloud-init options
echo "Configuring Cloud-Init..."
qm set "$VMID" --ciuser "$CI_USER" --cipassword "$CI_PASSWORD"

if [[ "$CI_USE_DHCP" =~ ^[Yy][Ee]?[Ss]?$ ]]; then
    echo "Setting network to DHCP..."
    qm set "$VMID" --ipconfig0 ip=dhcp
else
    echo "Leaving static IP as default (manual configuration required)."
fi

# Prompt to convert to template
if [[ -z "$CONVERT_TO_TEMPLATE" ]]; then
    read -p "Convert VM to template? (yes/no) [no]: " CONVERT_TO_TEMPLATE
    CONVERT_TO_TEMPLATE=${CONVERT_TO_TEMPLATE:-no}
fi

if [[ "$CONVERT_TO_TEMPLATE" =~ ^[Tt][Rr][Uu][Ee]$ || "$CONVERT_TO_TEMPLATE" =~ ^[Yy][Ee]?[Ss]?$ ]]; then
    echo "-- Converting VM $VMID to template..."
    qm template "$VMID"
    echo "-- VM $VMID converted to template."
else
    echo "VM $VMID left as normal VM."
fi

# Done
echo "-- SUCCESS! VM $VMID ($VM_NAME) setup completed."
