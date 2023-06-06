Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3479C77B7A
	for <linux-raid@archiver.kernel.org>; Tue,  6 Jun 2023 12:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbjFFMx6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Jun 2023 08:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237655AbjFFMxy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Jun 2023 08:53:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708DD10D5
        for <linux-raid@vger.kernel.org>; Tue,  6 Jun 2023 05:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686056028; x=1717592028;
  h=date:from:to:cc:subject:message-id;
  bh=yxJltGyuvSKYdOMogSOeR6GLgp92CwX/1RvBvvHAVi4=;
  b=Od62i9zn/h9zfoPHNZ/onwuxPjRPyWeP17oq2FSqUpY4crDSclVTwytY
   m4uvNKY1NykGN5PLsMxUQZ7E7Iw/3lw68++RQaZ4aWZMA/PTWWrBt0MMm
   1+YcGIHSX7kMEYF78+mWF/X/6jCxtRgF6iRHFXQi5x0PRGZGMXDa/kIDP
   2Mwk425TvF4pLCCLCtOtmCZGzOENSZBRJBiQXLsW0Q2hubNFwvMMdPC1Y
   CNQNVghQmtNDagcC/8ttzMN4GEgZntSlz6l3coBrfZEV+RCA1CnV/8GRP
   wlp++reo7hAdjFI6a0U+48OV6/vNBFoV2Cp2AVN9POJxNUrtdkggw2ny5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341299880"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="341299880"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 05:53:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="709066202"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="709066202"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 06 Jun 2023 05:53:24 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q6WBf-0005FZ-25;
        Tue, 06 Jun 2023 12:53:23 +0000
Date:   Tue, 06 Jun 2023 20:53:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 8404706db6fa00b1bb2f8f6d276b33eed68b7ab8
Message-ID: <20230606125308.hfXH4%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 8404706db6fa00b1bb2f8f6d276b33eed68b7ab8  md/raid10: fix io loss while replacement replace rdev

elapsed time: 725m

configs tested: 187
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r005-20230606   gcc  
alpha                randconfig-r022-20230606   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r004-20230605   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r004-20230605   gcc  
arc                  randconfig-r026-20230605   gcc  
arc                  randconfig-r043-20230605   gcc  
arc                  randconfig-r043-20230606   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r003-20230606   clang
arm                  randconfig-r036-20230605   gcc  
arm                  randconfig-r046-20230605   clang
arm                  randconfig-r046-20230606   gcc  
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r006-20230606   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r004-20230606   gcc  
arm64                randconfig-r013-20230605   gcc  
arm64                randconfig-r016-20230605   gcc  
arm64                randconfig-r025-20230606   clang
csky                                defconfig   gcc  
csky                 randconfig-r005-20230605   gcc  
csky                 randconfig-r021-20230606   gcc  
csky                 randconfig-r022-20230606   gcc  
csky                 randconfig-r032-20230605   gcc  
csky                 randconfig-r033-20230606   gcc  
csky                 randconfig-r035-20230606   gcc  
hexagon      buildonly-randconfig-r003-20230606   clang
hexagon              randconfig-r004-20230606   clang
hexagon              randconfig-r041-20230605   clang
hexagon              randconfig-r041-20230606   clang
hexagon              randconfig-r045-20230605   clang
hexagon              randconfig-r045-20230606   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r005-20230606   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230605   clang
i386                 randconfig-i001-20230606   gcc  
i386                 randconfig-i002-20230605   clang
i386                 randconfig-i002-20230606   gcc  
i386                 randconfig-i003-20230605   clang
i386                 randconfig-i003-20230606   gcc  
i386                 randconfig-i004-20230605   clang
i386                 randconfig-i004-20230606   gcc  
i386                 randconfig-i005-20230605   clang
i386                 randconfig-i005-20230606   gcc  
i386                 randconfig-i006-20230605   clang
i386                 randconfig-i006-20230606   gcc  
i386                 randconfig-i011-20230605   gcc  
i386                 randconfig-i011-20230606   clang
i386                 randconfig-i012-20230605   gcc  
i386                 randconfig-i012-20230606   clang
i386                 randconfig-i013-20230605   gcc  
i386                 randconfig-i013-20230606   clang
i386                 randconfig-i014-20230605   gcc  
i386                 randconfig-i014-20230606   clang
i386                 randconfig-i015-20230605   gcc  
i386                 randconfig-i015-20230606   clang
i386                 randconfig-i016-20230605   gcc  
i386                 randconfig-i016-20230606   clang
i386                 randconfig-i051-20230605   clang
i386                 randconfig-i051-20230606   gcc  
i386                 randconfig-i052-20230605   clang
i386                 randconfig-i052-20230606   gcc  
i386                 randconfig-i053-20230605   clang
i386                 randconfig-i053-20230606   gcc  
i386                 randconfig-i054-20230605   clang
i386                 randconfig-i054-20230606   gcc  
i386                 randconfig-i055-20230605   clang
i386                 randconfig-i055-20230606   gcc  
i386                 randconfig-i056-20230605   clang
i386                 randconfig-i056-20230606   gcc  
i386                 randconfig-i061-20230606   gcc  
i386                 randconfig-i062-20230606   gcc  
i386                 randconfig-i063-20230606   gcc  
i386                 randconfig-i064-20230606   gcc  
i386                 randconfig-i065-20230606   gcc  
i386                 randconfig-i066-20230606   gcc  
i386                 randconfig-r006-20230606   gcc  
i386                 randconfig-r021-20230605   gcc  
i386                 randconfig-r022-20230605   gcc  
i386                 randconfig-r036-20230606   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r012-20230605   gcc  
loongarch            randconfig-r025-20230606   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r001-20230606   gcc  
m68k         buildonly-randconfig-r006-20230605   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r003-20230606   gcc  
m68k                 randconfig-r023-20230605   gcc  
m68k                 randconfig-r032-20230606   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r002-20230606   clang
mips                 randconfig-r021-20230606   gcc  
mips                 randconfig-r025-20230606   gcc  
nios2        buildonly-randconfig-r003-20230606   gcc  
nios2        buildonly-randconfig-r004-20230606   gcc  
nios2        buildonly-randconfig-r005-20230605   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r023-20230606   gcc  
nios2                randconfig-r031-20230605   gcc  
nios2                randconfig-r034-20230606   gcc  
openrisc     buildonly-randconfig-r002-20230606   gcc  
openrisc             randconfig-r002-20230605   gcc  
parisc       buildonly-randconfig-r003-20230606   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r001-20230605   clang
powerpc              randconfig-r012-20230606   clang
powerpc              randconfig-r021-20230606   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r001-20230606   clang
riscv        buildonly-randconfig-r002-20230606   clang
riscv                               defconfig   gcc  
riscv                randconfig-r004-20230606   gcc  
riscv                randconfig-r015-20230605   gcc  
riscv                randconfig-r032-20230605   clang
riscv                randconfig-r032-20230606   gcc  
riscv                randconfig-r042-20230606   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r005-20230606   clang
s390                                defconfig   gcc  
s390                 randconfig-r002-20230606   gcc  
s390                 randconfig-r033-20230605   clang
s390                 randconfig-r035-20230605   clang
s390                 randconfig-r044-20230605   gcc  
s390                 randconfig-r044-20230606   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r001-20230606   gcc  
sh                   randconfig-r033-20230606   gcc  
sh                   randconfig-r034-20230605   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r006-20230605   gcc  
sparc                randconfig-r025-20230605   gcc  
sparc                randconfig-r035-20230605   gcc  
sparc64      buildonly-randconfig-r001-20230605   gcc  
sparc64      buildonly-randconfig-r002-20230605   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230606   gcc  
x86_64               randconfig-a002-20230606   gcc  
x86_64               randconfig-a003-20230606   gcc  
x86_64               randconfig-a004-20230606   gcc  
x86_64               randconfig-a005-20230606   gcc  
x86_64               randconfig-a006-20230606   gcc  
x86_64               randconfig-a011-20230606   clang
x86_64               randconfig-a012-20230606   clang
x86_64               randconfig-a013-20230606   clang
x86_64               randconfig-a014-20230606   clang
x86_64               randconfig-a015-20230606   clang
x86_64               randconfig-a016-20230606   clang
x86_64               randconfig-r003-20230606   gcc  
x86_64               randconfig-r031-20230605   clang
x86_64               randconfig-x051-20230606   clang
x86_64               randconfig-x052-20230606   clang
x86_64               randconfig-x053-20230606   clang
x86_64               randconfig-x054-20230606   clang
x86_64               randconfig-x055-20230606   clang
x86_64               randconfig-x056-20230606   clang
x86_64               randconfig-x061-20230606   clang
x86_64               randconfig-x062-20230605   gcc  
x86_64               randconfig-x062-20230606   clang
x86_64               randconfig-x063-20230605   gcc  
x86_64               randconfig-x063-20230606   clang
x86_64               randconfig-x064-20230606   clang
x86_64               randconfig-x065-20230606   clang
x86_64               randconfig-x066-20230606   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r024-20230606   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
