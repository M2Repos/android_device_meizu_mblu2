#!/sbin/sh

# Return values:
# 0 = Unrecognized partition table
# 1 = Stock partition table
# 2 = Treble partition table

source /partition_manager/constants.sh

# Initial status var's
system_status=invalid
vendor_status=invalid
userdata_status=invalid
cache_status=invalid

# Get system info
system_partline=`sgdisk --print /dev/block/mmcblk0 | grep -i system`
system_partnum_current=$(echo "$system_partline" | awk '{ print $1 }')
system_partstart_current=$(echo "$system_partline" | awk '{ print $2 }')
system_partend_current=$(echo "$system_partline" | awk '{ print $3 }')
system_partname=$(echo "$system_partline" | awk '{ print $7 }')
system_partsize=$(($system_partend_current - $system_partstart_current + 1))
if [ "$system_partnum_current" == "$system_partnum" ]; then
	if [ "$system_partname" == "system" ]; then
		if [ "$system_partsize" == "$system_treble_partsize" ]; then
			system_status=treble
		elif [ "$system_partsize" == "$system_stock_partsize" ]; then
			system_status=stock
		fi
	fi
fi

# Get vendor info
vendor_partline=`sgdisk --print /dev/block/mmcblk0 | grep -iE '(vendor|custom)'`
vendor_partnum_current=$(echo "$vendor_partline" | awk '{ print $1 }')
vendor_partname=$(echo "$vendor_partline" | awk '{ print $7 }')
if [ "$vendor_partnum_current" == "$vendor_partnum" ]; then
	if [ "$vendor_partname" == "vendor" ]; then
		vendor_status=treble
	elif [ "$vendor_partname" == "custom" ]; then
		vendor_status=stock
	fi
fi

# Get userdata info
userdata_partline=`sgdisk --print /dev/block/mmcblk0 | grep -i userdata`
userdata_partnum_current=$(echo "$userdata_partline" | awk '{ print $1 }')
userdata_partstart_current=$(echo "$userdata_partline" | awk '{ print $2 }')
userdata_partend_current=$(echo "$userdata_partline" | awk '{ print $3 }')
userdata_partname=$(echo "$userdata_partline" | awk '{ print $7 }')
userdata_partsize=$(($userdata_partend_current - $userdata_partstart_current + 1))
if [ "$userdata_partnum_current" == "$userdata_partnum" ]; then
	if [ "$userdata_partname" == "userdata" ]; then
		if [ "$userdata_partsize" == "$userdata_treble_partsize" ]; then
			userdata_status=treble
		elif [ "$userdata_partsize" == "$userdata_stock_partsize" ]; then
			userdata_status=stock
		fi
	fi
fi

# Get cache info
cache_partline=`sgdisk --print /dev/block/mmcblk0 | grep -i cache`
cache_partnum_current=$(echo "$cache_partline" | awk '{ print $1 }')
cache_partstart_current=$(echo "$cache_partline" | awk '{ print $2 }')
cache_partend_current=$(echo "$cache_partline" | awk '{ print $3 }')
cache_partname=$(echo "$cache_partline" | awk '{ print $7 }')
cache_partsize=$(($cache_partend_current - $cache_partstart_current + 1))
if [ "$cache_partnum_current" == "$cache_partnum" ]; then
	if [ "$cache_partname" == "cache" ]; then
		if [ "$cache_partsize" == "$cache_treble_partsize" ]; then
			cache_status=treble
		elif [ "$cache_partsize" == "$cache_stock_partsize" ]; then
			cache_status=stock
		fi
	fi
fi

echo "System status: $system_status" > /tmp/detected_partition_table.log
echo "Vendor status: $vendor_status" >> /tmp/detected_partition_table.log
echo "Userdata status: $userdata_status" >> /tmp/detected_partition_table.log
echo "Cache status: $cache_status" >> /tmp/detected_partition_table.log


# if any status is invalid, return 0
if [ "$system_status" == "invalid" -o "$vendor_status" == "invalid" -o "$userdata_status" == "invalid" -a "$cache_status" == "invalid" ]; then
	exit 0
fi

# check if we have a stock partition map
if [ "$system_status" == "stock" -a "$vendor_status" == "stock" -a "$userdata_status" == "stock" -a "$cache_status" == "stock" ]; then
	exit 1
fi

# check if we have a treble partition map
if [ "$system_status" == "treble" -a "$vendor_status" == "treble" -a "$userdata_status" == "treble" -a "$cache_status" == "treble" ]; then
	exit 2
fi

# nothing else matched, so return 0
exit 0
