Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DF77F
	for <linux-raid@vger.kernel.org>; Wed, 14 Feb 2024 00:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707870157; cv=none; b=rH7WPcPzegU5fZrj/m3Hw2hA+M52scnl4D9ftWtvJB1fKYCka0wnxeXvTByF6WglBKlVRVbOfr6aO3ZDW3gMKdGIQ1sGEOlWq4isrL7SDzpEsCJLXM7/IyuImP8w0QgNwW0tYfnMkJhSt53FAgLknRt+dvGNpjzi/+ZURMErTSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707870157; c=relaxed/simple;
	bh=BYAcVCx8AhF+drKGmDxWionz+1Ga9lTGx2dfV0C8rEQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Taj2SkqqKRCxfRM1BVZnZeMnTNx/x1xmlwRgQSoXXpIRoPjaVJ/Sdcn5752m5tKcx4OyfX+zzRlug5YDu5rgY+oVIeAA3Zq8lVXjq/GaZcuscWsHijHUr13oxcugramrUFmY27TK6tdhAElPJ2qEjx86MOKLTN60Z2lc9TNrkxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PJXaP4NU; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PJXaP4NU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707870156; x=1739406156;
  h=date:from:to:cc:subject:message-id;
  bh=BYAcVCx8AhF+drKGmDxWionz+1Ga9lTGx2dfV0C8rEQ=;
  b=PJXaP4NUjT3ZjlDGVFIy1RWt7Phd9eugKxgLzZg7B2PKwGA34+0tS9eQ
   cOoh4HMKEE22w13+mH9dot55/ZgoJMo3wRDKv87XSq1YIlNJsdHMOpKmI
   uDZE11DxXtIANRq/ESO0QPsTMLMUznWwc55+ViLTlNB0Bx5Lf19loKTCZ
   ybheBpotM7cBcVF/xqBV2bJyVi2u9wfdgHfr5Pq91+v9pBKJZxOOhM/HD
   1igSI8gJVqB109w3FaL7cZ6WfH27aZwlGQa3ibSJw8+IyJx0cK+4HLnpJ
   7F9Qa+76LJ+uX8qOgXEy603m+BEKFTB96FR2MEZSIGMrG9vPkLSGRSuRO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="1779761"
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="1779761"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 16:22:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="7787585"
Received: from lkp-server01.sh.intel.com (HELO 01f0647817ea) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 13 Feb 2024 16:22:22 -0800
Received: from kbuild by 01f0647817ea with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ra32a-0008B2-0N;
	Wed, 14 Feb 2024 00:22:20 +0000
Date: Wed, 14 Feb 2024 08:22:15 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.9] BUILD SUCCESS
 6cf350658736681b9d6b0b6e58c5c76b235bb4c4
Message-ID: <202402140813.eotzscve-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.9
branch HEAD: 6cf350658736681b9d6b0b6e58c5c76b235bb4c4  md: fix kmemleak of rdev->serial

elapsed time: 1450m

configs tested: 234
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            alldefconfig   gcc  
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                        nsim_700_defconfig   gcc  
arc                   randconfig-001-20240213   gcc  
arc                   randconfig-001-20240214   gcc  
arc                   randconfig-002-20240213   gcc  
arc                   randconfig-002-20240214   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                          collie_defconfig   gcc  
arm                                 defconfig   clang
arm                            mmp2_defconfig   gcc  
arm                       netwinder_defconfig   gcc  
arm                           omap1_defconfig   gcc  
arm                             pxa_defconfig   gcc  
arm                   randconfig-001-20240213   gcc  
arm                   randconfig-002-20240213   gcc  
arm                   randconfig-002-20240214   gcc  
arm                   randconfig-003-20240213   gcc  
arm                   randconfig-004-20240213   clang
arm                        shmobile_defconfig   gcc  
arm                          sp7021_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240213   gcc  
arm64                 randconfig-002-20240213   gcc  
arm64                 randconfig-003-20240213   gcc  
arm64                 randconfig-003-20240214   gcc  
arm64                 randconfig-004-20240213   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240213   gcc  
csky                  randconfig-001-20240214   gcc  
csky                  randconfig-002-20240213   gcc  
csky                  randconfig-002-20240214   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20240213   clang
hexagon               randconfig-002-20240213   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240213   clang
i386         buildonly-randconfig-001-20240214   clang
i386         buildonly-randconfig-002-20240213   gcc  
i386         buildonly-randconfig-002-20240214   clang
i386         buildonly-randconfig-003-20240213   gcc  
i386         buildonly-randconfig-003-20240214   clang
i386         buildonly-randconfig-004-20240213   clang
i386         buildonly-randconfig-005-20240213   gcc  
i386         buildonly-randconfig-006-20240213   clang
i386         buildonly-randconfig-006-20240214   clang
i386                                defconfig   clang
i386                  randconfig-001-20240213   clang
i386                  randconfig-001-20240214   clang
i386                  randconfig-002-20240213   gcc  
i386                  randconfig-002-20240214   clang
i386                  randconfig-003-20240213   gcc  
i386                  randconfig-003-20240214   clang
i386                  randconfig-004-20240213   clang
i386                  randconfig-005-20240213   gcc  
i386                  randconfig-005-20240214   clang
i386                  randconfig-006-20240213   gcc  
i386                  randconfig-011-20240213   clang
i386                  randconfig-011-20240214   clang
i386                  randconfig-012-20240213   gcc  
i386                  randconfig-013-20240213   gcc  
i386                  randconfig-014-20240213   gcc  
i386                  randconfig-015-20240213   gcc  
i386                  randconfig-015-20240214   clang
i386                  randconfig-016-20240213   gcc  
i386                  randconfig-016-20240214   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240213   gcc  
loongarch             randconfig-001-20240214   gcc  
loongarch             randconfig-002-20240213   gcc  
loongarch             randconfig-002-20240214   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5208evb_defconfig   gcc  
m68k                        mvme147_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
microblaze                      mmu_defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                          ath79_defconfig   gcc  
mips                           ip22_defconfig   gcc  
mips                          rm200_defconfig   gcc  
nios2                         10m50_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240213   gcc  
nios2                 randconfig-001-20240214   gcc  
nios2                 randconfig-002-20240213   gcc  
nios2                 randconfig-002-20240214   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc                 simple_smp_defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240213   gcc  
parisc                randconfig-001-20240214   gcc  
parisc                randconfig-002-20240213   gcc  
parisc                randconfig-002-20240214   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                      arches_defconfig   gcc  
powerpc                        icon_defconfig   gcc  
powerpc                      ppc6xx_defconfig   gcc  
powerpc               randconfig-001-20240213   clang
powerpc               randconfig-002-20240213   gcc  
powerpc               randconfig-003-20240213   gcc  
powerpc                    sam440ep_defconfig   gcc  
powerpc                     tqm5200_defconfig   gcc  
powerpc                     tqm8560_defconfig   gcc  
powerpc64             randconfig-001-20240213   gcc  
powerpc64             randconfig-002-20240213   gcc  
powerpc64             randconfig-003-20240213   clang
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-001-20240213   gcc  
riscv                 randconfig-002-20240213   gcc  
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                          debug_defconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-001-20240213   gcc  
s390                  randconfig-002-20240213   clang
s390                  randconfig-002-20240214   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                     magicpanelr2_defconfig   gcc  
sh                          polaris_defconfig   gcc  
sh                    randconfig-001-20240213   gcc  
sh                    randconfig-001-20240214   gcc  
sh                    randconfig-002-20240213   gcc  
sh                    randconfig-002-20240214   gcc  
sh                          rsk7201_defconfig   gcc  
sh                      rts7751r2d1_defconfig   gcc  
sh                           se7619_defconfig   gcc  
sh                        sh7785lcr_defconfig   gcc  
sh                            shmin_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                       sparc64_defconfig   gcc  
sparc64                          alldefconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240213   gcc  
sparc64               randconfig-001-20240214   gcc  
sparc64               randconfig-002-20240213   gcc  
sparc64               randconfig-002-20240214   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                    randconfig-001-20240213   clang
um                    randconfig-002-20240213   gcc  
um                    randconfig-002-20240214   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240214   gcc  
x86_64       buildonly-randconfig-002-20240213   gcc  
x86_64       buildonly-randconfig-003-20240214   gcc  
x86_64       buildonly-randconfig-004-20240213   gcc  
x86_64       buildonly-randconfig-004-20240214   gcc  
x86_64       buildonly-randconfig-005-20240213   gcc  
x86_64       buildonly-randconfig-005-20240214   gcc  
x86_64       buildonly-randconfig-006-20240213   gcc  
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240213   gcc  
x86_64                randconfig-002-20240214   gcc  
x86_64                randconfig-004-20240213   gcc  
x86_64                randconfig-004-20240214   gcc  
x86_64                randconfig-013-20240214   gcc  
x86_64                randconfig-014-20240213   gcc  
x86_64                randconfig-014-20240214   gcc  
x86_64                randconfig-071-20240213   gcc  
x86_64                randconfig-071-20240214   gcc  
x86_64                randconfig-072-20240213   gcc  
x86_64                randconfig-073-20240214   gcc  
x86_64                randconfig-074-20240213   gcc  
x86_64                randconfig-075-20240213   gcc  
x86_64                randconfig-076-20240213   gcc  
x86_64                randconfig-076-20240214   gcc  
x86_64                          rhel-8.3-func   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                  nommu_kc705_defconfig   gcc  
xtensa                randconfig-001-20240213   gcc  
xtensa                randconfig-001-20240214   gcc  
xtensa                randconfig-002-20240213   gcc  
xtensa                randconfig-002-20240214   gcc  
xtensa                    smp_lx200_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
