time sudo pacman -Syu
python --version
time repo init -u https://github.com/PixelExperience/manifest -b thirteen-plus --depth=1 --git-lfs -g default,-mips,-darwin,-notdefault
echo "repo init"
time repo sync -j32 -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync || repo sync -j4 -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync
git lfs install
repo forall -c 'git lfs pull'
echo "sync complete"
rm -rf hardware/qcom-caf/msm8998/media
rm -rf hardware/qcom-caf/msm8998/audio
rm -rf hardware/qcom-caf/msm8998/display
rm -rf prebuilts/clang/host/linux-x86/clang-r450784d
rm -rf system/extras/su
git clone https://gitlab.com/ImSurajxD/clang-r450784d prebuilts/clang/host/linux-x86/clang-r450784d --depth=1
git clone https://github.com/NopeNopeGuy/device_xiaomi_whyred-1 device/xiaomi/whyred --depth=1 -b pe-13
git clone https://github.com/NopeNopeGuy/vendor_xiaomi_whyred-1/ vendor/xiaomi/whyred --depth=1
git clone https://github.com/NopeNopeGuy/android_kernel_xiaomi_whyred kernel/xiaomi/whyred -b KCUF_419 --depth=1 --recurse-submodules
git clone https://github.com/shekhawat2/android_hardware_qcom_media hardware/qcom-caf/msm8998/media --depth=1
git clone https://github.com/shekhawat2/android_hardware_qcom_audio hardware/qcom-caf/msm8998/audio --depth=1
git clone https://github.com/shekhawat2/android_hardware_qcom_display hardware/qcom-caf/msm8998/display --depth=1
export CCACHE_DIR=/tmp/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
export CCACHE_COMPRESSLEVEL=5
ccache -M 30G
ccache -o compression=true 
ccache -z
export ALLOW_MISSING_DEPENDENCIES=true
timeout 100m bash -c "source build/envsetup.sh && lunch aosp_whyred-userdebug && mka bacon -j10" || exit 0
