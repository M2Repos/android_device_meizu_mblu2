#!/sbin/sh
# Based on Tissot Manager install script by CosmicDan
# Parts based on AnyKernel2 Backend by osm0sis
# This script is called by Aroma installer via update-binary-installer

# INTERNAL FUNCTIONS

OUTFD=/proc/self/fd/$2;
ZIP="$3";
DIR=`dirname "$ZIP"`;

ui_print() {
	until [ ! "$1" ]; do
		echo -e "ui_print $1\nui_print" > $OUTFD;
		shift;
	done;
}

set_progress() { echo "set_progress $1" > $OUTFD; }
getprop() { test -e /sbin/getprop && /sbin/getprop $1 || file_getprop /default.prop $1; }
abort() { ui_print "$*"; umount /system; umount /data; exit 1; }

source /partition_manager/constants.sh
source /partition_manager/tools.sh

# Repartition
ui_print " ";
ui_print "[#] Unmounting all eMMC partitions..."
unmountAllAndRefreshPartitions

partition_status=`cat /tmp/partition_status`
if [ ! $partition_status -ge 0 ]; then
	ui_print "[!] Error - partition status unknown! Was /tmp wiped? RAM full? Aborting..."
	exit 1
fi

choice=`file_getprop /tmp/aroma/choice_repartition.prop root`
if [ "$choice" == "stock" ]; then
	ui_print " "
	ui_print "[i] Starting repartition back to stock..."
	ui_print " "
	ui_print "[#] Deleting old partitions..."
	sgdisk /dev/block/mmcblk0 --delete $system_partnum
	sgdisk /dev/block/mmcblk0 --delete $cache_partnum
	sgdisk /dev/block/mmcblk0 --delete $userdata_partnum
	ui_print "[#] Creating system..."
	sgdisk /dev/block/mmcblk0 --new=$system_partnum:1474560:4620287
	sgdisk /dev/block/mmcblk0 --change-name=$system_partnum:system
	sgdisk /dev/block/mmcblk0 --typecode $system_partnum:0700
	ui_print "[#] Creating cache..."
	sgdisk /dev/block/mmcblk0 --new=$cache_partnum:4620288:5439487
	sgdisk /dev/block/mmcblk0 --change-name=$cache_partnum:cache
	sgdisk /dev/block/mmcblk0 --typecode $cache_partnum:0700
	ui_print "[#] Creating userdata..."
	sgdisk /dev/block/mmcblk0 --new=$userdata_partnum:5439488:30501887
	sgdisk /dev/block/mmcblk0 --change-name=$userdata_partnum:userdata
	sgdisk /dev/block/mmcblk0 --typecode $userdata_partnum:0700
	ui_print "[#] Renaming vendor to custom..."
	sgdisk /dev/block/mmcblk0 --change-name=$vendor_partnum:custom
	ui_print "[#] Setting userdata size in metadata"
	busybox dd if=/partition_manager/stock_meta.bin of=/dev/block/platform/mtk-msdc.0/11230000.msdc0/by-name/metadata seek=24 bs=1 conv=notrunc
	sleep 1
	blockdev --rereadpt /dev/block/mmcblk0
	sleep 1
	ui_print "[#] Formatting partitions..."
	mke2fs -qF -t ext4 /dev/block/mmcblk0p$system_partnum
	mke2fs -qF -t ext4 /dev/block/mmcblk0p$cache_partnum
	mke2fs -qF -t ext4 /dev/block/mmcblk0p$userdata_partnum
	mke2fs -qF -t ext4 /dev/block/mmcblk0p$vendor_partnum
	ui_print " "
	ui_print "[i] All done!"
	ui_print " "
	ui_print "[i] You are now ready to install a non-Treble ROM."
elif [ "$choice" == "treble" ]; then
	ui_print " "
	ui_print "[i] Starting Treble repartition..."
	ui_print " "
	ui_print "[#] Deleting old partitions..."
	sgdisk /dev/block/mmcblk0 --delete $system_partnum
	sgdisk /dev/block/mmcblk0 --delete $cache_partnum
	sgdisk /dev/block/mmcblk0 --delete $userdata_partnum
	ui_print "[#] Creating system..."
	sgdisk /dev/block/mmcblk0 --new=$system_partnum:1474560:6717439
	sgdisk /dev/block/mmcblk0 --change-name=$system_partnum:system
	sgdisk /dev/block/mmcblk0 --typecode $system_partnum:0700
	ui_print "[#] Creating cache..."
	sgdisk /dev/block/mmcblk0 --new=$cache_partnum:6717440:6922239
	sgdisk /dev/block/mmcblk0 --change-name=$cache_partnum:cache
	sgdisk /dev/block/mmcblk0 --typecode $cache_partnum:0700
	ui_print "[#] Creating userdata..."
	sgdisk /dev/block/mmcblk0 --new=$userdata_partnum:6922240:30501887
	sgdisk /dev/block/mmcblk0 --change-name=$userdata_partnum:userdata
	sgdisk /dev/block/mmcblk0 --typecode $userdata_partnum:0700
	ui_print "[#] Renaming custom to vendor..."
	sgdisk /dev/block/mmcblk0 --change-name=$vendor_partnum:vendor
	ui_print "[#] Setting userdata size in metadata"
	busybox dd if=/partition_manager/treble_meta.bin of=/dev/block/platform/mtk-msdc.0/11230000.msdc0/by-name/metadata seek=24 bs=1 conv=notrunc
	sleep 1
	blockdev --rereadpt /dev/block/mmcblk0
	sleep 1
	ui_print "[#] Formatting partitions..."
	mke2fs -qF -t ext4 /dev/block/mmcblk0p$system_partnum
	mke2fs -qF -t ext4 /dev/block/mmcblk0p$cache_partnum
	mke2fs -qF -t ext4 /dev/block/mmcblk0p$userdata_partnum
	mke2fs -qF -t ext4 /dev/block/mmcblk0p$vendor_partnum
	ui_print " "
	ui_print "[i] All done!"
	ui_print " "
	ui_print "[i] You are now ready to install a Treble ROM."
fi;

blockdev --rereadpt /dev/block/mmcblk0
sleep 0.2
sync /dev/block/mmcblk0
sleep 0.2

ui_print " ";
ui_print " ";
while read line || [ -n "$line" ]; do
	ui_print "$line"
done < /tmp/aroma/credits.txt
ui_print " ";
ui_print "<#009>Be sure to select 'Save Logs' in case you need to report a bug. Will be saved to microSD root as 'partition_manager.log'.</#>";
set_progress "1.0"
