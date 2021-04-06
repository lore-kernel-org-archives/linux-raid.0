Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CABC433ED
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 06:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0780610D0
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 06:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhDFGUd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:20:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:3431 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhDFGUd (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 6 Apr 2021 02:20:33 -0400
IronPort-SDR: GxWW0KnoOqbK+L6jTtCD47PsdNi7OmXiYlMSSimk9eRsjNxdSV1228MNFAyQnKoax/OP3q2QFO
 Ffod96H7JV6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="192529859"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="192529859"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 23:20:25 -0700
IronPort-SDR: xVXQ7C5bLuHJ5f9L2ULEaUmJSNO8N3jy8NVL/dvAWM2AlJJOOMNiAwwDVV3hg34r8nAKvqmdmZ
 SpU8gK5YQvpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="447715892"
Received: from lkp-server01.sh.intel.com (HELO 69d8fcc516b7) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2021 23:20:24 -0700
Received: from kbuild by 69d8fcc516b7 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lTf4Z-000BMQ-Nm; Tue, 06 Apr 2021 06:20:23 +0000
Date:   Tue, 06 Apr 2021 14:20:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 f21c86cf789a60e5f4054fe897026f612ac5f123
Message-ID: <606bfda4.0vr1p7igOpzmjbMX%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: f21c86cf789a60e5f4054fe897026f612ac5f123  md: split mddev_find

elapsed time: 720m

configs tested: 203
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
riscv                            allmodconfig
x86_64                           allyesconfig
riscv                            allyesconfig
i386                             allyesconfig
mips                        workpad_defconfig
xtensa                generic_kc705_defconfig
sh                         microdev_defconfig
arm                            mmp2_defconfig
sparc64                             defconfig
sh                           se7343_defconfig
powerpc                     akebono_defconfig
arm                       aspeed_g4_defconfig
sh                          sdk7786_defconfig
csky                             alldefconfig
arm                          lpd270_defconfig
arm                        spear3xx_defconfig
mips                        qi_lb60_defconfig
sh                   sh7770_generic_defconfig
powerpc                mpc7448_hpc2_defconfig
powerpc                 canyonlands_defconfig
sh                     sh7710voipgw_defconfig
arm                            mps2_defconfig
arc                         haps_hs_defconfig
sh                        sh7763rdp_defconfig
xtensa                       common_defconfig
openrisc                 simple_smp_defconfig
riscv                          rv32_defconfig
arm                           corgi_defconfig
sparc                       sparc32_defconfig
um                            kunit_defconfig
arm                         at91_dt_defconfig
mips                             allyesconfig
powerpc                      arches_defconfig
powerpc                  storcenter_defconfig
powerpc                   lite5200b_defconfig
parisc                generic-64bit_defconfig
mips                          malta_defconfig
riscv             nommu_k210_sdcard_defconfig
powerpc                 mpc85xx_cds_defconfig
powerpc                 mpc836x_rdk_defconfig
mips                      fuloong2e_defconfig
powerpc                      ppc64e_defconfig
powerpc                      katmai_defconfig
powerpc                      ppc44x_defconfig
nds32                             allnoconfig
powerpc                     tqm8541_defconfig
arm                     eseries_pxa_defconfig
sh                         apsh4a3a_defconfig
sh                          r7785rp_defconfig
arm                       versatile_defconfig
s390                             allmodconfig
xtensa                  audio_kc705_defconfig
arm                        magician_defconfig
powerpc                     kilauea_defconfig
mips                        nlm_xlp_defconfig
sh                           se7705_defconfig
xtensa                         virt_defconfig
powerpc                     redwood_defconfig
m68k                       m5475evb_defconfig
powerpc                     tqm8540_defconfig
arm                          collie_defconfig
sparc                            allyesconfig
mips                           xway_defconfig
arm                        keystone_defconfig
arm                          badge4_defconfig
arm                  colibri_pxa270_defconfig
powerpc                      ep88xc_defconfig
arm                         palmz72_defconfig
mips                         tb0219_defconfig
arm                       mainstone_defconfig
mips                     loongson1b_defconfig
h8300                    h8300h-sim_defconfig
mips                      loongson3_defconfig
h8300                     edosk2674_defconfig
m68k                             alldefconfig
sh                               j2_defconfig
sh                         ecovec24_defconfig
m68k                        stmark2_defconfig
s390                       zfcpdump_defconfig
powerpc                      walnut_defconfig
arm                            xcep_defconfig
mips                      maltasmvp_defconfig
powerpc                     mpc5200_defconfig
openrisc                         alldefconfig
mips                     loongson1c_defconfig
mips                        bcm63xx_defconfig
mips                malta_qemu_32r6_defconfig
m68k                       m5249evb_defconfig
sh                           sh2007_defconfig
arm                           stm32_defconfig
mips                           ip32_defconfig
sh                            migor_defconfig
mips                           ip22_defconfig
arm                      tct_hammer_defconfig
powerpc                 mpc8313_rdb_defconfig
ia64                          tiger_defconfig
arc                           tb10x_defconfig
powerpc                   currituck_defconfig
arm                       omap2plus_defconfig
arm                        clps711x_defconfig
arc                     haps_hs_smp_defconfig
xtensa                              defconfig
xtensa                  nommu_kc705_defconfig
arc                          axs101_defconfig
um                               alldefconfig
mips                            gpr_defconfig
arm                          simpad_defconfig
sh                           se7721_defconfig
powerpc                    klondike_defconfig
mips                          rm200_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
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
sparc                               defconfig
i386                                defconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a004-20210406
x86_64               randconfig-a003-20210406
x86_64               randconfig-a005-20210406
x86_64               randconfig-a001-20210406
x86_64               randconfig-a002-20210406
x86_64               randconfig-a006-20210406
i386                 randconfig-a006-20210406
i386                 randconfig-a003-20210406
i386                 randconfig-a001-20210406
i386                 randconfig-a004-20210406
i386                 randconfig-a005-20210406
i386                 randconfig-a002-20210406
i386                 randconfig-a006-20210405
i386                 randconfig-a003-20210405
i386                 randconfig-a001-20210405
i386                 randconfig-a004-20210405
i386                 randconfig-a002-20210405
i386                 randconfig-a005-20210405
x86_64               randconfig-a014-20210405
x86_64               randconfig-a015-20210405
x86_64               randconfig-a013-20210405
x86_64               randconfig-a011-20210405
x86_64               randconfig-a012-20210405
x86_64               randconfig-a016-20210405
i386                 randconfig-a014-20210405
i386                 randconfig-a011-20210405
i386                 randconfig-a016-20210405
i386                 randconfig-a012-20210405
i386                 randconfig-a015-20210405
i386                 randconfig-a013-20210405
i386                 randconfig-a014-20210406
i386                 randconfig-a016-20210406
i386                 randconfig-a011-20210406
i386                 randconfig-a012-20210406
i386                 randconfig-a015-20210406
i386                 randconfig-a013-20210406
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
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
x86_64               randconfig-a004-20210405
x86_64               randconfig-a003-20210405
x86_64               randconfig-a005-20210405
x86_64               randconfig-a001-20210405
x86_64               randconfig-a002-20210405
x86_64               randconfig-a006-20210405
x86_64               randconfig-a014-20210406
x86_64               randconfig-a015-20210406
x86_64               randconfig-a013-20210406
x86_64               randconfig-a011-20210406
x86_64               randconfig-a012-20210406
x86_64               randconfig-a016-20210406

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
