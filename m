Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211D5C77B7A
	for <linux-raid@archiver.kernel.org>; Sat, 20 May 2023 14:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjETOiz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 20 May 2023 10:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjETOiy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 20 May 2023 10:38:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D86C109
        for <linux-raid@vger.kernel.org>; Sat, 20 May 2023 07:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684593531; x=1716129531;
  h=date:from:to:cc:subject:message-id;
  bh=ERjeBcpnudSU3w3vzddxH5OaRuDGnZit48+S4AZdDHw=;
  b=XrzG/5hxQaQL4RShK+f1UYtzCdD008WPVezUmV344QeVLQU4KdlWEjLx
   4aQ3uDPiGwwxTi6psLV88xLIhQd5Gy/7FA6tSXMD21fg4uqXzjV6vBkOH
   HjYzBKaF6stiZIVPbkEWqgCuHqro31qb+Vc9E+dEglcXjsurwK02dgbr9
   Ri9eGBeOSbnWsaQTGmv+0zd57bVogF/lUEcpCsmzEKrGDP5b8mm6EyclT
   iZDpnq7yPTq98eK0idoOSN17p2AD08xCXupmudiqJaokSaV+r2N9TK4iS
   w+aghh0rfLHU/+ajWddiNb2OMAUBjh3gOFAMoGmqsUgUXhuVkmWDdj69P
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10716"; a="416054706"
X-IronPort-AV: E=Sophos;i="6.00,180,1681196400"; 
   d="scan'208";a="416054706"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2023 07:38:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10716"; a="735835895"
X-IronPort-AV: E=Sophos;i="6.00,180,1681196400"; 
   d="scan'208";a="735835895"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 20 May 2023 07:38:48 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q0NjM-000BbO-0b;
        Sat, 20 May 2023 14:38:48 +0000
Date:   Sat, 20 May 2023 22:38:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 4539f9ff958c04bf06b5906b6ae2688f54522c55
Message-ID: <20230520143822.h4jQI%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: INFO setup_repo_specs: /db/releases/20230519164737/lkp-src/repo/*/song-md
git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 4539f9ff958c04bf06b5906b6ae2688f54522c55  md/raid5: fix a deadlock in the case that reshape is interrupted

elapsed time: 851m

configs tested: 137
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r001-20230517   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r015-20230517   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                     haps_hs_smp_defconfig   gcc  
arc                  randconfig-r025-20230517   gcc  
arc                  randconfig-r043-20230517   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                           h3600_defconfig   gcc  
arm                   milbeaut_m10v_defconfig   clang
arm                  randconfig-r046-20230517   clang
arm                       versatile_defconfig   clang
arm                         vf610m4_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
hexagon      buildonly-randconfig-r006-20230517   clang
hexagon              randconfig-r041-20230517   clang
hexagon              randconfig-r045-20230517   clang
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
ia64                 randconfig-r014-20230517   gcc  
ia64                 randconfig-r023-20230517   gcc  
ia64                 randconfig-r031-20230517   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r002-20230517   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5249evb_defconfig   gcc  
m68k                 randconfig-r005-20230517   gcc  
m68k                           virt_defconfig   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                     cu1000-neo_defconfig   clang
mips                     decstation_defconfig   gcc  
mips                           gcw0_defconfig   gcc  
mips                           ip28_defconfig   clang
mips                 randconfig-r016-20230517   clang
nios2                               defconfig   gcc  
nios2                randconfig-r011-20230517   gcc  
openrisc                  or1klitex_defconfig   gcc  
openrisc             randconfig-r001-20230517   gcc  
openrisc             randconfig-r003-20230517   gcc  
openrisc             randconfig-r036-20230517   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r032-20230517   gcc  
parisc               randconfig-r035-20230517   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                     asp8347_defconfig   gcc  
powerpc      buildonly-randconfig-r004-20230517   gcc  
powerpc                 canyonlands_defconfig   gcc  
powerpc                      katmai_defconfig   clang
powerpc                     ksi8560_defconfig   clang
powerpc                     redwood_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r003-20230517   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r006-20230517   clang
riscv                randconfig-r042-20230517   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r022-20230517   gcc  
s390                 randconfig-r044-20230517   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r013-20230517   gcc  
sh                          sdk7786_defconfig   gcc  
sh                           se7705_defconfig   gcc  
sh                           se7712_defconfig   gcc  
sh                  sh7785lcr_32bit_defconfig   gcc  
sh                              ul2_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r021-20230517   gcc  
sparc                randconfig-r024-20230517   gcc  
sparc64      buildonly-randconfig-r005-20230517   gcc  
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
x86_64                        randconfig-k001   clang
x86_64                        randconfig-x051   gcc  
x86_64                        randconfig-x052   clang
x86_64                        randconfig-x053   gcc  
x86_64                        randconfig-x054   clang
x86_64                        randconfig-x055   gcc  
x86_64                        randconfig-x056   clang
x86_64                        randconfig-x061   gcc  
x86_64                        randconfig-x062   clang
x86_64                        randconfig-x063   gcc  
x86_64                        randconfig-x064   clang
x86_64                        randconfig-x065   gcc  
x86_64                        randconfig-x066   clang
x86_64                               rhel-8.3   gcc  
xtensa                  audio_kc705_defconfig   gcc  
xtensa                generic_kc705_defconfig   gcc  
xtensa               randconfig-r004-20230517   gcc  
xtensa               randconfig-r026-20230517   gcc  
xtensa               randconfig-r033-20230517   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
