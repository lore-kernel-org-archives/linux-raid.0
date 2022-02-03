Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC2E6C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  3 Feb 2022 08:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242007AbiBCIK7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Feb 2022 03:10:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:19890 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231836AbiBCIK6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 3 Feb 2022 03:10:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643875858; x=1675411858;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=pNzspDe+ewY1GPx4oD35xBbkmLS5sMfgYy/InII7Ph0=;
  b=WL7AWNT2tVqSF0TMLjNWmp5VTX0sYXii4LUJAFqTM1x7Wf14kCXuQ2Sm
   lwCrd5nNBYC4hztyD2wrvFo34j1yCqSPTdhcdibpa4i2BXArfyY0uifrc
   KW9Qgp4WjcuVE9scDHDb8TwbaU0F+9I904M6LdAEEmhQDkCbEoppdBOOP
   tbkofI5X7nJv2ud6R6p5HvV5I2PZKluONYMws1S9pEtjcu99XnojTIQV0
   7FUHYfQFeCyCJ/P4xqx9WUjuvye3KhCojQrhpLmXRXgTgOalFkQPkmWKK
   1nwB7BPXCIf3iyOmoRIdnkUHkpseUSBy5stpUBgtxcZGTovcHmJQ/7ggv
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="246929329"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="246929329"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 00:10:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="769546035"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2022 00:10:57 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nFXCi-000Vq9-KK; Thu, 03 Feb 2022 08:10:56 +0000
Date:   Thu, 03 Feb 2022 16:10:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 0f9650bd838efe5c52f7e5f40c3204ad59f1964d
Message-ID: <61fb8e04.hMFnZ0TDUfovG2dG%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 0f9650bd838efe5c52f7e5f40c3204ad59f1964d  md: fix NULL pointer deref with nowait but no mddev->queue

elapsed time: 728m

configs tested: 169
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20220131
arm                        clps711x_defconfig
sh                           se7724_defconfig
sh                         apsh4a3a_defconfig
arm64                            alldefconfig
mips                           ip32_defconfig
powerpc                     redwood_defconfig
arm                       aspeed_g5_defconfig
arm                            zeus_defconfig
powerpc                     asp8347_defconfig
csky                             alldefconfig
mips                        vocore2_defconfig
sh                          r7780mp_defconfig
m68k                        stmark2_defconfig
arm                        multi_v7_defconfig
sh                               alldefconfig
parisc                generic-32bit_defconfig
arc                           tb10x_defconfig
powerpc                      ppc40x_defconfig
powerpc                mpc7448_hpc2_defconfig
arc                        nsimosci_defconfig
openrisc                  or1klitex_defconfig
arm                           viper_defconfig
s390                       zfcpdump_defconfig
h8300                       h8s-sim_defconfig
powerpc                      pcm030_defconfig
parisc                generic-64bit_defconfig
sh                           se7721_defconfig
mips                       capcella_defconfig
powerpc                       ppc64_defconfig
arm                         vf610m4_defconfig
mips                          rb532_defconfig
mips                  decstation_64_defconfig
mips                           gcw0_defconfig
mips                           jazz_defconfig
xtensa                       common_defconfig
s390                          debug_defconfig
microblaze                          defconfig
mips                           ci20_defconfig
arm                         axm55xx_defconfig
powerpc                       holly_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                        sh7785lcr_defconfig
powerpc                      ppc6xx_defconfig
powerpc                     taishan_defconfig
sh                     sh7710voipgw_defconfig
arm                           corgi_defconfig
sh                          r7785rp_defconfig
ia64                          tiger_defconfig
m68k                          sun3x_defconfig
microblaze                      mmu_defconfig
powerpc                    amigaone_defconfig
arm                          pxa910_defconfig
arm                  randconfig-c002-20220130
arm                  randconfig-c002-20220131
arm                  randconfig-c002-20220202
ia64                                defconfig
ia64                             allmodconfig
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
alpha                               defconfig
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
x86_64               randconfig-a004-20220131
x86_64               randconfig-a003-20220131
x86_64               randconfig-a001-20220131
x86_64               randconfig-a006-20220131
x86_64               randconfig-a005-20220131
x86_64               randconfig-a002-20220131
i386                 randconfig-a006-20220131
i386                 randconfig-a005-20220131
i386                 randconfig-a003-20220131
i386                 randconfig-a002-20220131
i386                 randconfig-a001-20220131
i386                 randconfig-a004-20220131
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
riscv                randconfig-r042-20220130
arc                  randconfig-r043-20220130
arc                  randconfig-r043-20220131
s390                 randconfig-r044-20220130
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
x86_64                                  kexec

clang tested configs:
riscv                randconfig-c006-20220130
x86_64                        randconfig-c007
arm                  randconfig-c002-20220130
powerpc              randconfig-c003-20220130
mips                 randconfig-c004-20220130
i386                          randconfig-c001
powerpc              randconfig-c003-20220201
mips                 randconfig-c004-20220201
arm                  randconfig-c002-20220201
arm                         hackkit_defconfig
arm                           spitz_defconfig
mips                  cavium_octeon_defconfig
powerpc                 mpc832x_rdb_defconfig
arm                          imote2_defconfig
powerpc                 mpc836x_rdk_defconfig
arm                         shannon_defconfig
powerpc                        icon_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64               randconfig-a013-20220131
x86_64               randconfig-a015-20220131
x86_64               randconfig-a014-20220131
x86_64               randconfig-a016-20220131
x86_64               randconfig-a011-20220131
x86_64               randconfig-a012-20220131
i386                 randconfig-a011-20220131
i386                 randconfig-a013-20220131
i386                 randconfig-a014-20220131
i386                 randconfig-a012-20220131
i386                 randconfig-a015-20220131
i386                 randconfig-a016-20220131
riscv                randconfig-r042-20220131
hexagon              randconfig-r045-20220131
hexagon              randconfig-r045-20220130
hexagon              randconfig-r041-20220130
hexagon              randconfig-r041-20220131
s390                 randconfig-r044-20220131

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
