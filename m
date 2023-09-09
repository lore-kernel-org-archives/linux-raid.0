Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF19EEB57C
	for <linux-raid@archiver.kernel.org>; Sat,  9 Sep 2023 09:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244238AbjIIJ3J (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Sep 2023 05:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjIIJ3I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Sep 2023 05:29:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC2A10F9
        for <linux-raid@vger.kernel.org>; Sat,  9 Sep 2023 02:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694251743; x=1725787743;
  h=date:from:to:cc:subject:message-id;
  bh=vYbTxhppIgbCzVdK4aZ71gTe7vUBq8EDlepzMGSMJ1M=;
  b=nWK6Nm0xJBEumSiqDSY2ZnlbHOZ97jfTliwCsU5YMoNViSLBNobqGE21
   udnzZKKy9AFDgXeetgI5b74W2+AGV7REft9MqVbZx62ORe8WYhkQBgQKK
   VKkASOmOIvfeWUS1nEBZ/2mqpNfAYTtghfXI84YWrBSww2SkDevOv0AnL
   CcfclK3nosroB5gwuM9RfDNGcN7qN3riHntQovhR/QHIrP4qAmKFuPN9P
   4Uw+a3EMwYcMvb6VeLCuU8OWJmljvyGCaOMl2+nKjfjZqQ5SBrZ3R7Rrc
   zCZLj0uYf8b4FcCAhI/9pgYTTJ69qrfEdlZdAkFN6ZPAc0G+sEJTGhjwK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="357273719"
X-IronPort-AV: E=Sophos;i="6.02,239,1688454000"; 
   d="scan'208";a="357273719"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2023 02:29:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="832929643"
X-IronPort-AV: E=Sophos;i="6.02,239,1688454000"; 
   d="scan'208";a="832929643"
Received: from lkp-server01.sh.intel.com (HELO 59b3c6e06877) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Sep 2023 02:29:02 -0700
Received: from kbuild by 59b3c6e06877 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qeuGy-0003Ef-1G;
        Sat, 09 Sep 2023 09:29:00 +0000
Date:   Sat, 09 Sep 2023 17:28:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 99892147f028d711f9d40fefad4f33632593864c
Message-ID: <202309091738.3sAqI44G-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 99892147f028d711f9d40fefad4f33632593864c  md: fix warning for holder mismatch from export_rdev()

elapsed time: 724m

configs tested: 209
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r004-20230909   gcc  
alpha                randconfig-r014-20230909   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                        nsim_700_defconfig   gcc  
arc                   randconfig-001-20230909   gcc  
arc                  randconfig-r024-20230909   gcc  
arc                  randconfig-r032-20230909   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                          exynos_defconfig   gcc  
arm                           h3600_defconfig   gcc  
arm                   milbeaut_m10v_defconfig   clang
arm                   randconfig-001-20230909   clang
arm                  randconfig-r034-20230909   gcc  
arm                  randconfig-r035-20230909   gcc  
arm                        shmobile_defconfig   gcc  
arm                           spitz_defconfig   clang
arm                         vf610m4_defconfig   gcc  
arm64                            allmodconfig   gcc  
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r011-20230909   gcc  
arm64                randconfig-r013-20230909   gcc  
arm64                randconfig-r014-20230909   gcc  
arm64                randconfig-r015-20230909   gcc  
arm64                randconfig-r025-20230909   gcc  
arm64                randconfig-r026-20230909   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r001-20230909   gcc  
hexagon               randconfig-001-20230909   clang
hexagon               randconfig-002-20230909   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20230909   clang
i386         buildonly-randconfig-002-20230909   clang
i386         buildonly-randconfig-003-20230909   clang
i386         buildonly-randconfig-004-20230909   clang
i386         buildonly-randconfig-005-20230909   clang
i386         buildonly-randconfig-006-20230909   clang
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                  randconfig-001-20230909   clang
i386                  randconfig-002-20230909   clang
i386                  randconfig-003-20230909   clang
i386                  randconfig-004-20230909   clang
i386                  randconfig-005-20230909   clang
i386                  randconfig-006-20230909   clang
i386                  randconfig-011-20230909   gcc  
i386                  randconfig-012-20230909   gcc  
i386                  randconfig-013-20230909   gcc  
i386                  randconfig-014-20230909   gcc  
i386                  randconfig-015-20230909   gcc  
i386                  randconfig-016-20230909   gcc  
i386                 randconfig-r025-20230909   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20230909   gcc  
loongarch            randconfig-r002-20230909   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r002-20230909   gcc  
m68k                 randconfig-r005-20230909   gcc  
m68k                 randconfig-r006-20230909   gcc  
m68k                 randconfig-r031-20230909   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
microblaze           randconfig-r003-20230909   gcc  
microblaze           randconfig-r014-20230909   gcc  
microblaze           randconfig-r026-20230909   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                       bmips_be_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r005-20230909   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc             randconfig-r015-20230909   gcc  
openrisc             randconfig-r033-20230909   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r016-20230909   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   gcc  
powerpc                        cell_defconfig   gcc  
powerpc                    klondike_defconfig   gcc  
powerpc                    mvme5100_defconfig   clang
powerpc                      pasemi_defconfig   gcc  
powerpc                      ppc44x_defconfig   clang
powerpc              randconfig-r023-20230909   gcc  
powerpc                  storcenter_defconfig   gcc  
powerpc                     tqm8555_defconfig   gcc  
powerpc64            randconfig-r016-20230909   gcc  
powerpc64            randconfig-r036-20230909   clang
riscv                            alldefconfig   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                 randconfig-001-20230909   clang
riscv                randconfig-r001-20230909   clang
riscv                randconfig-r012-20230909   gcc  
riscv                          rv32_defconfig   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20230909   gcc  
s390                 randconfig-r032-20230909   clang
s390                 randconfig-r036-20230909   clang
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                            hp6xx_defconfig   gcc  
sh                   randconfig-r003-20230909   gcc  
sh                   randconfig-r013-20230909   gcc  
sh                           se7619_defconfig   gcc  
sh                   secureedge5410_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r011-20230909   gcc  
sparc                randconfig-r024-20230909   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64              randconfig-r012-20230909   gcc  
sparc64              randconfig-r021-20230909   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-001-20230909   clang
x86_64       buildonly-randconfig-002-20230909   clang
x86_64       buildonly-randconfig-003-20230909   clang
x86_64       buildonly-randconfig-004-20230909   clang
x86_64       buildonly-randconfig-005-20230909   clang
x86_64       buildonly-randconfig-006-20230909   clang
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                randconfig-001-20230909   gcc  
x86_64                randconfig-002-20230909   gcc  
x86_64                randconfig-003-20230909   gcc  
x86_64                randconfig-004-20230909   gcc  
x86_64                randconfig-005-20230909   gcc  
x86_64                randconfig-006-20230909   gcc  
x86_64                randconfig-011-20230909   clang
x86_64                randconfig-012-20230909   clang
x86_64                randconfig-013-20230909   clang
x86_64                randconfig-014-20230909   clang
x86_64                randconfig-015-20230909   clang
x86_64                randconfig-016-20230909   clang
x86_64                randconfig-071-20230909   clang
x86_64                randconfig-072-20230909   clang
x86_64                randconfig-073-20230909   clang
x86_64                randconfig-074-20230909   clang
x86_64                randconfig-075-20230909   clang
x86_64                randconfig-076-20230909   clang
x86_64               randconfig-r012-20230909   gcc  
x86_64               randconfig-r021-20230909   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-func   gcc  
x86_64                    rhel-8.3-kselftests   gcc  
x86_64                         rhel-8.3-kunit   gcc  
x86_64                           rhel-8.3-ltp   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                           alldefconfig   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                  cadence_csp_defconfig   gcc  
xtensa               randconfig-r013-20230909   gcc  
xtensa               randconfig-r015-20230909   gcc  
xtensa               randconfig-r016-20230909   gcc  
xtensa               randconfig-r022-20230909   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
