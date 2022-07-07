#!/bin/bash

#
# _Archlinux
#

set -oue pipefail

#
#
#

___comment___() { 
    echo > /dev/null 
}

___help___() {
    local -r _name="${1:?}"
    local -r _version="${2:?}"
    local -r _namespace="${3:?}"
    echo
    echo "${_name}.sh v${_version}"
    echo
    echo "Usage:"
    echo
    echo " ${_name} COMMAND [ARGUMENTS]"
    echo 
    echo "Commands:"
    echo
    local -r _classMethodPairs=$(declare -F | grep "${_namespace}" | grep -v '__' | sed "s/.*${_namespace}_//")
    local _classMethodPair
    (
        for _classMethodPair in ${_classMethodPairs}
        do
            local _class=$(echo ${_classMethodPair} | sed 's/_.*//')
            local _method=$(echo ${_classMethodPair} | sed 's/.*_//')
            local _comment=$(declare -f _${_namespace}_${_class}_${_method} | grep '___comment___' | head -n1 | sed 's/.*"\(.*\)".*/\1/')
            echo " ${_class} ${_method}: ${_comment}"
        done
    ) | sort
    echo " help: Print this help text."
    echo
    exit 0
}

___main___() {
    local -r _name="${1:?}"
    shift
    local -r _version="${1:?}"
    shift
    local -r _namespace="${1:?}"
    shift
    [[ "${1:-help}" == "help" ]] && ___help___ ${_name} ${_version} ${_namespace}
    local -r _class="${1:?}"
    shift
    local -r _method="${2:?}"
    shift
    eval "_${_namespace}_${_class}_${_method} ${@:-}"
}

#
# _Archlinux_InstallationGuide
#
# See https://wiki.archlinux.org/title/installation_guide
#

_Archlinux_InstallationGuide_USER="iamlynnmckay"
_Archlinux_InstallationGuide_LOCALE="en_US.UTF-8 UTF-8"
_Archlinux_InstallationGuide_LANG="en_US.UTF-8"
_Archlinux_InstallationGuide_TIMEZONE="America/Los_Angeles"

_Archlinux_InstallationGuide_verifyTheBootMode() {
    ___comment___ "() -> verifyTheBootMode -> connectToTheInternet"
    echo "Installation guide: Verify the boot mode..."
    ls /sys/firmware/efi/efivars || \
    echo "Error: The system is NOT booted in UEFI mode."
}

_Archlinux_InstallationGuide_connectToTheInternet() {
    ___comment___ "verifyTheBootMode -> connectToTheInternet -> updateTheSystemClock"
    echo "Installation guide: Connect to the internet..."
    ip link
    ping -c 3 archlinux.org
}

_Archlinux_InstallationGuide_updateTheSystemClock() {
    ___comment___ "connectToTheInternet -> updateTheSystemClock -> partitionTheDisks"
    echo "Installation guide: Update the system clock..."
    timedatectl set-ntp true
}

_Archlinux_InstallationGuide_partitionTheDisks() {
    ___comment___ "updateTheSystemClock -> partitionTheDisks -> formatThePartitions"
    echo "Installation guide: Partition the disks..."
    # @TODO
}

_Archlinux_InstallationGuide_formatThePartitions() {
    ___comment___ "partitionTheDisks -> formatThePartitions -> mountTheFileSystems"
    echo "Installation guide: Format the partitions..."
    # @TODO
}

_Archlinux_InstallationGuide_mountTheFileSystems() {
    ___comment___ "formatThePartitions -> mountTheFileSystems -> installEssentialPackages"
    echo "Installation guide: Mount the file systems..."
    # @TODO
}

_Archlinux_InstallationGuide_installEssentialPackages() {
    ___comment___ "mountTheFileSystems -> installEssentialPackages -> fstab"
    echo "Installation guide: Install essential packages..."
    pacstrap /mnt base linux linux-firmware
}

_Archlinux_InstallationGuide_fstab() {
    ___comment___ "installEssentialPackages -> fstab -> chroot"
    echo "Installation guide: Fstab..."
    genfstab -U /mnt >> /mnt/etc/fstab
    vim "/mnt/etc/fstab"
}

_Archlinux_InstallationGuide_chroot() {
    ___comment___ "fstab -> chroot -> timeZone"
    echo "Installation guide: Chroot..."
    arch-chroot /mnt
}

_Archlinux_InstallationGuide_timeZone() {
    ___comment___ "chroot -> timeZone -> localization"
    echo "Installation guide: Time zone..."
    ln -sf "/usr/share/zoneinfo/${_Archlinux_InstallationGuide_TIMEZONE}" /etc/localtime
    hwclock --systohc
}

_Archlinux_InstallationGuide_localization() {
    ___comment___ "timeZone -> localization -> networkConfiguration"
    echo "Installation guide: Localization..."
    sed -i "s/#${_Archlinux_InstallationGuide_LOCALE}/${_Archlinux_InstallationGuide_LOCALE}/" /etc/locale.gen
    locale-gen
    echo "${_Archlinux_InstallationGuide_LANG}" > /etc/locale.conf
}

_Archlinux_InstallationGuide_networkConfiguration() {
    ___comment___ "localization -> networkConfiguration -> initramfs"
    echo "Installation guide: Network configuration..."
    # @TODO
}

_Archlinux_InstallationGuide_initramfs() {
    ___comment___ "networkConfiguration -> initramfs -> rootPassword"
    echo "Installation guide: Initramfs..."
    # @TODO 
}

_Archlinux_InstallationGuide_rootPassword() {
    ___comment___ "initramfs -> rootPassword -> bootLoader"
    echo "Installation guide: Root password..."
    passwd
}

_Archlinux_InstallationGuide_bootLoader() {
    ___comment___ "rootPassword -> bootLoader -> reboot"
    echo "Installation guide: Boot loader..."
    # @TODO
}

_Archlinux_InstallationGuide_reboot() {
    ___comment___ "bootLoader -> reboot -> ()"
    echo "Installation guide: Reboot..."
    exit
    reboot
}

#
#
#

archlinux() {
    ___main___ "archlinux" "0.0.1" "Archlinux" ${@:-}
}

archlinux ${@:-}
