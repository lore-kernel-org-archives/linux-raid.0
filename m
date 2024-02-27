Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5D1146E74
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709046584; cv=none; b=X7Nm7/IVTMcZvGaHsH5CJFggD/bLGYmrSVqKevcSwj9z9vYC443IcVe/Fi7OBo3FFi84L8J5pOTnO1JPR3nRMvmbm+gLeQwAiRNcMJ3dNKfRPzV8WOVL/mDvOPHOrWGnAaF0VIU+T5Wi220U9vhDsGPAhSl9MoDKfe8t8FqfRrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709046584; c=relaxed/simple;
	bh=6bdePzFdAUq51J4d5cpHDT0tuQ4MMYRmbm+yrJLdYxc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=TAzfR7FnhX9+kooMMd71v8CwVGCkK2iUM8cRBgHFtbm+A1Vk62lhSoFJcID0s4gZeOYjLkiNV1xR7IopKnGgOOF5vzypDb19lQ2bnp4Y0hXggQ8KqeHCXs5e0KAAZDz8tUFKXmQn8dPuP1MqGQEo+MuoymK/sUBvEloCSyJkmjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RqhWeyLj; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RqhWeyLj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709046583; x=1740582583;
  h=date:from:to:cc:subject:message-id;
  bh=6bdePzFdAUq51J4d5cpHDT0tuQ4MMYRmbm+yrJLdYxc=;
  b=RqhWeyLjgPTTSwcKRLzZOd9QRWWE/qHMxCHKXCDjYJMocRCreB4N2NT1
   WJEgQ0t6cdQBbbcA7Vbm1VFXsifycMzkrQ3eJ7fcl9zIAPHKJ3Ut6IT/u
   LhLe0Nb1ffHhVdYyYQwlfOwKgYNGpOzqSINKrU3+umE9Oth4OkHAzd2EA
   +b3M8x0l7OEyLV2tuGkhty5GkjnAsRVVLp8mneqt+t3nh5YKEkNm69hL8
   MotJNgUxXRiXGUX2FSB/V20ywiraqOclMZmi5SbY7m9BZikNCztYBXEVt
   si6VTfnnlKOBJz1WpoxrRPl+v8Fr65V+xfMEw8AFRnxPaY1RqA8Ra9pFx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3550204"
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="3550204"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 07:09:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="11748244"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 27 Feb 2024 07:09:41 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rez5O-000BJL-2L;
	Tue, 27 Feb 2024 15:09:38 +0000
Date: Tue, 27 Feb 2024 23:07:54 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.9] BUILD SUCCESS
 ecbd8ebb51bf7e4939d83b9e6022a55cac44ef06
Message-ID: <202402272351.qPIouyVo-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.9
branch HEAD: ecbd8ebb51bf7e4939d83b9e6022a55cac44ef06  md/md-bitmap: fix incorrect usage for sb_index

elapsed time: 1035m

configs tested: 170
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
arc                   randconfig-001-20240227   gcc  
arc                   randconfig-002-20240227   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                          collie_defconfig   gcc  
arm                                 defconfig   clang
arm                          pxa910_defconfig   gcc  
arm                   randconfig-001-20240227   gcc  
arm                   randconfig-002-20240227   gcc  
arm                   randconfig-003-20240227   gcc  
arm                   randconfig-004-20240227   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-002-20240227   gcc  
arm64                 randconfig-003-20240227   gcc  
arm64                 randconfig-004-20240227   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240227   gcc  
csky                  randconfig-002-20240227   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240227   gcc  
i386         buildonly-randconfig-002-20240227   gcc  
i386         buildonly-randconfig-003-20240227   clang
i386         buildonly-randconfig-004-20240227   gcc  
i386         buildonly-randconfig-005-20240227   gcc  
i386         buildonly-randconfig-006-20240227   gcc  
i386                                defconfig   clang
i386                  randconfig-001-20240227   gcc  
i386                  randconfig-002-20240227   gcc  
i386                  randconfig-003-20240227   clang
i386                  randconfig-004-20240227   clang
i386                  randconfig-005-20240227   clang
i386                  randconfig-006-20240227   gcc  
i386                  randconfig-011-20240227   clang
i386                  randconfig-012-20240227   clang
i386                  randconfig-013-20240227   clang
i386                  randconfig-014-20240227   clang
i386                  randconfig-015-20240227   clang
i386                  randconfig-016-20240227   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240227   gcc  
loongarch             randconfig-002-20240227   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                          atari_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5249evb_defconfig   gcc  
microblaze                       alldefconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                       bmips_be_defconfig   gcc  
mips                         cobalt_defconfig   gcc  
mips                 decstation_r4k_defconfig   gcc  
mips                       lemote2f_defconfig   gcc  
mips                malta_qemu_32r6_defconfig   gcc  
mips                    maltaup_xpa_defconfig   gcc  
mips                           rs90_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240227   gcc  
nios2                 randconfig-002-20240227   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc                    or1ksim_defconfig   gcc  
parisc                           alldefconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240227   gcc  
parisc                randconfig-002-20240227   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc               randconfig-002-20240227   gcc  
powerpc                      walnut_defconfig   gcc  
powerpc64             randconfig-002-20240227   gcc  
powerpc64             randconfig-003-20240227   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-001-20240227   gcc  
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-001-20240227   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                          lboxre2_defconfig   gcc  
sh                     magicpanelr2_defconfig   gcc  
sh                            migor_defconfig   gcc  
sh                    randconfig-001-20240227   gcc  
sh                    randconfig-002-20240227   gcc  
sh                   rts7751r2dplus_defconfig   gcc  
sh                           se7705_defconfig   gcc  
sh                            titan_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240227   gcc  
sparc64               randconfig-002-20240227   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240227   clang
x86_64       buildonly-randconfig-003-20240227   clang
x86_64       buildonly-randconfig-004-20240227   clang
x86_64       buildonly-randconfig-005-20240227   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240227   clang
x86_64                randconfig-002-20240227   clang
x86_64                randconfig-013-20240227   clang
x86_64                randconfig-072-20240227   clang
x86_64                randconfig-074-20240227   clang
x86_64                randconfig-075-20240227   clang
x86_64                randconfig-076-20240227   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                  audio_kc705_defconfig   gcc  
xtensa                generic_kc705_defconfig   gcc  
xtensa                randconfig-001-20240227   gcc  
xtensa                randconfig-002-20240227   gcc  
xtensa                    smp_lx200_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
