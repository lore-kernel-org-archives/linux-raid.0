Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559E81BF336
	for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 20:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725049358; cv=none; b=mwOtMwXTy0QFOdD7eZesjInIeTH1HpQKtn+I84WLnwVX9xPq11zYiRY3RM5IoFVzaj0p318E+dVbrobmKtjoa7r03t3WKZOy/zLdewos2aMxBJP8RA3oxlCoUaH4UpCum+LZRO7M2Oz3MboVMoz6d7HfA7dpqvYmP9ZQLeYRmP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725049358; c=relaxed/simple;
	bh=i1ypRvdVgF9TCMV8WdAlSX2oHcP+6J2zKunlq7WzuC0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=nfhzanZqWTk4LEJjSAzTi4kz9GKK3NoMYnhK/ItBpJ+N9VmizVY6zR/O3kBkivJmfQuXwk1fjMZI/1QANZCbZViblJiOZfsxkVHyK93p5BMM8O5Uvsuj42NdGMMxSTNy39XgvB7l/VxWP6euvdf/h1y8JsDBp4Qqq5UUMZEWg0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5YnMJiK; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5YnMJiK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725049357; x=1756585357;
  h=date:from:to:cc:subject:message-id;
  bh=i1ypRvdVgF9TCMV8WdAlSX2oHcP+6J2zKunlq7WzuC0=;
  b=f5YnMJiKDVyu7dJ/4AJTFHjpO+kmWtJVipK2ciPUFlJCbROIlhsZI60m
   XNGdnIzhBzfxuwDfiOum9KxL/x7IsekAJP+CpKXFMR+veXMjJc85wyLzc
   ypLOXqD5PIbG55mmQiY9Xvyd5OLfHXguZW8+a/3UEsOm8k+0ARdl+rBzz
   nWjIYkGDTeMvv9zh5ZNmMqhmhB8eL+tZ/CAjFNbQakPz9gRIAhFed8ghc
   4zBarJikpz9gNedUr2d+48AermodqWf7Y9hm73Wr6JM9mCe5vin2mRH2R
   gNFVaEJgY7cml71z4iCUNtrzojzk9zHjl4kn+OpGttHlHaaQ7w9ChunIt
   A==;
X-CSE-ConnectionGUID: P+e+UbpqSzmxfST+P69JOw==
X-CSE-MsgGUID: ufMx1VyRSu2RlhtzzKcIrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11180"; a="23662320"
X-IronPort-AV: E=Sophos;i="6.10,189,1719903600"; 
   d="scan'208";a="23662320"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 13:22:36 -0700
X-CSE-ConnectionGUID: eBL5eRXMQo6swPyn4lS79Q==
X-CSE-MsgGUID: 7Ovy5WYORNO1flnYqVc4jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,189,1719903600"; 
   d="scan'208";a="68141810"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 30 Aug 2024 13:22:34 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sk88e-00023a-2u;
	Fri, 30 Aug 2024 20:22:32 +0000
Date: Sat, 31 Aug 2024 04:22:19 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.12] BUILD SUCCESS
 fb16787b396c46158e46b588d357dea4e090020b
Message-ID: <202408310417.UwVrrHUS-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.12
branch HEAD: fb16787b396c46158e46b588d357dea4e090020b  Merge branch 'md-6.12-raid5-opt' into md-6.12

elapsed time: 1516m

configs tested: 167
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc-14.1.0
alpha                            allyesconfig   clang-20
alpha                               defconfig   gcc-14.1.0
arc                              allmodconfig   clang-20
arc                              allmodconfig   gcc-13.2.0
arc                               allnoconfig   gcc-14.1.0
arc                              allyesconfig   clang-20
arc                              allyesconfig   gcc-13.2.0
arc                                 defconfig   gcc-14.1.0
arc                   randconfig-001-20240830   gcc-14.1.0
arc                   randconfig-002-20240830   gcc-14.1.0
arm                              allmodconfig   clang-20
arm                              allmodconfig   gcc-13.2.0
arm                               allnoconfig   gcc-14.1.0
arm                              allyesconfig   clang-20
arm                              allyesconfig   gcc-13.2.0
arm                                 defconfig   gcc-14.1.0
arm                        multi_v5_defconfig   gcc-14.1.0
arm                       omap2plus_defconfig   gcc-14.1.0
arm                            qcom_defconfig   gcc-14.1.0
arm                   randconfig-001-20240830   gcc-14.1.0
arm                   randconfig-002-20240830   gcc-14.1.0
arm                   randconfig-003-20240830   gcc-14.1.0
arm                   randconfig-004-20240830   gcc-14.1.0
arm64                            allmodconfig   clang-20
arm64                             allnoconfig   gcc-14.1.0
arm64                               defconfig   gcc-14.1.0
arm64                 randconfig-001-20240830   gcc-14.1.0
arm64                 randconfig-002-20240830   gcc-14.1.0
arm64                 randconfig-003-20240830   gcc-14.1.0
arm64                 randconfig-004-20240830   gcc-14.1.0
csky                              allnoconfig   gcc-14.1.0
csky                                defconfig   gcc-14.1.0
csky                  randconfig-001-20240830   gcc-14.1.0
csky                  randconfig-002-20240830   gcc-14.1.0
hexagon                          allmodconfig   clang-20
hexagon                           allnoconfig   gcc-14.1.0
hexagon                          allyesconfig   clang-20
hexagon                             defconfig   gcc-14.1.0
hexagon               randconfig-001-20240830   gcc-14.1.0
hexagon               randconfig-002-20240830   gcc-14.1.0
i386                             allmodconfig   clang-18
i386                              allnoconfig   clang-18
i386                             allyesconfig   clang-18
i386         buildonly-randconfig-001-20240830   gcc-12
i386         buildonly-randconfig-002-20240830   gcc-12
i386         buildonly-randconfig-003-20240830   gcc-12
i386         buildonly-randconfig-004-20240830   gcc-12
i386         buildonly-randconfig-005-20240830   gcc-12
i386         buildonly-randconfig-006-20240830   gcc-12
i386                                defconfig   clang-18
i386                  randconfig-001-20240830   gcc-12
i386                  randconfig-002-20240830   gcc-12
i386                  randconfig-003-20240830   gcc-12
i386                  randconfig-004-20240830   gcc-12
i386                  randconfig-005-20240830   gcc-12
i386                  randconfig-006-20240830   gcc-12
i386                  randconfig-011-20240830   gcc-12
i386                  randconfig-012-20240830   gcc-12
i386                  randconfig-013-20240830   gcc-12
i386                  randconfig-014-20240830   gcc-12
i386                  randconfig-015-20240830   gcc-12
i386                  randconfig-016-20240830   gcc-12
loongarch                        allmodconfig   gcc-14.1.0
loongarch                         allnoconfig   gcc-14.1.0
loongarch                           defconfig   gcc-14.1.0
loongarch             randconfig-001-20240830   gcc-14.1.0
loongarch             randconfig-002-20240830   gcc-14.1.0
m68k                             allmodconfig   gcc-14.1.0
m68k                              allnoconfig   gcc-14.1.0
m68k                             allyesconfig   gcc-14.1.0
m68k                                defconfig   gcc-14.1.0
m68k                       m5275evb_defconfig   gcc-14.1.0
m68k                           virt_defconfig   gcc-14.1.0
microblaze                       allmodconfig   gcc-14.1.0
microblaze                        allnoconfig   gcc-14.1.0
microblaze                       allyesconfig   gcc-14.1.0
microblaze                          defconfig   gcc-14.1.0
mips                              allnoconfig   gcc-14.1.0
mips                           jazz_defconfig   gcc-14.1.0
mips                     loongson2k_defconfig   gcc-14.1.0
nios2                             allnoconfig   gcc-14.1.0
nios2                               defconfig   gcc-14.1.0
nios2                 randconfig-001-20240830   gcc-14.1.0
nios2                 randconfig-002-20240830   gcc-14.1.0
openrisc                         alldefconfig   gcc-14.1.0
openrisc                          allnoconfig   clang-20
openrisc                            defconfig   gcc-12
parisc                            allnoconfig   clang-20
parisc                              defconfig   gcc-12
parisc                randconfig-001-20240830   gcc-14.1.0
parisc                randconfig-002-20240830   gcc-14.1.0
parisc64                            defconfig   gcc-14.1.0
powerpc                           allnoconfig   clang-20
powerpc                        cell_defconfig   gcc-14.1.0
powerpc                      ep88xc_defconfig   gcc-14.1.0
powerpc                         ps3_defconfig   gcc-14.1.0
powerpc               randconfig-001-20240830   gcc-14.1.0
powerpc               randconfig-002-20240830   gcc-14.1.0
powerpc64             randconfig-001-20240830   gcc-14.1.0
powerpc64             randconfig-002-20240830   gcc-14.1.0
powerpc64             randconfig-003-20240830   gcc-14.1.0
riscv                             allnoconfig   clang-20
riscv                               defconfig   gcc-12
riscv                 randconfig-001-20240830   gcc-14.1.0
riscv                 randconfig-002-20240830   gcc-14.1.0
s390                             allmodconfig   gcc-14.1.0
s390                              allnoconfig   clang-20
s390                             allyesconfig   gcc-14.1.0
s390                                defconfig   gcc-12
s390                  randconfig-001-20240830   gcc-14.1.0
s390                  randconfig-002-20240830   gcc-14.1.0
sh                               allmodconfig   gcc-14.1.0
sh                                allnoconfig   gcc-14.1.0
sh                               allyesconfig   gcc-14.1.0
sh                                  defconfig   gcc-12
sh                          landisk_defconfig   gcc-14.1.0
sh                    randconfig-001-20240830   gcc-14.1.0
sh                    randconfig-002-20240830   gcc-14.1.0
sh                          rsk7269_defconfig   gcc-14.1.0
sh                           se7722_defconfig   gcc-14.1.0
sh                             sh03_defconfig   gcc-14.1.0
sh                          urquell_defconfig   gcc-14.1.0
sparc                            allmodconfig   gcc-14.1.0
sparc64                             defconfig   gcc-12
sparc64               randconfig-001-20240830   gcc-14.1.0
sparc64               randconfig-002-20240830   gcc-14.1.0
um                               allmodconfig   clang-20
um                                allnoconfig   clang-20
um                               allyesconfig   clang-20
um                                  defconfig   gcc-12
um                             i386_defconfig   gcc-12
um                    randconfig-001-20240830   gcc-14.1.0
um                    randconfig-002-20240830   gcc-14.1.0
um                           x86_64_defconfig   gcc-12
x86_64                            allnoconfig   clang-18
x86_64                           allyesconfig   clang-18
x86_64       buildonly-randconfig-001-20240830   clang-18
x86_64       buildonly-randconfig-002-20240830   clang-18
x86_64       buildonly-randconfig-003-20240830   clang-18
x86_64       buildonly-randconfig-004-20240830   clang-18
x86_64       buildonly-randconfig-005-20240830   clang-18
x86_64       buildonly-randconfig-006-20240830   clang-18
x86_64                              defconfig   clang-18
x86_64                randconfig-001-20240830   clang-18
x86_64                randconfig-002-20240830   clang-18
x86_64                randconfig-003-20240830   clang-18
x86_64                randconfig-004-20240830   clang-18
x86_64                randconfig-005-20240830   clang-18
x86_64                randconfig-006-20240830   clang-18
x86_64                randconfig-011-20240830   clang-18
x86_64                randconfig-012-20240830   clang-18
x86_64                randconfig-013-20240830   clang-18
x86_64                randconfig-014-20240830   clang-18
x86_64                randconfig-015-20240830   clang-18
x86_64                randconfig-016-20240830   clang-18
x86_64                randconfig-071-20240830   clang-18
x86_64                randconfig-072-20240830   clang-18
x86_64                randconfig-073-20240830   clang-18
x86_64                randconfig-074-20240830   clang-18
x86_64                randconfig-075-20240830   clang-18
x86_64                randconfig-076-20240830   clang-18
x86_64                          rhel-8.3-rust   clang-18
xtensa                            allnoconfig   gcc-14.1.0
xtensa                       common_defconfig   gcc-14.1.0
xtensa                randconfig-001-20240830   gcc-14.1.0
xtensa                randconfig-002-20240830   gcc-14.1.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
