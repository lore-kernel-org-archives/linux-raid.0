Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3F3C71145
	for <linux-raid@archiver.kernel.org>; Thu, 24 Aug 2023 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241176AbjHXL7m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbjHXL7Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Aug 2023 07:59:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068EC1993
        for <linux-raid@vger.kernel.org>; Thu, 24 Aug 2023 04:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692878361; x=1724414361;
  h=date:from:to:cc:subject:message-id;
  bh=rnTrSuzHkwVFEQ+c7ZUs5fK5hVjhgqru+tAzkNm0VPc=;
  b=X/xXwqstMPs+77727yYeV5xBWm9X6yhSlF/U7jt0pbfOswgagJaNOSeP
   RJFv5IdVU2PtJ5qKHjZdymzYXXEho1aFKPkT6iq0TRaFdq7FqEeaLP+Nw
   K9jNftOS3/yRiCDo8fi9ff8Ob004lXzXpz3PCSrTTAGEU3CmdUnkfecp2
   KFMwYJG+MomjYL7kJ20U2dXP0M+05JhNG2wT4JO74N5T1gCaEUMCWRyA5
   PgO4zS99wGkpwP0xjBO69hlhvWYH3N18PK9VltFiyxZUreN5cIW+dcbi4
   SNn6STjgYc0g8Y8bSP41tvxD+0S6ExuZlxWdlcgSwftirJlpAMhDS6MEg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="371824692"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="371824692"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 04:59:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="910879067"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="910879067"
Received: from lkp-server02.sh.intel.com (HELO daf8bb0a381d) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2023 04:59:18 -0700
Received: from kbuild by daf8bb0a381d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qZ8ze-0002Hu-0M;
        Thu, 24 Aug 2023 11:59:18 +0000
Date:   Thu, 24 Aug 2023 19:58:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 851e06297f20bbd85c93bbf09469f2150d1db218
Message-ID: <202308241931.8dl2iokj-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 851e06297f20bbd85c93bbf09469f2150d1db218  ublk: zoned: support REQ_OP_ZONE_RESET_ALL

elapsed time: 4831m

configs tested: 370
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r012-20230822   gcc  
alpha                randconfig-r013-20230822   gcc  
alpha                randconfig-r022-20230822   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                        nsimosci_defconfig   gcc  
arc                   randconfig-001-20230822   gcc  
arc                   randconfig-001-20230823   gcc  
arc                  randconfig-r011-20230822   gcc  
arc                  randconfig-r012-20230823   gcc  
arc                  randconfig-r021-20230822   gcc  
arc                  randconfig-r024-20230822   gcc  
arc                  randconfig-r026-20230822   gcc  
arc                  randconfig-r035-20230823   gcc  
arc                  randconfig-r036-20230822   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                              allyesconfig   gcc  
arm                         assabet_defconfig   gcc  
arm                         at91_dt_defconfig   gcc  
arm                                 defconfig   gcc  
arm                           h3600_defconfig   gcc  
arm                         lpc18xx_defconfig   gcc  
arm                        neponset_defconfig   clang
arm                       netwinder_defconfig   gcc  
arm                           omap1_defconfig   clang
arm                          pxa910_defconfig   gcc  
arm                            qcom_defconfig   gcc  
arm                   randconfig-001-20230821   clang
arm                   randconfig-001-20230822   gcc  
arm                  randconfig-r006-20230822   clang
arm                  randconfig-r014-20230822   gcc  
arm                  randconfig-r022-20230821   clang
arm                  randconfig-r025-20230822   gcc  
arm                  randconfig-r026-20230821   clang
arm                  randconfig-r035-20230822   clang
arm                           sama5_defconfig   gcc  
arm                         wpcm450_defconfig   gcc  
arm64                            allmodconfig   gcc  
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r015-20230823   gcc  
arm64                randconfig-r032-20230822   gcc  
arm64                randconfig-r033-20230822   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r003-20230822   gcc  
csky                 randconfig-r006-20230822   gcc  
csky                 randconfig-r012-20230822   gcc  
csky                 randconfig-r016-20230822   gcc  
csky                 randconfig-r026-20230822   gcc  
hexagon               randconfig-001-20230821   clang
hexagon               randconfig-001-20230822   clang
hexagon               randconfig-002-20230821   clang
hexagon               randconfig-002-20230822   clang
hexagon              randconfig-r005-20230823   clang
hexagon              randconfig-r033-20230822   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20230821   clang
i386         buildonly-randconfig-001-20230822   gcc  
i386         buildonly-randconfig-001-20230823   clang
i386         buildonly-randconfig-002-20230821   clang
i386         buildonly-randconfig-002-20230822   gcc  
i386         buildonly-randconfig-002-20230823   clang
i386         buildonly-randconfig-003-20230821   clang
i386         buildonly-randconfig-003-20230822   gcc  
i386         buildonly-randconfig-003-20230823   clang
i386         buildonly-randconfig-004-20230821   clang
i386         buildonly-randconfig-004-20230822   gcc  
i386         buildonly-randconfig-004-20230823   clang
i386         buildonly-randconfig-005-20230821   clang
i386         buildonly-randconfig-005-20230822   gcc  
i386         buildonly-randconfig-005-20230823   clang
i386         buildonly-randconfig-006-20230821   clang
i386         buildonly-randconfig-006-20230822   gcc  
i386         buildonly-randconfig-006-20230823   clang
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                  randconfig-001-20230821   clang
i386                  randconfig-001-20230822   gcc  
i386                  randconfig-001-20230823   clang
i386                  randconfig-002-20230821   clang
i386                  randconfig-002-20230822   gcc  
i386                  randconfig-002-20230823   clang
i386                  randconfig-003-20230821   clang
i386                  randconfig-003-20230822   gcc  
i386                  randconfig-003-20230823   clang
i386                  randconfig-004-20230821   clang
i386                  randconfig-004-20230822   gcc  
i386                  randconfig-004-20230823   clang
i386                  randconfig-005-20230821   clang
i386                  randconfig-005-20230822   gcc  
i386                  randconfig-005-20230823   clang
i386                  randconfig-006-20230821   clang
i386                  randconfig-006-20230822   gcc  
i386                  randconfig-006-20230823   clang
i386                  randconfig-011-20230821   gcc  
i386                  randconfig-011-20230822   clang
i386                  randconfig-011-20230823   gcc  
i386                  randconfig-012-20230821   gcc  
i386                  randconfig-012-20230822   clang
i386                  randconfig-012-20230823   gcc  
i386                  randconfig-013-20230821   gcc  
i386                  randconfig-013-20230822   clang
i386                  randconfig-013-20230823   gcc  
i386                  randconfig-014-20230821   gcc  
i386                  randconfig-014-20230822   clang
i386                  randconfig-014-20230823   gcc  
i386                  randconfig-015-20230821   gcc  
i386                  randconfig-015-20230822   clang
i386                  randconfig-015-20230823   gcc  
i386                  randconfig-016-20230821   gcc  
i386                  randconfig-016-20230822   clang
i386                  randconfig-016-20230823   gcc  
i386                 randconfig-r004-20230822   gcc  
i386                 randconfig-r005-20230822   gcc  
i386                 randconfig-r022-20230823   gcc  
i386                 randconfig-r031-20230822   gcc  
i386                 randconfig-r032-20230822   gcc  
i386                 randconfig-r033-20230822   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20230821   gcc  
loongarch             randconfig-001-20230822   gcc  
loongarch             randconfig-001-20230823   gcc  
loongarch            randconfig-r003-20230822   gcc  
loongarch            randconfig-r013-20230822   gcc  
loongarch            randconfig-r015-20230821   gcc  
loongarch            randconfig-r023-20230822   gcc  
loongarch            randconfig-r026-20230822   gcc  
loongarch            randconfig-r035-20230822   gcc  
m68k                             alldefconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                         apollo_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5208evb_defconfig   gcc  
m68k                          multi_defconfig   gcc  
m68k                        mvme147_defconfig   gcc  
m68k                 randconfig-r006-20230822   gcc  
m68k                 randconfig-r014-20230822   gcc  
m68k                 randconfig-r034-20230822   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
microblaze           randconfig-r005-20230822   gcc  
microblaze           randconfig-r011-20230821   gcc  
microblaze           randconfig-r014-20230823   gcc  
microblaze           randconfig-r021-20230822   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                         bigsur_defconfig   gcc  
mips                       bmips_be_defconfig   gcc  
mips                      bmips_stb_defconfig   clang
mips                  cavium_octeon_defconfig   clang
mips                  decstation_64_defconfig   gcc  
mips                 decstation_r4k_defconfig   gcc  
mips                           gcw0_defconfig   gcc  
mips                 randconfig-r002-20230822   clang
mips                 randconfig-r033-20230823   gcc  
mips                           rs90_defconfig   clang
mips                           xway_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r004-20230822   gcc  
nios2                randconfig-r014-20230821   gcc  
nios2                randconfig-r016-20230821   gcc  
nios2                randconfig-r016-20230823   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc                  or1klitex_defconfig   gcc  
openrisc             randconfig-r005-20230822   gcc  
openrisc             randconfig-r011-20230822   gcc  
openrisc             randconfig-r015-20230822   gcc  
openrisc             randconfig-r023-20230823   gcc  
openrisc             randconfig-r025-20230822   gcc  
openrisc             randconfig-r036-20230822   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r001-20230822   gcc  
parisc               randconfig-r013-20230821   gcc  
parisc               randconfig-r013-20230823   gcc  
parisc               randconfig-r015-20230822   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   gcc  
powerpc                      arches_defconfig   gcc  
powerpc                      bamboo_defconfig   gcc  
powerpc                   bluestone_defconfig   clang
powerpc                        cell_defconfig   gcc  
powerpc                      ep88xc_defconfig   gcc  
powerpc                          g5_defconfig   gcc  
powerpc                    ge_imp3a_defconfig   clang
powerpc                   motionpro_defconfig   gcc  
powerpc                 mpc834x_itx_defconfig   gcc  
powerpc                      pmac32_defconfig   clang
powerpc                     powernv_defconfig   clang
powerpc                     rainier_defconfig   gcc  
powerpc              randconfig-r003-20230822   gcc  
powerpc              randconfig-r031-20230822   gcc  
powerpc64                        alldefconfig   gcc  
powerpc64            randconfig-r002-20230822   gcc  
powerpc64            randconfig-r024-20230822   clang
powerpc64            randconfig-r031-20230822   gcc  
powerpc64            randconfig-r032-20230822   gcc  
powerpc64            randconfig-r035-20230822   gcc  
powerpc64            randconfig-r036-20230822   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                    nommu_virt_defconfig   clang
riscv                 randconfig-001-20230821   clang
riscv                 randconfig-001-20230822   gcc  
riscv                randconfig-r002-20230822   gcc  
riscv                randconfig-r012-20230821   gcc  
riscv                randconfig-r036-20230822   gcc  
riscv                          rv32_defconfig   gcc  
s390                             alldefconfig   gcc  
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20230822   clang
s390                  randconfig-001-20230823   gcc  
s390                 randconfig-r002-20230822   gcc  
s390                 randconfig-r006-20230822   gcc  
s390                 randconfig-r023-20230822   clang
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                        edosk7705_defconfig   gcc  
sh                            hp6xx_defconfig   gcc  
sh                          r7780mp_defconfig   gcc  
sh                   randconfig-r001-20230822   gcc  
sh                   randconfig-r013-20230822   gcc  
sh                   randconfig-r016-20230822   gcc  
sh                   randconfig-r021-20230822   gcc  
sh                   randconfig-r026-20230823   gcc  
sh                   randconfig-r031-20230822   gcc  
sh                   randconfig-r034-20230822   gcc  
sh                           se7712_defconfig   gcc  
sh                     sh7710voipgw_defconfig   gcc  
sparc                            alldefconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r002-20230822   gcc  
sparc                randconfig-r011-20230822   gcc  
sparc                randconfig-r022-20230822   gcc  
sparc                randconfig-r025-20230823   gcc  
sparc                randconfig-r031-20230823   gcc  
sparc                randconfig-r034-20230822   gcc  
sparc                randconfig-r034-20230823   gcc  
sparc                       sparc64_defconfig   gcc  
sparc64                          alldefconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64              randconfig-r024-20230823   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                   randconfig-r022-20230822   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-001-20230822   gcc  
x86_64       buildonly-randconfig-001-20230823   clang
x86_64       buildonly-randconfig-002-20230822   gcc  
x86_64       buildonly-randconfig-002-20230823   clang
x86_64       buildonly-randconfig-003-20230822   gcc  
x86_64       buildonly-randconfig-003-20230823   clang
x86_64       buildonly-randconfig-004-20230822   gcc  
x86_64       buildonly-randconfig-004-20230823   clang
x86_64       buildonly-randconfig-005-20230822   gcc  
x86_64       buildonly-randconfig-005-20230823   clang
x86_64       buildonly-randconfig-006-20230822   gcc  
x86_64       buildonly-randconfig-006-20230823   clang
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                randconfig-001-20230822   clang
x86_64                randconfig-001-20230823   gcc  
x86_64                randconfig-002-20230822   clang
x86_64                randconfig-002-20230823   gcc  
x86_64                randconfig-003-20230822   clang
x86_64                randconfig-003-20230823   gcc  
x86_64                randconfig-004-20230822   clang
x86_64                randconfig-004-20230823   gcc  
x86_64                randconfig-005-20230822   clang
x86_64                randconfig-005-20230823   gcc  
x86_64                randconfig-006-20230822   clang
x86_64                randconfig-006-20230823   gcc  
x86_64                randconfig-011-20230821   clang
x86_64                randconfig-011-20230822   gcc  
x86_64                randconfig-011-20230823   clang
x86_64                randconfig-012-20230821   clang
x86_64                randconfig-012-20230822   gcc  
x86_64                randconfig-012-20230823   clang
x86_64                randconfig-013-20230821   clang
x86_64                randconfig-013-20230822   gcc  
x86_64                randconfig-013-20230823   clang
x86_64                randconfig-014-20230821   clang
x86_64                randconfig-014-20230822   gcc  
x86_64                randconfig-014-20230823   clang
x86_64                randconfig-015-20230821   clang
x86_64                randconfig-015-20230822   gcc  
x86_64                randconfig-015-20230823   clang
x86_64                randconfig-016-20230821   clang
x86_64                randconfig-016-20230822   gcc  
x86_64                randconfig-016-20230823   clang
x86_64                randconfig-071-20230821   clang
x86_64                randconfig-071-20230822   gcc  
x86_64                randconfig-071-20230823   clang
x86_64                randconfig-072-20230821   clang
x86_64                randconfig-072-20230822   gcc  
x86_64                randconfig-072-20230823   clang
x86_64                randconfig-073-20230821   clang
x86_64                randconfig-073-20230822   gcc  
x86_64                randconfig-073-20230823   clang
x86_64                randconfig-074-20230821   clang
x86_64                randconfig-074-20230822   gcc  
x86_64                randconfig-074-20230823   clang
x86_64                randconfig-075-20230821   clang
x86_64                randconfig-075-20230822   gcc  
x86_64                randconfig-075-20230823   clang
x86_64                randconfig-076-20230821   clang
x86_64                randconfig-076-20230822   gcc  
x86_64                randconfig-076-20230823   clang
x86_64               randconfig-r001-20230823   clang
x86_64               randconfig-r003-20230823   clang
x86_64               randconfig-r035-20230822   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-func   gcc  
x86_64                    rhel-8.3-kselftests   gcc  
x86_64                         rhel-8.3-kunit   gcc  
x86_64                           rhel-8.3-ltp   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa               randconfig-r003-20230822   gcc  
xtensa               randconfig-r032-20230823   gcc  
xtensa               randconfig-r034-20230822   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
