Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487A81632DB
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731514016; cv=none; b=tPvz+w2zdCu4fizXti6dmhIce5Kl+f/tN4A77j2+fbEAEfOI7qYQDJSkgAunyW6RNmHojMFsGsj1XU56wZLqG8Q25GmnogNzm9zr+SmjGwumNd1H++OtJmLbOzbzBATAq0YKOPCfU4y6GukjAMF01oFTv+xrMY0Hvnu6YMjG868=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731514016; c=relaxed/simple;
	bh=906W3ctFins7GUXpr5zVLcTX9rJa6nUVqJiC8uaNJm0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=igw3S5Vo9j9GzNvxfxZR69/rqWxZtRlOpQssy5r9P0BYHICB5BA+L3Up8/loOxGT8ZBoiYbcRaxo+95P89GMe7UmtU/2uqjuO4Q57vtcpUmVjihKNT/OTdoN81DVO7qT5pNtJShyGn4i30D0/aj92qrDKQhh7EnL5AR7+p+mzb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UAxCY6Uh; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UAxCY6Uh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731514014; x=1763050014;
  h=date:from:to:cc:subject:message-id;
  bh=906W3ctFins7GUXpr5zVLcTX9rJa6nUVqJiC8uaNJm0=;
  b=UAxCY6UhX0r50yKZROFAQ4qpbAjd4x01JpYj60lrb1EPKwAnXdZ/cYwf
   hWqs9LUt+ondb4EZLgkH/XDUSjrO1Y2Nj8xptY8/Ys+FESfh3qJXoHePC
   ZhB86Oh36qOf4GTvpBiyAW3sN0zyKvcGAp3BKFDjn04s4Fu14PH87fnUE
   MNVu3e7KWiKeamCcfO1NSbZWx/vclryhuCWBd2tDTpojKsaBFx/6gXojp
   ystDmTEPQx0RYb56ScEYb16XRr4uhOfJb7FrGraa42+fnJ34fgjyU5+Do
   gGpxeUYgDeRpFjIYhk/Vh7kx5a9vR2lMYyYU4Otk34J2x61Xe2mUvpQhr
   w==;
X-CSE-ConnectionGUID: H/1mDbI2TdmkuT9nLpYqRQ==
X-CSE-MsgGUID: d3SL1GOUSlSdm8Wt62jZjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42803446"
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="42803446"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 08:06:53 -0800
X-CSE-ConnectionGUID: EhOL508bSvCE1et6aHVjzQ==
X-CSE-MsgGUID: IPBSl8/3QJ2nf87gZ97mPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="87805367"
Received: from lkp-server01.sh.intel.com (HELO 80bd855f15b3) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 13 Nov 2024 08:06:52 -0800
Received: from kbuild by 80bd855f15b3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tBFtK-0000Wn-02;
	Wed, 13 Nov 2024 16:06:50 +0000
Date: Thu, 14 Nov 2024 00:06:42 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.13] BUILD SUCCESS
 ea90d270349d51086d0dddc55821a782040d68f5
Message-ID: <202411140037.yiAQ08QB-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.13
branch HEAD: ea90d270349d51086d0dddc55821a782040d68f5  md/raid5: Increase r5conf.cache_name size

elapsed time: 945m

configs tested: 165
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-14.2.0
alpha                            allyesconfig    clang-20
alpha                            allyesconfig    gcc-14.2.0
alpha                               defconfig    gcc-14.2.0
arc                              allmodconfig    clang-20
arc                              allmodconfig    gcc-13.2.0
arc                               allnoconfig    gcc-14.2.0
arc                              allyesconfig    clang-20
arc                              allyesconfig    gcc-13.2.0
arc                          axs103_defconfig    clang-20
arc                                 defconfig    gcc-14.2.0
arc                   randconfig-001-20241113    gcc-13.2.0
arc                   randconfig-002-20241113    gcc-13.2.0
arm                              allmodconfig    clang-20
arm                              allmodconfig    gcc-14.2.0
arm                               allnoconfig    gcc-14.2.0
arm                              allyesconfig    clang-20
arm                              allyesconfig    gcc-14.2.0
arm                         at91_dt_defconfig    clang-20
arm                                 defconfig    gcc-14.2.0
arm                   randconfig-001-20241113    clang-20
arm                   randconfig-002-20241113    clang-20
arm                   randconfig-003-20241113    clang-20
arm                   randconfig-004-20241113    clang-20
arm                        spear3xx_defconfig    clang-20
arm64                            allmodconfig    clang-20
arm64                             allnoconfig    gcc-14.2.0
arm64                               defconfig    gcc-14.2.0
arm64                 randconfig-001-20241113    clang-20
arm64                 randconfig-002-20241113    gcc-14.2.0
arm64                 randconfig-003-20241113    gcc-14.2.0
arm64                 randconfig-004-20241113    gcc-14.2.0
csky                             alldefconfig    clang-20
csky                              allnoconfig    gcc-14.2.0
csky                                defconfig    clang-20
csky                                defconfig    gcc-14.2.0
csky                  randconfig-001-20241113    gcc-14.2.0
csky                  randconfig-002-20241113    gcc-14.2.0
hexagon                          allmodconfig    clang-20
hexagon                           allnoconfig    gcc-14.2.0
hexagon                          allyesconfig    clang-20
hexagon                             defconfig    gcc-14.2.0
hexagon               randconfig-002-20241113    clang-20
i386                             allmodconfig    clang-19
i386                             allmodconfig    gcc-12
i386                              allnoconfig    clang-19
i386                              allnoconfig    gcc-12
i386                             allyesconfig    clang-19
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20241113    clang-19
i386        buildonly-randconfig-002-20241113    clang-19
i386        buildonly-randconfig-003-20241113    clang-19
i386        buildonly-randconfig-004-20241113    clang-19
i386        buildonly-randconfig-004-20241113    gcc-12
i386        buildonly-randconfig-005-20241113    clang-19
i386        buildonly-randconfig-005-20241113    gcc-12
i386        buildonly-randconfig-006-20241113    clang-19
i386        buildonly-randconfig-006-20241113    gcc-12
i386                                defconfig    clang-19
i386                  randconfig-001-20241113    clang-19
i386                  randconfig-001-20241113    gcc-12
i386                  randconfig-002-20241113    clang-19
i386                  randconfig-002-20241113    gcc-12
i386                  randconfig-003-20241113    clang-19
i386                  randconfig-004-20241113    clang-19
i386                  randconfig-005-20241113    clang-19
i386                  randconfig-005-20241113    gcc-12
i386                  randconfig-006-20241113    clang-19
i386                  randconfig-006-20241113    gcc-12
i386                  randconfig-011-20241113    clang-19
i386                  randconfig-012-20241113    clang-19
i386                  randconfig-012-20241113    gcc-12
i386                  randconfig-013-20241113    clang-19
i386                  randconfig-014-20241113    clang-19
i386                  randconfig-015-20241113    clang-19
i386                  randconfig-015-20241113    gcc-11
i386                  randconfig-016-20241113    clang-19
i386                  randconfig-016-20241113    gcc-12
loongarch                        allmodconfig    gcc-14.2.0
loongarch                         allnoconfig    gcc-14.2.0
loongarch                           defconfig    gcc-14.2.0
loongarch             randconfig-001-20241113    gcc-14.2.0
loongarch             randconfig-002-20241113    gcc-14.2.0
m68k                             allmodconfig    gcc-14.2.0
m68k                              allnoconfig    gcc-14.2.0
m68k                             allyesconfig    gcc-14.2.0
m68k                          atari_defconfig    clang-20
m68k                                defconfig    gcc-14.2.0
microblaze                       allmodconfig    gcc-14.2.0
microblaze                        allnoconfig    gcc-14.2.0
microblaze                       allyesconfig    gcc-14.2.0
microblaze                          defconfig    gcc-14.2.0
mips                              allnoconfig    gcc-14.2.0
mips                           jazz_defconfig    clang-20
mips                         rt305x_defconfig    clang-20
mips                   sb1250_swarm_defconfig    clang-20
nios2                             allnoconfig    gcc-14.2.0
nios2                               defconfig    gcc-14.2.0
nios2                 randconfig-001-20241113    gcc-14.2.0
nios2                 randconfig-002-20241113    gcc-14.2.0
openrisc                          allnoconfig    clang-20
openrisc                          allnoconfig    gcc-14.2.0
openrisc                         allyesconfig    gcc-14.2.0
openrisc                            defconfig    gcc-12
parisc                           allmodconfig    gcc-14.2.0
parisc                            allnoconfig    clang-20
parisc                            allnoconfig    gcc-14.2.0
parisc                           allyesconfig    gcc-14.2.0
parisc                              defconfig    gcc-12
parisc                randconfig-001-20241113    gcc-14.2.0
parisc                randconfig-002-20241113    gcc-14.2.0
parisc64                            defconfig    gcc-14.2.0
powerpc                          allmodconfig    gcc-14.2.0
powerpc                           allnoconfig    clang-20
powerpc                           allnoconfig    gcc-14.2.0
powerpc                          allyesconfig    clang-20
powerpc                          allyesconfig    gcc-14.2.0
powerpc                     asp8347_defconfig    clang-20
powerpc               randconfig-001-20241113    clang-20
powerpc               randconfig-002-20241113    clang-20
powerpc               randconfig-003-20241113    clang-15
powerpc                     redwood_defconfig    clang-20
powerpc64             randconfig-001-20241113    gcc-14.2.0
powerpc64             randconfig-002-20241113    clang-20
powerpc64             randconfig-003-20241113    gcc-14.2.0
riscv                            allmodconfig    clang-20
riscv                            allmodconfig    gcc-14.2.0
riscv                             allnoconfig    clang-20
riscv                             allnoconfig    gcc-14.2.0
riscv                            allyesconfig    clang-20
riscv                            allyesconfig    gcc-14.2.0
riscv                               defconfig    gcc-12
riscv             nommu_k210_sdcard_defconfig    clang-20
riscv                 randconfig-001-20241113    gcc-14.2.0
riscv                 randconfig-002-20241113    clang-20
s390                             allmodconfig    clang-20
s390                             allmodconfig    gcc-14.2.0
s390                              allnoconfig    clang-20
s390                             allyesconfig    gcc-14.2.0
s390                                defconfig    gcc-12
s390                  randconfig-001-20241113    gcc-14.2.0
sh                               allmodconfig    gcc-14.2.0
sh                                allnoconfig    gcc-14.2.0
sh                               allyesconfig    gcc-14.2.0
sh                                  defconfig    gcc-12
sh                        dreamcast_defconfig    clang-20
sparc                            allmodconfig    gcc-14.2.0
sparc64                             defconfig    gcc-12
um                               allmodconfig    clang-20
um                                allnoconfig    clang-17
um                                allnoconfig    clang-20
um                               allyesconfig    clang-20
um                               allyesconfig    gcc-12
um                                  defconfig    gcc-12
um                             i386_defconfig    gcc-12
um                           x86_64_defconfig    clang-20
um                           x86_64_defconfig    gcc-12
x86_64                            allnoconfig    clang-19
x86_64                           allyesconfig    clang-19
x86_64                              defconfig    clang-19
x86_64                              defconfig    gcc-11
x86_64                                  kexec    clang-19
x86_64                                  kexec    gcc-12
x86_64                               rhel-8.3    gcc-12
xtensa                            allnoconfig    gcc-14.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
