### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=<---: Butterfly-Kernel for Galaxy M51 :--->
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=m51
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

device=$(file_getprop /system/build.prop ro.product.system.device);
android=$(file_getprop /system/build.prop ro.build.version.sdk);

patch_cmdline "android.is_aosp" "";

if grep -qi "oneui" /system/build.prop; then
   ui_print ""
   ui_print "OneUI ROM detected!"
   patch_cmdline "android.is_aosp" "android.is_aosp=0";
elif [ $device == "generic" ]; then
   ui_print "GSI ROM detected!"
   patch_cmdline "android.is_aosp" "android.is_aosp=0";
else
   ui_print "AOSP ROM detected!"
   patch_cmdline "android.is_aosp" "android.is_aosp=1";
fi

write_boot;
## end boot install