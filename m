Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053A2C6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 09:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbjCOJwH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 05:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjCOJvQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 05:51:16 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDA037F0F
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 02:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678873844; x=1710409844;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=dhqh+J/59Aag5+qsjt/0dD7dzqtlC5p5P6hL4Ru/+B0=;
  b=XaK/Kr10Ff9lfw8K3H2lw6AaXOWZt1mrbk1gdk1O4M96PEFxgzjKLtjL
   k8EWeOcibNO1qu5U1DrRv7prrtxnaqIzrp2GOzudrGPKHAYhUyY6iOTOO
   aNEpydNsboCXkVBXpcCReulKQJmYXUSQGi3F3brRuJwkFtLIRD9+Vy50F
   wz2N1yxO3xRBuQkBtLUORLaLYw4V9adv2ro3uw5bXgG93yDw5s0BJyNFv
   ZMT+N6ZuI8SQgvfJu8zYn2RuoZydAfX8hibrZTCNzbliQ9VWNXMWR3GON
   kUTB8Hp4LYrqvXN1698YPs5aJCEFLq6VkjB0gG8wL6H22HYPt+RcBts2c
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="321500938"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="321500938"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:50:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="679444661"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="679444661"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 15 Mar 2023 02:50:42 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcNmM-0007bB-06;
        Wed, 15 Mar 2023 09:50:42 +0000
Date:   Wed, 15 Mar 2023 17:50:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 703c560db9a7b61c6ac7cb5fd634d7d5c1c4f38f
Message-ID: <641194c9.xGXEOXWGIfp4usqo%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 703c560db9a7b61c6ac7cb5fd634d7d5c1c4f38f  md/raid10: don't call bio_start_io_acct twice for bio which experienced read error

elapsed time: 723m

configs tested: 174
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r001-20230313   gcc  
alpha        buildonly-randconfig-r006-20230312   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r001-20230313   gcc  
alpha                randconfig-r002-20230313   gcc  
alpha                randconfig-r034-20230313   gcc  
alpha                randconfig-r035-20230313   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r004-20230312   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r004-20230312   gcc  
arc                  randconfig-r012-20230312   gcc  
arc                  randconfig-r023-20230313   gcc  
arc                  randconfig-r031-20230313   gcc  
arc                  randconfig-r043-20230312   gcc  
arc                  randconfig-r043-20230313   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                          moxart_defconfig   clang
arm                        multi_v7_defconfig   gcc  
arm                  randconfig-r002-20230313   clang
arm                  randconfig-r046-20230312   clang
arm                  randconfig-r046-20230313   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r012-20230313   clang
csky         buildonly-randconfig-r003-20230312   gcc  
csky         buildonly-randconfig-r004-20230312   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r003-20230312   gcc  
csky                 randconfig-r022-20230313   gcc  
csky                 randconfig-r023-20230312   gcc  
csky                 randconfig-r025-20230313   gcc  
hexagon              randconfig-r004-20230313   clang
hexagon              randconfig-r015-20230312   clang
hexagon              randconfig-r016-20230313   clang
hexagon              randconfig-r022-20230312   clang
hexagon              randconfig-r041-20230312   clang
hexagon              randconfig-r041-20230313   clang
hexagon              randconfig-r045-20230312   clang
hexagon              randconfig-r045-20230313   clang
i386                             allyesconfig   gcc  
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
ia64         buildonly-randconfig-r002-20230312   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r003-20230313   gcc  
ia64                 randconfig-r005-20230313   gcc  
ia64                 randconfig-r006-20230313   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                            q40_defconfig   gcc  
m68k                 randconfig-r002-20230312   gcc  
m68k                 randconfig-r003-20230312   gcc  
m68k                 randconfig-r003-20230313   gcc  
m68k                 randconfig-r032-20230312   gcc  
m68k                          sun3x_defconfig   gcc  
microblaze   buildonly-randconfig-r002-20230312   gcc  
microblaze   buildonly-randconfig-r002-20230313   gcc  
microblaze           randconfig-r001-20230312   gcc  
microblaze           randconfig-r011-20230312   gcc  
microblaze           randconfig-r012-20230313   gcc  
microblaze           randconfig-r015-20230313   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r001-20230312   gcc  
mips                         cobalt_defconfig   gcc  
mips                         db1xxx_defconfig   gcc  
mips                 randconfig-r013-20230312   clang
mips                 randconfig-r025-20230312   clang
nios2        buildonly-randconfig-r003-20230312   gcc  
nios2        buildonly-randconfig-r005-20230313   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r006-20230312   gcc  
nios2                randconfig-r014-20230312   gcc  
openrisc     buildonly-randconfig-r003-20230313   gcc  
openrisc     buildonly-randconfig-r006-20230313   gcc  
parisc       buildonly-randconfig-r006-20230313   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r005-20230312   gcc  
parisc               randconfig-r011-20230313   gcc  
parisc               randconfig-r021-20230313   gcc  
parisc               randconfig-r034-20230312   gcc  
parisc               randconfig-r035-20230312   gcc  
parisc64                            defconfig   gcc  
powerpc                    adder875_defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r005-20230312   gcc  
powerpc              randconfig-r004-20230312   clang
powerpc                      tqm8xx_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r005-20230313   clang
riscv                               defconfig   gcc  
riscv                randconfig-r011-20230313   clang
riscv                randconfig-r042-20230312   gcc  
riscv                randconfig-r042-20230313   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r006-20230313   gcc  
s390                 randconfig-r013-20230313   clang
s390                 randconfig-r031-20230312   clang
s390                 randconfig-r044-20230312   gcc  
s390                 randconfig-r044-20230313   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r005-20230312   gcc  
sh                            hp6xx_defconfig   gcc  
sh                   randconfig-r024-20230313   gcc  
sh                        sh7763rdp_defconfig   gcc  
sh                          urquell_defconfig   gcc  
sparc        buildonly-randconfig-r001-20230313   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r005-20230312   gcc  
sparc                randconfig-r032-20230313   gcc  
sparc                randconfig-r036-20230313   gcc  
sparc64              randconfig-r001-20230313   gcc  
sparc64              randconfig-r004-20230313   gcc  
sparc64              randconfig-r021-20230312   gcc  
sparc64              randconfig-r026-20230312   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230313   gcc  
x86_64                        randconfig-a001   clang
x86_64               randconfig-a002-20230313   gcc  
x86_64               randconfig-a003-20230313   gcc  
x86_64                        randconfig-a003   clang
x86_64               randconfig-a004-20230313   gcc  
x86_64               randconfig-a005-20230313   gcc  
x86_64                        randconfig-a005   clang
x86_64               randconfig-a006-20230313   gcc  
x86_64               randconfig-a011-20230313   clang
x86_64                        randconfig-a011   gcc  
x86_64               randconfig-a012-20230313   clang
x86_64               randconfig-a013-20230313   clang
x86_64                        randconfig-a013   gcc  
x86_64               randconfig-a014-20230313   clang
x86_64               randconfig-a015-20230313   clang
x86_64                        randconfig-a015   gcc  
x86_64               randconfig-a016-20230313   clang
x86_64                        randconfig-k001   clang
x86_64               randconfig-r016-20230313   clang
x86_64               randconfig-r026-20230313   clang
x86_64               randconfig-r033-20230313   gcc  
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r001-20230312   gcc  
xtensa       buildonly-randconfig-r002-20230313   gcc  
xtensa               randconfig-r013-20230313   gcc  
xtensa               randconfig-r014-20230313   gcc  
xtensa               randconfig-r016-20230312   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
