Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7811ACDB465
	for <linux-raid@archiver.kernel.org>; Thu, 19 Oct 2023 12:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbjJSMwO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Oct 2023 08:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbjJSMwO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Oct 2023 08:52:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC28F7
        for <linux-raid@vger.kernel.org>; Thu, 19 Oct 2023 05:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697719932; x=1729255932;
  h=date:from:to:cc:subject:message-id;
  bh=+Bfuz2WmsFIJc4E2bll23um2muda9LHDxWF6TTBZHSI=;
  b=EbtxXn9mY3bov1Qje1BlHowR4TsHqVH38MJeZeWVz/RxKpngGWEVMyfo
   9kko2tiXtXAF05tpC1sKj8aY6n44esBawrw/ny/NNy+BAwsyW8SBgjAzc
   1v2xMTlp7BViAssB53zxay3b2Xy3G2yV6kF75tj5wP79bUTB/43YnLkDs
   Js5nIF3vJY4DBbFF+3dPCLcIoWNiNy9+HBF6Ikl9VYDSHm9dFMb3cBIuG
   x/tKT9wBUdorF3ydJufllWRSvBmYo3AdhEp3+RF6lIffEFPpoRqgUvNNU
   Ybyd0fFCEo5pd+IzccHxQk3evvOTv0ZAFS3WKBbCBkq9LbUxl9Os59jDI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="371304261"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="371304261"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 05:52:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="1088348938"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="1088348938"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 19 Oct 2023 05:52:10 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qtSVU-00027K-19;
        Thu, 19 Oct 2023 12:52:08 +0000
Date:   Thu, 19 Oct 2023 20:51:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 78b7b13f07a3ca16c03aa8bf63f51d6780e8e9e1
Message-ID: <202310192008.OReuOqx6-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 78b7b13f07a3ca16c03aa8bf63f51d6780e8e9e1  md: cleanup pers->prepare_suspend()

elapsed time: 1117m

configs tested: 149
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                   randconfig-001-20231019   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                   randconfig-001-20231019   gcc  
arm64                            allmodconfig   gcc  
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20231019   gcc  
i386         buildonly-randconfig-002-20231019   gcc  
i386         buildonly-randconfig-003-20231019   gcc  
i386         buildonly-randconfig-004-20231019   gcc  
i386         buildonly-randconfig-005-20231019   gcc  
i386         buildonly-randconfig-006-20231019   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                  randconfig-001-20231019   gcc  
i386                  randconfig-002-20231019   gcc  
i386                  randconfig-003-20231019   gcc  
i386                  randconfig-004-20231019   gcc  
i386                  randconfig-005-20231019   gcc  
i386                  randconfig-006-20231019   gcc  
i386                  randconfig-011-20231019   gcc  
i386                  randconfig-012-20231019   gcc  
i386                  randconfig-013-20231019   gcc  
i386                  randconfig-014-20231019   gcc  
i386                  randconfig-015-20231019   gcc  
i386                  randconfig-016-20231019   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20231019   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                       bvme6000_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                          sun3x_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                           xway_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
openrisc                         alldefconfig   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                     akebono_defconfig   clang
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   gcc  
powerpc                 mpc8315_rdb_defconfig   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                 randconfig-001-20231019   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20231019   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                           se7780_defconfig   gcc  
sh                        sh7757lcr_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                 randconfig-001-20231019   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-001-20231019   gcc  
x86_64       buildonly-randconfig-002-20231019   gcc  
x86_64       buildonly-randconfig-003-20231019   gcc  
x86_64       buildonly-randconfig-004-20231019   gcc  
x86_64       buildonly-randconfig-005-20231019   gcc  
x86_64       buildonly-randconfig-006-20231019   gcc  
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20231019   gcc  
x86_64                randconfig-002-20231019   gcc  
x86_64                randconfig-003-20231019   gcc  
x86_64                randconfig-004-20231019   gcc  
x86_64                randconfig-005-20231019   gcc  
x86_64                randconfig-006-20231019   gcc  
x86_64                randconfig-011-20231019   gcc  
x86_64                randconfig-012-20231019   gcc  
x86_64                randconfig-013-20231019   gcc  
x86_64                randconfig-014-20231019   gcc  
x86_64                randconfig-015-20231019   gcc  
x86_64                randconfig-016-20231019   gcc  
x86_64                randconfig-071-20231019   gcc  
x86_64                randconfig-072-20231019   gcc  
x86_64                randconfig-073-20231019   gcc  
x86_64                randconfig-074-20231019   gcc  
x86_64                randconfig-075-20231019   gcc  
x86_64                randconfig-076-20231019   gcc  
x86_64                          rhel-8.3-func   gcc  
x86_64                    rhel-8.3-kselftests   gcc  
x86_64                           rhel-8.3-ltp   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                  audio_kc705_defconfig   gcc  
xtensa                       common_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
