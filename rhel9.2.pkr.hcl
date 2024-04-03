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
/*     ks_content                  = {
                                    "ks.cfg" = templatefile("${abspath(path.root)}/config/ks.pkrtpl.hcl", {
                                        build_username            = var.build_username
                                        build_password            = var.build_password
                                        vm_guestos_language       = var.vm_guestos_language
                                        vm_guestos_keyboard       = var.vm_guestos_keyboard
                                        vm_guestos_timezone       = var.vm_guestos_timezone
                                     })
                                   }*/
     ks_content                  = {
                                    "ks.cfg" = templatefile("${abspath(path.root)}/ks.cfg", {
                                        build_username            = var.build_username
                                        build_password            = var.build_password
                                        vm_guestos_language       = var.vm_guestos_language
                                        vm_guestos_keyboard       = var.vm_guestos_keyboard
                                        vm_guestos_timezone       = var.vm_guestos_timezone
                                     })
                                   }
#    vm_description              = "VER: ${ local.build_version }\nISO: ${ var.os_iso_file }"
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
    /*
    create_snapshot             = var.vcenter_snapshot
    snapshot_name               = var.vcenter_snapshot_name

    dynamic "content_library_destination" {
        for_each = var.vcenter_content_library != null ? [1] : []
            content {
                library         = var.vcenter_content_library
                name            = "${ source.name }${ locals.build_quarter }"
                description     = local.vm_description
                ovf             = var.vcenter_content_library_ovf
                destroy         = var.vcenter_content_library_destroy
                skip_import     = var.vcenter_content_library_skip
            }
    }*/
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
    #notes                       = local.vm_description
    firmware                    = var.vm_firmware
    CPUs                        = var.vm_cpu_sockets
    cpu_cores                   = var.vm_cpu_cores
    CPU_hot_plug                = var.vm_cpu_hotadd
    RAM                         = var.vm_mem_size
    RAM_hot_plug                = var.vm_mem_hotadd
    cdrom_type                  = var.vm_cdrom_type
    remove_cdrom                = var.vm_cdrom_remove
    disk_controller_type        = var.vm_disk_controller
    #Device: sda
#    storage {
#        disk_size               = var.vm_disk_size
#        disk_thin_provisioned   = var.vm_disk_thin
#    }
#    #Device: sdb
#    storage {
#        disk_size               = var.vm_disk_size
#        disk_thin_provisioned   = var.vm_disk_thin
#    }
#    #Device: sdc
#    storage {
#        disk_size               = 4096
#        disk_thin_provisioned   = var.vm_disk_thin
#    }
#    #Device: sdd
#    storage {
#        disk_size               = 4096
#        disk_thin_provisioned   = var.vm_disk_thin
#    }


    dynamic "storage" {
        for_each = var.vm_disk_size
            content {
                disk_size       = storage.value
                disk_thin_provisioned  = var.vm_disk_thin
            }
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
    /*boot_command                = [ "up", "wait", "e", "<down><down><end><wait>",
                                    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                                    "quiet text inst.ks=cdrom",
                                    "<enter><wait><leftCtrlOn>x<leftCtrlOff>" ]*/
    /*boot_command                = [
       "<up>e<wait>",
       "<down><down><down>",
       "<left>",
       " inst.ks=hd:fd0:/ks.cfg",
       "<wat5s><leftCtrlOn>x<leftCtrlOff>",
       "<wait1m><tab><tab><enter>"
    ]*/
    #boot_command                = [" inst.text inst.ks=hd:fd0:/ks.cfg "]
    #boot_command                 = ["e<leftCtrlOn>c ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"]
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

    # Shell Provisioner to execute scripts
    provisioner "shell" {
        execute_command     = "echo '${ var.build_password }' | {{.Vars}} sudo -E -S sh -eu '{{.Path}}'"
        scripts             = var.script_files
/*
        environment_vars    = [ "PKISERVER=${ var.build_pkiserver }",
                                "CONFIGMGMTUSER=${ var.build_configmgmt_user }",
                                "CONFIGMGMTKEY=${ var.build_configmgmt_key }",
                                "BUILDVERSION=${ local.build_version }",
                                "BUILDREPO=${ var.build_repo }",
                                "BUILDBRANCH=${ var.build_branch }",
                                "RHSM_USER=${ var.rhsm_user }",
                                "RHSM_PASS=${ var.rhsm_pass }" ]
*/
    }

     post-processor "manifest" {
         output     = local.manifest_output
         strip_path = true
         strip_time = true
         custom_data = {
           build_username           = var.build_username
           vm_cpu_cores             = var.vm_cpu_cores
           vm_cpu_count             = var.vm_cpu_sockets
           vm_firmware              = var.vm_firmware
           vm_guest_os_type         = var.vm_guestos_type
           vm_mem_size              = var.vm_mem_size
           vm_network_card          = var.vm_nic_type
           vsphere_cluster          = var.vcenter_cluster
           vsphere_host             = var.vcenter_server
           vsphere_datacenter       = var.vcenter_datacenter
           vsphere_datastore        = var.vcenter_datastore
           vsphere_folder           = var.vcenter_folder
         }
       }

}

