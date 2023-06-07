Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76CCC7EE23
	for <linux-raid@archiver.kernel.org>; Wed,  7 Jun 2023 10:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238925AbjFGKcB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Jun 2023 06:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbjFGKb7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Jun 2023 06:31:59 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7031011F
        for <linux-raid@vger.kernel.org>; Wed,  7 Jun 2023 03:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686133918; x=1717669918;
  h=date:from:to:cc:subject:message-id;
  bh=pTTb4aemqIDkM/kNB2OVyiu8ReDPSRMfbZwT+X4s3SU=;
  b=A9heYjJEvWA/6TdfjHXQlAvcD061nLnWEphpCn1P4zrUeKbABP1KgwKa
   kT+HzwqOGQkxTPuYdYnyvw934XWsgsCaZjNnwq5i1DlAf9+8DEloYeIWD
   4KDhJPWfe6zVemY5qCGcDyJXDOGckqjpmH2VCgidlqHiITKe49XJ2CCg1
   YRa69B8RxjUbCWWN3cz47HyoVWMxGXGHrUx777RfdahNnPvxH+IvmdhSw
   bJDYWKB4X2UqXwbHjOZAjtc13vlSnedLKB15t7KOX3EjUHzrtFJkirFfx
   xSLOXSH4fld+LDPkTT5iBqrDvX9wEEXYH/EUZflcO/8TnFpCippptQqmO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="385267856"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="385267856"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 03:31:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="822068506"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="822068506"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2023 03:31:57 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q6qSK-0006TZ-2B;
        Wed, 07 Jun 2023 10:31:56 +0000
Date:   Wed, 07 Jun 2023 18:31:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 05efc5bded36ba1a6d3db1b8cfeecb6a6f07508c
Message-ID: <20230607103107.IrslQ%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 05efc5bded36ba1a6d3db1b8cfeecb6a6f07508c  md/raid1-10: limit the number of plugged bio

elapsed time: 744m

configs tested: 128
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r004-20230606   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r025-20230606   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r002-20230606   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r002-20230607   gcc  
arc                  randconfig-r043-20230606   gcc  
arc                  randconfig-r043-20230607   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r046-20230607   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r006-20230607   clang
csky         buildonly-randconfig-r006-20230606   gcc  
csky                                defconfig   gcc  
hexagon      buildonly-randconfig-r003-20230606   clang
hexagon              randconfig-r012-20230606   clang
hexagon              randconfig-r036-20230606   clang
hexagon              randconfig-r041-20230606   clang
hexagon              randconfig-r041-20230607   clang
hexagon              randconfig-r045-20230607   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230607   clang
i386                 randconfig-i002-20230607   clang
i386                 randconfig-i003-20230607   clang
i386                 randconfig-i004-20230606   gcc  
i386                 randconfig-i004-20230607   clang
i386                 randconfig-i005-20230607   clang
i386                 randconfig-i006-20230606   gcc  
i386                 randconfig-i006-20230607   clang
i386                 randconfig-i011-20230606   clang
i386                 randconfig-i011-20230607   gcc  
i386                 randconfig-i012-20230606   clang
i386                 randconfig-i012-20230607   gcc  
i386                 randconfig-i013-20230606   clang
i386                 randconfig-i013-20230607   gcc  
i386                 randconfig-i014-20230606   clang
i386                 randconfig-i014-20230607   gcc  
i386                 randconfig-i015-20230607   gcc  
i386                 randconfig-i016-20230607   gcc  
i386                 randconfig-i051-20230607   clang
i386                 randconfig-i052-20230607   clang
i386                 randconfig-i053-20230607   clang
i386                 randconfig-i054-20230606   gcc  
i386                 randconfig-i054-20230607   clang
i386                 randconfig-i055-20230607   clang
i386                 randconfig-i056-20230607   clang
i386                 randconfig-i061-20230606   gcc  
i386                 randconfig-i062-20230606   gcc  
i386                 randconfig-i063-20230606   gcc  
i386                 randconfig-i064-20230606   gcc  
i386                 randconfig-i065-20230606   gcc  
i386                 randconfig-i066-20230606   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r031-20230606   gcc  
loongarch            randconfig-r033-20230606   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r005-20230607   gcc  
microblaze           randconfig-r024-20230606   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r001-20230607   gcc  
mips                 randconfig-r022-20230606   gcc  
nios2                               defconfig   gcc  
parisc       buildonly-randconfig-r005-20230606   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r023-20230606   gcc  
parisc               randconfig-r034-20230606   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r001-20230606   clang
powerpc              randconfig-r035-20230606   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r003-20230607   clang
riscv                randconfig-r011-20230606   clang
riscv                randconfig-r042-20230607   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r026-20230606   clang
s390                 randconfig-r044-20230607   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r016-20230606   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r014-20230606   gcc  
sparc                randconfig-r021-20230606   gcc  
sparc64              randconfig-r032-20230606   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230607   clang
x86_64               randconfig-a002-20230607   clang
x86_64               randconfig-a003-20230606   gcc  
x86_64               randconfig-a003-20230607   clang
x86_64               randconfig-a004-20230607   clang
x86_64               randconfig-a005-20230607   clang
x86_64               randconfig-a006-20230607   clang
x86_64               randconfig-a011-20230606   clang
x86_64               randconfig-a011-20230607   gcc  
x86_64               randconfig-a012-20230607   gcc  
x86_64               randconfig-a013-20230607   gcc  
x86_64               randconfig-a014-20230606   clang
x86_64               randconfig-a014-20230607   gcc  
x86_64               randconfig-a015-20230606   clang
x86_64               randconfig-a015-20230607   gcc  
x86_64               randconfig-a016-20230607   gcc  
x86_64               randconfig-x051-20230607   gcc  
x86_64               randconfig-x052-20230607   gcc  
x86_64               randconfig-x053-20230607   gcc  
x86_64               randconfig-x054-20230607   gcc  
x86_64               randconfig-x055-20230607   gcc  
x86_64               randconfig-x056-20230607   gcc  
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
