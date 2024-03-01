Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6226BFDD
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 11:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709292428; cv=none; b=nHn8aX8jvwNhwxt0ZpA24Ffyav1l4/Rr4fSD0G7eQRrkr3qUW3XlI4uYh4NTY4Iny73Va00lpI9QlMJMCd6GXm0j4hnAoy4t7D5KIJl9eIiu5KnYTLvPyfsjZOt2jXuLvZ9Z9VVEJXIkgRMB7ccxEMqYpCauUusfwrGkAEboJ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709292428; c=relaxed/simple;
	bh=xb4e4UNVOMTggcfDZ0jcdp2OAH7HgqYkVJdt8WkyCzA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=jyb70HcWQ9Ye5miOY637Esc4vWXhUypliT9RKHla5VlZsjmb2Es0Z8mVU1J6UQSO3+Y0nnF34CWJC4MKE6Dh7N8bROEkBjRcmiT7NFRbLsIiwUS30FA0z81/tPeCAKwB93NwuQ5FGJIC5jVbKntssIommrzm/Hj+sht1D470fPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kixqectq; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kixqectq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709292427; x=1740828427;
  h=date:from:to:cc:subject:message-id;
  bh=xb4e4UNVOMTggcfDZ0jcdp2OAH7HgqYkVJdt8WkyCzA=;
  b=kixqectqMLs3BOrtPZRThE2ec7PgKGRKPO5GBXdwMTyu2YBT9H/yzsQ9
   cQsjb2xMVnH3wINKHtRJFwohTj1n4Yoxm1MoTjcjEAeZb1Dj8FWv5xAIG
   DLowIEMk1Wl2tolYopAQeC/FnaxTH66HCFyfARTNMAkOtITzcDfrHW4v+
   Zm0wklyWfCFnO3VRL+8GR83pNmKqzg26fvXdzlKd8VKNcBXvf3RwLMuAf
   FsQ/0xXuIC1kzsy36I0JJuc3GxF4D4Ak4czyoHdHrS1mgTfoJz4QGSGy/
   aJ8/21FpwrxfydINoGMXNlbtUXQfD2vJ7TfLxf+4FERwx0zGR3uBpLhFm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3712167"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="3712167"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:27:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="45706589"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 01 Mar 2024 03:27:05 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rg12c-000Dor-3C;
	Fri, 01 Mar 2024 11:27:02 +0000
Date: Fri, 01 Mar 2024 19:26:11 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [song-md:md-6.9-for-hch] BUILD SUCCESS
 36928e9812eb6ecd4074787c296ddcc451b9beeb
Message-ID: <202403011908.nW9ffekL-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-6.9-for-hch
branch HEAD: 36928e9812eb6ecd4074787c296ddcc451b9beeb  md/raid5: Don't check crossing reshape when reshape hasn't started

elapsed time: 725m

configs tested: 126
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
arc                   randconfig-001-20240301   gcc  
arc                   randconfig-002-20240301   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                                 defconfig   clang
arm                   randconfig-001-20240301   gcc  
arm                   randconfig-002-20240301   clang
arm                   randconfig-003-20240301   gcc  
arm                   randconfig-004-20240301   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240301   gcc  
arm64                 randconfig-002-20240301   clang
arm64                 randconfig-003-20240301   gcc  
arm64                 randconfig-004-20240301   clang
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240301   gcc  
csky                  randconfig-002-20240301   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20240301   clang
hexagon               randconfig-002-20240301   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240301   clang
i386         buildonly-randconfig-002-20240301   clang
i386         buildonly-randconfig-003-20240301   gcc  
i386         buildonly-randconfig-004-20240301   clang
i386         buildonly-randconfig-005-20240301   clang
i386         buildonly-randconfig-006-20240301   clang
i386                                defconfig   clang
i386                  randconfig-001-20240301   clang
i386                  randconfig-002-20240301   clang
i386                  randconfig-003-20240301   clang
i386                  randconfig-004-20240301   clang
i386                  randconfig-005-20240301   gcc  
i386                  randconfig-006-20240301   gcc  
i386                  randconfig-011-20240301   gcc  
i386                  randconfig-012-20240301   clang
i386                  randconfig-013-20240301   clang
i386                  randconfig-014-20240301   gcc  
i386                  randconfig-015-20240301   gcc  
i386                  randconfig-016-20240301   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240301   gcc  
loongarch             randconfig-002-20240301   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240301   gcc  
nios2                 randconfig-002-20240301   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240301   gcc  
parisc                randconfig-002-20240301   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc               randconfig-001-20240301   gcc  
powerpc               randconfig-002-20240301   gcc  
powerpc               randconfig-003-20240301   clang
powerpc64             randconfig-001-20240301   clang
powerpc64             randconfig-002-20240301   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64                              defconfig   gcc  
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
