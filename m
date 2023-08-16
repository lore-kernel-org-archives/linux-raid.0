Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D571CC04A94
	for <linux-raid@archiver.kernel.org>; Wed, 16 Aug 2023 05:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbjHPFzJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Aug 2023 01:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241951AbjHPFyj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Aug 2023 01:54:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D23C19B9
        for <linux-raid@vger.kernel.org>; Tue, 15 Aug 2023 22:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692165278; x=1723701278;
  h=date:from:to:cc:subject:message-id;
  bh=f+K5Lzg1MaKJvTeK9R8rNVi7+eM6QFI0lqCgXC7mNII=;
  b=dgzj7sNubG8RNG6Cqh2UPisxeWWN/9Q360sVC3k6336wCTBppcWfkQ5O
   ZKUew7iznzfAxVeTfrn5TiAvsVAMsz4AjBMtjfLxn6wEWZe2qBw+7vNWc
   POkSpmYut7m+vXOUT9fT7JNhhRq50rj3tasMaOe0/pre7w/LmbBhxV0HY
   eGMnWNP/9aTDfOUnLva5oh/VNH2nGb3O/8rKAvV+URKzl9SZnrfiogajL
   Kuf9OUNojbXC00EejxZCzEygqI0B9/TV9NyYrjRitttNV8pxgmoAcnLZZ
   78B8aHE983DsUwXKjuNDTcz5yQbAgSPx3M98wASFNH8gOJ3Vz40m+J9+3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="357424375"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="357424375"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 22:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="799447307"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="799447307"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 15 Aug 2023 22:54:35 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qW9UI-000028-2G;
        Wed, 16 Aug 2023 05:54:34 +0000
Date:   Wed, 16 Aug 2023 13:54:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 a85e83948c4087dade3443042b20ab9e07f1e735
Message-ID: <202308161300.lZLLla0f-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: a85e83948c4087dade3443042b20ab9e07f1e735  md/raid0: Fix performance regression for large sequential writes

elapsed time: 722m

configs tested: 130
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r016-20230816   gcc  
alpha                randconfig-r022-20230816   gcc  
alpha                randconfig-r025-20230816   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r002-20230816   gcc  
arc                  randconfig-r006-20230816   gcc  
arc                  randconfig-r021-20230816   gcc  
arc                  randconfig-r043-20230816   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                       multi_v4t_defconfig   gcc  
arm                  randconfig-r003-20230816   clang
arm                  randconfig-r036-20230816   clang
arm                  randconfig-r046-20230816   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r026-20230816   gcc  
csky                 randconfig-r032-20230816   gcc  
hexagon              randconfig-r011-20230816   clang
hexagon              randconfig-r033-20230816   clang
hexagon              randconfig-r041-20230816   clang
hexagon              randconfig-r045-20230816   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230816   gcc  
i386         buildonly-randconfig-r005-20230816   gcc  
i386         buildonly-randconfig-r006-20230816   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230816   gcc  
i386                 randconfig-i002-20230816   gcc  
i386                 randconfig-i003-20230816   gcc  
i386                 randconfig-i004-20230816   gcc  
i386                 randconfig-i005-20230816   gcc  
i386                 randconfig-i006-20230816   gcc  
i386                 randconfig-i011-20230816   clang
i386                 randconfig-i012-20230816   clang
i386                 randconfig-i013-20230816   clang
i386                 randconfig-i014-20230816   clang
i386                 randconfig-i015-20230816   clang
i386                 randconfig-i016-20230816   clang
i386                 randconfig-r001-20230816   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             alldefconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r022-20230816   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                         cobalt_defconfig   gcc  
mips                         rt305x_defconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r031-20230816   gcc  
openrisc             randconfig-r002-20230816   gcc  
openrisc             randconfig-r012-20230816   gcc  
openrisc             randconfig-r023-20230816   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                generic-64bit_defconfig   gcc  
parisc               randconfig-r024-20230816   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                     ksi8560_defconfig   clang
powerpc                 mpc834x_itx_defconfig   gcc  
powerpc                      tqm8xx_defconfig   gcc  
powerpc                 xes_mpc85xx_defconfig   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230816   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r044-20230816   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r001-20230816   gcc  
sh                   randconfig-r004-20230816   gcc  
sh                   randconfig-r013-20230816   gcc  
sh                   randconfig-r021-20230816   gcc  
sh                   randconfig-r025-20230816   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r021-20230816   gcc  
sparc                randconfig-r023-20230816   gcc  
sparc                randconfig-r024-20230816   gcc  
sparc                randconfig-r026-20230816   gcc  
sparc64              randconfig-r004-20230816   gcc  
sparc64              randconfig-r006-20230816   gcc  
sparc64              randconfig-r035-20230816   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                   randconfig-r033-20230816   clang
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230816   gcc  
x86_64       buildonly-randconfig-r002-20230816   gcc  
x86_64       buildonly-randconfig-r003-20230816   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r025-20230816   clang
x86_64               randconfig-x001-20230816   clang
x86_64               randconfig-x002-20230816   clang
x86_64               randconfig-x003-20230816   clang
x86_64               randconfig-x004-20230816   clang
x86_64               randconfig-x005-20230816   clang
x86_64               randconfig-x006-20230816   clang
x86_64               randconfig-x011-20230816   gcc  
x86_64               randconfig-x012-20230816   gcc  
x86_64               randconfig-x013-20230816   gcc  
x86_64               randconfig-x014-20230816   gcc  
x86_64               randconfig-x015-20230816   gcc  
x86_64               randconfig-x016-20230816   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                         rhel-8.3-kunit   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r005-20230816   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
