Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABF4C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  3 Mar 2022 16:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbiCCQM0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Mar 2022 11:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiCCQMZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Mar 2022 11:12:25 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC24198D29
        for <linux-raid@vger.kernel.org>; Thu,  3 Mar 2022 08:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646323900; x=1677859900;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=2ZdWchenCc+DbJkahwR1cKs+Xp+6p9UQRiA/aGb3psE=;
  b=VKj14kEHgT+YEXiwmOsBclgz8e2QEeA0N1ORS+Z/mcafqmdddkWXAUBx
   gzz2El7zLWda/LmplJYpdGzpO+uIiVc7xV8hsmufn1dCNca91PVbNb25D
   UU4REoT00MmvjqGiT9M8aO5fHWKEWq0qyvsSBr4/9bog5+yVtxU1aqxX6
   5HSjcaw5mtSs/8Imrbqj/Q78PsKs4v7+/yI/Cb5913dQILoH5gxSKMelt
   xzMwfoRwQ/czpUbRk/tGor9eGIC5Qc6Mmzr8/eBYkjVZUSDi9AwkUl4RU
   IOx1/VmuM8uojAR2KvHuuOy3llIao3kROjl/Xi51I+ZG+TnzWp9vYCxXO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="241133396"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="241133396"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 08:06:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="709968115"
Received: from lkp-server01.sh.intel.com (HELO ccb16ba0ecc3) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 03 Mar 2022 08:05:59 -0800
Received: from kbuild by ccb16ba0ecc3 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nPnxm-0000hp-DP; Thu, 03 Mar 2022 16:05:58 +0000
Date:   Fri, 04 Mar 2022 00:05:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 701c73b4114293fc2b2781bb70ee5c7d5296d85f
Message-ID: <6220e759.VBFxPS/8AFGMHH3d%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 701c73b4114293fc2b2781bb70ee5c7d5296d85f  raid5: initialize the stripe_head embeeded bios as needed

elapsed time: 720m

configs tested: 110
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                          randconfig-c001
sparc64                             defconfig
arm                           sunxi_defconfig
sh                        edosk7705_defconfig
xtensa                           allyesconfig
arc                    vdk_hs38_smp_defconfig
arm                         lubbock_defconfig
mips                         db1xxx_defconfig
sh                            shmin_defconfig
arm                          badge4_defconfig
m68k                             allyesconfig
nios2                         10m50_defconfig
arc                        nsim_700_defconfig
arm                        cerfcube_defconfig
riscv             nommu_k210_sdcard_defconfig
mips                 decstation_r4k_defconfig
nios2                               defconfig
sh                          urquell_defconfig
arm                            lart_defconfig
arc                        nsimosci_defconfig
arm                           h3600_defconfig
arm                           sama5_defconfig
sparc                            alldefconfig
mips                            gpr_defconfig
sh                           se7705_defconfig
powerpc                       holly_defconfig
powerpc                        warp_defconfig
openrisc                  or1klitex_defconfig
sh                  sh7785lcr_32bit_defconfig
arm                  randconfig-c002-20220302
arm                  randconfig-c002-20220303
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
arc                              allyesconfig
nds32                             allnoconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
nds32                               defconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
arc                  randconfig-r043-20220302
riscv                randconfig-r042-20220302
s390                 randconfig-r044-20220302
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                                  kexec

clang tested configs:
x86_64                        randconfig-c007
powerpc              randconfig-c003-20220303
riscv                randconfig-c006-20220303
i386                          randconfig-c001
arm                  randconfig-c002-20220303
mips                 randconfig-c004-20220303
powerpc              randconfig-c003-20220302
riscv                randconfig-c006-20220302
arm                  randconfig-c002-20220302
mips                 randconfig-c004-20220302
mips                            e55_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a011
i386                          randconfig-a013
i386                          randconfig-a015
hexagon              randconfig-r045-20220303
riscv                randconfig-r042-20220303
hexagon              randconfig-r041-20220303

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
