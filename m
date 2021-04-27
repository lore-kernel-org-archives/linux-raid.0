Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BD9C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 27 Apr 2021 06:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C8F561078
	for <linux-raid@archiver.kernel.org>; Tue, 27 Apr 2021 06:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhD0Gad (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Apr 2021 02:30:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:12839 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhD0Gad (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 27 Apr 2021 02:30:33 -0400
IronPort-SDR: 0VLqVYGHVT/EEhBqAqjGLU6sx3xxo9CkJ6NkXYuslSIfi/ldctqL1BWfmFrlfR2ycX5o4YJc4W
 HCw6+9AHkjMA==
X-IronPort-AV: E=McAfee;i="6200,9189,9966"; a="183594470"
X-IronPort-AV: E=Sophos;i="5.82,254,1613462400"; 
   d="scan'208";a="183594470"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2021 23:29:50 -0700
IronPort-SDR: Z8h0FVXH4FYDQOKMUWyODxvfdEbS3NONFcthr10sFXpZj4s2vugSmuuOREjrSbzrL5hvQNS6in
 8ATGQCJgDljg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,254,1613462400"; 
   d="scan'208";a="457488059"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 26 Apr 2021 23:29:48 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lbHEC-0006Mi-BV; Tue, 27 Apr 2021 06:29:48 +0000
Date:   Tue, 27 Apr 2021 14:29:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 ceaf2966ab082bbc4d26516f97b3ca8a676e2af8
Message-ID: <6087af56.msYFPm3CwB8hjF7X%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: ceaf2966ab082bbc4d26516f97b3ca8a676e2af8  async_xor: increase src_offs when dropping destination page

elapsed time: 727m

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
x86_64                           allyesconfig
riscv                            allmodconfig
i386                             allyesconfig
riscv                            allyesconfig
mips                         tb0287_defconfig
sh                          rsk7264_defconfig
mips                     decstation_defconfig
powerpc                   currituck_defconfig
powerpc                     tqm8548_defconfig
mips                      fuloong2e_defconfig
arm                         mv78xx0_defconfig
sparc                       sparc32_defconfig
m68k                                defconfig
sh                           se7705_defconfig
mips                     loongson1c_defconfig
s390                                defconfig
sh                           sh2007_defconfig
sh                     sh7710voipgw_defconfig
powerpc                     kilauea_defconfig
sh                           se7751_defconfig
powerpc                     rainier_defconfig
powerpc                          g5_defconfig
m68k                       bvme6000_defconfig
sh                           se7206_defconfig
powerpc                    socrates_defconfig
sh                          r7780mp_defconfig
arm                     am200epdkit_defconfig
powerpc                 mpc834x_mds_defconfig
sh                           se7712_defconfig
arm                            lart_defconfig
arm                            xcep_defconfig
mips                             allmodconfig
sh                            migor_defconfig
arm                      tct_hammer_defconfig
arm                      pxa255-idp_defconfig
powerpc                      makalu_defconfig
arc                    vdk_hs38_smp_defconfig
sh                   secureedge5410_defconfig
mips                         mpc30x_defconfig
powerpc                     stx_gp3_defconfig
arm                          pxa168_defconfig
powerpc                         ps3_defconfig
arm                         axm55xx_defconfig
powerpc                     tqm8555_defconfig
sh                         ap325rxa_defconfig
arm                            hisi_defconfig
arm                       spear13xx_defconfig
ia64                             allyesconfig
powerpc                 mpc8315_rdb_defconfig
ia64                             allmodconfig
ia64                                defconfig
m68k                             allmodconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nds32                               defconfig
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
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a005-20210426
i386                 randconfig-a002-20210426
i386                 randconfig-a001-20210426
i386                 randconfig-a006-20210426
i386                 randconfig-a004-20210426
i386                 randconfig-a003-20210426
x86_64               randconfig-a015-20210426
x86_64               randconfig-a016-20210426
x86_64               randconfig-a011-20210426
x86_64               randconfig-a014-20210426
x86_64               randconfig-a012-20210426
x86_64               randconfig-a013-20210426
i386                 randconfig-a014-20210426
i386                 randconfig-a012-20210426
i386                 randconfig-a011-20210426
i386                 randconfig-a013-20210426
i386                 randconfig-a015-20210426
i386                 randconfig-a016-20210426
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
um                               allmodconfig
um                                allnoconfig
um                               allyesconfig
um                                  defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a002-20210426
x86_64               randconfig-a004-20210426
x86_64               randconfig-a001-20210426
x86_64               randconfig-a006-20210426
x86_64               randconfig-a005-20210426
x86_64               randconfig-a003-20210426

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
