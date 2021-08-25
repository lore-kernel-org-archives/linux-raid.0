Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62801C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 11:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B6B161076
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 11:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbhHYLQ6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Aug 2021 07:16:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:10654 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239824AbhHYLQ5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 25 Aug 2021 07:16:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="217535937"
X-IronPort-AV: E=Sophos;i="5.84,350,1620716400"; 
   d="scan'208";a="217535937"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 04:16:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,350,1620716400"; 
   d="scan'208";a="686036438"
Received: from lkp-server01.sh.intel.com (HELO 4fbc2b3ce5aa) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 25 Aug 2021 04:16:07 -0700
Received: from kbuild by 4fbc2b3ce5aa with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mIqt5-000062-0J; Wed, 25 Aug 2021 11:16:07 +0000
Date:   Wed, 25 Aug 2021 19:15:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 bbe48a66a81d06da7db63b5cb7071531af447edc
Message-ID: <61262666.9+KaJ/g+XlkQgU9e%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: bbe48a66a81d06da7db63b5cb7071531af447edc  md/raid10: Remove rcu_dereference when it doesn't need rcu lock to protect

elapsed time: 730m

configs tested: 155
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210824
sh                           se7722_defconfig
powerpc                    mvme5100_defconfig
powerpc                     ep8248e_defconfig
sh                          sdk7786_defconfig
arm                           viper_defconfig
xtensa                  nommu_kc705_defconfig
h8300                               defconfig
powerpc                     ksi8560_defconfig
arm                          simpad_defconfig
arm                          imote2_defconfig
arm                              alldefconfig
riscv                            alldefconfig
powerpc                        fsp2_defconfig
sparc64                             defconfig
arc                           tb10x_defconfig
arm                          pxa910_defconfig
mips                      fuloong2e_defconfig
sh                        sh7763rdp_defconfig
powerpc                 mpc837x_rdb_defconfig
powerpc                     pq2fads_defconfig
powerpc                       ebony_defconfig
mips                      malta_kvm_defconfig
powerpc                     pseries_defconfig
arc                              alldefconfig
arm                           tegra_defconfig
sh                 kfr2r09-romimage_defconfig
mips                           ci20_defconfig
arm                        spear3xx_defconfig
ia64                                defconfig
arm                             ezx_defconfig
powerpc                      ppc40x_defconfig
mips                       lemote2f_defconfig
mips                           xway_defconfig
microblaze                          defconfig
mips                        bcm63xx_defconfig
powerpc                  mpc866_ads_defconfig
powerpc                 mpc834x_itx_defconfig
powerpc                      arches_defconfig
arm                             rpc_defconfig
riscv                    nommu_k210_defconfig
s390                             allyesconfig
arm                        realview_defconfig
powerpc                      pmac32_defconfig
arm                         cm_x300_defconfig
powerpc                       maple_defconfig
sh                               j2_defconfig
i386                                defconfig
arm                          ixp4xx_defconfig
arc                     haps_hs_smp_defconfig
powerpc                 linkstation_defconfig
powerpc64                           defconfig
mips                          ath79_defconfig
arm                          lpd270_defconfig
arm                         hackkit_defconfig
sh                           se7206_defconfig
arc                              allyesconfig
arm                      tct_hammer_defconfig
sh                            titan_defconfig
xtensa                  audio_kc705_defconfig
m68k                         apollo_defconfig
sh                           se7721_defconfig
mips                           ip28_defconfig
sh                          rsk7269_defconfig
xtensa                    xip_kc705_defconfig
powerpc               mpc834x_itxgp_defconfig
arm                           h3600_defconfig
powerpc                 canyonlands_defconfig
ia64                             allmodconfig
ia64                             allyesconfig
x86_64                            allnoconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
nds32                             allnoconfig
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
s390                             allmodconfig
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
x86_64               randconfig-a005-20210824
x86_64               randconfig-a006-20210824
x86_64               randconfig-a001-20210824
x86_64               randconfig-a003-20210824
x86_64               randconfig-a004-20210824
x86_64               randconfig-a002-20210824
i386                 randconfig-a006-20210824
i386                 randconfig-a001-20210824
i386                 randconfig-a002-20210824
i386                 randconfig-a005-20210824
i386                 randconfig-a003-20210824
i386                 randconfig-a004-20210824
x86_64               randconfig-a014-20210825
x86_64               randconfig-a015-20210825
x86_64               randconfig-a016-20210825
x86_64               randconfig-a013-20210825
x86_64               randconfig-a012-20210825
x86_64               randconfig-a011-20210825
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
i386                 randconfig-c001-20210824
s390                 randconfig-c005-20210824
arm                  randconfig-c002-20210824
riscv                randconfig-c006-20210824
powerpc              randconfig-c003-20210824
x86_64               randconfig-c007-20210824
mips                 randconfig-c004-20210824
x86_64               randconfig-a014-20210824
x86_64               randconfig-a015-20210824
x86_64               randconfig-a016-20210824
x86_64               randconfig-a013-20210824
x86_64               randconfig-a012-20210824
x86_64               randconfig-a011-20210824
i386                 randconfig-a011-20210824
i386                 randconfig-a016-20210824
i386                 randconfig-a012-20210824
i386                 randconfig-a014-20210824
i386                 randconfig-a013-20210824
i386                 randconfig-a015-20210824
hexagon              randconfig-r041-20210824
hexagon              randconfig-r045-20210824
riscv                randconfig-r042-20210824
s390                 randconfig-r044-20210824

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
