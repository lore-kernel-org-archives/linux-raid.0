Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCD527452
	for <linux-raid@vger.kernel.org>; Fri,  5 Jul 2024 05:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720158143; cv=none; b=W1PLk/rfyi1kUAB9yDR52SZuD+BDRDDoXiGge3Pxa02BWN4p1dCK7LYA28HpmIdXPt/Clqpm8GVGVCrXKEJfEHBbUQclNP91C2JU+FKLym46oDLZ8r2uQuzsHgklCvk+RfbPCjkpS4JVsSxH7v38bKwqjYnJPOEh7XLPwBy99RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720158143; c=relaxed/simple;
	bh=Eyk1+6yhgzboBWVE9S/mk/DzBw6F17V8uQRsOMhbLKA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=bHYKnqfs2P/bW08cwfumBWCU/3o55IS7IyBh5xAvieKeYgA4w3nTxqHcROHEKledBAc74iDTQnQXjblUM9e83ADTUP8qTRmNmSdqWxFeTdi5DZrr8cs3KTzRt706Xs7GnhFOCilzFlLFTa7aUVYLACZyxdHTuV9vXqKRKmVy+B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HX1EcHIw; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HX1EcHIw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720158142; x=1751694142;
  h=date:from:to:cc:subject:message-id;
  bh=Eyk1+6yhgzboBWVE9S/mk/DzBw6F17V8uQRsOMhbLKA=;
  b=HX1EcHIwwQc/cdIYNHN39aebXtWcKa1dtNMeU284r6ND6EyRXipIcw0U
   PImtAnZDDY0S6fjt/DbX9x+bm6QarIkbeS0ZS0hdQJGAsPfE5gYDJTm+9
   sq8gnXseWn86fU4EFsaonUSCQcmsCqk/JHbUZr6By+sQG1m3at+TdBGr7
   OQv7S5XzeMmP5UCBc4/bInXwEgIOH3sb5AkaNbOhrHJfYIdyOyzq/GGUJ
   GcLOWptYX7roupqYMqzKW6zDnX+GvK9VvaHWQCdox8Pm1ReVePwR7IC05
   AYvUtQNGpnmGwIdPfn0wmDo/F96xO/Fe77JdamBNg61rQuozPQ0okf2t5
   g==;
X-CSE-ConnectionGUID: pAn8WMOJQcGRKy1RHNW40Q==
X-CSE-MsgGUID: NArCjsGcTzy2x4lBZicEEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="28594227"
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="28594227"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 22:42:22 -0700
X-CSE-ConnectionGUID: VaQWV4VHTVym6QMOFonw8A==
X-CSE-MsgGUID: C9a28IQgSI+NqeWxoB4eMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="46893022"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 04 Jul 2024 22:42:20 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sPbi5-000RzH-2c;
	Fri, 05 Jul 2024 05:42:17 +0000
Date: Fri, 05 Jul 2024 13:42:03 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.11] BUILD SUCCESS
 25b3a8237a03ec0b67b965b52d74862e77ef7115
Message-ID: <202407051302.ZfhSC4Mp-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.11
branch HEAD: 25b3a8237a03ec0b67b965b52d74862e77ef7115  md/raid5: recheck if reshape has finished with device_lock held

elapsed time: 1295m

configs tested: 128
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig   gcc-13.2.0
alpha                            allyesconfig   gcc-13.2.0
arc                              allmodconfig   gcc-13.2.0
arc                               allnoconfig   gcc-13.2.0
arc                              allyesconfig   gcc-13.2.0
arc                   randconfig-001-20240705   gcc-13.2.0
arc                   randconfig-002-20240705   gcc-13.2.0
arm                              allmodconfig   gcc-13.2.0
arm                               allnoconfig   clang-19
arm                              allyesconfig   gcc-13.2.0
arm                          ixp4xx_defconfig   gcc-13.2.0
arm                          pxa168_defconfig   clang-19
arm                   randconfig-001-20240705   gcc-13.2.0
arm                   randconfig-002-20240705   gcc-13.2.0
arm                   randconfig-003-20240705   gcc-13.2.0
arm                   randconfig-004-20240705   gcc-13.2.0
arm                           sama7_defconfig   clang-19
arm64                            allmodconfig   clang-19
arm64                             allnoconfig   gcc-13.2.0
arm64                 randconfig-001-20240705   clang-19
arm64                 randconfig-002-20240705   clang-19
arm64                 randconfig-003-20240705   clang-19
arm64                 randconfig-004-20240705   clang-19
csky                              allnoconfig   gcc-13.2.0
csky                  randconfig-001-20240705   gcc-13.2.0
csky                  randconfig-002-20240705   gcc-13.2.0
hexagon                          allmodconfig   clang-19
hexagon                           allnoconfig   clang-19
hexagon                          allyesconfig   clang-19
hexagon               randconfig-001-20240705   clang-19
hexagon               randconfig-002-20240705   clang-17
i386                             allmodconfig   gcc-13
i386                              allnoconfig   gcc-13
i386                             allyesconfig   gcc-13
i386         buildonly-randconfig-001-20240704   clang-18
i386         buildonly-randconfig-002-20240704   gcc-13
i386         buildonly-randconfig-003-20240704   gcc-13
i386         buildonly-randconfig-004-20240704   gcc-12
i386         buildonly-randconfig-005-20240704   gcc-12
i386         buildonly-randconfig-006-20240704   gcc-12
i386                                defconfig   clang-18
i386                  randconfig-001-20240704   clang-18
i386                  randconfig-002-20240704   gcc-13
i386                  randconfig-003-20240704   clang-18
i386                  randconfig-004-20240704   gcc-13
i386                  randconfig-005-20240704   clang-18
i386                  randconfig-006-20240704   gcc-12
i386                  randconfig-011-20240704   gcc-13
i386                  randconfig-012-20240704   clang-18
i386                  randconfig-013-20240704   clang-18
i386                  randconfig-014-20240704   clang-18
i386                  randconfig-015-20240704   clang-18
i386                  randconfig-016-20240704   clang-18
loongarch                        allmodconfig   gcc-13.2.0
loongarch                         allnoconfig   gcc-13.2.0
loongarch             randconfig-001-20240705   gcc-13.2.0
loongarch             randconfig-002-20240705   gcc-13.2.0
m68k                             allmodconfig   gcc-13.2.0
m68k                              allnoconfig   gcc-13.2.0
m68k                             allyesconfig   gcc-13.2.0
m68k                       m5208evb_defconfig   gcc-13.2.0
microblaze                       allmodconfig   gcc-13.2.0
microblaze                        allnoconfig   gcc-13.2.0
microblaze                       allyesconfig   gcc-13.2.0
mips                              allnoconfig   gcc-13.2.0
mips                      fuloong2e_defconfig   gcc-13.2.0
mips                      maltasmvp_defconfig   gcc-13.2.0
nios2                             allnoconfig   gcc-13.2.0
nios2                 randconfig-001-20240705   gcc-13.2.0
nios2                 randconfig-002-20240705   gcc-13.2.0
openrisc                          allnoconfig   gcc-13.2.0
openrisc                         allyesconfig   gcc-13.2.0
openrisc                            defconfig   gcc-13.2.0
parisc                           allmodconfig   gcc-13.2.0
parisc                            allnoconfig   gcc-13.2.0
parisc                           allyesconfig   gcc-13.2.0
parisc                randconfig-001-20240705   gcc-13.2.0
parisc                randconfig-002-20240705   gcc-13.2.0
powerpc                          allmodconfig   gcc-13.2.0
powerpc                           allnoconfig   gcc-13.2.0
powerpc                          allyesconfig   clang-19
powerpc                    amigaone_defconfig   gcc-13.2.0
powerpc                   bluestone_defconfig   clang-19
powerpc                     ksi8560_defconfig   gcc-13.2.0
powerpc                  mpc885_ads_defconfig   clang-19
powerpc               randconfig-001-20240705   gcc-13.2.0
powerpc               randconfig-002-20240705   clang-19
powerpc               randconfig-003-20240705   clang-19
powerpc                    sam440ep_defconfig   gcc-13.2.0
powerpc                      walnut_defconfig   gcc-13.2.0
powerpc64             randconfig-001-20240705   gcc-13.2.0
powerpc64             randconfig-002-20240705   clang-19
powerpc64             randconfig-003-20240705   clang-19
riscv                            allmodconfig   clang-19
riscv                             allnoconfig   gcc-13.2.0
riscv                            allyesconfig   clang-19
riscv                    nommu_virt_defconfig   clang-19
riscv                 randconfig-001-20240705   gcc-13.2.0
riscv                 randconfig-002-20240705   clang-19
s390                             allmodconfig   clang-19
s390                              allnoconfig   clang-19
s390                             allyesconfig   gcc-13.2.0
s390                  randconfig-001-20240705   gcc-13.2.0
s390                  randconfig-002-20240705   clang-16
sh                               allmodconfig   gcc-13.2.0
sh                                allnoconfig   gcc-13.2.0
sh                               allyesconfig   gcc-13.2.0
sh                ecovec24-romimage_defconfig   gcc-13.2.0
sh                    randconfig-001-20240705   gcc-13.2.0
sh                    randconfig-002-20240705   gcc-13.2.0
sh                      rts7751r2d1_defconfig   gcc-13.2.0
sh                        sh7763rdp_defconfig   gcc-13.2.0
sparc                            allmodconfig   gcc-13.2.0
sparc64               randconfig-001-20240705   gcc-13.2.0
sparc64               randconfig-002-20240705   gcc-13.2.0
um                               allmodconfig   clang-19
um                                allnoconfig   clang-17
um                               allyesconfig   gcc-13
um                    randconfig-001-20240705   clang-19
um                    randconfig-002-20240705   clang-15
x86_64                            allnoconfig   clang-18
x86_64                           allyesconfig   clang-18
x86_64                              defconfig   gcc-13
x86_64                          rhel-8.3-rust   clang-18
xtensa                            allnoconfig   gcc-13.2.0
xtensa                randconfig-001-20240705   gcc-13.2.0
xtensa                randconfig-002-20240705   gcc-13.2.0
xtensa                         virt_defconfig   gcc-13.2.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
