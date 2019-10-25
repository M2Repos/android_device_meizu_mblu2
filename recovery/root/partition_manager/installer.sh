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
system_start=$(($(sgdisk --print /dev/block/mmcblk0 | grep "\ $((system_partnum - 1))\ " | awk '{ print $3 }') + 1))
free_space=$(sgdisk /dev/block/mmcblk0 --print | grep 'free space is' | awk '{ print $5 }')
if [ "$choice" == "stock" ] || [ "$choice" == "treble20" ] || \
   [ "$choice" == "treble25" ] || [ "$choice" == "treble30" ] || \
   [ "$choice" == "treble35" ] || [ "$choice" == "treble40" ]; then
	if [ "$choice" == "stock" ]; then
		system_end=$((system_start + system_stock_partsize - 1))
	elif [ "$choice" == "treble20" ]; then
		system_end=$((system_start + system_treble20_partsize - 1))
	elif [ "$choice" == "treble25" ]; then
		system_end=$((system_start + system_treble25_partsize - 1))
	elif [ "$choice" == "treble30" ]; then
		system_end=$((system_start + system_treble30_partsize - 1))
	elif [ "$choice" == "treble35" ]; then
		system_end=$((system_start + system_treble35_partsize - 1))
	elif [ "$choice" == "treble40" ]; then
		system_end=$((system_start + system_treble40_partsize - 1))
	fi
	ui_print " "
	ui_print "[i] Starting repartition..."
	ui_print " "
	ui_print "[#] Deleting old partitions..."
	sgdisk /dev/block/mmcblk0 --delete $system_partnum
	sgdisk /dev/block/mmcblk0 --delete $cache_partnum
	sgdisk /dev/block/mmcblk0 --delete $userdata_partnum
	ui_print "[#] Creating system..."
	sgdisk /dev/block/mmcblk0 --new=$system_partnum:$system_start:$system_end
	sgdisk /dev/block/mmcblk0 --change-name=$system_partnum:system
	sgdisk /dev/block/mmcblk0 --typecode $system_partnum:0700
	ui_print "[#] Creating cache..."
	if [ "$choice" == "stock" ]; then
		cache_end=$((system_end + cache_stock_partsize))
	else
		cache_end=$((system_end + cache_treble_partsize))
	fi
	sgdisk /dev/block/mmcblk0 --new=$cache_partnum:$((system_end + 1)):$cache_end
	sgdisk /dev/block/mmcblk0 --change-name=$cache_partnum:cache
	sgdisk /dev/block/mmcblk0 --typecode $cache_partnum:0700
	ui_print "[#] Creating userdata..."
	userdata_end="$((cache_end + \
		$(sgdisk /dev/block/mmcblk0 --print | grep 'free space is' | awk '{ print $5 }') - free_space))"
	userdata_size=$((userdata_end - cache_end + 2))
	sgdisk /dev/block/mmcblk0 --new=$userdata_partnum:$((cache_end + 1)):$userdata_end
	sgdisk /dev/block/mmcblk0 --change-name=$userdata_partnum:userdata
	sgdisk /dev/block/mmcblk0 --typecode $userdata_partnum:0700
	if [ "$choice" == "stock" ]; then
		ui_print "[#] Renaming vendor to custom..."
		sgdisk /dev/block/mmcblk0 --change-name=$vendor_partnum:custom
	else
		ui_print "[#] Renaming custom to vendor..."
		sgdisk /dev/block/mmcblk0 --change-name=$vendor_partnum:vendor
	fi
	ui_print "[#] Setting userdata size in metadata"
	printf "%.8x" $userdata_size | rev | \
		awk -vFS= '{ORS=""} {print"0: "} {for (i = 1; i <= NF; i+=2) {printf $(i+1)$i}}' | xxd -r > /tmp/meta.bin
	busybox dd if=/tmp/meta.bin of=/dev/block/by-name/metadata seek=24 bs=1 conv=notrunc
	rm /tmp/meta.bin
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
	if [ "$choice" == "stock" ]; then
		ui_print "[i] You are now ready to install a non-Treble ROM's."
	else
		ui_print "[i] You are now ready to install a Treble ROM's."
	fi
fi

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
ui_print "<#009>Be sure to select 'Save Logs' in case you need to report a bug.</#>"
ui_print "<#009>Will be saved to microSD root as 'partition_manager.log'.</#>";
set_progress "1.0"
