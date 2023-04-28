Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F588C77B61
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 07:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345473AbjD1H32 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Apr 2023 03:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345251AbjD1H31 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Apr 2023 03:29:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4F72689
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 00:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682666966; x=1714202966;
  h=date:from:to:cc:subject:message-id;
  bh=4wGzX8GqCXD5disAAdudHm7aYQjpc0uYdJ+aUBZKnZo=;
  b=Iqi4QSh3yANGzDsYGT4x984NXCSKfzG6d2G4JujVgSYIfYRA2BCjGrvB
   aOMjhTZsYkdY1+6qUU6fCtgbV2Yk8Q8GjAsaiYT5RgudFtbdcx7rVA0Ga
   dfJQ3KIx6tQdPzaKy9z3I336dZLSUTuE9Z4ZIYBijvBCDm5WbE934BKtH
   D8+EZopi09o6LxfA2VWx2T6FrMUSUCo8z2czuZqyNNr0SczLNup9PEUKB
   ihwtLVFiZDw+GmbNGlRyJzEU1vjlINPLs+nmRZtVGWdgHl5umh5OBnqLH
   nN2BxuhmIkQk+yHoXjturmNg+zAO5VL19/2zgl3Uth0UyOVKWY+cB2uZC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349697972"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="349697972"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 00:29:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="672056983"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="672056983"
Received: from lkp-server01.sh.intel.com (HELO 5bad9d2b7fcb) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 28 Apr 2023 00:29:24 -0700
Received: from kbuild by 5bad9d2b7fcb with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1psIXj-0000Fa-37;
        Fri, 28 Apr 2023 07:29:23 +0000
Date:   Fri, 28 Apr 2023 15:28:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 8954851c1cf45538d2f2d12e1fbfc8e525bec54c
Message-ID: <20230428072854.wAhh8%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 8954851c1cf45538d2f2d12e1fbfc8e525bec54c  md: Fix bitmap offset type in sb writer

elapsed time: 725m

configs tested: 121
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r004-20230427   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r025-20230427   gcc  
arc                  randconfig-r043-20230427   gcc  
arc                    vdk_hs38_smp_defconfig   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                          collie_defconfig   clang
arm                                 defconfig   gcc  
arm                  randconfig-r046-20230427   gcc  
arm                           u8500_defconfig   gcc  
arm                         vf610m4_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky         buildonly-randconfig-r003-20230427   gcc  
csky         buildonly-randconfig-r004-20230427   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r015-20230427   gcc  
hexagon              randconfig-r012-20230427   clang
hexagon              randconfig-r041-20230427   clang
hexagon              randconfig-r045-20230427   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                          randconfig-a001   gcc  
i386                          randconfig-a002   clang
i386                          randconfig-a003   gcc  
i386                          randconfig-a004   clang
i386                          randconfig-a005   gcc  
i386                          randconfig-a006   clang
i386                          randconfig-a011   clang
i386                          randconfig-a012   gcc  
i386                          randconfig-a013   clang
i386                          randconfig-a014   gcc  
i386                          randconfig-a015   clang
i386                          randconfig-a016   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r011-20230427   gcc  
ia64                 randconfig-r022-20230427   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r001-20230427   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                            q40_defconfig   gcc  
microblaze   buildonly-randconfig-r002-20230427   gcc  
microblaze           randconfig-r016-20230427   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r002-20230427   clang
mips                 randconfig-r014-20230427   gcc  
nios2                               defconfig   gcc  
openrisc     buildonly-randconfig-r005-20230427   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r024-20230427   gcc  
parisc               randconfig-r036-20230427   gcc  
parisc64                            defconfig   gcc  
powerpc                    adder875_defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                    amigaone_defconfig   gcc  
powerpc                    gamecube_defconfig   clang
powerpc                    ge_imp3a_defconfig   clang
powerpc                 mpc8272_ads_defconfig   clang
powerpc                 mpc836x_mds_defconfig   clang
powerpc                 mpc85xx_cds_defconfig   gcc  
powerpc                     tqm5200_defconfig   clang
powerpc                      walnut_defconfig   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r013-20230427   clang
riscv                randconfig-r042-20230427   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r031-20230427   gcc  
s390                 randconfig-r044-20230427   clang
sh                               allmodconfig   gcc  
sh                ecovec24-romimage_defconfig   gcc  
sh                   randconfig-r003-20230427   gcc  
sh                            titan_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r006-20230427   gcc  
sparc                randconfig-r032-20230427   gcc  
sparc                randconfig-r034-20230427   gcc  
sparc64                             defconfig   gcc  
sparc64              randconfig-r021-20230427   gcc  
sparc64              randconfig-r026-20230427   gcc  
sparc64              randconfig-r035-20230427   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                        randconfig-a001   clang
x86_64                        randconfig-a002   gcc  
x86_64                        randconfig-a003   clang
x86_64                        randconfig-a004   gcc  
x86_64                        randconfig-a005   clang
x86_64                        randconfig-a006   gcc  
x86_64                        randconfig-a011   gcc  
x86_64                        randconfig-a012   clang
x86_64                        randconfig-a013   gcc  
x86_64                        randconfig-a014   clang
x86_64                        randconfig-a015   gcc  
x86_64                        randconfig-a016   clang
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r006-20230427   gcc  
xtensa                  nommu_kc705_defconfig   gcc  
xtensa               randconfig-r005-20230427   gcc  
xtensa               randconfig-r023-20230427   gcc  
xtensa               randconfig-r033-20230427   gcc  
xtensa                         virt_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
