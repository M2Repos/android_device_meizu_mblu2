#!/sbin/sh

# only source it, we set our own OUT_FD
source /partition_manager/tools.sh

OUT_FD=/proc/$$/fd/$2

ui_print "[#] Starting Partition Manager..."

pauseTwrp

# unmount every internal partition
mount | grep /dev/block/mmcblk0p | while read -r line ; do
	thispart=`echo "$line" | awk '{ print $3 }'`
	umount -f $thispart
done
mount | grep /dev/block/platform/mtk-msdc.0 | while read -r line ; do
	thispart=`echo "$line" | awk '{ print $3 }'`
	umount -f $thispart
done

/partition_manager/aroma 1 $2 /partition_manager/partition_manager.zip >/tmp/partition_manager.log
if [ -f "/partition_manager/partition_manager.zip.log.txt" ]; then
	cp -f "/partition_manager/partition_manager.zip.log.txt" "/external_sd/partition_manager.log"
fi

if [ -f "/tmp/do_reboot_recovery" ]; then
	reboot recovery
fi

resumeTwrp
