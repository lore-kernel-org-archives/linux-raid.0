Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776D2C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 17:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EC9F60F36
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 17:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhKBR2S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 13:28:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:20711 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhKBR2S (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 2 Nov 2021 13:28:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="292162153"
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="292162153"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 10:25:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="449485971"
Received: from lkp-server02.sh.intel.com (HELO c20d8bc80006) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2021 10:25:41 -0700
Received: from kbuild by c20d8bc80006 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mhxXY-0004hj-PQ; Tue, 02 Nov 2021 17:25:40 +0000
Date:   Wed, 03 Nov 2021 01:25:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 5663ca4e2a1249da72b675ba7f7a18801017fa63
Message-ID: <61817491.6td/K3RT2nEi2tE9%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 5663ca4e2a1249da72b675ba7f7a18801017fa63  raid5-ppl: use swap() to make code cleaner

elapsed time: 723m

configs tested: 190
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211101
mips                 randconfig-c004-20211101
powerpc              randconfig-c003-20211101
arc                        vdk_hs38_defconfig
arm                       cns3420vb_defconfig
mips                          rb532_defconfig
alpha                            allyesconfig
powerpc                     powernv_defconfig
arm                        shmobile_defconfig
mips                            ar7_defconfig
powerpc                   currituck_defconfig
sh                          landisk_defconfig
mips                          malta_defconfig
powerpc                     tqm8555_defconfig
arm                        cerfcube_defconfig
mips                        bcm63xx_defconfig
powerpc                      bamboo_defconfig
powerpc                      katmai_defconfig
mips                 decstation_r4k_defconfig
powerpc                        icon_defconfig
arc                        nsimosci_defconfig
sh                ecovec24-romimage_defconfig
powerpc                     kmeter1_defconfig
m68k                        m5307c3_defconfig
mips                           mtx1_defconfig
mips                malta_qemu_32r6_defconfig
powerpc                     ep8248e_defconfig
sh                  sh7785lcr_32bit_defconfig
h8300                       h8s-sim_defconfig
powerpc                 mpc8540_ads_defconfig
powerpc                 mpc837x_mds_defconfig
arm                       spear13xx_defconfig
arm                        mvebu_v7_defconfig
mips                      loongson3_defconfig
mips                      maltasmvp_defconfig
m68k                        stmark2_defconfig
arc                          axs103_defconfig
powerpc                   bluestone_defconfig
arm                          moxart_defconfig
riscv                             allnoconfig
powerpc                    sam440ep_defconfig
m68k                          atari_defconfig
arm                            mmp2_defconfig
mips                        jmr3927_defconfig
arm                             ezx_defconfig
powerpc                 mpc8272_ads_defconfig
mips                           xway_defconfig
sh                        apsh4ad0a_defconfig
xtensa                  audio_kc705_defconfig
powerpc                      pcm030_defconfig
arm                       versatile_defconfig
arm                           tegra_defconfig
riscv                               defconfig
mips                           gcw0_defconfig
arm                           corgi_defconfig
sh                            shmin_defconfig
arm                         s3c2410_defconfig
powerpc                      tqm8xx_defconfig
m68k                          hp300_defconfig
parisc                generic-64bit_defconfig
arm                  colibri_pxa270_defconfig
xtensa                           alldefconfig
arm                        spear6xx_defconfig
mips                             allmodconfig
powerpc                         wii_defconfig
mips                        vocore2_defconfig
sh                     magicpanelr2_defconfig
s390                          debug_defconfig
powerpc                 mpc834x_itx_defconfig
powerpc                      acadia_defconfig
arm                           h5000_defconfig
arc                              alldefconfig
sh                            hp6xx_defconfig
arm                         cm_x300_defconfig
powerpc                 linkstation_defconfig
sh                           se7712_defconfig
mips                          ath79_defconfig
mips                      maltaaprp_defconfig
sh                          lboxre2_defconfig
powerpc                      ep88xc_defconfig
arm                           spitz_defconfig
arm                      jornada720_defconfig
ia64                        generic_defconfig
arm                           omap1_defconfig
sh                           sh2007_defconfig
sh                        sh7785lcr_defconfig
m68k                          multi_defconfig
sh                           se7705_defconfig
m68k                       m5475evb_defconfig
powerpc                      cm5200_defconfig
arm                        mvebu_v5_defconfig
microblaze                      mmu_defconfig
arm                       aspeed_g5_defconfig
powerpc                    gamecube_defconfig
ia64                            zx1_defconfig
sh                           se7780_defconfig
mips                     decstation_defconfig
arm                          ep93xx_defconfig
powerpc                   microwatt_defconfig
s390                             alldefconfig
arm                         orion5x_defconfig
arm                  randconfig-c002-20211101
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                              debian-10.3
mips                             allyesconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a012-20211101
x86_64               randconfig-a015-20211101
x86_64               randconfig-a016-20211101
x86_64               randconfig-a013-20211101
x86_64               randconfig-a011-20211101
x86_64               randconfig-a014-20211101
i386                 randconfig-a016-20211101
i386                 randconfig-a014-20211101
i386                 randconfig-a015-20211101
i386                 randconfig-a013-20211101
i386                 randconfig-a011-20211101
i386                 randconfig-a012-20211101
arc                  randconfig-r043-20211101
riscv                randconfig-r042-20211101
s390                 randconfig-r044-20211101
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
mips                 randconfig-c004-20211101
arm                  randconfig-c002-20211101
i386                 randconfig-c001-20211101
s390                 randconfig-c005-20211101
powerpc              randconfig-c003-20211101
riscv                randconfig-c006-20211101
x86_64               randconfig-c007-20211101
mips                 randconfig-c004-20211102
arm                  randconfig-c002-20211102
i386                 randconfig-c001-20211102
s390                 randconfig-c005-20211102
powerpc              randconfig-c003-20211102
riscv                randconfig-c006-20211102
x86_64               randconfig-c007-20211102
x86_64               randconfig-a004-20211101
x86_64               randconfig-a006-20211101
x86_64               randconfig-a001-20211101
x86_64               randconfig-a002-20211101
x86_64               randconfig-a003-20211101
x86_64               randconfig-a005-20211101
i386                 randconfig-a005-20211101
i386                 randconfig-a001-20211101
i386                 randconfig-a003-20211101
i386                 randconfig-a004-20211101
i386                 randconfig-a006-20211101
i386                 randconfig-a002-20211101
hexagon              randconfig-r041-20211101
hexagon              randconfig-r045-20211101

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
