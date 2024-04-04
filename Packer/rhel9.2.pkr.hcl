# ----------------------------------------------------------------------------
# Name:         rhel9.2.pkr.hcl
# Description:  Build definition for RedHat Enterprise Linux 8
# Author:       Ronald Stewart S. Lim
# URL:          https://github.com/ronslim
# ----------------------------------------------------------------------------
#
# -------------------------------------------------------------------------- #
#                           Packer Configuration                             #
# -------------------------------------------------------------------------- #
packer {
    required_version = ">= 1.9.1"
    required_plugins {
        vsphere = {
            version = "= v1.1.2"
            source  = "github.com/hashicorp/vsphere"
        }
    }
}

# -------------------------------------------------------------------------- #
#                              Local Variables                               #
# -------------------------------------------------------------------------- #
locals {
     manifest_output             = "manifest.json"
     build_version               = formatdate("MMYYYY", timestamp())
     build_month                 = formatdate("MM", timestamp())
     build_quarter               = "${local.build_month == "01" ? "Q1" : local.build_month == "02" ? "Q1" : local.build_month == "03" ? "Q1" :
                                      local.build_month == "04" ? "Q2" : local.build_month == "05" ? "Q2" : local.build_month == "06" ? "Q2" :
                                      local.build_month == "07" ? "Q3" : local.build_month == "08" ? "Q3" : local.build_month == "09" ? "Q3" :
                                      local.build_month == "10" ? "Q4" : local.build_month == "11" ? "Q4" : local.build_month == "12" ? "Q4" : ""}"

     # VM Hardware Settings
     vm_firmware                     = "efi"
     vm_cpu_sockets                  = 2
     vm_cpu_cores                    = 1
     vm_mem_size                     = 2048
     vm_nic_type                     = "vmxnet3"
     vm_disk_controller              = ["pvscsi"]
     vm_disk_size                    = ["25600","12288","4096","4096"]
     vm_disk_thin                    = true
     vm_cdrom_type                   = "ide"

     # VM Settings
     vm_cdrom_remove                 = true
     vcenter_convert_template        = true
     vcenter_content_library_ovf     = true
     vcenter_content_library_destroy = true
     vcenter_content_library_skip    = false

     #Vcenter settings
     vcenter_datastore = "packer-ds"
     vcenter_folder = "/VM"
     vcenter_server = "192.168.16.140"
     vcenter_cluster = "packer-cluster"
     vcenter_username = "administrator@vsphere.local"
     vcenter_password = "Milo2024!"
     vcenter_datacenter = "packer-datacenter"
     vcenter_network = "VM Network"
     vcenter_insecure = true
     build_username = "root"
     build_password = "Milo2024!"
     vm_cpu_hotadd = true
     vm_mem_hotadd = true

     # VM OS Settings
     vm_guestos_type                 = "rhel9_64Guest"
     vm_guestos_language             = "en_US.UTF-8"
     vm_guestos_keyboard             = "us"
     vm_guestos_timezone             = "Asia/Singapore"
     vm_ip_timeout                   = "30m"
     vm_shutdown_timeout             = "30m"
     vm_boot_order                   = "disk,cdrom"
     vm_boot_wait                    = "5s"

     ks_content                  = {
                                    "ks.cfg" = templatefile("${abspath(path.root)}/ks.cfg", {
                                        build_password            = var.build_password
                                        vm_guestos_language       = local.vm_guestos_language
                                        vm_guestos_keyboard       = local.vm_guestos_keyboard
                                        vm_guestos_timezone       = local.vm_guestos_timezone
                                        ip                        = var.vm_ip_address
                                        netmask                   = var.vm_ip_netmask
                                        gateway                   = var.vm_ip_gateway
                                        nameserver                = var.vm_nameserver
                                     })
                                   }

}

# -------------------------------------------------------------------------- #
#                       Template Source Definitions                          #
# -------------------------------------------------------------------------- #
source "vsphere-iso" "rhel92" {
    # vCenter
    vcenter_server              = local.vcenter_server
    username                    = local.vcenter_username
    password                    = local.vcenter_password
    insecure_connection         = local.vcenter_insecure
    datacenter                  = local.vcenter_datacenter
    cluster                     = local.vcenter_cluster
    folder                      = local.vcenter_folder
    datastore                   = local.vcenter_datastore

    # Content Library and Template Settings
    convert_to_template         = local.vcenter_convert_template

    content_library_destination {
           library         = var.vcenter_content_library
           name            = "rhel9.2-${ local.build_quarter }${ local.build_version }"
           description     = "Packer rhel 9.2 created OVF"
           ovf             = local.vcenter_content_library_ovf
           destroy         = local.vcenter_content_library_destroy
           skip_import     = local.vcenter_content_library_skip
       }

    # Virtual Machine
    guest_os_type               = local.vm_guestos_type
    vm_name                     = "rhel9.2-${ local.build_quarter }${ local.build_version }"
    notes                       = "VER: ${ local.build_version }\nISO: ${ var.os_iso_file }"
    firmware                    = local.vm_firmware
    CPUs                        = local.vm_cpu_sockets
    cpu_cores                   = local.vm_cpu_cores
    CPU_hot_plug                = local.vm_cpu_hotadd
    RAM                         = local.vm_mem_size
    RAM_hot_plug                = local.vm_mem_hotadd
    cdrom_type                  = local.vm_cdrom_type
    remove_cdrom                = local.vm_cdrom_remove
    disk_controller_type        = local.vm_disk_controller
    resource_pool               = var.vcenter_resource_pool

    dynamic "storage" {
        for_each = local.vm_disk_size
            content {
                disk_size       = storage.value
                disk_thin_provisioned  = local.vm_disk_thin
            }
    }

    network_adapters {
        network                 = local.vcenter_network
        network_card            = local.vm_nic_type
    }

    # Removeable Media
    iso_paths                   = [ "[${ var.os_iso_datastore }] ${ var.os_iso_path }/${ var.os_iso_file }" ]
    cd_content                  = local.ks_content
    cd_files                     = ["ks.cfg"]
    # Boot and Provisioner
    boot_order                  = local.vm_boot_order
    boot_wait                   = local.vm_boot_wait
    boot_command                = [
       "<up>",
       "e",
       "<down><down><end><wait>",
       "text inst.ks=cdrom",
       "<enter><wait><leftctrlOn>x<leftctrlOff>"
    ]
    ip_wait_timeout             = local.vm_ip_timeout
    communicator                = "ssh"
    ssh_username                = var.build_username
    ssh_password                = var.build_password
    shutdown_command            = "sudo shutdown -P now"
    shutdown_timeout            = local.vm_shutdown_timeout
}

# -------------------------------------------------------------------------- #
#                             Build Management                               #
# -------------------------------------------------------------------------- #
build {
    # Build sources
    sources                 = [ "source.vsphere-iso.rhel92" ]

    # Shell Provisioner to execute scripts
    provisioner "shell" {
        scripts             = var.script_files
    }

     post-processor "manifest" {
         output     = local.manifest_output
         strip_path = true
         strip_time = true
         custom_data = {
           build_username           = local.build_username
           vm_cpu_cores             = local.vm_cpu_cores
           vm_cpu_count             = local.vm_cpu_sockets
           vm_firmware              = local.vm_firmware
           vm_guest_os_type         = local.vm_guestos_type
           vm_mem_size              = local.vm_mem_size
           vm_network_card          = local.vm_nic_type
           vsphere_cluster          = var.vcenter_cluster
           vsphere_host             = var.vcenter_server
           vsphere_datacenter       = var.vcenter_datacenter
           vsphere_datastore        = var.vcenter_datastore
           vsphere_folder           = var.vcenter_folder
         }
       }

}

