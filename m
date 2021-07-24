Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ACDC4338F
	for <linux-raid@archiver.kernel.org>; Sat, 24 Jul 2021 06:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F51601FC
	for <linux-raid@archiver.kernel.org>; Sat, 24 Jul 2021 06:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhGXGEI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:04:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:22305 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229926AbhGXGEG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 24 Jul 2021 02:04:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="211999869"
X-IronPort-AV: E=Sophos;i="5.84,265,1620716400"; 
   d="scan'208";a="211999869"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 23:44:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,265,1620716400"; 
   d="scan'208";a="434378084"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jul 2021 23:44:36 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1m7BOm-000336-Cn; Sat, 24 Jul 2021 06:44:36 +0000
Date:   Sat, 24 Jul 2021 14:43:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 5ba03936c05584b6f6f79be5ebe7e5036c1dd252
Message-ID: <60fbb6a5.PNFgpkLkAg2Li1fH%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 5ba03936c05584b6f6f79be5ebe7e5036c1dd252  md/raid10: properly indicate failure when ending a failed write request

elapsed time: 722m

configs tested: 119
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210723
sh                           se7750_defconfig
mips                  maltasmvp_eva_defconfig
arm                       imx_v6_v7_defconfig
arm                           tegra_defconfig
ia64                             allyesconfig
mips                           ip22_defconfig
powerpc                     redwood_defconfig
mips                      bmips_stb_defconfig
arc                           tb10x_defconfig
powerpc                         ps3_defconfig
m68k                       m5208evb_defconfig
sh                         microdev_defconfig
powerpc                      cm5200_defconfig
arm                          pxa910_defconfig
openrisc                  or1klitex_defconfig
arm                          gemini_defconfig
microblaze                          defconfig
sh                          r7785rp_defconfig
h8300                            alldefconfig
powerpc                 mpc85xx_cds_defconfig
sh                           se7705_defconfig
arm                          badge4_defconfig
powerpc                     kmeter1_defconfig
sh                     sh7710voipgw_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
mips                     loongson2k_defconfig
sh                        sh7763rdp_defconfig
mips                         mpc30x_defconfig
m68k                            mac_defconfig
arc                    vdk_hs38_smp_defconfig
powerpc                      katmai_defconfig
powerpc                     tqm8548_defconfig
m68k                             alldefconfig
nds32                               defconfig
powerpc                    amigaone_defconfig
arm                        keystone_defconfig
openrisc                    or1ksim_defconfig
x86_64                            allnoconfig
ia64                             allmodconfig
ia64                                defconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
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
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a005-20210723
i386                 randconfig-a003-20210723
i386                 randconfig-a004-20210723
i386                 randconfig-a002-20210723
i386                 randconfig-a001-20210723
i386                 randconfig-a006-20210723
i386                 randconfig-a005-20210724
i386                 randconfig-a003-20210724
i386                 randconfig-a004-20210724
i386                 randconfig-a002-20210724
i386                 randconfig-a001-20210724
i386                 randconfig-a006-20210724
x86_64               randconfig-a011-20210723
x86_64               randconfig-a016-20210723
x86_64               randconfig-a013-20210723
x86_64               randconfig-a014-20210723
x86_64               randconfig-a012-20210723
x86_64               randconfig-a015-20210723
i386                 randconfig-a016-20210723
i386                 randconfig-a013-20210723
i386                 randconfig-a012-20210723
i386                 randconfig-a011-20210723
i386                 randconfig-a014-20210723
i386                 randconfig-a015-20210723
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-c001-20210723
x86_64               randconfig-b001-20210723
x86_64               randconfig-a003-20210723
x86_64               randconfig-a006-20210723
x86_64               randconfig-a001-20210723
x86_64               randconfig-a005-20210723
x86_64               randconfig-a004-20210723
x86_64               randconfig-a002-20210723

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
