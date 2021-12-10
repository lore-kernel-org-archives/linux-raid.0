Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FB6C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 06:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbhLJGKG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 01:10:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:52720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236851AbhLJGKE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 10 Dec 2021 01:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639116389; x=1670652389;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=9Ds9/Mh/D2xcTlQCmnTnWciUqJQV6e12CG1tLD0P/y4=;
  b=bJapBwxc2k0FJ3Yd4ylR13lrLnnfU8wWW/hkx+dvY36x+e/m0RexjE++
   IfeWx+ZEr+O6hByqcq1MTrhS3/obG2ZN91aQg00oZfZDhaX2cakmc1nPm
   EVcmfZOY0C4iaPwG2QAIcCUcfyfkE3+u+ksPyovm+otNeXxwqWdA9wsZg
   /gRvoTM8PRRKyDF4vxjSfXeI1wh5nRhi2fn6LrTXF7K368dLxUOVlAwuy
   HdQ96tnfTx82XZS/q8+FooAqyc6dOiTc+aZAuBxhob2mMRvxq7UR4kNbU
   toOg54wewXtJaLYpEtOvJf9L+hZpZSth2oIbxicYJsgtgA1nXmmciwC09
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="235795296"
X-IronPort-AV: E=Sophos;i="5.88,194,1635231600"; 
   d="scan'208";a="235795296"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 22:05:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,194,1635231600"; 
   d="scan'208";a="463551425"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2021 22:05:55 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mvZ2Y-0002qE-MF; Fri, 10 Dec 2021 06:05:54 +0000
Date:   Fri, 10 Dec 2021 14:04:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 2cdf0f5a99027acd9d5c43196cabc77d1b9f3b3b
Message-ID: <61b2ee05.vciG0CgscDf43LmR%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 2cdf0f5a99027acd9d5c43196cabc77d1b9f3b3b  md: fix double free of mddev->private in autorun_array()

elapsed time: 753m

configs tested: 181
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211210
i386                 randconfig-c001-20211209
m68k                          hp300_defconfig
powerpc                    ge_imp3a_defconfig
arm                     eseries_pxa_defconfig
csky                             alldefconfig
sparc64                             defconfig
mips                         cobalt_defconfig
powerpc                    socrates_defconfig
sh                          r7780mp_defconfig
m68k                       m5208evb_defconfig
sh                          sdk7780_defconfig
mips                        qi_lb60_defconfig
m68k                          amiga_defconfig
powerpc                           allnoconfig
mips                           ip28_defconfig
sh                          polaris_defconfig
nios2                         10m50_defconfig
powerpc                     asp8347_defconfig
mips                        vocore2_defconfig
powerpc                    sam440ep_defconfig
powerpc                      tqm8xx_defconfig
m68k                        m5307c3_defconfig
arm                             mxs_defconfig
sh                        apsh4ad0a_defconfig
alpha                            allyesconfig
powerpc                 mpc834x_mds_defconfig
powerpc                     kilauea_defconfig
powerpc                      makalu_defconfig
sh                          lboxre2_defconfig
sh                           se7712_defconfig
arm                             rpc_defconfig
sparc                       sparc32_defconfig
sh                  sh7785lcr_32bit_defconfig
powerpc                 xes_mpc85xx_defconfig
nds32                             allnoconfig
sh                           se7705_defconfig
powerpc                      mgcoge_defconfig
sh                          sdk7786_defconfig
arm                           sama7_defconfig
sh                          rsk7201_defconfig
arm                        multi_v5_defconfig
powerpc                     redwood_defconfig
sh                          rsk7269_defconfig
arm                           sama5_defconfig
sh                        sh7763rdp_defconfig
powerpc                     rainier_defconfig
arm                            dove_defconfig
nds32                               defconfig
m68k                         apollo_defconfig
arm                     am200epdkit_defconfig
mips                         mpc30x_defconfig
powerpc                 canyonlands_defconfig
powerpc                      pcm030_defconfig
arm                        keystone_defconfig
xtensa                              defconfig
powerpc                     ppa8548_defconfig
m68k                             alldefconfig
mips                         db1xxx_defconfig
um                             i386_defconfig
arm                      jornada720_defconfig
arm                             pxa_defconfig
m68k                        m5407c3_defconfig
powerpc                        warp_defconfig
riscv             nommu_k210_sdcard_defconfig
arm                           tegra_defconfig
powerpc                 mpc836x_mds_defconfig
mips                     loongson1b_defconfig
sh                             sh03_defconfig
arm                      integrator_defconfig
powerpc                      chrp32_defconfig
um                           x86_64_defconfig
arm                       spear13xx_defconfig
arm                          pxa168_defconfig
openrisc                 simple_smp_defconfig
powerpc                      ppc44x_defconfig
arm                  randconfig-c002-20211210
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
nios2                               defconfig
arc                              allyesconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
arc                                 defconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
x86_64               randconfig-a001-20211209
x86_64               randconfig-a002-20211209
x86_64               randconfig-a004-20211209
x86_64               randconfig-a003-20211209
x86_64               randconfig-a006-20211209
x86_64               randconfig-a005-20211209
i386                 randconfig-a001-20211210
i386                 randconfig-a002-20211210
i386                 randconfig-a005-20211210
i386                 randconfig-a003-20211210
i386                 randconfig-a006-20211210
i386                 randconfig-a004-20211210
i386                 randconfig-a001-20211209
i386                 randconfig-a005-20211209
i386                 randconfig-a003-20211209
i386                 randconfig-a002-20211209
i386                 randconfig-a006-20211209
i386                 randconfig-a004-20211209
x86_64               randconfig-a006-20211210
x86_64               randconfig-a005-20211210
x86_64               randconfig-a001-20211210
x86_64               randconfig-a002-20211210
x86_64               randconfig-a003-20211210
x86_64               randconfig-a004-20211210
arc                  randconfig-r043-20211209
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
arm                  randconfig-c002-20211210
x86_64               randconfig-c007-20211210
riscv                randconfig-c006-20211210
mips                 randconfig-c004-20211210
i386                 randconfig-c001-20211210
s390                 randconfig-c005-20211210
powerpc              randconfig-c003-20211210
x86_64               randconfig-a011-20211210
x86_64               randconfig-a012-20211210
x86_64               randconfig-a014-20211210
x86_64               randconfig-a013-20211210
x86_64               randconfig-a016-20211210
x86_64               randconfig-a015-20211210
i386                 randconfig-a013-20211210
i386                 randconfig-a011-20211210
i386                 randconfig-a016-20211210
i386                 randconfig-a014-20211210
i386                 randconfig-a015-20211210
i386                 randconfig-a012-20211210
i386                 randconfig-a013-20211209
i386                 randconfig-a011-20211209
i386                 randconfig-a014-20211209
i386                 randconfig-a012-20211209
i386                 randconfig-a016-20211209
i386                 randconfig-a015-20211209
hexagon              randconfig-r045-20211210
riscv                randconfig-r042-20211210
s390                 randconfig-r044-20211210
hexagon              randconfig-r041-20211210
s390                 randconfig-r044-20211209
hexagon              randconfig-r041-20211209
hexagon              randconfig-r045-20211209
riscv                randconfig-r042-20211209

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
