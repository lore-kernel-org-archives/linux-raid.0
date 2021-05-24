Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDE6C2B9F8
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 17:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB7961400
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 17:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhEXRhA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 May 2021 13:37:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:27300 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233112AbhEXRg7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 May 2021 13:36:59 -0400
IronPort-SDR: napefHMUuny9xeMOazkUsBlRXfD7WUaDKnFGfOw2wtwSeU9IoZseVpl5F5NDFMp84qULs0XfrU
 3A+K2Hoz8KAQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9993"; a="202011762"
X-IronPort-AV: E=Sophos;i="5.82,325,1613462400"; 
   d="scan'208";a="202011762"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 10:35:28 -0700
IronPort-SDR: NpByXquiLfIKic9Eu2OxlyYDBnMkMcfoo2nZK7UTvAUaHp/HEFugiFoBRAxYxOa4dtZa17L3ay
 ckVCxHRnDOfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,325,1613462400"; 
   d="scan'208";a="475982436"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 24 May 2021 10:35:27 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1llEUA-0001If-Ja; Mon, 24 May 2021 17:35:26 +0000
Date:   Tue, 25 May 2021 01:35:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 ac5cf751a832c0dc7adf0e880158edd5c58ae854
Message-ID: <60abe3cf.Xo+4cLf7gUxpK3a1%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: ac5cf751a832c0dc7adf0e880158edd5c58ae854  md/raid5: remove an incorrect assert in in_chunk_boundary

elapsed time: 726m

configs tested: 186
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
powerpc                      tqm8xx_defconfig
arm                       mainstone_defconfig
powerpc                 mpc832x_rdb_defconfig
powerpc                      mgcoge_defconfig
arm                          imote2_defconfig
arm                          pxa3xx_defconfig
x86_64                              defconfig
mips                        nlm_xlr_defconfig
sh                             shx3_defconfig
mips                         tb0287_defconfig
m68k                            q40_defconfig
sh                           se7343_defconfig
powerpc                 mpc837x_mds_defconfig
arm                            mps2_defconfig
arm                          pxa910_defconfig
powerpc                      pcm030_defconfig
mips                           ip27_defconfig
mips                           mtx1_defconfig
arm                             mxs_defconfig
mips                        bcm47xx_defconfig
arm                         at91_dt_defconfig
arm                            lart_defconfig
sh                         apsh4a3a_defconfig
arm                           spitz_defconfig
powerpc                      makalu_defconfig
arm                       aspeed_g4_defconfig
arm64                            alldefconfig
ia64                          tiger_defconfig
csky                                defconfig
powerpc                     stx_gp3_defconfig
xtensa                           allyesconfig
sh                          rsk7264_defconfig
m68k                          amiga_defconfig
arm                          ep93xx_defconfig
sh                        sh7757lcr_defconfig
arm                         axm55xx_defconfig
arm                          pcm027_defconfig
riscv                    nommu_virt_defconfig
powerpc                   currituck_defconfig
xtensa                              defconfig
m68k                        m5407c3_defconfig
mips                      pic32mzda_defconfig
powerpc                     mpc83xx_defconfig
ia64                             alldefconfig
sh                           se7724_defconfig
sparc                            allyesconfig
mips                     cu1000-neo_defconfig
sh                         microdev_defconfig
arm                       spear13xx_defconfig
riscv                          rv32_defconfig
powerpc                  mpc866_ads_defconfig
arm                           stm32_defconfig
powerpc                     taishan_defconfig
xtensa                       common_defconfig
xtensa                    xip_kc705_defconfig
powerpc                       ebony_defconfig
powerpc                 canyonlands_defconfig
arm                        neponset_defconfig
sh                     magicpanelr2_defconfig
powerpc                       maple_defconfig
arm                            qcom_defconfig
sh                   sh7724_generic_defconfig
arm                      integrator_defconfig
arm                        oxnas_v6_defconfig
sh                           se7722_defconfig
arm                          badge4_defconfig
s390                                defconfig
arm                         lpc18xx_defconfig
openrisc                            defconfig
riscv                               defconfig
powerpc                     skiroot_defconfig
arm                       imx_v4_v5_defconfig
sh                          rsk7203_defconfig
mips                           xway_defconfig
mips                     loongson1c_defconfig
mips                  cavium_octeon_defconfig
sparc                               defconfig
csky                             alldefconfig
h8300                    h8300h-sim_defconfig
openrisc                 simple_smp_defconfig
sh                        edosk7705_defconfig
arm                           h3600_defconfig
mips                        omega2p_defconfig
sh                        sh7785lcr_defconfig
powerpc                     powernv_defconfig
powerpc                 linkstation_defconfig
mips                      bmips_stb_defconfig
sh                            titan_defconfig
m68k                         amcore_defconfig
mips                        workpad_defconfig
mips                     loongson2k_defconfig
mips                           jazz_defconfig
riscv                            alldefconfig
arm                     eseries_pxa_defconfig
powerpc                    adder875_defconfig
xtensa                    smp_lx200_defconfig
powerpc                      acadia_defconfig
sh                           se7619_defconfig
powerpc                     akebono_defconfig
riscv                    nommu_k210_defconfig
parisc                           alldefconfig
openrisc                  or1klitex_defconfig
parisc                generic-32bit_defconfig
sh                          rsk7201_defconfig
powerpc                  mpc885_ads_defconfig
m68k                             alldefconfig
sh                        sh7763rdp_defconfig
sh                   rts7751r2dplus_defconfig
mips                           gcw0_defconfig
sh                          rsk7269_defconfig
m68k                        m5307c3_defconfig
sh                          r7780mp_defconfig
m68k                            mac_defconfig
xtensa                         virt_defconfig
alpha                            alldefconfig
arc                 nsimosci_hs_smp_defconfig
x86_64                            allnoconfig
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
alpha                               defconfig
alpha                            allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
i386                             allyesconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a005-20210524
x86_64               randconfig-a001-20210524
x86_64               randconfig-a006-20210524
x86_64               randconfig-a003-20210524
x86_64               randconfig-a004-20210524
x86_64               randconfig-a002-20210524
i386                 randconfig-a001-20210524
i386                 randconfig-a002-20210524
i386                 randconfig-a005-20210524
i386                 randconfig-a006-20210524
i386                 randconfig-a004-20210524
i386                 randconfig-a003-20210524
i386                 randconfig-a011-20210524
i386                 randconfig-a016-20210524
i386                 randconfig-a015-20210524
i386                 randconfig-a012-20210524
i386                 randconfig-a014-20210524
i386                 randconfig-a013-20210524
riscv                            allyesconfig
riscv                             allnoconfig
riscv                            allmodconfig
um                               allmodconfig
um                                allnoconfig
um                               allyesconfig
um                                  defconfig
x86_64                    rhel-8.3-kselftests
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                           allyesconfig
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-b001-20210524
x86_64               randconfig-a013-20210524
x86_64               randconfig-a012-20210524
x86_64               randconfig-a014-20210524
x86_64               randconfig-a016-20210524
x86_64               randconfig-a015-20210524
x86_64               randconfig-a011-20210524

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
