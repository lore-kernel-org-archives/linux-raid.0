Return-Path: <SRS0=hplT=DP=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BCCC433E7
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 22:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F39EC22243
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 22:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbgJHWki (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Oct 2020 18:40:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:21904 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730491AbgJHWki (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 8 Oct 2020 18:40:38 -0400
IronPort-SDR: 26z3iKf8nNlI/ZRUeWXc+vwbk4IuqhVNJ4gGlZSitIk1Zuj4HaaCkWo25Nz8aqwiZjoayNLsBP
 Ymt59X54iWCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="229601372"
X-IronPort-AV: E=Sophos;i="5.77,352,1596524400"; 
   d="scan'208";a="229601372"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 15:40:36 -0700
IronPort-SDR: Oh/HIOymcB1bNtwbaUWh2CSw7U205l+8jp0J5yiFljqQv3e0pjMoE4iDHfb88fQbXuflgzvxbe
 1dMhAZwk7JAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,352,1596524400"; 
   d="scan'208";a="461968182"
Received: from lkp-server02.sh.intel.com (HELO b5ae2f167493) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 08 Oct 2020 15:40:34 -0700
Received: from kbuild by b5ae2f167493 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kQeaP-0002N6-W3; Thu, 08 Oct 2020 22:40:33 +0000
Date:   Fri, 09 Oct 2020 06:40:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 03ee70c404b671674dc365870588e3bc3733735a
Message-ID: <5f7f9544.c8lQkdTrepLbK1kw%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git  md-next
branch HEAD: 03ee70c404b671674dc365870588e3bc3733735a  md/raid5: fix oops during stripe resizing

elapsed time: 726m

configs tested: 157
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
mips                      fuloong2e_defconfig
riscv                               defconfig
powerpc                     tqm8540_defconfig
powerpc                 mpc836x_mds_defconfig
powerpc                  iss476-smp_defconfig
mips                         bigsur_defconfig
powerpc                       eiger_defconfig
mips                       rbtx49xx_defconfig
arm                           tegra_defconfig
powerpc                        icon_defconfig
powerpc                  mpc885_ads_defconfig
mips                      bmips_stb_defconfig
arm                      footbridge_defconfig
mips                malta_qemu_32r6_defconfig
arm                        magician_defconfig
sh                         ap325rxa_defconfig
powerpc                 xes_mpc85xx_defconfig
m68k                        m5307c3_defconfig
arm                             mxs_defconfig
h8300                               defconfig
nios2                               defconfig
xtensa                generic_kc705_defconfig
sh                   secureedge5410_defconfig
sh                        apsh4ad0a_defconfig
arm                       multi_v4t_defconfig
m68k                           sun3_defconfig
sh                          polaris_defconfig
arm                           sama5_defconfig
powerpc                      bamboo_defconfig
sh                         ecovec24_defconfig
m68k                             allmodconfig
arm                             ezx_defconfig
arm                  colibri_pxa300_defconfig
powerpc                       maple_defconfig
sh                          rsk7203_defconfig
sh                          urquell_defconfig
powerpc               mpc834x_itxgp_defconfig
powerpc                         ps3_defconfig
sh                 kfr2r09-romimage_defconfig
arm                           h3600_defconfig
arm                          exynos_defconfig
powerpc                     mpc512x_defconfig
parisc                           allyesconfig
arm                       omap2plus_defconfig
m68k                         apollo_defconfig
powerpc                          g5_defconfig
mips                          ath25_defconfig
i386                             alldefconfig
powerpc                 mpc834x_itx_defconfig
powerpc                     powernv_defconfig
powerpc                      mgcoge_defconfig
sh                         apsh4a3a_defconfig
mips                           mtx1_defconfig
arm                            mmp2_defconfig
sh                           sh2007_defconfig
arm                          ixp4xx_defconfig
mips                        nlm_xlp_defconfig
mips                      malta_kvm_defconfig
sh                           se7721_defconfig
s390                          debug_defconfig
s390                             alldefconfig
arm                      integrator_defconfig
c6x                        evmc6474_defconfig
arm                            qcom_defconfig
arm                             rpc_defconfig
c6x                              alldefconfig
sh                        sh7757lcr_defconfig
arm                         cm_x300_defconfig
mips                         db1xxx_defconfig
arm                       netwinder_defconfig
c6x                              allyesconfig
powerpc                    ge_imp3a_defconfig
arm                         axm55xx_defconfig
powerpc                      ep88xc_defconfig
powerpc                        warp_defconfig
powerpc                    gamecube_defconfig
alpha                            allyesconfig
i386                             allyesconfig
arm                         bcm2835_defconfig
sh                             espt_defconfig
mips                      loongson3_defconfig
mips                           ip28_defconfig
arm                        shmobile_defconfig
powerpc                      arches_defconfig
powerpc                     ksi8560_defconfig
powerpc                     ppa8548_defconfig
sh                          r7780mp_defconfig
sh                              ul2_defconfig
microblaze                          defconfig
mips                           ip22_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                                defconfig
m68k                             allyesconfig
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
s390                                defconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a004-20201008
x86_64               randconfig-a003-20201008
x86_64               randconfig-a005-20201008
x86_64               randconfig-a001-20201008
x86_64               randconfig-a002-20201008
x86_64               randconfig-a006-20201008
i386                 randconfig-a006-20201008
i386                 randconfig-a005-20201008
i386                 randconfig-a001-20201008
i386                 randconfig-a004-20201008
i386                 randconfig-a002-20201008
i386                 randconfig-a003-20201008
i386                 randconfig-a015-20201008
i386                 randconfig-a013-20201008
i386                 randconfig-a014-20201008
i386                 randconfig-a016-20201008
i386                 randconfig-a011-20201008
i386                 randconfig-a012-20201008
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                                   rhel
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a012-20201008
x86_64               randconfig-a015-20201008
x86_64               randconfig-a013-20201008
x86_64               randconfig-a014-20201008
x86_64               randconfig-a011-20201008
x86_64               randconfig-a016-20201008

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
