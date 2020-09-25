Return-Path: <SRS0=Fkpm=DC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795DBC4363D
	for <linux-raid@archiver.kernel.org>; Fri, 25 Sep 2020 13:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4585B2083B
	for <linux-raid@archiver.kernel.org>; Fri, 25 Sep 2020 13:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgIYNm0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Sep 2020 09:42:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:44317 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbgIYNm0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 25 Sep 2020 09:42:26 -0400
IronPort-SDR: 3NkXcJqyJN8/RBebr/FQIUHKf2pnLBpECcoaH/cT37ne9CAHs1xMJ1tS2VKVKBWfHP2mqoBEc0
 LE2O+xNYc+MA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="223126379"
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="223126379"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 06:42:25 -0700
IronPort-SDR: XEKjOUGjnxXAlahlADnPoNxYEhIzukOk2ubbf1w7MD/1LT2SujxL/IUZ1m5DDsiFoEbS2Cze+g
 /qg5buwT2yfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="383477385"
Received: from lkp-server01.sh.intel.com (HELO 2dda29302fe3) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 25 Sep 2020 06:42:24 -0700
Received: from kbuild by 2dda29302fe3 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kLnzT-00007Z-TI; Fri, 25 Sep 2020 13:42:23 +0000
Date:   Fri, 25 Sep 2020 21:41:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS WITH WARNING
 d3ee2d8415a6256c1c41e1be36e80e640c3e6359
Message-ID: <5f6df39a.6UHvTHCzYM4whmJL%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git  md-next
branch HEAD: d3ee2d8415a6256c1c41e1be36e80e640c3e6359  md/raid10: improve discard request for far layout

Warning in current branch:

drivers/md/raid10.c:1542:8-27: atomic_dec_and_test variation before object free at line 1548.

Warning ids grouped by kconfigs:

gcc_recent_errors
`-- x86_64-randconfig-c002-20200925
    `-- drivers-md-raid10.c:atomic_dec_and_test-variation-before-object-free-at-line-.

elapsed time: 768m

configs tested: 118
configs skipped: 2

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
sh                          landisk_defconfig
arm                            lart_defconfig
sh                   secureedge5410_defconfig
m68k                        mvme147_defconfig
sh                   rts7751r2dplus_defconfig
sh                ecovec24-romimage_defconfig
arm                      footbridge_defconfig
arm                           h5000_defconfig
powerpc                     tqm8540_defconfig
arc                          axs103_defconfig
powerpc                  mpc885_ads_defconfig
i386                                defconfig
mips                           ci20_defconfig
powerpc                      tqm8xx_defconfig
arm                         bcm2835_defconfig
arm                           stm32_defconfig
arm                          collie_defconfig
mips                         cobalt_defconfig
arm                        clps711x_defconfig
powerpc                      ppc64e_defconfig
xtensa                  audio_kc705_defconfig
h8300                            alldefconfig
arm                        trizeps4_defconfig
powerpc                 mpc85xx_cds_defconfig
sh                      rts7751r2d1_defconfig
mips                        bcm47xx_defconfig
mips                         tb0226_defconfig
arm                         hackkit_defconfig
um                           x86_64_defconfig
arm                       netwinder_defconfig
arm                        keystone_defconfig
arc                              alldefconfig
c6x                                 defconfig
ia64                        generic_defconfig
ia64                      gensparse_defconfig
sh                           se7721_defconfig
mips                        workpad_defconfig
powerpc                     ep8248e_defconfig
mips                       capcella_defconfig
powerpc                     ppa8548_defconfig
powerpc                       maple_defconfig
arm                       omap2plus_defconfig
mips                         db1xxx_defconfig
s390                             allyesconfig
sh                          sdk7786_defconfig
arm                          tango4_defconfig
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
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a002-20200925
i386                 randconfig-a006-20200925
i386                 randconfig-a003-20200925
i386                 randconfig-a004-20200925
i386                 randconfig-a005-20200925
i386                 randconfig-a001-20200925
x86_64               randconfig-a011-20200925
x86_64               randconfig-a013-20200925
x86_64               randconfig-a012-20200925
x86_64               randconfig-a016-20200925
x86_64               randconfig-a014-20200925
x86_64               randconfig-a015-20200925
i386                 randconfig-a012-20200925
i386                 randconfig-a014-20200925
i386                 randconfig-a016-20200925
i386                 randconfig-a013-20200925
i386                 randconfig-a011-20200925
i386                 randconfig-a015-20200925
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
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a005-20200925
x86_64               randconfig-a003-20200925
x86_64               randconfig-a004-20200925
x86_64               randconfig-a002-20200925
x86_64               randconfig-a006-20200925
x86_64               randconfig-a001-20200925

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
