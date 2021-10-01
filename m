Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827A3C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  1 Oct 2021 10:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66AE261507
	for <linux-raid@archiver.kernel.org>; Fri,  1 Oct 2021 10:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353697AbhJALAu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Oct 2021 07:00:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:3049 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353693AbhJALAq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 1 Oct 2021 07:00:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="310944573"
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="310944573"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 03:58:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="520982656"
Received: from lkp-server01.sh.intel.com (HELO 72c3bd3cf19c) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 01 Oct 2021 03:58:58 -0700
Received: from kbuild by 72c3bd3cf19c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mWGFl-000169-Nt; Fri, 01 Oct 2021 10:58:57 +0000
Date:   Fri, 01 Oct 2021 18:57:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 46f0fffb8e88f2a7c40ce67bb08e47f1f78a191f
Message-ID: <6156e9b7.tQHpudJHKJK4oZ16%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 46f0fffb8e88f2a7c40ce67bb08e47f1f78a191f  md: properly unwind when failing to add the kobject in md_alloc

elapsed time: 1552m

configs tested: 129
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210930
i386                 randconfig-c001-20211001
arm                       mainstone_defconfig
mips                           mtx1_defconfig
arm                       imx_v6_v7_defconfig
powerpc                     stx_gp3_defconfig
mips                         tb0287_defconfig
powerpc                     powernv_defconfig
mips                           xway_defconfig
mips                          rb532_defconfig
arm                        oxnas_v6_defconfig
m68k                         apollo_defconfig
arm                            lart_defconfig
powerpc                 mpc8560_ads_defconfig
mips                     cu1000-neo_defconfig
mips                        qi_lb60_defconfig
s390                          debug_defconfig
sh                         ap325rxa_defconfig
powerpc                        cell_defconfig
powerpc                     ksi8560_defconfig
powerpc                     ep8248e_defconfig
parisc                generic-64bit_defconfig
powerpc                     pseries_defconfig
arm                          simpad_defconfig
m68k                        stmark2_defconfig
powerpc                 mpc85xx_cds_defconfig
powerpc                    socrates_defconfig
um                             i386_defconfig
sh                        apsh4ad0a_defconfig
arm                        magician_defconfig
mips                       bmips_be_defconfig
mips                       lemote2f_defconfig
powerpc                  mpc885_ads_defconfig
arm                     davinci_all_defconfig
arm                       aspeed_g5_defconfig
arm                          ixp4xx_defconfig
mips                            e55_defconfig
sh                         ecovec24_defconfig
arm                  randconfig-c002-20210930
x86_64               randconfig-c001-20210930
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nds32                               defconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
nios2                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
parisc                              defconfig
s390                                defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                             allyesconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a004-20210930
x86_64               randconfig-a001-20210930
x86_64               randconfig-a002-20210930
x86_64               randconfig-a005-20210930
x86_64               randconfig-a006-20210930
x86_64               randconfig-a003-20210930
i386                 randconfig-a003-20210930
i386                 randconfig-a001-20210930
i386                 randconfig-a004-20210930
i386                 randconfig-a002-20210930
i386                 randconfig-a006-20210930
i386                 randconfig-a005-20210930
i386                 randconfig-a001-20211001
i386                 randconfig-a003-20211001
i386                 randconfig-a005-20211001
i386                 randconfig-a002-20211001
i386                 randconfig-a004-20211001
i386                 randconfig-a006-20211001
arc                  randconfig-r043-20210930
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allyesconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                                  kexec

clang tested configs:
i386                 randconfig-c001-20210930
arm                  randconfig-c002-20210930
powerpc              randconfig-c003-20210930
mips                 randconfig-c004-20210930
s390                 randconfig-c005-20210930
riscv                randconfig-c006-20210930
x86_64               randconfig-c007-20210930
x86_64               randconfig-a015-20210930
x86_64               randconfig-a011-20210930
x86_64               randconfig-a012-20210930
x86_64               randconfig-a013-20210930
x86_64               randconfig-a016-20210930
x86_64               randconfig-a014-20210930
i386                 randconfig-a014-20210930
i386                 randconfig-a013-20210930
i386                 randconfig-a011-20210930
i386                 randconfig-a015-20210930
i386                 randconfig-a016-20210930
i386                 randconfig-a012-20210930
riscv                randconfig-r042-20210930
hexagon              randconfig-r041-20210930
s390                 randconfig-r044-20210930
hexagon              randconfig-r045-20210930

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
