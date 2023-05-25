Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3E0C77B7A
	for <linux-raid@archiver.kernel.org>; Thu, 25 May 2023 07:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbjEYHUa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 03:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238970AbjEYHU3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 03:20:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A611BD
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 00:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684999225; x=1716535225;
  h=date:from:to:cc:subject:message-id;
  bh=etvxMw7fYjFeyGr6jnpr0C5TSr502yKcChm3s9k0YJU=;
  b=e7U59vUXFB7XI/4lpaC1ojQxsxGVp3TrJviWhnWwk1wNpI52+1KQZYll
   18UhAlC1Nx+YAEWAkdmrrRtO08GGjSbOWZjN20+FAvejX0CWocIvS4yxO
   rQBkPSJOnA+NWGEL+/N1z7j2KYDcI35WpCGbXhm30hK97oejY1rpLmnkT
   tZx2Mav0ipW/1TqxHHhFDfMFLSwODl1TCyA2Z13/dMFH1thk7b7zs2oCf
   UZoqjyWR1CTJsPedi0dOkztNeGYshZLdGIWqVb/rjRN1efb2M5l8HEs8d
   u/HtughRSohPSpVb+TjLSpMa64/HQpSESG/46600MWXdsRgDI9RiuIaDf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="357039535"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="357039535"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:16:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="774560344"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="774560344"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 25 May 2023 00:16:37 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q25DA-000FYF-2v;
        Thu, 25 May 2023 07:16:36 +0000
Date:   Thu, 25 May 2023 15:15:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 8557dc27126949c702bd3aafe8a7e0b7e4fcb44c
Message-ID: <20230525071546.9Wu5g%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 8557dc27126949c702bd3aafe8a7e0b7e4fcb44c  md/raid5: fix miscalculation of 'end_sector' in raid5_read_one_chunk()

elapsed time: 763m

configs tested: 152
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r015-20230524   gcc  
alpha                randconfig-r024-20230524   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r026-20230524   gcc  
arc                  randconfig-r043-20230524   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r032-20230524   clang
arm                  randconfig-r046-20230524   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r034-20230524   clang
hexagon              randconfig-r041-20230524   clang
hexagon              randconfig-r045-20230524   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230524   gcc  
i386                 randconfig-i002-20230524   gcc  
i386                 randconfig-i003-20230524   gcc  
i386                 randconfig-i004-20230524   gcc  
i386                 randconfig-i005-20230524   gcc  
i386                 randconfig-i006-20230524   gcc  
i386                 randconfig-i011-20230524   clang
i386                 randconfig-i012-20230524   clang
i386                 randconfig-i013-20230524   clang
i386                 randconfig-i014-20230524   clang
i386                 randconfig-i015-20230524   clang
i386                 randconfig-i016-20230524   clang
i386                 randconfig-i051-20230524   gcc  
i386                 randconfig-i052-20230524   gcc  
i386                 randconfig-i053-20230524   gcc  
i386                 randconfig-i054-20230524   gcc  
i386                 randconfig-i055-20230524   gcc  
i386                 randconfig-i056-20230524   gcc  
i386                 randconfig-i061-20230524   gcc  
i386                 randconfig-i062-20230524   gcc  
i386                 randconfig-i063-20230524   gcc  
i386                 randconfig-i064-20230524   gcc  
i386                 randconfig-i065-20230524   gcc  
i386                 randconfig-i066-20230524   gcc  
i386                 randconfig-i071-20230524   clang
i386                 randconfig-i072-20230524   clang
i386                 randconfig-i073-20230524   clang
i386                 randconfig-i074-20230524   clang
i386                 randconfig-i075-20230524   clang
i386                 randconfig-i076-20230524   clang
i386                 randconfig-i081-20230524   clang
i386                 randconfig-i082-20230524   clang
i386                 randconfig-i083-20230524   clang
i386                 randconfig-i084-20230524   clang
i386                 randconfig-i085-20230524   clang
i386                 randconfig-i086-20230524   clang
i386                 randconfig-i091-20230524   gcc  
i386                 randconfig-i092-20230524   gcc  
i386                 randconfig-i093-20230524   gcc  
i386                 randconfig-i094-20230524   gcc  
i386                 randconfig-i095-20230524   gcc  
i386                 randconfig-i096-20230524   gcc  
i386                 randconfig-r003-20230524   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r004-20230524   gcc  
ia64                 randconfig-r014-20230524   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r006-20230524   clang
mips                 randconfig-r023-20230524   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r001-20230524   gcc  
nios2                randconfig-r022-20230524   gcc  
openrisc             randconfig-r002-20230524   gcc  
openrisc             randconfig-r006-20230524   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r031-20230524   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r002-20230524   clang
powerpc      buildonly-randconfig-r003-20230524   clang
powerpc      buildonly-randconfig-r005-20230524   clang
powerpc              randconfig-r025-20230524   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r013-20230524   clang
riscv                randconfig-r042-20230524   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r033-20230524   gcc  
s390                 randconfig-r044-20230524   clang
sh                               allmodconfig   gcc  
sparc        buildonly-randconfig-r001-20230524   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r005-20230524   gcc  
sparc                randconfig-r035-20230524   gcc  
sparc64      buildonly-randconfig-r004-20230524   gcc  
sparc64              randconfig-r021-20230524   gcc  
sparc64              randconfig-r036-20230524   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230524   gcc  
x86_64               randconfig-a002-20230524   gcc  
x86_64               randconfig-a003-20230524   gcc  
x86_64               randconfig-a004-20230524   gcc  
x86_64               randconfig-a005-20230524   gcc  
x86_64               randconfig-a006-20230524   gcc  
x86_64               randconfig-a011-20230524   clang
x86_64               randconfig-a012-20230524   clang
x86_64               randconfig-a013-20230524   clang
x86_64               randconfig-a014-20230524   clang
x86_64               randconfig-a015-20230524   clang
x86_64               randconfig-a016-20230524   clang
x86_64               randconfig-r011-20230524   clang
x86_64               randconfig-r012-20230524   clang
x86_64               randconfig-x052-20230524   clang
x86_64               randconfig-x061-20230524   clang
x86_64               randconfig-x062-20230524   clang
x86_64               randconfig-x063-20230524   clang
x86_64               randconfig-x064-20230524   clang
x86_64               randconfig-x065-20230524   clang
x86_64               randconfig-x066-20230524   clang
x86_64               randconfig-x071-20230524   gcc  
x86_64               randconfig-x072-20230524   gcc  
x86_64               randconfig-x073-20230524   gcc  
x86_64               randconfig-x074-20230524   gcc  
x86_64               randconfig-x075-20230524   gcc  
x86_64               randconfig-x076-20230524   gcc  
x86_64               randconfig-x081-20230524   gcc  
x86_64               randconfig-x082-20230524   gcc  
x86_64               randconfig-x083-20230524   gcc  
x86_64               randconfig-x084-20230524   gcc  
x86_64               randconfig-x085-20230524   gcc  
x86_64               randconfig-x086-20230524   gcc  
x86_64               randconfig-x092-20230524   clang
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
