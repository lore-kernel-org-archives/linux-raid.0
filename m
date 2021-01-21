Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86748C433E6
	for <linux-raid@archiver.kernel.org>; Thu, 21 Jan 2021 04:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3711823788
	for <linux-raid@archiver.kernel.org>; Thu, 21 Jan 2021 04:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732983AbhAUEci (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:32:38 -0500
Received: from mga18.intel.com ([134.134.136.126]:57299 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbhAUEbU (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 20 Jan 2021 23:31:20 -0500
IronPort-SDR: HN4Il0sgf8MIYSmi+D4YnjnZFGvjQbLFCBwFdjSz5CAdhnEJaocX5iF2BCuQoqZs0bKg9Y8mFq
 AxXNh0Gsrdbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="166879575"
X-IronPort-AV: E=Sophos;i="5.79,363,1602572400"; 
   d="scan'208";a="166879575"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 20:30:35 -0800
IronPort-SDR: e3oMQB68PQ7uz27Un1Bn3n46FgYqZhcI5ALelgWww9ne6ZSfX5ybrgwJJpDrEWeg6TpkxLjTlt
 r4r9gBdKeNzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,363,1602572400"; 
   d="scan'208";a="467324968"
Received: from lkp-server01.sh.intel.com (HELO 260eafd5ecd0) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2021 20:30:33 -0800
Received: from kbuild by 260eafd5ecd0 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1l2Rc9-0006Gi-6t; Thu, 21 Jan 2021 04:30:33 +0000
Date:   Thu, 21 Jan 2021 12:30:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 dc5d17a3c39b06aef866afca19245a9cfb533a79
Message-ID: <60090357./Mt9wxaX//Pa2rIm%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: dc5d17a3c39b06aef866afca19245a9cfb533a79  md: Set prev_flush_start and flush_bio in an atomic way

elapsed time: 722m

configs tested: 158
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
arm                                 defconfig
s390                          debug_defconfig
mips                     cu1830-neo_defconfig
arm                          moxart_defconfig
xtensa                    smp_lx200_defconfig
mips                          malta_defconfig
powerpc                     stx_gp3_defconfig
powerpc                         ps3_defconfig
arm                         hackkit_defconfig
powerpc64                           defconfig
m68k                          sun3x_defconfig
ia64                      gensparse_defconfig
powerpc                     mpc5200_defconfig
powerpc                     tqm8541_defconfig
powerpc                 mpc834x_itx_defconfig
powerpc                     powernv_defconfig
sh                   secureedge5410_defconfig
powerpc                     skiroot_defconfig
arm                    vt8500_v6_v7_defconfig
arm                         cm_x300_defconfig
arm                             pxa_defconfig
powerpc                    amigaone_defconfig
openrisc                            defconfig
powerpc                 mpc832x_mds_defconfig
arm                       imx_v6_v7_defconfig
m68k                       m5249evb_defconfig
ia64                          tiger_defconfig
arm                       versatile_defconfig
powerpc                 linkstation_defconfig
powerpc                     sbc8548_defconfig
powerpc                      ppc6xx_defconfig
arm                           viper_defconfig
powerpc                     ppa8548_defconfig
sh                           se7724_defconfig
mips                     decstation_defconfig
mips                         bigsur_defconfig
arm                        mini2440_defconfig
xtensa                              defconfig
powerpc                    klondike_defconfig
sh                            titan_defconfig
powerpc                     rainier_defconfig
powerpc                  storcenter_defconfig
arm                            pleb_defconfig
powerpc                   lite5200b_defconfig
sh                   sh7770_generic_defconfig
powerpc                         wii_defconfig
um                            kunit_defconfig
mips                            ar7_defconfig
ia64                        generic_defconfig
mips                        jmr3927_defconfig
riscv                             allnoconfig
h8300                       h8s-sim_defconfig
sh                           se7712_defconfig
mips                           ip22_defconfig
openrisc                    or1ksim_defconfig
m68k                         apollo_defconfig
arm                     am200epdkit_defconfig
powerpc                mpc7448_hpc2_defconfig
arm                       spear13xx_defconfig
xtensa                generic_kc705_defconfig
m68k                             alldefconfig
arm                           spitz_defconfig
xtensa                  cadence_csp_defconfig
arm                         axm55xx_defconfig
arm                           h3600_defconfig
c6x                                 defconfig
xtensa                       common_defconfig
m68k                          multi_defconfig
csky                             alldefconfig
arm                         mv78xx0_defconfig
mips                           ip32_defconfig
mips                      maltasmvp_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
c6x                              allyesconfig
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
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                               tinyconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a002-20210119
i386                 randconfig-a005-20210119
i386                 randconfig-a006-20210119
i386                 randconfig-a001-20210119
i386                 randconfig-a003-20210119
i386                 randconfig-a004-20210119
i386                 randconfig-a001-20210120
i386                 randconfig-a002-20210120
i386                 randconfig-a004-20210120
i386                 randconfig-a005-20210120
i386                 randconfig-a003-20210120
i386                 randconfig-a006-20210120
x86_64               randconfig-a012-20210120
x86_64               randconfig-a015-20210120
x86_64               randconfig-a016-20210120
x86_64               randconfig-a011-20210120
x86_64               randconfig-a013-20210120
x86_64               randconfig-a014-20210120
i386                 randconfig-a013-20210120
i386                 randconfig-a011-20210120
i386                 randconfig-a012-20210120
i386                 randconfig-a014-20210120
i386                 randconfig-a015-20210120
i386                 randconfig-a016-20210120
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                                   rhel
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a002-20210120
x86_64               randconfig-a003-20210120
x86_64               randconfig-a001-20210120
x86_64               randconfig-a005-20210120
x86_64               randconfig-a006-20210120
x86_64               randconfig-a004-20210120
x86_64               randconfig-a004-20210118
x86_64               randconfig-a006-20210118
x86_64               randconfig-a001-20210118
x86_64               randconfig-a003-20210118
x86_64               randconfig-a005-20210118
x86_64               randconfig-a002-20210118

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
