Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DA4C7EE32
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 06:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbjEXGyM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 02:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbjEXGxT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 02:53:19 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DACE6
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 23:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684911173; x=1716447173;
  h=date:from:to:cc:subject:message-id;
  bh=d3keSUNOUa/sn6vRYQuLMMUGqWOLq/A+UU3HBtWpfbM=;
  b=B6czTtgkQ+SUkcdAyH3pScrif8HKWoSl+sA5PP7yXlaOa5zVOQJauaIl
   V29PPZ0ys3BTtRrOUijoefAqhdMbvZeQYAOXDU3saQ39t7n7ugH1XSmnt
   g8IVCg8pg0AdHfNbK4HnV0042iwY5Gz9KpdYQc5ze3JLjRtgevgkl4nqc
   9aFcZ/OL/KiTuxRMbc9/o/7Ni46F7MGecPQNLbDKezMuXclB7rW+gZPec
   jLGQARBR5GeMHafdtByp/33yvtaUZ9b9tGE4wxHjI+L7td6NEKb5s5QoU
   2RbU3YyxuXyRNlls+9SrkEYoaOdXi05ZM7r8+LvPLxzhQgGW7LMuuTJnH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="352321475"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="352321475"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 23:52:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="794063905"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="794063905"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 23 May 2023 23:52:51 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q1iMd-000EVi-0z;
        Wed, 24 May 2023 06:52:51 +0000
Date:   Wed, 24 May 2023 14:52:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 c7190ff4e4919ea20c27107a199b151cc24f9840
Message-ID: <20230524065233.I4nWW%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: INFO setup_repo_specs: /db/releases/20230524121217/lkp-src/repo/*/song-md
git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: c7190ff4e4919ea20c27107a199b151cc24f9840  md: protect md_thread with rcu

elapsed time: 723m

configs tested: 186
configs skipped: 18

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r005-20230521   gcc  
alpha                randconfig-r006-20230522   gcc  
alpha                randconfig-r013-20230521   gcc  
alpha                randconfig-r013-20230523   gcc  
alpha                randconfig-r014-20230523   gcc  
alpha                randconfig-r025-20230521   gcc  
alpha                randconfig-r035-20230522   gcc  
arc                              allyesconfig   gcc  
arc                          axs101_defconfig   gcc  
arc          buildonly-randconfig-r001-20230522   gcc  
arc          buildonly-randconfig-r003-20230522   gcc  
arc                                 defconfig   gcc  
arc                            hsdk_defconfig   gcc  
arc                        nsimosci_defconfig   gcc  
arc                  randconfig-r015-20230521   gcc  
arc                  randconfig-r015-20230523   gcc  
arc                  randconfig-r024-20230521   gcc  
arc                  randconfig-r043-20230521   gcc  
arc                  randconfig-r043-20230522   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                       imx_v6_v7_defconfig   gcc  
arm                  randconfig-r024-20230522   gcc  
arm                  randconfig-r046-20230521   clang
arm                  randconfig-r046-20230522   gcc  
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r006-20230522   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r011-20230523   gcc  
arm64                randconfig-r021-20230522   clang
arm64                randconfig-r023-20230521   gcc  
csky         buildonly-randconfig-r004-20230521   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r011-20230522   gcc  
csky                 randconfig-r012-20230521   gcc  
csky                 randconfig-r022-20230522   gcc  
csky                 randconfig-r026-20230521   gcc  
csky                 randconfig-r026-20230522   gcc  
hexagon              randconfig-r004-20230521   clang
hexagon              randconfig-r011-20230523   clang
hexagon              randconfig-r016-20230522   clang
hexagon              randconfig-r041-20230521   clang
hexagon              randconfig-r041-20230522   clang
hexagon              randconfig-r045-20230521   clang
hexagon              randconfig-r045-20230522   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230522   gcc  
i386                 randconfig-a002-20230522   gcc  
i386                 randconfig-a003-20230522   gcc  
i386                 randconfig-a004-20230522   gcc  
i386                 randconfig-a005-20230522   gcc  
i386                 randconfig-a006-20230522   gcc  
i386                 randconfig-i051-20230524   gcc  
i386                 randconfig-i052-20230524   gcc  
i386                 randconfig-i053-20230524   gcc  
i386                 randconfig-i054-20230524   gcc  
i386                 randconfig-i055-20230524   gcc  
i386                 randconfig-i056-20230524   gcc  
i386                 randconfig-i061-20230523   clang
i386                 randconfig-i062-20230523   clang
i386                 randconfig-i063-20230523   clang
i386                 randconfig-i064-20230523   clang
i386                 randconfig-i065-20230523   clang
i386                 randconfig-i066-20230523   clang
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r015-20230523   gcc  
ia64                 randconfig-r016-20230521   gcc  
ia64                 randconfig-r021-20230521   gcc  
ia64                 randconfig-r023-20230521   gcc  
ia64                 randconfig-r025-20230522   gcc  
ia64                 randconfig-r033-20230521   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r012-20230522   gcc  
loongarch            randconfig-r012-20230523   gcc  
loongarch            randconfig-r022-20230521   gcc  
loongarch            randconfig-r022-20230522   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r024-20230522   gcc  
microblaze           randconfig-r034-20230522   gcc  
microblaze           randconfig-r036-20230521   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r003-20230521   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r005-20230522   gcc  
nios2                randconfig-r012-20230523   gcc  
nios2                randconfig-r025-20230521   gcc  
openrisc     buildonly-randconfig-r002-20230521   gcc  
openrisc             randconfig-r002-20230522   gcc  
openrisc             randconfig-r006-20230521   gcc  
openrisc             randconfig-r015-20230522   gcc  
parisc       buildonly-randconfig-r002-20230522   gcc  
parisc       buildonly-randconfig-r004-20230522   gcc  
parisc       buildonly-randconfig-r006-20230521   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r015-20230522   gcc  
parisc               randconfig-r016-20230523   gcc  
parisc               randconfig-r031-20230522   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                      chrp32_defconfig   gcc  
powerpc              randconfig-r004-20230522   gcc  
powerpc              randconfig-r013-20230522   clang
powerpc              randconfig-r023-20230522   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r001-20230521   clang
riscv                randconfig-r035-20230521   clang
riscv                randconfig-r042-20230521   gcc  
riscv                randconfig-r042-20230522   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r014-20230522   clang
s390                 randconfig-r032-20230522   gcc  
s390                 randconfig-r044-20230521   gcc  
s390                 randconfig-r044-20230522   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r003-20230521   gcc  
sh                   randconfig-r036-20230522   gcc  
sh                           se7705_defconfig   gcc  
sh                     sh7710voipgw_defconfig   gcc  
sparc        buildonly-randconfig-r005-20230521   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r003-20230522   gcc  
sparc                randconfig-r023-20230522   gcc  
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230522   gcc  
x86_64               randconfig-a002-20230522   gcc  
x86_64               randconfig-a003-20230522   gcc  
x86_64               randconfig-a004-20230522   gcc  
x86_64               randconfig-a005-20230522   gcc  
x86_64               randconfig-a006-20230522   gcc  
x86_64               randconfig-a011-20230522   clang
x86_64               randconfig-a012-20230522   clang
x86_64               randconfig-a013-20230522   clang
x86_64               randconfig-a014-20230522   clang
x86_64               randconfig-a015-20230522   clang
x86_64               randconfig-a016-20230522   clang
x86_64               randconfig-r001-20230522   gcc  
x86_64               randconfig-x051-20230522   clang
x86_64               randconfig-x052-20230522   clang
x86_64               randconfig-x053-20230522   clang
x86_64               randconfig-x054-20230522   clang
x86_64               randconfig-x055-20230522   clang
x86_64               randconfig-x056-20230522   clang
x86_64               randconfig-x061-20230522   clang
x86_64               randconfig-x062-20230522   clang
x86_64               randconfig-x063-20230522   clang
x86_64               randconfig-x064-20230522   clang
x86_64               randconfig-x065-20230522   clang
x86_64               randconfig-x066-20230522   clang
x86_64               randconfig-x071-20230522   gcc  
x86_64               randconfig-x072-20230522   gcc  
x86_64               randconfig-x073-20230522   gcc  
x86_64               randconfig-x074-20230522   gcc  
x86_64               randconfig-x075-20230522   gcc  
x86_64               randconfig-x076-20230522   gcc  
x86_64               randconfig-x081-20230522   gcc  
x86_64               randconfig-x082-20230522   gcc  
x86_64               randconfig-x083-20230522   gcc  
x86_64               randconfig-x084-20230522   gcc  
x86_64               randconfig-x085-20230522   gcc  
x86_64               randconfig-x086-20230522   gcc  
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r012-20230522   gcc  
xtensa               randconfig-r031-20230521   gcc  
xtensa               randconfig-r035-20230521   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
