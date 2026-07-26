#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
# sed -i 's/192.168.1.1/192.168.199.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# borrow some package from immortalwrt
# shallow clone without actually pull all the files
git clone --no-checkout --depth 1 https://github.com/immortalwrt/immortalwrt immortalwrt
cd immortalwrt
# sparse-checkout only certail packages
git sparse-checkout set "package/emortal/autocore" "package/emortal/cpufreq" \
"package/emortal/default-settings" "package/utils/mhz" \
"target/linux/generic/hack-6.12/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch" \
"target/linux/generic/hack-6.18/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch"
git checkout
# copy to package for further use
cp -R package/emortal/* ../package/
cp -R package/utils/mhz ../package/
cp "target/linux/generic/hack-6.12/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch" \
"../target/linux/generic/hack-6.12/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch"
cp "target/linux/generic/hack-6.18/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch" \
"../target/linux/generic/hack-6.18/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch"
cd ..

# use 3-party mosdns
rm -Rf feeds/packages/net/mosdns
git clone --depth 1 https://github.com/xlighting2017/luci-app-mosdns -b v5 package/mosdns

# add luci-app-athena-led
rm -Rf package/emortal/luci-app-athena-led
git clone --depth 1 https://github.com/xlighting2017/JDC-AX6600-Athena-LED-Controller -b main JDC-AX6600-Athena-LED-Controller
cp -R JDC-AX6600-Athena-LED-Controller/athena-led package/
cp -R JDC-AX6600-Athena-LED-Controller/luci-app-athena-led package/

# update feeds after introduce new package(s)
./scripts/feeds update -a
./scripts/feeds install -a
