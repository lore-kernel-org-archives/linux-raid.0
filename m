Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD914E1BD
	for <linux-raid@vger.kernel.org>; Wed, 20 Dec 2023 22:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kauo3PNd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703113163; x=1734649163;
  h=date:from:to:cc:subject:message-id;
  bh=LQ5pisW9Do/xLSGB2PJZkGsT05lQJ487ilYW6Aeq4co=;
  b=kauo3PNdi8N1hT1tj3irayFdAeHCjIf+9KWcv0otby9rhGow6WjLyrdT
   I97Ehvr9GpvGaMkE8yP1k2Z7iIWQn7/HW1yNZOspJOmxVRqJdPDeg7+Ec
   1me74mNCOs3JXg2ss9B59o0jCYgo8viNyrgwVT49EeZYN1ghjDwDJdPmP
   JWDQBW8sZieMCPPhZu2f7v6sbAQ/7POxFqRu70bIjD62A0UWWtgvQ24Nd
   6NNUqXxaf3oAOlPql/D/itze8KZedW6+hpYJQuNmfLsYmzEBpvSJITkSZ
   /T/S4aqy3hGD3/eqHILOykhsj04FE15dZbbzPtN3gk+jdexEpudYn0VO/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="380874725"
X-IronPort-AV: E=Sophos;i="6.04,292,1695711600"; 
   d="scan'208";a="380874725"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 14:53:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="1107876246"
X-IronPort-AV: E=Sophos;i="6.04,292,1695711600"; 
   d="scan'208";a="1107876246"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 20 Dec 2023 14:53:53 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rG5Rn-0007cS-31;
	Wed, 20 Dec 2023 22:53:51 +0000
Date: Thu, 21 Dec 2023 06:53:28 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 415c7451872b0d037760795edd3961eaa63276ea
Message-ID: <202312210625.jzfAlfj1-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 415c7451872b0d037760795edd3961eaa63276ea  md: Remove deprecated CONFIG_MD_FAULTY

elapsed time: 1454m

configs tested: 199
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                               defconfig   gcc  
arc                               allnoconfig   gcc  
arc                                 defconfig   gcc  
arc                     nsimosci_hs_defconfig   gcc  
arc                   randconfig-001-20231220   gcc  
arc                   randconfig-001-20231221   gcc  
arc                   randconfig-002-20231220   gcc  
arc                   randconfig-002-20231221   gcc  
arm                               allnoconfig   gcc  
arm                                 defconfig   clang
arm                      footbridge_defconfig   gcc  
arm                             pxa_defconfig   gcc  
arm                   randconfig-001-20231220   gcc  
arm                   randconfig-002-20231220   gcc  
arm                   randconfig-003-20231220   gcc  
arm                   randconfig-004-20231220   gcc  
arm                           u8500_defconfig   gcc  
arm64                            alldefconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20231220   gcc  
arm64                 randconfig-002-20231220   gcc  
arm64                 randconfig-003-20231220   gcc  
arm64                 randconfig-004-20231220   gcc  
csky                              allnoconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20231220   gcc  
csky                  randconfig-001-20231221   gcc  
csky                  randconfig-002-20231220   gcc  
csky                  randconfig-002-20231221   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
i386                             allmodconfig   clang
i386                              allnoconfig   clang
i386                             allyesconfig   clang
i386                                defconfig   gcc  
i386                  randconfig-011-20231220   clang
i386                  randconfig-011-20231221   gcc  
i386                  randconfig-012-20231220   clang
i386                  randconfig-012-20231221   gcc  
i386                  randconfig-013-20231220   clang
i386                  randconfig-013-20231221   gcc  
i386                  randconfig-014-20231220   clang
i386                  randconfig-014-20231221   gcc  
i386                  randconfig-015-20231220   clang
i386                  randconfig-015-20231221   gcc  
i386                  randconfig-016-20231220   clang
i386                  randconfig-016-20231221   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20231220   gcc  
loongarch             randconfig-001-20231221   gcc  
loongarch             randconfig-002-20231220   gcc  
loongarch             randconfig-002-20231221   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                         amcore_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                        m5272c3_defconfig   gcc  
m68k                       m5275evb_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   clang
mips                             allyesconfig   gcc  
mips                        bcm47xx_defconfig   gcc  
mips                         db1xxx_defconfig   gcc  
mips                     decstation_defconfig   gcc  
mips                      fuloong2e_defconfig   gcc  
mips                       rbtx49xx_defconfig   gcc  
mips                         rt305x_defconfig   gcc  
mips                           xway_defconfig   gcc  
nios2                            alldefconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20231220   gcc  
nios2                 randconfig-001-20231221   gcc  
nios2                 randconfig-002-20231220   gcc  
nios2                 randconfig-002-20231221   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc                       virt_defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20231220   gcc  
parisc                randconfig-001-20231221   gcc  
parisc                randconfig-002-20231220   gcc  
parisc                randconfig-002-20231221   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   clang
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                    amigaone_defconfig   gcc  
powerpc                     asp8347_defconfig   gcc  
powerpc                     ep8248e_defconfig   gcc  
powerpc                      mgcoge_defconfig   gcc  
powerpc                      pcm030_defconfig   gcc  
powerpc                     rainier_defconfig   gcc  
powerpc               randconfig-001-20231220   gcc  
powerpc               randconfig-002-20231220   gcc  
powerpc               randconfig-003-20231220   gcc  
powerpc64             randconfig-001-20231220   gcc  
powerpc64             randconfig-002-20231220   gcc  
powerpc64             randconfig-003-20231220   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   clang
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                 randconfig-001-20231220   gcc  
riscv                 randconfig-002-20231220   gcc  
riscv                          rv32_defconfig   clang
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20231221   gcc  
s390                  randconfig-002-20231221   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                         apsh4a3a_defconfig   gcc  
sh                                  defconfig   gcc  
sh                            hp6xx_defconfig   gcc  
sh                     magicpanelr2_defconfig   gcc  
sh                          polaris_defconfig   gcc  
sh                    randconfig-001-20231220   gcc  
sh                    randconfig-001-20231221   gcc  
sh                    randconfig-002-20231220   gcc  
sh                    randconfig-002-20231221   gcc  
sh                          rsk7201_defconfig   gcc  
sh                          rsk7203_defconfig   gcc  
sh                           se7343_defconfig   gcc  
sh                           se7780_defconfig   gcc  
sh                        sh7757lcr_defconfig   gcc  
sh                  sh7785lcr_32bit_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                            allyesconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20231220   gcc  
sparc64               randconfig-001-20231221   gcc  
sparc64               randconfig-002-20231220   gcc  
sparc64               randconfig-002-20231221   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                    randconfig-001-20231220   gcc  
um                    randconfig-002-20231220   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20231220   gcc  
x86_64       buildonly-randconfig-002-20231220   gcc  
x86_64       buildonly-randconfig-003-20231220   gcc  
x86_64       buildonly-randconfig-004-20231220   gcc  
x86_64       buildonly-randconfig-005-20231220   gcc  
x86_64       buildonly-randconfig-006-20231220   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                randconfig-011-20231220   gcc  
x86_64                randconfig-012-20231220   gcc  
x86_64                randconfig-013-20231220   gcc  
x86_64                randconfig-014-20231220   gcc  
x86_64                randconfig-015-20231220   gcc  
x86_64                randconfig-016-20231220   gcc  
x86_64                randconfig-071-20231220   gcc  
x86_64                randconfig-072-20231220   gcc  
x86_64                randconfig-073-20231220   gcc  
x86_64                randconfig-074-20231220   gcc  
x86_64                randconfig-075-20231220   gcc  
x86_64                randconfig-076-20231220   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                randconfig-001-20231220   gcc  
xtensa                randconfig-001-20231221   gcc  
xtensa                randconfig-002-20231220   gcc  
xtensa                randconfig-002-20231221   gcc  
xtensa                         virt_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
