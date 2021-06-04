Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF16C07E94
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 14:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A7F613FF
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 14:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFDOoN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Jun 2021 10:44:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:24985 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhFDOoM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 4 Jun 2021 10:44:12 -0400
IronPort-SDR: 18u5q0OEWbJln8PD9S491v9/2+WT8ksGMTIaDuTuk2AiIp2yZgqHs8l8U1u6wiQYotiq7U25SL
 iYRuLZm4INHw==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="265463402"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="265463402"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 07:42:25 -0700
IronPort-SDR: CuLISeeW1dWk1L5dwgQjmZ3a1YrBXDb1uAYvIsd/p2h+RkXG3CT6Thy/rA3Cjn5SYB9mpKhTJ+
 A8OkDFZaacQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448276336"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 07:42:23 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lpB1i-0006zA-Uk; Fri, 04 Jun 2021 14:42:22 +0000
Date:   Fri, 04 Jun 2021 22:42:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 eaf634fc2966114742315d169b3cf99fcbd752a2
Message-ID: <60ba3bc2.tzH09zfKN364eGTJ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: eaf634fc2966114742315d169b3cf99fcbd752a2  md: add comments in md_integrity_register

elapsed time: 721m

configs tested: 213
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
nios2                         3c120_defconfig
mips                         tb0219_defconfig
arm                          moxart_defconfig
mips                           xway_defconfig
powerpc                       holly_defconfig
sh                   rts7751r2dplus_defconfig
mips                         rt305x_defconfig
mips                           mtx1_defconfig
arm                          ep93xx_defconfig
h8300                    h8300h-sim_defconfig
powerpc                     kilauea_defconfig
sh                           se7780_defconfig
sh                         ap325rxa_defconfig
sh                         apsh4a3a_defconfig
arc                         haps_hs_defconfig
arm                         mv78xx0_defconfig
sh                         ecovec24_defconfig
powerpc                 xes_mpc85xx_defconfig
powerpc                         ps3_defconfig
mips                         tb0287_defconfig
sh                          landisk_defconfig
mips                        maltaup_defconfig
mips                     cu1830-neo_defconfig
arm                             mxs_defconfig
m68k                       m5275evb_defconfig
arm                     am200epdkit_defconfig
mips                        bcm47xx_defconfig
powerpc                 mpc836x_rdk_defconfig
powerpc                    sam440ep_defconfig
sh                            titan_defconfig
riscv             nommu_k210_sdcard_defconfig
powerpc                      ep88xc_defconfig
sh                               alldefconfig
powerpc64                           defconfig
powerpc                 mpc8313_rdb_defconfig
openrisc                            defconfig
mips                  decstation_64_defconfig
powerpc                     mpc5200_defconfig
arm                     davinci_all_defconfig
powerpc                      makalu_defconfig
mips                   sb1250_swarm_defconfig
powerpc                      pcm030_defconfig
powerpc                   lite5200b_defconfig
arm                           u8500_defconfig
um                                  defconfig
nds32                             allnoconfig
m68k                          hp300_defconfig
m68k                          amiga_defconfig
powerpc                    gamecube_defconfig
ia64                             allyesconfig
sh                        sh7785lcr_defconfig
powerpc                     tqm8541_defconfig
m68k                       m5208evb_defconfig
arm                           stm32_defconfig
nds32                            alldefconfig
sh                          rsk7264_defconfig
powerpc                    klondike_defconfig
sh                         microdev_defconfig
arm                         s5pv210_defconfig
arm                         cm_x300_defconfig
powerpc                    adder875_defconfig
powerpc                mpc7448_hpc2_defconfig
xtensa                              defconfig
microblaze                          defconfig
powerpc                 mpc837x_rdb_defconfig
powerpc                      ppc40x_defconfig
powerpc                 canyonlands_defconfig
arm                          pxa168_defconfig
sh                           se7712_defconfig
powerpc                     rainier_defconfig
arm                         orion5x_defconfig
xtensa                    xip_kc705_defconfig
nios2                         10m50_defconfig
mips                         db1xxx_defconfig
openrisc                 simple_smp_defconfig
arm                              alldefconfig
arm                         nhk8815_defconfig
mips                      pic32mzda_defconfig
arm                            mmp2_defconfig
sh                            hp6xx_defconfig
sh                      rts7751r2d1_defconfig
sh                             sh03_defconfig
ia64                             alldefconfig
arc                     nsimosci_hs_defconfig
mips                      maltaaprp_defconfig
arm                       omap2plus_defconfig
sh                 kfr2r09-romimage_defconfig
powerpc                     sequoia_defconfig
sparc64                          alldefconfig
m68k                        mvme147_defconfig
arm                       spear13xx_defconfig
powerpc                 mpc834x_itx_defconfig
ia64                          tiger_defconfig
powerpc                     mpc512x_defconfig
mips                       lemote2f_defconfig
mips                           ip28_defconfig
sh                          sdk7786_defconfig
arm                       cns3420vb_defconfig
arm                        trizeps4_defconfig
sh                          lboxre2_defconfig
powerpc                     sbc8548_defconfig
arm                         lubbock_defconfig
powerpc                     mpc83xx_defconfig
arc                    vdk_hs38_smp_defconfig
mips                        jmr3927_defconfig
sh                   sh7770_generic_defconfig
mips                         mpc30x_defconfig
mips                  maltasmvp_eva_defconfig
arm                        realview_defconfig
s390                                defconfig
sh                           se7206_defconfig
powerpc                     tqm8555_defconfig
microblaze                      mmu_defconfig
x86_64                            allnoconfig
ia64                             allmodconfig
ia64                                defconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
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
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a002-20210604
x86_64               randconfig-a004-20210604
x86_64               randconfig-a003-20210604
x86_64               randconfig-a006-20210604
x86_64               randconfig-a005-20210604
x86_64               randconfig-a001-20210604
i386                 randconfig-a003-20210604
i386                 randconfig-a006-20210604
i386                 randconfig-a004-20210604
i386                 randconfig-a001-20210604
i386                 randconfig-a005-20210604
i386                 randconfig-a002-20210604
i386                 randconfig-a003-20210603
i386                 randconfig-a006-20210603
i386                 randconfig-a004-20210603
i386                 randconfig-a001-20210603
i386                 randconfig-a002-20210603
i386                 randconfig-a005-20210603
x86_64               randconfig-a015-20210603
x86_64               randconfig-a011-20210603
x86_64               randconfig-a012-20210603
x86_64               randconfig-a014-20210603
x86_64               randconfig-a016-20210603
x86_64               randconfig-a013-20210603
i386                 randconfig-a015-20210603
i386                 randconfig-a013-20210603
i386                 randconfig-a011-20210603
i386                 randconfig-a016-20210603
i386                 randconfig-a014-20210603
i386                 randconfig-a012-20210603
i386                 randconfig-a015-20210604
i386                 randconfig-a013-20210604
i386                 randconfig-a016-20210604
i386                 randconfig-a011-20210604
i386                 randconfig-a014-20210604
i386                 randconfig-a012-20210604
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                           x86_64_defconfig
um                             i386_defconfig
um                            kunit_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-b001-20210604
x86_64               randconfig-a002-20210603
x86_64               randconfig-a004-20210603
x86_64               randconfig-a003-20210603
x86_64               randconfig-a006-20210603
x86_64               randconfig-a005-20210603
x86_64               randconfig-a001-20210603
x86_64               randconfig-a015-20210604
x86_64               randconfig-a011-20210604
x86_64               randconfig-a014-20210604
x86_64               randconfig-a012-20210604
x86_64               randconfig-a016-20210604
x86_64               randconfig-a013-20210604

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
