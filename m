Return-Path: <SRS0=zRnh=DQ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0364BC433DF
	for <linux-raid@archiver.kernel.org>; Fri,  9 Oct 2020 18:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A825B2158C
	for <linux-raid@archiver.kernel.org>; Fri,  9 Oct 2020 18:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbgJISF2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Oct 2020 14:05:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:25669 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbgJISF2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 9 Oct 2020 14:05:28 -0400
IronPort-SDR: y2mR3mqkVfySIOBDil2wkUdhuEr26Ez6+vRJijgYpC0P0Zhn8XquBWn72Pec09+C3y9Jb+srhH
 r+xMKZYZKqEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="145386949"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="145386949"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 11:05:27 -0700
IronPort-SDR: xBY3uX991iegVpJuWtjdZv/MogJGn3wgM7/gD8bOfPe1O64+7uzqUQZqoRDy52j+lXsh9Trsso
 h6EIBMRIs2Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="317117972"
Received: from lkp-server02.sh.intel.com (HELO 80eb06af76cf) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 09 Oct 2020 11:05:26 -0700
Received: from kbuild by 80eb06af76cf with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kQwlh-0000eu-D7; Fri, 09 Oct 2020 18:05:25 +0000
Date:   Sat, 10 Oct 2020 02:05:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 b44c018cdf748b96b676ba09fdbc5b34fc443ada
Message-ID: <5f80a65e.uIVemRsgS1oqs3fe%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git  md-next
branch HEAD: b44c018cdf748b96b676ba09fdbc5b34fc443ada  md/raid5: fix oops during stripe resizing

elapsed time: 724m

configs tested: 141
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
arm                              allmodconfig
arm64                               defconfig
riscv                    nommu_virt_defconfig
powerpc                      katmai_defconfig
mips                      loongson3_defconfig
s390                                defconfig
m68k                          hp300_defconfig
arc                    vdk_hs38_smp_defconfig
sparc64                          alldefconfig
arm                     am200epdkit_defconfig
arm                        magician_defconfig
powerpc                      ppc44x_defconfig
arc                          axs101_defconfig
powerpc                 mpc8540_ads_defconfig
mips                         bigsur_defconfig
arm                       imx_v6_v7_defconfig
arm                     davinci_all_defconfig
arm                           corgi_defconfig
powerpc64                           defconfig
powerpc                        fsp2_defconfig
sh                   sh7770_generic_defconfig
arm                           viper_defconfig
arm                           efm32_defconfig
sh                               allmodconfig
powerpc                 mpc8560_ads_defconfig
arm                             rpc_defconfig
m68k                          sun3x_defconfig
mips                      pistachio_defconfig
alpha                            alldefconfig
arc                         haps_hs_defconfig
ia64                        generic_defconfig
arm                          iop32x_defconfig
sh                           se7724_defconfig
arm                       aspeed_g5_defconfig
sh                           sh2007_defconfig
sh                        sh7785lcr_defconfig
sh                   rts7751r2dplus_defconfig
arm                         cm_x300_defconfig
powerpc                      walnut_defconfig
mips                     loongson1b_defconfig
sh                   secureedge5410_defconfig
arm                           omap1_defconfig
arm                         mv78xx0_defconfig
arm                         assabet_defconfig
mips                          ath25_defconfig
powerpc                      pcm030_defconfig
xtensa                    xip_kc705_defconfig
arm                          pcm027_defconfig
powerpc                   currituck_defconfig
arm                           tegra_defconfig
mips                            gpr_defconfig
arm                          collie_defconfig
arm                         nhk8815_defconfig
sh                   sh7724_generic_defconfig
arm                      tct_hammer_defconfig
powerpc                 linkstation_defconfig
m68k                            mac_defconfig
powerpc                   motionpro_defconfig
arc                        vdk_hs38_defconfig
sh                          rsk7203_defconfig
arm                        trizeps4_defconfig
mips                           ip28_defconfig
powerpc                     powernv_defconfig
m68k                         apollo_defconfig
sh                 kfr2r09-romimage_defconfig
ia64                             alldefconfig
arm                        oxnas_v6_defconfig
h8300                     edosk2674_defconfig
sh                             espt_defconfig
arm                   milbeaut_m10v_defconfig
mips                    maltaup_xpa_defconfig
arm                       spear13xx_defconfig
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
parisc                              defconfig
s390                             allyesconfig
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
i386                 randconfig-a006-20201009
i386                 randconfig-a005-20201009
i386                 randconfig-a001-20201009
i386                 randconfig-a004-20201009
i386                 randconfig-a002-20201009
i386                 randconfig-a003-20201009
x86_64               randconfig-a012-20201009
x86_64               randconfig-a015-20201009
x86_64               randconfig-a013-20201009
x86_64               randconfig-a014-20201009
x86_64               randconfig-a011-20201009
x86_64               randconfig-a016-20201009
i386                 randconfig-a015-20201009
i386                 randconfig-a013-20201009
i386                 randconfig-a014-20201009
i386                 randconfig-a016-20201009
i386                 randconfig-a011-20201009
i386                 randconfig-a012-20201009
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                                   rhel
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a004-20201009
x86_64               randconfig-a003-20201009
x86_64               randconfig-a005-20201009
x86_64               randconfig-a001-20201009
x86_64               randconfig-a002-20201009
x86_64               randconfig-a006-20201009

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
