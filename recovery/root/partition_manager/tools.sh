#!/sbin/sh

# Various tools for Tissot Manager by CosmicDan
# Parts from LazyFlasher boot image patcher script by jcadduono

source /partition_manager/constants.sh

ui_print() {
	if [ "$OUT_FD" ]; then
		if [ "$1" ]; then
			echo "ui_print $1" > "$OUT_FD"
		else
			echo "ui_print  " > "$OUT_FD"
		fi
	else
		echo "$1"
	fi
}

# set to a fraction (where 1.0 = 100%)
set_progress() {
	echo "set_progress $1" > "$OUT_FD"
}

# find the recovery text output pipe (it's always the last one found)
for l in /proc/self/fd/*; do 
	# set the last pipe: target
	if readlink $l | grep -Fqe 'pipe:'; then
		OUT_FD=$l
	fi
done

file_getprop() { grep "^$2" "$1" | cut -d= -f2; }

pauseTwrp() {
	for pid in `pidof recovery`; do 
		kill -SIGSTOP $pid
	done;
}

resumeTwrp() {
	for pid in `pidof recovery`; do 
		kill -SIGCONT $pid
	done;
}

unmountAllAndRefreshPartitions() {
	mount | grep /dev/block/mmcblk0p | while read -r line ; do
		thispart=`echo "$line" | awk '{ print $3 }'`
		umount -f $thispart
		sleep 0.5
	done
	mount | grep /dev/block/platform/mtk-msdc.0 | while read -r line ; do
		thispart=`echo "$line" | awk '{ print $3 }'`
		umount -f $thispart
		sleep 0.5
	done
	sleep 2
	blockdev --rereadpt /dev/block/mmcblk0
}
