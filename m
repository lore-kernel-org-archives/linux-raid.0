Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEE7EB64D9
	for <linux-raid@archiver.kernel.org>; Thu, 29 Jun 2023 11:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjF2Lm2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Jun 2023 07:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF2Lm1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Jun 2023 07:42:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5209330F0
        for <linux-raid@vger.kernel.org>; Thu, 29 Jun 2023 04:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688038946; x=1719574946;
  h=date:from:to:cc:subject:message-id;
  bh=MoWphiNtb7YRmUeLY1pZw4S9vS8q7OOoGJ64L4+X/xY=;
  b=nq2EG/jBzEBKBhIV5/uIWNRrS4l5NPis1sLsCJ6vPJkDDIBxrU5NaNSJ
   vwWw0qt2DnszN5aDWo6abf6rxYdephelSuGafp/G2NunvzL5YJkG5HzeF
   q0dQHgrFgiT9GM5NXAOliuQUa72M+pq7L9sbk58sMJlEdMKqt7pWE2AmG
   qpIZuSxP46TufFjX/lN1srggRc+kmXpXuxR8ckZC6HMohVoSk68Gwb5qG
   bFcHGtkJjVzebgDXrJ95fvjLPXNJp/FE4YN4UrDTJBCbM50wq2cLCBPDH
   3bftAE2IFIP/F42+10M4k3RJt0F8W06wt4PANO9gAjDnGidLFumhKSywT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="428103951"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="428103951"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 04:42:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="720536901"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="720536901"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2023 04:42:24 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qEq2Z-000E6T-3A;
        Thu, 29 Jun 2023 11:42:23 +0000
Date:   Thu, 29 Jun 2023 19:41:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 73bbbec2a33982db88186489fb75f5705aadf5fe
Message-ID: <202306291926.HlrtWuCG-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 73bbbec2a33982db88186489fb75f5705aadf5fe  md/raid0: add discard support for the 'original' layout

elapsed time: 721m

configs tested: 109
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r004-20230628   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r043-20230628   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r003-20230628   gcc  
arm                  randconfig-r025-20230628   clang
arm                  randconfig-r046-20230628   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r031-20230629   gcc  
arm64                randconfig-r036-20230628   clang
csky                                defconfig   gcc  
csky                 randconfig-r026-20230628   gcc  
hexagon              randconfig-r041-20230628   clang
hexagon              randconfig-r045-20230628   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230628   clang
i386         buildonly-randconfig-r005-20230628   clang
i386         buildonly-randconfig-r006-20230628   clang
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230628   clang
i386                 randconfig-i002-20230628   clang
i386                 randconfig-i003-20230628   clang
i386                 randconfig-i004-20230628   clang
i386                 randconfig-i005-20230628   clang
i386                 randconfig-i006-20230628   clang
i386                 randconfig-i011-20230628   gcc  
i386                 randconfig-i012-20230628   gcc  
i386                 randconfig-i013-20230628   gcc  
i386                 randconfig-i014-20230628   gcc  
i386                 randconfig-i015-20230628   gcc  
i386                 randconfig-i016-20230628   gcc  
i386                 randconfig-r011-20230628   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r023-20230628   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r035-20230628   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r012-20230628   clang
mips                 randconfig-r016-20230628   clang
nios2                               defconfig   gcc  
nios2                randconfig-r015-20230628   gcc  
nios2                randconfig-r032-20230629   gcc  
nios2                randconfig-r035-20230629   gcc  
openrisc             randconfig-r034-20230629   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230628   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r001-20230628   clang
s390                 randconfig-r013-20230628   gcc  
s390                 randconfig-r044-20230628   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r002-20230628   gcc  
sh                   randconfig-r024-20230628   gcc  
sh                   randconfig-r033-20230628   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r006-20230628   gcc  
sparc                randconfig-r032-20230628   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230628   clang
x86_64       buildonly-randconfig-r002-20230628   clang
x86_64       buildonly-randconfig-r003-20230628   clang
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r031-20230628   clang
x86_64               randconfig-r033-20230629   gcc  
x86_64               randconfig-x001-20230628   gcc  
x86_64               randconfig-x002-20230628   gcc  
x86_64               randconfig-x003-20230628   gcc  
x86_64               randconfig-x004-20230628   gcc  
x86_64               randconfig-x005-20230628   gcc  
x86_64               randconfig-x006-20230628   gcc  
x86_64               randconfig-x011-20230628   clang
x86_64               randconfig-x012-20230628   clang
x86_64               randconfig-x013-20230628   clang
x86_64               randconfig-x014-20230628   clang
x86_64               randconfig-x015-20230628   clang
x86_64               randconfig-x016-20230628   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
