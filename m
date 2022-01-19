Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C126C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jan 2022 14:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355097AbiASORb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jan 2022 09:17:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:22662 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354883AbiASORa (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Jan 2022 09:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642601850; x=1674137850;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=G1GJV4+2LvYm9lv1zK2zAoNW29UdRXy3C8oT9Lcw6hc=;
  b=jIxYoZ/JgKJmzR6qQnA8j/yiEDeAyYjm3ZgzvL6t7jSrvVeT8Wh0s/VM
   tutwwPH+rdxMZNzCr0OOEUqmRgsI1wof/g+Yh96fshHwtJ6+mrDN2J0HT
   8PJzMh6yi2LPNwougbr5+zchGx6Yv0eMxK1KabeKDDUxaIbHM+4x3PEwS
   jfXeNR2SGiHPucxCrWPUs5YpUyT1lc4SCDR59nPNE6M8ihZOAerawn3uV
   sl932i5XbvViuJLOx+AlsRwrw/YXPrK+DzMMUE6uhf4B2NVrlnWPhEZYQ
   GMx/fNd0XjC4Vqfk+F2QWCKNrL49UTq6J+c2B4VvGVfYw+pLaAhp1Bo8J
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="308415168"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="308415168"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 06:17:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="625898816"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 19 Jan 2022 06:17:29 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nABmC-000DYz-B7; Wed, 19 Jan 2022 14:17:28 +0000
Date:   Wed, 19 Jan 2022 22:16:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 78eb08ba82684b559276b30ae7e434053bb584f5
Message-ID: <61e81d57.WQRmqXsOVve17Ni/%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 78eb08ba82684b559276b30ae7e434053bb584f5  md: raid1/raid10: drop pending_cnt

elapsed time: 724m

configs tested: 155
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20220117
mips                 randconfig-c004-20220117
powerpc              randconfig-c003-20220118
i386                          randconfig-c001
powerpc              randconfig-c003-20220117
m68k                          atari_defconfig
sh                            shmin_defconfig
mips                  decstation_64_defconfig
sh                          sdk7786_defconfig
arm                      footbridge_defconfig
csky                                defconfig
powerpc                  iss476-smp_defconfig
mips                        bcm47xx_defconfig
h8300                    h8300h-sim_defconfig
sh                          rsk7201_defconfig
arm                       omap2plus_defconfig
arm                         axm55xx_defconfig
arc                        vdk_hs38_defconfig
sh                        dreamcast_defconfig
sh                     sh7710voipgw_defconfig
arm                        multi_v7_defconfig
mips                       bmips_be_defconfig
sh                     magicpanelr2_defconfig
m68k                          hp300_defconfig
powerpc                      chrp32_defconfig
xtensa                         virt_defconfig
powerpc                        cell_defconfig
nios2                         3c120_defconfig
powerpc                     rainier_defconfig
powerpc                       ppc64_defconfig
sh                           se7721_defconfig
sh                          r7780mp_defconfig
mips                      maltasmvp_defconfig
arm                       imx_v6_v7_defconfig
arm                           tegra_defconfig
arm                  randconfig-c002-20220116
arm                  randconfig-c002-20220117
arm                  randconfig-c002-20220118
arm                  randconfig-c002-20220119
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                                defconfig
m68k                             allmodconfig
m68k                             allyesconfig
nds32                             allnoconfig
nios2                               defconfig
arc                              allyesconfig
nds32                               defconfig
nios2                            allyesconfig
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
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                             allyesconfig
sparc                               defconfig
sparc                            allyesconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a016-20220117
x86_64               randconfig-a012-20220117
x86_64               randconfig-a013-20220117
x86_64               randconfig-a011-20220117
x86_64               randconfig-a014-20220117
x86_64               randconfig-a015-20220117
i386                 randconfig-a012-20220117
i386                 randconfig-a016-20220117
i386                 randconfig-a014-20220117
i386                 randconfig-a015-20220117
i386                 randconfig-a011-20220117
i386                 randconfig-a013-20220117
riscv                randconfig-r042-20220119
riscv                randconfig-r042-20220117
arc                  randconfig-r043-20220116
arc                  randconfig-r043-20220117
s390                 randconfig-r044-20220119
s390                 randconfig-r044-20220117
arc                  randconfig-r043-20220118
arc                  randconfig-r043-20220119
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
arm                  randconfig-c002-20220116
x86_64                        randconfig-c007
arm                  randconfig-c002-20220118
arm                  randconfig-c002-20220119
riscv                randconfig-c006-20220119
riscv                randconfig-c006-20220118
riscv                randconfig-c006-20220116
powerpc              randconfig-c003-20220116
powerpc              randconfig-c003-20220119
powerpc              randconfig-c003-20220118
i386                          randconfig-c001
s390                 randconfig-c005-20220119
mips                 randconfig-c004-20220119
mips                 randconfig-c004-20220116
arm                                 defconfig
riscv                            alldefconfig
arm                            mmp2_defconfig
arm                       imx_v4_v5_defconfig
powerpc                     kilauea_defconfig
powerpc                      pmac32_defconfig
i386                             allyesconfig
powerpc               mpc834x_itxgp_defconfig
mips                      pic32mzda_defconfig
mips                        omega2p_defconfig
mips                        bcm63xx_defconfig
powerpc                      ppc64e_defconfig
x86_64               randconfig-a001-20220117
x86_64               randconfig-a002-20220117
x86_64               randconfig-a003-20220117
x86_64               randconfig-a005-20220117
x86_64               randconfig-a004-20220117
x86_64               randconfig-a006-20220117
i386                 randconfig-a005-20220117
i386                 randconfig-a001-20220117
i386                 randconfig-a006-20220117
i386                 randconfig-a004-20220117
i386                 randconfig-a002-20220117
i386                 randconfig-a003-20220117
riscv                randconfig-r042-20220118
hexagon              randconfig-r045-20220116
hexagon              randconfig-r045-20220117
hexagon              randconfig-r045-20220118
hexagon              randconfig-r045-20220119
riscv                randconfig-r042-20220116
hexagon              randconfig-r041-20220118
hexagon              randconfig-r041-20220119
s390                 randconfig-r044-20220118
s390                 randconfig-r044-20220116
hexagon              randconfig-r041-20220116
hexagon              randconfig-r041-20220117

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
