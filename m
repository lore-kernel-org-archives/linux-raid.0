Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD5AC6FD1F
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 08:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjCNI7t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 04:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjCNI7g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 04:59:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC5794F71
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 01:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678784368; x=1710320368;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=bMVEpUPtXUPVwr+Vm47hgG3Yz4dL9dvS3nBpaOpt9JM=;
  b=HakYAUputCMSVK9GA6YSlE/T1z5heM9n3LJVbaq0MCWmyl7uP56UGQdH
   edjWTdN88i1ShBaw/HNDoIGaB5D+V3Vl0uXoa/hjb0NhdMPidmJqhwyYG
   jgsgVS2HvMlRGYEot/F2yBs/4XI73+xdLoBJT8vqrV7C3a0cn9ESEB3wO
   AMsi3t9TntIWyJ8LYPHrxy7MVt3G5ANLRF+q/xoy46tJ/J+1AjtrrLa/o
   qlkYMbeXz2Pyr/LPfahJa6p3yz2xDYxR096oqhO4TwjzDclA+3jxIxgza
   bmJ0IV5ORzVLViO7LC67y1qW8UEwEgHUXpiftSgdPsA6VeVTZ7Kd9lArF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="317756299"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="317756299"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747922784"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="747922784"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2023 01:59:27 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pc0VC-0006ji-1m;
        Tue, 14 Mar 2023 08:59:26 +0000
Date:   Tue, 14 Mar 2023 16:59:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 f6bb5176318186880ff2f16ad65f519b70f04686
Message-ID: <64103761.+jZ9z4qxWHf5PGps%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: f6bb5176318186880ff2f16ad65f519b70f04686  Subject: md: select BLOCK_LEGACY_AUTOLOAD

elapsed time: 724m

configs tested: 131
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r006-20230313   gcc  
alpha                randconfig-r016-20230312   gcc  
alpha                randconfig-r034-20230313   gcc  
alpha                randconfig-r035-20230313   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r001-20230313   gcc  
arc                  randconfig-r013-20230313   gcc  
arc                  randconfig-r022-20230313   gcc  
arc                  randconfig-r024-20230312   gcc  
arc                  randconfig-r031-20230313   gcc  
arc                  randconfig-r043-20230312   gcc  
arc                  randconfig-r043-20230313   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r003-20230312   clang
arm                                 defconfig   gcc  
arm                  randconfig-r046-20230312   clang
arm                  randconfig-r046-20230313   gcc  
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r001-20230312   clang
arm64                               defconfig   gcc  
arm64                randconfig-r003-20230312   clang
arm64                randconfig-r011-20230312   gcc  
arm64                randconfig-r015-20230313   clang
arm64                randconfig-r023-20230312   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r004-20230313   gcc  
csky                 randconfig-r022-20230312   gcc  
hexagon      buildonly-randconfig-r001-20230313   clang
hexagon              randconfig-r002-20230312   clang
hexagon              randconfig-r024-20230313   clang
hexagon              randconfig-r041-20230312   clang
hexagon              randconfig-r041-20230313   clang
hexagon              randconfig-r045-20230312   clang
hexagon              randconfig-r045-20230313   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r006-20230313   gcc  
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
i386                 randconfig-r003-20230313   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r012-20230312   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r004-20230313   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r004-20230312   gcc  
m68k                 randconfig-r006-20230312   gcc  
m68k                 randconfig-r016-20230313   gcc  
m68k                 randconfig-r032-20230312   gcc  
microblaze   buildonly-randconfig-r002-20230313   gcc  
microblaze           randconfig-r025-20230312   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r002-20230312   gcc  
mips                 randconfig-r021-20230312   clang
nios2                               defconfig   gcc  
nios2                randconfig-r012-20230313   gcc  
nios2                randconfig-r023-20230313   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r005-20230312   gcc  
parisc               randconfig-r034-20230312   gcc  
parisc               randconfig-r035-20230312   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r026-20230312   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r014-20230312   gcc  
riscv                randconfig-r042-20230312   gcc  
riscv                randconfig-r042-20230313   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r011-20230313   clang
s390                 randconfig-r031-20230312   clang
s390                 randconfig-r044-20230312   gcc  
s390                 randconfig-r044-20230313   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r021-20230313   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r032-20230313   gcc  
sparc                randconfig-r036-20230313   gcc  
sparc64              randconfig-r001-20230312   gcc  
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
x86_64               randconfig-a013-20230313   clang
x86_64               randconfig-a014-20230313   clang
x86_64               randconfig-a015-20230313   clang
x86_64               randconfig-a016-20230313   clang
x86_64               randconfig-r014-20230313   clang
x86_64               randconfig-r025-20230313   clang
x86_64               randconfig-r033-20230313   gcc  
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r005-20230312   gcc  
xtensa       buildonly-randconfig-r006-20230312   gcc  
xtensa               randconfig-r005-20230313   gcc  
xtensa               randconfig-r015-20230312   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
