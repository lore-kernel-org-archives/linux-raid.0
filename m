Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7856C6FBF
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 03:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730949235; cv=none; b=nPI4Q5uRShPbTomkXeB668f5vcs4qgAJC0FcIzQjW6zpnrNCOYzmfUYcm41GogjSv/d+/D3PKapgMCkM0JPSEzRDiu46U5iHzsHAvz3nCbGiLLZXYrQNsDd/i2kmW/M2in7AbKhG4MPmqKBHkKl+nWPuAQJuBoSIzrforaoquHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730949235; c=relaxed/simple;
	bh=qTsNnaXP3Jyh0q59OyA2/rh1QG3rP4z0sgFy2UeLhCw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=R0qDoxp+CdMQXAn6Sax6qLJP4CWwdjIypSQVmhuohjAkrGEjz+nAmrBIj27haLPiaX/ml7AR+jDjCREjejTr+2zKXCy8So03A28FE/1RJfewqkinz/Ae1ygE1wmTXydRTrMDZ0WaEjxY7fiOYuwH7/qFAjmnazDWYjHS7xFMpDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OJyJclZ/; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OJyJclZ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730949232; x=1762485232;
  h=date:from:to:cc:subject:message-id;
  bh=qTsNnaXP3Jyh0q59OyA2/rh1QG3rP4z0sgFy2UeLhCw=;
  b=OJyJclZ/RhpAxuQJz437O5r2f2KYj0CZ3qCfW1GKAYvMcHtmzPqy/a8m
   tP5a6RtZNQSKY5ckS88YGPlKiOGogpQHaMSyYnf4SYDEqxY29JATqZKo+
   Ds2Y5bwfND2aUa+UPO4ZRbHZTI2uK/FJcrKg+AiC92cA2r1CvsCWijgbF
   cLYTjcphccgUIvYwbaIDJfMxvJLx8wtKXoASe0lu0+UZjaZnfXFxgOgT8
   oT5XnZkUonk0TReqSIoY8vwdhjLIFi7tnBl+MwK6vNZcJ6sNiDOKDrIZ6
   F00i4f3sIyv5suIXCwD6ed5UldbXW2I6z5Ll2UBSFAZeLoT0FYnw/rMmM
   g==;
X-CSE-ConnectionGUID: +Og6BXsyROuKymCqJQJ/jQ==
X-CSE-MsgGUID: PG8efgQJQxGjlTyXrNlKgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="34553554"
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="34553554"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 19:13:52 -0800
X-CSE-ConnectionGUID: Ymg5WO3rTJu/0NBVOLxYzA==
X-CSE-MsgGUID: J2KueQj2SjegI1gKEikNSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="85058870"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 06 Nov 2024 19:13:50 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8sxw-000pj8-21;
	Thu, 07 Nov 2024 03:13:48 +0000
Date: Thu, 07 Nov 2024 11:13:18 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.13] BUILD SUCCESS
 6012169e8aae9c0eda38bbedcd7a1540a81220ae
Message-ID: <202411071110.etouPQR2-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.13
branch HEAD: 6012169e8aae9c0eda38bbedcd7a1540a81220ae  md/md-bitmap: Add missing destroy_work_on_stack()

elapsed time: 1292m

configs tested: 354
configs skipped: 17

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-14.2.0
alpha                            allyesconfig    clang-20
alpha                            allyesconfig    gcc-14.2.0
alpha                               defconfig    gcc-14.2.0
arc                              allmodconfig    clang-20
arc                              allmodconfig    gcc-13.2.0
arc                               allnoconfig    gcc-14.2.0
arc                              allyesconfig    clang-20
arc                              allyesconfig    gcc-13.2.0
arc                          axs101_defconfig    gcc-14.2.0
arc                          axs103_defconfig    gcc-14.2.0
arc                                 defconfig    gcc-14.2.0
arc                     haps_hs_smp_defconfig    clang-20
arc                            hsdk_defconfig    gcc-14.2.0
arc                        nsim_700_defconfig    gcc-14.2.0
arc                        nsimosci_defconfig    clang-20
arc                   randconfig-001-20241106    gcc-14.2.0
arc                   randconfig-001-20241107    gcc-14.2.0
arc                   randconfig-002-20241106    gcc-14.2.0
arc                   randconfig-002-20241107    gcc-14.2.0
arm                              allmodconfig    clang-20
arm                              allmodconfig    gcc-14.2.0
arm                               allnoconfig    gcc-14.2.0
arm                              allyesconfig    clang-20
arm                              allyesconfig    gcc-14.2.0
arm                         axm55xx_defconfig    gcc-14.2.0
arm                        clps711x_defconfig    clang-20
arm                                 defconfig    gcc-14.2.0
arm                          gemini_defconfig    gcc-14.2.0
arm                           h3600_defconfig    gcc-14.2.0
arm                            hisi_defconfig    clang-20
arm                           imxrt_defconfig    gcc-14.2.0
arm                          ixp4xx_defconfig    clang-20
arm                         nhk8815_defconfig    clang-20
arm                            qcom_defconfig    clang-20
arm                   randconfig-001-20241106    gcc-14.2.0
arm                   randconfig-001-20241107    gcc-14.2.0
arm                   randconfig-002-20241106    gcc-14.2.0
arm                   randconfig-002-20241107    gcc-14.2.0
arm                   randconfig-003-20241106    gcc-14.2.0
arm                   randconfig-003-20241107    gcc-14.2.0
arm                   randconfig-004-20241106    gcc-14.2.0
arm                   randconfig-004-20241107    gcc-14.2.0
arm                             rpc_defconfig    clang-20
arm                             rpc_defconfig    gcc-14.2.0
arm                           sama5_defconfig    gcc-14.2.0
arm                        shmobile_defconfig    gcc-14.2.0
arm                          sp7021_defconfig    gcc-14.2.0
arm                       spear13xx_defconfig    clang-20
arm                        spear6xx_defconfig    gcc-14.2.0
arm                           sunxi_defconfig    gcc-14.2.0
arm                       versatile_defconfig    gcc-14.2.0
arm64                            allmodconfig    clang-20
arm64                             allnoconfig    gcc-14.2.0
arm64                               defconfig    clang-20
arm64                               defconfig    gcc-14.2.0
arm64                 randconfig-001-20241106    gcc-14.2.0
arm64                 randconfig-001-20241107    gcc-14.2.0
arm64                 randconfig-002-20241106    gcc-14.2.0
arm64                 randconfig-002-20241107    gcc-14.2.0
arm64                 randconfig-003-20241106    gcc-14.2.0
arm64                 randconfig-003-20241107    gcc-14.2.0
arm64                 randconfig-004-20241106    gcc-14.2.0
arm64                 randconfig-004-20241107    gcc-14.2.0
csky                              allnoconfig    gcc-14.2.0
csky                                defconfig    gcc-14.2.0
csky                  randconfig-001-20241106    gcc-14.2.0
csky                  randconfig-001-20241107    gcc-14.2.0
csky                  randconfig-002-20241106    gcc-14.2.0
csky                  randconfig-002-20241107    gcc-14.2.0
hexagon                          allmodconfig    clang-20
hexagon                           allnoconfig    gcc-14.2.0
hexagon                          allyesconfig    clang-20
hexagon                             defconfig    gcc-14.2.0
hexagon               randconfig-001-20241106    gcc-14.2.0
hexagon               randconfig-001-20241107    gcc-14.2.0
hexagon               randconfig-002-20241106    gcc-14.2.0
hexagon               randconfig-002-20241107    gcc-14.2.0
i386                             allmodconfig    clang-19
i386                             allmodconfig    gcc-12
i386                              allnoconfig    clang-19
i386                              allnoconfig    gcc-12
i386                             allyesconfig    clang-19
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20241106    gcc-12
i386        buildonly-randconfig-001-20241107    clang-19
i386        buildonly-randconfig-002-20241106    gcc-12
i386        buildonly-randconfig-002-20241107    clang-19
i386        buildonly-randconfig-003-20241106    gcc-12
i386        buildonly-randconfig-003-20241107    clang-19
i386        buildonly-randconfig-004-20241106    gcc-12
i386        buildonly-randconfig-004-20241107    clang-19
i386        buildonly-randconfig-005-20241106    gcc-12
i386        buildonly-randconfig-005-20241107    clang-19
i386        buildonly-randconfig-006-20241106    gcc-12
i386        buildonly-randconfig-006-20241107    clang-19
i386                                defconfig    clang-19
i386                  randconfig-001-20241106    gcc-12
i386                  randconfig-001-20241107    clang-19
i386                  randconfig-002-20241106    gcc-12
i386                  randconfig-002-20241107    clang-19
i386                  randconfig-003-20241106    gcc-12
i386                  randconfig-003-20241107    clang-19
i386                  randconfig-004-20241106    gcc-12
i386                  randconfig-004-20241107    clang-19
i386                  randconfig-005-20241106    gcc-12
i386                  randconfig-005-20241107    clang-19
i386                  randconfig-006-20241106    gcc-12
i386                  randconfig-006-20241107    clang-19
i386                  randconfig-011-20241106    gcc-12
i386                  randconfig-011-20241107    clang-19
i386                  randconfig-012-20241106    gcc-12
i386                  randconfig-012-20241107    clang-19
i386                  randconfig-013-20241106    gcc-12
i386                  randconfig-013-20241107    clang-19
i386                  randconfig-014-20241106    gcc-12
i386                  randconfig-014-20241107    clang-19
i386                  randconfig-015-20241106    gcc-12
i386                  randconfig-015-20241107    clang-19
i386                  randconfig-016-20241106    gcc-12
i386                  randconfig-016-20241107    clang-19
loongarch                        allmodconfig    gcc-14.2.0
loongarch                         allnoconfig    gcc-14.2.0
loongarch                           defconfig    gcc-14.2.0
loongarch             randconfig-001-20241106    gcc-14.2.0
loongarch             randconfig-001-20241107    gcc-14.2.0
loongarch             randconfig-002-20241106    gcc-14.2.0
loongarch             randconfig-002-20241107    gcc-14.2.0
m68k                             allmodconfig    gcc-14.2.0
m68k                              allnoconfig    gcc-14.2.0
m68k                             allyesconfig    gcc-14.2.0
m68k                         amcore_defconfig    clang-20
m68k                         amcore_defconfig    gcc-14.2.0
m68k                          amiga_defconfig    clang-20
m68k                          atari_defconfig    gcc-14.2.0
m68k                                defconfig    gcc-14.2.0
m68k                       m5208evb_defconfig    gcc-14.2.0
m68k                       m5249evb_defconfig    gcc-14.2.0
m68k                       m5275evb_defconfig    clang-20
m68k                          multi_defconfig    gcc-14.2.0
m68k                        mvme147_defconfig    clang-20
m68k                        mvme16x_defconfig    clang-20
m68k                           sun3_defconfig    clang-20
m68k                           sun3_defconfig    gcc-14.2.0
microblaze                       allmodconfig    gcc-14.2.0
microblaze                        allnoconfig    gcc-14.2.0
microblaze                       allyesconfig    gcc-14.2.0
microblaze                          defconfig    gcc-14.2.0
mips                              allnoconfig    gcc-14.2.0
mips                         bigsur_defconfig    clang-20
mips                            gpr_defconfig    gcc-14.2.0
mips                        maltaup_defconfig    clang-20
mips                        vocore2_defconfig    gcc-14.2.0
nios2                         10m50_defconfig    clang-20
nios2                             allnoconfig    gcc-14.2.0
nios2                               defconfig    gcc-14.2.0
nios2                 randconfig-001-20241106    gcc-14.2.0
nios2                 randconfig-001-20241107    gcc-14.2.0
nios2                 randconfig-002-20241106    gcc-14.2.0
nios2                 randconfig-002-20241107    gcc-14.2.0
openrisc                          allnoconfig    clang-20
openrisc                          allnoconfig    gcc-14.2.0
openrisc                         allyesconfig    gcc-14.2.0
openrisc                            defconfig    gcc-12
openrisc                  or1klitex_defconfig    clang-20
openrisc                    or1ksim_defconfig    gcc-14.2.0
openrisc                       virt_defconfig    clang-20
parisc                           allmodconfig    gcc-14.2.0
parisc                            allnoconfig    clang-20
parisc                            allnoconfig    gcc-14.2.0
parisc                           allyesconfig    gcc-14.2.0
parisc                              defconfig    gcc-12
parisc                generic-32bit_defconfig    clang-20
parisc                randconfig-001-20241106    gcc-14.2.0
parisc                randconfig-001-20241107    gcc-14.2.0
parisc                randconfig-002-20241106    gcc-14.2.0
parisc                randconfig-002-20241107    gcc-14.2.0
parisc64                            defconfig    gcc-14.2.0
powerpc                          allmodconfig    gcc-14.2.0
powerpc                           allnoconfig    clang-20
powerpc                           allnoconfig    gcc-14.2.0
powerpc                          allyesconfig    gcc-14.2.0
powerpc                      bamboo_defconfig    gcc-14.2.0
powerpc                        cell_defconfig    clang-20
powerpc                        cell_defconfig    gcc-14.2.0
powerpc                   currituck_defconfig    clang-20
powerpc                     ep8248e_defconfig    gcc-14.2.0
powerpc                        fsp2_defconfig    clang-20
powerpc                       holly_defconfig    clang-20
powerpc                   motionpro_defconfig    clang-20
powerpc                   motionpro_defconfig    gcc-14.2.0
powerpc                     mpc5200_defconfig    clang-20
powerpc                 mpc8315_rdb_defconfig    gcc-14.2.0
powerpc                 mpc832x_rdb_defconfig    gcc-14.2.0
powerpc                 mpc834x_itx_defconfig    clang-20
powerpc                 mpc837x_rdb_defconfig    gcc-14.2.0
powerpc                      pasemi_defconfig    clang-20
powerpc                      pcm030_defconfig    clang-20
powerpc                      pcm030_defconfig    gcc-14.2.0
powerpc                      ppc64e_defconfig    clang-20
powerpc                      ppc64e_defconfig    gcc-14.2.0
powerpc                         ps3_defconfig    gcc-14.2.0
powerpc                     rainier_defconfig    gcc-14.2.0
powerpc               randconfig-001-20241106    gcc-14.2.0
powerpc               randconfig-001-20241107    gcc-14.2.0
powerpc               randconfig-002-20241106    gcc-14.2.0
powerpc               randconfig-002-20241107    gcc-14.2.0
powerpc               randconfig-003-20241106    gcc-14.2.0
powerpc               randconfig-003-20241107    gcc-14.2.0
powerpc                     sequoia_defconfig    gcc-14.2.0
powerpc                  storcenter_defconfig    gcc-14.2.0
powerpc                     tqm8541_defconfig    gcc-14.2.0
powerpc                     tqm8555_defconfig    clang-20
powerpc                      tqm8xx_defconfig    gcc-14.2.0
powerpc64             randconfig-001-20241106    gcc-14.2.0
powerpc64             randconfig-002-20241106    gcc-14.2.0
powerpc64             randconfig-003-20241106    gcc-14.2.0
powerpc64             randconfig-003-20241107    gcc-14.2.0
riscv                            allmodconfig    gcc-14.2.0
riscv                             allnoconfig    clang-20
riscv                             allnoconfig    gcc-14.2.0
riscv                            allyesconfig    gcc-14.2.0
riscv                               defconfig    clang-20
riscv                               defconfig    gcc-12
riscv             nommu_k210_sdcard_defconfig    clang-20
riscv                    nommu_virt_defconfig    gcc-14.2.0
riscv                 randconfig-001-20241106    gcc-14.2.0
riscv                 randconfig-001-20241107    gcc-14.2.0
riscv                 randconfig-002-20241106    gcc-14.2.0
riscv                 randconfig-002-20241107    gcc-14.2.0
s390                             allmodconfig    clang-20
s390                             allmodconfig    gcc-14.2.0
s390                              allnoconfig    clang-20
s390                             allyesconfig    gcc-14.2.0
s390                                defconfig    gcc-12
s390                  randconfig-001-20241106    gcc-14.2.0
s390                  randconfig-001-20241107    gcc-14.2.0
s390                  randconfig-002-20241106    gcc-14.2.0
s390                  randconfig-002-20241107    gcc-14.2.0
s390                       zfcpdump_defconfig    clang-20
s390                       zfcpdump_defconfig    gcc-14.2.0
sh                               allmodconfig    gcc-14.2.0
sh                                allnoconfig    gcc-14.2.0
sh                               allyesconfig    gcc-14.2.0
sh                        apsh4ad0a_defconfig    gcc-14.2.0
sh                                  defconfig    gcc-12
sh                ecovec24-romimage_defconfig    gcc-14.2.0
sh                         ecovec24_defconfig    clang-20
sh                        edosk7760_defconfig    clang-20
sh                          lboxre2_defconfig    gcc-14.2.0
sh                     magicpanelr2_defconfig    clang-20
sh                            migor_defconfig    gcc-14.2.0
sh                    randconfig-001-20241106    gcc-14.2.0
sh                    randconfig-001-20241107    gcc-14.2.0
sh                    randconfig-002-20241106    gcc-14.2.0
sh                    randconfig-002-20241107    gcc-14.2.0
sh                           se7712_defconfig    clang-20
sh                           se7721_defconfig    clang-20
sh                           se7750_defconfig    gcc-14.2.0
sh                   secureedge5410_defconfig    gcc-14.2.0
sh                           sh2007_defconfig    clang-20
sh                           sh2007_defconfig    gcc-14.2.0
sh                     sh7710voipgw_defconfig    gcc-14.2.0
sh                        sh7757lcr_defconfig    gcc-14.2.0
sh                        sh7763rdp_defconfig    gcc-14.2.0
sh                        sh7785lcr_defconfig    gcc-14.2.0
sh                          urquell_defconfig    gcc-14.2.0
sparc                            allmodconfig    gcc-14.2.0
sparc                       sparc32_defconfig    gcc-14.2.0
sparc64                             defconfig    gcc-12
sparc64               randconfig-001-20241106    gcc-14.2.0
sparc64               randconfig-001-20241107    gcc-14.2.0
sparc64               randconfig-002-20241106    gcc-14.2.0
sparc64               randconfig-002-20241107    gcc-14.2.0
um                               alldefconfig    clang-20
um                               alldefconfig    gcc-14.2.0
um                               allmodconfig    clang-20
um                                allnoconfig    clang-17
um                                allnoconfig    clang-20
um                               allyesconfig    clang-20
um                               allyesconfig    gcc-12
um                                  defconfig    gcc-12
um                             i386_defconfig    gcc-12
um                    randconfig-001-20241106    gcc-14.2.0
um                    randconfig-001-20241107    gcc-14.2.0
um                    randconfig-002-20241106    gcc-14.2.0
um                    randconfig-002-20241107    gcc-14.2.0
um                           x86_64_defconfig    gcc-12
x86_64                            allnoconfig    clang-19
x86_64                           allyesconfig    clang-19
x86_64      buildonly-randconfig-001-20241106    gcc-11
x86_64      buildonly-randconfig-001-20241107    clang-19
x86_64      buildonly-randconfig-002-20241106    gcc-11
x86_64      buildonly-randconfig-002-20241107    clang-19
x86_64      buildonly-randconfig-003-20241106    gcc-11
x86_64      buildonly-randconfig-003-20241107    clang-19
x86_64      buildonly-randconfig-004-20241106    gcc-11
x86_64      buildonly-randconfig-004-20241107    clang-19
x86_64      buildonly-randconfig-005-20241106    gcc-11
x86_64      buildonly-randconfig-005-20241107    clang-19
x86_64      buildonly-randconfig-006-20241106    gcc-11
x86_64      buildonly-randconfig-006-20241107    clang-19
x86_64                              defconfig    clang-19
x86_64                              defconfig    gcc-11
x86_64                                  kexec    clang-19
x86_64                                  kexec    gcc-12
x86_64                randconfig-001-20241106    gcc-11
x86_64                randconfig-001-20241107    clang-19
x86_64                randconfig-002-20241106    gcc-11
x86_64                randconfig-002-20241107    clang-19
x86_64                randconfig-003-20241106    gcc-11
x86_64                randconfig-003-20241107    clang-19
x86_64                randconfig-004-20241106    gcc-11
x86_64                randconfig-004-20241107    clang-19
x86_64                randconfig-005-20241106    gcc-11
x86_64                randconfig-005-20241107    clang-19
x86_64                randconfig-006-20241106    gcc-11
x86_64                randconfig-006-20241107    clang-19
x86_64                randconfig-011-20241106    gcc-11
x86_64                randconfig-011-20241107    clang-19
x86_64                randconfig-012-20241106    gcc-11
x86_64                randconfig-012-20241107    clang-19
x86_64                randconfig-013-20241106    gcc-11
x86_64                randconfig-013-20241107    clang-19
x86_64                randconfig-014-20241106    gcc-11
x86_64                randconfig-014-20241107    clang-19
x86_64                randconfig-015-20241106    gcc-11
x86_64                randconfig-015-20241107    clang-19
x86_64                randconfig-016-20241106    gcc-11
x86_64                randconfig-016-20241107    clang-19
x86_64                randconfig-071-20241106    gcc-11
x86_64                randconfig-071-20241107    clang-19
x86_64                randconfig-072-20241106    gcc-11
x86_64                randconfig-072-20241107    clang-19
x86_64                randconfig-073-20241106    gcc-11
x86_64                randconfig-073-20241107    clang-19
x86_64                randconfig-074-20241106    gcc-11
x86_64                randconfig-074-20241107    clang-19
x86_64                randconfig-075-20241106    gcc-11
x86_64                randconfig-075-20241107    clang-19
x86_64                randconfig-076-20241106    gcc-11
x86_64                randconfig-076-20241107    clang-19
x86_64                               rhel-8.3    gcc-12
x86_64                           rhel-8.3-bpf    clang-19
x86_64                         rhel-8.3-kunit    clang-19
x86_64                           rhel-8.3-ltp    clang-19
x86_64                          rhel-8.3-rust    clang-19
xtensa                            allnoconfig    gcc-14.2.0
xtensa                  audio_kc705_defconfig    gcc-14.2.0
xtensa                       common_defconfig    clang-20
xtensa                randconfig-001-20241106    gcc-14.2.0
xtensa                randconfig-001-20241107    gcc-14.2.0
xtensa                randconfig-002-20241106    gcc-14.2.0
xtensa                randconfig-002-20241107    gcc-14.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
