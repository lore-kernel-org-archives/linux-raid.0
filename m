Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F5FEB64DD
	for <linux-raid@archiver.kernel.org>; Sun, 30 Jul 2023 04:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjG3EbK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 30 Jul 2023 00:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjG3EbI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 30 Jul 2023 00:31:08 -0400
Received: from mgamail.intel.com (unknown [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB00019BA
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 21:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690691466; x=1722227466;
  h=date:from:to:cc:subject:message-id;
  bh=hR2/MZtoMyjnFjhuy6wnfNtEYW1AImkO3H80dsxu0/Y=;
  b=Cq1HVwYzOcyknywYQ+tl0odxZx5wL3nwA+KYGwFAed5bwX8tQQs20auz
   ZpB3caa9w5qEUx1Iy42Qe9G/xmGLA4Di9GJbV/inCiZC8HdA+WeLMhMdg
   sYjyyCk/z2T0MPn4wHZ8ZEpGwi8RamXKrLaS+EuVdRnWWmER8nKB6UsgB
   MUKuMxIvfjdHykL+Vg9PilJDlVcqT/WpefggkYGaoqzRtDDQS73v1Av4L
   IY08e36uV8TckGr+O72icceNj0HWPbXWYaOAd6A3ANenvoLyrspcUMeGw
   w110DQQK5wmfbKH7ijdXgfpY+Dd72vK1nEGwNH49uaIjBQpnK6Y7jBWFy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10786"; a="372443408"
X-IronPort-AV: E=Sophos;i="6.01,240,1684825200"; 
   d="scan'208";a="372443408"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2023 21:31:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10786"; a="721684530"
X-IronPort-AV: E=Sophos;i="6.01,240,1684825200"; 
   d="scan'208";a="721684530"
Received: from lkp-server02.sh.intel.com (HELO 953e8cd98f7d) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 29 Jul 2023 21:31:05 -0700
Received: from kbuild by 953e8cd98f7d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qPy5A-0004RR-0n;
        Sun, 30 Jul 2023 04:31:04 +0000
Date:   Sun, 30 Jul 2023 12:30:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 07e62cc3a340f69c669cae05255a6a0182a0226b
Message-ID: <202307301204.Y0035yzZ-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 07e62cc3a340f69c669cae05255a6a0182a0226b  md/raid5-cache: fix a deadlock in r5l_exit_log()

elapsed time: 1054m

configs tested: 124
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r015-20230729   gcc  
arc                  randconfig-r043-20230729   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                         orion5x_defconfig   clang
arm                          pxa168_defconfig   clang
arm                  randconfig-r046-20230729   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r033-20230729   clang
csky                                defconfig   gcc  
csky                 randconfig-r026-20230729   gcc  
hexagon                             defconfig   clang
hexagon              randconfig-r006-20230728   clang
hexagon              randconfig-r041-20230729   clang
hexagon              randconfig-r045-20230729   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230728   gcc  
i386         buildonly-randconfig-r005-20230728   gcc  
i386         buildonly-randconfig-r006-20230728   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230729   clang
i386                 randconfig-i002-20230729   clang
i386                 randconfig-i003-20230729   clang
i386                 randconfig-i004-20230729   clang
i386                 randconfig-i005-20230729   clang
i386                 randconfig-i006-20230729   clang
i386                 randconfig-i011-20230729   gcc  
i386                 randconfig-i012-20230729   gcc  
i386                 randconfig-i013-20230729   gcc  
i386                 randconfig-i014-20230729   gcc  
i386                 randconfig-i015-20230729   gcc  
i386                 randconfig-i016-20230729   gcc  
i386                 randconfig-r005-20230728   gcc  
i386                 randconfig-r012-20230729   gcc  
i386                 randconfig-r024-20230729   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r035-20230729   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r011-20230729   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                          ath79_defconfig   clang
mips                         cobalt_defconfig   gcc  
mips                      maltaaprp_defconfig   clang
mips                           mtx1_defconfig   clang
mips                 randconfig-r001-20230728   clang
mips                           rs90_defconfig   clang
nios2                               defconfig   gcc  
nios2                randconfig-r002-20230728   gcc  
openrisc                    or1ksim_defconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r003-20230728   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                   lite5200b_defconfig   clang
powerpc              randconfig-r013-20230729   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r036-20230729   clang
riscv                randconfig-r042-20230729   gcc  
riscv                          rv32_defconfig   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r044-20230729   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r004-20230728   gcc  
sh                   randconfig-r021-20230729   gcc  
sh                   randconfig-r034-20230729   gcc  
sh                   sh7724_generic_defconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r025-20230729   gcc  
sparc                randconfig-r031-20230729   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                   randconfig-r022-20230729   clang
um                   randconfig-r023-20230729   clang
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230728   gcc  
x86_64       buildonly-randconfig-r002-20230728   gcc  
x86_64       buildonly-randconfig-r003-20230728   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-x001-20230728   clang
x86_64               randconfig-x002-20230728   clang
x86_64               randconfig-x003-20230728   clang
x86_64               randconfig-x004-20230728   clang
x86_64               randconfig-x005-20230728   clang
x86_64               randconfig-x006-20230728   clang
x86_64               randconfig-x011-20230728   gcc  
x86_64               randconfig-x012-20230728   gcc  
x86_64               randconfig-x013-20230728   gcc  
x86_64               randconfig-x014-20230728   gcc  
x86_64               randconfig-x015-20230728   gcc  
x86_64               randconfig-x016-20230728   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-func   gcc  
x86_64                    rhel-8.3-kselftests   gcc  
x86_64                         rhel-8.3-kunit   gcc  
x86_64                           rhel-8.3-ltp   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                       common_defconfig   gcc  
xtensa                          iss_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
