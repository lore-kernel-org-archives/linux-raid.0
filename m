Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DD6C433E6
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jan 2021 10:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFCA82339D
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jan 2021 10:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbhAMKGB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jan 2021 05:06:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:35788 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbhAMKF7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 13 Jan 2021 05:05:59 -0500
IronPort-SDR: iSOJBL9hwM3PC6w3DJD7Hiif7k89qozI1y4/PxWQH7DC6aLwsIHsl0a+slvaMBKPsic+tWsFC/
 1CYYiottOMUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="177404625"
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="177404625"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 02:05:18 -0800
IronPort-SDR: S2OxH43Q7w9FFHl/LWQfGeCDJ4p8zieTtDjtdd9GdoE9iVw8q0gPIqtvKdB6QV+c75JjwsIIEK
 Y1LDvFTaBHtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="381789542"
Received: from lkp-server01.sh.intel.com (HELO d5d1a9a2c6bb) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 13 Jan 2021 02:05:17 -0800
Received: from kbuild by d5d1a9a2c6bb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kzd1g-0000Ac-Ox; Wed, 13 Jan 2021 10:05:16 +0000
Date:   Wed, 13 Jan 2021 18:05:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 c5d9dcfb1d340591e04e976469ac38cf2dc1707a
Message-ID: <5ffec5cc.5sTZImutK4/U4dUh%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git  md-fixes
branch HEAD: c5d9dcfb1d340591e04e976469ac38cf2dc1707a  md: Set prev_flush_start and flush_bio in an atomic way

elapsed time: 720m

configs tested: 121
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
arm                         shannon_defconfig
powerpc                       maple_defconfig
arm                              zx_defconfig
mips                            e55_defconfig
arm                       spear13xx_defconfig
sh                           se7750_defconfig
powerpc                     ep8248e_defconfig
arm                         lubbock_defconfig
sh                        apsh4ad0a_defconfig
sh                           se7343_defconfig
powerpc64                        alldefconfig
arm                          moxart_defconfig
powerpc                      arches_defconfig
arm                             rpc_defconfig
arc                        nsimosci_defconfig
m68k                          multi_defconfig
xtensa                generic_kc705_defconfig
mips                      bmips_stb_defconfig
sh                             espt_defconfig
arm                            xcep_defconfig
sh                            migor_defconfig
arm                        oxnas_v6_defconfig
mips                         tb0219_defconfig
sh                        edosk7760_defconfig
mips                        jmr3927_defconfig
mips                  decstation_64_defconfig
powerpc                      ep88xc_defconfig
sh                          rsk7264_defconfig
mips                       rbtx49xx_defconfig
arm                        spear6xx_defconfig
arm                         s3c6400_defconfig
powerpc                     pseries_defconfig
arc                              alldefconfig
arc                     nsimosci_hs_defconfig
arm                         lpc18xx_defconfig
sh                ecovec24-romimage_defconfig
mips                        qi_lb60_defconfig
um                            kunit_defconfig
arm                           sunxi_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
c6x                              allyesconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                               tinyconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a002-20210113
i386                 randconfig-a005-20210113
i386                 randconfig-a006-20210113
i386                 randconfig-a003-20210113
i386                 randconfig-a001-20210113
i386                 randconfig-a004-20210113
i386                 randconfig-a012-20210112
i386                 randconfig-a011-20210112
i386                 randconfig-a016-20210112
i386                 randconfig-a013-20210112
i386                 randconfig-a015-20210112
i386                 randconfig-a014-20210112
i386                 randconfig-a012-20210113
i386                 randconfig-a011-20210113
i386                 randconfig-a016-20210113
i386                 randconfig-a013-20210113
i386                 randconfig-a015-20210113
i386                 randconfig-a014-20210113
x86_64               randconfig-a006-20210113
x86_64               randconfig-a004-20210113
x86_64               randconfig-a001-20210113
x86_64               randconfig-a005-20210113
x86_64               randconfig-a003-20210113
x86_64               randconfig-a002-20210113
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                                   rhel
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a015-20210113
x86_64               randconfig-a012-20210113
x86_64               randconfig-a013-20210113
x86_64               randconfig-a016-20210113
x86_64               randconfig-a014-20210113
x86_64               randconfig-a011-20210113

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
