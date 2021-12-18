Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AD7C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 18 Dec 2021 23:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhLRXRH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 18 Dec 2021 18:17:07 -0500
Received: from mga04.intel.com ([192.55.52.120]:56578 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhLRXRH (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 18 Dec 2021 18:17:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639869427; x=1671405427;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=L1+nbShmuQ95xQjzNupA4qO9zIi+4G24PwpDl2BEKJk=;
  b=Mph8Xl2jYmDeBihRvc5PuUEBRBk0H44uSPMDBrJZlgvxO4vkER1TPoGj
   r4r2wnxgpK9c1zYfrhD4sjGG+PE5xsw+d+ds4kV+kRoXmqe8Svm+AsoFi
   ieyjk/L+l4DrqWUpchZL/OrawPn8RHm5AvNowMaDQkJBF9XXp9i9FimOF
   JRm38UjSziECOdNjL+PqgOiHp1MMXRYYwYcJKk/7ziwTUy8o/S+9qDSwx
   S3gkW0uf0kKQwGglDjjfmFSsCjt02mkjlLKsI6ZIEy+zAa1rRc8WtXHt+
   kjogFIk7uwNmyca7LcLq7hGguxUjyDhx/cEHwO6tNemBV6/TH3J6roYJS
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10202"; a="238701454"
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="238701454"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2021 15:17:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="615954303"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 18 Dec 2021 15:17:05 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1myiwq-0006V3-BP; Sat, 18 Dec 2021 23:17:04 +0000
Date:   Sun, 19 Dec 2021 07:16:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 fbcddf788fe221573a9d30acd8018db0cc6c1e89
Message-ID: <61be6bcc.qPCdirkK81JsXqnG%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: fbcddf788fe221573a9d30acd8018db0cc6c1e89  md/raid5: play nice with PREEMPT_RT

elapsed time: 826m

configs tested: 200
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211218
mips                 randconfig-c004-20211218
mips                         rt305x_defconfig
sh                      rts7751r2d1_defconfig
powerpc                    ge_imp3a_defconfig
powerpc                      bamboo_defconfig
powerpc                     ppa8548_defconfig
sh                           se7780_defconfig
powerpc                       maple_defconfig
nds32                               defconfig
arm                          simpad_defconfig
mips                        bcm63xx_defconfig
sh                           se7724_defconfig
mips                     loongson1b_defconfig
openrisc                            defconfig
powerpc                   motionpro_defconfig
powerpc                    socrates_defconfig
powerpc                      arches_defconfig
powerpc                          g5_defconfig
powerpc                 canyonlands_defconfig
arm                        trizeps4_defconfig
powerpc                      chrp32_defconfig
nios2                         10m50_defconfig
arm                          lpd270_defconfig
powerpc                 mpc8315_rdb_defconfig
mips                   sb1250_swarm_defconfig
parisc                              defconfig
m68k                        m5307c3_defconfig
mips                      malta_kvm_defconfig
um                             i386_defconfig
sparc64                             defconfig
arm                        mvebu_v7_defconfig
mips                malta_qemu_32r6_defconfig
mips                             allmodconfig
powerpc                 mpc85xx_cds_defconfig
alpha                            alldefconfig
arc                        nsim_700_defconfig
powerpc                 mpc837x_rdb_defconfig
arm                      pxa255-idp_defconfig
h8300                            alldefconfig
arm                       spear13xx_defconfig
mips                         cobalt_defconfig
mips                           ip28_defconfig
powerpc                      pasemi_defconfig
nds32                             allnoconfig
powerpc                        fsp2_defconfig
nios2                            alldefconfig
m68k                        m5407c3_defconfig
ia64                          tiger_defconfig
arm                       netwinder_defconfig
powerpc                      pmac32_defconfig
m68k                             alldefconfig
mips                         tb0219_defconfig
sparc                       sparc64_defconfig
m68k                        mvme147_defconfig
arm                  colibri_pxa270_defconfig
sh                         ecovec24_defconfig
powerpc                     pseries_defconfig
i386                                defconfig
arm                         palmz72_defconfig
ia64                         bigsur_defconfig
arm                            dove_defconfig
arm                        multi_v7_defconfig
m68k                         apollo_defconfig
m68k                         amcore_defconfig
mips                        bcm47xx_defconfig
h8300                    h8300h-sim_defconfig
mips                             allyesconfig
sh                   sh7770_generic_defconfig
arm                         mv78xx0_defconfig
powerpc                     tqm8560_defconfig
i386                             alldefconfig
sh                ecovec24-romimage_defconfig
powerpc                     tqm8548_defconfig
sh                        dreamcast_defconfig
powerpc                    adder875_defconfig
m68k                            q40_defconfig
powerpc                 mpc8313_rdb_defconfig
arm                         s5pv210_defconfig
mips                  decstation_64_defconfig
mips                  cavium_octeon_defconfig
m68k                          hp300_defconfig
xtensa                generic_kc705_defconfig
sh                          rsk7269_defconfig
arm                          pxa168_defconfig
powerpc                     taishan_defconfig
powerpc                      acadia_defconfig
xtensa                  nommu_kc705_defconfig
arm                       aspeed_g4_defconfig
sh                             espt_defconfig
parisc                           allyesconfig
powerpc                      makalu_defconfig
arc                     haps_hs_smp_defconfig
mips                          rb532_defconfig
m68k                            mac_defconfig
arc                     nsimosci_hs_defconfig
h8300                            allyesconfig
powerpc                 linkstation_defconfig
m68k                           sun3_defconfig
openrisc                    or1ksim_defconfig
arm                         s3c6400_defconfig
arm                          iop32x_defconfig
arm                         vf610m4_defconfig
arm                         assabet_defconfig
mips                      pic32mzda_defconfig
powerpc                    mvme5100_defconfig
powerpc                         ps3_defconfig
parisc                           alldefconfig
m68k                       m5208evb_defconfig
powerpc                     tqm5200_defconfig
arm                  randconfig-c002-20211218
arm                  randconfig-c002-20211219
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                             allyesconfig
s390                             allmodconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
nios2                               defconfig
arc                              allyesconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a006-20211218
x86_64               randconfig-a005-20211218
x86_64               randconfig-a001-20211218
x86_64               randconfig-a003-20211218
x86_64               randconfig-a002-20211218
x86_64               randconfig-a004-20211218
i386                 randconfig-a002-20211216
i386                 randconfig-a005-20211216
i386                 randconfig-a003-20211216
i386                 randconfig-a006-20211216
i386                 randconfig-a004-20211216
i386                 randconfig-a001-20211216
i386                 randconfig-a002-20211218
i386                 randconfig-a005-20211218
i386                 randconfig-a003-20211218
i386                 randconfig-a006-20211218
i386                 randconfig-a004-20211218
x86_64               randconfig-a005-20211216
x86_64               randconfig-a001-20211216
x86_64               randconfig-a002-20211216
x86_64               randconfig-a003-20211216
x86_64               randconfig-a004-20211216
x86_64               randconfig-a006-20211216
i386                 randconfig-a011-20211219
i386                 randconfig-a015-20211219
i386                 randconfig-a012-20211219
i386                 randconfig-a013-20211219
i386                 randconfig-a016-20211219
i386                 randconfig-a014-20211219
arc                  randconfig-r043-20211216
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a011-20211216
x86_64               randconfig-a014-20211216
x86_64               randconfig-a012-20211216
x86_64               randconfig-a013-20211216
x86_64               randconfig-a016-20211216
x86_64               randconfig-a015-20211216
x86_64               randconfig-a011-20211218
x86_64               randconfig-a015-20211218
x86_64               randconfig-a016-20211218
hexagon              randconfig-r045-20211216
s390                 randconfig-r044-20211216
riscv                randconfig-r042-20211216
hexagon              randconfig-r041-20211216

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
