#!/sbin/sh

### Recovery service bootstrap for better Treble support
# Purpose:
#  - Prevent recovery from being restarted when it's killed (equivalent to a one-shot service)
#  - symlink to the correct fstab depending on partitions state
#

source /partition_manager/constants.sh
source /partition_manager/tools.sh

chmod -R 777 /partition_manager/*

# check mount situation and use appropriate fstab
rm /etc/recovery.fstab
if [ -b "$vendor_blockdev" ]; then
	ln -sn /etc/twrp.treble /etc/recovery.fstab
else
	ln -sn /etc/twrp.stock /etc/recovery.fstab
fi;

# start recovery
/sbin/recovery &

# idle around
while kill -0 `pidof recovery`; do sleep 1; done

# stop self
stop recovery
