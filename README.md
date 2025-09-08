# Proxmox-Cloud-Image-Deployment-Tool
PCIDT

## Downloading the script

1. Download the latest version of the script and sample config.

```
wget https://raw.githubusercontent.com/NWSpitfire/Proxmox-Cloud-Image-Deployment-Tool/refs/heads/main/PCIDT-Script.sh

wget https://raw.githubusercontent.com/NWSpitfire/Proxmox-Cloud-Image-Deployment-Tool/refs/heads/main/sample-config.conf
```

2. Create a configuration file from the sample (optional).

``` 
cp sample-config.conf main-config.conf
```
You can edit the options of the configuration file(s) to suite your desired configuration. See the Configuration File Section below for info on the options.

4. Make the script executable.

```
sudo chmod +x PCIDT-Script.sh
```

## Running the script.

This step will depend on whether you are running the script with or without a configuration file. If you do not specify a configuration file then you will be prompted at the beginning of the script to specify your settings.

### Run the script without a configuration file.

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

It will ask you to manually specify each of the options which would normally be specified in the configuration file (see section Configuration File section below for more info on the options). When asked to specify *CLOUD DISK*, paste the path you copied from *Readlink* earlier.

Once all options have been set, it should go through and configure the VM. Once complete you should have a basic VM (or Template if you specified that) that you can go in and add things like SSH keys to the VM.


2. Run the script **with** a configuration file

By specifying a configuration file, you don't have to worry about specifying any options at the start of the script. You can also have multiple configuration files to suit your needs.

```
./PCIDT-Script.sh <path to configuration file>

./PCIDT-Script.sh sample-config.conf
```


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

## IMPORTANT NOTES AND DISCLOSURE

This is a script from the internet, **before running** on your system I strongly advise you go through and understand what the script is doing. Running random scripts of unknown function and origin from the internet on your "totally not in production* homelab hypervisor, that your family has now come to rely on entirely (lets be honest, keeping Plex all for yourself was never going to happen), is a **terrible idea**! 
For all you know the script could be downloading a crypto-miner or the authors favourite episode of The Power Puff Girls onto your system. Scripts that run on Hypervisors are especially dangerous because one wrong command could spell disaster for your virtual infrastructure, although this is mitigated somewhat by backups (you do have backups... **right**??).

I have tested this script multiple times on my test Proxmox server to debug and ensure it functions correctly - I don't want to nuke my production homelab server. But with all things computers, there are no guarantee's. Make sure you understand the script before running. Also, just the usual disclaimer that **I take no responsibility for your actions or the effects of this script on your system, etc, etc.**

Another disclaimer I would like to make purely for the sake of transparency. The base boilerplate code for this script was created by AI, which I then built this script up from. Yes, I am very lazy, I could not be bothered to write all the tedious input sections. Does this mean this whole repo is AI Slop? Probably. I know some people are very against AI, and that is ok, but by now you can probably tell I'm lazy and have too many projects on the go, AI just makes the process more efficient for me by generating boilerplates, *for now*.

In all seriousness though (fake sarcasm aside), please be careful out there. There is a lot more dangers from literal AI slop that might break your machine, or from malware in general masquerading as useful scripts or programs. I published this script because, althoug simple, the whole Homelab & Self-Hosted Communities are great and, if this makes at least one persons life easier then I'm happy.

Homelabs are cool, keep homelabbing.
