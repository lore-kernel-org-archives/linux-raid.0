Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8663DC6FD18
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 11:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjC2LBy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 07:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2LBx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 07:01:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEB219BB
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 04:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680087712; x=1711623712;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=1EuX+t8MIN7iu/FywNPH9vXnWk3+MGqhvZ0f0fAZbV4=;
  b=g5QCIn1IwEVtp9309wuzTCrlFYN8uEqTTe+MhescP/wNAf1f/+FSAbRB
   BmM+MtuYee1XeOWBvoIhoeoq9i7dmej8ORYXuOJEaphwM5p6tScnhJNNk
   3S7diKD5gVHrCSOEqIUQUq5eN7GQY0v17yyERPTUMOxkUz6+Zg/zMQam1
   1m37Mt8AStmI9JBkt1O3Hd4WfZBIKAcF5NLPSC0QwQQfLvQgF5kKZNkCb
   hmqHMpYfUyQYdsL4A+wiChYdewwkI3oXs8WYtsN1fDv7vdgwNCyNSEtx7
   bvknm30MxvtfRtxjOyxhUJUHSFirjjBuID0oOUnrsNndV432vOuEc3dzC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="324750487"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="324750487"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 04:01:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="714582534"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="714582534"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 29 Mar 2023 04:01:46 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1phTYo-000JSY-2f;
        Wed, 29 Mar 2023 11:01:46 +0000
Date:   Wed, 29 Mar 2023 19:01:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 969eb2a7464c5170bd5e33e55904b15eb59f9896
Message-ID: <64241a98.2I2u9KakWIbVSVtt%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 969eb2a7464c5170bd5e33e55904b15eb59f9896  md: fix regression for null-ptr-deference in __md_stop()

elapsed time: 775m

configs tested: 100
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r011-20230326   gcc  
arc                  randconfig-r043-20230326   gcc  
arc                  randconfig-r043-20230327   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r013-20230326   clang
arm                  randconfig-r046-20230326   clang
arm                  randconfig-r046-20230327   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r015-20230327   clang
csky                                defconfig   gcc  
csky                 randconfig-r012-20230326   gcc  
csky                 randconfig-r016-20230326   gcc  
hexagon              randconfig-r041-20230326   clang
hexagon              randconfig-r041-20230327   clang
hexagon              randconfig-r045-20230326   clang
hexagon              randconfig-r045-20230327   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230327   gcc  
i386                 randconfig-a002-20230327   gcc  
i386                 randconfig-a003-20230327   gcc  
i386                 randconfig-a004-20230327   gcc  
i386                 randconfig-a005-20230327   gcc  
i386                 randconfig-a006-20230327   gcc  
i386                 randconfig-a011-20230327   clang
i386                 randconfig-a012-20230327   clang
i386                 randconfig-a013-20230327   clang
i386                 randconfig-a014-20230327   clang
i386                 randconfig-a015-20230327   clang
i386                 randconfig-a016-20230327   clang
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r014-20230327   gcc  
loongarch            randconfig-r024-20230326   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r014-20230326   gcc  
m68k                 randconfig-r015-20230326   gcc  
microblaze           randconfig-r026-20230326   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r023-20230327   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r021-20230326   gcc  
parisc               randconfig-r022-20230327   gcc  
parisc               randconfig-r025-20230326   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r013-20230327   clang
riscv                randconfig-r042-20230326   gcc  
riscv                randconfig-r042-20230327   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r024-20230327   clang
s390                 randconfig-r044-20230326   gcc  
s390                 randconfig-r044-20230327   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r023-20230326   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r021-20230327   gcc  
sparc                randconfig-r026-20230327   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230327   gcc  
x86_64               randconfig-a002-20230327   gcc  
x86_64               randconfig-a003-20230327   gcc  
x86_64               randconfig-a004-20230327   gcc  
x86_64               randconfig-a005-20230327   gcc  
x86_64               randconfig-a006-20230327   gcc  
x86_64               randconfig-a011-20230327   clang
x86_64               randconfig-a012-20230327   clang
x86_64               randconfig-a013-20230327   clang
x86_64               randconfig-a014-20230327   clang
x86_64               randconfig-a015-20230327   clang
x86_64               randconfig-a016-20230327   clang
x86_64               randconfig-r012-20230327   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r016-20230327   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
