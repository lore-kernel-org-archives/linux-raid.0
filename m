Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3588C77B72
	for <linux-raid@archiver.kernel.org>; Fri, 14 Apr 2023 21:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjDNVN7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Apr 2023 17:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDNVN6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 Apr 2023 17:13:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901CF559D
        for <linux-raid@vger.kernel.org>; Fri, 14 Apr 2023 14:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681506837; x=1713042837;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=3KuCaPu+OuVJjE66ctiNQ4MckCFYgefIUVhyRZ6Wvuw=;
  b=hIZd4Q3ZbGwm2pXOfLVdy4Tx/eReiQXTkTIPd9c/98kJ5AKuUc1dY9IK
   odVSo0583ly5Gqpi0E2tWLOTWcEsu/1CeQTy10BV4+Hp1fofg4PjGn40R
   3gx84vigbhqli6FlcnqNA7AiL9HH8DMH/Mvnn5XZ0+K3GVqLIyo0R0CoJ
   AUsh9+vgQIG7OjrVQUBQaXQv4PpLuE1eDnKdj23NGAG+7PPCmvtfY1LE3
   Pz82v8TTip1Zn8zj8R40u3vesd5H2+3G+S4zCTJoWFn/5cxDJmguppNiK
   eY8MTNjEF1VTwtUjHOWw6vAYbnNEFpvijK2M5JcRL8BzdWpHNDquzseJ2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="407457549"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="407457549"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 14:13:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="814035674"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="814035674"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 14 Apr 2023 14:13:55 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pnQjt-000Zyb-2j;
        Fri, 14 Apr 2023 21:13:49 +0000
Date:   Sat, 15 Apr 2023 05:12:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 7bc436121e557b1f5bebf5ad67e7ed3614d6df92
Message-ID: <6439c1d4.6TfflZ5H3jZIC61o%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 7bc436121e557b1f5bebf5ad67e7ed3614d6df92  md/raid5: remove unused working_disks variable

elapsed time: 724m

configs tested: 96
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r013-20230410   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r005-20230409   clang
arm                                 defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r015-20230413   clang
csky         buildonly-randconfig-r001-20230409   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r015-20230409   gcc  
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230410   clang
i386                 randconfig-a002-20230410   clang
i386                 randconfig-a003-20230410   clang
i386                 randconfig-a004-20230410   clang
i386                 randconfig-a005-20230410   clang
i386                 randconfig-a006-20230410   clang
i386                          randconfig-a011   clang
i386                          randconfig-a012   gcc  
i386                          randconfig-a013   clang
i386                          randconfig-a014   gcc  
i386                          randconfig-a015   clang
i386                          randconfig-a016   gcc  
ia64                             allmodconfig   gcc  
ia64         buildonly-randconfig-r003-20230410   gcc  
ia64                                defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r001-20230410   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r002-20230409   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r016-20230409   gcc  
microblaze   buildonly-randconfig-r006-20230409   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r012-20230410   clang
mips                 randconfig-r014-20230413   gcc  
nios2        buildonly-randconfig-r002-20230410   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r011-20230409   gcc  
nios2                randconfig-r013-20230409   gcc  
nios2                randconfig-r015-20230410   gcc  
nios2                randconfig-r016-20230410   gcc  
parisc       buildonly-randconfig-r002-20230414   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r011-20230410   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r004-20230414   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r014-20230410   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r003-20230409   gcc  
s390                                defconfig   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r011-20230413   gcc  
sparc        buildonly-randconfig-r004-20230410   gcc  
sparc        buildonly-randconfig-r006-20230410   gcc  
sparc                               defconfig   gcc  
sparc64      buildonly-randconfig-r003-20230414   gcc  
sparc64              randconfig-r016-20230413   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230410   clang
x86_64               randconfig-a002-20230410   clang
x86_64               randconfig-a003-20230410   clang
x86_64               randconfig-a004-20230410   clang
x86_64               randconfig-a005-20230410   clang
x86_64               randconfig-a006-20230410   clang
x86_64               randconfig-a011-20230410   gcc  
x86_64               randconfig-a012-20230410   gcc  
x86_64               randconfig-a013-20230410   gcc  
x86_64               randconfig-a014-20230410   gcc  
x86_64               randconfig-a015-20230410   gcc  
x86_64               randconfig-a016-20230410   gcc  
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r001-20230414   gcc  
xtensa       buildonly-randconfig-r006-20230414   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
