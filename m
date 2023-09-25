Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10763CE7A95
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 02:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjIYClf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 24 Sep 2023 22:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjIYCle (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 24 Sep 2023 22:41:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96F7A3
        for <linux-raid@vger.kernel.org>; Sun, 24 Sep 2023 19:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695609687; x=1727145687;
  h=date:from:to:cc:subject:message-id;
  bh=MIO7hZiQjmNu70mLh0Dpmf5Qd8T9DlrYDpUYrAYccWY=;
  b=AlO+lFtEhVKk1TfJ1j3kJx1MTu25HkyWLgFMtm86d/dnxE9iYvZpu9uo
   /eeBMIH85A6xf+Jyxb08yh/wC6i5DqxwmUmEDHpXWxMxusIYBoB31DwS4
   Ot4NC9RlopLLVFWjwrzrqKIaUFNGgbwPcR3E89K5cnpB4e2pzp+p54cWq
   fb7b058L4Cj7DHvRYd59vCvi9OQ7ScMJjKa9E4byJipEwAX0ln2AbpPZy
   KhKyo7SrWe/RB9XWGyQPU5AFuE65vCXEqMWXo0k0mdsaBFoV5QIdlHIjO
   2NSWJsspU5Cyt5DRMj48la/6HUivExoBYoAFU0hM7n70xurWVycUh5eRj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="445254472"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="445254472"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 19:41:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="697833609"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="697833609"
Received: from lkp-server02.sh.intel.com (HELO 32c80313467c) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 24 Sep 2023 19:41:24 -0700
Received: from kbuild by 32c80313467c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qkbXG-0000yp-1F;
        Mon, 25 Sep 2023 02:41:22 +0000
Date:   Mon, 25 Sep 2023 10:41:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 2ba70b8d2990157e3926de7c2160e35ba2998b95
Message-ID: <202309251008.odDO5TKd-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 2ba70b8d2990157e3926de7c2160e35ba2998b95  md: fix potential hang for mddev_suspend()

elapsed time: 3094m

configs tested: 199
configs skipped: 2

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
arc                     nsimosci_hs_defconfig   gcc  
arc                   randconfig-001-20230923   gcc  
arc                        vdk_hs38_defconfig   gcc  
arc                    vdk_hs38_smp_defconfig   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                              allyesconfig   gcc  
arm                       aspeed_g4_defconfig   clang
arm                                 defconfig   gcc  
arm                   randconfig-001-20230923   gcc  
arm                   randconfig-001-20230925   gcc  
arm                           u8500_defconfig   gcc  
arm                         vf610m4_defconfig   gcc  
arm64                            allmodconfig   gcc  
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20230923   gcc  
i386         buildonly-randconfig-002-20230923   gcc  
i386         buildonly-randconfig-003-20230923   gcc  
i386         buildonly-randconfig-004-20230923   gcc  
i386         buildonly-randconfig-005-20230923   gcc  
i386         buildonly-randconfig-006-20230923   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                  randconfig-001-20230923   gcc  
i386                  randconfig-001-20230925   gcc  
i386                  randconfig-002-20230923   gcc  
i386                  randconfig-002-20230925   gcc  
i386                  randconfig-003-20230923   gcc  
i386                  randconfig-003-20230925   gcc  
i386                  randconfig-004-20230923   gcc  
i386                  randconfig-004-20230925   gcc  
i386                  randconfig-005-20230923   gcc  
i386                  randconfig-005-20230925   gcc  
i386                  randconfig-006-20230923   gcc  
i386                  randconfig-006-20230925   gcc  
i386                  randconfig-011-20230923   gcc  
i386                  randconfig-011-20230925   gcc  
i386                  randconfig-012-20230923   gcc  
i386                  randconfig-012-20230925   gcc  
i386                  randconfig-013-20230923   gcc  
i386                  randconfig-013-20230925   gcc  
i386                  randconfig-014-20230923   gcc  
i386                  randconfig-014-20230925   gcc  
i386                  randconfig-015-20230923   gcc  
i386                  randconfig-015-20230925   gcc  
i386                  randconfig-016-20230923   gcc  
i386                  randconfig-016-20230925   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20230923   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                       bmips_be_defconfig   gcc  
mips                           ip32_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   clang
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   gcc  
powerpc                       maple_defconfig   gcc  
powerpc                     mpc83xx_defconfig   gcc  
powerpc                      pmac32_defconfig   clang
powerpc                     stx_gp3_defconfig   gcc  
powerpc                     tqm8548_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                    nommu_k210_defconfig   gcc  
riscv                 randconfig-001-20230923   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20230923   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                         apsh4a3a_defconfig   gcc  
sh                                  defconfig   gcc  
sh                      rts7751r2d1_defconfig   gcc  
sh                           se7206_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                 randconfig-001-20230923   gcc  
sparc                 randconfig-001-20230925   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-001-20230923   gcc  
x86_64       buildonly-randconfig-001-20230925   gcc  
x86_64       buildonly-randconfig-002-20230923   gcc  
x86_64       buildonly-randconfig-002-20230925   gcc  
x86_64       buildonly-randconfig-003-20230923   gcc  
x86_64       buildonly-randconfig-003-20230925   gcc  
x86_64       buildonly-randconfig-004-20230923   gcc  
x86_64       buildonly-randconfig-004-20230925   gcc  
x86_64       buildonly-randconfig-005-20230923   gcc  
x86_64       buildonly-randconfig-005-20230925   gcc  
x86_64       buildonly-randconfig-006-20230923   gcc  
x86_64       buildonly-randconfig-006-20230925   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                randconfig-001-20230923   gcc  
x86_64                randconfig-001-20230925   gcc  
x86_64                randconfig-002-20230923   gcc  
x86_64                randconfig-002-20230925   gcc  
x86_64                randconfig-003-20230923   gcc  
x86_64                randconfig-003-20230925   gcc  
x86_64                randconfig-004-20230923   gcc  
x86_64                randconfig-004-20230925   gcc  
x86_64                randconfig-005-20230923   gcc  
x86_64                randconfig-005-20230925   gcc  
x86_64                randconfig-006-20230923   gcc  
x86_64                randconfig-006-20230925   gcc  
x86_64                randconfig-011-20230924   gcc  
x86_64                randconfig-011-20230925   gcc  
x86_64                randconfig-012-20230924   gcc  
x86_64                randconfig-012-20230925   gcc  
x86_64                randconfig-013-20230924   gcc  
x86_64                randconfig-013-20230925   gcc  
x86_64                randconfig-014-20230924   gcc  
x86_64                randconfig-014-20230925   gcc  
x86_64                randconfig-015-20230924   gcc  
x86_64                randconfig-015-20230925   gcc  
x86_64                randconfig-016-20230924   gcc  
x86_64                randconfig-016-20230925   gcc  
x86_64                randconfig-071-20230923   gcc  
x86_64                randconfig-071-20230925   gcc  
x86_64                randconfig-072-20230923   gcc  
x86_64                randconfig-072-20230925   gcc  
x86_64                randconfig-073-20230923   gcc  
x86_64                randconfig-073-20230925   gcc  
x86_64                randconfig-074-20230923   gcc  
x86_64                randconfig-074-20230925   gcc  
x86_64                randconfig-075-20230923   gcc  
x86_64                randconfig-075-20230925   gcc  
x86_64                randconfig-076-20230923   gcc  
x86_64                randconfig-076-20230925   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-func   gcc  
x86_64                    rhel-8.3-kselftests   gcc  
x86_64                         rhel-8.3-kunit   gcc  
x86_64                           rhel-8.3-ltp   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                  nommu_kc705_defconfig   gcc  
xtensa                    smp_lx200_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
