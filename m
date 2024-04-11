Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4265102E
	for <linux-raid@vger.kernel.org>; Thu, 11 Apr 2024 18:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712858975; cv=none; b=G6L3fEmQ750LEgMi1qafoG9JrJgwz3cuN79MsqMowVMEmGbyjmrj59ZNGQF6PiB5A7uCEEygeBW8Zetld7izG6joAM+m/AwdhAtFVX8Ta5KC+hePLp2cANE9hWfi5jMerWSzWBEBC9tqa48BKV5KpqnPiGn6ghWhNkU39yGoRvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712858975; c=relaxed/simple;
	bh=fZwuiR0P7uGs22EWkRbUEdgipHaFf3Zy/vL4/0ncQp4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=TBc/PJ1I+9ktGkOPsS1zTc1ORizUmvcqY6Thad4hGxbWfLOqQIhYY6c9aQDFQ25kMj8mI/bWwmSKmy5+QIa7l2EhUUfj431ALzT2hIswULKhuFe3i+MeQnzs/Cli6jyby6HjH7kWF8N035uvdhIDj0bheY/TGEyX9/AKCn2AxUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W9KxRymD; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W9KxRymD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712858972; x=1744394972;
  h=date:from:to:cc:subject:message-id;
  bh=fZwuiR0P7uGs22EWkRbUEdgipHaFf3Zy/vL4/0ncQp4=;
  b=W9KxRymDqbP/KOMjIoLXASFpW1d/oPqTeaE1pZClDJarcewyPSV6X5sX
   lOC15iyn3dSY3iD0fdjiH72COYA/yV2nO+2WpzizkjS5383pY9yqmcB7g
   1cs2m+psStCD2BpbUloa+uzNuJabWojz6pDPylyec6TrA5vKAizjvF1aS
   yiZ2rz1METGAvsPBzOwpBeMdDRSeY9xZIJAHU5iTydq++MUqKaqu+0iOP
   84QG05yaGf5+qCihAyGVH0TJ5paISyJ1H2+jrtxlDUyTiuGfwJEBKbtAo
   peJR9+7vFlMRFwHJfV8r/40cZ4g5D9Ycbt2snbL1dtY9dnBRldJUIlwBj
   Q==;
X-CSE-ConnectionGUID: +3jk7FO8QIm5eIsysYazkA==
X-CSE-MsgGUID: j96c2l1nRkuxI+D5dqVCWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="11257495"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="11257495"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 11:09:22 -0700
X-CSE-ConnectionGUID: uTjjdVehTKyoYIALkinncw==
X-CSE-MsgGUID: hn8aAQWXTDiDYAmiUkNhgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="51931925"
Received: from lkp-server01.sh.intel.com (HELO e61807b1d151) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 11 Apr 2024 11:09:21 -0700
Received: from kbuild by e61807b1d151 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ruyrO-0008rp-1P;
	Thu, 11 Apr 2024 18:09:18 +0000
Date: Fri, 12 Apr 2024 02:09:15 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.10] BUILD SUCCESS
 9d1110f99c253ccef82e480bfe9f38a12eb797a7
Message-ID: <202404120213.hu2iO5vy-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.10
branch HEAD: 9d1110f99c253ccef82e480bfe9f38a12eb797a7  md: don't account sync_io if iostats of the disk is disabled

elapsed time: 1218m

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
arc                         haps_hs_defconfig   gcc  
arc                   randconfig-001-20240411   gcc  
arc                   randconfig-002-20240411   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                                 defconfig   clang
arm                           omap1_defconfig   gcc  
arm                   randconfig-001-20240411   gcc  
arm                   randconfig-002-20240411   gcc  
arm                   randconfig-004-20240411   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   clang
arm64                               defconfig   gcc  
arm64                 randconfig-002-20240411   gcc  
arm64                 randconfig-003-20240411   gcc  
arm64                 randconfig-004-20240411   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240411   gcc  
csky                  randconfig-002-20240411   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240411   clang
i386         buildonly-randconfig-002-20240411   clang
i386         buildonly-randconfig-003-20240411   clang
i386         buildonly-randconfig-004-20240411   clang
i386         buildonly-randconfig-005-20240411   clang
i386         buildonly-randconfig-006-20240411   clang
i386                                defconfig   clang
i386                  randconfig-001-20240411   gcc  
i386                  randconfig-002-20240411   gcc  
i386                  randconfig-003-20240411   clang
i386                  randconfig-004-20240411   clang
i386                  randconfig-005-20240411   gcc  
i386                  randconfig-006-20240411   clang
i386                  randconfig-011-20240411   clang
i386                  randconfig-012-20240411   gcc  
i386                  randconfig-013-20240411   gcc  
i386                  randconfig-014-20240411   gcc  
i386                  randconfig-015-20240411   clang
i386                  randconfig-016-20240411   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240411   gcc  
loongarch             randconfig-002-20240411   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                            mac_defconfig   gcc  
m68k                           sun3_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                         bigsur_defconfig   gcc  
mips                      fuloong2e_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240411   gcc  
nios2                 randconfig-002-20240411   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                generic-32bit_defconfig   gcc  
parisc                randconfig-001-20240411   gcc  
parisc                randconfig-002-20240411   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc               randconfig-001-20240411   gcc  
powerpc               randconfig-003-20240411   gcc  
powerpc64             randconfig-002-20240411   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-002-20240411   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                         ecovec24_defconfig   gcc  
sh                    randconfig-001-20240411   gcc  
sh                    randconfig-002-20240411   gcc  
sh                           se7206_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240411   gcc  
sparc64               randconfig-002-20240411   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                    randconfig-001-20240411   gcc  
um                    randconfig-002-20240411   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240411   gcc  
x86_64       buildonly-randconfig-004-20240411   gcc  
x86_64                              defconfig   gcc  
x86_64                randconfig-003-20240411   gcc  
x86_64                randconfig-005-20240411   gcc  
x86_64                randconfig-012-20240411   gcc  
x86_64                randconfig-014-20240411   gcc  
x86_64                randconfig-015-20240411   gcc  
x86_64                randconfig-016-20240411   gcc  
x86_64                randconfig-074-20240411   gcc  
x86_64                randconfig-075-20240411   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                randconfig-001-20240411   gcc  
xtensa                randconfig-002-20240411   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
