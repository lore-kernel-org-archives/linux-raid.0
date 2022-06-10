Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D385C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Jun 2022 21:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347062AbiFJVMB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Jun 2022 17:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350839AbiFJVMA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Jun 2022 17:12:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8B149B5A
        for <linux-raid@vger.kernel.org>; Fri, 10 Jun 2022 14:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654895518; x=1686431518;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=uDpMrjBhw/rfZpop2mUPvkSUDetszwOvlAmfEBH+jhs=;
  b=ntL/hFz1aX00v1goA/qSgcgtu6KU4aVNASYGc4fkZdXQTQrCnY+Q11sA
   U7I+TLy+UCxLi0Vo9QQsbWjbwDRoZVaITL2jpEpnjAKkF92TU3dHx1QQ7
   BxHrgemj98axeRBvXBfAi+yDdahSq8qARGc1gs4aR57btexqUm3d1PfXt
   RJS0vkCAsSkwrGDyxrQ7qy1QM074XFyZs233Z8Wv5OoYxycUDYRls0Dqr
   ZhWYN6wLLmIz8rJAE4Hxaq42XZNJE27sQPDoD+TMyfHSuk0Ji1nDeoYx8
   Qw/qbkZrHs66Y9hRrvsMxHy8HW3Jct+7naefVLoP81MCEpH3vHJqOtFg7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275280200"
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="275280200"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 14:11:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="650024843"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jun 2022 14:11:52 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzlv6-000IHZ-5l;
        Fri, 10 Jun 2022 21:11:52 +0000
Date:   Sat, 11 Jun 2022 05:11:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 23ffa1d984cbf3c05655e61d59cfb27f0c7d897f
Message-ID: <62a3b37e.JSfLcS2uNMa1EG5f%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 23ffa1d984cbf3c05655e61d59cfb27f0c7d897f  Revert "md: don't unregister sync_thread with reconfig_mutex held"

elapsed time: 4138m

configs tested: 148
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                               defconfig
arm64                            allyesconfig
arm                              allmodconfig
arm                                 defconfig
arm                              allyesconfig
i386                          randconfig-c001
sh                         ap325rxa_defconfig
arc                     haps_hs_smp_defconfig
m68k                       m5475evb_defconfig
nios2                               defconfig
arc                         haps_hs_defconfig
mips                          rb532_defconfig
ia64                         bigsur_defconfig
m68k                        m5272c3_defconfig
sh                            titan_defconfig
powerpc                 mpc837x_mds_defconfig
mips                         tb0226_defconfig
sh                           se7750_defconfig
powerpc                 linkstation_defconfig
powerpc64                           defconfig
sh                          rsk7201_defconfig
powerpc                 canyonlands_defconfig
sh                          lboxre2_defconfig
m68k                          sun3x_defconfig
powerpc                 mpc8540_ads_defconfig
arc                      axs103_smp_defconfig
sparc64                             defconfig
sh                           sh2007_defconfig
arm                           viper_defconfig
mips                           ci20_defconfig
powerpc                     stx_gp3_defconfig
powerpc                     pq2fads_defconfig
powerpc                 mpc834x_itx_defconfig
mips                      fuloong2e_defconfig
sh                ecovec24-romimage_defconfig
m68k                        mvme16x_defconfig
arm                           sama5_defconfig
arm                       imx_v6_v7_defconfig
arm                         s3c6400_defconfig
arm                             ezx_defconfig
powerpc                        cell_defconfig
powerpc                      pasemi_defconfig
arm                      footbridge_defconfig
m68k                        mvme147_defconfig
powerpc                  storcenter_defconfig
mips                           xway_defconfig
openrisc                         alldefconfig
arm                          pxa3xx_defconfig
sh                              ul2_defconfig
xtensa                  cadence_csp_defconfig
sh                               alldefconfig
powerpc                      ep88xc_defconfig
um                           x86_64_defconfig
sh                   sh7770_generic_defconfig
arc                    vdk_hs38_smp_defconfig
powerpc                      ppc40x_defconfig
powerpc                      pcm030_defconfig
sh                          rsk7203_defconfig
alpha                            alldefconfig
sh                           se7619_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220608
arm                  randconfig-c002-20220609
ia64                             allmodconfig
ia64                             allyesconfig
ia64                                defconfig
riscv                             allnoconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
arc                              allyesconfig
csky                                defconfig
nios2                            allyesconfig
alpha                               defconfig
alpha                            allyesconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                                defconfig
s390                             allmodconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                             allyesconfig
sparc                               defconfig
i386                             allyesconfig
sparc                            allyesconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
riscv                               defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
powerpc                          allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
um                             i386_defconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
riscv                            allmodconfig
riscv                            allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                                  kexec
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit

clang tested configs:
powerpc              randconfig-c003-20220608
x86_64                        randconfig-c007
riscv                randconfig-c006-20220608
i386                          randconfig-c001
s390                 randconfig-c005-20220608
mips                 randconfig-c004-20220608
arm                  randconfig-c002-20220608
powerpc                        fsp2_defconfig
powerpc                          g5_defconfig
arm64                            allyesconfig
mips                        maltaup_defconfig
powerpc                       ebony_defconfig
arm                  colibri_pxa300_defconfig
powerpc                      katmai_defconfig
powerpc                 mpc832x_mds_defconfig
mips                        workpad_defconfig
powerpc                     akebono_defconfig
arm                         mv78xx0_defconfig
arm                         lpc32xx_defconfig
i386                             allyesconfig
x86_64                        randconfig-k001
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
hexagon              randconfig-r045-20220608
hexagon              randconfig-r041-20220608

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
