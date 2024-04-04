# ----------------------------------------------------------------------------
# Name:         definitions.pkr.hcl
# Description:  Variable definitions for vSphere Packer builds
# Author:       Michael Poore (@mpoore)
# URL:          https://github.com/v12n-io/packer
# ----------------------------------------------------------------------------

# -------------------------------------------------------------------------- #
#                           Variable Definitions                             #
# -------------------------------------------------------------------------- #
# Sensitive Variables
variable "vcenter_username" {
    type        = string
    description = "Username used by Packer to connect to vCenter"
    sensitive   = true
}
variable "vcenter_password" {
    type        = string
    description = "Password used by Packer to connect to vCenter"
    sensitive   = true
}
variable "build_username" {
    type        = string
    description = "Non-administrative username for this OS"
    sensitive   = true
}
variable "build_password" {
    type        = string
    description = "Password for the non-administrative user"
    sensitive   = true
}
variable "vcenter_resource_pool" {
    type        = string
    description = "Vcenter Resource Pool"
    sensitive   = true
}

#Network Configuration of the image
variable "vm_ip_address" {
    type        = string
    description = "Specify static IP Address that will be used"
}

variable "vm_ip_netmask" {
    type        = string
    description = "Specify subnet masking to be used e.g. 255.255.255.0"
    default     = "255.255.255.0"
}

variable "vm_ip_gateway" {
    type        = string
    description = "Specify gateway address to be used"
}

variable "vm_nameserver" {
    type        = string
    description = "Specify dns nameserver to be used"
}

# vCenter Configuration
variable "vcenter_server" {
    type        = string
    description = "FQDN for the vCenter Server Packer will create this build in"
}
variable "vcenter_datacenter" {
    type        = string
    description = "Datacenter name in vCenter where the build will be created"
}
variable "vcenter_cluster" {
    type        = string
    description = "Cluster name in vCenter where the build will be created"
}
variable "vcenter_folder" {
    type        = string
    description = "Folder path in vCenter where the build will be created"
}
variable "vcenter_datastore" {
    type        = string
    description = "vSphere datastore where the build will be created"
}

# vCenter and ISO Configuration
variable "os_iso_datastore" {
    type        = string
    description = "vSphere datastore name where source OS media reside"
}
variable "os_iso_path" {
    type        = string
    description = "Datastore path to the OS media"
}
variable "os_iso_file" {
    type        = string
    description = "OS media file"
}

#
variable "vcenter_content_library" {
    type        = string
    description = "Name of the vSphere Content Library to export the VM to"
    default     = null
}

# Provisioner Settings
variable "script_files" {
    type        = list(string)
    description = "List of OS scripts to execute"
    default     = []
}