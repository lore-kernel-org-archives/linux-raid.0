Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A996DC74A5B
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 12:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjC2Miy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 08:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjC2Mix (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 08:38:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A3ED1
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 05:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680093532; x=1711629532;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=UUbZP2x74Q+TWwdbuoH95aEEwu5JWT+UkK2fgzb/xI8=;
  b=N5DLnhJFedxc5+wSZy6KZ2rKBkQfnIY7ujiOcysgjwx4ZO7HqHy3P4v9
   3nOtlhbFQWOdZ4M7Q7kzQsWZxIz3DY66PEEJxVTyai+jeC08NaN2Ouj3C
   nfBnv9NjFlZ9EtjNSp67/XjFGeO+wi3cLSmxnTufmT6oSzRWnX6yLhAxz
   KxvKGZNIiFbhnF1pnSavxXC8USdcCOTlvpqfKP5PBZaP0Dm44gWRTa7n9
   /oNYBQ/VFsM+bhPacSlGvyt53FyLXhOSZiUE6WbdWu52t4a3c/zS0mbIj
   B5HOBg5DVh6+n30yYkGWyjvhKNz8HpU2NjA7LZD+jXPxL+IJ0S3uX4BZM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="324766930"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="324766930"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 05:38:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="677764763"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="677764763"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 29 Mar 2023 05:38:50 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1phV4j-000JX2-27;
        Wed, 29 Mar 2023 12:38:49 +0000
Date:   Wed, 29 Mar 2023 20:37:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 5618a78dd48948979bafc67e2eab9b9bce5095fd
Message-ID: <64243124.JfK7PEABsD0oycwp%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 5618a78dd48948979bafc67e2eab9b9bce5095fd  md/raid5: remove unused working_disks variable

elapsed time: 723m

configs tested: 154
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r012-20230327   gcc  
alpha                randconfig-r012-20230329   gcc  
alpha                randconfig-r013-20230326   gcc  
alpha                randconfig-r015-20230327   gcc  
alpha                randconfig-r016-20230326   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                        nsimosci_defconfig   gcc  
arc                  randconfig-r043-20230327   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r002-20230329   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r011-20230326   clang
arm                  randconfig-r046-20230327   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r002-20230329   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r014-20230329   gcc  
csky                 randconfig-r031-20230329   gcc  
csky                 randconfig-r034-20230329   gcc  
hexagon              randconfig-r015-20230326   clang
hexagon              randconfig-r015-20230329   clang
hexagon              randconfig-r041-20230327   clang
hexagon              randconfig-r041-20230329   clang
hexagon              randconfig-r045-20230327   clang
hexagon              randconfig-r045-20230329   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230327   gcc  
i386                 randconfig-a002-20230327   gcc  
i386                          randconfig-a002   clang
i386                 randconfig-a003-20230327   gcc  
i386                 randconfig-a004-20230327   gcc  
i386                          randconfig-a004   clang
i386                 randconfig-a005-20230327   gcc  
i386                 randconfig-a006-20230327   gcc  
i386                          randconfig-a006   clang
i386                 randconfig-a011-20230327   clang
i386                 randconfig-a012-20230327   clang
i386                          randconfig-a012   gcc  
i386                 randconfig-a013-20230327   clang
i386                 randconfig-a014-20230327   clang
i386                          randconfig-a014   gcc  
i386                 randconfig-a015-20230327   clang
i386                 randconfig-a016-20230327   clang
i386                          randconfig-a016   gcc  
i386                          randconfig-c001   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r003-20230329   gcc  
ia64                 randconfig-r036-20230329   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r012-20230326   gcc  
loongarch            randconfig-r024-20230326   gcc  
loongarch            randconfig-r036-20230329   gcc  
m68k                             alldefconfig   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r002-20230329   gcc  
m68k                                defconfig   gcc  
m68k                          hp300_defconfig   gcc  
m68k                 randconfig-r016-20230327   gcc  
m68k                 randconfig-r035-20230329   gcc  
microblaze           randconfig-r026-20230326   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r001-20230329   clang
mips                 randconfig-r016-20230329   gcc  
nios2        buildonly-randconfig-r003-20230329   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r023-20230327   gcc  
openrisc                  or1klitex_defconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r001-20230329   gcc  
parisc               randconfig-r021-20230326   gcc  
parisc               randconfig-r022-20230327   gcc  
parisc               randconfig-r025-20230326   gcc  
parisc               randconfig-r032-20230329   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r032-20230329   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv             nommu_k210_sdcard_defconfig   gcc  
riscv                randconfig-r042-20230327   clang
riscv                randconfig-r042-20230329   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r005-20230329   gcc  
s390                 randconfig-r013-20230327   clang
s390                 randconfig-r014-20230329   clang
s390                 randconfig-r016-20230329   clang
s390                 randconfig-r024-20230327   clang
s390                 randconfig-r044-20230327   clang
s390                 randconfig-r044-20230329   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r004-20230329   gcc  
sh                   randconfig-r006-20230329   gcc  
sh                   randconfig-r023-20230326   gcc  
sh                           se7206_defconfig   gcc  
sh                           sh2007_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r011-20230327   gcc  
sparc                randconfig-r014-20230326   gcc  
sparc                randconfig-r015-20230329   gcc  
sparc                randconfig-r021-20230327   gcc  
sparc                randconfig-r026-20230327   gcc  
sparc64      buildonly-randconfig-r003-20230329   gcc  
sparc64      buildonly-randconfig-r005-20230329   gcc  
sparc64      buildonly-randconfig-r006-20230329   gcc  
sparc64              randconfig-r031-20230329   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230327   gcc  
x86_64                        randconfig-a001   clang
x86_64               randconfig-a002-20230327   gcc  
x86_64                        randconfig-a002   gcc  
x86_64               randconfig-a003-20230327   gcc  
x86_64                        randconfig-a003   clang
x86_64               randconfig-a004-20230327   gcc  
x86_64                        randconfig-a004   gcc  
x86_64               randconfig-a005-20230327   gcc  
x86_64                        randconfig-a005   clang
x86_64               randconfig-a006-20230327   gcc  
x86_64                        randconfig-a006   gcc  
x86_64               randconfig-a011-20230327   clang
x86_64               randconfig-a012-20230327   clang
x86_64                        randconfig-a012   clang
x86_64               randconfig-a013-20230327   clang
x86_64               randconfig-a014-20230327   clang
x86_64                        randconfig-a014   clang
x86_64               randconfig-a015-20230327   clang
x86_64               randconfig-a016-20230327   clang
x86_64                        randconfig-a016   clang
x86_64                        randconfig-k001   clang
x86_64                               rhel-8.3   gcc  
xtensa                              defconfig   gcc  
xtensa               randconfig-r011-20230329   gcc  
xtensa               randconfig-r033-20230329   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
