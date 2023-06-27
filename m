Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B61EB64D7
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jun 2023 01:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjF0BKg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Jun 2023 21:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjF0BKf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 26 Jun 2023 21:10:35 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAB3E7F
        for <linux-raid@vger.kernel.org>; Mon, 26 Jun 2023 18:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687828234; x=1719364234;
  h=date:from:to:cc:subject:message-id;
  bh=Be/SDHcIOwkjgTK4/zmBcDknc8BKa0R5pZJ7jyuL/zM=;
  b=i2ucEdHwHsTs0bzteB6k/NZXE4/zKMSTNvXWFkE1ygsb30UJ1xxPnHuy
   peEGrDAu4MEiFGmtrrLFYc0uc2mNnVzWrMvEkweG7ojoyGSFbvZQH4Lde
   v9EiaO9xFp7cfJrtueQah242SAMOm2Wlk+JNAJnq5+gsZjNST2LyApMIy
   q/xD5iWYLlusBETkMBWlpLw9Ln23RicPPDqWk3svGmM978JSZuoxz1E71
   Br+XqkCJrtmdBoklJlqxzV6ot4X0f3QSrcWmFNUhpOHwAjplOR4Zj2LLt
   kYFMwx3Wi7oWUEMhpBsNRmC1Qsyx3COuH/j0GGBOablqEd53/Br/C7Gaf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="447820870"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="447820870"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 18:10:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="840490387"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="840490387"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 26 Jun 2023 18:10:33 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qDxE0-000B9F-1T;
        Tue, 27 Jun 2023 01:10:32 +0000
Date:   Tue, 27 Jun 2023 09:09:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-for-6.5] BUILD SUCCESS
 a8d5fdd4d2702d0c7ec125bd3bbce3fc589afa67
Message-ID: <202306270946.quDAyvI4-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-for-6.5
branch HEAD: a8d5fdd4d2702d0c7ec125bd3bbce3fc589afa67  raid10: avoid spin_lock from fastpath from raid10_unplug()

elapsed time: 4798m

configs tested: 116
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r022-20230622   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r003-20230622   gcc  
arc                  randconfig-r013-20230622   gcc  
arc                  randconfig-r043-20230622   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                       imx_v4_v5_defconfig   clang
arm                      integrator_defconfig   gcc  
arm                            mmp2_defconfig   clang
arm                        multi_v7_defconfig   gcc  
arm                  randconfig-r046-20230622   clang
arm                         s5pv210_defconfig   clang
arm                           sama5_defconfig   gcc  
arm                        vexpress_defconfig   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r001-20230622   clang
arm64                randconfig-r011-20230622   gcc  
arm64                randconfig-r023-20230622   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r034-20230623   clang
hexagon              randconfig-r041-20230622   clang
hexagon              randconfig-r045-20230622   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230621   gcc  
i386         buildonly-randconfig-r005-20230621   gcc  
i386         buildonly-randconfig-r006-20230621   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230622   clang
i386                 randconfig-i002-20230622   clang
i386                 randconfig-i003-20230622   clang
i386                 randconfig-i004-20230622   clang
i386                 randconfig-i005-20230622   clang
i386                 randconfig-i006-20230622   clang
i386                 randconfig-i011-20230622   gcc  
i386                 randconfig-i012-20230622   gcc  
i386                 randconfig-i013-20230622   gcc  
i386                 randconfig-i014-20230622   gcc  
i386                 randconfig-i015-20230622   gcc  
i386                 randconfig-i016-20230622   gcc  
i386                 randconfig-r032-20230623   gcc  
i386                 randconfig-r036-20230623   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r005-20230622   gcc  
loongarch            randconfig-r016-20230622   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r024-20230622   gcc  
microblaze           randconfig-r033-20230623   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                           ip22_defconfig   clang
mips                           ip28_defconfig   clang
mips                        qi_lb60_defconfig   clang
nios2                               defconfig   gcc  
openrisc             randconfig-r004-20230622   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                    adder875_defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                      cm5200_defconfig   gcc  
powerpc                 mpc8315_rdb_defconfig   clang
powerpc               mpc834x_itxgp_defconfig   clang
powerpc                  mpc885_ads_defconfig   clang
powerpc              randconfig-r012-20230622   gcc  
powerpc                     sequoia_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                    nommu_virt_defconfig   clang
riscv                randconfig-r035-20230623   gcc  
riscv                randconfig-r042-20230622   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r006-20230622   clang
s390                 randconfig-r014-20230622   gcc  
s390                 randconfig-r021-20230622   gcc  
s390                 randconfig-r026-20230622   gcc  
s390                 randconfig-r044-20230622   gcc  
sh                               allmodconfig   gcc  
sh                         ecovec24_defconfig   gcc  
sh                          rsk7203_defconfig   gcc  
sh                           se7619_defconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r015-20230622   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230621   gcc  
x86_64       buildonly-randconfig-r002-20230621   gcc  
x86_64       buildonly-randconfig-r003-20230621   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r002-20230622   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r031-20230623   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
