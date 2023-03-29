Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C10C74A5B
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 12:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjC2MiM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 08:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjC2MiL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 08:38:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53750132
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 05:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680093490; x=1711629490;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=zc1BfQlBiHFv3iGYh+9rPNiCE5BDe3F1tj6UPDFu7CI=;
  b=GU2eLMfVyGDcy4E56w4CaeSunxlL+MOK6ntSzm6DeWMEZuhKZtrUxRal
   nuV/e08HtmgLWck0vT3jKk+j8tnDUkmKzsH5M3DQV1eXMTbC9DG8B0wuk
   CeriAeP5oBhZwRGG/lR2orya9xRI/mPwuIP35lWfeI9JW0n26j8Jy0luk
   nnAfgFT0Huq9hFWIlgHDLfvLdGHOC3lG5ea8FJAmosPqsdrPvajOWJXh4
   vJSArIo8DRC7sqaekg7IL6OgHf6hYwBn3SFaiBIOPMjnnU4GhqMV0Iqx7
   nAwvovI912kBhWJxXWeLxbMDaP7af+zt4Ay52nycQgvSFe+WGUaZZL0GP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="329331129"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="329331129"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 05:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="753560496"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="753560496"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 29 Mar 2023 05:37:50 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1phV3l-000JWk-1V;
        Wed, 29 Mar 2023 12:37:49 +0000
Date:   Wed, 29 Mar 2023 20:37:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-tmp] BUILD SUCCESS
 f3b49ec99fc6de703c67071cec1acbedf3133a56
Message-ID: <6424311a.AFCFoYSEJkXlDdkG%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-tmp
branch HEAD: f3b49ec99fc6de703c67071cec1acbedf3133a56  md: enhance checking in md_check_recovery()

elapsed time: 723m

configs tested: 162
configs skipped: 8

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r012-20230329   gcc  
alpha                randconfig-r021-20230327   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                        nsimosci_defconfig   gcc  
arc                  randconfig-r011-20230326   gcc  
arc                  randconfig-r022-20230326   gcc  
arc                  randconfig-r043-20230326   gcc  
arc                  randconfig-r043-20230327   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r002-20230329   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r013-20230326   clang
arm                  randconfig-r046-20230326   clang
arm                  randconfig-r046-20230327   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r002-20230329   gcc  
arm64                randconfig-r015-20230327   clang
arm64                randconfig-r026-20230327   clang
csky                                defconfig   gcc  
csky                 randconfig-r012-20230326   gcc  
csky                 randconfig-r014-20230329   gcc  
csky                 randconfig-r016-20230326   gcc  
csky                 randconfig-r026-20230326   gcc  
csky                 randconfig-r031-20230329   gcc  
csky                 randconfig-r034-20230329   gcc  
hexagon              randconfig-r015-20230329   clang
hexagon              randconfig-r021-20230326   clang
hexagon              randconfig-r041-20230326   clang
hexagon              randconfig-r041-20230327   clang
hexagon              randconfig-r041-20230329   clang
hexagon              randconfig-r045-20230326   clang
hexagon              randconfig-r045-20230327   clang
hexagon              randconfig-r045-20230329   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230327   gcc  
i386                 randconfig-a002-20230327   gcc  
i386                          randconfig-a002   clang
i386                 randconfig-a003-20230327   gcc  
i386                 randconfig-a004-20230327   gcc  
i386                          randconfig-a004   clang
i386                 randconfig-a005-20230327   gcc  
i386                 randconfig-a006-20230327   gcc  
i386                          randconfig-a006   clang
i386                 randconfig-a011-20230327   clang
i386                 randconfig-a012-20230327   clang
i386                          randconfig-a012   gcc  
i386                 randconfig-a013-20230327   clang
i386                 randconfig-a014-20230327   clang
i386                          randconfig-a014   gcc  
i386                 randconfig-a015-20230327   clang
i386                 randconfig-a016-20230327   clang
i386                          randconfig-a016   gcc  
i386                          randconfig-c001   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r003-20230329   gcc  
ia64                 randconfig-r036-20230329   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r014-20230327   gcc  
loongarch            randconfig-r023-20230327   gcc  
loongarch            randconfig-r036-20230329   gcc  
m68k                             alldefconfig   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r002-20230329   gcc  
m68k                                defconfig   gcc  
m68k                          hp300_defconfig   gcc  
m68k                 randconfig-r014-20230326   gcc  
m68k                 randconfig-r015-20230326   gcc  
m68k                 randconfig-r035-20230329   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r001-20230329   clang
mips                 randconfig-r016-20230329   gcc  
mips                 randconfig-r022-20230327   gcc  
nios2        buildonly-randconfig-r003-20230329   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r023-20230326   gcc  
openrisc                  or1klitex_defconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r001-20230329   gcc  
parisc               randconfig-r024-20230326   gcc  
parisc               randconfig-r024-20230327   gcc  
parisc               randconfig-r032-20230329   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r032-20230329   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv             nommu_k210_sdcard_defconfig   gcc  
riscv                randconfig-r013-20230327   clang
riscv                randconfig-r042-20230326   gcc  
riscv                randconfig-r042-20230327   clang
riscv                randconfig-r042-20230329   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r005-20230329   gcc  
s390                 randconfig-r014-20230329   clang
s390                 randconfig-r016-20230329   clang
s390                 randconfig-r044-20230326   gcc  
s390                 randconfig-r044-20230327   clang
s390                 randconfig-r044-20230329   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r004-20230329   gcc  
sh                   randconfig-r006-20230329   gcc  
sh                           se7206_defconfig   gcc  
sh                           sh2007_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r015-20230329   gcc  
sparc64      buildonly-randconfig-r003-20230329   gcc  
sparc64      buildonly-randconfig-r005-20230329   gcc  
sparc64      buildonly-randconfig-r006-20230329   gcc  
sparc64              randconfig-r025-20230326   gcc  
sparc64              randconfig-r031-20230329   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230327   gcc  
x86_64                        randconfig-a001   clang
x86_64               randconfig-a002-20230327   gcc  
x86_64                        randconfig-a002   gcc  
x86_64               randconfig-a003-20230327   gcc  
x86_64                        randconfig-a003   clang
x86_64               randconfig-a004-20230327   gcc  
x86_64                        randconfig-a004   gcc  
x86_64               randconfig-a005-20230327   gcc  
x86_64                        randconfig-a005   clang
x86_64               randconfig-a006-20230327   gcc  
x86_64                        randconfig-a006   gcc  
x86_64               randconfig-a011-20230327   clang
x86_64               randconfig-a012-20230327   clang
x86_64                        randconfig-a012   clang
x86_64               randconfig-a013-20230327   clang
x86_64               randconfig-a014-20230327   clang
x86_64                        randconfig-a014   clang
x86_64               randconfig-a015-20230327   clang
x86_64               randconfig-a016-20230327   clang
x86_64                        randconfig-a016   clang
x86_64                        randconfig-k001   clang
x86_64               randconfig-r012-20230327   clang
x86_64               randconfig-r025-20230327   clang
x86_64                               rhel-8.3   gcc  
xtensa                              defconfig   gcc  
xtensa               randconfig-r011-20230329   gcc  
xtensa               randconfig-r016-20230327   gcc  
xtensa               randconfig-r033-20230329   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
