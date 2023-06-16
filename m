Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24E6EB64DA
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 20:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjFPUI5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 16:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjFPUIz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 16:08:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B182D79
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 13:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686946134; x=1718482134;
  h=date:from:to:cc:subject:message-id;
  bh=3BJa3v7ZtbLBB2ekheMGfXvLqxeKZKxWFoLHjCtqtZo=;
  b=IWnhUF3swgkxvcmVoF14LOVoVKc5GEo3wNBci2enPiSfeAwROYcFBk11
   iKYQBPZiFW65EERp1rglAt/gdHlOr3bKOX8ETIdFyonzNs0vhN9rzYIUK
   sc3ni442W4bJW+ISBk8QYABg5n62nUzsm8IumiDNEKrEO9LM31RIY1hRH
   2arNZmW3m1YEpEHd5irqHAS9NbBbkTzcLb0bagQS/botelcEsy0Bh34wf
   RC/KoIgeUMWLTIerCp3hCO437i3W/Xcv+lDIZMbsxmTeZzJh1KAnsXyIZ
   NXblIim7sJuoWn39lcZ09QHDJwiBAUR/48E2Z9vMuJvLKZfZ6EghSMTRm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="359312433"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="359312433"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 13:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="857526032"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="857526032"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jun 2023 13:08:52 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qAFkZ-0001lE-1A;
        Fri, 16 Jun 2023 20:08:51 +0000
Date:   Sat, 17 Jun 2023 04:08:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 40c7a6a5605810f9db267cdf47e0a32ce96ea491
Message-ID: <202306170449.87WQsh3e-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 40c7a6a5605810f9db267cdf47e0a32ce96ea491  md: deprecate bitmap file support

elapsed time: 726m

configs tested: 103
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r012-20230615   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r016-20230615   gcc  
arc                  randconfig-r043-20230615   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r046-20230615   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r014-20230615   gcc  
csky                 randconfig-r034-20230614   gcc  
hexagon              randconfig-r024-20230615   clang
hexagon              randconfig-r025-20230615   clang
hexagon              randconfig-r036-20230614   clang
hexagon              randconfig-r041-20230615   clang
hexagon              randconfig-r045-20230615   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r005-20230614   clang
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230616   clang
i386                 randconfig-i002-20230616   clang
i386                 randconfig-i003-20230616   clang
i386                 randconfig-i004-20230616   clang
i386                 randconfig-i005-20230616   clang
i386                 randconfig-i006-20230616   clang
i386                 randconfig-i011-20230616   gcc  
i386                 randconfig-i012-20230616   gcc  
i386                 randconfig-i013-20230616   gcc  
i386                 randconfig-i014-20230616   gcc  
i386                 randconfig-i015-20230616   gcc  
i386                 randconfig-i016-20230616   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r006-20230616   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze   buildonly-randconfig-r002-20230614   gcc  
microblaze           randconfig-r031-20230614   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r023-20230615   gcc  
nios2        buildonly-randconfig-r003-20230614   gcc  
nios2                               defconfig   gcc  
openrisc             randconfig-r005-20230616   gcc  
parisc                           allyesconfig   gcc  
parisc       buildonly-randconfig-r001-20230614   gcc  
parisc       buildonly-randconfig-r004-20230614   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r004-20230616   gcc  
parisc               randconfig-r021-20230615   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r013-20230615   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r011-20230615   clang
riscv                randconfig-r015-20230615   clang
riscv                randconfig-r042-20230615   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r026-20230615   clang
s390                 randconfig-r032-20230614   clang
s390                 randconfig-r044-20230615   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r006-20230614   gcc  
sh                   randconfig-r035-20230614   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r033-20230614   gcc  
sparc64              randconfig-r022-20230615   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230616   clang
x86_64               randconfig-a002-20230616   clang
x86_64               randconfig-a003-20230616   clang
x86_64               randconfig-a004-20230616   clang
x86_64               randconfig-a005-20230616   clang
x86_64               randconfig-a006-20230616   clang
x86_64               randconfig-a011-20230616   gcc  
x86_64               randconfig-a012-20230616   gcc  
x86_64               randconfig-a013-20230616   gcc  
x86_64               randconfig-a014-20230616   gcc  
x86_64               randconfig-a015-20230616   gcc  
x86_64               randconfig-a016-20230616   gcc  
x86_64               randconfig-r001-20230616   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
