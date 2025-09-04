# Proxmox-Cloud-Image-Deployment-Tool
PCIDT


-- Run Readlink to identify disk image path before running the script --

```
readlink -f <file name>

readlink -f debian-13-generic-amd64-custom.qcow2
```

Expected Output
```
/root/debian-13-generic-amd64-custom.qcow2
```

| Key                   | Description                    | Default     |
| --------------------- | ------------------------------ | ----------- |
| `VMID`                | VM ID                          | (required)  |
| `VM_NAME`             | VM name                        | (required)  |
| `CLOUD_DISK`          | Path to the image              | (required)  |
| `TARGET_STORAGE`      | Target storage                 | `local-lvm` |
| `NET_BRIDGE`          | Network bridge                 | `vmbr0`     |
| `CI_USER`             | Cloud-init username            | (required)  |
| `CI_PASSWORD`         | Cloud-init password            | (required)  |
| `CI_USE_DHCP`         | Use DHCP (`true`/`false`)      | `true`      |
| `CONVERT_TO_TEMPLATE` | Convert to template at the end | `false`     |
