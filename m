Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256C94DA1B
	for <linux-raid@vger.kernel.org>; Wed,  6 Mar 2024 15:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709738668; cv=none; b=IrYKAeoB+u0ZOd9VcqGmrJOg+7vIXmJiQGKN2eImU3k6RjC2IibRvs3GDNq1cxVMsLHwW9yRQHfw9JQB8COwiQwAxY9hYUzEi/xOxkzIIIFOwRdWoQ4EGh1naNgKSiTcCeFU1UlOSZKWvxY23X/n26XvxQ9xzhAGpC4SsIJfAEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709738668; c=relaxed/simple;
	bh=dSF1QkE7jnZNnwi2QFyxCFZE3RATrX7/k9zGmhzJc9g=;
	h=Date:From:To:Cc:Subject:Message-ID; b=bEFzvCIIyVwI97xWHgQV3DmSvcm02iAzE2KiJFBx9oj/tFuUI76/ExI8hJN8YKC961H/iXpOiogYFo5RWIXHEcdYAcXPJfUiUE6d6Nw3ntGHa41e5TrVnAjnE+P0dJ8784ISzxXAPjkKIww0CqsQY42GbHrMW4WXxMY3pAotyDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXgYd+41; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXgYd+41"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709738667; x=1741274667;
  h=date:from:to:cc:subject:message-id;
  bh=dSF1QkE7jnZNnwi2QFyxCFZE3RATrX7/k9zGmhzJc9g=;
  b=OXgYd+41tup4hgwdKC1sJnXLY4q3SEI+aaJ6eGXujeVj1ipPPsyqs3FE
   AfBGe2nHRXDSdnVL8IUL8k3Aq2YFSV1AJILEMg9RrJBvn38pnjXchr7fi
   DlwzLkUv2W/R02D1TXadBpC7Q3VYZnRM9c/WSMUPuXNPgaZT2JQof80Hf
   ThUwRzmJEtCeLeGSlAFiJjjEay+c059Q9bumPZHSwZUiOULwtMG06F6cX
   I1ldWEN1NO0H+ZNgflFV1AE8TOiIEd4KY18gLSUJLW0ISBlOf5oeDixvV
   wqGgTFCzfQCniIgHU/MFz/r2E2FWPVshsoHsTmzU45sy08oBqp/Au7Gv0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4470353"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="4470353"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 07:24:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="9657346"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 Mar 2024 07:24:25 -0800
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rht83-0004KZ-0x;
	Wed, 06 Mar 2024 15:24:23 +0000
Date: Wed, 06 Mar 2024 23:23:29 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.9] BUILD SUCCESS
 3a889fdce7e8927a7d81d11ca3d26608b3be1c31
Message-ID: <202403062326.aJoOVbsY-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.9
branch HEAD: 3a889fdce7e8927a7d81d11ca3d26608b3be1c31  Merge branch 'dmraid-fix-6.9' into md-6.9

elapsed time: 949m

configs tested: 156
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
arc                   randconfig-001-20240306   gcc  
arc                   randconfig-002-20240306   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                                 defconfig   clang
arm                   randconfig-001-20240306   gcc  
arm                           tegra_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   clang
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240306   gcc  
arm64                 randconfig-003-20240306   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240306   gcc  
csky                  randconfig-002-20240306   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
i386                             alldefconfig   gcc  
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240306   clang
i386         buildonly-randconfig-002-20240306   clang
i386         buildonly-randconfig-004-20240306   clang
i386         buildonly-randconfig-005-20240306   clang
i386                                defconfig   clang
i386                  randconfig-002-20240306   clang
i386                  randconfig-003-20240306   clang
i386                  randconfig-004-20240306   clang
i386                  randconfig-006-20240306   clang
i386                  randconfig-011-20240306   clang
i386                  randconfig-012-20240306   clang
i386                  randconfig-015-20240306   clang
i386                  randconfig-016-20240306   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240306   gcc  
loongarch             randconfig-002-20240306   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                       bvme6000_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5275evb_defconfig   gcc  
m68k                        mvme16x_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240306   gcc  
nios2                 randconfig-002-20240306   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                generic-64bit_defconfig   gcc  
parisc                randconfig-001-20240306   gcc  
parisc                randconfig-002-20240306   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc               randconfig-001-20240306   gcc  
powerpc               randconfig-002-20240306   gcc  
powerpc64             randconfig-001-20240306   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-002-20240306   gcc  
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-002-20240306   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                        dreamcast_defconfig   gcc  
sh                        edosk7705_defconfig   gcc  
sh                          lboxre2_defconfig   gcc  
sh                    randconfig-001-20240306   gcc  
sh                    randconfig-002-20240306   gcc  
sh                              ul2_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240306   gcc  
sparc64               randconfig-002-20240306   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                    randconfig-001-20240306   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240306   clang
x86_64       buildonly-randconfig-002-20240306   clang
x86_64       buildonly-randconfig-003-20240306   clang
x86_64       buildonly-randconfig-004-20240306   clang
x86_64       buildonly-randconfig-006-20240306   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240306   clang
x86_64                randconfig-002-20240306   clang
x86_64                randconfig-005-20240306   clang
x86_64                randconfig-006-20240306   clang
x86_64                randconfig-011-20240306   clang
x86_64                randconfig-012-20240306   clang
x86_64                randconfig-013-20240306   clang
x86_64                randconfig-015-20240306   clang
x86_64                randconfig-071-20240306   clang
x86_64                randconfig-072-20240306   clang
x86_64                randconfig-073-20240306   clang
x86_64                randconfig-074-20240306   clang
x86_64                randconfig-075-20240306   clang
x86_64                randconfig-076-20240306   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                randconfig-001-20240306   gcc  
xtensa                randconfig-002-20240306   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
