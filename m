Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB31F4FAD
	for <linux-raid@vger.kernel.org>; Fri,  8 Nov 2024 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731074890; cv=none; b=c0b6Wnn3QAXmAqmmw/rpXFgCxv9aoCQhrMZn6JAJ+qg9uuiH9H0CqP5h6F9F6Xh6+0hw6LS0buEGhCxftxMuMjifbRRA0VzcIv/Xsf8lE59LUNSfHvrqkzf1vYK03jQHGnj8rGf2NeYotUl9LTZPYsvQ3rsXhQUFz8HTjwDMHhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731074890; c=relaxed/simple;
	bh=8d1fXwYeT9spsheUAfJ+fY8cdJGKg0teJfZx+WqtLmc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=WM8R4K09uBL3zDVGWdfobbZemMjjL74AgA76rZkm6oWHXCrUULFdcKMw1TKkoW6opPyRc67J+s8F7bJLGCTeGRTtR4nXCGMQQF3FckgqLO89+jR6Nhsjtcb1mQrx/KLCbcUszbHXHvThUnjqCzKc83TdLr/o7awRKYWgIZ176Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JbhHHNUW; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JbhHHNUW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731074888; x=1762610888;
  h=date:from:to:cc:subject:message-id;
  bh=8d1fXwYeT9spsheUAfJ+fY8cdJGKg0teJfZx+WqtLmc=;
  b=JbhHHNUWd+F8CYjB1lQA7I8W2pk6e+smBfd+FNY1/2Itu7OneE28ntr7
   50EbmWaXueqE6owIkMiKto8LF+ihWyGsR08NGHpNwJf6NlJf8Kj9WGMQM
   oQKO/iTEbcb4me4URXm7oE0QXsFHAzsz5eZhyP8+ApiFtKcd95+EWAlzv
   5ZjxR/FbpSoTrSN4pHmpyYj70K5uEPihlsx787sLiNlJ1X7LVkK1cyaFk
   P7XPz1r8Udm8T3WgWhocIAWSznObW3/P+z/dJilfrm6gFFswFP9NSJbCj
   o1EuKuj8tp/kiFN1/Y6FofWyhcvPT5WiZ6sAY507KuNcj3V9W/ZHtXsFC
   Q==;
X-CSE-ConnectionGUID: Y/hyMwFNT+mNqyGA15jk0Q==
X-CSE-MsgGUID: B+zHhebpRSCUSMEhK0jmAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11250"; a="30355140"
X-IronPort-AV: E=Sophos;i="6.12,138,1728975600"; 
   d="scan'208";a="30355140"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 06:08:08 -0800
X-CSE-ConnectionGUID: IUZ4pURHQkCBZiFvYBfG+A==
X-CSE-MsgGUID: mSTaYxqiSzGzMAtI44ngjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,138,1728975600"; 
   d="scan'208";a="123104686"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 08 Nov 2024 06:08:06 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t9Pee-000rUU-0P;
	Fri, 08 Nov 2024 14:08:04 +0000
Date: Fri, 08 Nov 2024 22:07:44 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.13] BUILD SUCCESS
 c13c2d2a4b52eacab1c093e5b993c0a6f82c438e
Message-ID: <202411082238.Ff7hyjad-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.13
branch HEAD: c13c2d2a4b52eacab1c093e5b993c0a6f82c438e  MAINTAINERS: Make Yu Kuai co-maintainer of md/raid subsystem

elapsed time: 726m

configs tested: 189
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-14.2.0
alpha                            allyesconfig    clang-20
alpha                               defconfig    gcc-14.2.0
arc                              allmodconfig    clang-20
arc                               allnoconfig    gcc-14.2.0
arc                              allyesconfig    clang-20
arc                                 defconfig    gcc-14.2.0
arc                            hsdk_defconfig    clang-14
arc                 nsimosci_hs_smp_defconfig    clang-20
arc                   randconfig-001-20241108    gcc-14.2.0
arc                   randconfig-002-20241108    gcc-14.2.0
arm                              allmodconfig    clang-20
arm                               allnoconfig    gcc-14.2.0
arm                              allyesconfig    clang-20
arm                                 defconfig    gcc-14.2.0
arm                            dove_defconfig    clang-14
arm                          ep93xx_defconfig    clang-14
arm                            mmp2_defconfig    clang-20
arm                       multi_v4t_defconfig    clang-20
arm                        multi_v5_defconfig    clang-20
arm                         orion5x_defconfig    clang-20
arm                   randconfig-001-20241108    gcc-14.2.0
arm                   randconfig-002-20241108    gcc-14.2.0
arm                   randconfig-003-20241108    gcc-14.2.0
arm                   randconfig-004-20241108    gcc-14.2.0
arm                           sama7_defconfig    clang-14
arm                           sunxi_defconfig    clang-20
arm64                            allmodconfig    clang-20
arm64                             allnoconfig    gcc-14.2.0
arm64                               defconfig    gcc-14.2.0
arm64                 randconfig-001-20241108    gcc-14.2.0
arm64                 randconfig-002-20241108    gcc-14.2.0
arm64                 randconfig-003-20241108    gcc-14.2.0
arm64                 randconfig-004-20241108    gcc-14.2.0
csky                              allnoconfig    gcc-14.2.0
csky                                defconfig    gcc-14.2.0
csky                  randconfig-001-20241108    gcc-14.2.0
csky                  randconfig-002-20241108    gcc-14.2.0
hexagon                          allmodconfig    clang-20
hexagon                           allnoconfig    gcc-14.2.0
hexagon                          allyesconfig    clang-20
hexagon                             defconfig    gcc-14.2.0
hexagon               randconfig-001-20241108    gcc-14.2.0
hexagon               randconfig-002-20241108    gcc-14.2.0
i386                             allmodconfig    clang-19
i386                              allnoconfig    clang-19
i386                             allyesconfig    clang-19
i386        buildonly-randconfig-001-20241108    clang-19
i386        buildonly-randconfig-002-20241108    clang-19
i386        buildonly-randconfig-003-20241108    clang-19
i386        buildonly-randconfig-004-20241108    clang-19
i386        buildonly-randconfig-005-20241108    clang-19
i386        buildonly-randconfig-006-20241108    clang-19
i386                                defconfig    clang-19
i386                  randconfig-001-20241108    clang-19
i386                  randconfig-002-20241108    clang-19
i386                  randconfig-003-20241108    clang-19
i386                  randconfig-004-20241108    clang-19
i386                  randconfig-005-20241108    clang-19
i386                  randconfig-006-20241108    clang-19
i386                  randconfig-011-20241108    clang-19
i386                  randconfig-012-20241108    clang-19
i386                  randconfig-013-20241108    clang-19
i386                  randconfig-014-20241108    clang-19
i386                  randconfig-015-20241108    clang-19
i386                  randconfig-016-20241108    clang-19
loongarch                        allmodconfig    gcc-14.2.0
loongarch                         allnoconfig    gcc-14.2.0
loongarch                           defconfig    gcc-14.2.0
loongarch             randconfig-001-20241108    gcc-14.2.0
loongarch             randconfig-002-20241108    gcc-14.2.0
m68k                             allmodconfig    gcc-14.2.0
m68k                              allnoconfig    gcc-14.2.0
m68k                             allyesconfig    gcc-14.2.0
m68k                                defconfig    gcc-14.2.0
m68k                       m5475evb_defconfig    clang-20
m68k                          sun3x_defconfig    clang-20
microblaze                       allmodconfig    gcc-14.2.0
microblaze                        allnoconfig    gcc-14.2.0
microblaze                       allyesconfig    gcc-14.2.0
microblaze                          defconfig    gcc-14.2.0
mips                              allnoconfig    gcc-14.2.0
mips                            gpr_defconfig    clang-20
mips                      maltaaprp_defconfig    clang-14
mips                         rt305x_defconfig    clang-20
mips                   sb1250_swarm_defconfig    clang-14
nios2                         10m50_defconfig    clang-20
nios2                             allnoconfig    gcc-14.2.0
nios2                               defconfig    gcc-14.2.0
nios2                 randconfig-001-20241108    gcc-14.2.0
nios2                 randconfig-002-20241108    gcc-14.2.0
openrisc                          allnoconfig    clang-20
openrisc                         allyesconfig    gcc-14.2.0
openrisc                            defconfig    gcc-12
openrisc                       virt_defconfig    clang-14
parisc                           alldefconfig    clang-20
parisc                           allmodconfig    gcc-14.2.0
parisc                            allnoconfig    clang-20
parisc                           allyesconfig    gcc-14.2.0
parisc                              defconfig    gcc-12
parisc                randconfig-001-20241108    gcc-14.2.0
parisc                randconfig-002-20241108    gcc-14.2.0
parisc64                            defconfig    gcc-14.2.0
powerpc                          allmodconfig    gcc-14.2.0
powerpc                           allnoconfig    clang-20
powerpc                          allyesconfig    gcc-14.2.0
powerpc                    amigaone_defconfig    clang-14
powerpc                   currituck_defconfig    clang-20
powerpc                 linkstation_defconfig    clang-20
powerpc                   lite5200b_defconfig    clang-14
powerpc                     mpc512x_defconfig    clang-14
powerpc               mpc834x_itxgp_defconfig    clang-14
powerpc                  mpc885_ads_defconfig    clang-20
powerpc               randconfig-001-20241108    gcc-14.2.0
powerpc               randconfig-002-20241108    gcc-14.2.0
powerpc               randconfig-003-20241108    gcc-14.2.0
powerpc                     sequoia_defconfig    clang-14
powerpc64             randconfig-001-20241108    gcc-14.2.0
powerpc64             randconfig-002-20241108    gcc-14.2.0
powerpc64             randconfig-003-20241108    gcc-14.2.0
riscv                            allmodconfig    gcc-14.2.0
riscv                             allnoconfig    clang-20
riscv                            allyesconfig    gcc-14.2.0
riscv                               defconfig    gcc-12
riscv                 randconfig-001-20241108    gcc-14.2.0
riscv                 randconfig-002-20241108    gcc-14.2.0
s390                             alldefconfig    clang-14
s390                             allmodconfig    clang-20
s390                             allmodconfig    gcc-14.2.0
s390                              allnoconfig    clang-20
s390                             allyesconfig    gcc-14.2.0
s390                                defconfig    gcc-12
s390                  randconfig-001-20241108    gcc-14.2.0
s390                  randconfig-002-20241108    gcc-14.2.0
sh                               allmodconfig    gcc-14.2.0
sh                                allnoconfig    gcc-14.2.0
sh                               allyesconfig    gcc-14.2.0
sh                                  defconfig    gcc-12
sh                          kfr2r09_defconfig    clang-14
sh                            migor_defconfig    clang-14
sh                          r7785rp_defconfig    clang-20
sh                    randconfig-001-20241108    gcc-14.2.0
sh                    randconfig-002-20241108    gcc-14.2.0
sparc                            allmodconfig    gcc-14.2.0
sparc64                             defconfig    gcc-12
sparc64               randconfig-001-20241108    gcc-14.2.0
sparc64               randconfig-002-20241108    gcc-14.2.0
um                               allmodconfig    clang-20
um                                allnoconfig    clang-20
um                               allyesconfig    clang-20
um                                  defconfig    gcc-12
um                             i386_defconfig    gcc-12
um                    randconfig-001-20241108    gcc-14.2.0
um                    randconfig-002-20241108    gcc-14.2.0
um                           x86_64_defconfig    gcc-12
x86_64                            allnoconfig    clang-19
x86_64                           allyesconfig    clang-19
x86_64      buildonly-randconfig-001-20241108    clang-19
x86_64      buildonly-randconfig-002-20241108    clang-19
x86_64      buildonly-randconfig-003-20241108    clang-19
x86_64      buildonly-randconfig-004-20241108    clang-19
x86_64      buildonly-randconfig-005-20241108    clang-19
x86_64      buildonly-randconfig-006-20241108    clang-19
x86_64                              defconfig    clang-19
x86_64                                  kexec    clang-19
x86_64                                  kexec    gcc-12
x86_64                randconfig-001-20241108    clang-19
x86_64                randconfig-002-20241108    clang-19
x86_64                randconfig-003-20241108    clang-19
x86_64                randconfig-004-20241108    clang-19
x86_64                randconfig-005-20241108    clang-19
x86_64                randconfig-006-20241108    clang-19
x86_64                randconfig-011-20241108    clang-19
x86_64                randconfig-012-20241108    clang-19
x86_64                randconfig-013-20241108    clang-19
x86_64                randconfig-014-20241108    clang-19
x86_64                randconfig-015-20241108    clang-19
x86_64                randconfig-016-20241108    clang-19
x86_64                randconfig-071-20241108    clang-19
x86_64                randconfig-072-20241108    clang-19
x86_64                randconfig-073-20241108    clang-19
x86_64                randconfig-074-20241108    clang-19
x86_64                randconfig-075-20241108    clang-19
x86_64                randconfig-076-20241108    clang-19
x86_64                               rhel-8.3    gcc-12
xtensa                            allnoconfig    gcc-14.2.0
xtensa                randconfig-001-20241108    gcc-14.2.0
xtensa                randconfig-002-20241108    gcc-14.2.0
xtensa                         virt_defconfig    clang-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
