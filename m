Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252D915CD60
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709136362; cv=none; b=l8F4P1gZ/iZq3Wo0xfuKc65olNKrHW0KQdQ1nw8evPrC1hP4A03epbEU3kJsiRjENcPMa/kUjKSqC4kKDxGGVFYCMbuDEtY8okTonAgvcfMOzrOLr+0pgcKaWaDbynlRA6XqKHmuwgTLj4zbRh821xpcmkBmyI8hKRZR41DgrSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709136362; c=relaxed/simple;
	bh=rg4i1jC4k5ckoyGgt0Kf6eC8T7k/q6PLtZiWedvnp6c=;
	h=Date:From:To:Cc:Subject:Message-ID; b=tbMTfmwNjl1NKqkKdybqqTkhavUQ3hceW9eKwrS7y25oLC3qCFVY0N4td9+ZaGtb7zA1b165OLR8AALA8RzIe+cPNaj5A0NqbFWm3kYSykJv6rnkMyD7ADwMfZzOD3JFhABwHopMOSpU2XRg9imgmmlGAHdXDHXtOCEV+iWSCLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SyVffM+s; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SyVffM+s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709136360; x=1740672360;
  h=date:from:to:cc:subject:message-id;
  bh=rg4i1jC4k5ckoyGgt0Kf6eC8T7k/q6PLtZiWedvnp6c=;
  b=SyVffM+sxzyajalZcm/LAUrD5eNYMdtfrCixbeMpgW3D83nLDTffmTl2
   3fciF9qCc2Z6o1T7QNpQiaGvOMIApza3e2Ae3EDw8b0SjwYOuTmXehfIm
   0hMC2jCgFyzvBHZ2QXacP4O7R0Hapdfn/ht9dDyDBr/hZLakgWGR4YCaB
   08iWPE8cSsa5xsEdUNqn6lijc7MmQXFjOjGRE33PTpBLRGmGa5wrcqTv8
   pfCZZUEBaslWl89W7gBh9jDrDDoIU1M4CVoL7YWrqNqmJUoqiRQ9x8XFR
   uDyh8dTgWsi/JdoQNY7Hc8MnnqQTIOUDSwCDqC0GD9W2ZRzp3sweJ37VG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3660811"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="3660811"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 08:05:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="7405672"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 28 Feb 2024 08:05:58 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rfMRQ-000CCP-11;
	Wed, 28 Feb 2024 16:05:56 +0000
Date: Thu, 29 Feb 2024 00:05:36 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.9] BUILD SUCCESS
 dfd2bf436709b2bccb78c2dda550dde93700efa7
Message-ID: <202402290033.jeMiWYTS-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.9
branch HEAD: dfd2bf436709b2bccb78c2dda550dde93700efa7  md/raid5: fix atomicity violation in raid5_cache_count

elapsed time: 1031m

configs tested: 157
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                          axs101_defconfig   gcc  
arc                                 defconfig   gcc  
arc                   randconfig-001-20240228   gcc  
arc                   randconfig-002-20240228   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                                 defconfig   clang
arm                          ixp4xx_defconfig   gcc  
arm                            mmp2_defconfig   gcc  
arm                        mvebu_v5_defconfig   gcc  
arm                   randconfig-004-20240228   gcc  
arm                         socfpga_defconfig   gcc  
arm                       versatile_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-002-20240228   gcc  
arm64                 randconfig-003-20240228   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240228   gcc  
csky                  randconfig-002-20240228   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240228   clang
i386         buildonly-randconfig-002-20240228   clang
i386         buildonly-randconfig-003-20240228   clang
i386         buildonly-randconfig-004-20240228   clang
i386         buildonly-randconfig-006-20240228   clang
i386                                defconfig   clang
i386                  randconfig-001-20240228   clang
i386                  randconfig-002-20240228   clang
i386                  randconfig-004-20240228   clang
i386                  randconfig-005-20240228   clang
i386                  randconfig-011-20240228   clang
i386                  randconfig-012-20240228   clang
i386                  randconfig-016-20240228   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch                 loongson3_defconfig   gcc  
loongarch             randconfig-001-20240228   gcc  
loongarch             randconfig-002-20240228   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                     cu1000-neo_defconfig   gcc  
mips                  decstation_64_defconfig   gcc  
mips                     loongson1c_defconfig   gcc  
mips                      maltasmvp_defconfig   gcc  
mips                  maltasmvp_eva_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240228   gcc  
nios2                 randconfig-002-20240228   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240228   gcc  
parisc                randconfig-002-20240228   gcc  
parisc64                         alldefconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                     ep8248e_defconfig   gcc  
powerpc                  iss476-smp_defconfig   gcc  
powerpc                         ps3_defconfig   gcc  
powerpc               randconfig-003-20240228   gcc  
powerpc                        warp_defconfig   gcc  
powerpc64             randconfig-003-20240228   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-002-20240228   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                        dreamcast_defconfig   gcc  
sh                        edosk7760_defconfig   gcc  
sh                               j2_defconfig   gcc  
sh                    randconfig-001-20240228   gcc  
sh                    randconfig-002-20240228   gcc  
sh                           se7712_defconfig   gcc  
sh                           se7724_defconfig   gcc  
sh                        sh7763rdp_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240228   gcc  
sparc64               randconfig-002-20240228   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-002-20240228   clang
x86_64       buildonly-randconfig-003-20240228   clang
x86_64       buildonly-randconfig-006-20240228   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240228   clang
x86_64                randconfig-006-20240228   clang
x86_64                randconfig-011-20240228   clang
x86_64                randconfig-012-20240228   clang
x86_64                randconfig-013-20240228   clang
x86_64                randconfig-072-20240228   clang
x86_64                randconfig-075-20240228   clang
x86_64                randconfig-076-20240228   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                randconfig-001-20240228   gcc  
xtensa                randconfig-002-20240228   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
