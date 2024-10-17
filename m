Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD07A1DD540
	for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729173394; cv=none; b=UB6765SE/9Ob/jGEhQtJ7oZcszwK/q/pRd5XAUCuNjub6XejAaE6mYqTKP2a0yzfOTL/8dS10lyHQ944Nd/TQmzbr0se/q6vViBgg3BFmdtVpNs1CcXyqL7eQYdjtf9EKdtFKbprYDJ2J0lqCt8MIO5Vt9Y1IUr7PLvYbBLkj9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729173394; c=relaxed/simple;
	bh=j4I5zE1ncufFmEV2tjBOcmzoV9PVwtCJWeODejYJGU8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=V9lfHpEYVML8UrBGUOrLJcL1FtukwwKXY1SDk6o3BZ7ffePSPrW5cK2xe7BH5ZB57R8oAhaqQ7PnMxPuGPjuqeBjfoDOyfIRF5pUae2fdhKbTsIbPwFe5f/Fh2Vv5pTROIsFhoqfm1VmoKwUBOKpZUFUIhws9fg3sLjOXACIyNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RdyXdrlt; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RdyXdrlt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729173389; x=1760709389;
  h=date:from:to:cc:subject:message-id;
  bh=j4I5zE1ncufFmEV2tjBOcmzoV9PVwtCJWeODejYJGU8=;
  b=RdyXdrlt2CEAFSxe2haLE2wK1tQ6S/WUfv+QzSTjmfiKNnVsz6xiquLZ
   GBSH2En3n9SsfrH4JEw+7hf+zgAy09wGwHPcXc9IpCbP7QZ4JGN4JCyWn
   r9d7qZgp5EqtP07vmuphtX9JhceURmUGg4PmoyVmu/80QD7Iy1mNtKuFA
   C9NlkM5aiBzb//vRXVfLcI2KgVOXPq74QGwcIJzUgIX6s6D+/+OTfWM6V
   m3pMo4iIBWpLRB6pCwczjvpqaNjaM/J4TyrbcoMPThtX8i0pbuP0DRPL1
   ZEmhbIH37SUyYGdUZYkES0lgTe/3QXU/7oGiC+auhbqvpjpvEj0mM6euu
   Q==;
X-CSE-ConnectionGUID: Y4eg1KQmTMqAW2BGEeFRLw==
X-CSE-MsgGUID: ovr8/XgyRM2FLHzWTnJtcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="28541716"
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="28541716"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 06:56:27 -0700
X-CSE-ConnectionGUID: IW8X067yQg+805zB+d4uZw==
X-CSE-MsgGUID: igohitNdQvCPZTylmPZ1dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="78577537"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 17 Oct 2024 06:56:26 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t1QzI-000MQl-0F;
	Thu, 17 Oct 2024 13:56:24 +0000
Date: Thu, 17 Oct 2024 21:56:16 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.13] BUILD SUCCESS
 1936f2e6981297621deed9afcdc9063c1964fc5b
Message-ID: <202410172108.mK4Rgteo-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.13
branch HEAD: 1936f2e6981297621deed9afcdc9063c1964fc5b  block: fix ordering between checking BLK_MQ_S_STOPPED request adding

elapsed time: 1180m

configs tested: 97
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-14.1.0
alpha                            allyesconfig    clang-20
arc                              allmodconfig    clang-20
arc                               allnoconfig    gcc-14.1.0
arc                              allyesconfig    clang-20
arc                           tb10x_defconfig    clang-20
arm                              allmodconfig    clang-20
arm                               allnoconfig    gcc-14.1.0
arm                              allyesconfig    clang-20
arm                         bcm2835_defconfig    clang-20
arm                      integrator_defconfig    clang-20
arm                   milbeaut_m10v_defconfig    clang-20
arm                        mvebu_v5_defconfig    clang-20
arm                        spear3xx_defconfig    clang-20
arm64                            allmodconfig    clang-20
arm64                             allnoconfig    gcc-14.1.0
csky                              allnoconfig    gcc-14.1.0
hexagon                          allmodconfig    clang-20
hexagon                           allnoconfig    gcc-14.1.0
hexagon                          allyesconfig    clang-20
i386                             allmodconfig    clang-18
i386                              allnoconfig    clang-18
i386                             allyesconfig    clang-18
i386        buildonly-randconfig-001-20241017    clang-18
i386        buildonly-randconfig-002-20241017    clang-18
i386        buildonly-randconfig-003-20241017    clang-18
i386        buildonly-randconfig-004-20241017    clang-18
i386        buildonly-randconfig-005-20241017    clang-18
i386        buildonly-randconfig-006-20241017    clang-18
i386                                defconfig    clang-18
i386                  randconfig-001-20241017    clang-18
i386                  randconfig-002-20241017    clang-18
i386                  randconfig-003-20241017    clang-18
i386                  randconfig-004-20241017    clang-18
i386                  randconfig-005-20241017    clang-18
i386                  randconfig-006-20241017    clang-18
i386                  randconfig-011-20241017    clang-18
i386                  randconfig-012-20241017    clang-18
i386                  randconfig-013-20241017    clang-18
i386                  randconfig-014-20241017    clang-18
i386                  randconfig-015-20241017    clang-18
i386                  randconfig-016-20241017    clang-18
loongarch                        allmodconfig    gcc-14.1.0
loongarch                         allnoconfig    gcc-14.1.0
m68k                             allmodconfig    gcc-14.1.0
m68k                              allnoconfig    gcc-14.1.0
m68k                             allyesconfig    gcc-14.1.0
microblaze                       allmodconfig    gcc-14.1.0
microblaze                        allnoconfig    gcc-14.1.0
microblaze                       allyesconfig    gcc-14.1.0
mips                              allnoconfig    gcc-14.1.0
mips                           mtx1_defconfig    clang-20
nios2                             allnoconfig    gcc-14.1.0
openrisc                          allnoconfig    clang-20
openrisc                         allyesconfig    gcc-14.1.0
openrisc                            defconfig    gcc-12
parisc                           allmodconfig    gcc-14.1.0
parisc                            allnoconfig    clang-20
parisc                           allyesconfig    gcc-14.1.0
parisc                              defconfig    gcc-12
powerpc                          allmodconfig    gcc-14.1.0
powerpc                           allnoconfig    clang-20
powerpc                          allyesconfig    gcc-14.1.0
powerpc                       maple_defconfig    clang-20
powerpc                      mgcoge_defconfig    clang-20
powerpc                     taishan_defconfig    clang-20
riscv                            allmodconfig    gcc-14.1.0
riscv                             allnoconfig    clang-20
riscv                            allyesconfig    gcc-14.1.0
riscv                               defconfig    gcc-12
s390                             allmodconfig    gcc-14.1.0
s390                              allnoconfig    clang-20
s390                             allyesconfig    gcc-14.1.0
s390                          debug_defconfig    clang-20
s390                                defconfig    gcc-12
sh                               allmodconfig    gcc-14.1.0
sh                                allnoconfig    gcc-14.1.0
sh                               allyesconfig    gcc-14.1.0
sh                                  defconfig    gcc-12
sh                             espt_defconfig    clang-20
sh                            migor_defconfig    clang-20
sh                   sh7770_generic_defconfig    clang-20
sparc                            allmodconfig    gcc-14.1.0
sparc                       sparc32_defconfig    clang-20
sparc64                             defconfig    gcc-12
um                               allmodconfig    clang-20
um                                allnoconfig    clang-20
um                               allyesconfig    clang-20
um                                  defconfig    gcc-12
um                             i386_defconfig    gcc-12
um                           x86_64_defconfig    gcc-12
x86_64                            allnoconfig    clang-18
x86_64                           allyesconfig    clang-18
x86_64                              defconfig    clang-18
x86_64                                  kexec    gcc-12
x86_64                               rhel-8.3    gcc-12
xtensa                            allnoconfig    gcc-14.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
