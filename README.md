# Proxmox-Cloud-Image-Deployment-Tool
PCIDT

## Downloading and Running the script

1. Download the latest version of the script

```
TBA
```

2. Create a configuration file from the sample (optional).

``` 
git clone https://github.com/NWSpitfire/Proxmox-Cloud-Image-Deployment-Tool.git
```

###### NOTE: Multiple configuration files can be created for different VM Configurations.

3. Make the script executable.

```
sudo chmod +x PCIDT-Script.sh
```

4. Run the script.
This step will depend on whether you are running the script with or without a configuration file. If you do not specify a configuration file then you will be prompted at the beginning of the script to specify your settings.

i. Run the script without a configuration file.

By doing this you will need to know the path of the cloud-image disk on your host, you can find this by using *Readlink*.

```
readlink -f <file name>

readlink -f debian-13-generic-amd64-custom.qcow2
```

The expected output of that command should be something like this.
```
/root/debian-13-generic-amd64-custom.qcow2
```

Once you have identified and copied (or written down) your path to the cloud-image disk, you can run the script.

```
./PCIDT-Script.sh
```

It will ask you to manually specify each of the options which would normally be specified in the configuration file (see section Configuration File below for more info on the options). When asked to specify *CLOUD DISK*, paste the path you copied from *Readlink* earlier.

Once all options have been set, it should go through and configure the VM. Once complete you should have a basic VM (or Template if you specified that) that you can go in and add things to like SSH keys and 


## Configuration File

The configuration file can be created and specified when running the script. If specified, it will automatically populate all of the values that are usually prompted when the script is run. This means the script can create mutliple templates with mutliple configurations.

The options that can be configured are;

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
