# OrangeFox Recovery — beryl (fox_14.1 / bp2a)

Device: POCO M7 Pro 5G / Redmi Note 14 5G (beryl)
SoC: MT6855
Target: OrangeFox fox_14.1
Lunch: twrp_beryl-bp2a-eng

## Build

```bash
cd ~/fox_14.1
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL=C
export FOX_BUILD_DEVICE=beryl

lunch twrp_beryl-bp2a-eng
mka adbd vendorbootimage -j$(nproc)
```

Output: `out/target/product/beryl/vendor_boot.img`

## Requirements
- git lfs pull (kernel/dtb/dtbo are LFS objects)
- prebuilt/decryption/ must remain for FBE
