Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6834EB64D7
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jun 2023 01:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjF0B2t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Jun 2023 21:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjF0B2s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 26 Jun 2023 21:28:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1902E52
        for <linux-raid@vger.kernel.org>; Mon, 26 Jun 2023 18:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687829327; x=1719365327;
  h=date:from:to:cc:subject:message-id;
  bh=39e3jsSg+8/Q2Tz/ZO5ILHg61+jW+IPYiDTxK0ZN3cM=;
  b=h8Uq6AHukhKdf3PNZXGbXVvXbu/fYRfydREn/bhC1mEDzVEQE/vlw1pT
   x0cxLbKp+EtYsBvtOi8gDQlciDqc87L/MGY/LaP3PxCstpXCMQKYZmh3d
   +IyxZZ7G226rfjbcnRyF8gV1rfIdLqeDyFxRe4mGiaBPHUhpu5xOvKR/M
   +4koiNKILbEQyoK6ZOWpJmGoEhTtcRNqp0G0yPUZKNFNIEVTlCGwi1610
   k9oreFCDqut0RNohjTCDoEsphJsx7GvPh3qyDV4F9GyeFG5OfetxmncCK
   P8saHIBbQKUThONL7yiJ1pGzVswkQvJ+FTVIWqD3tqEjfWD73AB3jZrCM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="361481454"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="361481454"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 18:28:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="786392435"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="786392435"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jun 2023 18:28:46 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qDxVd-000BWl-2R;
        Tue, 27 Jun 2023 01:28:45 +0000
Date:   Tue, 27 Jun 2023 09:27:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 41fb72ee7eeda723e619c6918dffaf05a55fc7dd
Message-ID: <202306270946.WF2V3Dh9-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 41fb72ee7eeda723e619c6918dffaf05a55fc7dd  md/md-faulty: enable io accounting

elapsed time: 5496m

configs tested: 129
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r031-20230622   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r003-20230621   gcc  
arc                  randconfig-r014-20230622   gcc  
arc                  randconfig-r035-20230622   gcc  
arc                  randconfig-r036-20230622   gcc  
arc                  randconfig-r043-20230621   gcc  
arc                  randconfig-r043-20230622   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                      integrator_defconfig   gcc  
arm                          pxa3xx_defconfig   gcc  
arm                  randconfig-r046-20230621   gcc  
arm                  randconfig-r046-20230622   clang
arm                         s5pv210_defconfig   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r002-20230621   gcc  
arm64                randconfig-r012-20230622   gcc  
arm64                randconfig-r021-20230621   clang
csky                                defconfig   gcc  
csky                 randconfig-r001-20230621   gcc  
csky                 randconfig-r016-20230622   gcc  
hexagon              randconfig-r023-20230621   clang
hexagon              randconfig-r041-20230621   clang
hexagon              randconfig-r041-20230622   clang
hexagon              randconfig-r045-20230621   clang
hexagon              randconfig-r045-20230622   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230622   clang
i386         buildonly-randconfig-r005-20230622   clang
i386         buildonly-randconfig-r006-20230622   clang
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230621   gcc  
i386                 randconfig-i001-20230622   clang
i386                 randconfig-i002-20230621   gcc  
i386                 randconfig-i002-20230622   clang
i386                 randconfig-i003-20230621   gcc  
i386                 randconfig-i003-20230622   clang
i386                 randconfig-i004-20230621   gcc  
i386                 randconfig-i004-20230622   clang
i386                 randconfig-i005-20230621   gcc  
i386                 randconfig-i005-20230622   clang
i386                 randconfig-i006-20230621   gcc  
i386                 randconfig-i006-20230622   clang
i386                 randconfig-i011-20230621   clang
i386                 randconfig-i011-20230622   gcc  
i386                 randconfig-i012-20230621   clang
i386                 randconfig-i012-20230622   gcc  
i386                 randconfig-i013-20230621   clang
i386                 randconfig-i013-20230622   gcc  
i386                 randconfig-i014-20230621   clang
i386                 randconfig-i014-20230622   gcc  
i386                 randconfig-i015-20230621   clang
i386                 randconfig-i015-20230622   gcc  
i386                 randconfig-i016-20230621   clang
i386                 randconfig-i016-20230622   gcc  
i386                 randconfig-r033-20230622   clang
loongarch                        alldefconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r015-20230622   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                           ip22_defconfig   clang
mips                           ip28_defconfig   clang
mips                       lemote2f_defconfig   clang
mips                        qi_lb60_defconfig   clang
nios2                         3c120_defconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r024-20230621   gcc  
nios2                randconfig-r026-20230621   gcc  
openrisc             randconfig-r022-20230621   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r011-20230622   gcc  
parisc64                            defconfig   gcc  
powerpc                    adder875_defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                      cm5200_defconfig   gcc  
powerpc                     mpc512x_defconfig   clang
powerpc                  mpc885_ads_defconfig   clang
powerpc                     sequoia_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r005-20230621   gcc  
riscv                randconfig-r042-20230621   clang
riscv                randconfig-r042-20230622   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r034-20230622   clang
s390                 randconfig-r044-20230621   clang
s390                 randconfig-r044-20230622   gcc  
sh                               allmodconfig   gcc  
sh                               j2_defconfig   gcc  
sh                   randconfig-r006-20230621   gcc  
sh                           se7343_defconfig   gcc  
sh                           se7780_defconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r032-20230622   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230622   clang
x86_64       buildonly-randconfig-r002-20230622   clang
x86_64       buildonly-randconfig-r003-20230622   clang
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
