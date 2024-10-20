Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E1C320E
	for <linux-raid@vger.kernel.org>; Sun, 20 Oct 2024 07:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729409907; cv=none; b=WtxuMtbcVPGxEPRbIgz2NFyDpfaSt+06gSmX+A3iwRF7GolHFy3zRkR37UKdw7+XG1KWd5QxrnVAdS5XmFX6pinIvPV2j3K1SUQDY2h4JE79AjIcaTjes8vaNt8Wety1on5IS7siCGcrGs2pd/zNQmHVdT1tCXkiAnadXcyhk/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729409907; c=relaxed/simple;
	bh=d0tl4uOJfwszSXd+FgbFw/e+MlRX/ARwkW3F2NX7/mg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=TGjGN4GMfvLg0hP/veFm8w1HX0cONNV/E0H1hdxzfa2g6OjMcTN+8G0QOjHfXJpi7EdBaZrlZPa6UfFg09UyHmwePzbA7Oyqp3NVm7rI2FarlSwy1Kw8JMzCs9PnlOiZBtNEOwdvnEzMPj64pWOlt51VGS4pD14jwa5H+Ao367s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G01kgPsf; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G01kgPsf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729409906; x=1760945906;
  h=date:from:to:cc:subject:message-id;
  bh=d0tl4uOJfwszSXd+FgbFw/e+MlRX/ARwkW3F2NX7/mg=;
  b=G01kgPsfXyh0+ld9OJURyEMlvYSNl0p2pq1+ADmx3loJ1txQ/M3ZSZ/y
   xC10Xlnbkn8EyZokrTWILpJZ3iIGU11/zuGetNZEwP8EdqvZJaBvVdE+n
   VemePkUFdhVbPz6MYQalH2pzlCNus81nEV2mi3Zx8NHDx2VCp2NEUDHEH
   +mcn/aQ3xO6NMHyZRbrX4D158zRGy1sKaA3b+CcaCOHUibY4FmggTSXX/
   DhYq10XajF0r0kY46R6sfbSsepKY8wR6Gnjn8jE+eBiOLAUi27iYbPMsQ
   t1p1sSx+PcehVqMfFMwRuigZBJf5jsrTwoxNhd3ImjOTZBRb+gUvg617I
   Q==;
X-CSE-ConnectionGUID: 3pkgM3dfR1qoz6qyDsVnXA==
X-CSE-MsgGUID: HTrq/Rt0T+CALGqWRlpMXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11230"; a="39526361"
X-IronPort-AV: E=Sophos;i="6.11,218,1725346800"; 
   d="scan'208";a="39526361"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 00:38:25 -0700
X-CSE-ConnectionGUID: v7bxJYEWSnuUuszeXCKKtQ==
X-CSE-MsgGUID: rAzd2m1RSnSZxYFOhoV/tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,218,1725346800"; 
   d="scan'208";a="110074894"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 20 Oct 2024 00:38:24 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t2QW5-000Q2q-1t;
	Sun, 20 Oct 2024 07:38:21 +0000
Date: Sun, 20 Oct 2024 15:38:00 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.12] BUILD SUCCESS
 825711e00117fc686ab89ac36a9a7b252dc349c6
Message-ID: <202410201552.6U33TfbG-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.12
branch HEAD: 825711e00117fc686ab89ac36a9a7b252dc349c6  md/raid10: fix null ptr dereference in raid10_size()

elapsed time: 3436m

configs tested: 64
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-13.3.0
alpha                               defconfig    gcc-13.3.0
arc                              allmodconfig    gcc-13.2.0
arc                               allnoconfig    gcc-13.2.0
arc                              allyesconfig    gcc-13.2.0
arc                                 defconfig    gcc-13.2.0
arm                               allnoconfig    clang-20
arm                                 defconfig    clang-14
arm64                             allnoconfig    gcc-14.1.0
arm64                               defconfig    gcc-14.1.0
csky                              allnoconfig    gcc-14.1.0
csky                                defconfig    gcc-14.1.0
hexagon                           allnoconfig    clang-20
hexagon                             defconfig    clang-20
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20241019    gcc-12
i386        buildonly-randconfig-002-20241019    clang-18
i386        buildonly-randconfig-003-20241019    gcc-12
i386        buildonly-randconfig-004-20241019    gcc-12
i386        buildonly-randconfig-005-20241019    clang-18
i386        buildonly-randconfig-006-20241019    gcc-12
i386                                defconfig    clang-18
i386                  randconfig-001-20241019    gcc-12
i386                  randconfig-002-20241019    clang-18
i386                  randconfig-003-20241019    gcc-12
i386                  randconfig-004-20241019    clang-18
i386                  randconfig-005-20241019    clang-18
i386                  randconfig-006-20241019    gcc-12
i386                  randconfig-011-20241019    clang-18
i386                  randconfig-012-20241019    clang-18
i386                  randconfig-013-20241019    clang-18
i386                  randconfig-014-20241019    clang-18
i386                  randconfig-015-20241019    gcc-12
i386                  randconfig-016-20241019    gcc-12
loongarch                        allmodconfig    gcc-14.1.0
loongarch                         allnoconfig    gcc-14.1.0
m68k                             allmodconfig    gcc-14.1.0
m68k                              allnoconfig    gcc-14.1.0
m68k                             allyesconfig    gcc-14.1.0
microblaze                       allmodconfig    gcc-14.1.0
microblaze                        allnoconfig    gcc-14.1.0
microblaze                       allyesconfig    gcc-14.1.0
mips                              allnoconfig    gcc-14.1.0
nios2                             allnoconfig    gcc-14.1.0
openrisc                          allnoconfig    gcc-14.1.0
parisc                            allnoconfig    gcc-14.1.0
powerpc                           allnoconfig    gcc-14.1.0
riscv                             allnoconfig    gcc-14.1.0
s390                             allmodconfig    clang-20
s390                              allnoconfig    clang-20
s390                             allyesconfig    gcc-14.1.0
sh                               allmodconfig    gcc-14.1.0
sh                                allnoconfig    gcc-14.1.0
sh                               allyesconfig    gcc-14.1.0
sparc                            allmodconfig    gcc-14.1.0
um                                allnoconfig    clang-17
x86_64                            allnoconfig    clang-18
x86_64                           allyesconfig    clang-18
x86_64                              defconfig    gcc-11
x86_64                                  kexec    clang-18
x86_64                               rhel-8.3    gcc-12
xtensa                            allnoconfig    gcc-14.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
