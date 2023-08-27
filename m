Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AFFC83F10
	for <linux-raid@archiver.kernel.org>; Sun, 27 Aug 2023 09:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjH0JYF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Aug 2023 05:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjH0JXr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Aug 2023 05:23:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EDAE1
        for <linux-raid@vger.kernel.org>; Sun, 27 Aug 2023 02:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693128225; x=1724664225;
  h=date:from:to:cc:subject:message-id;
  bh=1dP8K4H4gOzLYiIUXnfjffnVpaht6GYf7/AEZrK3eD0=;
  b=UbOmuoXWLMQVsj382XA9g8v5YSMTiTDDbcxZ2AF34nX9mp5vFAPFeGvE
   R7mEyW21z52ADvY0umusTAgBtKhp9go/F9px8KxAD4N/le3k+Whp/23+C
   CZWBVCws6Q0IvIZj3xbVD7i72qJaTHUH5ayQ1BryuX1yLgYIrckOOLB7C
   p4OKDs2zAKYnU3waY/xIbpbPKMZIL80kj8/YnBZZvrs4KIlN/+kwl3nBi
   nca/guy67FRyxSfbBKW6HQllc+psx+NpsBgzC5sCnzuduq7rU557CKEYz
   ZgGhgb3hIUHzi1EKRs6jUagKTe/xZtxvwW8+nknPmSZegezbWTM4R9qjY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10814"; a="378713455"
X-IronPort-AV: E=Sophos;i="6.02,205,1688454000"; 
   d="scan'208";a="378713455"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2023 02:23:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10814"; a="687768615"
X-IronPort-AV: E=Sophos;i="6.02,205,1688454000"; 
   d="scan'208";a="687768615"
Received: from lkp-server02.sh.intel.com (HELO daf8bb0a381d) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2023 02:23:43 -0700
Received: from kbuild by daf8bb0a381d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qaBzi-0005bp-28;
        Sun, 27 Aug 2023 09:23:42 +0000
Date:   Sun, 27 Aug 2023 17:23:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 e3b2f62786a02b217038ba18e4b77bf6bc1bb831
Message-ID: <202308271737.Ej3cR18b-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: e3b2f62786a02b217038ba18e4b77bf6bc1bb831  md: don't check 'mddev->pers' and 'pers->quiesce' from suspend_lo_store()

elapsed time: 3039m

configs tested: 158
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r014-20230825   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                   randconfig-001-20230825   gcc  
arc                  randconfig-r011-20230825   gcc  
arc                  randconfig-r022-20230825   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                   randconfig-001-20230825   clang
arm64                            allmodconfig   gcc  
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
hexagon               randconfig-001-20230825   clang
hexagon               randconfig-002-20230825   clang
hexagon              randconfig-r005-20230825   clang
hexagon              randconfig-r034-20230825   clang
i386         buildonly-randconfig-001-20230825   clang
i386         buildonly-randconfig-002-20230825   clang
i386         buildonly-randconfig-003-20230825   clang
i386         buildonly-randconfig-004-20230825   clang
i386         buildonly-randconfig-005-20230825   clang
i386         buildonly-randconfig-006-20230825   clang
i386                                defconfig   gcc  
i386                  randconfig-001-20230825   clang
i386                  randconfig-002-20230825   clang
i386                  randconfig-003-20230825   clang
i386                  randconfig-004-20230825   clang
i386                  randconfig-005-20230825   clang
i386                  randconfig-006-20230825   clang
i386                  randconfig-011-20230825   gcc  
i386                  randconfig-012-20230825   gcc  
i386                  randconfig-013-20230825   gcc  
i386                  randconfig-014-20230825   gcc  
i386                  randconfig-015-20230825   gcc  
i386                  randconfig-016-20230825   gcc  
i386                 randconfig-r021-20230825   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20230825   gcc  
loongarch            randconfig-r033-20230825   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                        m5407c3_defconfig   gcc  
m68k                 randconfig-r024-20230825   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
microblaze           randconfig-r004-20230825   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r015-20230825   gcc  
nios2                randconfig-r035-20230825   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc             randconfig-r032-20230825   gcc  
openrisc             randconfig-r036-20230825   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r012-20230825   gcc  
parisc               randconfig-r016-20230825   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   gcc  
powerpc                      katmai_defconfig   clang
powerpc                      ppc64e_defconfig   clang
powerpc              randconfig-r006-20230825   clang
powerpc              randconfig-r023-20230825   gcc  
powerpc64            randconfig-r002-20230825   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                 randconfig-001-20230825   clang
riscv                randconfig-r001-20230825   clang
riscv                randconfig-r025-20230825   gcc  
riscv                randconfig-r026-20230825   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20230825   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                         apsh4a3a_defconfig   gcc  
sh                                  defconfig   gcc  
sh                   randconfig-r031-20230825   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r003-20230825   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                   randconfig-r013-20230825   clang
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64       buildonly-randconfig-001-20230825   clang
x86_64       buildonly-randconfig-002-20230825   clang
x86_64       buildonly-randconfig-003-20230825   clang
x86_64       buildonly-randconfig-004-20230825   clang
x86_64       buildonly-randconfig-005-20230825   clang
x86_64       buildonly-randconfig-006-20230825   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20230825   gcc  
x86_64                randconfig-002-20230825   gcc  
x86_64                randconfig-003-20230825   gcc  
x86_64                randconfig-004-20230825   gcc  
x86_64                randconfig-005-20230825   gcc  
x86_64                randconfig-006-20230825   gcc  
x86_64                randconfig-011-20230825   clang
x86_64                randconfig-012-20230825   clang
x86_64                randconfig-013-20230825   clang
x86_64                randconfig-014-20230825   clang
x86_64                randconfig-015-20230825   clang
x86_64                randconfig-016-20230825   clang
x86_64                randconfig-071-20230825   clang
x86_64                randconfig-072-20230825   clang
x86_64                randconfig-073-20230825   clang
x86_64                randconfig-074-20230825   clang
x86_64                randconfig-075-20230825   clang
x86_64                randconfig-076-20230825   clang
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
