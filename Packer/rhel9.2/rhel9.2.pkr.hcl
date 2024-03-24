# ----------------------------------------------------------------------------
# Name:         rhel9.2.pkr.hcl
# Description:  Build definition for RedHat Enterprise Linux 9.2
# Author:       Ronald Stewart S. Lim
# URL:          https://github.com/ronslim/projects/Packer
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
     build_version               = formatdate("MMYYYY", timestamp())
     build_month                 = formatdate("MM", timestamp())
     build_quarter               = "${local.build_month == "01" ? "Q1" : local.build_month == "02" ? "Q1" : local.build_month == "03" ? "Q1" :
                                      local.build_month == "04" ? "Q2" : local.build_month == "05" ? "Q2" : local.build_month == "06" ? "Q2" :
                                      local.build_month == "07" ? "Q3" : local.build_month == "08" ? "Q3" : local.build_month == "09" ? "Q3" :
                                      local.build_month == "10" ? "Q4" : local.build_month == "11" ? "Q4" : local.build_month == "12" ? "Q4" : ""}"
     ks_content                  = {
                                    "ks.cfg" = templatefile("${abspath(path.root)}/ks.cfg", {
                                        build_username            = var.build_username
                                        build_password            = var.build_password
                                        vm_guestos_language       = var.vm_guestos_language
                                        vm_guestos_keyboard       = var.vm_guestos_keyboard
                                        vm_guestos_timezone       = var.vm_guestos_timezone
                                     })
                                   }
}

# -------------------------------------------------------------------------- #
#                       Template Source Definitions                          #
# -------------------------------------------------------------------------- #
source "vsphere-iso" "rhel92" {
    # vCenter
    vcenter_server              = var.vcenter_server
    username                    = var.vcenter_username
    password                    = var.vcenter_password
    insecure_connection         = var.vcenter_insecure
    datacenter                  = var.vcenter_datacenter
    cluster                     = var.vcenter_cluster
    folder                      = var.vcenter_folder
    datastore                   = var.vcenter_datastore

    # Content Library and Template Settings
    convert_to_template         = var.vcenter_convert_template

    content_library_destination {
           library         = "Packer Standard Library"
           #name            = "rhel7.9-${ local.build_quarter }${ local.build_version }"
           #name            = "rhel8.6-${ local.build_quarter }${ local.build_version }"
           name            = "rhel9.2-${ local.build_quarter }${ local.build_version }"
           #description     = "Packer rhel 7.9 created OVF"
           #description     = "Packer rhel 8.6 created OVF"
           description     = "Packer rhel 9.2 created OVF"
           ovf             = var.vcenter_content_library_ovf
           destroy         = var.vcenter_content_library_destroy
           skip_import     = var.vcenter_content_library_skip
    }

    # Virtual Machine
    guest_os_type               = var.vm_guestos_type
    #vm_name                     = "${ source.name }-${ var.build_branch }"
    #vm_name                     = "packer-rhel7.9-test"
    #vm_name                     = "packer-rhel8.6-test"
    vm_name                     = "packer-rhel9.2-test"
    firmware                    = var.vm_firmware
    CPUs                        = var.vm_cpu_sockets
    cpu_cores                   = var.vm_cpu_cores
    CPU_hot_plug                = var.vm_cpu_hotadd
    RAM                         = var.vm_mem_size
    RAM_hot_plug                = var.vm_mem_hotadd
    cdrom_type                  = var.vm_cdrom_type
    remove_cdrom                = var.vm_cdrom_remove
    disk_controller_type        = var.vm_disk_controller
    storage {
        disk_size               = var.vm_disk_size
        disk_thin_provisioned   = var.vm_disk_thin
    }
    network_adapters {
        network                 = var.vcenter_network
        network_card            = var.vm_nic_type
    }
    #Export with OVF template
    #export {
    #   force = true
    #   output_directory = "${ var.build_directory }"
    #}

    # Removeable Media
    iso_paths                   = [ "[${ var.os_iso_datastore }] ${ var.os_iso_path }/${ var.os_iso_file }" ]
    cd_content                  = local.ks_content
    #floppy_files                = ["ks.cfg"]
    cd_files                     = ["ks.cfg"]
    # Boot and Provisioner
    boot_order                  = var.vm_boot_order
    boot_wait                   = var.vm_boot_wait
    boot_command                = [
       "<up>",
       "e",
       "<down><down><end><wait>",
       "text inst.ks=cdrom",
       "<enter><wait><leftctrlOn>x<leftctrlOff>"
    ]
    ip_wait_timeout             = var.vm_ip_timeout
    communicator                = "ssh"
    ssh_username                = var.build_username
    ssh_password                = var.build_password
    shutdown_command            = "sudo shutdown -P now"
    shutdown_timeout            = var.vm_shutdown_timeout
}

# -------------------------------------------------------------------------- #
#                             Build Management                               #
# -------------------------------------------------------------------------- #
build {
    # Build sources
    sources                 = [ "source.vsphere-iso.rhel92" ]


}