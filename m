Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957FFEB64DC
	for <linux-raid@archiver.kernel.org>; Sat,  1 Jul 2023 11:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjGALhP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 Jul 2023 07:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjGALhO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 1 Jul 2023 07:37:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943FD137
        for <linux-raid@vger.kernel.org>; Sat,  1 Jul 2023 04:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688211432; x=1719747432;
  h=date:from:to:cc:subject:message-id;
  bh=Sborbd5ZpT62/W4NPrsK/oHoZRZRAZy+/64Q3izaIIs=;
  b=SZVXPVeaGxkhWNDOpg+WGJ/dUf4YEsLYHJ2EIF9QSC4O4sxYOWXwGKr6
   QIcOQM7WIN+IGs2cIASFzVCOZeOEemnhazf+GDDsYB+6YiGDibSijRagr
   kaoM3xt7Xk8nE/Ji18FXu9xmjdZaH1kcXI480CshPgI/pC1L7iA+jYGPP
   t0e4cSiYivbiWl45bWLU+vi9deZq5PE1i0eaSmNMc4N7dQYeBorgT3M69
   4y+DjKf79vnkJu4p02Ur7IVjSPIOzE9rA0VxhbaXWqxx/O4o5LfVuMLwW
   XxfxWXQDMJA7i2iVXvNZ2BzbkN60f4hMTtXJfm5rH1nTEP+vfZ1ai6hqI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="393320643"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="393320643"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2023 04:37:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="668269269"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="668269269"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 01 Jul 2023 04:37:10 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qFYub-000Fzb-2c;
        Sat, 01 Jul 2023 11:37:09 +0000
Date:   Sat, 01 Jul 2023 19:36:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 e836007089ba8fdf24e636ef2b007651fb4582e6
Message-ID: <202307011926.7HNPlOPH-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: e836007089ba8fdf24e636ef2b007651fb4582e6  md/raid0: add discard support for the 'original' layout

elapsed time: 722m

configs tested: 124
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r004-20230701   gcc  
arc                              allyesconfig   gcc  
arc                      axs103_smp_defconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r011-20230701   gcc  
arc                  randconfig-r043-20230701   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                         mv78xx0_defconfig   clang
arm                       netwinder_defconfig   clang
arm                  randconfig-r021-20230630   gcc  
arm                  randconfig-r046-20230701   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r012-20230701   clang
csky                                defconfig   gcc  
csky                 randconfig-r016-20230701   gcc  
hexagon              randconfig-r003-20230701   clang
hexagon              randconfig-r041-20230701   clang
hexagon              randconfig-r045-20230701   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230630   gcc  
i386         buildonly-randconfig-r005-20230630   gcc  
i386         buildonly-randconfig-r006-20230630   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230701   gcc  
i386                 randconfig-i002-20230701   gcc  
i386                 randconfig-i003-20230701   gcc  
i386                 randconfig-i004-20230701   gcc  
i386                 randconfig-i005-20230701   gcc  
i386                 randconfig-i006-20230701   gcc  
i386                 randconfig-i011-20230629   clang
i386                 randconfig-i012-20230629   clang
i386                 randconfig-i013-20230629   clang
i386                 randconfig-i014-20230629   clang
i386                 randconfig-i015-20230629   clang
i386                 randconfig-i016-20230629   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r024-20230630   gcc  
loongarch            randconfig-r025-20230630   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                           virt_defconfig   gcc  
microblaze           randconfig-r002-20230701   gcc  
microblaze           randconfig-r005-20230701   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                     loongson1b_defconfig   gcc  
mips                          rm200_defconfig   clang
nios2                               defconfig   gcc  
nios2                randconfig-r026-20230630   gcc  
nios2                randconfig-r036-20230701   gcc  
openrisc                         alldefconfig   gcc  
openrisc                            defconfig   gcc  
openrisc             randconfig-r014-20230701   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r022-20230630   gcc  
parisc               randconfig-r033-20230701   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                   bluestone_defconfig   clang
powerpc                      pasemi_defconfig   gcc  
powerpc              randconfig-r013-20230701   clang
powerpc              randconfig-r034-20230701   gcc  
powerpc                     tqm8560_defconfig   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230701   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r044-20230701   clang
sh                               allmodconfig   gcc  
sh                 kfr2r09-romimage_defconfig   gcc  
sh                          kfr2r09_defconfig   gcc  
sh                   randconfig-r032-20230701   gcc  
sh                   randconfig-r035-20230701   gcc  
sh                              ul2_defconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64              randconfig-r006-20230701   gcc  
sparc64              randconfig-r031-20230701   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                   randconfig-r015-20230701   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230630   gcc  
x86_64       buildonly-randconfig-r002-20230630   gcc  
x86_64       buildonly-randconfig-r003-20230630   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r023-20230630   clang
x86_64               randconfig-x001-20230629   clang
x86_64               randconfig-x002-20230629   clang
x86_64               randconfig-x003-20230629   clang
x86_64               randconfig-x004-20230629   clang
x86_64               randconfig-x005-20230629   clang
x86_64               randconfig-x006-20230629   clang
x86_64               randconfig-x011-20230701   gcc  
x86_64               randconfig-x012-20230701   gcc  
x86_64               randconfig-x013-20230701   gcc  
x86_64               randconfig-x014-20230701   gcc  
x86_64               randconfig-x015-20230701   gcc  
x86_64               randconfig-x016-20230701   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                           alldefconfig   gcc  
xtensa                       common_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
