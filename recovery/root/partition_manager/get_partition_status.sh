#!/sbin/sh

# Return values:
# 0 = Unrecognized partition table
# 1 = Stock partition table
# 2 = Treble partition table

source /partition_manager/constants.sh

# Initial status var's
assumptions_status=invalid
cache_status=invalid
system_status=invalid
vendor_status=invalid

# Assumptions
cache_current_partnum=`sgdisk /dev/block/mmcblk0 --print | \
					   grep -i cache | awk '{ print $1 }'`
system_current_partnum=`sgdisk /dev/block/mmcblk0 --print | \
						grep -i system | awk '{ print $1 }'`
userdata_current_partnum=`sgdisk /dev/block/mmcblk0 --print | \
						  grep -i userdata | awk '{ print $1 }'`
vendor_current_partnum=`sgdisk /dev/block/mmcblk0 --print | \
						grep -iE '(vendor|custom)' | awk '{ print $1 }'`
if [ "$cache_current_partnum" == "$cache_partnum" ] && \
   [ "$system_current_partnum" == "$system_partnum" ] && \
   [ "$userdata_current_partnum" == "$userdata_partnum" ] && \
   [ "$vendor_current_partnum" == "$vendor_partnum" ]; then
	assumptions_status=correct
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

# Get system info
system_partline=`sgdisk --print /dev/block/mmcblk0 | grep -i system`
system_partnum_current=$(echo "$system_partline" | awk '{ print $1 }')
system_partstart_current=$(echo "$system_partline" | awk '{ print $2 }')
system_partend_current=$(echo "$system_partline" | awk '{ print $3 }')
system_partname=$(echo "$system_partline" | awk '{ print $7 }')
system_partsize=$(($system_partend_current - $system_partstart_current + 1))
if [ "$system_partnum_current" == "$system_partnum" ]; then
	if [ "$system_partname" == "system" ]; then
		if [ "$system_partsize" == "$system_treble20_partsize" ]; then
			system_status=treble20
		elif [ "$system_partsize" == "$system_treble25_partsize" ]; then
			system_status=treble25
		elif [ "$system_partsize" == "$system_treble30_partsize" ]; then
			system_status=treble30
		elif [ "$system_partsize" == "$system_treble35_partsize" ]; then
			system_status=treble35
		elif [ "$system_partsize" == "$system_treble40_partsize" ]; then
			system_status=treble40
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

echo "Assumptions: $assumptions_status" > /tmp/detected_partition_table.log
echo "System status: $system_status" >> /tmp/detected_partition_table.log
echo "Cache status: $cache_status" >> /tmp/detected_partition_table.log
echo "Vendor status: $vendor_status" >> /tmp/detected_partition_table.log


# if any status is invalid, return 0
if [ "$assumptions_status" == "invalid" -o \
	 "$system_status" == "invalid" -o \
	 "$cache_status" == "invalid" -o \
	 "$vendor_status" == "invalid" ]; then
	exit 0
fi

# check if we have a stock partition map
if [ "$assumptions_status" == "correct" -a \
	 "$system_status" == "stock" -a \
	 "$cache_status" == "stock" -a \
	 "$vendor_status" == "stock" ]; then
	exit 1
fi

# check if we have a treble partition map
if [ "$assumptions_status" == "correct" -a \
	 "$cache_status" == "treble" -a \
	 "$vendor_status" == "treble" ]; then
	if [ "$system_status" == "treble20" ]; then
		exit 2
	elif [ "$system_status" == "treble25" ]; then
		exit 3
	elif [ "$system_status" == "treble30" ]; then
		exit 4
	elif [ "$system_status" == "treble35" ]; then
		exit 5
	elif [ "$system_status" == "treble40" ]; then
		exit 6
	fi
fi

# nothing else matched, so return 0
exit 0
