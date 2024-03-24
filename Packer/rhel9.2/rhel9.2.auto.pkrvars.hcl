# ----------------------------------------------------------------------------
# Name:         rhel9.2.auto.pkrvars.hcl
# Description:  Required vSphere variables for RHEL 9.2 Packer builds
# Author:       Ronald Stewart S. Lim
# URL:          https://github.com/ronslim/projects/Packer
# ----------------------------------------------------------------------------

# ISO Settings
#os_iso_file                     = "rhel-server-7.9-x86_64-dvd.iso"
#os_iso_file                     = "rhel-8.6-x86_64-dvd.iso"
os_iso_file                     = "rhel-9.2-x86_64-dvd.iso"
os_iso_path                     = "/ISO"
os_iso_datastore                = "iso-ds"

#Vcenter settings
#vcenter_datastore = "vcenter-ds1"
vcenter_datastore = "vcenter-ds"
vcenter_folder = "/VM"
#vcenter_server = "photon-machine"
vcenter_server = "192.168.16.140"
vcenter_cluster = "vcenter-cluster"
vcenter_username = "administrator@vsphere.local"
vcenter_password = "<desired pw>"
vcenter_datacenter = "vcenter-datacenter"
vcenter_network = "VM Network"
vcenter_insecure = true
build_username = "root"
build_password = "<desired pw>"
#build_directory = "./ovf"

# OS Meta Data
#vm_os_family                    = "Linux"
#vm_os_type                      = "Server"
#vm_os_vendor                    = "RHEL"
#vm_os_version                   = "8.8"

# VM Hardware Settings
vm_hardware_version             = 20
vm_firmware                     = "efi"
vm_cpu_sockets                  = 2
vm_cpu_cores                    = 1
vm_mem_size                     = 2048
vm_nic_type                     = "vmxnet3"
vm_disk_controller              = ["pvscsi"]
vm_disk_size                    = 32768
vm_disk_thin                    = true
vm_cdrom_type                   = "ide"

# VM Settings
#vm_cdrom_remove                 = true
vcenter_convert_template        = true
vcenter_content_library_ovf     = true
vcenter_content_library_destroy = true

# VM OS Settings
#vm_guestos_type                 = "rhel7_64Guest"
#vm_guestos_type                 = "rhel8_64Guest"
vm_guestos_type                 = "rhel9_64Guest"
vm_guestos_language             = "en_GB"
vm_guestos_keyboard             = "gb"
vm_guestos_timezone             = "UTC"

# Provisioner Settings
/*script_files                    = [ "scripts/rhsm-add.sh",
                                    "scripts/updates.sh",
                                    "scripts/pki.sh",
                                    "scripts/sshd.sh",
                                    "scripts/hashicorp.sh",
                                    "scripts/cloud-init.sh",
                                    "scripts/salt-minion.sh",
                                    "scripts/motd.sh",
                                    "scripts/rhsm-remove.sh",
                                    "scripts/cleanup.sh" ]*/
inline_cmds                     = []