Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC27E82CA0
	for <linux-raid@archiver.kernel.org>; Fri, 29 Sep 2023 21:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjI2VyG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Sep 2023 17:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjI2VyF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Sep 2023 17:54:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406DEE6
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 14:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696024443; x=1727560443;
  h=date:from:to:cc:subject:message-id;
  bh=PzWvDsaW4wrrBvVLu6zz/hgR21SgSJb+3fPkVyob/XY=;
  b=dse4BQYlaQRKosIvEq7PPdcVLSepjYr2Ki81JfrGQnWNiEJ/7JwZ7gUw
   51VI29Cwa40R5KCuSUZ5UIA2+YpFL2/EIH5Q7wj5iEjmoQLEQsGaViriq
   wKrnXOvdoTVRdn3vjLjzXy089NuRuMU0jA/qgzOfoqlk3a6FMiLsWoOtv
   v6xEX3j0vgUDbH6gXo5VTAlWsdbj/xIFAX9v347GDEieTa+D+oK7xbqDY
   sa5esLSscZ5NCRI0HOUZrkjhNwBss5783QB3ZF1YWGbcGksGOfYXHANXq
   JzSZmmM8r8ZTEET/nO2qjHbbfirRo+twiCrpceq2AMggc9kVhZpehNSoP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="381267237"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="381267237"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 14:54:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="815724462"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="815724462"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 29 Sep 2023 14:54:00 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qmLQs-0003Ir-1g;
        Fri, 29 Sep 2023 21:53:58 +0000
Date:   Sat, 30 Sep 2023 05:53:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 09f894affcf2daac5aa841ffff43d1242215fd80
Message-ID: <202309300503.5Q8cNPz4-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 09f894affcf2daac5aa841ffff43d1242215fd80  md: do not require mddev_lock() for all options in array_state_store()

elapsed time: 1466m

configs tested: 212
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
arc                   randconfig-001-20230929   gcc  
arc                   randconfig-001-20230930   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                       netwinder_defconfig   clang
arm                          pxa168_defconfig   clang
arm                   randconfig-001-20230929   gcc  
arm                   randconfig-001-20230930   gcc  
arm64                            allmodconfig   gcc  
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
hexagon                          allyesconfig   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20230929   gcc  
i386         buildonly-randconfig-001-20230930   gcc  
i386         buildonly-randconfig-002-20230929   gcc  
i386         buildonly-randconfig-002-20230930   gcc  
i386         buildonly-randconfig-003-20230929   gcc  
i386         buildonly-randconfig-003-20230930   gcc  
i386         buildonly-randconfig-004-20230929   gcc  
i386         buildonly-randconfig-004-20230930   gcc  
i386         buildonly-randconfig-005-20230929   gcc  
i386         buildonly-randconfig-005-20230930   gcc  
i386         buildonly-randconfig-006-20230929   gcc  
i386         buildonly-randconfig-006-20230930   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                  randconfig-001-20230929   gcc  
i386                  randconfig-001-20230930   gcc  
i386                  randconfig-002-20230929   gcc  
i386                  randconfig-002-20230930   gcc  
i386                  randconfig-003-20230929   gcc  
i386                  randconfig-003-20230930   gcc  
i386                  randconfig-004-20230929   gcc  
i386                  randconfig-004-20230930   gcc  
i386                  randconfig-005-20230929   gcc  
i386                  randconfig-005-20230930   gcc  
i386                  randconfig-006-20230929   gcc  
i386                  randconfig-006-20230930   gcc  
i386                  randconfig-011-20230929   gcc  
i386                  randconfig-011-20230930   gcc  
i386                  randconfig-012-20230929   gcc  
i386                  randconfig-012-20230930   gcc  
i386                  randconfig-013-20230929   gcc  
i386                  randconfig-013-20230930   gcc  
i386                  randconfig-014-20230929   gcc  
i386                  randconfig-014-20230930   gcc  
i386                  randconfig-015-20230929   gcc  
i386                  randconfig-015-20230930   gcc  
i386                  randconfig-016-20230929   gcc  
i386                  randconfig-016-20230930   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20230929   gcc  
loongarch             randconfig-001-20230930   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                        mvme16x_defconfig   gcc  
m68k                           sun3_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                           ip22_defconfig   clang
mips                           mtx1_defconfig   clang
mips                        qi_lb60_defconfig   clang
mips                          rb532_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
openrisc                 simple_smp_defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   gcc  
powerpc                   currituck_defconfig   gcc  
powerpc                    ge_imp3a_defconfig   clang
powerpc                   microwatt_defconfig   clang
powerpc                 xes_mpc85xx_defconfig   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv             nommu_k210_sdcard_defconfig   gcc  
riscv                 randconfig-001-20230929   gcc  
riscv                 randconfig-001-20230930   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20230929   gcc  
s390                  randconfig-001-20230930   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                        edosk7760_defconfig   gcc  
sh                           se7619_defconfig   gcc  
sh                           se7722_defconfig   gcc  
sh                   secureedge5410_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                 randconfig-001-20230929   gcc  
sparc                 randconfig-001-20230930   gcc  
sparc64                          alldefconfig   gcc  
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
x86_64       buildonly-randconfig-001-20230929   gcc  
x86_64       buildonly-randconfig-001-20230930   gcc  
x86_64       buildonly-randconfig-002-20230929   gcc  
x86_64       buildonly-randconfig-002-20230930   gcc  
x86_64       buildonly-randconfig-003-20230929   gcc  
x86_64       buildonly-randconfig-003-20230930   gcc  
x86_64       buildonly-randconfig-004-20230929   gcc  
x86_64       buildonly-randconfig-004-20230930   gcc  
x86_64       buildonly-randconfig-005-20230929   gcc  
x86_64       buildonly-randconfig-005-20230930   gcc  
x86_64       buildonly-randconfig-006-20230929   gcc  
x86_64       buildonly-randconfig-006-20230930   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                randconfig-001-20230929   gcc  
x86_64                randconfig-001-20230930   gcc  
x86_64                randconfig-002-20230929   gcc  
x86_64                randconfig-002-20230930   gcc  
x86_64                randconfig-003-20230929   gcc  
x86_64                randconfig-003-20230930   gcc  
x86_64                randconfig-004-20230929   gcc  
x86_64                randconfig-004-20230930   gcc  
x86_64                randconfig-005-20230929   gcc  
x86_64                randconfig-005-20230930   gcc  
x86_64                randconfig-006-20230929   gcc  
x86_64                randconfig-006-20230930   gcc  
x86_64                randconfig-011-20230929   gcc  
x86_64                randconfig-011-20230930   gcc  
x86_64                randconfig-012-20230929   gcc  
x86_64                randconfig-012-20230930   gcc  
x86_64                randconfig-013-20230929   gcc  
x86_64                randconfig-013-20230930   gcc  
x86_64                randconfig-014-20230929   gcc  
x86_64                randconfig-014-20230930   gcc  
x86_64                randconfig-015-20230929   gcc  
x86_64                randconfig-015-20230930   gcc  
x86_64                randconfig-016-20230929   gcc  
x86_64                randconfig-016-20230930   gcc  
x86_64                randconfig-071-20230929   gcc  
x86_64                randconfig-071-20230930   gcc  
x86_64                randconfig-072-20230929   gcc  
x86_64                randconfig-072-20230930   gcc  
x86_64                randconfig-073-20230929   gcc  
x86_64                randconfig-073-20230930   gcc  
x86_64                randconfig-074-20230929   gcc  
x86_64                randconfig-074-20230930   gcc  
x86_64                randconfig-075-20230929   gcc  
x86_64                randconfig-075-20230930   gcc  
x86_64                randconfig-076-20230929   gcc  
x86_64                randconfig-076-20230930   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-func   gcc  
x86_64                    rhel-8.3-kselftests   gcc  
x86_64                         rhel-8.3-kunit   gcc  
x86_64                           rhel-8.3-ltp   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                              defconfig   gcc  
xtensa                    xip_kc705_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
