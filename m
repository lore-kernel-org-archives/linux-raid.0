Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8542712C470
	for <linux-raid@vger.kernel.org>; Fri, 16 Aug 2024 07:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723793933; cv=none; b=WjeXEn1fmGURUULcUivnskM3keb3U/Uf0PP7Yd78ASbkvfMRrQu5CiTdFyQ6U0NL0DEgr0UrhykNk2QRILvJPp0w7N7/m97QdewFguOtxvVN8hjzeqRdr5p6oEETLk2mpsAEEaORm8IP+hvkUaD8IYwAfZybfYyOOYIboX4tiCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723793933; c=relaxed/simple;
	bh=RsIv48E7MDr9qeMUKv0yYPJa9rkoYfqXNYyPMdsB5TU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=MNxck+z+SBHaz8t0ooXv9i3vyNGZ+6BG9UTYxOguZTPWF385IKdoALSgYmgyNK1SQdu8iGoYwccO2jqP1RPTkIrTVKPcnvN928Ae+GM8ZfJqMWnnae1Cld+bntAvhR60PZj6thiuoflsr56vmD418Pfp/Xe1JROHTFEaa9sTW0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oKGrt0th; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oKGrt0th"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723793932; x=1755329932;
  h=date:from:to:cc:subject:message-id;
  bh=RsIv48E7MDr9qeMUKv0yYPJa9rkoYfqXNYyPMdsB5TU=;
  b=oKGrt0thykipXbkUPgHEXuxiBQF8ff2/7b+wPF22b0t9hN4QnwJxqocN
   EijVuOjQRBP4Ztop9nG1H1R98aM2o1S3c2iP6yLXsV4+6ATg06vIkMsdY
   cDD8PYIvrGQIMPtGZsTiwGM3HuL0sI9hxize4uqJhQW3pqZ/ufxnZsCCO
   3HAzo6WVMn/fMD3JZvCyvAKqcRI6CptoCoNYQ5PLe3qgBPbiye+WnMLai
   TbkmN6Jgkxsrc54zNgliriiT/2COJXwXWL2Uqebj5igRROwDvk7nr16Yj
   Vsxv9PqbAs7WgFDSn93Ihc1kyaq9rqEbMOUbUlzuBHBPW+yxhs9i8UBMB
   g==;
X-CSE-ConnectionGUID: ozmFAmz5RKuLA+0jISEV9A==
X-CSE-MsgGUID: ay5qEApSSvC3JGGfZW2ivg==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="32755548"
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="32755548"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 00:38:51 -0700
X-CSE-ConnectionGUID: wartK/zuQJOEMFj8u1ai7w==
X-CSE-MsgGUID: nbbKZav0RV+Q22z8TsNzAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="64273450"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 16 Aug 2024 00:38:49 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1serXr-00067K-2Z;
	Fri, 16 Aug 2024 07:38:47 +0000
Date: Fri, 16 Aug 2024 15:38:08 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.12] BUILD SUCCESS
 ca958879ade564daa0e0fa82aeeccf3bc7f73edd
Message-ID: <202408161506.czfgNGuZ-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.12
branch HEAD: ca958879ade564daa0e0fa82aeeccf3bc7f73edd  md: convert comma to semicolon

elapsed time: 1447m

configs tested: 266
configs skipped: 8

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc-13.2.0
alpha                             allnoconfig   gcc-13.3.0
alpha                            allyesconfig   gcc-13.3.0
alpha                               defconfig   gcc-13.2.0
arc                              allmodconfig   gcc-13.2.0
arc                               allnoconfig   gcc-13.2.0
arc                              allyesconfig   gcc-13.2.0
arc                                 defconfig   gcc-13.2.0
arc                 nsimosci_hs_smp_defconfig   gcc-13.2.0
arc                   randconfig-001-20240816   gcc-13.2.0
arc                   randconfig-002-20240816   gcc-13.2.0
arm                              allmodconfig   gcc-13.2.0
arm                              allmodconfig   gcc-14.1.0
arm                               allnoconfig   clang-20
arm                               allnoconfig   gcc-13.2.0
arm                              allyesconfig   gcc-13.2.0
arm                              allyesconfig   gcc-14.1.0
arm                         bcm2835_defconfig   clang-20
arm                        clps711x_defconfig   gcc-13.2.0
arm                                 defconfig   gcc-13.2.0
arm                         lpc32xx_defconfig   gcc-13.2.0
arm                          pxa910_defconfig   gcc-13.2.0
arm                   randconfig-001-20240816   clang-20
arm                   randconfig-001-20240816   gcc-13.2.0
arm                   randconfig-002-20240816   clang-20
arm                   randconfig-002-20240816   gcc-13.2.0
arm                   randconfig-003-20240816   clang-20
arm                   randconfig-003-20240816   gcc-13.2.0
arm                   randconfig-004-20240816   clang-20
arm                   randconfig-004-20240816   gcc-13.2.0
arm                        realview_defconfig   clang-20
arm                          sp7021_defconfig   clang-20
arm                        vexpress_defconfig   gcc-13.2.0
arm64                            allmodconfig   clang-20
arm64                            allmodconfig   gcc-13.2.0
arm64                             allnoconfig   gcc-13.2.0
arm64                             allnoconfig   gcc-14.1.0
arm64                               defconfig   clang-20
arm64                               defconfig   gcc-13.2.0
arm64                 randconfig-001-20240816   clang-20
arm64                 randconfig-001-20240816   gcc-13.2.0
arm64                 randconfig-002-20240816   clang-20
arm64                 randconfig-002-20240816   gcc-13.2.0
arm64                 randconfig-003-20240816   clang-20
arm64                 randconfig-003-20240816   gcc-13.2.0
arm64                 randconfig-004-20240816   clang-20
arm64                 randconfig-004-20240816   gcc-13.2.0
csky                              allnoconfig   gcc-13.2.0
csky                              allnoconfig   gcc-14.1.0
csky                                defconfig   gcc-13.2.0
csky                  randconfig-001-20240816   gcc-13.2.0
csky                  randconfig-001-20240816   gcc-14.1.0
csky                  randconfig-002-20240816   gcc-13.2.0
csky                  randconfig-002-20240816   gcc-14.1.0
hexagon                          allmodconfig   clang-20
hexagon                           allnoconfig   clang-20
hexagon                          allyesconfig   clang-20
hexagon               randconfig-001-20240816   clang-20
hexagon               randconfig-002-20240816   clang-20
i386                             allmodconfig   clang-18
i386                             allmodconfig   gcc-12
i386                              allnoconfig   clang-18
i386                              allnoconfig   gcc-12
i386                             allyesconfig   clang-18
i386                             allyesconfig   gcc-12
i386         buildonly-randconfig-001-20240815   gcc-12
i386         buildonly-randconfig-001-20240816   gcc-12
i386         buildonly-randconfig-002-20240815   clang-18
i386         buildonly-randconfig-002-20240816   gcc-12
i386         buildonly-randconfig-003-20240815   clang-18
i386         buildonly-randconfig-003-20240816   gcc-12
i386         buildonly-randconfig-004-20240815   clang-18
i386         buildonly-randconfig-004-20240816   gcc-12
i386         buildonly-randconfig-005-20240815   clang-18
i386         buildonly-randconfig-005-20240816   gcc-12
i386         buildonly-randconfig-006-20240815   clang-18
i386         buildonly-randconfig-006-20240816   gcc-12
i386                                defconfig   clang-18
i386                  randconfig-001-20240815   gcc-12
i386                  randconfig-001-20240816   gcc-12
i386                  randconfig-002-20240815   clang-18
i386                  randconfig-002-20240816   gcc-12
i386                  randconfig-003-20240815   clang-18
i386                  randconfig-003-20240816   gcc-12
i386                  randconfig-004-20240815   gcc-12
i386                  randconfig-004-20240816   gcc-12
i386                  randconfig-005-20240815   gcc-12
i386                  randconfig-005-20240816   gcc-12
i386                  randconfig-006-20240815   gcc-12
i386                  randconfig-006-20240816   gcc-12
i386                  randconfig-011-20240815   clang-18
i386                  randconfig-011-20240816   gcc-12
i386                  randconfig-012-20240815   clang-18
i386                  randconfig-012-20240816   gcc-12
i386                  randconfig-013-20240815   gcc-12
i386                  randconfig-013-20240816   gcc-12
i386                  randconfig-014-20240815   clang-18
i386                  randconfig-014-20240816   gcc-12
i386                  randconfig-015-20240815   clang-18
i386                  randconfig-015-20240816   gcc-12
i386                  randconfig-016-20240815   gcc-12
i386                  randconfig-016-20240816   gcc-12
loongarch                        allmodconfig   gcc-14.1.0
loongarch                         allnoconfig   gcc-13.2.0
loongarch                         allnoconfig   gcc-14.1.0
loongarch                           defconfig   gcc-13.2.0
loongarch             randconfig-001-20240816   gcc-13.2.0
loongarch             randconfig-001-20240816   gcc-14.1.0
loongarch             randconfig-002-20240816   gcc-13.2.0
loongarch             randconfig-002-20240816   gcc-14.1.0
m68k                             allmodconfig   gcc-14.1.0
m68k                              allnoconfig   gcc-13.2.0
m68k                              allnoconfig   gcc-14.1.0
m68k                             allyesconfig   gcc-14.1.0
m68k                          atari_defconfig   gcc-13.2.0
m68k                                defconfig   gcc-13.2.0
microblaze                       allmodconfig   gcc-14.1.0
microblaze                        allnoconfig   gcc-13.2.0
microblaze                        allnoconfig   gcc-14.1.0
microblaze                       allyesconfig   gcc-14.1.0
microblaze                          defconfig   gcc-13.2.0
mips                              allnoconfig   gcc-13.2.0
mips                              allnoconfig   gcc-14.1.0
mips                        bcm63xx_defconfig   clang-20
mips                           ci20_defconfig   gcc-13.2.0
mips                         cobalt_defconfig   clang-20
mips                           ip32_defconfig   clang-20
nios2                            alldefconfig   gcc-13.2.0
nios2                             allnoconfig   gcc-13.2.0
nios2                             allnoconfig   gcc-14.1.0
nios2                               defconfig   gcc-13.2.0
nios2                 randconfig-001-20240816   gcc-13.2.0
nios2                 randconfig-001-20240816   gcc-14.1.0
nios2                 randconfig-002-20240816   gcc-13.2.0
nios2                 randconfig-002-20240816   gcc-14.1.0
openrisc                          allnoconfig   gcc-14.1.0
openrisc                         allyesconfig   gcc-14.1.0
openrisc                            defconfig   gcc-14.1.0
openrisc                    or1ksim_defconfig   gcc-13.2.0
parisc                           allmodconfig   gcc-14.1.0
parisc                            allnoconfig   gcc-14.1.0
parisc                           allyesconfig   gcc-14.1.0
parisc                              defconfig   gcc-14.1.0
parisc                randconfig-001-20240816   gcc-13.2.0
parisc                randconfig-001-20240816   gcc-14.1.0
parisc                randconfig-002-20240816   gcc-13.2.0
parisc                randconfig-002-20240816   gcc-14.1.0
parisc64                            defconfig   gcc-13.2.0
powerpc                          allmodconfig   gcc-14.1.0
powerpc                           allnoconfig   gcc-14.1.0
powerpc                          allyesconfig   clang-20
powerpc                          allyesconfig   gcc-14.1.0
powerpc                      arches_defconfig   clang-20
powerpc                   currituck_defconfig   clang-20
powerpc                          g5_defconfig   clang-20
powerpc                    gamecube_defconfig   clang-20
powerpc                  mpc866_ads_defconfig   clang-20
powerpc               randconfig-002-20240816   clang-20
powerpc               randconfig-002-20240816   gcc-13.2.0
powerpc64             randconfig-001-20240816   gcc-13.2.0
powerpc64             randconfig-001-20240816   gcc-14.1.0
powerpc64             randconfig-002-20240816   clang-20
powerpc64             randconfig-002-20240816   gcc-13.2.0
powerpc64             randconfig-003-20240816   gcc-13.2.0
powerpc64             randconfig-003-20240816   gcc-14.1.0
riscv                            allmodconfig   clang-20
riscv                            allmodconfig   gcc-14.1.0
riscv                             allnoconfig   gcc-14.1.0
riscv                            allyesconfig   clang-20
riscv                            allyesconfig   gcc-14.1.0
riscv                               defconfig   gcc-13.2.0
riscv                               defconfig   gcc-14.1.0
riscv                 randconfig-001-20240816   clang-20
riscv                 randconfig-001-20240816   gcc-13.2.0
riscv                 randconfig-002-20240816   clang-20
riscv                 randconfig-002-20240816   gcc-13.2.0
s390                             allmodconfig   clang-20
s390                              allnoconfig   clang-20
s390                              allnoconfig   gcc-14.1.0
s390                             allyesconfig   clang-20
s390                             allyesconfig   gcc-14.1.0
s390                                defconfig   gcc-14.1.0
s390                  randconfig-001-20240816   gcc-13.2.0
s390                  randconfig-001-20240816   gcc-14.1.0
s390                  randconfig-002-20240816   clang-20
s390                  randconfig-002-20240816   gcc-13.2.0
sh                               allmodconfig   gcc-14.1.0
sh                                allnoconfig   gcc-13.2.0
sh                                allnoconfig   gcc-14.1.0
sh                               allyesconfig   gcc-14.1.0
sh                                  defconfig   gcc-14.1.0
sh                         ecovec24_defconfig   gcc-13.2.0
sh                    randconfig-001-20240816   gcc-13.2.0
sh                    randconfig-001-20240816   gcc-14.1.0
sh                    randconfig-002-20240816   gcc-13.2.0
sh                    randconfig-002-20240816   gcc-14.1.0
sh                           se7343_defconfig   gcc-13.2.0
sparc                            allmodconfig   gcc-14.1.0
sparc                       sparc32_defconfig   gcc-13.2.0
sparc64                             defconfig   gcc-14.1.0
sparc64               randconfig-001-20240816   gcc-13.2.0
sparc64               randconfig-001-20240816   gcc-14.1.0
sparc64               randconfig-002-20240816   gcc-13.2.0
sparc64               randconfig-002-20240816   gcc-14.1.0
um                               allmodconfig   clang-20
um                               allmodconfig   gcc-13.3.0
um                                allnoconfig   clang-17
um                                allnoconfig   gcc-14.1.0
um                               allyesconfig   gcc-12
um                               allyesconfig   gcc-13.3.0
um                                  defconfig   gcc-14.1.0
um                             i386_defconfig   gcc-14.1.0
um                    randconfig-001-20240816   clang-20
um                    randconfig-001-20240816   gcc-13.2.0
um                    randconfig-002-20240816   gcc-12
um                    randconfig-002-20240816   gcc-13.2.0
um                           x86_64_defconfig   clang-20
um                           x86_64_defconfig   gcc-14.1.0
x86_64                            allnoconfig   clang-18
x86_64                           allyesconfig   clang-18
x86_64       buildonly-randconfig-001-20240816   clang-18
x86_64       buildonly-randconfig-002-20240816   clang-18
x86_64       buildonly-randconfig-002-20240816   gcc-12
x86_64       buildonly-randconfig-003-20240816   clang-18
x86_64       buildonly-randconfig-003-20240816   gcc-12
x86_64       buildonly-randconfig-004-20240816   clang-18
x86_64       buildonly-randconfig-005-20240816   clang-18
x86_64       buildonly-randconfig-006-20240816   clang-18
x86_64       buildonly-randconfig-006-20240816   gcc-12
x86_64                              defconfig   clang-18
x86_64                              defconfig   gcc-11
x86_64                                  kexec   clang-18
x86_64                randconfig-001-20240816   clang-18
x86_64                randconfig-001-20240816   gcc-12
x86_64                randconfig-002-20240816   clang-18
x86_64                randconfig-003-20240816   clang-18
x86_64                randconfig-004-20240816   clang-18
x86_64                randconfig-005-20240816   clang-18
x86_64                randconfig-006-20240816   clang-18
x86_64                randconfig-006-20240816   gcc-12
x86_64                randconfig-011-20240816   clang-18
x86_64                randconfig-012-20240816   clang-18
x86_64                randconfig-012-20240816   gcc-12
x86_64                randconfig-013-20240816   clang-18
x86_64                randconfig-013-20240816   gcc-12
x86_64                randconfig-014-20240816   clang-18
x86_64                randconfig-015-20240816   clang-18
x86_64                randconfig-016-20240816   clang-18
x86_64                randconfig-071-20240816   clang-18
x86_64                randconfig-072-20240816   clang-18
x86_64                randconfig-072-20240816   gcc-11
x86_64                randconfig-073-20240816   clang-18
x86_64                randconfig-073-20240816   gcc-12
x86_64                randconfig-074-20240816   clang-18
x86_64                randconfig-075-20240816   clang-18
x86_64                randconfig-076-20240816   clang-18
x86_64                randconfig-076-20240816   gcc-12
x86_64                          rhel-8.3-rust   clang-18
x86_64                               rhel-8.3   clang-18
xtensa                            allnoconfig   gcc-13.2.0
xtensa                            allnoconfig   gcc-14.1.0
xtensa                randconfig-001-20240816   gcc-13.2.0
xtensa                randconfig-001-20240816   gcc-14.1.0
xtensa                randconfig-002-20240816   gcc-13.2.0
xtensa                randconfig-002-20240816   gcc-14.1.0
xtensa                    xip_kc705_defconfig   gcc-13.2.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
