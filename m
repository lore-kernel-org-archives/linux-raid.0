Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F56FC432BE
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 16:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6A760F4C
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 16:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243061AbhHZQ1Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:27:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:51670 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243174AbhHZQ1X (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 26 Aug 2021 12:27:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="217816199"
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="217816199"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 09:26:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="537407789"
Received: from lkp-server01.sh.intel.com (HELO 4fbc2b3ce5aa) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 26 Aug 2021 09:26:20 -0700
Received: from kbuild by 4fbc2b3ce5aa with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mJICp-0001No-C9; Thu, 26 Aug 2021 16:26:19 +0000
Date:   Fri, 27 Aug 2021 00:25:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 9cd81ffa6546bea41d67008d4b4e0bcdad2bd5bf
Message-ID: <6127c096.MaE8qZY7BKkhXgql%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 9cd81ffa6546bea41d67008d4b4e0bcdad2bd5bf  md/raid10: Remove unnecessary rcu_dereference in raid10_handle_discard

elapsed time: 833m

configs tested: 210
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                               defconfig
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210826
mips                      bmips_stb_defconfig
powerpc                         wii_defconfig
xtensa                  cadence_csp_defconfig
arc                        nsimosci_defconfig
sh                          lboxre2_defconfig
arm                          gemini_defconfig
mips                      fuloong2e_defconfig
powerpc                       holly_defconfig
m68k                            mac_defconfig
powerpc                 mpc836x_mds_defconfig
xtensa                generic_kc705_defconfig
mips                         bigsur_defconfig
arm                      footbridge_defconfig
ia64                         bigsur_defconfig
ia64                            zx1_defconfig
powerpc                 mpc85xx_cds_defconfig
powerpc                 mpc836x_rdk_defconfig
powerpc                 mpc8272_ads_defconfig
m68k                         apollo_defconfig
xtensa                    smp_lx200_defconfig
m68k                        m5272c3_defconfig
sh                           se7780_defconfig
arm                        keystone_defconfig
mips                        vocore2_defconfig
sh                           se7721_defconfig
arm                         nhk8815_defconfig
mips                     loongson1b_defconfig
arc                 nsimosci_hs_smp_defconfig
xtensa                           alldefconfig
arm                        oxnas_v6_defconfig
arm                         hackkit_defconfig
mips                        nlm_xlr_defconfig
h8300                               defconfig
xtensa                  nommu_kc705_defconfig
arm                         s3c6400_defconfig
sh                            migor_defconfig
sh                            hp6xx_defconfig
mips                          ath79_defconfig
powerpc                     redwood_defconfig
sh                          rsk7269_defconfig
mips                  maltasmvp_eva_defconfig
ia64                                defconfig
mips                     cu1000-neo_defconfig
m68k                            q40_defconfig
powerpc                      acadia_defconfig
powerpc                     mpc83xx_defconfig
mips                      loongson3_defconfig
powerpc                     stx_gp3_defconfig
powerpc                          g5_defconfig
arm                       multi_v4t_defconfig
openrisc                    or1ksim_defconfig
powerpc                 mpc834x_itx_defconfig
mips                     loongson2k_defconfig
powerpc                      ep88xc_defconfig
powerpc                     powernv_defconfig
m68k                       m5275evb_defconfig
sh                            shmin_defconfig
sh                             shx3_defconfig
sh                     magicpanelr2_defconfig
mips                         rt305x_defconfig
openrisc                  or1klitex_defconfig
powerpc               mpc834x_itxgp_defconfig
arm                         vf610m4_defconfig
openrisc                 simple_smp_defconfig
sh                           se7705_defconfig
m68k                        m5407c3_defconfig
mips                           xway_defconfig
parisc                generic-32bit_defconfig
sh                           sh2007_defconfig
mips                           ip22_defconfig
arm                         cm_x300_defconfig
arc                        vdk_hs38_defconfig
sparc                       sparc32_defconfig
powerpc                 mpc8315_rdb_defconfig
sh                      rts7751r2d1_defconfig
powerpc                      mgcoge_defconfig
m68k                       m5249evb_defconfig
arm                          pcm027_defconfig
arm                   milbeaut_m10v_defconfig
arm                    vt8500_v6_v7_defconfig
powerpc                 mpc8540_ads_defconfig
arm                          lpd270_defconfig
arc                          axs101_defconfig
nios2                         10m50_defconfig
arm                          collie_defconfig
h8300                       h8s-sim_defconfig
sh                          urquell_defconfig
m68k                          hp300_defconfig
arm                          pxa3xx_defconfig
mips                      pic32mzda_defconfig
arm64                            alldefconfig
mips                        omega2p_defconfig
powerpc                     pq2fads_defconfig
powerpc                     taishan_defconfig
powerpc                   motionpro_defconfig
sh                             sh03_defconfig
mips                         db1xxx_defconfig
powerpc                      pasemi_defconfig
arm                             mxs_defconfig
powerpc                     tqm8555_defconfig
powerpc                        warp_defconfig
mips                        qi_lb60_defconfig
sh                        edosk7760_defconfig
powerpc                      ppc64e_defconfig
mips                        bcm47xx_defconfig
powerpc                      ppc40x_defconfig
arm                        multi_v5_defconfig
powerpc                 mpc832x_rdb_defconfig
arm                           h3600_defconfig
mips                         tb0226_defconfig
m68k                           sun3_defconfig
arm                          ixp4xx_defconfig
x86_64                            allnoconfig
ia64                             allmodconfig
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
x86_64               randconfig-a005-20210826
x86_64               randconfig-a006-20210826
x86_64               randconfig-a001-20210826
x86_64               randconfig-a003-20210826
x86_64               randconfig-a004-20210826
x86_64               randconfig-a002-20210826
i386                 randconfig-a006-20210826
i386                 randconfig-a001-20210826
i386                 randconfig-a002-20210826
i386                 randconfig-a005-20210826
i386                 randconfig-a003-20210826
i386                 randconfig-a004-20210826
x86_64               randconfig-a014-20210825
x86_64               randconfig-a015-20210825
x86_64               randconfig-a016-20210825
x86_64               randconfig-a013-20210825
x86_64               randconfig-a012-20210825
x86_64               randconfig-a011-20210825
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
i386                 randconfig-c001-20210826
s390                 randconfig-c005-20210826
arm                  randconfig-c002-20210826
riscv                randconfig-c006-20210826
powerpc              randconfig-c003-20210826
x86_64               randconfig-c007-20210826
mips                 randconfig-c004-20210826
x86_64               randconfig-a014-20210826
x86_64               randconfig-a015-20210826
x86_64               randconfig-a016-20210826
x86_64               randconfig-a013-20210826
x86_64               randconfig-a012-20210826
x86_64               randconfig-a011-20210826
i386                 randconfig-a011-20210826
i386                 randconfig-a016-20210826
i386                 randconfig-a012-20210826
i386                 randconfig-a014-20210826
i386                 randconfig-a013-20210826
i386                 randconfig-a015-20210826
x86_64               randconfig-a005-20210825
x86_64               randconfig-a001-20210825
x86_64               randconfig-a006-20210825
x86_64               randconfig-a003-20210825
x86_64               randconfig-a004-20210825
x86_64               randconfig-a002-20210825
hexagon              randconfig-r041-20210826
hexagon              randconfig-r045-20210826
riscv                randconfig-r042-20210826
s390                 randconfig-r044-20210826

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
