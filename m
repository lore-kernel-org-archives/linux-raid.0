Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676371C233C
	for <linux-raid@vger.kernel.org>; Fri, 16 Aug 2024 19:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837937; cv=none; b=b5OVD4WfW3CMSukBETV7IjVPioj0LHWqt9B0veFqcIcp+TGNyjysG73DAMG6MAWbChYRgQo7tdTzkMTgQ5bjHrZYcVqo9rB/cdYoQ+3gLmdvsrVBvtccRhnebMbXk3SCRqVKmj8dRKkVQxswipZtmKQLRlpgkeYSu8kNd5dipF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837937; c=relaxed/simple;
	bh=rFjRtGO8a8wncxLcc5CMcHWu8QNxB22WwZpALapX0kU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=L6jxym6RnP20yUphWGtO7xu5bRMcnCvbiIhmdD1z+ijRQNRMsXGoYBCCVobYDQ3r7VvzBAfa8HqAeB22Z4zMEj//D6CRc2SfFw2YW6GBXh9ngT2NZ1LgJ/mUrwXHRzDxI7bA32tPSPLNBQiGDFKPZv2uRULNfp4TTLhFelIDBGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AcbLT94P; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AcbLT94P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723837935; x=1755373935;
  h=date:from:to:cc:subject:message-id;
  bh=rFjRtGO8a8wncxLcc5CMcHWu8QNxB22WwZpALapX0kU=;
  b=AcbLT94Pvx10beaO5QpuVZi1YF9WK6Ti5/s1XTUPNh3h8Y2LH9cMzTem
   ry+NkPpxLJLajvpJ7dvFYqCioDmkf2vJEWHtcFrH1pbSHFm4jEOP8NaeI
   g/walJ6E+z7mpRrCcCrCAGtd55o436B+wEWGavIB+A8C/sDuBOFGuwwCT
   TS5Kfi6i8ctxl/1oLCHGUUJPhD1nsx2PcaftjYUdaqTuec+XHh+RtBu6Y
   56uKePPi899cbkf9fWU6Lz3iHEOLt+hQ7aR1EVW5DhEUrz+P83+RGe8x0
   BOUMgl9bbQnfXq/VfynM3nGN3G7LH4TCoDUhaJ16E2+DoquQal9TONyO8
   Q==;
X-CSE-ConnectionGUID: 39E++jq+Qu+FfyRsyXXSgA==
X-CSE-MsgGUID: FzusPRDJRASv8euyKoczrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="33556601"
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="33556601"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 12:52:14 -0700
X-CSE-ConnectionGUID: XJu87VmsRr+N7llDvamXPw==
X-CSE-MsgGUID: tdChHAUwQhGxzeVmLRzffQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="60042120"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 16 Aug 2024 12:52:14 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sf2zb-0006sZ-0b;
	Fri, 16 Aug 2024 19:52:11 +0000
Date: Sat, 17 Aug 2024 03:52:01 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.11] BUILD SUCCESS
 c916ca35308d3187c9928664f9be249b22a3a701
Message-ID: <202408170359.0G8Y6gpf-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.11
branch HEAD: c916ca35308d3187c9928664f9be249b22a3a701  md/raid1: Fix data corruption for degraded array with slow disk

elapsed time: 1385m

configs tested: 191
configs skipped: 17

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc-13.2.0
alpha                             allnoconfig   gcc-13.3.0
alpha                            allyesconfig   gcc-13.3.0
alpha                               defconfig   gcc-13.2.0
arc                              allmodconfig   gcc-13.2.0
arc                               allnoconfig   gcc-13.2.0
arc                              allyesconfig   gcc-13.2.0
arc                                 defconfig   gcc-13.2.0
arc                   randconfig-001-20240816   gcc-13.2.0
arc                   randconfig-002-20240816   gcc-13.2.0
arm                              allmodconfig   gcc-13.2.0
arm                              allmodconfig   gcc-14.1.0
arm                               allnoconfig   clang-20
arm                               allnoconfig   gcc-13.2.0
arm                              allyesconfig   gcc-13.2.0
arm                              allyesconfig   gcc-14.1.0
arm                          ixp4xx_defconfig   gcc-14.1.0
arm                   randconfig-001-20240816   gcc-13.2.0
arm                   randconfig-002-20240816   gcc-13.2.0
arm                   randconfig-003-20240816   gcc-13.2.0
arm                           tegra_defconfig   gcc-14.1.0
arm                    vt8500_v6_v7_defconfig   gcc-14.1.0
arm64                            allmodconfig   clang-20
arm64                             allnoconfig   gcc-13.2.0
arm64                             allnoconfig   gcc-14.1.0
arm64                               defconfig   gcc-13.2.0
csky                              allnoconfig   gcc-13.2.0
csky                              allnoconfig   gcc-14.1.0
csky                                defconfig   gcc-13.2.0
csky                  randconfig-001-20240816   gcc-13.2.0
csky                  randconfig-002-20240816   gcc-13.2.0
hexagon                          allmodconfig   clang-20
hexagon                           allnoconfig   clang-20
hexagon                          allyesconfig   clang-20
i386                             allmodconfig   clang-18
i386                             allmodconfig   gcc-12
i386                              allnoconfig   clang-18
i386                              allnoconfig   gcc-12
i386                             allyesconfig   clang-18
i386                             allyesconfig   gcc-12
i386         buildonly-randconfig-001-20240816   gcc-12
i386         buildonly-randconfig-002-20240816   clang-18
i386         buildonly-randconfig-002-20240816   gcc-12
i386         buildonly-randconfig-003-20240816   clang-18
i386         buildonly-randconfig-003-20240816   gcc-12
i386         buildonly-randconfig-004-20240816   clang-18
i386         buildonly-randconfig-005-20240816   gcc-11
i386         buildonly-randconfig-005-20240816   gcc-12
i386         buildonly-randconfig-006-20240816   gcc-12
i386                                defconfig   clang-18
i386                  randconfig-001-20240816   clang-18
i386                  randconfig-002-20240816   gcc-12
i386                  randconfig-003-20240816   gcc-11
i386                  randconfig-003-20240816   gcc-12
i386                  randconfig-004-20240816   gcc-12
i386                  randconfig-005-20240816   clang-18
i386                  randconfig-006-20240816   gcc-11
i386                  randconfig-006-20240816   gcc-12
i386                  randconfig-011-20240816   gcc-12
i386                  randconfig-012-20240816   clang-18
i386                  randconfig-012-20240816   gcc-12
i386                  randconfig-013-20240816   clang-18
i386                  randconfig-013-20240816   gcc-12
i386                  randconfig-014-20240816   gcc-12
i386                  randconfig-015-20240816   gcc-12
i386                  randconfig-016-20240816   gcc-12
loongarch                        allmodconfig   gcc-14.1.0
loongarch                         allnoconfig   gcc-13.2.0
loongarch                         allnoconfig   gcc-14.1.0
loongarch                           defconfig   gcc-13.2.0
loongarch             randconfig-001-20240816   gcc-13.2.0
loongarch             randconfig-002-20240816   gcc-13.2.0
m68k                             allmodconfig   gcc-14.1.0
m68k                              allnoconfig   gcc-13.2.0
m68k                              allnoconfig   gcc-14.1.0
m68k                             allyesconfig   gcc-14.1.0
m68k                                defconfig   gcc-13.2.0
m68k                            mac_defconfig   gcc-14.1.0
microblaze                       allmodconfig   gcc-14.1.0
microblaze                        allnoconfig   gcc-13.2.0
microblaze                        allnoconfig   gcc-14.1.0
microblaze                       allyesconfig   gcc-14.1.0
microblaze                          defconfig   gcc-13.2.0
mips                              allnoconfig   gcc-13.2.0
mips                              allnoconfig   gcc-14.1.0
mips                           ci20_defconfig   gcc-14.1.0
mips                           ip22_defconfig   gcc-14.1.0
mips                           mtx1_defconfig   gcc-14.1.0
mips                        omega2p_defconfig   gcc-14.1.0
nios2                            alldefconfig   gcc-14.1.0
nios2                             allnoconfig   gcc-13.2.0
nios2                             allnoconfig   gcc-14.1.0
nios2                               defconfig   gcc-13.2.0
nios2                 randconfig-001-20240816   gcc-13.2.0
nios2                 randconfig-002-20240816   gcc-13.2.0
openrisc                          allnoconfig   gcc-14.1.0
openrisc                         allyesconfig   gcc-14.1.0
openrisc                            defconfig   gcc-14.1.0
parisc                           allmodconfig   gcc-14.1.0
parisc                            allnoconfig   gcc-14.1.0
parisc                           allyesconfig   gcc-14.1.0
parisc                              defconfig   gcc-14.1.0
parisc                randconfig-001-20240816   gcc-13.2.0
parisc                randconfig-002-20240816   gcc-13.2.0
parisc64                            defconfig   gcc-13.2.0
powerpc                          allmodconfig   gcc-14.1.0
powerpc                           allnoconfig   gcc-14.1.0
powerpc                          allyesconfig   clang-20
powerpc                          allyesconfig   gcc-14.1.0
powerpc                   bluestone_defconfig   gcc-14.1.0
powerpc                    gamecube_defconfig   gcc-14.1.0
powerpc                      pcm030_defconfig   gcc-14.1.0
powerpc               randconfig-002-20240816   gcc-13.2.0
powerpc                     tqm5200_defconfig   gcc-14.1.0
powerpc                        warp_defconfig   gcc-14.1.0
powerpc64             randconfig-001-20240816   gcc-13.2.0
powerpc64             randconfig-002-20240816   gcc-13.2.0
powerpc64             randconfig-003-20240816   gcc-13.2.0
riscv                            allmodconfig   clang-20
riscv                            allmodconfig   gcc-14.1.0
riscv                             allnoconfig   gcc-14.1.0
riscv                            allyesconfig   clang-20
riscv                            allyesconfig   gcc-14.1.0
riscv                               defconfig   gcc-14.1.0
riscv                 randconfig-001-20240816   gcc-13.2.0
riscv                 randconfig-002-20240816   gcc-13.2.0
s390                             allmodconfig   clang-20
s390                              allnoconfig   clang-20
s390                              allnoconfig   gcc-14.1.0
s390                             allyesconfig   clang-20
s390                             allyesconfig   gcc-14.1.0
s390                                defconfig   gcc-14.1.0
s390                  randconfig-001-20240816   gcc-13.2.0
s390                  randconfig-002-20240816   gcc-13.2.0
sh                               allmodconfig   gcc-14.1.0
sh                                allnoconfig   gcc-13.2.0
sh                                allnoconfig   gcc-14.1.0
sh                               allyesconfig   gcc-14.1.0
sh                                  defconfig   gcc-14.1.0
sh                    randconfig-001-20240816   gcc-13.2.0
sh                    randconfig-002-20240816   gcc-13.2.0
sh                   sh7770_generic_defconfig   gcc-14.1.0
sh                        sh7785lcr_defconfig   gcc-14.1.0
sh                             shx3_defconfig   gcc-14.1.0
sparc                            allmodconfig   gcc-14.1.0
sparc64                             defconfig   gcc-14.1.0
sparc64               randconfig-001-20240816   gcc-13.2.0
sparc64               randconfig-002-20240816   gcc-13.2.0
um                               allmodconfig   clang-20
um                               allmodconfig   gcc-13.3.0
um                                allnoconfig   clang-17
um                               allyesconfig   gcc-12
um                               allyesconfig   gcc-13.3.0
um                                  defconfig   gcc-14.1.0
um                             i386_defconfig   gcc-14.1.0
um                    randconfig-001-20240816   gcc-13.2.0
um                    randconfig-002-20240816   gcc-13.2.0
um                           x86_64_defconfig   gcc-14.1.0
x86_64                            allnoconfig   clang-18
x86_64                           allyesconfig   clang-18
x86_64       buildonly-randconfig-001-20240816   clang-18
x86_64       buildonly-randconfig-002-20240816   clang-18
x86_64       buildonly-randconfig-003-20240816   clang-18
x86_64       buildonly-randconfig-004-20240816   clang-18
x86_64       buildonly-randconfig-005-20240816   clang-18
x86_64       buildonly-randconfig-006-20240816   clang-18
x86_64                              defconfig   clang-18
x86_64                              defconfig   gcc-11
x86_64                randconfig-001-20240816   clang-18
x86_64                randconfig-002-20240816   clang-18
x86_64                randconfig-003-20240816   clang-18
x86_64                randconfig-004-20240816   clang-18
x86_64                randconfig-005-20240816   clang-18
x86_64                randconfig-006-20240816   clang-18
x86_64                randconfig-011-20240816   clang-18
x86_64                randconfig-012-20240816   clang-18
x86_64                randconfig-013-20240816   clang-18
x86_64                randconfig-014-20240816   clang-18
x86_64                randconfig-015-20240816   clang-18
x86_64                randconfig-016-20240816   clang-18
x86_64                randconfig-071-20240816   clang-18
x86_64                randconfig-072-20240816   clang-18
x86_64                randconfig-073-20240816   clang-18
x86_64                randconfig-074-20240816   clang-18
x86_64                randconfig-075-20240816   clang-18
x86_64                randconfig-076-20240816   clang-18
x86_64                          rhel-8.3-rust   clang-18
xtensa                            allnoconfig   gcc-13.2.0
xtensa                            allnoconfig   gcc-14.1.0
xtensa                randconfig-001-20240816   gcc-13.2.0
xtensa                randconfig-002-20240816   gcc-13.2.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
