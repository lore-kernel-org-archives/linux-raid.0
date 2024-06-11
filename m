Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EB140849
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 21:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718142371; cv=none; b=YwA2hj4QSdlphlTDpy+60uV8FZy+AekVWlQe5YzfyTY2GCCxLowqaOFPpFbfvORK13yP2g+lBqh/miYEb/KJyWctoCPj1RrZDTtsHnVkVE8IfLXgf6CBrfekSJvK/Mgn6vENME4Wj1u4j0Pnrfajq/mxOxP+o2VRu2Q8vMUGals=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718142371; c=relaxed/simple;
	bh=FOCwi41rJh52gFE1j8MFMeGZehjk1sF5Qi0HhGEc7Pc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=svO6NDcuVJ0t3CvosOL07m0pv4uvU4qJXFYmhsuz4HRAmuikZwyp227gwncT3iXlu4zkXGFHVerEfa+IzBwCQ2LFwSyqMQiSUzw7eGsdBq0yZQvrxz9oU6NlAaaqfDtzOTGog3P8CWUgLmZ5X9kALV+u4vyyph7CMNbIbUoVUWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I+a1SCPm; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I+a1SCPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718142370; x=1749678370;
  h=date:from:to:cc:subject:message-id;
  bh=FOCwi41rJh52gFE1j8MFMeGZehjk1sF5Qi0HhGEc7Pc=;
  b=I+a1SCPmAKELUlaHM4geXajEG2gnRHgqZ1v9OnLwc+FYh+cIduTwdw9I
   w+Bd2ic8JC0gq6GqwC+EahLoVkyk+M1fX5VbXaymqRYqyvvdvCFl5Ox9h
   fvyn/WdkeUvpD+K3bSeu57ORTXFGxEiI4wMVBJlkS4bXVqbZHCLkwNY9K
   t7043Y6p9SBJCVZ34RjZtFI0wPCNI76+Tvm+E6d5YvvYcRDNYFHauTeD0
   2mVcLFCggP7E4KKPSyxM3l7poLzyJnqdKLnrp5SW7KHRq36qoD/N+KYz6
   ZyKFkizS8bXyuV6CHj8E6zlo/DuAm0Vd17qeQRwnpUoY57MkykCFNfp1o
   w==;
X-CSE-ConnectionGUID: H0CQ6lS4QRehHzRhpAnhGg==
X-CSE-MsgGUID: i04FvXaSSiSieXdDxgLjWg==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14841603"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14841603"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 14:46:10 -0700
X-CSE-ConnectionGUID: MGn8oVTgRSK0ydZS/u90sQ==
X-CSE-MsgGUID: 6RlI6GfTRGaXjcy/pQJhDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="39631408"
Received: from lkp-server01.sh.intel.com (HELO 628d7d8b9fc6) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 11 Jun 2024 14:46:08 -0700
Received: from kbuild by 628d7d8b9fc6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sH9Je-0000v8-12;
	Tue, 11 Jun 2024 21:46:06 +0000
Date: Wed, 12 Jun 2024 05:46:05 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.11] BUILD SUCCESS
 17f91ac0843b50462a9c9c8f18df962338bd3db2
Message-ID: <202406120503.t4h7c21E-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.11
branch HEAD: 17f91ac0843b50462a9c9c8f18df962338bd3db2  md/raid1: don't free conf on raid0_run failure

elapsed time: 1449m

configs tested: 91
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc  
alpha                             allnoconfig   gcc-13.2.0
alpha                            allyesconfig   gcc  
alpha                            allyesconfig   gcc-13.2.0
alpha                               defconfig   gcc  
alpha                               defconfig   gcc-13.2.0
arc                               allnoconfig   gcc  
arc                               allnoconfig   gcc-13.2.0
arc                              allyesconfig   gcc-13.2.0
arc                                 defconfig   gcc  
arc                                 defconfig   gcc-13.2.0
arm                               allnoconfig   clang
arm                                 defconfig   clang
arm64                             allnoconfig   gcc  
arm64                             allnoconfig   gcc-13.2.0
arm64                               defconfig   gcc  
arm64                               defconfig   gcc-13.2.0
csky                              allnoconfig   gcc  
csky                              allnoconfig   gcc-13.2.0
csky                                defconfig   gcc  
csky                                defconfig   gcc-13.2.0
hexagon                          allmodconfig   clang-19
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang-19
hexagon                             defconfig   clang
i386         buildonly-randconfig-003-20240611   clang
i386                  randconfig-001-20240611   clang
i386                  randconfig-004-20240611   clang
i386                  randconfig-006-20240611   clang
i386                  randconfig-011-20240611   clang
i386                  randconfig-013-20240611   clang
i386                  randconfig-015-20240611   clang
i386                  randconfig-016-20240611   clang
loongarch                        allmodconfig   gcc-13.2.0
loongarch                         allnoconfig   gcc  
loongarch                         allnoconfig   gcc-13.2.0
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc-13.2.0
m68k                              allnoconfig   gcc  
m68k                              allnoconfig   gcc-13.2.0
m68k                             allyesconfig   gcc-13.2.0
m68k                                defconfig   gcc  
microblaze                       allmodconfig   gcc-13.2.0
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc-13.2.0
microblaze                          defconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc-13.2.0
nios2                            allmodconfig   gcc-13.2.0
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc-13.2.0
nios2                               defconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                          allnoconfig   gcc-13.2.0
openrisc                            defconfig   gcc  
openrisc                            defconfig   gcc-13.2.0
parisc                            allnoconfig   gcc  
parisc                            allnoconfig   gcc-13.2.0
parisc                              defconfig   gcc  
parisc                              defconfig   gcc-13.2.0
parisc64                            defconfig   gcc  
parisc64                            defconfig   gcc-13.2.0
powerpc                           allnoconfig   gcc  
powerpc                           allnoconfig   gcc-13.2.0
riscv                             allnoconfig   gcc  
riscv                             allnoconfig   gcc-13.2.0
riscv                               defconfig   clang
s390                             allmodconfig   clang-19
s390                              allnoconfig   clang
s390                             allyesconfig   gcc-13.2.0
s390                                defconfig   clang
sh                               allmodconfig   gcc-13.2.0
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc-13.2.0
sh                                  defconfig   gcc  
sparc                            allmodconfig   gcc-13.2.0
sparc                             allnoconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc-13.2.0
sparc64                          allyesconfig   gcc-13.2.0
sparc64                             defconfig   gcc  
um                               allmodconfig   clang-19
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                               allyesconfig   gcc-13
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang-18
x86_64                              defconfig   gcc-13
xtensa                            allnoconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
