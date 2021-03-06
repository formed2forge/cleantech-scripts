#!/bin/bash

### Launch a KVM instance on disk with detected windows partition.
### Idea is to have a WinPE ISO that will launch a batch script that will run chkdsk scan (among others)
### that will then save to the USBDATA volume under the current FAHT working directory.
### Pseudo code for now.
### Should be run elevated, and called by fahtdiag.

## launch_kvm $VAR (disk to set as SECOND HDD in vm)

KVM=$(kvm-ok|grep exists)

launch_kvm () {

	sudo kvm -m 2048 -drive if=ide,media=disk,format=raw,file=/usr/share/faht/lsusb.img -drive if=ide,media=disk,format=raw,file=${CHANGEME_DETECTED_WIN_DISK} -display gtk,zoom-to-fit=on

	#kvm -m 2048 -drive if=ide,media=disk,format=raw,file=${CHANGEME_DETECTED_WIN_DISK} -drive if=ide,media=cdrom,file=/usr/share/faht/WinPE_amd64.iso -boot order=dc
}

## launch_qmeu $VAR (disk to set as SECOND HDD)

launch_qemu () {

	sudo qemu-system-x86_64 -m 1024 -drive if=ide,media=disk,format=raw,file=/usr/share/faht/lsusb.img -drive if=ide,media=disk,format=raw,file=${CHANGEME_DETECTED_WIN_DISK} -display gtk,zoom-to-fit=on

}

run_windows_fs_checks () {
	if [ "$KVM" ]; then
		launch_kvm
	else
		launch_qemu
	fi
}