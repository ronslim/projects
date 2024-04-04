# ----------------------------------------------------------------------------
# Name:         rhel9.2.auto.pkrvars.hcl
# Description:  Required vSphere variables for RHEL 8 Packer builds
# Author:       Ronald Stewart S. Lim
# URL:          https://github.com/ronslim
# ----------------------------------------------------------------------------

# ISO Settings
#os_iso_file                     = "rhel-server-7.9-x86_64-dvd.iso"
#os_iso_file                     = "rhel-8.6-x86_64-dvd.iso"
os_iso_file                     = "rhel-9.2-x86_64-dvd.iso"
os_iso_path                     = "/ISO"
os_iso_datastore                = "nfs-iso-ds"

#Network COnfiguration of the image
vm_ip_address = "192.168.16.145"
vm_ip_gateway = "192.168.16.2"
vm_nameserver =  "192.168.16.2"

#Vcenter settings
vcenter_datastore = "packer-ds"
vcenter_folder = "/VM"
vcenter_server = "192.168.16.140"
vcenter_cluster = "packer-cluster"
vcenter_username = "administrator@vsphere.local"
vcenter_password = "Milo2024!"
vcenter_datacenter = "packer-datacenter"
vcenter_network = "VM Network"
vcenter_content_library = "Packer Standard Library"
vcenter_resource_pool = "packer-rp"
build_username = "root"
build_password = "Milo2024!"

# Provisioner Settings
script_files                    = [ "provisioner/fstab_vg2_setup.sh"]