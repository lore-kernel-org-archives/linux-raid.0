Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9084A0A
	for <linux-raid@vger.kernel.org>; Wed,  7 Feb 2024 00:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707266128; cv=none; b=A8/DXYD7oem91++JOL8fvRxeKcbPGra42Pkyy/SBGkfYrYThg+Rwiwk1LBZDd+uR0mwhM7pQogEH7ZHIvHXB1L2brLyCSC1Z08uHFN26PLq6uLjEhHPy6+miPLjLaUyi2TVZr7PSOtefuLKaArvvkPuJ63TZ2I0O0wPG2xYvhTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707266128; c=relaxed/simple;
	bh=wufIYjYyJrOOEK1TNtwy8Q46ShA6n7va1hL6So8prxU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=X7n0IuihP3n6TGIM2exbeMKbd5N743Ve4EHMO2JYVMLP4xov0EJ85MQAQ9+zGIqrvlkuqn54Sxz3q9i2BG9ScJ0CBj1eVv6d1TJxupHLYcc7tCVMIFdzt7tGAUDWbsU11LXr8i1x/vKIfS9w2IASK5tuQghhIAI705gDranRCy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lDVxxIvG; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lDVxxIvG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707266127; x=1738802127;
  h=date:from:to:cc:subject:message-id;
  bh=wufIYjYyJrOOEK1TNtwy8Q46ShA6n7va1hL6So8prxU=;
  b=lDVxxIvGAKFaHr8gEMckQssy/8DdlYlC0WCtflr8YpRzt1PT8HC7XHRW
   5SSfxCEPTixDczdza8fuSUsPm9eBA7ILbbegqOjTRGwo2KyXyemca3hoX
   UFdBE4BRayd28dxn1jmaRfg+VPBOsDY3VBgzG0mGnRe2tsUDZTWwcedgy
   LBWV183quWlgtoVjZD9iIhU2H05yuAYcnBs80EAalZEKHIhyKC7bXJEdO
   P3vMAFcnQF04+32T8DnT2aIapNsNkmu6ZiAQNS3ryM6pUwEyMHy7jgJ5O
   V6oOYgcQ2c8eTXJZJuVBr8ZYmzcbnHsCIfq9qBMqeKyq6n6/aEcP537ii
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="771829"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="771829"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 16:35:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="5783330"
Received: from lkp-server01.sh.intel.com (HELO 01f0647817ea) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 06 Feb 2024 16:35:24 -0800
Received: from kbuild by 01f0647817ea with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rXVuM-0001vA-1O;
	Wed, 07 Feb 2024 00:35:22 +0000
Date: Wed, 07 Feb 2024 08:34:56 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.9] BUILD SUCCESS
 83cbdaf61b1ab9cdaa0321eeea734bc70ca069c8
Message-ID: <202402070853.6wvXjimu-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.9
branch HEAD: 83cbdaf61b1ab9cdaa0321eeea734bc70ca069c8  md/multipath: Remove md-multipath.h

elapsed time: 1453m

configs tested: 253
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              alldefconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                     haps_hs_smp_defconfig   gcc  
arc                            hsdk_defconfig   gcc  
arc                        nsimosci_defconfig   gcc  
arc                   randconfig-001-20240206   gcc  
arc                   randconfig-001-20240207   gcc  
arc                   randconfig-002-20240206   gcc  
arc                   randconfig-002-20240207   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                       aspeed_g5_defconfig   gcc  
arm                          collie_defconfig   gcc  
arm                                 defconfig   clang
arm                        neponset_defconfig   gcc  
arm                       netwinder_defconfig   gcc  
arm                   randconfig-002-20240206   gcc  
arm                   randconfig-003-20240206   gcc  
arm                   randconfig-004-20240207   gcc  
arm                          sp7021_defconfig   gcc  
arm                           spitz_defconfig   gcc  
arm                           tegra_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240206   gcc  
arm64                 randconfig-003-20240206   gcc  
arm64                 randconfig-004-20240206   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240206   gcc  
csky                  randconfig-001-20240207   gcc  
csky                  randconfig-002-20240206   gcc  
csky                  randconfig-002-20240207   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240206   clang
i386         buildonly-randconfig-002-20240206   clang
i386         buildonly-randconfig-003-20240206   gcc  
i386         buildonly-randconfig-004-20240206   clang
i386         buildonly-randconfig-005-20240206   gcc  
i386         buildonly-randconfig-006-20240206   gcc  
i386                                defconfig   clang
i386                  randconfig-001-20240206   clang
i386                  randconfig-001-20240207   gcc  
i386                  randconfig-002-20240206   clang
i386                  randconfig-003-20240206   clang
i386                  randconfig-003-20240207   gcc  
i386                  randconfig-004-20240206   clang
i386                  randconfig-004-20240207   gcc  
i386                  randconfig-005-20240206   clang
i386                  randconfig-005-20240207   gcc  
i386                  randconfig-006-20240206   clang
i386                  randconfig-011-20240206   clang
i386                  randconfig-011-20240207   gcc  
i386                  randconfig-012-20240206   gcc  
i386                  randconfig-012-20240207   gcc  
i386                  randconfig-013-20240206   clang
i386                  randconfig-013-20240207   gcc  
i386                  randconfig-014-20240206   gcc  
i386                  randconfig-014-20240207   gcc  
i386                  randconfig-015-20240206   gcc  
i386                  randconfig-015-20240207   gcc  
i386                  randconfig-016-20240206   gcc  
i386                  randconfig-016-20240207   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240206   gcc  
loongarch             randconfig-001-20240207   gcc  
loongarch             randconfig-002-20240206   gcc  
loongarch             randconfig-002-20240207   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                          atari_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5249evb_defconfig   gcc  
m68k                        m5407c3_defconfig   gcc  
m68k                            mac_defconfig   gcc  
m68k                        mvme147_defconfig   gcc  
m68k                        mvme16x_defconfig   gcc  
m68k                            q40_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                  cavium_octeon_defconfig   gcc  
mips                     decstation_defconfig   gcc  
mips                 decstation_r4k_defconfig   gcc  
mips                      fuloong2e_defconfig   gcc  
mips                          malta_defconfig   gcc  
mips                malta_qemu_32r6_defconfig   gcc  
mips                      maltasmvp_defconfig   gcc  
mips                           rs90_defconfig   gcc  
mips                   sb1250_swarm_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240206   gcc  
nios2                 randconfig-001-20240207   gcc  
nios2                 randconfig-002-20240206   gcc  
nios2                 randconfig-002-20240207   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                generic-32bit_defconfig   gcc  
parisc                randconfig-001-20240206   gcc  
parisc                randconfig-001-20240207   gcc  
parisc                randconfig-002-20240206   gcc  
parisc                randconfig-002-20240207   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                        cell_defconfig   gcc  
powerpc                  iss476-smp_defconfig   gcc  
powerpc                   microwatt_defconfig   gcc  
powerpc                 mpc832x_rdb_defconfig   gcc  
powerpc                     powernv_defconfig   gcc  
powerpc                      ppc64e_defconfig   gcc  
powerpc               randconfig-002-20240206   gcc  
powerpc               randconfig-003-20240207   gcc  
powerpc                  storcenter_defconfig   gcc  
powerpc                      walnut_defconfig   gcc  
powerpc                         wii_defconfig   gcc  
powerpc64             randconfig-001-20240206   gcc  
powerpc64             randconfig-002-20240207   gcc  
powerpc64             randconfig-003-20240206   gcc  
powerpc64             randconfig-003-20240207   gcc  
riscv                            alldefconfig   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-001-20240206   gcc  
riscv                 randconfig-002-20240207   gcc  
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-001-20240207   gcc  
s390                  randconfig-002-20240207   gcc  
sh                               alldefconfig   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                ecovec24-romimage_defconfig   gcc  
sh                    randconfig-001-20240206   gcc  
sh                    randconfig-001-20240207   gcc  
sh                    randconfig-002-20240206   gcc  
sh                    randconfig-002-20240207   gcc  
sh                          sdk7780_defconfig   gcc  
sh                          sdk7786_defconfig   gcc  
sh                           se7722_defconfig   gcc  
sh                           sh2007_defconfig   gcc  
sh                        sh7763rdp_defconfig   gcc  
sh                   sh7770_generic_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240206   gcc  
sparc64               randconfig-001-20240207   gcc  
sparc64               randconfig-002-20240206   gcc  
sparc64               randconfig-002-20240207   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                    randconfig-002-20240206   gcc  
um                    randconfig-002-20240207   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240206   gcc  
x86_64       buildonly-randconfig-001-20240207   clang
x86_64       buildonly-randconfig-002-20240206   clang
x86_64       buildonly-randconfig-002-20240207   clang
x86_64       buildonly-randconfig-003-20240206   gcc  
x86_64       buildonly-randconfig-004-20240206   gcc  
x86_64       buildonly-randconfig-004-20240207   clang
x86_64       buildonly-randconfig-005-20240206   gcc  
x86_64       buildonly-randconfig-005-20240207   clang
x86_64       buildonly-randconfig-006-20240206   gcc  
x86_64       buildonly-randconfig-006-20240207   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240206   clang
x86_64                randconfig-001-20240207   clang
x86_64                randconfig-002-20240206   clang
x86_64                randconfig-003-20240206   gcc  
x86_64                randconfig-004-20240206   gcc  
x86_64                randconfig-005-20240206   gcc  
x86_64                randconfig-005-20240207   clang
x86_64                randconfig-006-20240206   clang
x86_64                randconfig-006-20240207   clang
x86_64                randconfig-011-20240206   gcc  
x86_64                randconfig-011-20240207   clang
x86_64                randconfig-012-20240206   clang
x86_64                randconfig-013-20240206   gcc  
x86_64                randconfig-013-20240207   clang
x86_64                randconfig-014-20240206   clang
x86_64                randconfig-014-20240207   clang
x86_64                randconfig-015-20240206   gcc  
x86_64                randconfig-016-20240206   clang
x86_64                randconfig-071-20240206   gcc  
x86_64                randconfig-072-20240206   gcc  
x86_64                randconfig-072-20240207   clang
x86_64                randconfig-073-20240206   gcc  
x86_64                randconfig-073-20240207   clang
x86_64                randconfig-074-20240206   gcc  
x86_64                randconfig-075-20240206   clang
x86_64                randconfig-076-20240206   gcc  
x86_64                randconfig-076-20240207   clang
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                           alldefconfig   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                randconfig-001-20240206   gcc  
xtensa                randconfig-001-20240207   gcc  
xtensa                randconfig-002-20240206   gcc  
xtensa                randconfig-002-20240207   gcc  
xtensa                         virt_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
