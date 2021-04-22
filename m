Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8412DC433B4
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 04:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F45661003
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 04:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhDVEWs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:22:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:45917 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhDVEWs (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Apr 2021 00:22:48 -0400
IronPort-SDR: VY1lYaTzXqbSGjLH5tem2YHjgXUDjLexNhkvBJDaiv37V3bqpgR2Cj8yIWuCY4YM7upD4GtvnL
 MBICqqZL6tMA==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="216482196"
X-IronPort-AV: E=Sophos;i="5.82,241,1613462400"; 
   d="scan'208";a="216482196"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 21:22:13 -0700
IronPort-SDR: 6E8d2rXp+ZBy5FWXme2Z9FTKezvcB83fuFm0Cx68+ZC7c/on57AxCLekbGR5sTvYUmn3KkvBxB
 bHkVCAqYeU4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,241,1613462400"; 
   d="scan'208";a="455620300"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2021 21:22:11 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lZQqw-0003ya-V6; Thu, 22 Apr 2021 04:22:10 +0000
Date:   Thu, 22 Apr 2021 12:21:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 77b743f3aab662295129d8d7901ff3ea20674a49
Message-ID: <6080f9d4.4CAMTJsunWbIK68x%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 77b743f3aab662295129d8d7901ff3ea20674a49  md-cluster: fix use-after-free issue when removing rdev

elapsed time: 722m

configs tested: 158
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
x86_64                           allyesconfig
riscv                            allmodconfig
riscv                            allyesconfig
i386                             allyesconfig
arm                            lart_defconfig
mips                malta_qemu_32r6_defconfig
mips                          malta_defconfig
sh                             shx3_defconfig
um                                  defconfig
powerpc                      ppc44x_defconfig
mips                        workpad_defconfig
powerpc                 xes_mpc85xx_defconfig
powerpc                   currituck_defconfig
riscv                             allnoconfig
powerpc                 mpc837x_mds_defconfig
arm                       netwinder_defconfig
mips                        bcm63xx_defconfig
xtensa                  nommu_kc705_defconfig
arm                       omap2plus_defconfig
arm                      tct_hammer_defconfig
mips                           rs90_defconfig
arm                      integrator_defconfig
arm                      footbridge_defconfig
alpha                               defconfig
h8300                    h8300h-sim_defconfig
xtensa                              defconfig
powerpc                  iss476-smp_defconfig
powerpc                 mpc836x_rdk_defconfig
powerpc                      mgcoge_defconfig
powerpc                         wii_defconfig
arm                  colibri_pxa270_defconfig
openrisc                    or1ksim_defconfig
sparc                               defconfig
powerpc                     asp8347_defconfig
ia64                          tiger_defconfig
mips                        nlm_xlr_defconfig
mips                  decstation_64_defconfig
m68k                          hp300_defconfig
mips                           xway_defconfig
powerpc                  storcenter_defconfig
mips                           ci20_defconfig
arm                         lpc18xx_defconfig
mips                      bmips_stb_defconfig
arm                        mvebu_v7_defconfig
powerpc                          allmodconfig
mips                      loongson3_defconfig
powerpc                      walnut_defconfig
mips                           mtx1_defconfig
sparc64                             defconfig
powerpc                      acadia_defconfig
ia64                            zx1_defconfig
arc                                 defconfig
arm                         lpc32xx_defconfig
arm                           h5000_defconfig
powerpc                     tqm8548_defconfig
powerpc                 canyonlands_defconfig
sh                     magicpanelr2_defconfig
arm                         cm_x300_defconfig
arm                         bcm2835_defconfig
arm                        keystone_defconfig
ia64                         bigsur_defconfig
sparc                            allyesconfig
s390                          debug_defconfig
x86_64                           alldefconfig
m68k                         amcore_defconfig
mips                       capcella_defconfig
um                            kunit_defconfig
arm                        oxnas_v6_defconfig
arc                        vdk_hs38_defconfig
arc                        nsim_700_defconfig
mips                        maltaup_defconfig
mips                        bcm47xx_defconfig
powerpc                     tqm5200_defconfig
powerpc               mpc834x_itxgp_defconfig
mips                     loongson1b_defconfig
mips                           jazz_defconfig
arm                         s3c2410_defconfig
powerpc                 mpc836x_mds_defconfig
powerpc                       maple_defconfig
sh                           se7206_defconfig
sh                          sdk7786_defconfig
powerpc                     ksi8560_defconfig
arc                          axs103_defconfig
i386                             alldefconfig
arc                      axs103_smp_defconfig
m68k                         apollo_defconfig
sh                           sh2007_defconfig
sh                           se7722_defconfig
openrisc                         alldefconfig
mips                            e55_defconfig
sh                            migor_defconfig
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
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                           allnoconfig
x86_64               randconfig-a004-20210421
x86_64               randconfig-a002-20210421
x86_64               randconfig-a001-20210421
x86_64               randconfig-a005-20210421
x86_64               randconfig-a006-20210421
x86_64               randconfig-a003-20210421
i386                 randconfig-a005-20210421
i386                 randconfig-a002-20210421
i386                 randconfig-a001-20210421
i386                 randconfig-a006-20210421
i386                 randconfig-a004-20210421
i386                 randconfig-a003-20210421
i386                 randconfig-a012-20210421
i386                 randconfig-a014-20210421
i386                 randconfig-a011-20210421
i386                 randconfig-a013-20210421
i386                 randconfig-a015-20210421
i386                 randconfig-a016-20210421
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
riscv                          rv32_defconfig
um                               allmodconfig
um                                allnoconfig
um                               allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a015-20210421
x86_64               randconfig-a016-20210421
x86_64               randconfig-a011-20210421
x86_64               randconfig-a014-20210421
x86_64               randconfig-a013-20210421
x86_64               randconfig-a012-20210421

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
