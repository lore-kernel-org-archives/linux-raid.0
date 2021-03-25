Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6982C433E0
	for <linux-raid@archiver.kernel.org>; Thu, 25 Mar 2021 12:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C9AC61A17
	for <linux-raid@archiver.kernel.org>; Thu, 25 Mar 2021 12:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhCYMWe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Mar 2021 08:22:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:59431 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230249AbhCYMWY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 25 Mar 2021 08:22:24 -0400
IronPort-SDR: kiOpUHsqcxDE0tCEhZ33cakkNt003bgsV7WQFTjzqKNnPnBDx0/40uqPBzHSxWMz50m2gUfUFc
 MamG9NSLkUAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="191009112"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="191009112"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 05:22:22 -0700
IronPort-SDR: Mt1LEsS3htakV3b56zHsf0jyShtbYczODzIES1zdjRL/IBhAyheKHHml9hgzavt8sdrkoNotYP
 WL49phA3WHGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="414143581"
Received: from lkp-server01.sh.intel.com (HELO 69d8fcc516b7) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 25 Mar 2021 05:22:08 -0700
Received: from kbuild by 69d8fcc516b7 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lPP03-0001vs-OC; Thu, 25 Mar 2021 12:22:07 +0000
Date:   Thu, 25 Mar 2021 20:21:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 7abfabaf5f805f5171d133ce6af9b65ab766e76a
Message-ID: <605c805f.VshKIaPMwl2AkVwT%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 7abfabaf5f805f5171d133ce6af9b65ab766e76a  md: Fix missing unused status line of /proc/mdstat

elapsed time: 725m

configs tested: 121
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
arm                              allmodconfig
arm64                               defconfig
i386                             allyesconfig
riscv                            allyesconfig
mips                           ip28_defconfig
powerpc                    adder875_defconfig
sh                             sh03_defconfig
sh                           se7343_defconfig
alpha                            alldefconfig
mips                      pic32mzda_defconfig
ia64                          tiger_defconfig
parisc                generic-32bit_defconfig
sh                               j2_defconfig
sh                        apsh4ad0a_defconfig
mips                          ath25_defconfig
arm                      integrator_defconfig
mips                        bcm63xx_defconfig
mips                           ip27_defconfig
arm                       netwinder_defconfig
arm                        cerfcube_defconfig
powerpc                 mpc837x_mds_defconfig
powerpc                      ppc44x_defconfig
sh                           se7705_defconfig
arm                          moxart_defconfig
m68k                        m5407c3_defconfig
powerpc                    klondike_defconfig
powerpc                     sequoia_defconfig
arc                           tb10x_defconfig
powerpc                    ge_imp3a_defconfig
m68k                       m5208evb_defconfig
powerpc                 linkstation_defconfig
sh                   secureedge5410_defconfig
powerpc                      katmai_defconfig
arm                        vexpress_defconfig
mips                malta_qemu_32r6_defconfig
csky                             alldefconfig
sh                            hp6xx_defconfig
mips                          ath79_defconfig
sh                           se7721_defconfig
arm                          gemini_defconfig
sh                           se7751_defconfig
openrisc                    or1ksim_defconfig
sh                      rts7751r2d1_defconfig
arm                      tct_hammer_defconfig
powerpc                       ebony_defconfig
powerpc                  iss476-smp_defconfig
mips                      maltaaprp_defconfig
arm                       imx_v6_v7_defconfig
arm64                            alldefconfig
arm                           viper_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nios2                            allyesconfig
nds32                               defconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                                defconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                               tinyconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a002-20210325
x86_64               randconfig-a003-20210325
x86_64               randconfig-a006-20210325
x86_64               randconfig-a001-20210325
x86_64               randconfig-a005-20210325
x86_64               randconfig-a004-20210325
i386                 randconfig-a003-20210325
i386                 randconfig-a004-20210325
i386                 randconfig-a001-20210325
i386                 randconfig-a002-20210325
i386                 randconfig-a006-20210325
i386                 randconfig-a005-20210325
i386                 randconfig-a014-20210325
i386                 randconfig-a011-20210325
i386                 randconfig-a015-20210325
i386                 randconfig-a016-20210325
i386                 randconfig-a013-20210325
i386                 randconfig-a012-20210325
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a012-20210325
x86_64               randconfig-a015-20210325
x86_64               randconfig-a014-20210325
x86_64               randconfig-a013-20210325
x86_64               randconfig-a011-20210325
x86_64               randconfig-a016-20210325

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
