Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3A3C43461
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 18:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D5C2068D
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 18:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgIOSnm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:43:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:24798 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgIOSnX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Sep 2020 14:43:23 -0400
IronPort-SDR: z9+coNLRjnJ5P9jS3uP730ZJtwW/Up0dM1gOGydXCFp9Wusj+8lBZbNf3rhVwMOpQ+YOJOL5uW
 cROz2SLIQ+JQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="244159470"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="244159470"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 11:43:18 -0700
IronPort-SDR: 0/obXFx58WAWyCmPhnEKy4e6vm05CPgF/XrnWhhC8NqZeIx2Pi+VYnpybcyEFodgq9GjAV65eW
 9FeNdvwDjQlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="343611982"
Received: from lkp-server01.sh.intel.com (HELO 96654786cb26) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Sep 2020 11:43:16 -0700
Received: from kbuild by 96654786cb26 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kIFvA-0000Eg-7s; Tue, 15 Sep 2020 18:43:16 +0000
Date:   Wed, 16 Sep 2020 02:42:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 5b2374a6c221f28c74913d208bb5376a7ee3bf70
Message-ID: <5f610b1a.MZ+dD2BcStod0MuJ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git  md-next
branch HEAD: 5b2374a6c221f28c74913d208bb5376a7ee3bf70  md/raid10: improve discard request for far layout

elapsed time: 721m

configs tested: 165
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
m68k                          hp300_defconfig
sh                          sdk7786_defconfig
powerpc                          g5_defconfig
arm                           tegra_defconfig
openrisc                 simple_smp_defconfig
powerpc                        icon_defconfig
arm                          pxa3xx_defconfig
arm                              zx_defconfig
powerpc                      ppc40x_defconfig
mips                        vocore2_defconfig
m68k                         amcore_defconfig
mips                    maltaup_xpa_defconfig
mips                       rbtx49xx_defconfig
powerpc                   currituck_defconfig
riscv                          rv32_defconfig
arm                        clps711x_defconfig
arm                          iop32x_defconfig
powerpc                         wii_defconfig
arm                         lpc32xx_defconfig
sh                          r7780mp_defconfig
powerpc                    mvme5100_defconfig
um                             i386_defconfig
arc                            hsdk_defconfig
powerpc                    gamecube_defconfig
powerpc                 mpc836x_mds_defconfig
arm                         shannon_defconfig
powerpc                      pcm030_defconfig
parisc                generic-64bit_defconfig
sh                        dreamcast_defconfig
arm                            mps2_defconfig
arm                       aspeed_g4_defconfig
arm                            pleb_defconfig
microblaze                    nommu_defconfig
arm                    vt8500_v6_v7_defconfig
powerpc                      mgcoge_defconfig
ia64                                defconfig
mips                        bcm47xx_defconfig
arc                        nsimosci_defconfig
powerpc                      obs600_defconfig
riscv                            alldefconfig
arm                        multi_v5_defconfig
powerpc                     tqm8541_defconfig
arm                         hackkit_defconfig
nds32                             allnoconfig
arm                             ezx_defconfig
arm                       aspeed_g5_defconfig
sparc                       sparc64_defconfig
powerpc                     tqm8560_defconfig
riscv                            allmodconfig
arm                        spear3xx_defconfig
powerpc                 mpc8540_ads_defconfig
m68k                        m5307c3_defconfig
c6x                              alldefconfig
arm                        trizeps4_defconfig
arm                        multi_v7_defconfig
powerpc                  mpc885_ads_defconfig
arm                   milbeaut_m10v_defconfig
microblaze                          defconfig
powerpc                      tqm8xx_defconfig
sh                                  defconfig
m68k                          sun3x_defconfig
powerpc                       ppc64_defconfig
powerpc                     stx_gp3_defconfig
arm                          gemini_defconfig
mips                  maltasmvp_eva_defconfig
xtensa                          iss_defconfig
xtensa                           alldefconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                                defconfig
m68k                             allmodconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
c6x                              allyesconfig
nds32                               defconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
nios2                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
xtensa                           allyesconfig
h8300                            allyesconfig
parisc                              defconfig
s390                             allyesconfig
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
x86_64               randconfig-a004-20200914
x86_64               randconfig-a006-20200914
x86_64               randconfig-a003-20200914
x86_64               randconfig-a002-20200914
x86_64               randconfig-a001-20200914
x86_64               randconfig-a005-20200914
i386                 randconfig-a004-20200914
i386                 randconfig-a006-20200914
i386                 randconfig-a001-20200914
i386                 randconfig-a003-20200914
i386                 randconfig-a002-20200914
i386                 randconfig-a005-20200914
i386                 randconfig-a004-20200915
i386                 randconfig-a006-20200915
i386                 randconfig-a001-20200915
i386                 randconfig-a003-20200915
i386                 randconfig-a002-20200915
i386                 randconfig-a005-20200915
x86_64               randconfig-a014-20200913
x86_64               randconfig-a011-20200913
x86_64               randconfig-a012-20200913
x86_64               randconfig-a016-20200913
x86_64               randconfig-a015-20200913
x86_64               randconfig-a013-20200913
x86_64               randconfig-a014-20200915
x86_64               randconfig-a011-20200915
x86_64               randconfig-a016-20200915
x86_64               randconfig-a012-20200915
x86_64               randconfig-a015-20200915
x86_64               randconfig-a013-20200915
i386                 randconfig-a015-20200915
i386                 randconfig-a014-20200915
i386                 randconfig-a011-20200915
i386                 randconfig-a013-20200915
i386                 randconfig-a016-20200915
i386                 randconfig-a012-20200915
i386                 randconfig-a015-20200914
i386                 randconfig-a014-20200914
i386                 randconfig-a011-20200914
i386                 randconfig-a013-20200914
i386                 randconfig-a016-20200914
i386                 randconfig-a012-20200914
riscv                            allyesconfig
riscv                             allnoconfig
riscv                               defconfig
x86_64                                   rhel
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a014-20200914
x86_64               randconfig-a011-20200914
x86_64               randconfig-a016-20200914
x86_64               randconfig-a012-20200914
x86_64               randconfig-a015-20200914
x86_64               randconfig-a013-20200914
x86_64               randconfig-a006-20200913
x86_64               randconfig-a004-20200913
x86_64               randconfig-a003-20200913
x86_64               randconfig-a002-20200913
x86_64               randconfig-a005-20200913
x86_64               randconfig-a001-20200913

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
