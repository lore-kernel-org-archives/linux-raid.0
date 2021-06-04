Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAB2C47097
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 00:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 711CB6140C
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 00:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhFDBAX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:00:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:21376 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhFDBAX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 3 Jun 2021 21:00:23 -0400
IronPort-SDR: /HvUOnHX4ZQohHYAPrA8dnhI6KRnReCzE+jAytVEZpR79qPFkR3f/pyyuXajfF1j9i1ZFtq75c
 UVKnyWlPnvQA==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="184566991"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="184566991"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 17:58:35 -0700
IronPort-SDR: l+gXh/H9yD9y7vaaaMFANcESJ4V4I9AFWixIMXfdDhj4WVQLXg0qKKHsTCmYY4SZJg4YosHHgX
 xzOQSXp+x5eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="446498838"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 03 Jun 2021 17:58:32 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1loyAR-0006Wm-SK; Fri, 04 Jun 2021 00:58:31 +0000
Date:   Fri, 04 Jun 2021 08:57:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 783b5dcba231f07459f30ca508162c1e670b0dcc
Message-ID: <60b97a88.Xk5b4tGU+tCVp3gF%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 783b5dcba231f07459f30ca508162c1e670b0dcc  It needs to check offset array is NULL or not in async_xor_offs

elapsed time: 1008m

configs tested: 242
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
arm                         socfpga_defconfig
arm                            qcom_defconfig
sh                          sdk7786_defconfig
mips                       rbtx49xx_defconfig
mips                        vocore2_defconfig
mips                           ip27_defconfig
powerpc                      pasemi_defconfig
m68k                       m5249evb_defconfig
arm                         lpc32xx_defconfig
powerpc                 xes_mpc85xx_defconfig
powerpc                      obs600_defconfig
mips                           jazz_defconfig
xtensa                    smp_lx200_defconfig
arm                          collie_defconfig
powerpc                    adder875_defconfig
m68k                         apollo_defconfig
powerpc               mpc834x_itxgp_defconfig
powerpc                      arches_defconfig
mips                          rm200_defconfig
arm                             mxs_defconfig
sh                            titan_defconfig
arm                           h5000_defconfig
powerpc                     tqm8548_defconfig
sh                         apsh4a3a_defconfig
arc                         haps_hs_defconfig
arm                         mv78xx0_defconfig
sh                         ecovec24_defconfig
sh                         ap325rxa_defconfig
powerpc                    amigaone_defconfig
arc                 nsimosci_hs_smp_defconfig
sh                   sh7770_generic_defconfig
m68k                       m5275evb_defconfig
powerpc                 mpc836x_mds_defconfig
parisc                              defconfig
sh                               j2_defconfig
mips                  decstation_64_defconfig
powerpc                 mpc837x_mds_defconfig
mips                       lemote2f_defconfig
arm                              alldefconfig
m68k                        m5407c3_defconfig
m68k                        mvme16x_defconfig
arc                    vdk_hs38_smp_defconfig
s390                       zfcpdump_defconfig
arm                         bcm2835_defconfig
mips                            ar7_defconfig
powerpc                  storcenter_defconfig
m68k                             alldefconfig
arm                         lpc18xx_defconfig
arc                      axs103_smp_defconfig
mips                         mpc30x_defconfig
sh                        dreamcast_defconfig
sh                          r7780mp_defconfig
arm                           h3600_defconfig
arm                            mps2_defconfig
arc                          axs103_defconfig
arm                         s3c6400_defconfig
sparc                       sparc32_defconfig
powerpc                     tqm8540_defconfig
sh                               alldefconfig
powerpc                     sbc8548_defconfig
arm                       netwinder_defconfig
mips                           rs90_defconfig
m68k                         amcore_defconfig
arm                        cerfcube_defconfig
powerpc                 canyonlands_defconfig
powerpc64                        alldefconfig
arm                    vt8500_v6_v7_defconfig
arm                            zeus_defconfig
xtensa                generic_kc705_defconfig
m68k                          amiga_defconfig
mips                            gpr_defconfig
nios2                         3c120_defconfig
powerpc                      pcm030_defconfig
powerpc                   lite5200b_defconfig
arm                           u8500_defconfig
um                                  defconfig
nds32                             allnoconfig
powerpc                 mpc8272_ads_defconfig
powerpc                        cell_defconfig
mips                        bcm63xx_defconfig
powerpc                      walnut_defconfig
mips                      pic32mzda_defconfig
mips                malta_qemu_32r6_defconfig
powerpc                      acadia_defconfig
arm                        neponset_defconfig
nios2                               defconfig
mips                         db1xxx_defconfig
powerpc                     pseries_defconfig
sh                           se7343_defconfig
powerpc                      tqm8xx_defconfig
sh                          urquell_defconfig
powerpc                      cm5200_defconfig
arm                  colibri_pxa270_defconfig
sh                            hp6xx_defconfig
um                            kunit_defconfig
mips                       bmips_be_defconfig
powerpc                     mpc83xx_defconfig
ia64                      gensparse_defconfig
m68k                            q40_defconfig
sh                ecovec24-romimage_defconfig
powerpc                     skiroot_defconfig
sh                   rts7751r2dplus_defconfig
xtensa                    xip_kc705_defconfig
arm                      tct_hammer_defconfig
powerpc                 mpc8560_ads_defconfig
arm                           sunxi_defconfig
mips                           mtx1_defconfig
sh                           se7712_defconfig
powerpc                     rainier_defconfig
arm                         orion5x_defconfig
arm                         axm55xx_defconfig
sh                             espt_defconfig
powerpc                     mpc5200_defconfig
powerpc                 mpc834x_itx_defconfig
arm                           stm32_defconfig
powerpc                 mpc85xx_cds_defconfig
xtensa                         virt_defconfig
arm                         at91_dt_defconfig
mips                        qi_lb60_defconfig
x86_64                              defconfig
mips                  cavium_octeon_defconfig
arm                         palmz72_defconfig
mips                          rb532_defconfig
powerpc                  mpc866_ads_defconfig
arm                           omap1_defconfig
powerpc                 mpc836x_rdk_defconfig
mips                         tb0219_defconfig
m68k                        m5307c3_defconfig
arm                       multi_v4t_defconfig
arm                       spear13xx_defconfig
powerpc                    ge_imp3a_defconfig
openrisc                  or1klitex_defconfig
powerpc64                           defconfig
arm                           tegra_defconfig
sh                              ul2_defconfig
powerpc                          allmodconfig
mips                     loongson2k_defconfig
arc                              alldefconfig
mips                      pistachio_defconfig
sh                        sh7757lcr_defconfig
arm                      pxa255-idp_defconfig
arm                           spitz_defconfig
arm                        vexpress_defconfig
arm                           viper_defconfig
arm                         shannon_defconfig
powerpc                     tqm8541_defconfig
sh                        sh7785lcr_defconfig
arm                          simpad_defconfig
sh                           se7722_defconfig
sh                           se7751_defconfig
arm                         assabet_defconfig
arm                         s3c2410_defconfig
parisc                           alldefconfig
powerpc                 mpc834x_mds_defconfig
powerpc                      bamboo_defconfig
powerpc                       ppc64_defconfig
arc                        nsimosci_defconfig
arm                          moxart_defconfig
sh                        edosk7705_defconfig
xtensa                  nommu_kc705_defconfig
ia64                                defconfig
mips                 decstation_r4k_defconfig
arm                       mainstone_defconfig
powerpc                 mpc8315_rdb_defconfig
sh                           se7721_defconfig
powerpc                         ps3_defconfig
sh                           se7206_defconfig
powerpc                    gamecube_defconfig
mips                      maltasmvp_defconfig
m68k                        stmark2_defconfig
x86_64                            allnoconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
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
powerpc                           allnoconfig
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
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-b001-20210603
x86_64               randconfig-a002-20210603
x86_64               randconfig-a004-20210603
x86_64               randconfig-a003-20210603
x86_64               randconfig-a006-20210603
x86_64               randconfig-a005-20210603
x86_64               randconfig-a001-20210603

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
