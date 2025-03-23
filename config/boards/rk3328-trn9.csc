# Rockchip RK3328 quad core 2GB GBE eMMC USB3 WiFi
BOARD_NAME="MVR9"
BOARDFAMILY="rockchip64"
BOOT_SOC="rk3328"
BOARD_MAINTAINER=""
#BOOTCONFIG="roc-cc-rk3328_defconfig"
#BOOTCONFIG="evb-rk3328_defconfig"
BOOTCONFIG="trn9-rk3328_defconfig"
KERNEL_TARGET="current,edge"
KERNEL_TEST_TARGET="current"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/rk3328-box-trn9.dtb"

# Mainline U-Boot
function post_family_config__station_m1_use_mainline_uboot() {
	display_alert "$BOARD" "Using mainline U-Boot for $BOARD / $BRANCH" "info"

	declare -g BOOTSOURCE="https://github.com/u-boot/u-boot.git"
	declare -g BOOTBRANCH="tag:v2022.07"
	declare -g BOOTPATCHDIR="u-boot-rockchip64/board_rk3328-box-trn9"
	# Don't set BOOTDIR, allow shared U-Boot source directory for disk space efficiency

	declare -g UBOOT_TARGET_MAP="BL31=${RKBIN_DIR}/${BL31_BLOB} ROCKCHIP_TPL=${RKBIN_DIR}/${DDR_BLOB};;u-boot-rockchip.bin"

	# Disable stuff from rockchip64_common; we're using binman here which does all the work already
	unset uboot_custom_postprocess write_uboot_platform write_uboot_platform_mtd

	# Just use the binman-provided u-boot-rockchip.bin, which is ready-to-go
	function write_uboot_platform() {
		dd "if=$1/u-boot-rockchip.bin" "of=$2" bs=32k seek=1 conv=notrunc status=none
	}
}
