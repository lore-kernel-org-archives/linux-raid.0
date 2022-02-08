Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24E3C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 22:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385608AbiBHWZK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386374AbiBHURK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 15:17:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B5CC0613CB
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 12:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644351428; x=1675887428;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=1xuqW/bAxnxO6dc3E+00mPNKu1XzAiGY4dh8++X85Ms=;
  b=cxyMD/9gjaAAy/VIYmlKNJGWVaFfIcI1LHQN/28uJwbb6PIIkZ5uZ9Xj
   pMbKlZK2qc3Ko84J0wglDgajqA/3TDrNpMsdhaxNb8QxR/2y7rEGLY4oR
   Wg8lOrlJLftTHaLctthQasKfDs8mgHX6DiBEA0/cMoEAiaG0cH4uXpoUg
   R1LVvSk3Pufyd+6wKBwlmjI74peZ6I2N+xlgUx/qBTKnt+73f2BvNbByD
   A+wkFkwpEtrRQjYM5juN5wbgnmorqe/rAnNJ97OQT1KZlVTU7CriOIozb
   58v982UZ12Ls/vazJ0TdtagKZ3ILmiddm4Crx1hJ2m3yvWIq33Kt+DHXm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="248992169"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="248992169"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 12:17:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="632969309"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 08 Feb 2022 12:17:06 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nHWvC-0000hH-70; Tue, 08 Feb 2022 20:17:06 +0000
Date:   Wed, 09 Feb 2022 04:16:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 29147ed79b7add3a937c0ee6d54cf22ae5b70853
Message-ID: <6202cfa5.Dz0tkOXgA1g8kehL%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 29147ed79b7add3a937c0ee6d54cf22ae5b70853  raid5: introduce MD_BROKEN

elapsed time: 728m

configs tested: 109
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
arm                              allmodconfig
arm64                               defconfig
i386                          randconfig-c001
sh                          r7785rp_defconfig
sh                          rsk7264_defconfig
mips                  decstation_64_defconfig
powerpc                        warp_defconfig
alpha                               defconfig
mips                         cobalt_defconfig
m68k                       m5249evb_defconfig
arm                        realview_defconfig
m68k                          sun3x_defconfig
mips                        jmr3927_defconfig
sh                  sh7785lcr_32bit_defconfig
arm                     eseries_pxa_defconfig
powerpc                 mpc8540_ads_defconfig
sh                           se7724_defconfig
parisc                           alldefconfig
m68k                        m5407c3_defconfig
powerpc                     tqm8548_defconfig
sh                           se7780_defconfig
arm                         axm55xx_defconfig
powerpc                  storcenter_defconfig
arm                         assabet_defconfig
sh                           se7343_defconfig
mips                 decstation_r4k_defconfig
arm                  randconfig-c002-20220208
ia64                             allmodconfig
ia64                             allyesconfig
ia64                                defconfig
m68k                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
s390                             allyesconfig
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
x86_64                        randconfig-a002
x86_64                        randconfig-a004
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                            allmodconfig
riscv                               defconfig
riscv                          rv32_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
mips                           ip27_defconfig
powerpc                      obs600_defconfig
mips                           ip22_defconfig
mips                        qi_lb60_defconfig
arm                          ixp4xx_defconfig
arm                  colibri_pxa270_defconfig
mips                      bmips_stb_defconfig
arm                        spear3xx_defconfig
arm                         hackkit_defconfig
powerpc                     mpc512x_defconfig
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
i386                          randconfig-a004
i386                          randconfig-a002
i386                          randconfig-a006
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a015
i386                          randconfig-a011
i386                          randconfig-a013
hexagon              randconfig-r045-20220208
hexagon              randconfig-r041-20220208
riscv                randconfig-r042-20220208

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
