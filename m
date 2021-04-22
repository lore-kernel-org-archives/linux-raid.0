Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54445C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 18:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1888E61424
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 18:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbhDVSYx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Apr 2021 14:24:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:39460 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236886AbhDVSYx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Apr 2021 14:24:53 -0400
IronPort-SDR: uauG629xnNXKB1HWiJ4r/HNGVKWMLjz5jyReEAt18UwVAZRuLhX2IWAIE5wA2HH0vxrA31dlzI
 hPcncsihNrkA==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="259899794"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="259899794"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 11:24:17 -0700
IronPort-SDR: hzNaP/L1WK6LIBmCr1oJw1bo7XzJ+FJdeiWQn8qdGcdmoO7AKXbm2rS1AEvm6nfh5HAs7kILPL
 lAsrJm+aZkXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="386164456"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2021 11:24:15 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lZdzq-0004IC-Hu; Thu, 22 Apr 2021 18:24:14 +0000
Date:   Fri, 23 Apr 2021 02:23:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 ddf9acf2430d7ca8d9eae2f658292684af46d5bb
Message-ID: <6081bf27.7Hc7wPSBhnFdS3Lx%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: ddf9acf2430d7ca8d9eae2f658292684af46d5bb  md/raid1: properly indicate failure when ending a failed write request

elapsed time: 725m

configs tested: 143
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
x86_64                           allyesconfig
riscv                            allmodconfig
i386                             allyesconfig
riscv                            allyesconfig
mips                        workpad_defconfig
powerpc                 xes_mpc85xx_defconfig
powerpc                   currituck_defconfig
powerpc                 mpc837x_mds_defconfig
arm                      footbridge_defconfig
alpha                               defconfig
h8300                    h8300h-sim_defconfig
xtensa                              defconfig
powerpc                  iss476-smp_defconfig
powerpc                      ep88xc_defconfig
arc                      axs103_smp_defconfig
powerpc                 linkstation_defconfig
arm                         s5pv210_defconfig
sparc                       sparc32_defconfig
sh                              ul2_defconfig
powerpc                     asp8347_defconfig
ia64                          tiger_defconfig
mips                        nlm_xlr_defconfig
mips                  decstation_64_defconfig
m68k                          hp300_defconfig
sparc                               defconfig
mips                           xway_defconfig
powerpc                  storcenter_defconfig
mips                           ci20_defconfig
powerpc                  mpc885_ads_defconfig
mips                          rm200_defconfig
arc                           tb10x_defconfig
arm                         cm_x300_defconfig
arm                         bcm2835_defconfig
arm                        keystone_defconfig
sh                                  defconfig
powerpc                       eiger_defconfig
arm                           h5000_defconfig
mips                        maltaup_defconfig
mips                        bcm47xx_defconfig
powerpc                 canyonlands_defconfig
powerpc                      ppc44x_defconfig
arc                        vdk_hs38_defconfig
powerpc                     tqm5200_defconfig
powerpc               mpc834x_itxgp_defconfig
mips                     loongson1b_defconfig
mips                malta_kvm_guest_defconfig
arm                         lpc18xx_defconfig
arm                        magician_defconfig
powerpc                         ps3_defconfig
mips                            ar7_defconfig
arm                           stm32_defconfig
s390                             alldefconfig
ia64                         bigsur_defconfig
i386                             alldefconfig
m68k                         apollo_defconfig
sh                           sh2007_defconfig
arm                    vt8500_v6_v7_defconfig
arm                       omap2plus_defconfig
arm                      tct_hammer_defconfig
m68k                        mvme16x_defconfig
sh                           se7722_defconfig
openrisc                         alldefconfig
powerpc                      acadia_defconfig
mips                            e55_defconfig
sh                            migor_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
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
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
sparc                            allyesconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a004-20210421
x86_64               randconfig-a002-20210421
x86_64               randconfig-a001-20210421
x86_64               randconfig-a005-20210421
x86_64               randconfig-a006-20210421
x86_64               randconfig-a003-20210421
i386                 randconfig-a005-20210421
i386                 randconfig-a002-20210421
i386                 randconfig-a001-20210421
i386                 randconfig-a006-20210421
i386                 randconfig-a004-20210421
i386                 randconfig-a003-20210421
i386                 randconfig-a012-20210421
i386                 randconfig-a014-20210421
i386                 randconfig-a011-20210421
i386                 randconfig-a013-20210421
i386                 randconfig-a015-20210421
i386                 randconfig-a016-20210421
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
um                               allmodconfig
um                                allnoconfig
um                               allyesconfig
um                                  defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a015-20210421
x86_64               randconfig-a016-20210421
x86_64               randconfig-a011-20210421
x86_64               randconfig-a014-20210421
x86_64               randconfig-a013-20210421
x86_64               randconfig-a012-20210421
x86_64               randconfig-a002-20210422
x86_64               randconfig-a004-20210422
x86_64               randconfig-a001-20210422
x86_64               randconfig-a005-20210422
x86_64               randconfig-a006-20210422
x86_64               randconfig-a003-20210422

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
