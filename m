Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AADC77B71
	for <linux-raid@archiver.kernel.org>; Tue, 25 Apr 2023 10:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjDYKx4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Apr 2023 06:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjDYKxy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Apr 2023 06:53:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7984749D2
        for <linux-raid@vger.kernel.org>; Tue, 25 Apr 2023 03:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682420033; x=1713956033;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ST/04kv8xenewn65AFuN56ZHb09fgNHRvOlPajkmcCc=;
  b=UEDwbYldzvvIlz6XNP0Mdp7yVP8HPXl4vKEnsfnRCBTTdaTYEwNpl5ka
   Gx2SO6JyzcIXPKEQB0rPFgHlN/yQ2MDDL0ec1arTqcDjcK7ce05zPI5aX
   Dd/ZUmiWFYrP0+BUcjYgmtdYrDPIEje9IxXCHK0Zuh2b9xt9I6Aoz/mW4
   4g8EQPmjwRN9qv5u8TXmYqN7kelw43nmI77X7C8WngMMPUFstql0pRtdM
   Kx3qzppVEBc/lEksOaMX1u4JS6kwnRxEymhfJQ9ngEjc1pkx5kKnjcmdI
   CQfs2fIX7bi8Y0j0s8h5rBoDk88DFGhnPtp4leOLCeIP4XFOE2Ijrx8OK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="349520714"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="349520714"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 03:53:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="723979179"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="723979179"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 25 Apr 2023 03:53:36 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1prGIc-000jJy-24;
        Tue, 25 Apr 2023 10:53:30 +0000
Date:   Tue, 25 Apr 2023 18:52:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 fd08656801050f3f508f455343ab77fd51a76980
Message-ID: <6447b109.68KdzrC+awF+aHOo%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: fd08656801050f3f508f455343ab77fd51a76980  md/raid5: Improve performance for sequential IO

elapsed time: 720m

configs tested: 128
configs skipped: 14

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r005-20230424   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r004-20230423   gcc  
alpha                randconfig-r013-20230423   gcc  
alpha                randconfig-r021-20230423   gcc  
alpha                randconfig-r026-20230423   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r002-20230423   gcc  
arc                  randconfig-r036-20230425   gcc  
arc                  randconfig-r043-20230423   gcc  
arc                  randconfig-r043-20230424   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r001-20230424   clang
arm                                 defconfig   gcc  
arm                  randconfig-r002-20230424   gcc  
arm                  randconfig-r012-20230423   gcc  
arm                  randconfig-r023-20230423   gcc  
arm                  randconfig-r046-20230423   gcc  
arm                  randconfig-r046-20230424   clang
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r004-20230423   gcc  
arm64        buildonly-randconfig-r006-20230423   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r004-20230424   clang
csky                                defconfig   gcc  
csky                 randconfig-r003-20230423   gcc  
csky                 randconfig-r022-20230423   gcc  
csky                 randconfig-r025-20230423   gcc  
csky                 randconfig-r026-20230424   gcc  
csky                 randconfig-r032-20230425   gcc  
hexagon              randconfig-r041-20230423   clang
hexagon              randconfig-r041-20230424   clang
hexagon              randconfig-r045-20230423   clang
hexagon              randconfig-r045-20230424   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230424   clang
i386                 randconfig-a002-20230424   clang
i386                 randconfig-a003-20230424   clang
i386                 randconfig-a004-20230424   clang
i386                 randconfig-a005-20230424   clang
i386                 randconfig-a006-20230424   clang
i386                 randconfig-a011-20230424   gcc  
i386                 randconfig-a012-20230424   gcc  
i386                 randconfig-a013-20230424   gcc  
i386                 randconfig-a014-20230424   gcc  
i386                 randconfig-a015-20230424   gcc  
i386                 randconfig-a016-20230424   gcc  
ia64                             allmodconfig   gcc  
ia64         buildonly-randconfig-r001-20230423   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r006-20230423   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r013-20230424   gcc  
loongarch            randconfig-r031-20230425   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r003-20230424   gcc  
m68k                 randconfig-r021-20230424   gcc  
m68k                 randconfig-r034-20230425   gcc  
microblaze   buildonly-randconfig-r004-20230424   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r011-20230423   gcc  
mips                 randconfig-r015-20230424   clang
nios2        buildonly-randconfig-r003-20230423   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r024-20230423   gcc  
nios2                randconfig-r025-20230424   gcc  
nios2                randconfig-r026-20230423   gcc  
openrisc     buildonly-randconfig-r002-20230423   gcc  
openrisc             randconfig-r006-20230424   gcc  
parisc       buildonly-randconfig-r006-20230424   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r021-20230423   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r003-20230424   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230423   clang
riscv                randconfig-r042-20230424   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r001-20230424   clang
s390                 randconfig-r014-20230424   gcc  
s390                 randconfig-r044-20230423   clang
s390                 randconfig-r044-20230424   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r005-20230424   gcc  
sh                   randconfig-r023-20230424   gcc  
sh                   randconfig-r025-20230423   gcc  
sh                   randconfig-r035-20230425   gcc  
sparc                               defconfig   gcc  
sparc64              randconfig-r014-20230423   gcc  
sparc64              randconfig-r016-20230423   gcc  
sparc64              randconfig-r023-20230423   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230424   clang
x86_64               randconfig-a002-20230424   clang
x86_64               randconfig-a003-20230424   clang
x86_64               randconfig-a004-20230424   clang
x86_64               randconfig-a005-20230424   clang
x86_64               randconfig-a006-20230424   clang
x86_64               randconfig-a011-20230424   gcc  
x86_64               randconfig-a012-20230424   gcc  
x86_64               randconfig-a013-20230424   gcc  
x86_64               randconfig-a014-20230424   gcc  
x86_64               randconfig-a015-20230424   gcc  
x86_64               randconfig-a016-20230424   gcc  
x86_64                        randconfig-k001   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r033-20230425   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
