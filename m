Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DC0C74A5B
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 13:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjCNN5K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 09:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjCNN4u (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 09:56:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC896410B0
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 06:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678802141; x=1710338141;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=EkVyuVmzDVHHlcF9AKe043oGrV5nIEeoCQ0YR7Z87Yw=;
  b=JhlP8D36y1bWKtLoDrJEp1TRptxCd0RwF3OkEVIvUMCfdy0gtdGJJEhu
   T1LAQMfxqvQPaC717I9G069cfLLDPoaES93Qrv0JEQaQGbWC3e/AfYll/
   ScGHBAe3d1YhjNlJAlDfmQmf0jpBiXoBwBcaDC5HlmaCTnwPxg0nVjqQH
   pJ0omUy3qZPZaYkg0Odsd9QNratvcNy9N8ZH40cNPaeOIWWEpqtGB5x0k
   efMPHw40/Fqk8K6Sri1gQlBg7PDUiUCQ5dgW4clM892JenERnmiW/nlJM
   sRBmczU9wICFyfrlIB5+CbufKun4Z3eS3C67W+S+lYElBl4suU5QPNcHb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="400015068"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="400015068"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 06:55:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="748018194"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="748018194"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2023 06:55:39 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pc57q-0006xu-3A;
        Tue, 14 Mar 2023 13:55:38 +0000
Date:   Tue, 14 Mar 2023 21:54:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD REGRESSION
 ec7246c9455e83f452055cec9c39bd54e72217a4
Message-ID: <64107ca0.LePHwBxci0R8S0gs%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: ec7246c9455e83f452055cec9c39bd54e72217a4  md: protect md_thread with a new disk level spin lock

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202303141758.4EtLtIA1-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303141841.7hUZnSGb-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/md/md-cluster.c:425:42: error: use of undeclared identifier 'mddev'; did you mean 'mode'?
drivers/md/md-cluster.c:425:63: error: 'mddev' undeclared (first use in this function)

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- m68k-allmodconfig
|   `-- drivers-md-md-cluster.c:error:mddev-undeclared-(first-use-in-this-function)
`-- m68k-allyesconfig
    `-- drivers-md-md-cluster.c:error:mddev-undeclared-(first-use-in-this-function)
clang_recent_errors
`-- s390-randconfig-r032-20230312
    `-- drivers-md-md-cluster.c:error:use-of-undeclared-identifier-mddev

elapsed time: 722m

configs tested: 132
configs skipped: 10

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r002-20230313   gcc  
alpha                randconfig-r016-20230312   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r002-20230313   gcc  
arc          buildonly-randconfig-r004-20230313   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r004-20230312   gcc  
arc                  randconfig-r043-20230312   gcc  
arc                  randconfig-r043-20230313   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r024-20230313   gcc  
arm                  randconfig-r046-20230312   clang
arm                  randconfig-r046-20230313   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r021-20230312   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r003-20230312   gcc  
csky                 randconfig-r033-20230313   gcc  
csky                 randconfig-r036-20230312   gcc  
hexagon              randconfig-r001-20230312   clang
hexagon              randconfig-r005-20230313   clang
hexagon              randconfig-r012-20230313   clang
hexagon              randconfig-r016-20230313   clang
hexagon              randconfig-r025-20230312   clang
hexagon              randconfig-r031-20230313   clang
hexagon              randconfig-r041-20230312   clang
hexagon              randconfig-r041-20230313   clang
hexagon              randconfig-r045-20230312   clang
hexagon              randconfig-r045-20230313   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r003-20230313   gcc  
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
ia64                             allmodconfig   gcc  
ia64         buildonly-randconfig-r006-20230312   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r006-20230313   gcc  
ia64                 randconfig-r022-20230313   gcc  
ia64                 randconfig-r023-20230313   gcc  
ia64                 randconfig-r025-20230313   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r026-20230312   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r003-20230313   gcc  
m68k                 randconfig-r011-20230313   gcc  
m68k                 randconfig-r013-20230312   gcc  
m68k                 randconfig-r031-20230312   gcc  
m68k                 randconfig-r035-20230313   gcc  
microblaze           randconfig-r032-20230313   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r004-20230312   gcc  
mips                 randconfig-r015-20230312   clang
mips                 randconfig-r023-20230312   clang
mips                 randconfig-r024-20230312   clang
mips                 randconfig-r034-20230313   clang
nios2                               defconfig   gcc  
parisc       buildonly-randconfig-r005-20230313   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r005-20230312   gcc  
parisc               randconfig-r034-20230312   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r011-20230312   gcc  
powerpc              randconfig-r013-20230313   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r001-20230312   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r033-20230312   clang
riscv                randconfig-r042-20230312   gcc  
riscv                randconfig-r042-20230313   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r006-20230313   clang
s390                                defconfig   gcc  
s390                 randconfig-r002-20230312   clang
s390                 randconfig-r032-20230312   clang
s390                 randconfig-r044-20230312   gcc  
s390                 randconfig-r044-20230313   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r005-20230312   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r022-20230312   gcc  
sparc64              randconfig-r001-20230313   gcc  
sparc64              randconfig-r004-20230313   gcc  
sparc64              randconfig-r014-20230312   gcc  
sparc64              randconfig-r014-20230313   gcc  
sparc64              randconfig-r021-20230313   gcc  
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
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r015-20230313   gcc  
xtensa               randconfig-r035-20230312   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
