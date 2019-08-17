#!/bin/bash
DEVICE_RECOVERY_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET_RECOVERY_ROOT_OUT=$1

sed -i 's/service recovery \/sbin\/recovery/service recovery \/sbin\/recovery\.sh/' "$TARGET_RECOVERY_ROOT_OUT/init.recovery.service.rc"
sed -i 's/ro\.build\.date\.utc=.*/ro\.build\.date\.utc=0/' "$TARGET_RECOVERY_ROOT_OUT/prop.default"
rm "$TARGET_RECOVERY_ROOT_OUT/partition_manager/partition_manager.zip" > /dev/null 2>&1
cd "$DEVICE_RECOVERY_PATH/partition_manager_resources"
zip -rq -1 "$TARGET_RECOVERY_ROOT_OUT/partition_manager/partition_manager.zip" *
cd "$DEVICE_RECOVERY_PATH"
