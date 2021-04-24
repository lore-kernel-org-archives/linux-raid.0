Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A27C433ED
	for <linux-raid@archiver.kernel.org>; Sat, 24 Apr 2021 05:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE00B61164
	for <linux-raid@archiver.kernel.org>; Sat, 24 Apr 2021 05:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhDXFEz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 24 Apr 2021 01:04:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:34232 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhDXFEy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 24 Apr 2021 01:04:54 -0400
IronPort-SDR: DYwCZ0/sUI3qDc+Uo0Rehqk5PSbLmGJ8lNHltjr14OZGvdHb0mrle1Ta9YnkeV5sXzgT8yE18G
 turMctHpRsVg==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="175647224"
X-IronPort-AV: E=Sophos;i="5.82,247,1613462400"; 
   d="scan'208";a="175647224"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 22:04:11 -0700
IronPort-SDR: Vos5Jdx0tL6ScpqjM4Daa7+bvC9PQPQDEF5VBXdRKsCwP3atKBh93g4HD9YGlJ2sAn7kJyT7G6
 frPt2mxnaOqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,247,1613462400"; 
   d="scan'208";a="525211443"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2021 22:04:10 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1laASg-0004zs-2h; Sat, 24 Apr 2021 05:04:10 +0000
Date:   Sat, 24 Apr 2021 13:03:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd
Message-ID: <6083a6b9.7zwWav/631J83qPk%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd  md/raid1: properly indicate failure when ending a failed write request

elapsed time: 722m

configs tested: 166
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
riscv                            allmodconfig
i386                             allyesconfig
riscv                            allyesconfig
sh                ecovec24-romimage_defconfig
mips                        omega2p_defconfig
sh                           se7780_defconfig
powerpc                           allnoconfig
mips                         tb0219_defconfig
powerpc                      obs600_defconfig
arm                       imx_v6_v7_defconfig
x86_64                           alldefconfig
arm                     am200epdkit_defconfig
arm                            dove_defconfig
sh                           sh2007_defconfig
sh                         ecovec24_defconfig
arm                          lpd270_defconfig
arm                         orion5x_defconfig
arc                        vdk_hs38_defconfig
mips                  maltasmvp_eva_defconfig
m68k                       m5208evb_defconfig
arm                           stm32_defconfig
mips                           ci20_defconfig
mips                        bcm63xx_defconfig
m68k                             alldefconfig
sh                          kfr2r09_defconfig
mips                      pistachio_defconfig
mips                          ath25_defconfig
microblaze                          defconfig
openrisc                    or1ksim_defconfig
nios2                            alldefconfig
arm                           h3600_defconfig
mips                          rm200_defconfig
mips                       capcella_defconfig
powerpc                     skiroot_defconfig
arm                           sama5_defconfig
arc                 nsimosci_hs_smp_defconfig
i386                                defconfig
arm                          exynos_defconfig
ia64                             alldefconfig
m68k                                defconfig
sh                          rsk7203_defconfig
sh                           se7724_defconfig
arm64                            alldefconfig
um                             i386_defconfig
mips                  decstation_64_defconfig
m68k                          multi_defconfig
mips                     cu1830-neo_defconfig
parisc                generic-64bit_defconfig
arm                         lubbock_defconfig
powerpc                  storcenter_defconfig
arm                       spear13xx_defconfig
s390                          debug_defconfig
sh                        edosk7760_defconfig
mips                      bmips_stb_defconfig
powerpc                      ppc64e_defconfig
arm                        mvebu_v7_defconfig
mips                            e55_defconfig
sh                          polaris_defconfig
mips                           jazz_defconfig
arm                           viper_defconfig
arm                            mps2_defconfig
arm                       imx_v4_v5_defconfig
sh                               j2_defconfig
powerpc                 mpc832x_mds_defconfig
powerpc                         wii_defconfig
mips                           ip28_defconfig
arm                         hackkit_defconfig
sh                             sh03_defconfig
powerpc                   lite5200b_defconfig
sh                            migor_defconfig
openrisc                  or1klitex_defconfig
m68k                        m5272c3_defconfig
um                               allmodconfig
arm                         lpc18xx_defconfig
powerpc                          g5_defconfig
arc                        nsim_700_defconfig
arm                       aspeed_g4_defconfig
ia64                                defconfig
powerpc                     taishan_defconfig
arm                      integrator_defconfig
arm                          collie_defconfig
powerpc                      tqm8xx_defconfig
arm                            qcom_defconfig
arm                        magician_defconfig
mips                        vocore2_defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nds32                               defconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
nios2                            allyesconfig
xtensa                           allyesconfig
arc                                 defconfig
h8300                            allyesconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
sparc                            allyesconfig
sparc                               defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
x86_64               randconfig-a004-20210423
x86_64               randconfig-a003-20210423
x86_64               randconfig-a002-20210423
x86_64               randconfig-a001-20210423
x86_64               randconfig-a005-20210423
x86_64               randconfig-a006-20210423
i386                 randconfig-a005-20210423
i386                 randconfig-a002-20210423
i386                 randconfig-a001-20210423
i386                 randconfig-a006-20210423
i386                 randconfig-a004-20210423
i386                 randconfig-a003-20210423
i386                 randconfig-a014-20210423
i386                 randconfig-a012-20210423
i386                 randconfig-a011-20210423
i386                 randconfig-a013-20210423
i386                 randconfig-a015-20210423
i386                 randconfig-a016-20210423
i386                 randconfig-a012-20210424
i386                 randconfig-a014-20210424
i386                 randconfig-a011-20210424
i386                 randconfig-a013-20210424
i386                 randconfig-a016-20210424
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
um                                allnoconfig
um                               allyesconfig
um                                  defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a015-20210423
x86_64               randconfig-a016-20210423
x86_64               randconfig-a011-20210423
x86_64               randconfig-a014-20210423
x86_64               randconfig-a012-20210423
x86_64               randconfig-a013-20210423
x86_64               randconfig-a004-20210424
x86_64               randconfig-a002-20210424
x86_64               randconfig-a003-20210424
x86_64               randconfig-a001-20210424
x86_64               randconfig-a006-20210424
x86_64               randconfig-a005-20210424

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
