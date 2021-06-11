Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B52BC48BE0
	for <linux-raid@archiver.kernel.org>; Fri, 11 Jun 2021 15:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4877661357
	for <linux-raid@archiver.kernel.org>; Fri, 11 Jun 2021 15:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhFKPMW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Jun 2021 11:12:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:10797 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhFKPMV (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 11 Jun 2021 11:12:21 -0400
IronPort-SDR: Eih4iIRrlKTii/M8EFAaOwr+n6Hf1rsgrzH5DV/mV7HN1eAIJUwFX8rWEqRTqabBG0V26eZg+W
 JNAow8OfoTEg==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="269390870"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="269390870"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 08:10:21 -0700
IronPort-SDR: hP6+PkwwHkuVCCJ7/CbOrYyB276sQdxsyxik09tUam5jqCD0zsCgVBmUlQKBz4NKznYQV2j8Zr
 x7lPC6ZQ//8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="449133998"
Received: from lkp-server02.sh.intel.com (HELO 3cb98b298c7e) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 11 Jun 2021 08:10:20 -0700
Received: from kbuild by 3cb98b298c7e with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lrinc-0000bb-FR; Fri, 11 Jun 2021 15:10:20 +0000
Date:   Fri, 11 Jun 2021 23:09:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 9be148e408df7d361ec5afd6299b7736ff3928b0
Message-ID: <60c37c9d.VBAM9+zhlZF+Lsod%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 9be148e408df7d361ec5afd6299b7736ff3928b0  async_xor: check src_offs is not NULL before updating it

elapsed time: 721m

configs tested: 169
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm                              allyesconfig
arm                              allmodconfig
arm64                            allyesconfig
arm64                               defconfig
powerpc                 mpc836x_rdk_defconfig
arm                         cm_x300_defconfig
arm                         s3c6400_defconfig
mips                           jazz_defconfig
arm                     davinci_all_defconfig
mips                malta_qemu_32r6_defconfig
mips                     cu1000-neo_defconfig
s390                                defconfig
powerpc                  iss476-smp_defconfig
arc                        vdk_hs38_defconfig
powerpc                 mpc832x_mds_defconfig
mips                        vocore2_defconfig
arc                        nsimosci_defconfig
arm                              alldefconfig
arm                         axm55xx_defconfig
powerpc                    socrates_defconfig
alpha                            allyesconfig
ia64                         bigsur_defconfig
powerpc                 xes_mpc85xx_defconfig
powerpc                      walnut_defconfig
powerpc                     sequoia_defconfig
m68k                        m5272c3_defconfig
xtensa                              defconfig
arm                             pxa_defconfig
openrisc                         alldefconfig
sh                          kfr2r09_defconfig
arm                        realview_defconfig
mips                           ip32_defconfig
arm                        spear6xx_defconfig
arm                           stm32_defconfig
sh                   sh7770_generic_defconfig
arm                         s5pv210_defconfig
sh                          rsk7201_defconfig
arm                          pxa3xx_defconfig
arm64                            alldefconfig
powerpc                      cm5200_defconfig
m68k                            mac_defconfig
arc                     nsimosci_hs_defconfig
sh                         ap325rxa_defconfig
powerpc                      ep88xc_defconfig
m68k                       m5475evb_defconfig
powerpc                       ppc64_defconfig
sh                         ecovec24_defconfig
mips                      maltasmvp_defconfig
sh                          polaris_defconfig
arm                            qcom_defconfig
m68k                       m5249evb_defconfig
sparc                            alldefconfig
arm                           spitz_defconfig
powerpc                     stx_gp3_defconfig
riscv                    nommu_k210_defconfig
arm                       mainstone_defconfig
powerpc                     tqm8540_defconfig
arm                       omap2plus_defconfig
h8300                     edosk2674_defconfig
arm                     eseries_pxa_defconfig
arm                      tct_hammer_defconfig
arm                         lpc32xx_defconfig
sh                                  defconfig
openrisc                  or1klitex_defconfig
arm                     am200epdkit_defconfig
mips                  decstation_64_defconfig
arm                      footbridge_defconfig
powerpc                     kmeter1_defconfig
arm                        multi_v7_defconfig
sh                           se7780_defconfig
mips                        workpad_defconfig
sh                           se7721_defconfig
xtensa                generic_kc705_defconfig
sh                          rsk7269_defconfig
arm                    vt8500_v6_v7_defconfig
mips                        bcm47xx_defconfig
arm                      integrator_defconfig
sh                 kfr2r09-romimage_defconfig
sh                          sdk7786_defconfig
sh                              ul2_defconfig
microblaze                          defconfig
m68k                        stmark2_defconfig
i386                                defconfig
sh                     sh7710voipgw_defconfig
arm                        trizeps4_defconfig
mips                        omega2p_defconfig
sh                           se7712_defconfig
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
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a002-20210611
x86_64               randconfig-a001-20210611
x86_64               randconfig-a004-20210611
x86_64               randconfig-a003-20210611
x86_64               randconfig-a006-20210611
x86_64               randconfig-a005-20210611
i386                 randconfig-a002-20210611
i386                 randconfig-a006-20210611
i386                 randconfig-a004-20210611
i386                 randconfig-a001-20210611
i386                 randconfig-a005-20210611
i386                 randconfig-a003-20210611
i386                 randconfig-a015-20210611
i386                 randconfig-a013-20210611
i386                 randconfig-a016-20210611
i386                 randconfig-a014-20210611
i386                 randconfig-a012-20210611
i386                 randconfig-a011-20210611
i386                 randconfig-a015-20210610
i386                 randconfig-a013-20210610
i386                 randconfig-a016-20210610
i386                 randconfig-a014-20210610
i386                 randconfig-a012-20210610
i386                 randconfig-a011-20210610
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                           x86_64_defconfig
um                             i386_defconfig
um                            kunit_defconfig
x86_64                    rhel-8.3-kselftests
x86_64                      rhel-8.3-kbuiltin
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a015-20210611
x86_64               randconfig-a011-20210611
x86_64               randconfig-a012-20210611
x86_64               randconfig-a014-20210611
x86_64               randconfig-a016-20210611
x86_64               randconfig-a013-20210611
x86_64               randconfig-a002-20210607
x86_64               randconfig-a004-20210607
x86_64               randconfig-a003-20210607
x86_64               randconfig-a006-20210607
x86_64               randconfig-a005-20210607
x86_64               randconfig-a001-20210607

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
