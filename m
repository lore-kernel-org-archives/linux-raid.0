Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223B9156CF
	for <linux-raid@vger.kernel.org>; Fri, 14 Jun 2024 14:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376727; cv=none; b=BEy6oXT6d/AspSVr1pW3UlcOOkKmYniGV8talqfrAUd/zvf4iq3xQ8/K/aKY3Yx6Q1AFGYIEsNGfJKwImYffZAYpN2FHp+2MMJQs+cHTLqRV8HVhMZuurg9bDiAIq1o3aP6av2mELhMhHvM/ytgqIZU7sjBgGByX8nORFXvz7Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376727; c=relaxed/simple;
	bh=6vRqsX7NZWmVNunTvVo2soj9asnSAouZttP2TZOc4/A=;
	h=Date:From:To:Cc:Subject:Message-ID; b=AqCKQ1ssNfgb58hBcWHZIptm9L5jizQ0m0wQjTTgWVmyl4yIQ/8JbSn/mV3GakbssLyvzD70PWIzwPKTRABgrgBVen8rAfXV5B1uzzbn9r+2IIIBjjvxycENQTAKueoPKvoIVUvSKENU5qv4W0z0SBelhe7OQo8khW1ePO5BvfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dnZSEHzr; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnZSEHzr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718376726; x=1749912726;
  h=date:from:to:cc:subject:message-id;
  bh=6vRqsX7NZWmVNunTvVo2soj9asnSAouZttP2TZOc4/A=;
  b=dnZSEHzrkOoaoBLLfgppHfenp1t3IDwHObe35wGIvc7DTvSpoIo+4gy4
   KQxJHB5AKR7i86nLFuBJVRPE0Ocp3nLsTO16hQwINA7egkYCgaTtDUsxf
   cho9ClQlOOqrrfmKrbGyS9h5YBywU/bLGtsQKZcwiRdAQCUpjTZ0wyLZ9
   r4Hp011rlOuSyLASf74oXSMqxTkakw3nlygGHmyDeEybSO2UtgalJ2mhZ
   6AoCAvp+W18M8l6I8xkAOUwU2MCgn5+nnazCSBAuuTmuSG9k7vaMkPIn3
   Nygk0tgN0j1nUI9H05FqHdWOlWHuUtRE4uom1h0lTb79hFnfZsJyjP+fQ
   g==;
X-CSE-ConnectionGUID: TFXBqd/RTS+5jV9DMHC42g==
X-CSE-MsgGUID: fFldN5eVRcWkSSSvKIccaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11103"; a="15098664"
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="15098664"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 07:52:06 -0700
X-CSE-ConnectionGUID: PArDltCqRcyeBRIZnePZqQ==
X-CSE-MsgGUID: 3zowz58CSkW0TjSOLe4w1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="71293434"
Received: from lkp-server01.sh.intel.com (HELO 9e3ee4e9e062) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 14 Jun 2024 07:52:05 -0700
Received: from kbuild by 9e3ee4e9e062 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sI8Ha-0001Pl-1q;
	Fri, 14 Jun 2024 14:52:02 +0000
Date: Fri, 14 Jun 2024 22:51:19 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.11] BUILD SUCCESS
 305a5170dc5cf3d395bb4c4e9239bca6d0b54b49
Message-ID: <202406142217.TWrQNaIu-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.11
branch HEAD: 305a5170dc5cf3d395bb4c4e9239bca6d0b54b49  md/raid5: avoid BUG_ON() while continue reshape after reassembling

elapsed time: 2736m

configs tested: 76
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc-13.2.0
alpha                            allyesconfig   gcc-13.2.0
alpha                               defconfig   gcc-13.2.0
arc                               allnoconfig   gcc-13.2.0
arc                                 defconfig   gcc-13.2.0
arm                               allnoconfig   clang-19
arm                                 defconfig   clang-14
arm64                             allnoconfig   gcc-13.2.0
arm64                               defconfig   gcc-13.2.0
csky                              allnoconfig   gcc-13.2.0
csky                                defconfig   gcc-13.2.0
hexagon                          allmodconfig   clang-19
hexagon                           allnoconfig   clang-19
hexagon                          allyesconfig   clang-19
hexagon                             defconfig   clang-19
i386                             allmodconfig   gcc-13
i386                              allnoconfig   gcc-13
i386                             allyesconfig   gcc-13
i386                                defconfig   clang-18
loongarch                        allmodconfig   gcc-13.2.0
loongarch                         allnoconfig   gcc-13.2.0
loongarch                           defconfig   gcc-13.2.0
m68k                             allmodconfig   gcc-13.2.0
m68k                              allnoconfig   gcc-13.2.0
m68k                             allyesconfig   gcc-13.2.0
m68k                                defconfig   gcc-13.2.0
microblaze                       allmodconfig   gcc-13.2.0
microblaze                        allnoconfig   gcc-13.2.0
microblaze                       allyesconfig   gcc-13.2.0
microblaze                          defconfig   gcc-13.2.0
mips                              allnoconfig   gcc-13.2.0
mips                             allyesconfig   gcc-13.2.0
nios2                            allmodconfig   gcc-13.2.0
nios2                             allnoconfig   gcc-13.2.0
nios2                            allyesconfig   gcc-13.2.0
nios2                               defconfig   gcc-13.2.0
openrisc                          allnoconfig   gcc-13.2.0
openrisc                         allyesconfig   gcc-13.2.0
openrisc                            defconfig   gcc-13.2.0
parisc                           allmodconfig   gcc-13.2.0
parisc                            allnoconfig   gcc-13.2.0
parisc                           allyesconfig   gcc-13.2.0
parisc                              defconfig   gcc-13.2.0
parisc64                            defconfig   gcc-13.2.0
powerpc                          allmodconfig   gcc-13.2.0
powerpc                           allnoconfig   gcc-13.2.0
powerpc                          allyesconfig   clang-19
riscv                            allmodconfig   clang-19
riscv                             allnoconfig   gcc-13.2.0
riscv                            allyesconfig   clang-19
riscv                               defconfig   clang-19
s390                             allmodconfig   clang-19
s390                              allnoconfig   clang-19
s390                             allyesconfig   gcc-13.2.0
s390                                defconfig   clang-19
sh                               allmodconfig   gcc-13.2.0
sh                                allnoconfig   gcc-13.2.0
sh                               allyesconfig   gcc-13.2.0
sh                                  defconfig   gcc-13.2.0
sparc                            allmodconfig   gcc-13.2.0
sparc                             allnoconfig   gcc-13.2.0
sparc                               defconfig   gcc-13.2.0
sparc64                          allmodconfig   gcc-13.2.0
sparc64                          allyesconfig   gcc-13.2.0
sparc64                             defconfig   gcc-13.2.0
um                               allmodconfig   clang-19
um                                allnoconfig   clang-17
um                               allyesconfig   gcc-13
um                                  defconfig   clang-19
um                             i386_defconfig   gcc-13
um                           x86_64_defconfig   clang-15
x86_64                            allnoconfig   clang-18
x86_64                           allyesconfig   clang-18
x86_64                              defconfig   gcc-13
x86_64                          rhel-8.3-rust   clang-18
xtensa                            allnoconfig   gcc-13.2.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
