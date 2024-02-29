Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A750B16FF5F
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 22:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244878; cv=none; b=oVI4ksRb6dLXJYQyQii4WHUrEVtjduGE4VNa+w3r8DwS9E9c3gcCD4rdPS6GZm9RdHq59ulfHXA1islvHuGjxcI5miPZyCx9DdLrWd82ba+fiCqSlry0kvaJ9kPSLEOuhc0cqyP2cBds8s79+4SC/Qx5/uNywrMSDM0EG3kvACo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244878; c=relaxed/simple;
	bh=nsl4bBvEbqTq2OAf3HzGOw/LkXZacCQEL63Wa+jKsxQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Ax9qo6mMmwSCuRR/ONNEKOpBtAC5Evv5+qqXLClqzyPJyg0iPIctig0lB5Sbl+0q2EYtu5MyFlbMXRqHazQcefPFDYqCL6zzWOjUPI8f90Cp3zu5jZiRsBpS1UHwDb9cDchgZHNBd58PgrKlOW2AqIwVfnG9BYipDPaRWJuTE8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IdX6MmAX; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IdX6MmAX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709244877; x=1740780877;
  h=date:from:to:cc:subject:message-id;
  bh=nsl4bBvEbqTq2OAf3HzGOw/LkXZacCQEL63Wa+jKsxQ=;
  b=IdX6MmAXDcTi4pOqrDFMS9TV5WJH6S/Epm/Wfzgx3d8sJSzGmVdwWJzS
   /+4OBjIxi9MehUs7Hi/2wu4CR+k14Hs879iiWlfMymGR8QAEA+VqjmLzU
   HTgiReT+sGHG9FKMHWZih8o60XVg2eJROCUCtr7sTg8FueocDZbJbDsRZ
   cG63pdCG9teEflsZGzNkhelwH6WPHXMBQpWv6HGsmCztfsqTBoRR53R+Z
   uC0yFls2pXMuDD6VTC1vlh3M1l1okmTBV5IKUTOppuLVyn6nvYdB5lRhi
   T6zrOsVAq1emziqSgZspbm65ElituZMdS/H2e7162ebMzEp3JQy6jX922
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="4335113"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="4335113"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 14:14:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="12665396"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 29 Feb 2024 14:14:34 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rfofg-000DJl-09;
	Thu, 29 Feb 2024 22:14:32 +0000
Date: Fri, 01 Mar 2024 06:13:44 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.9-for-hch] BUILD SUCCESS
 aee93ec0ec79d2875d3c76571d49586322f667b1
Message-ID: <202403010641.g2PTSTZk-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.9-for-hch
branch HEAD: aee93ec0ec79d2875d3c76571d49586322f667b1  md: Don't suspend the array for interrupted reshape

elapsed time: 1243m

configs tested: 185
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                      axs103_smp_defconfig   gcc  
arc                                 defconfig   gcc  
arc                        nsimosci_defconfig   gcc  
arc                   randconfig-001-20240229   gcc  
arc                   randconfig-002-20240229   gcc  
arc                    vdk_hs38_smp_defconfig   gcc  
arm                              alldefconfig   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                                 defconfig   clang
arm                            dove_defconfig   gcc  
arm                   randconfig-001-20240229   gcc  
arm                   randconfig-002-20240229   gcc  
arm                   randconfig-004-20240229   gcc  
arm                          sp7021_defconfig   gcc  
arm                           spitz_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-002-20240229   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240229   gcc  
csky                  randconfig-002-20240229   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240229   clang
i386         buildonly-randconfig-003-20240301   gcc  
i386         buildonly-randconfig-004-20240229   clang
i386                                defconfig   clang
i386                  randconfig-001-20240229   clang
i386                  randconfig-003-20240229   clang
i386                  randconfig-005-20240301   gcc  
i386                  randconfig-006-20240301   gcc  
i386                  randconfig-011-20240301   gcc  
i386                  randconfig-013-20240229   clang
i386                  randconfig-014-20240229   clang
i386                  randconfig-014-20240301   gcc  
i386                  randconfig-015-20240229   clang
i386                  randconfig-015-20240301   gcc  
i386                  randconfig-016-20240229   clang
i386                  randconfig-016-20240301   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240229   gcc  
loongarch             randconfig-002-20240229   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                            q40_defconfig   gcc  
m68k                           sun3_defconfig   gcc  
m68k                           virt_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                       bmips_be_defconfig   gcc  
mips                  cavium_octeon_defconfig   gcc  
mips                malta_qemu_32r6_defconfig   gcc  
mips                       rbtx49xx_defconfig   gcc  
mips                          rm200_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240229   gcc  
nios2                 randconfig-002-20240229   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc                  or1klitex_defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240229   gcc  
parisc                randconfig-002-20240229   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                     ep8248e_defconfig   gcc  
powerpc                          g5_defconfig   gcc  
powerpc                     ksi8560_defconfig   gcc  
powerpc               randconfig-002-20240229   gcc  
powerpc                 xes_mpc85xx_defconfig   gcc  
powerpc64             randconfig-001-20240229   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-002-20240229   gcc  
sh                               alldefconfig   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                          kfr2r09_defconfig   gcc  
sh                          polaris_defconfig   gcc  
sh                    randconfig-001-20240229   gcc  
sh                    randconfig-002-20240229   gcc  
sh                          rsk7201_defconfig   gcc  
sh                          sdk7780_defconfig   gcc  
sh                           se7206_defconfig   gcc  
sh                           se7705_defconfig   gcc  
sh                   sh7724_generic_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                       sparc32_defconfig   gcc  
sparc                       sparc64_defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240229   gcc  
sparc64               randconfig-002-20240229   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                    randconfig-001-20240229   gcc  
um                    randconfig-002-20240229   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-002-20240229   clang
x86_64       buildonly-randconfig-002-20240301   gcc  
x86_64       buildonly-randconfig-004-20240301   gcc  
x86_64       buildonly-randconfig-006-20240301   gcc  
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240229   clang
x86_64                randconfig-001-20240301   gcc  
x86_64                randconfig-002-20240229   clang
x86_64                randconfig-003-20240229   clang
x86_64                randconfig-004-20240229   clang
x86_64                randconfig-005-20240229   clang
x86_64                randconfig-005-20240301   gcc  
x86_64                randconfig-006-20240229   clang
x86_64                randconfig-006-20240301   gcc  
x86_64                randconfig-014-20240301   gcc  
x86_64                randconfig-016-20240301   gcc  
x86_64                randconfig-071-20240229   clang
x86_64                randconfig-071-20240301   gcc  
x86_64                randconfig-072-20240229   clang
x86_64                randconfig-073-20240229   clang
x86_64                randconfig-073-20240301   gcc  
x86_64                randconfig-074-20240229   clang
x86_64                randconfig-074-20240301   gcc  
x86_64                randconfig-075-20240301   gcc  
x86_64                randconfig-076-20240229   clang
x86_64                randconfig-076-20240301   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                          iss_defconfig   gcc  
xtensa                randconfig-001-20240229   gcc  
xtensa                randconfig-002-20240229   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
