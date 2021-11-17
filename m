Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2A1C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 20:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CD6761B43
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 20:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240712AbhKQU0P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 15:26:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:31917 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238577AbhKQU0P (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Nov 2021 15:26:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="231529211"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="231529211"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 12:23:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="736346565"
Received: from lkp-server02.sh.intel.com (HELO c20d8bc80006) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 17 Nov 2021 12:23:14 -0800
Received: from kbuild by c20d8bc80006 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mnRSc-0002Bi-5w; Wed, 17 Nov 2021 20:23:14 +0000
Date:   Thu, 18 Nov 2021 04:22:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 78a7fb15ebd7b8557a87ebcf02c81018fb7566f7
Message-ID: <6195649f.agxoTeWuOgVYpp/j%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 78a7fb15ebd7b8557a87ebcf02c81018fb7566f7  md: fix the problem that the pointer may be double free

elapsed time: 725m

configs tested: 192
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211117
powerpc              randconfig-c003-20211117
s390                       zfcpdump_defconfig
arm                          gemini_defconfig
powerpc                      mgcoge_defconfig
ia64                          tiger_defconfig
sh                ecovec24-romimage_defconfig
m68k                          multi_defconfig
powerpc                 mpc85xx_cds_defconfig
arm                      jornada720_defconfig
arm                         lpc18xx_defconfig
sh                          urquell_defconfig
nios2                         10m50_defconfig
powerpc                   currituck_defconfig
arm                          collie_defconfig
powerpc                     kilauea_defconfig
sh                          rsk7269_defconfig
riscv                            alldefconfig
alpha                               defconfig
powerpc                     stx_gp3_defconfig
arc                     nsimosci_hs_defconfig
mips                     loongson2k_defconfig
x86_64                           allyesconfig
powerpc               mpc834x_itxgp_defconfig
x86_64                              defconfig
mips                         cobalt_defconfig
powerpc                      pasemi_defconfig
mips                           jazz_defconfig
mips                malta_qemu_32r6_defconfig
sparc                       sparc64_defconfig
powerpc                    adder875_defconfig
ia64                                defconfig
sh                         apsh4a3a_defconfig
arm                          ep93xx_defconfig
mips                          ath79_defconfig
sh                         ecovec24_defconfig
openrisc                         alldefconfig
powerpc                     pq2fads_defconfig
powerpc                 mpc8272_ads_defconfig
sh                           se7712_defconfig
mips                          rb532_defconfig
arm                          simpad_defconfig
i386                             alldefconfig
mips                       capcella_defconfig
powerpc                     tqm8555_defconfig
arm                             ezx_defconfig
powerpc                  mpc885_ads_defconfig
powerpc                    ge_imp3a_defconfig
um                           x86_64_defconfig
sh                   secureedge5410_defconfig
s390                             allmodconfig
mips                      loongson3_defconfig
h8300                       h8s-sim_defconfig
arm                           stm32_defconfig
xtensa                    smp_lx200_defconfig
m68k                        mvme147_defconfig
powerpc                     mpc83xx_defconfig
sh                   sh7724_generic_defconfig
mips                      malta_kvm_defconfig
powerpc                 mpc832x_mds_defconfig
h8300                    h8300h-sim_defconfig
m68k                           sun3_defconfig
sh                          lboxre2_defconfig
powerpc                         ps3_defconfig
ia64                        generic_defconfig
powerpc                    socrates_defconfig
m68k                          atari_defconfig
mips                      bmips_stb_defconfig
powerpc                      cm5200_defconfig
arm                        mvebu_v7_defconfig
arm                          exynos_defconfig
powerpc                   motionpro_defconfig
arm                       omap2plus_defconfig
powerpc                 xes_mpc85xx_defconfig
sparc                       sparc32_defconfig
riscv                          rv32_defconfig
m68k                        stmark2_defconfig
powerpc                     mpc5200_defconfig
arm                       aspeed_g5_defconfig
sh                           se7619_defconfig
arm                              alldefconfig
sh                 kfr2r09-romimage_defconfig
riscv             nommu_k210_sdcard_defconfig
powerpc                        cell_defconfig
um                             i386_defconfig
powerpc                       holly_defconfig
xtensa                              defconfig
arm                            mps2_defconfig
sh                        edosk7705_defconfig
m68k                         amcore_defconfig
ia64                             allyesconfig
arm                           tegra_defconfig
powerpc                 mpc837x_mds_defconfig
ia64                             alldefconfig
arc                        nsimosci_defconfig
powerpc                      tqm8xx_defconfig
powerpc                  mpc866_ads_defconfig
arm                         s3c6400_defconfig
powerpc                      ppc6xx_defconfig
powerpc                     tqm8560_defconfig
arc                         haps_hs_defconfig
sh                        apsh4ad0a_defconfig
arm                         s3c2410_defconfig
mips                           mtx1_defconfig
parisc                generic-64bit_defconfig
powerpc                     asp8347_defconfig
arm                        magician_defconfig
arm                         assabet_defconfig
h8300                            alldefconfig
mips                         tb0287_defconfig
powerpc64                           defconfig
powerpc                      acadia_defconfig
arm                       versatile_defconfig
arm                            dove_defconfig
arm                  randconfig-c002-20211117
ia64                             allmodconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a005-20211117
x86_64               randconfig-a003-20211117
x86_64               randconfig-a002-20211117
x86_64               randconfig-a001-20211117
x86_64               randconfig-a006-20211117
x86_64               randconfig-a004-20211117
i386                 randconfig-a006-20211117
i386                 randconfig-a003-20211117
i386                 randconfig-a005-20211117
i386                 randconfig-a001-20211117
i386                 randconfig-a004-20211117
i386                 randconfig-a002-20211117
arc                  randconfig-r043-20211117
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-c007-20211117
i386                 randconfig-c001-20211117
arm                  randconfig-c002-20211117
riscv                randconfig-c006-20211117
powerpc              randconfig-c003-20211117
s390                 randconfig-c005-20211117
mips                 randconfig-c004-20211117
x86_64               randconfig-a015-20211117
x86_64               randconfig-a013-20211117
x86_64               randconfig-a011-20211117
x86_64               randconfig-a012-20211117
x86_64               randconfig-a016-20211117
x86_64               randconfig-a014-20211117
i386                 randconfig-a014-20211117
i386                 randconfig-a016-20211117
i386                 randconfig-a012-20211117
i386                 randconfig-a013-20211117
i386                 randconfig-a011-20211117
i386                 randconfig-a015-20211117
hexagon              randconfig-r045-20211117
hexagon              randconfig-r041-20211117
s390                 randconfig-r044-20211117
riscv                randconfig-r042-20211117

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
