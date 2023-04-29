Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC89C7618E
	for <linux-raid@archiver.kernel.org>; Sat, 29 Apr 2023 05:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjD2F3E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Apr 2023 01:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjD2F3C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Apr 2023 01:29:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE871FE4
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 22:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682746141; x=1714282141;
  h=date:from:to:cc:subject:message-id;
  bh=B0LHOW9pRXapGnanjq2Fa9uJKkzgvbEuGXHMAmGP+GM=;
  b=S0DXvv5/Lq7zDHBPUHfnJDMGSHyIUgZ9NzA9gaujtmfX4C/D4WOOUbeK
   V0rXNCNV+JBnEcClscsJ4GaxlrLXo59Ged+yBMSIhP85+zn9BclRFjGpE
   gMzZzFiPkt1AbvZL666vHc9TlV5LKDNC4m2ALHunLWQE4xZTRmJ163K7Z
   6GkvS9hKWK6cw0xBjdCGdLFLvkL90nDHCL0UBjAyys2LmEg2O6gdur89e
   hzrFyH/btP/71FZJnLQu11h64MiP4mexKetCtqe9VGMvT2uJucO/LSkml
   CzrVGc1UzOfv++ku/2/v6bjTp3fcQJKPwTGJGi78ofr6J0hJz2SfvoyTh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="375924076"
X-IronPort-AV: E=Sophos;i="5.99,236,1677571200"; 
   d="scan'208";a="375924076"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 22:29:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="941383542"
X-IronPort-AV: E=Sophos;i="5.99,236,1677571200"; 
   d="scan'208";a="941383542"
Received: from lkp-server01.sh.intel.com (HELO 5bad9d2b7fcb) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 28 Apr 2023 22:28:59 -0700
Received: from kbuild by 5bad9d2b7fcb with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1psd8g-0000vl-0r;
        Sat, 29 Apr 2023 05:28:54 +0000
Date:   Sat, 29 Apr 2023 13:28:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 b1211978ecf19bceb63a04f53fea4b5d73832a4a
Message-ID: <20230429052800.feqMc%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: b1211978ecf19bceb63a04f53fea4b5d73832a4a  md: Fix bitmap offset type in sb writer

elapsed time: 724m

configs tested: 102
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r003-20230428   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r002-20230428   gcc  
arc                  randconfig-r004-20230428   gcc  
arc                  randconfig-r006-20230428   gcc  
arc                  randconfig-r043-20230428   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r046-20230428   clang
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r004-20230428   clang
arm64                               defconfig   gcc  
arm64                randconfig-r025-20230428   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r013-20230429   gcc  
csky                 randconfig-r031-20230428   gcc  
hexagon              randconfig-r012-20230429   clang
hexagon              randconfig-r014-20230429   clang
hexagon              randconfig-r032-20230428   clang
hexagon              randconfig-r041-20230428   clang
hexagon              randconfig-r045-20230428   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                          randconfig-a001   gcc  
i386                          randconfig-a002   clang
i386                          randconfig-a003   gcc  
i386                          randconfig-a004   clang
i386                          randconfig-a005   gcc  
i386                          randconfig-a006   clang
i386                          randconfig-a011   clang
i386                          randconfig-a012   gcc  
i386                          randconfig-a013   clang
i386                          randconfig-a014   gcc  
i386                          randconfig-a015   clang
i386                          randconfig-a016   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
microblaze   buildonly-randconfig-r005-20230428   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r023-20230428   clang
nios2        buildonly-randconfig-r001-20230428   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r001-20230428   gcc  
nios2                randconfig-r024-20230428   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r003-20230428   gcc  
parisc               randconfig-r022-20230428   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r015-20230429   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r002-20230428   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r016-20230429   clang
riscv                randconfig-r033-20230428   clang
riscv                randconfig-r034-20230428   clang
riscv                randconfig-r042-20230428   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r011-20230429   clang
s390                 randconfig-r044-20230428   gcc  
sh                               allmodconfig   gcc  
sparc                               defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                        randconfig-a001   clang
x86_64                        randconfig-a002   gcc  
x86_64                        randconfig-a003   clang
x86_64                        randconfig-a004   gcc  
x86_64                        randconfig-a005   clang
x86_64                        randconfig-a006   gcc  
x86_64                        randconfig-a011   gcc  
x86_64                        randconfig-a012   clang
x86_64                        randconfig-a013   gcc  
x86_64                        randconfig-a014   clang
x86_64                        randconfig-a015   gcc  
x86_64                        randconfig-a016   clang
x86_64                        randconfig-k001   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r005-20230428   gcc  
xtensa               randconfig-r026-20230428   gcc  
xtensa               randconfig-r035-20230428   gcc  
xtensa               randconfig-r036-20230428   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
