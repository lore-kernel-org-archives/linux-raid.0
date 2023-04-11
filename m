Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228AAC7619A
	for <linux-raid@archiver.kernel.org>; Tue, 11 Apr 2023 18:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjDKSJn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjDKSJl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Apr 2023 14:09:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664CF6E9B
        for <linux-raid@vger.kernel.org>; Tue, 11 Apr 2023 11:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681236562; x=1712772562;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=aQsBPI7ucS+NkXGA1Azz/Agtmg0TLtCHSTovm3rrZVc=;
  b=Or3k2wjsPsS8Rtl+UzIMWsPl3N03u7jHHUugN2JfmVb9ZSTHarJLbaiR
   5fVXsWKTp9UGk2RNFLjDeY4bL9A4axlsgYlc4Bo6191ZAM9QAsEewj0FG
   iGukdKYuz5QeskR4XSAFweuUWh+1EuI6w5kTXbCGFEgB+4FqsUJdyiZ/W
   FzOVHjrenAZ62La+DlrUY/+ORIj7wEjDtucnuwC9I7WLGUuiCSzl1tfJA
   2FzXpxNPgMlWl35KVC/eVZi8Ofjfww97GGe27tLyEY0aBiz+k3WpbyhRv
   LIhHH2ldZlB0b89CtgpspgBCsqf/fjMo+8bF/FTljn4eH5Xn6ck6Yf4BT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="324060851"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="324060851"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 11:07:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="862975482"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="862975482"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 11 Apr 2023 11:05:22 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pmIMs-000Wa7-05;
        Tue, 11 Apr 2023 18:05:22 +0000
Date:   Wed, 12 Apr 2023 02:04:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 fd24e32db299b1cde485413381edf2182ead9a84
Message-ID: <6435a149.4KM+R9XQioa+aXzc%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: fd24e32db299b1cde485413381edf2182ead9a84  md/raid5: remove unused working_disks variable

elapsed time: 725m

configs tested: 144
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r003-20230410   gcc  
alpha                randconfig-r023-20230410   gcc  
alpha                randconfig-r026-20230410   gcc  
alpha                randconfig-r034-20230409   gcc  
alpha                randconfig-r035-20230410   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r003-20230409   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r031-20230410   gcc  
arc                  randconfig-r032-20230410   gcc  
arc                  randconfig-r043-20230409   gcc  
arc                  randconfig-r043-20230410   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r003-20230410   clang
arm                                 defconfig   gcc  
arm                        multi_v5_defconfig   clang
arm                  randconfig-r033-20230410   gcc  
arm                  randconfig-r034-20230410   gcc  
arm                  randconfig-r046-20230409   clang
arm                  randconfig-r046-20230410   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r015-20230409   gcc  
arm64                randconfig-r022-20230410   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r003-20230409   gcc  
hexagon              randconfig-r006-20230409   clang
hexagon              randconfig-r041-20230409   clang
hexagon              randconfig-r041-20230410   clang
hexagon              randconfig-r045-20230409   clang
hexagon              randconfig-r045-20230410   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230410   clang
i386                 randconfig-a002-20230410   clang
i386                 randconfig-a003-20230410   clang
i386                 randconfig-a004-20230410   clang
i386                 randconfig-a005-20230410   clang
i386                 randconfig-a006-20230410   clang
i386                 randconfig-a011-20230410   gcc  
i386                 randconfig-a012-20230410   gcc  
i386                 randconfig-a013-20230410   gcc  
i386                 randconfig-a014-20230410   gcc  
i386                 randconfig-a015-20230410   gcc  
i386                 randconfig-a016-20230410   gcc  
i386                 randconfig-r002-20230410   clang
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r016-20230410   gcc  
ia64                 randconfig-r022-20230409   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r004-20230410   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r001-20230409   gcc  
loongarch            randconfig-r011-20230410   gcc  
loongarch            randconfig-r024-20230409   gcc  
loongarch            randconfig-r034-20230409   gcc  
loongarch            randconfig-r036-20230410   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r002-20230410   gcc  
m68k         buildonly-randconfig-r005-20230409   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r015-20230410   gcc  
microblaze   buildonly-randconfig-r006-20230409   gcc  
microblaze           randconfig-r035-20230409   gcc  
microblaze           randconfig-r036-20230410   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r001-20230410   gcc  
mips                 randconfig-r021-20230409   clang
mips                 randconfig-r031-20230410   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r004-20230410   gcc  
nios2                randconfig-r013-20230409   gcc  
openrisc     buildonly-randconfig-r002-20230409   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r016-20230409   gcc  
parisc               randconfig-r023-20230409   gcc  
parisc               randconfig-r032-20230409   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r001-20230410   gcc  
powerpc      buildonly-randconfig-r006-20230410   gcc  
powerpc                       ebony_defconfig   clang
powerpc              randconfig-r014-20230410   gcc  
powerpc              randconfig-r033-20230409   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r002-20230409   clang
riscv                randconfig-r012-20230409   gcc  
riscv                randconfig-r024-20230410   gcc  
riscv                randconfig-r042-20230409   gcc  
riscv                randconfig-r042-20230410   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r026-20230409   gcc  
s390                 randconfig-r044-20230409   gcc  
s390                 randconfig-r044-20230410   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r004-20230409   gcc  
sh                   randconfig-r005-20230409   gcc  
sh                   randconfig-r013-20230410   gcc  
sh                   randconfig-r014-20230409   gcc  
sh                   randconfig-r025-20230409   gcc  
sparc        buildonly-randconfig-r004-20230409   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r012-20230410   gcc  
sparc                randconfig-r032-20230409   gcc  
sparc                randconfig-r033-20230409   gcc  
sparc64              randconfig-r005-20230410   gcc  
sparc64              randconfig-r025-20230410   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                        randconfig-a001   clang
x86_64                        randconfig-a002   gcc  
x86_64                        randconfig-a003   clang
x86_64                        randconfig-a004   gcc  
x86_64                        randconfig-a005   clang
x86_64                        randconfig-a006   gcc  
x86_64               randconfig-a011-20230410   gcc  
x86_64               randconfig-a012-20230410   gcc  
x86_64               randconfig-a013-20230410   gcc  
x86_64               randconfig-a014-20230410   gcc  
x86_64               randconfig-a015-20230410   gcc  
x86_64               randconfig-a016-20230410   gcc  
x86_64               randconfig-r006-20230410   clang
x86_64               randconfig-r021-20230410   gcc  
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r011-20230409   gcc  
xtensa               randconfig-r033-20230410   gcc  
xtensa               randconfig-r034-20230410   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
