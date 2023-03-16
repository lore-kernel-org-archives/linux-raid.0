Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52213C6FD1F
	for <linux-raid@archiver.kernel.org>; Thu, 16 Mar 2023 07:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCPHMp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Mar 2023 03:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCPHMn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Mar 2023 03:12:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1752A6EE
        for <linux-raid@vger.kernel.org>; Thu, 16 Mar 2023 00:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678950727; x=1710486727;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=5ZSgzfRi7jBKdxMdpVwv1fiOzhpU7bbAmRMvZLS7SE4=;
  b=Q+prlXskD9J2UOs0HAthFOKdQhINi2n5LynIR99IHpoLMW0Ng8jS1t9S
   56rGcau5uiAwJwdju+tKlyI1FpWyzqgxW0TcqaqKBwnnJLefEqMatXbdS
   knXjyPbQQ/DpUBbD+mabY1FifU4uDTzyO6VAgqD1T/YHVd1bsDNmEpq5O
   5dRfFg9Iq7nM80lgkFFD6UheicFigy0HC1sJ7uLIHTaDzvhky0fvnfWv7
   rHI7i/jSk+knpnQuOCScsNi8/mI4cgIYXnyFX1azUk4/lEuV9R6VzK4Lt
   XUMWbonpu1aUT1ZlYMAJsTaWBbGC5JrmR7ZuDhYwHEk5/KJ2GtB48/T1h
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="340270988"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="340270988"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 00:10:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="1009123752"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009123752"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 00:10:29 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pchkm-0008Ob-0w;
        Thu, 16 Mar 2023 07:10:24 +0000
Date:   Thu, 16 Mar 2023 15:09:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 6c0f5898836c05c6d850a750ed7940ba29e4e6c5
Message-ID: <6412c0b9.JMxyOBN5Z+4WLtdf%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 6c0f5898836c05c6d850a750ed7940ba29e4e6c5  md: select BLOCK_LEGACY_AUTOLOAD

elapsed time: 730m

configs tested: 233
configs skipped: 18

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            alldefconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r021-20230312   gcc  
alpha                randconfig-r024-20230312   gcc  
alpha                randconfig-r031-20230313   gcc  
alpha                randconfig-r033-20230313   gcc  
alpha                randconfig-r034-20230313   gcc  
alpha                randconfig-r036-20230313   gcc  
arc                              allyesconfig   gcc  
arc                          axs103_defconfig   gcc  
arc          buildonly-randconfig-r003-20230312   gcc  
arc          buildonly-randconfig-r003-20230313   gcc  
arc          buildonly-randconfig-r005-20230312   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r003-20230312   gcc  
arc                  randconfig-r011-20230313   gcc  
arc                  randconfig-r012-20230312   gcc  
arc                  randconfig-r013-20230313   gcc  
arc                  randconfig-r022-20230313   gcc  
arc                  randconfig-r026-20230312   gcc  
arc                  randconfig-r036-20230312   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                          collie_defconfig   clang
arm                                 defconfig   gcc  
arm                            dove_defconfig   clang
arm                      integrator_defconfig   gcc  
arm                  randconfig-r001-20230312   gcc  
arm                  randconfig-r004-20230313   clang
arm                  randconfig-r013-20230313   gcc  
arm                  randconfig-r021-20230313   gcc  
arm                  randconfig-r025-20230313   gcc  
arm                  randconfig-r036-20230312   gcc  
arm                  randconfig-r046-20230312   clang
arm                         s3c6400_defconfig   gcc  
arm                        shmobile_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r002-20230313   gcc  
arm64                randconfig-r005-20230312   clang
arm64                randconfig-r015-20230312   gcc  
arm64                randconfig-r035-20230313   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r032-20230312   gcc  
hexagon      buildonly-randconfig-r004-20230312   clang
hexagon      buildonly-randconfig-r005-20230313   clang
hexagon              randconfig-r001-20230313   clang
hexagon              randconfig-r041-20230312   clang
hexagon              randconfig-r041-20230313   clang
hexagon              randconfig-r045-20230312   clang
hexagon              randconfig-r045-20230313   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r002-20230313   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230313   gcc  
i386                 randconfig-a002-20230313   gcc  
i386                 randconfig-a003-20230313   gcc  
i386                 randconfig-a004-20230313   gcc  
i386                 randconfig-a005-20230313   gcc  
i386                 randconfig-a006-20230313   gcc  
i386                 randconfig-a011-20230313   clang
i386                 randconfig-a012-20230313   clang
i386                 randconfig-a013-20230313   clang
i386                 randconfig-a014-20230313   clang
i386                 randconfig-a015-20230313   clang
i386                 randconfig-a016-20230313   clang
i386                          randconfig-c001   gcc  
i386                 randconfig-r032-20230313   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                        generic_defconfig   gcc  
ia64                 randconfig-r006-20230313   gcc  
ia64                 randconfig-r011-20230312   gcc  
ia64                 randconfig-r015-20230315   gcc  
ia64                 randconfig-r016-20230312   gcc  
ia64                 randconfig-r022-20230313   gcc  
ia64                 randconfig-r032-20230313   gcc  
ia64                 randconfig-r036-20230313   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r002-20230312   gcc  
loongarch            randconfig-r002-20230313   gcc  
loongarch            randconfig-r004-20230313   gcc  
loongarch            randconfig-r013-20230313   gcc  
loongarch            randconfig-r021-20230312   gcc  
loongarch            randconfig-r022-20230312   gcc  
loongarch            randconfig-r031-20230313   gcc  
loongarch            randconfig-r033-20230313   gcc  
m68k                             alldefconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                          atari_defconfig   gcc  
m68k         buildonly-randconfig-r001-20230312   gcc  
m68k         buildonly-randconfig-r005-20230312   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r001-20230313   gcc  
m68k                 randconfig-r011-20230312   gcc  
m68k                 randconfig-r011-20230313   gcc  
m68k                 randconfig-r012-20230312   gcc  
m68k                 randconfig-r014-20230313   gcc  
m68k                 randconfig-r014-20230315   gcc  
m68k                 randconfig-r033-20230313   gcc  
m68k                 randconfig-r034-20230313   gcc  
microblaze   buildonly-randconfig-r001-20230312   gcc  
microblaze           randconfig-r003-20230312   gcc  
microblaze           randconfig-r005-20230312   gcc  
microblaze           randconfig-r035-20230313   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                          ath79_defconfig   clang
mips                       bmips_be_defconfig   gcc  
mips                 randconfig-r004-20230312   gcc  
mips                 randconfig-r015-20230313   gcc  
nios2        buildonly-randconfig-r003-20230312   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r003-20230313   gcc  
nios2                randconfig-r015-20230313   gcc  
nios2                randconfig-r016-20230313   gcc  
nios2                randconfig-r021-20230313   gcc  
nios2                randconfig-r025-20230312   gcc  
nios2                randconfig-r031-20230312   gcc  
nios2                randconfig-r032-20230312   gcc  
openrisc     buildonly-randconfig-r001-20230313   gcc  
openrisc     buildonly-randconfig-r002-20230313   gcc  
openrisc     buildonly-randconfig-r004-20230312   gcc  
openrisc             randconfig-r012-20230313   gcc  
openrisc             randconfig-r014-20230312   gcc  
openrisc             randconfig-r032-20230313   gcc  
openrisc             randconfig-r035-20230313   gcc  
parisc       buildonly-randconfig-r002-20230312   gcc  
parisc       buildonly-randconfig-r005-20230313   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r002-20230312   gcc  
parisc               randconfig-r005-20230312   gcc  
parisc               randconfig-r014-20230313   gcc  
parisc               randconfig-r026-20230313   gcc  
parisc               randconfig-r033-20230312   gcc  
parisc               randconfig-r036-20230313   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r001-20230313   clang
powerpc      buildonly-randconfig-r004-20230313   clang
powerpc                 canyonlands_defconfig   gcc  
powerpc                     ksi8560_defconfig   clang
powerpc                      mgcoge_defconfig   gcc  
powerpc                 mpc8313_rdb_defconfig   clang
powerpc                 mpc832x_mds_defconfig   clang
powerpc                 mpc834x_itx_defconfig   gcc  
powerpc                 mpc837x_rdb_defconfig   gcc  
powerpc                     powernv_defconfig   clang
powerpc              randconfig-r004-20230313   gcc  
powerpc              randconfig-r012-20230312   gcc  
powerpc              randconfig-r026-20230312   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                    nommu_k210_defconfig   gcc  
riscv                    nommu_virt_defconfig   clang
riscv                randconfig-r002-20230312   clang
riscv                randconfig-r005-20230313   gcc  
riscv                randconfig-r024-20230312   gcc  
riscv                randconfig-r042-20230313   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r001-20230313   gcc  
s390                 randconfig-r013-20230312   gcc  
s390                 randconfig-r016-20230312   gcc  
s390                 randconfig-r021-20230312   gcc  
s390                 randconfig-r023-20230312   gcc  
s390                 randconfig-r025-20230312   gcc  
s390                 randconfig-r044-20230313   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r004-20230313   gcc  
sh           buildonly-randconfig-r006-20230313   gcc  
sh                   randconfig-r023-20230313   gcc  
sh                   randconfig-r024-20230312   gcc  
sh                   randconfig-r034-20230312   gcc  
sh                   randconfig-r035-20230312   gcc  
sh                          rsk7269_defconfig   gcc  
sh                           se7206_defconfig   gcc  
sh                   secureedge5410_defconfig   gcc  
sh                        sh7757lcr_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r015-20230313   gcc  
sparc                randconfig-r016-20230313   gcc  
sparc                randconfig-r023-20230312   gcc  
sparc                randconfig-r034-20230312   gcc  
sparc                randconfig-r034-20230313   gcc  
sparc                randconfig-r035-20230312   gcc  
sparc64      buildonly-randconfig-r002-20230312   gcc  
sparc64      buildonly-randconfig-r006-20230312   gcc  
sparc64              randconfig-r012-20230313   gcc  
sparc64              randconfig-r013-20230312   gcc  
sparc64              randconfig-r015-20230312   gcc  
sparc64              randconfig-r022-20230312   gcc  
sparc64              randconfig-r024-20230313   gcc  
sparc64              randconfig-r025-20230313   gcc  
sparc64              randconfig-r034-20230312   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230313   gcc  
x86_64               randconfig-a002-20230313   gcc  
x86_64               randconfig-a003-20230313   gcc  
x86_64               randconfig-a004-20230313   gcc  
x86_64               randconfig-a005-20230313   gcc  
x86_64               randconfig-a006-20230313   gcc  
x86_64               randconfig-a011-20230313   clang
x86_64               randconfig-a012-20230313   clang
x86_64                        randconfig-a012   clang
x86_64               randconfig-a013-20230313   clang
x86_64               randconfig-a014-20230313   clang
x86_64                        randconfig-a014   clang
x86_64               randconfig-a015-20230313   clang
x86_64               randconfig-a016-20230313   clang
x86_64                        randconfig-a016   clang
x86_64               randconfig-k001-20230313   clang
x86_64               randconfig-r006-20230313   gcc  
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r003-20230313   gcc  
xtensa                       common_defconfig   gcc  
xtensa               randconfig-r001-20230312   gcc  
xtensa               randconfig-r016-20230312   gcc  
xtensa               randconfig-r023-20230312   gcc  
xtensa               randconfig-r031-20230312   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
