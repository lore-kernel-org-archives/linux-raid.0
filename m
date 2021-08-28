Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DF6C432BE
	for <linux-raid@archiver.kernel.org>; Sat, 28 Aug 2021 11:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88C67601FD
	for <linux-raid@archiver.kernel.org>; Sat, 28 Aug 2021 11:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhH1LIT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 28 Aug 2021 07:08:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:49009 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233850AbhH1LIS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 28 Aug 2021 07:08:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="216240821"
X-IronPort-AV: E=Sophos;i="5.84,359,1620716400"; 
   d="scan'208";a="216240821"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2021 04:07:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,359,1620716400"; 
   d="scan'208";a="685934382"
Received: from lkp-server01.sh.intel.com (HELO 4fbc2b3ce5aa) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 28 Aug 2021 04:07:24 -0700
Received: from kbuild by 4fbc2b3ce5aa with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mJwBH-0003Ml-L5; Sat, 28 Aug 2021 11:07:23 +0000
Date:   Sat, 28 Aug 2021 19:07:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 6607cd319b6b91bff94e90f798a61c031650b514
Message-ID: <612a18e1.mPFh5BPVkNBzGiWl%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 6607cd319b6b91bff94e90f798a61c031650b514  raid1: ensure write behind bio has less than BIO_MAX_VECS sectors

elapsed time: 721m

configs tested: 138
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210827
powerpc              randconfig-c003-20210827
arc                            hsdk_defconfig
arm                         lpc32xx_defconfig
alpha                            allyesconfig
sh                           sh2007_defconfig
nios2                               defconfig
mips                           xway_defconfig
x86_64                           alldefconfig
arm                  colibri_pxa270_defconfig
arm                         lpc18xx_defconfig
m68k                       m5275evb_defconfig
mips                         mpc30x_defconfig
mips                           ip32_defconfig
m68k                        m5272c3_defconfig
arm                       imx_v4_v5_defconfig
mips                        maltaup_defconfig
arm                         palmz72_defconfig
sh                           se7722_defconfig
sh                           se7751_defconfig
ia64                        generic_defconfig
sh                          rsk7201_defconfig
sh                           se7780_defconfig
powerpc                        warp_defconfig
m68k                        mvme147_defconfig
arm                          badge4_defconfig
xtensa                       common_defconfig
ia64                             allyesconfig
powerpc                      makalu_defconfig
m68k                          multi_defconfig
nds32                             allnoconfig
sh                         apsh4a3a_defconfig
arm                        keystone_defconfig
sh                        edosk7705_defconfig
powerpc                     akebono_defconfig
nios2                         3c120_defconfig
arc                        vdk_hs38_defconfig
sh                         ap325rxa_defconfig
sh                        sh7763rdp_defconfig
sh                   rts7751r2dplus_defconfig
powerpc                      bamboo_defconfig
powerpc                      ppc64e_defconfig
arm                         bcm2835_defconfig
powerpc                      ppc6xx_defconfig
sh                           se7343_defconfig
arm                         nhk8815_defconfig
x86_64                            allnoconfig
ia64                             allmodconfig
ia64                                defconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
arc                              allyesconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a001-20210828
i386                 randconfig-a006-20210828
i386                 randconfig-a002-20210828
i386                 randconfig-a005-20210828
i386                 randconfig-a003-20210828
i386                 randconfig-a004-20210828
x86_64               randconfig-a014-20210827
x86_64               randconfig-a015-20210827
x86_64               randconfig-a016-20210827
x86_64               randconfig-a013-20210827
x86_64               randconfig-a012-20210827
x86_64               randconfig-a011-20210827
i386                 randconfig-a011-20210827
i386                 randconfig-a016-20210827
i386                 randconfig-a012-20210827
i386                 randconfig-a014-20210827
i386                 randconfig-a013-20210827
i386                 randconfig-a015-20210827
arc                  randconfig-r043-20210827
riscv                randconfig-r042-20210827
s390                 randconfig-r044-20210827
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
x86_64                                  kexec

clang tested configs:
s390                 randconfig-c005-20210827
i386                 randconfig-c001-20210827
arm                  randconfig-c002-20210827
riscv                randconfig-c006-20210827
powerpc              randconfig-c003-20210827
x86_64               randconfig-c007-20210827
mips                 randconfig-c004-20210827
x86_64               randconfig-a005-20210827
x86_64               randconfig-a001-20210827
x86_64               randconfig-a006-20210827
x86_64               randconfig-a003-20210827
x86_64               randconfig-a004-20210827
x86_64               randconfig-a002-20210827
i386                 randconfig-a006-20210827
i386                 randconfig-a001-20210827
i386                 randconfig-a002-20210827
i386                 randconfig-a005-20210827
i386                 randconfig-a004-20210827
i386                 randconfig-a003-20210827
i386                 randconfig-a011-20210828
i386                 randconfig-a016-20210828
i386                 randconfig-a012-20210828
i386                 randconfig-a014-20210828
i386                 randconfig-a013-20210828
i386                 randconfig-a015-20210828

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
