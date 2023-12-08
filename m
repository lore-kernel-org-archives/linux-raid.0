Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6356Bs2"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F67A10DF
	for <linux-raid@vger.kernel.org>; Fri,  8 Dec 2023 15:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702077218; x=1733613218;
  h=date:from:to:cc:subject:message-id;
  bh=ntRZhhTvPqaFIm9msXjTAtqkiuG/vcRcSDxa5RqkT/k=;
  b=W6356Bs2/gehf3vNP0R11Ayy1qF8gUwIpsOzbU1JRTadbgJIFmpDRKxp
   B1Kdnc/nHtM22cfpaRN4Jc03r1jWvd6e1S4Tpiup2EmzXlAUJlP/YQAKt
   56BNayYDXuk/Q8Po09thsfGGZiHYPxvCcZTlL9rVWkYqJYYucIknSOqUU
   1/02LsD1KgdlvG3+lyFJFMT0U0HXv/P3JchAqSlTwEQ60Pg5C5Sh1qHyS
   hwCWZvscSnxEaenNR6bCiJ+OsHxTKJT3HtEDAGiWCSFUVc5oz6OZaL2Hh
   Y4oNy01cihN5Zrv91OTtgepPdkystqCmqotitnLn19wb1EY86fnazueqY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="480672390"
X-IronPort-AV: E=Sophos;i="6.04,262,1695711600"; 
   d="scan'208";a="480672390"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 15:13:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="765643615"
X-IronPort-AV: E=Sophos;i="6.04,262,1695711600"; 
   d="scan'208";a="765643615"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 08 Dec 2023 15:13:36 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rBk2I-000EWi-0L;
	Fri, 08 Dec 2023 23:13:34 +0000
Date: Sat, 09 Dec 2023 07:13:17 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 b39113349de60e9b0bc97c2e129181b193c45054
Message-ID: <202312090714.3gfjerRK-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: b39113349de60e9b0bc97c2e129181b193c45054  md: split MD_RECOVERY_NEEDED out of mddev_resume

Warning ids grouped by kconfigs:

gcc_recent_errors
|-- arc-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arc-defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm-randconfig-001-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm-randconfig-002-20231209
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-algif_hash.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-curve25519-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-w1.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-core-pwrseq_emmc.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-core-pwrseq_simple.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-chips-cfi_util.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-maps-map_funcs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-perf-arm-ccn.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-regulator-rt4831-regulator.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-spmi-hisi-spmi-controller.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-mac-gaelic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp1250.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-caif-chnl_net.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-vmw_vsock-vsock_diag.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm-randconfig-003-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm-randconfig-004-20231209
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-slimbus.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-spmi.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-w1.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-hw_random-omap-rng.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-core-mmc_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-core-pwrseq_simple.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-host-renesas_sdhi_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-host-tmio_mmc_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pci-controller-pcie-mediatek.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pci-pci-stub.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pmdomain-amlogic-meson-ee-pwrc.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-spmi-hisi-spmi-controller.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-spmi-spmi-pmic-arb.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-adfs-adfs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp1250.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp737.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp950.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-qnx6-qnx6.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-sysv-sysv.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-locking-test-ww_mutex.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-scftorture.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm64-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm64-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-curve25519-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-slimbus.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-hte-hte-tegra194-test.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme-core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-perf-arm-ccn.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-soc-qcom-spm.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm64-randconfig-001-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm64-randconfig-002-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm64-randconfig-003-20231209
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-curve25519-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-slimbus.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-hw_random-omap-rng.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-hw_random-omap3-rom-rng.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-gpu-drm-tiny-cirrus.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-phy-broadcom-phy-bcm-ns-usb2.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_DAC1064.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_Ti3026.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_accel.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-fat-fat.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp737.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_ucs2_utils.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- arm64-randconfig-004-20231209
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-curve25519-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-hw_random-omap-rng.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-gpu-drm-tiny-cirrus.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-core-mmc_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pci-pci-stub.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-regulator-rt4831-regulator.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-spmi-hisi-spmi-controller.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-tty-serial-owl-uart.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-fat-fat.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp1250.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp860.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-rcu-rcuscale.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-scftorture.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- csky-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- csky-defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- csky-randconfig-001-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- csky-randconfig-002-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- i386-defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- loongarch-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- loongarch-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-algif_hash.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-chips-cfi_cmdset_0020.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-chips-cfi_util.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-cramfs-cramfs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-fat-fat.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_ucs2_utils.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-sysv-sysv.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-crypto-libpoly1305.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-vmw_vsock-vsock_diag.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- loongarch-randconfig-001-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- loongarch-randconfig-002-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- m68k-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- m68k-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-algif_hash.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-curve25519-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-cramfs-cramfs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-fat-fat.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-mac-gaelic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp1250.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp737.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp775.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp860.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp861.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp865.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp950.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_ucs2_utils.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-qnx6-qnx6.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-sysv-sysv.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-locking-test-ww_mutex.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-crypto-libpoly1305.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-packet-af_packet_diag.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- microblaze-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- microblaze-defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- nios2-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- nios2-defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- nios2-randconfig-001-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- openrisc-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- openrisc-defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- parisc-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- parisc-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_DAC1064.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_Ti3026.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_accel.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_ucs2_utils.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- parisc64-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_DAC1064.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_Ti3026.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_accel.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_ucs2_utils.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- powerpc-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- riscv-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme-core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- s390-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- s390-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-algif_hash.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-curve25519-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme-core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-cramfs-cramfs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-fat-fat.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_ucs2_utils.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-crypto-libpoly1305.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-packet-af_packet_diag.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-vmw_vsock-vsock_diag.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- sh-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- sh-defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- um-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- um-i386_defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- um-x86_64_defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
`-- xtensa-allnoconfig
    `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
clang_recent_errors
|-- arm-defconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-algif_hash.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-crypto_simd.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- hexagon-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- hexagon-defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- hexagon-randconfig-001-20231209
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- hexagon-randconfig-002-20231209
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-curve25519-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-spmi.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-hw_random-omap-rng.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-i2c-busses-i2c-qup.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-host-renesas_sdhi_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-host-tmio_mmc_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-chips-cfi_cmdset_0020.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-chips-cfi_util.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-maps-map_funcs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-perf-arm-ccn.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-regulator-rt4831-regulator.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-reset-hisilicon-hi6220_reset.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-soc-ixp4xx-ixp4xx-qmgr.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-soc-qcom-spm.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-spmi-hisi-spmi-controller.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-spmi-spmi-pmic-arb.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp775.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp861.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-rcu-rcuscale.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- i386-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- i386-buildonly-randconfig-006-20231208
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-block-t10-pi.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-algif_hash.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-crypto_simd.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-crypto-curve25519-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-slimbus.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-spmi.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-w1.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-agp-amd-k7-agp.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-agp-ati-agp.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-agp-efficeon-agp.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-agp-intel-agp.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-agp-intel-gtt.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-agp-nvidia-agp.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-agp-sis-agp.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-agp-sworks-agp.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-hw_random-omap-rng.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-hw_random-omap3-rom-rng.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-nvram.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-char-ttyprintk.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-crypto-xilinx-zynqmp-aes-gcm.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-cxl-core-cxl_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-cxl-cxl_pci.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-cxl-cxl_port.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-gpio-gpio-gw-pld.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-gpu-drm-tiny-cirrus.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-hte-hte-tegra194-test.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-i2c-busses-i2c-pxa.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-i2c-busses-i2c-qup.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-iio-adc-ingenic-adc.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-core-mmc_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-core-pwrseq_emmc.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-core-pwrseq_simple.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-host-renesas_sdhi_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mmc-host-tmio_mmc_core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-chips-cfi_cmdset_0020.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-chips-cfi_util.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-maps-map_funcs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-mtd-parsers-brcm_u-boot.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme-core.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvme-host-nvme.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-nvmem-nvmem_u-boot-env.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pci-controller-pci-host-generic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pci-controller-pcie-apple.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pci-controller-pcie-mediatek.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pci-controller-pcie-mt7621.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pci-pci-stub.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-perf-arm-ccn.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-perf-arm_cspmu-nvidia_cspmu.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-perf-cxl_pmu.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-phy-broadcom-phy-bcm-ns-usb2.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-pmdomain-amlogic-meson-ee-pwrc.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-regulator-rt4831-regulator.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-reset-hisilicon-hi6220_reset.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-soc-ixp4xx-ixp4xx-qmgr.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-soc-qcom-spm.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-spmi-hisi-spmi-controller.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-spmi-spmi-pmic-arb.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-tty-n_gsm.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-tty-serial-owl-uart.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_DAC1064.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_Ti3026.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-video-fbdev-matrox-matroxfb_accel.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-watchdog-omap_wdt.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-adfs-adfs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-binfmt_script.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-cramfs-cramfs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-efs-efs.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-fat-fat.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-mac-gaelic.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp1250.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp737.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp775.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp860.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp861.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp865.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_cp950.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_iso8859-.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-nls-nls_ucs2_utils.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-qnx6-qnx6.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-sysv-sysv.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-locking-test-ww_mutex.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-rcu-rcuscale.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-kernel-scftorture.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-crypto-libpoly1305.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-caif-chnl_net.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-packet-af_packet_diag.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-net-vmw_vsock-vsock_diag.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-configfs-configfs_sample.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kfifo-bytestream-example.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kfifo-dma-example.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kfifo-inttype-example.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kfifo-record-example.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kprobes-kprobe_example.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- mips-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- riscv-allnoconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- um-allmodconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- um-allnoconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
|-- um-allyesconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-block-loop.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o
`-- x86_64-allyesconfig
    |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-configfs-configfs_sample.o
    |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kfifo-bytestream-example.o
    |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kfifo-dma-example.o
    |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kfifo-inttype-example.o
    |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kfifo-record-example.o
    |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-samples-kprobes-kprobe_example.o
    `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-vmlinux.o

elapsed time: 1696m

configs tested: 91
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                               defconfig   gcc  
arc                               allnoconfig   gcc  
arc                                 defconfig   gcc  
arc                   randconfig-001-20231209   gcc  
arc                   randconfig-002-20231209   gcc  
arm                               allnoconfig   gcc  
arm                                 defconfig   clang
arm                   randconfig-001-20231209   gcc  
arm                   randconfig-002-20231209   gcc  
arm                   randconfig-003-20231209   gcc  
arm                   randconfig-004-20231209   gcc  
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20231209   gcc  
arm64                 randconfig-002-20231209   gcc  
arm64                 randconfig-003-20231209   gcc  
arm64                 randconfig-004-20231209   gcc  
csky                              allnoconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20231209   gcc  
csky                  randconfig-002-20231209   gcc  
hexagon                           allnoconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20231209   clang
hexagon               randconfig-002-20231209   clang
i386                             allmodconfig   clang
i386                              allnoconfig   clang
i386                             allyesconfig   clang
i386         buildonly-randconfig-001-20231208   clang
i386         buildonly-randconfig-002-20231208   clang
i386         buildonly-randconfig-003-20231208   clang
i386         buildonly-randconfig-004-20231208   clang
i386         buildonly-randconfig-005-20231208   clang
i386         buildonly-randconfig-006-20231208   clang
i386                                defconfig   gcc  
i386                  randconfig-001-20231208   clang
i386                  randconfig-002-20231208   clang
i386                  randconfig-003-20231208   clang
i386                  randconfig-004-20231208   clang
i386                  randconfig-005-20231208   clang
i386                  randconfig-006-20231208   clang
i386                  randconfig-011-20231208   gcc  
i386                  randconfig-012-20231208   gcc  
i386                  randconfig-013-20231208   gcc  
i386                  randconfig-014-20231208   gcc  
i386                  randconfig-015-20231208   gcc  
i386                  randconfig-016-20231208   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20231209   gcc  
loongarch             randconfig-002-20231209   gcc  
m68k                              allnoconfig   gcc  
m68k                                defconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                          defconfig   gcc  
mips                              allnoconfig   clang
nios2                             allnoconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20231209   gcc  
openrisc                          allnoconfig   gcc  
openrisc                            defconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                           allnoconfig   gcc  
riscv                             allnoconfig   clang
riscv                               defconfig   gcc  
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   clang
x86_64                              defconfig   gcc  
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
