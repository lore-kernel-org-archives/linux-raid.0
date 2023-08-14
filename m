Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C27C001E0
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 07:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbjHNHHN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 03:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbjHNHHJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 03:07:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D7FE63
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 00:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691996828; x=1723532828;
  h=date:from:to:cc:subject:message-id;
  bh=cDRKaMo6DwO9hx9eJ4CqMgO/xDER9UQ8IYffgoAXVKw=;
  b=UcZG0yL1gv/4si0ADa2ukk8+RD3Nfrw5AN15jsb4ehZGwMySirctwELI
   vvUIerwz7Wjo9SLSTUggqFjika5etEheziky588jbrZmbtz/vbG50edCR
   EaFBTLRAGf46uoa0k5WUrRT7WSnAV9jI6VjZC/iPMwzOaGSZza88riP4P
   bTT3DElOZLc3RjGZlH5NBFEuPLIjNb1ztrErX4tjHGLqgyedKoq6kwcr4
   yX71wqaLH7dkfw6ywKlDnDJrVmTvndP4OcyMXQLvo4upoMkOzfHWBhfsC
   GcxDbrBCS/aVekggYy9eRw+Pn0S2HyfE1aqAb5LrNwwclhADBdseIwJr6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="370878116"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="370878116"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 00:07:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="1063962521"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="1063962521"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 14 Aug 2023 00:06:44 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qVRf1-0009P2-2O;
        Mon, 14 Aug 2023 07:06:43 +0000
Date:   Mon, 14 Aug 2023 15:06:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 733fd910ffa5cdc26776c98cc4612b0ce3e2bbfd
Message-ID: <202308141502.TKaGobvr-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 733fd910ffa5cdc26776c98cc4612b0ce3e2bbfd  md/raid5-cache: fix null-ptr-deref for r5l_flush_stripe_to_raid()

elapsed time: 723m

configs tested: 107
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r031-20230814   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r043-20230814   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r046-20230814   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r016-20230814   clang
csky                                defconfig   gcc  
hexagon              randconfig-r012-20230814   clang
hexagon              randconfig-r041-20230814   clang
hexagon              randconfig-r045-20230814   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230814   gcc  
i386         buildonly-randconfig-r005-20230814   gcc  
i386         buildonly-randconfig-r006-20230814   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230814   gcc  
i386                 randconfig-i002-20230814   gcc  
i386                 randconfig-i003-20230814   gcc  
i386                 randconfig-i004-20230814   gcc  
i386                 randconfig-i005-20230814   gcc  
i386                 randconfig-i006-20230814   gcc  
i386                 randconfig-i011-20230814   clang
i386                 randconfig-i012-20230814   clang
i386                 randconfig-i013-20230814   clang
i386                 randconfig-i014-20230814   clang
i386                 randconfig-i015-20230814   clang
i386                 randconfig-i016-20230814   clang
i386                 randconfig-r022-20230814   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r026-20230814   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r033-20230814   gcc  
microblaze           randconfig-r032-20230814   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r006-20230814   gcc  
openrisc             randconfig-r024-20230814   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r036-20230814   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r003-20230814   gcc  
riscv                randconfig-r021-20230814   clang
riscv                randconfig-r034-20230814   gcc  
riscv                randconfig-r042-20230814   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r023-20230814   clang
s390                 randconfig-r044-20230814   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r035-20230814   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r025-20230814   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                   randconfig-r004-20230814   clang
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230814   gcc  
x86_64       buildonly-randconfig-r002-20230814   gcc  
x86_64       buildonly-randconfig-r003-20230814   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r005-20230814   gcc  
x86_64               randconfig-x001-20230814   clang
x86_64               randconfig-x002-20230814   clang
x86_64               randconfig-x003-20230814   clang
x86_64               randconfig-x004-20230814   clang
x86_64               randconfig-x005-20230814   clang
x86_64               randconfig-x006-20230814   clang
x86_64               randconfig-x011-20230814   gcc  
x86_64               randconfig-x012-20230814   gcc  
x86_64               randconfig-x013-20230814   gcc  
x86_64               randconfig-x014-20230814   gcc  
x86_64               randconfig-x015-20230814   gcc  
x86_64               randconfig-x016-20230814   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r001-20230814   gcc  
xtensa               randconfig-r002-20230814   gcc  
xtensa               randconfig-r013-20230814   gcc  
xtensa               randconfig-r015-20230814   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
