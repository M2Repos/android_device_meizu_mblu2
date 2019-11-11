/*
 * Copyright (C) 2019 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <android-base/file.h>
#include <android-base/logging.h>
#include <android-base/strings.h>

#include "KeyDisabler.h"

namespace vendor {
namespace lineage {
namespace touch {
namespace V1_0 {
namespace implementation {

constexpr const char kBackControlPath[] = "/sys/devices/virtual/input/input1/enable";
constexpr const char kHomeControlPath[] = "/sys/bus/platform/drivers/mtk-kpd/enable_home_button";

KeyDisabler::KeyDisabler() {
    mHasKeyDisabler = !access(kBackControlPath, F_OK) && !access(kHomeControlPath, F_OK);
}

// Methods from ::vendor::lineage::touch::V1_0::IKeyDisabler follow.
Return<bool> KeyDisabler::isEnabled() {
    std::string backBuf, homeBuf;

    if (!mHasKeyDisabler) return false;

    if (!android::base::ReadFileToString(kBackControlPath, &backBuf)) {
        LOG(ERROR) << "Failed to read " << kBackControlPath;
        return false;
    }
    if (!android::base::ReadFileToString(kHomeControlPath, &homeBuf)) {
        LOG(ERROR) << "Failed to read " << kHomeControlPath;
        return false;
    }

    return std::stoi(android::base::Trim(backBuf)) == 0 || std::stoi(android::base::Trim(homeBuf)) == 0;
}

Return<bool> KeyDisabler::setEnabled(bool enabled) {
    std::string buf = enabled ? "0" : "1";

    if (!mHasKeyDisabler) return false;

    if (!android::base::WriteStringToFile(buf, kBackControlPath)) {
        LOG(ERROR) << "Failed to write " << kBackControlPath;
        return false;
    }
    if (!android::base::WriteStringToFile(buf, kHomeControlPath)) {
        LOG(ERROR) << "Failed to write " << kHomeControlPath;
        return false;
    }

    return true;
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace touch
}  // namespace lineage
}  // namespace vendor
