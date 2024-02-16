Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DB441E4E
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 22:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708124283; cv=none; b=D+U5I4nkAnfDYagXx4Yq7+WSjmstwlG59G7M93iCKsQe1YXNUDMA8WtH5gsVy8y9/KlNawWWL3nSjlOpALaQJFAeBffpGMGj/NAuB8FYdKqGSL2hZVeE0TOdn1VZ4BieeRSFNY/um9TOFrHeqiW+j1InBNgMgVDPATRmWRHo6e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708124283; c=relaxed/simple;
	bh=gPXV+JSAOjzwL75lHBodA/7r1CvnDNI+38HmjRQNJd4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=FT3GxlgjM3/+luKlKgvkp0iDKORc1IeFUyhALW9S74Pj6TlYBgftcZ8Nq4UMXpIvKGykw9q+Qnx1IijveY1Hrdb0fepA6YpvuPgUUP9/B8UhoyRL8boHLW166m0ioVFMe8o/fnhU8ZuoiftRx0YaXkiyySnUEQaw192vnqffykM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RuNBXCk0; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RuNBXCk0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708124281; x=1739660281;
  h=date:from:to:cc:subject:message-id;
  bh=gPXV+JSAOjzwL75lHBodA/7r1CvnDNI+38HmjRQNJd4=;
  b=RuNBXCk0lv2C8TnhHZyl2+ViF6nrqUDr5mGUBVGHidxfdtmCDXwPCgPx
   jEzDtNjI5aRDk4uZbbKd2Omv546WnAOiuNl0uR1dn9vFjbXcR041ESGJb
   vUwxQed9CUsn+4YTuodg/UBgnTYHnKD0Mp+cEw33WqLg3dWhK+Fci6yGE
   fEXF5jyUB8eGmDUsjA4wi0+omPfmvKZfRYkt4zLeeMachvsFsbMghBedk
   4Neyq4PdZh+AXorO2xozJS+zwfJGpVe1ID/jE3jm/f7sRc4ZRhcJUwa6L
   hBukJukN1i0V8uwivt90i6UKMgFaMX7L4jiqlEfyX3G9+iWoGfHUKCx1k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="2137670"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="2137670"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 14:58:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="8656577"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 16 Feb 2024 14:58:00 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rb79Y-0001fO-2K;
	Fri, 16 Feb 2024 22:57:56 +0000
Date: Sat, 17 Feb 2024 06:57:17 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.8] BUILD SUCCESS
 9e46c70e829bddc24e04f963471e9983a11598b7
Message-ID: <202402170615.HkEWCDpO-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.8
branch HEAD: 9e46c70e829bddc24e04f963471e9983a11598b7  md: Don't suspend the array for interrupted reshape

elapsed time: 1453m

configs tested: 189
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
arc                                 defconfig   gcc  
arc                     haps_hs_smp_defconfig   gcc  
arc                   randconfig-001-20240216   gcc  
arc                   randconfig-002-20240216   gcc  
arm                              alldefconfig   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                          collie_defconfig   gcc  
arm                                 defconfig   clang
arm                            hisi_defconfig   gcc  
arm                        keystone_defconfig   gcc  
arm                          moxart_defconfig   gcc  
arm                        neponset_defconfig   gcc  
arm                             pxa_defconfig   gcc  
arm                   randconfig-003-20240216   gcc  
arm                   randconfig-004-20240216   gcc  
arm                           tegra_defconfig   gcc  
arm                           u8500_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-002-20240216   gcc  
arm64                 randconfig-004-20240216   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240216   gcc  
csky                  randconfig-002-20240216   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240216   gcc  
i386         buildonly-randconfig-001-20240217   gcc  
i386         buildonly-randconfig-003-20240217   gcc  
i386         buildonly-randconfig-004-20240216   gcc  
i386         buildonly-randconfig-004-20240217   gcc  
i386         buildonly-randconfig-005-20240216   gcc  
i386         buildonly-randconfig-005-20240217   gcc  
i386                  randconfig-001-20240217   gcc  
i386                  randconfig-002-20240217   gcc  
i386                  randconfig-003-20240216   gcc  
i386                  randconfig-004-20240217   gcc  
i386                  randconfig-005-20240216   gcc  
i386                  randconfig-005-20240217   gcc  
i386                  randconfig-011-20240216   gcc  
i386                  randconfig-011-20240217   gcc  
i386                  randconfig-012-20240216   gcc  
i386                  randconfig-012-20240217   gcc  
i386                  randconfig-013-20240216   gcc  
i386                  randconfig-015-20240216   gcc  
i386                  randconfig-016-20240216   gcc  
i386                  randconfig-016-20240217   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240216   gcc  
loongarch             randconfig-002-20240216   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                          amiga_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5249evb_defconfig   gcc  
m68k                        mvme16x_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                           ip28_defconfig   gcc  
mips                      loongson3_defconfig   gcc  
mips                      pic32mzda_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240216   gcc  
nios2                 randconfig-002-20240216   gcc  
openrisc                         alldefconfig   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc                    or1ksim_defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                generic-32bit_defconfig   gcc  
parisc                randconfig-001-20240216   gcc  
parisc                randconfig-002-20240216   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                        fsp2_defconfig   gcc  
powerpc                        icon_defconfig   gcc  
powerpc                    klondike_defconfig   gcc  
powerpc                 mpc832x_rdb_defconfig   gcc  
powerpc                         ps3_defconfig   gcc  
powerpc                     tqm5200_defconfig   gcc  
powerpc64             randconfig-003-20240216   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-001-20240216   gcc  
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-001-20240216   gcc  
s390                  randconfig-002-20240216   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                            hp6xx_defconfig   gcc  
sh                          landisk_defconfig   gcc  
sh                          lboxre2_defconfig   gcc  
sh                          r7785rp_defconfig   gcc  
sh                    randconfig-001-20240216   gcc  
sh                    randconfig-002-20240216   gcc  
sh                   sh7724_generic_defconfig   gcc  
sh                  sh7785lcr_32bit_defconfig   gcc  
sh                              ul2_defconfig   gcc  
sh                          urquell_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240216   gcc  
sparc64               randconfig-002-20240216   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                    randconfig-001-20240216   gcc  
um                    randconfig-002-20240216   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64       buildonly-randconfig-001-20240216   clang
x86_64       buildonly-randconfig-002-20240216   clang
x86_64       buildonly-randconfig-003-20240216   clang
x86_64       buildonly-randconfig-004-20240216   clang
x86_64       buildonly-randconfig-005-20240216   gcc  
x86_64       buildonly-randconfig-006-20240216   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240216   gcc  
x86_64                randconfig-002-20240216   clang
x86_64                randconfig-003-20240216   gcc  
x86_64                randconfig-004-20240216   gcc  
x86_64                randconfig-005-20240216   gcc  
x86_64                randconfig-006-20240216   clang
x86_64                randconfig-011-20240216   gcc  
x86_64                randconfig-012-20240216   gcc  
x86_64                randconfig-013-20240216   clang
x86_64                randconfig-014-20240216   gcc  
x86_64                randconfig-015-20240216   clang
x86_64                randconfig-016-20240216   clang
x86_64                randconfig-071-20240216   clang
x86_64                randconfig-072-20240216   clang
x86_64                randconfig-073-20240216   gcc  
x86_64                randconfig-074-20240216   gcc  
x86_64                randconfig-075-20240216   clang
x86_64                randconfig-076-20240216   gcc  
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                randconfig-001-20240216   gcc  
xtensa                randconfig-002-20240216   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
