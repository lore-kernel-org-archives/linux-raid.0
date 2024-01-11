Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4594F190
	for <linux-raid@vger.kernel.org>; Thu, 11 Jan 2024 00:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixCTCL3E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704932864; x=1736468864;
  h=date:from:to:cc:subject:message-id;
  bh=Y1Z2HLyx/4/vfTAvM+3MRxjxSVyfpEGEWwGLKbDNiwY=;
  b=ixCTCL3E3Sa3z9HolX/tx97JRigXeOzpUMZiCCzIQfkuRE7vh/3aB20Y
   0IIU2VC8q9e710ta2cuwYWDGpLPLPJHwgHYZfmPnVyvCud8k7tE0t2+Uv
   GUrFRC6A4GMfmYbXg9Mm9W4z/kYujxjLMUXTK0aqcvtoy54bU3VZ70f9q
   +ve2EOby9RjWA953ucU82IDVOFkMXGN3SW3bfhjFscEtfBA5xo2YIX9/I
   PhiK7WU03j4d9AzPUNf0/e5ZbKZOZGkwrF69Z/za6x5z8C/DbOj8VMGf1
   jg6OyGPMSyIo0DlKBXuw3ryOlA7Wc0pcFIcIWSEPt+vwylKsgOr5WEvA4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="20177171"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="20177171"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 16:27:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="16847086"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 10 Jan 2024 16:27:42 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rNiv3-0007ca-1e;
	Thu, 11 Jan 2024 00:27:37 +0000
Date: Thu, 11 Jan 2024 08:26:01 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.8] BUILD SUCCESS
 7dab24554dedd4e6f408af8eb2d25c89997a6a1f
Message-ID: <202401110859.ziGDnOUp-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.8
branch HEAD: 7dab24554dedd4e6f408af8eb2d25c89997a6a1f  md/raid1: Use blk_opf_t for read and write operations

elapsed time: 1462m

configs tested: 144
configs skipped: 2

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
arc                   randconfig-001-20240110   gcc  
arc                   randconfig-002-20240110   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                                 defconfig   clang
arm                   randconfig-001-20240110   clang
arm                   randconfig-002-20240110   clang
arm                   randconfig-003-20240110   clang
arm                   randconfig-004-20240110   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240110   clang
arm64                 randconfig-002-20240110   clang
arm64                 randconfig-003-20240110   clang
arm64                 randconfig-004-20240110   clang
csky                              allnoconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240110   gcc  
csky                  randconfig-002-20240110   gcc  
hexagon                           allnoconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20240110   clang
hexagon               randconfig-002-20240110   clang
i386                             allmodconfig   clang
i386                              allnoconfig   clang
i386                             allyesconfig   clang
i386         buildonly-randconfig-001-20240110   clang
i386         buildonly-randconfig-002-20240110   clang
i386         buildonly-randconfig-003-20240110   clang
i386         buildonly-randconfig-004-20240110   clang
i386         buildonly-randconfig-005-20240110   clang
i386         buildonly-randconfig-006-20240110   clang
i386                                defconfig   gcc  
i386                  randconfig-001-20240110   clang
i386                  randconfig-002-20240110   clang
i386                  randconfig-003-20240110   clang
i386                  randconfig-004-20240110   clang
i386                  randconfig-005-20240110   clang
i386                  randconfig-006-20240110   clang
i386                  randconfig-011-20240110   gcc  
i386                  randconfig-012-20240110   gcc  
i386                  randconfig-013-20240110   gcc  
i386                  randconfig-014-20240110   gcc  
i386                  randconfig-015-20240110   gcc  
i386                  randconfig-016-20240110   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240110   gcc  
loongarch             randconfig-002-20240110   gcc  
m68k                              allnoconfig   gcc  
m68k                                defconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                          defconfig   gcc  
mips                              allnoconfig   clang
nios2                             allnoconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240110   gcc  
nios2                 randconfig-002-20240110   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240110   gcc  
parisc                randconfig-002-20240110   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   clang
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc               randconfig-001-20240110   clang
powerpc               randconfig-002-20240110   clang
powerpc               randconfig-003-20240110   clang
powerpc64             randconfig-001-20240110   clang
powerpc64             randconfig-002-20240110   clang
powerpc64             randconfig-003-20240110   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   clang
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                 randconfig-001-20240110   clang
riscv                 randconfig-002-20240110   clang
riscv                          rv32_defconfig   clang
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20240110   gcc  
s390                  randconfig-002-20240110   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                    randconfig-001-20240110   gcc  
sh                    randconfig-002-20240110   gcc  
sparc                            allmodconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240110   gcc  
sparc64               randconfig-002-20240110   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                    randconfig-001-20240110   clang
um                    randconfig-002-20240110   clang
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240111   gcc  
x86_64       buildonly-randconfig-002-20240111   gcc  
x86_64       buildonly-randconfig-003-20240111   gcc  
x86_64       buildonly-randconfig-004-20240111   gcc  
x86_64       buildonly-randconfig-005-20240111   gcc  
x86_64       buildonly-randconfig-006-20240111   gcc  
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240111   clang
x86_64                randconfig-002-20240111   clang
x86_64                randconfig-003-20240111   clang
x86_64                randconfig-004-20240111   clang
x86_64                randconfig-005-20240111   clang
x86_64                randconfig-006-20240111   clang
x86_64                randconfig-011-20240111   gcc  
x86_64                randconfig-012-20240111   gcc  
x86_64                randconfig-013-20240111   gcc  
x86_64                randconfig-014-20240111   gcc  
x86_64                randconfig-015-20240111   gcc  
x86_64                randconfig-016-20240111   gcc  
x86_64                randconfig-071-20240111   gcc  
x86_64                randconfig-072-20240111   gcc  
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  
xtensa                randconfig-001-20240110   gcc  
xtensa                randconfig-002-20240110   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
