Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82D2C6FD1D
	for <linux-raid@archiver.kernel.org>; Thu, 30 Mar 2023 07:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjC3HYo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Mar 2023 03:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjC3HYm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 30 Mar 2023 03:24:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E60E40CB
        for <linux-raid@vger.kernel.org>; Thu, 30 Mar 2023 00:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680161079; x=1711697079;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=KeqefUBT5hFx9xcqwfzdBrifxfTTi9ZPRLaFkeCnzys=;
  b=ThB1u35EAOD90FN/qfMxGATwQ2MtPCVHXHiPz6+Cj/Of43boQB/adl2U
   oO7hkIFojBjvFVfKYJ43KbwhndnsyZD7n3E+rcOZhGK8v+G9EYUJbOX4N
   f8gHmi8qeFWdEshbZMv2Nom14zdq6l9Lgqiu4YdqjnoToBkDNimWiEytU
   n1UFxRueuvXUrJpWJyuGJtzxZu44VqDsYOK1j7GVozKhk+VhitTyqTuiV
   Li6A5w0eyyM+t8MqGu+pWA9ThiYEogxOhZyHLMJFNEoH4+ueSJhbmL6av
   h5Zce3pTxrckubqAObpBrVGz/JTRTLjtHGhJO4kH2Rx1LNYV4r3LNquGf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="329585211"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="329585211"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 00:24:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="858802450"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="858802450"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2023 00:24:37 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1phmeD-000KWH-0B;
        Thu, 30 Mar 2023 07:24:37 +0000
Date:   Thu, 30 Mar 2023 15:23:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 433279beba1d4872da10b7b60a539e0cb828b32b
Message-ID: <642538fd.t8DtGxoLHQopFhdg%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 433279beba1d4872da10b7b60a539e0cb828b32b  md: fix regression for null-ptr-deference in __md_stop()

elapsed time: 729m

configs tested: 266
configs skipped: 23

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r002-20230329   gcc  
alpha        buildonly-randconfig-r004-20230330   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r004-20230329   gcc  
alpha                randconfig-r012-20230329   gcc  
alpha                randconfig-r015-20230329   gcc  
alpha                randconfig-r023-20230329   gcc  
alpha                randconfig-r026-20230329   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r003-20230329   gcc  
arc          buildonly-randconfig-r005-20230329   gcc  
arc                                 defconfig   gcc  
arc                 nsimosci_hs_smp_defconfig   gcc  
arc                  randconfig-r005-20230329   gcc  
arc                  randconfig-r013-20230329   gcc  
arc                  randconfig-r016-20230329   gcc  
arc                  randconfig-r025-20230329   gcc  
arc                  randconfig-r033-20230329   gcc  
arc                  randconfig-r034-20230329   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                         axm55xx_defconfig   gcc  
arm          buildonly-randconfig-r003-20230329   gcc  
arm          buildonly-randconfig-r006-20230329   gcc  
arm                                 defconfig   gcc  
arm                            hisi_defconfig   gcc  
arm                      jornada720_defconfig   gcc  
arm                         lpc18xx_defconfig   gcc  
arm                        multi_v5_defconfig   clang
arm                             mxs_defconfig   clang
arm                             pxa_defconfig   gcc  
arm                  randconfig-r013-20230329   gcc  
arm                  randconfig-r021-20230329   gcc  
arm                  randconfig-r023-20230329   gcc  
arm                  randconfig-r025-20230329   gcc  
arm                        realview_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r001-20230329   gcc  
arm64        buildonly-randconfig-r002-20230329   gcc  
arm64        buildonly-randconfig-r005-20230329   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r001-20230329   gcc  
arm64                randconfig-r003-20230329   gcc  
arm64                randconfig-r013-20230329   clang
arm64                randconfig-r025-20230329   clang
arm64                randconfig-r026-20230329   clang
arm64                randconfig-r032-20230329   gcc  
arm64                randconfig-r035-20230329   gcc  
arm64                randconfig-r036-20230329   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r003-20230329   gcc  
csky                 randconfig-r004-20230329   gcc  
csky                 randconfig-r011-20230329   gcc  
csky                 randconfig-r026-20230329   gcc  
csky                 randconfig-r026-20230330   gcc  
csky                 randconfig-r031-20230329   gcc  
csky                 randconfig-r034-20230329   gcc  
hexagon              randconfig-r016-20230329   clang
hexagon              randconfig-r033-20230329   clang
hexagon              randconfig-r041-20230329   clang
hexagon              randconfig-r045-20230329   clang
i386                              allnoconfig   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                          randconfig-a002   clang
i386                          randconfig-a004   clang
i386                          randconfig-a006   clang
i386                          randconfig-a012   gcc  
i386                          randconfig-a014   gcc  
i386                          randconfig-a016   gcc  
i386                          randconfig-c001   gcc  
ia64                             allmodconfig   gcc  
ia64         buildonly-randconfig-r003-20230329   gcc  
ia64         buildonly-randconfig-r005-20230329   gcc  
ia64         buildonly-randconfig-r005-20230330   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r002-20230329   gcc  
ia64                 randconfig-r005-20230329   gcc  
ia64                 randconfig-r006-20230329   gcc  
ia64                 randconfig-r015-20230329   gcc  
ia64                 randconfig-r023-20230329   gcc  
ia64                 randconfig-r025-20230329   gcc  
ia64                 randconfig-r026-20230329   gcc  
ia64                 randconfig-r033-20230329   gcc  
ia64                 randconfig-r036-20230329   gcc  
ia64                            zx1_defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r004-20230329   gcc  
loongarch    buildonly-randconfig-r006-20230329   gcc  
loongarch                           defconfig   gcc  
loongarch                 loongson3_defconfig   gcc  
loongarch            randconfig-r002-20230329   gcc  
loongarch            randconfig-r004-20230329   gcc  
loongarch            randconfig-r006-20230329   gcc  
loongarch            randconfig-r013-20230329   gcc  
loongarch            randconfig-r015-20230329   gcc  
loongarch            randconfig-r021-20230329   gcc  
loongarch            randconfig-r022-20230329   gcc  
loongarch            randconfig-r023-20230329   gcc  
loongarch            randconfig-r036-20230329   gcc  
m68k                             allmodconfig   gcc  
m68k                          amiga_defconfig   gcc  
m68k         buildonly-randconfig-r002-20230329   gcc  
m68k         buildonly-randconfig-r002-20230330   gcc  
m68k         buildonly-randconfig-r004-20230329   gcc  
m68k         buildonly-randconfig-r006-20230329   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r004-20230329   gcc  
m68k                 randconfig-r014-20230329   gcc  
m68k                 randconfig-r015-20230329   gcc  
m68k                 randconfig-r022-20230329   gcc  
m68k                 randconfig-r025-20230329   gcc  
m68k                 randconfig-r031-20230329   gcc  
microblaze   buildonly-randconfig-r001-20230329   gcc  
microblaze   buildonly-randconfig-r002-20230329   gcc  
microblaze   buildonly-randconfig-r005-20230329   gcc  
microblaze   buildonly-randconfig-r006-20230329   gcc  
microblaze           randconfig-r016-20230329   gcc  
microblaze           randconfig-r024-20230329   gcc  
microblaze           randconfig-r032-20230329   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                      bmips_stb_defconfig   clang
mips         buildonly-randconfig-r004-20230329   clang
mips                           ip32_defconfig   gcc  
mips                      loongson3_defconfig   gcc  
mips                    maltaup_xpa_defconfig   gcc  
mips                 randconfig-r001-20230329   clang
mips                 randconfig-r012-20230329   gcc  
mips                 randconfig-r015-20230329   gcc  
mips                 randconfig-r021-20230329   gcc  
mips                 randconfig-r021-20230330   gcc  
mips                 randconfig-r025-20230329   gcc  
nios2        buildonly-randconfig-r003-20230329   gcc  
nios2        buildonly-randconfig-r004-20230329   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r006-20230329   gcc  
nios2                randconfig-r011-20230329   gcc  
nios2                randconfig-r012-20230329   gcc  
nios2                randconfig-r016-20230329   gcc  
nios2                randconfig-r024-20230329   gcc  
nios2                randconfig-r025-20230329   gcc  
nios2                randconfig-r031-20230329   gcc  
nios2                randconfig-r033-20230329   gcc  
nios2                randconfig-r035-20230329   gcc  
openrisc     buildonly-randconfig-r002-20230329   gcc  
openrisc             randconfig-r006-20230329   gcc  
openrisc             randconfig-r021-20230329   gcc  
openrisc             randconfig-r026-20230329   gcc  
openrisc             randconfig-r032-20230329   gcc  
openrisc             randconfig-r034-20230329   gcc  
openrisc             randconfig-r036-20230329   gcc  
parisc       buildonly-randconfig-r006-20230329   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r004-20230329   gcc  
parisc               randconfig-r006-20230329   gcc  
parisc               randconfig-r022-20230329   gcc  
parisc               randconfig-r022-20230330   gcc  
parisc               randconfig-r023-20230330   gcc  
parisc               randconfig-r024-20230329   gcc  
parisc               randconfig-r032-20230329   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                      arches_defconfig   gcc  
powerpc                      chrp32_defconfig   gcc  
powerpc                       ebony_defconfig   clang
powerpc                       holly_defconfig   gcc  
powerpc                 mpc834x_itx_defconfig   gcc  
powerpc                 mpc8540_ads_defconfig   gcc  
powerpc                      pcm030_defconfig   gcc  
powerpc                      ppc64e_defconfig   clang
powerpc                     rainier_defconfig   gcc  
powerpc              randconfig-r003-20230329   gcc  
powerpc              randconfig-r011-20230329   clang
powerpc              randconfig-r024-20230329   clang
powerpc              randconfig-r026-20230329   clang
powerpc              randconfig-r032-20230329   gcc  
powerpc              randconfig-r034-20230329   gcc  
powerpc                     tqm8555_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r005-20230329   gcc  
riscv                randconfig-r006-20230329   gcc  
riscv                randconfig-r022-20230329   clang
riscv                randconfig-r031-20230329   gcc  
riscv                randconfig-r032-20230329   gcc  
riscv                randconfig-r035-20230329   gcc  
riscv                randconfig-r042-20230329   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r002-20230329   clang
s390         buildonly-randconfig-r003-20230329   clang
s390                          debug_defconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r002-20230329   gcc  
s390                 randconfig-r005-20230329   gcc  
s390                 randconfig-r014-20230329   clang
s390                 randconfig-r022-20230329   clang
s390                 randconfig-r023-20230329   clang
s390                 randconfig-r035-20230329   gcc  
s390                 randconfig-r044-20230329   clang
sh                               allmodconfig   gcc  
sh                        dreamcast_defconfig   gcc  
sh                         ecovec24_defconfig   gcc  
sh                         microdev_defconfig   gcc  
sh                            migor_defconfig   gcc  
sh                   randconfig-r005-20230329   gcc  
sh                   randconfig-r022-20230329   gcc  
sh                   randconfig-r023-20230329   gcc  
sh                          rsk7264_defconfig   gcc  
sparc                            alldefconfig   gcc  
sparc                             allnoconfig   gcc  
sparc        buildonly-randconfig-r001-20230329   gcc  
sparc        buildonly-randconfig-r003-20230329   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r005-20230329   gcc  
sparc                randconfig-r022-20230329   gcc  
sparc                randconfig-r024-20230330   gcc  
sparc64      buildonly-randconfig-r003-20230329   gcc  
sparc64      buildonly-randconfig-r005-20230329   gcc  
sparc64      buildonly-randconfig-r006-20230329   gcc  
sparc64              randconfig-r003-20230329   gcc  
sparc64              randconfig-r013-20230329   gcc  
sparc64              randconfig-r024-20230329   gcc  
sparc64              randconfig-r031-20230329   gcc  
sparc64              randconfig-r033-20230329   gcc  
sparc64              randconfig-r034-20230329   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   clang
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                        randconfig-a001   clang
x86_64                        randconfig-a002   gcc  
x86_64                        randconfig-a003   clang
x86_64                        randconfig-a004   gcc  
x86_64                        randconfig-a005   clang
x86_64                        randconfig-a006   gcc  
x86_64                        randconfig-a011   gcc  
x86_64                        randconfig-a012   clang
x86_64                        randconfig-a013   gcc  
x86_64                        randconfig-a014   clang
x86_64                        randconfig-a015   gcc  
x86_64                        randconfig-a016   clang
x86_64                        randconfig-k001   clang
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r001-20230329   gcc  
xtensa       buildonly-randconfig-r003-20230329   gcc  
xtensa       buildonly-randconfig-r003-20230330   gcc  
xtensa       buildonly-randconfig-r004-20230329   gcc  
xtensa       buildonly-randconfig-r006-20230330   gcc  
xtensa               randconfig-r002-20230329   gcc  
xtensa               randconfig-r012-20230329   gcc  
xtensa               randconfig-r021-20230329   gcc  
xtensa               randconfig-r024-20230329   gcc  
xtensa               randconfig-r026-20230329   gcc  
xtensa               randconfig-r031-20230329   gcc  
xtensa               randconfig-r033-20230329   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
