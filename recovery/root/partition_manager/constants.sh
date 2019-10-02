#!/sbin/sh

# system partition info
system_partnum=21
system_treble20_partsize=4194304
system_treble25_partsize=5242880
system_treble30_partsize=6291456
system_treble35_partsize=7340032
system_treble40_partsize=8388608
system_stock_partsize=3145728
 
# vendor partition info
vendor_partnum=17
vendor_blockdev=/dev/block/by-name/vendor

# cache partition info
cache_partnum=22
cache_treble_partsize=204800
cache_stock_partsize=819200

# userdata partition info
userdata_partnum=23
