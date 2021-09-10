Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806FDC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Sep 2021 02:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5780A610C7
	for <linux-raid@archiver.kernel.org>; Fri, 10 Sep 2021 02:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhIJCeM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Sep 2021 22:34:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:26092 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJCeL (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 9 Sep 2021 22:34:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="281988442"
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="281988442"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 19:33:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="607117621"
Received: from lkp-server01.sh.intel.com (HELO 730d49888f40) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 09 Sep 2021 19:32:59 -0700
Received: from kbuild by 730d49888f40 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mOWLa-0003ll-Ly; Fri, 10 Sep 2021 02:32:58 +0000
Date:   Fri, 10 Sep 2021 10:31:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 879401f903413462729f11f8fd7c6eabeb241358
Message-ID: <613ac39e.ayk8yt3yaHBkLxMc%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 879401f903413462729f11f8fd7c6eabeb241358  md: properly unwind when failing to add the kobject in md_alloc

elapsed time: 1180m

configs tested: 201
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210908
powerpc                 xes_mpc85xx_defconfig
parisc                generic-64bit_defconfig
arm                             ezx_defconfig
powerpc                     mpc83xx_defconfig
arm                       aspeed_g4_defconfig
sh                   sh7724_generic_defconfig
arm                            hisi_defconfig
mips                        nlm_xlr_defconfig
mips                  decstation_64_defconfig
um                           x86_64_defconfig
mips                        omega2p_defconfig
powerpc                     asp8347_defconfig
arm                         lpc32xx_defconfig
powerpc                       eiger_defconfig
h8300                            alldefconfig
sh                           se7751_defconfig
mips                         bigsur_defconfig
m68k                          amiga_defconfig
arm                            pleb_defconfig
m68k                            mac_defconfig
powerpc                 mpc834x_itx_defconfig
sh                        sh7763rdp_defconfig
xtensa                    smp_lx200_defconfig
arm                          collie_defconfig
nios2                            alldefconfig
powerpc                      pcm030_defconfig
powerpc                  storcenter_defconfig
arm                          ep93xx_defconfig
sparc                       sparc32_defconfig
arm                         axm55xx_defconfig
mips                     loongson2k_defconfig
mips                      fuloong2e_defconfig
ia64                            zx1_defconfig
openrisc                 simple_smp_defconfig
powerpc                     mpc5200_defconfig
arm                        spear6xx_defconfig
s390                                defconfig
arc                        nsimosci_defconfig
alpha                            allyesconfig
arm                         lpc18xx_defconfig
sh                             sh03_defconfig
sh                            titan_defconfig
sh                            shmin_defconfig
arm                      integrator_defconfig
mips                      maltaaprp_defconfig
powerpc                      chrp32_defconfig
arm                         socfpga_defconfig
powerpc                     ep8248e_defconfig
arm                          pxa168_defconfig
s390                          debug_defconfig
powerpc                      mgcoge_defconfig
powerpc                   lite5200b_defconfig
arm                             rpc_defconfig
arm                     am200epdkit_defconfig
powerpc                     skiroot_defconfig
powerpc                 mpc836x_rdk_defconfig
powerpc                    klondike_defconfig
openrisc                            defconfig
mips                          ath79_defconfig
m68k                       m5208evb_defconfig
m68k                        m5407c3_defconfig
arm                       versatile_defconfig
arm                        cerfcube_defconfig
arm                          ixp4xx_defconfig
sh                               j2_defconfig
sh                             espt_defconfig
ia64                        generic_defconfig
arm                         vf610m4_defconfig
mips                           ip32_defconfig
arm                  colibri_pxa300_defconfig
m68k                        m5307c3_defconfig
powerpc                      obs600_defconfig
powerpc                    mvme5100_defconfig
powerpc                     sequoia_defconfig
sh                           se7750_defconfig
mips                        workpad_defconfig
powerpc                        warp_defconfig
arm                         mv78xx0_defconfig
sh                           se7343_defconfig
powerpc                     redwood_defconfig
sh                          r7785rp_defconfig
x86_64                           alldefconfig
sh                      rts7751r2d1_defconfig
arc                      axs103_smp_defconfig
sh                          sdk7780_defconfig
powerpc                        fsp2_defconfig
arm                       netwinder_defconfig
arm                        keystone_defconfig
mips                         tb0219_defconfig
powerpc                 mpc8560_ads_defconfig
arm                         palmz72_defconfig
powerpc                mpc7448_hpc2_defconfig
m68k                          multi_defconfig
powerpc                  iss476-smp_defconfig
sh                 kfr2r09-romimage_defconfig
powerpc                      ppc6xx_defconfig
sh                        apsh4ad0a_defconfig
mips                       rbtx49xx_defconfig
mips                        vocore2_defconfig
powerpc                      makalu_defconfig
nios2                         3c120_defconfig
powerpc                      ep88xc_defconfig
arm                           sama7_defconfig
arc                          axs103_defconfig
microblaze                      mmu_defconfig
powerpc                    sam440ep_defconfig
openrisc                         alldefconfig
arm                           viper_defconfig
sh                        sh7785lcr_defconfig
powerpc                 mpc8315_rdb_defconfig
xtensa                    xip_kc705_defconfig
sh                        edosk7760_defconfig
mips                        qi_lb60_defconfig
m68k                       bvme6000_defconfig
powerpc                     ppa8548_defconfig
arm                    vt8500_v6_v7_defconfig
arm                            qcom_defconfig
arm                        spear3xx_defconfig
x86_64               randconfig-c001-20210908
x86_64                            allnoconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                                defconfig
m68k                             allmodconfig
m68k                             allyesconfig
nios2                               defconfig
nds32                             allnoconfig
arc                              allyesconfig
nds32                               defconfig
csky                                defconfig
alpha                               defconfig
nios2                            allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
xtensa                           allyesconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                             allyesconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                           allnoconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
x86_64               randconfig-a004-20210908
x86_64               randconfig-a006-20210908
x86_64               randconfig-a003-20210908
x86_64               randconfig-a001-20210908
x86_64               randconfig-a005-20210908
x86_64               randconfig-a002-20210908
i386                 randconfig-a005-20210908
i386                 randconfig-a004-20210908
i386                 randconfig-a006-20210908
i386                 randconfig-a002-20210908
i386                 randconfig-a001-20210908
i386                 randconfig-a003-20210908
arc                  randconfig-r043-20210908
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allyesconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec
x86_64                           allyesconfig

clang tested configs:
s390                 randconfig-c005-20210908
powerpc              randconfig-c003-20210908
mips                 randconfig-c004-20210908
i386                 randconfig-c001-20210908
x86_64               randconfig-a016-20210908
x86_64               randconfig-a011-20210908
x86_64               randconfig-a012-20210908
x86_64               randconfig-a015-20210908
x86_64               randconfig-a014-20210908
x86_64               randconfig-a013-20210908
i386                 randconfig-a012-20210908
i386                 randconfig-a015-20210908
i386                 randconfig-a011-20210908
i386                 randconfig-a013-20210908
i386                 randconfig-a014-20210908
i386                 randconfig-a016-20210908
s390                 randconfig-r044-20210908
riscv                randconfig-r042-20210908
hexagon              randconfig-r045-20210908
hexagon              randconfig-r041-20210908

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
