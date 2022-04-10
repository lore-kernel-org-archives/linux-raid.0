Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6CBC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 10 Apr 2022 02:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiDJCCn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Apr 2022 22:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiDJCCl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Apr 2022 22:02:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99F22E69E
        for <linux-raid@vger.kernel.org>; Sat,  9 Apr 2022 19:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649556031; x=1681092031;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ceV0So7COUVjPg8SYQFSl/tO5kd1aKvkXzFlSrNHPzc=;
  b=cyKVzThLkG6crEcYExk4qDONIPN/SLtloGaWVK8vaGzyrRIjetTEegc0
   Yu0v72m/Zyg7vOYCdewmIk1UoMoQx2d8IzGbU+SzMoKGmFd7UUmqRQD1m
   QY4mgG35MJGR99VKd34PbjxiXPublGS5ePNiiWdN9/TbdLCMxbQaKk3X/
   PIQppPIGBdtuLhqq5Dj7UBzqCCxHlGGQvSxzerrkfQgkHS84yBhf3NkAJ
   mlOKSscSJ0eqJTwYaeo58leX55maH+v1waD/SuuF0w07GNIFWJEcF9VFj
   9yXVc07CXz1PhTDfx93ygJuHaKls2XEIQDWe5QjjE6ERfXmXSDU5iWwF0
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10312"; a="286930586"
X-IronPort-AV: E=Sophos;i="5.90,248,1643702400"; 
   d="scan'208";a="286930586"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2022 19:00:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,248,1643702400"; 
   d="scan'208";a="799931936"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 09 Apr 2022 19:00:30 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ndMsP-0000ai-Q6;
        Sun, 10 Apr 2022 02:00:29 +0000
Date:   Sun, 10 Apr 2022 10:00:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 90a377574171b9d9f9c9474332fd55fa328e2701
Message-ID: <62523a32.efuuH57M4IuFcdpJ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 90a377574171b9d9f9c9474332fd55fa328e2701  md/raid5: Annotate functions that hold device_lock with __must_hold

elapsed time: 721m

configs tested: 143
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                               defconfig
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
arm                              allmodconfig
powerpc              randconfig-c003-20220410
i386                          randconfig-c001
powerpc                      ppc40x_defconfig
powerpc64                        alldefconfig
m68k                            q40_defconfig
m68k                        mvme147_defconfig
arm                       multi_v4t_defconfig
sh                             sh03_defconfig
xtensa                           allyesconfig
sparc                       sparc32_defconfig
xtensa                  audio_kc705_defconfig
ia64                         bigsur_defconfig
sh                           sh2007_defconfig
mips                        vocore2_defconfig
m68k                         apollo_defconfig
powerpc                    adder875_defconfig
arm                           imxrt_defconfig
powerpc                 mpc85xx_cds_defconfig
powerpc                      chrp32_defconfig
powerpc                      pasemi_defconfig
arm                        mvebu_v7_defconfig
arm                            zeus_defconfig
x86_64                              defconfig
arc                        vdk_hs38_defconfig
powerpc                 canyonlands_defconfig
openrisc                    or1ksim_defconfig
sh                          lboxre2_defconfig
sh                          sdk7786_defconfig
mips                            gpr_defconfig
sh                        edosk7760_defconfig
arm                        realview_defconfig
powerpc                     sequoia_defconfig
mips                         mpc30x_defconfig
mips                         cobalt_defconfig
mips                      fuloong2e_defconfig
xtensa                         virt_defconfig
m68k                       m5249evb_defconfig
xtensa                              defconfig
arm                            xcep_defconfig
sh                         ecovec24_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220410
ia64                             allmodconfig
ia64                             allyesconfig
ia64                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
nios2                               defconfig
arc                              allyesconfig
csky                                defconfig
nios2                            allyesconfig
alpha                               defconfig
alpha                            allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                                defconfig
s390                             allmodconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                             allyesconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
sparc                               defconfig
i386                             allyesconfig
sparc                            allyesconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
arc                  randconfig-r043-20220409
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
riscv                               defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
riscv                            allmodconfig
riscv                            allyesconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                          rhel-8.3-func
x86_64                                  kexec
x86_64                           allyesconfig
x86_64                         rhel-8.3-kunit
x86_64                               rhel-8.3

clang tested configs:
x86_64                        randconfig-c007
powerpc              randconfig-c003-20220410
arm                  randconfig-c002-20220410
i386                          randconfig-c001
riscv                randconfig-c006-20220410
mips                 randconfig-c004-20220410
powerpc              randconfig-c003-20220409
riscv                randconfig-c006-20220409
mips                 randconfig-c004-20220409
arm                  randconfig-c002-20220409
mips                        qi_lb60_defconfig
arm                          imote2_defconfig
powerpc                 mpc832x_mds_defconfig
arm                       aspeed_g4_defconfig
powerpc                      ppc64e_defconfig
powerpc                     skiroot_defconfig
powerpc                     mpc512x_defconfig
mips                     cu1000-neo_defconfig
arm                       imx_v4_v5_defconfig
arm                          moxart_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a011
i386                          randconfig-a013
i386                          randconfig-a015
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
hexagon              randconfig-r041-20220409
s390                 randconfig-r044-20220409
riscv                randconfig-r042-20220409
hexagon              randconfig-r045-20220409
riscv                randconfig-r042-20220410
hexagon              randconfig-r041-20220410
hexagon              randconfig-r045-20220410

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
