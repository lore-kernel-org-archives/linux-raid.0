Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1907073457
	for <linux-raid@vger.kernel.org>; Sat, 13 Jul 2024 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720887638; cv=none; b=ovonydYosXvA4i3PmS+x5A+KoKd8d0N9KBsY7YnkGwIpnJi4OuodPS5O+vGuhGjcPUDEd9dBA9vUQGTUAHEre0Q0weMa2LaVXoG80jrAJaPQHMP4bnHCSEW946RA7yajfEXX2j81qBEKZtNCR3541d1Qro96IiLHtkQR9VNm/iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720887638; c=relaxed/simple;
	bh=/OwdM/pBjqdJssWIUj715g7L7aF66i/rHFA587Pe30o=;
	h=Date:From:To:Cc:Subject:Message-ID; b=EKH6Wrhum/rtVtl4UazNuUsduEV3fbhpZNcTp8qc+yTGwmv1Ic+OZyjfzCkSZVO30zeYJLK+k7bbH3QEJ7jDE3Gnrt71go47TUpNLCjxCYAm3d48lApNzrv9WdyFBEP/hx1f/WJnH3bDVHJ1atuDe5eA7ks5sg5Xcdfrs1LYlIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CAURYbVb; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CAURYbVb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720887637; x=1752423637;
  h=date:from:to:cc:subject:message-id;
  bh=/OwdM/pBjqdJssWIUj715g7L7aF66i/rHFA587Pe30o=;
  b=CAURYbVbtgkIkrjYhXa3cnyrVzvkQbeTZyJ1y8zMDJRljMt/gzz+Zi8F
   cuqfnJcwjw2vY+/x4temwBabdZ5RO8U7iEbALYj4zhTCAEt2oHnPTgSFS
   yjgFklaqelPtL+PbUmxLvXkdoQsArnIBbQpthpkeV+XVqaazGx9qOCFKc
   9JfqAZ5W33zZVdWcA3qXvWtPwwUiALSC7lRqdlVZvEB+oycZPdqjTXIhe
   1noJH4Zw7nJ2e41B4BNS+d92Tlto0e11NU/e4hzCOsOwc9bvQ1hGNhPa2
   bsBN1FD4C0d76i2SfpI6vsldie5gUfgetbn/j4kPmtyuuRYUUPl8pfruY
   Q==;
X-CSE-ConnectionGUID: 8X3cVoiXR8iJAvVSGqNOmQ==
X-CSE-MsgGUID: Eqy50EDiQaKRN6roYnmlsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11132"; a="18130738"
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="18130738"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2024 09:20:36 -0700
X-CSE-ConnectionGUID: igtXAj7MTVebS7lTAVE9bQ==
X-CSE-MsgGUID: B/YJMOzARcWOcUfOIH+P1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="49147467"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 13 Jul 2024 09:20:34 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sSfU7-000cU6-33;
	Sat, 13 Jul 2024 16:20:31 +0000
Date: Sun, 14 Jul 2024 00:19:45 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.11] BUILD SUCCESS
 36a5c03f232719eb4e2d925f4d584e09cfaf372c
Message-ID: <202407140042.CIB5Iq4S-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.11
branch HEAD: 36a5c03f232719eb4e2d925f4d584e09cfaf372c  md/raid1: set max_sectors during early return from choose_slow_rdev()

elapsed time: 1451m

configs tested: 151
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc-13.3.0
alpha                            allyesconfig   gcc-13.3.0
arc                              allmodconfig   gcc-13.2.0
arc                               allnoconfig   gcc-13.2.0
arc                              allyesconfig   gcc-13.2.0
arc                          axs103_defconfig   gcc-13.2.0
arc                   randconfig-001-20240713   gcc-13.2.0
arc                   randconfig-002-20240713   gcc-13.2.0
arm                              allmodconfig   gcc-14.1.0
arm                               allnoconfig   clang-19
arm                              allyesconfig   gcc-14.1.0
arm                     davinci_all_defconfig   clang-19
arm                       imx_v4_v5_defconfig   clang-16
arm                      integrator_defconfig   clang-19
arm                          pxa168_defconfig   clang-19
arm                             pxa_defconfig   gcc-14.1.0
arm                   randconfig-001-20240713   gcc-14.1.0
arm                   randconfig-002-20240713   gcc-14.1.0
arm                   randconfig-003-20240713   clang-19
arm                   randconfig-004-20240713   clang-19
arm                             rpc_defconfig   clang-19
arm64                            allmodconfig   clang-19
arm64                             allnoconfig   gcc-14.1.0
arm64                 randconfig-001-20240713   gcc-14.1.0
arm64                 randconfig-002-20240713   gcc-14.1.0
arm64                 randconfig-003-20240713   clang-19
arm64                 randconfig-004-20240713   gcc-14.1.0
csky                              allnoconfig   gcc-14.1.0
csky                  randconfig-001-20240713   gcc-14.1.0
csky                  randconfig-002-20240713   gcc-14.1.0
hexagon                          alldefconfig   clang-15
hexagon                           allnoconfig   clang-19
hexagon               randconfig-001-20240713   clang-19
hexagon               randconfig-002-20240713   clang-19
i386                             allmodconfig   gcc-13
i386                              allnoconfig   gcc-13
i386                             allyesconfig   gcc-13
i386         buildonly-randconfig-001-20240713   clang-18
i386         buildonly-randconfig-002-20240713   clang-18
i386         buildonly-randconfig-003-20240713   gcc-8
i386         buildonly-randconfig-004-20240713   clang-18
i386         buildonly-randconfig-005-20240713   gcc-13
i386         buildonly-randconfig-006-20240713   clang-18
i386                                defconfig   clang-18
i386                  randconfig-001-20240713   gcc-10
i386                  randconfig-002-20240713   gcc-13
i386                  randconfig-003-20240713   gcc-13
i386                  randconfig-004-20240713   clang-18
i386                  randconfig-005-20240713   gcc-10
i386                  randconfig-006-20240713   gcc-12
i386                  randconfig-011-20240713   clang-18
i386                  randconfig-012-20240713   gcc-7
i386                  randconfig-013-20240713   gcc-13
i386                  randconfig-014-20240713   gcc-13
i386                  randconfig-015-20240713   gcc-11
i386                  randconfig-016-20240713   clang-18
loongarch                        allmodconfig   gcc-14.1.0
loongarch                         allnoconfig   gcc-14.1.0
loongarch             randconfig-001-20240713   gcc-14.1.0
loongarch             randconfig-002-20240713   gcc-14.1.0
m68k                             allmodconfig   gcc-14.1.0
m68k                              allnoconfig   gcc-14.1.0
m68k                             allyesconfig   gcc-14.1.0
m68k                         apollo_defconfig   gcc-14.1.0
microblaze                       allmodconfig   gcc-14.1.0
microblaze                        allnoconfig   gcc-14.1.0
microblaze                       allyesconfig   gcc-14.1.0
mips                              allnoconfig   gcc-14.1.0
mips                        omega2p_defconfig   clang-19
nios2                         3c120_defconfig   gcc-14.1.0
nios2                             allnoconfig   gcc-14.1.0
nios2                 randconfig-001-20240713   gcc-14.1.0
nios2                 randconfig-002-20240713   gcc-14.1.0
openrisc                          allnoconfig   gcc-14.1.0
openrisc                         allyesconfig   gcc-14.1.0
openrisc                            defconfig   gcc-14.1.0
parisc                           allmodconfig   gcc-14.1.0
parisc                            allnoconfig   gcc-14.1.0
parisc                           allyesconfig   gcc-14.1.0
parisc                              defconfig   gcc-14.1.0
parisc                randconfig-001-20240713   gcc-14.1.0
parisc                randconfig-002-20240713   gcc-14.1.0
powerpc                          allmodconfig   gcc-14.1.0
powerpc                           allnoconfig   gcc-14.1.0
powerpc                    gamecube_defconfig   clang-19
powerpc                    ge_imp3a_defconfig   gcc-14.1.0
powerpc                 mpc8313_rdb_defconfig   gcc-14.1.0
powerpc                 mpc834x_itx_defconfig   clang-19
powerpc               randconfig-001-20240713   gcc-14.1.0
powerpc               randconfig-002-20240713   gcc-14.1.0
powerpc               randconfig-003-20240713   clang-19
powerpc                        warp_defconfig   gcc-14.1.0
powerpc64             randconfig-001-20240713   gcc-14.1.0
powerpc64             randconfig-002-20240713   gcc-14.1.0
powerpc64             randconfig-003-20240713   clang-17
riscv                             allnoconfig   gcc-14.1.0
riscv                               defconfig   clang-19
riscv                 randconfig-001-20240713   gcc-14.1.0
riscv                 randconfig-002-20240713   gcc-14.1.0
s390                             allmodconfig   clang-19
s390                              allnoconfig   clang-19
s390                             allyesconfig   gcc-14.1.0
s390                                defconfig   clang-19
s390                  randconfig-001-20240713   clang-19
s390                  randconfig-002-20240713   clang-19
sh                               allmodconfig   gcc-14.1.0
sh                                allnoconfig   gcc-14.1.0
sh                               allyesconfig   gcc-14.1.0
sh                                  defconfig   gcc-14.1.0
sh                    randconfig-001-20240713   gcc-14.1.0
sh                    randconfig-002-20240713   gcc-14.1.0
sh                          sdk7780_defconfig   gcc-14.1.0
sparc                            allmodconfig   gcc-14.1.0
sparc64                             defconfig   gcc-14.1.0
sparc64               randconfig-001-20240713   gcc-14.1.0
sparc64               randconfig-002-20240713   gcc-14.1.0
um                                allnoconfig   clang-17
um                                  defconfig   clang-19
um                             i386_defconfig   gcc-13
um                    randconfig-001-20240713   clang-14
um                    randconfig-002-20240713   clang-19
um                           x86_64_defconfig   clang-15
x86_64                            allnoconfig   clang-18
x86_64                           allyesconfig   clang-18
x86_64       buildonly-randconfig-001-20240713   clang-18
x86_64       buildonly-randconfig-002-20240713   clang-18
x86_64       buildonly-randconfig-003-20240713   gcc-13
x86_64       buildonly-randconfig-004-20240713   clang-18
x86_64       buildonly-randconfig-005-20240713   gcc-8
x86_64       buildonly-randconfig-006-20240713   clang-18
x86_64                              defconfig   gcc-13
x86_64                randconfig-001-20240713   clang-18
x86_64                randconfig-002-20240713   clang-18
x86_64                randconfig-003-20240713   clang-18
x86_64                randconfig-004-20240713   gcc-13
x86_64                randconfig-005-20240713   clang-18
x86_64                randconfig-006-20240713   clang-18
x86_64                randconfig-011-20240713   clang-18
x86_64                randconfig-012-20240713   clang-18
x86_64                randconfig-013-20240713   gcc-13
x86_64                randconfig-014-20240713   clang-18
x86_64                randconfig-015-20240713   gcc-13
x86_64                randconfig-016-20240713   gcc-13
x86_64                randconfig-071-20240713   gcc-8
x86_64                randconfig-072-20240713   gcc-8
x86_64                randconfig-073-20240713   clang-18
x86_64                randconfig-074-20240713   clang-18
x86_64                randconfig-075-20240713   gcc-13
x86_64                randconfig-076-20240713   clang-18
x86_64                          rhel-8.3-rust   clang-18
xtensa                            allnoconfig   gcc-14.1.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
