Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07E1C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  4 Jan 2022 13:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiADNHw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Jan 2022 08:07:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:11482 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbiADNHw (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 4 Jan 2022 08:07:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641301672; x=1672837672;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=OcogyVodYMDBKDb4nj+1fXXHEP7mGumFHk7/H9PKiEw=;
  b=ZwuuSjVjh1gY1oqbzIGSF11hghl5xB4UIioQoKu7VTqFg0cEyOXUkubr
   IORjAqpHrRrFovQHSbRFGZrB0CRy3xSsOsTazwuvOPtu4jdv/Z+qYdSvC
   oMRe2uDhSyj3SIuPHo5518po/vzuHQ1u9iyO1vrhumWdehhpkvp1ug/ij
   72V7nOopCAD59mtxPx/s/2cW1SeiUpOP+cXkw8nJKUOpIMfOtTnhoeIRg
   NXfeMwqMTDUJ3v4V68DwNjM1gsaRn3tVOLEEck2O4wVwEVJATpN1++tog
   Y8fXrbk+i/G74Mbt3y2HBW9Y6+4nWCQ7rshJ+wHkBPzl+1vgpnhH1CWrq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="222892883"
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="222892883"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 05:07:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="470163662"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2022 05:07:50 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n4jXZ-000FMa-Ey; Tue, 04 Jan 2022 13:07:49 +0000
Date:   Tue, 04 Jan 2022 21:07:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 9a491db5cc7b2d75fcb138cf84660c6a5022f782
Message-ID: <61d4467e.wh2aIoUMs8vRcY5B%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 9a491db5cc7b2d75fcb138cf84660c6a5022f782  md: fix spelling of "its"

elapsed time: 3574m

configs tested: 208
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
sh                            shmin_defconfig
xtensa                       common_defconfig
openrisc                         alldefconfig
nios2                            alldefconfig
arm                            qcom_defconfig
sh                        dreamcast_defconfig
arm                            mps2_defconfig
sh                         ap325rxa_defconfig
sh                          rsk7264_defconfig
xtensa                    smp_lx200_defconfig
x86_64                           alldefconfig
arm                        oxnas_v6_defconfig
powerpc                 mpc85xx_cds_defconfig
sh                           se7750_defconfig
arm                        clps711x_defconfig
powerpc                       eiger_defconfig
powerpc                       ppc64_defconfig
mips                         mpc30x_defconfig
arm                           h5000_defconfig
xtensa                          iss_defconfig
powerpc                     tqm8548_defconfig
microblaze                      mmu_defconfig
xtensa                         virt_defconfig
powerpc                     ep8248e_defconfig
mips                           ci20_defconfig
arm                     eseries_pxa_defconfig
sh                        edosk7760_defconfig
powerpc                     stx_gp3_defconfig
m68k                          sun3x_defconfig
m68k                       m5208evb_defconfig
powerpc                      ppc6xx_defconfig
arm                       multi_v4t_defconfig
sh                             sh03_defconfig
powerpc                      makalu_defconfig
arm                         nhk8815_defconfig
nios2                         3c120_defconfig
parisc                           alldefconfig
sh                               j2_defconfig
arm                      footbridge_defconfig
arm                           tegra_defconfig
sh                     sh7710voipgw_defconfig
m68k                            q40_defconfig
sh                          kfr2r09_defconfig
arc                              alldefconfig
arc                          axs103_defconfig
mips                           gcw0_defconfig
arc                        vdk_hs38_defconfig
arm64                            alldefconfig
ia64                        generic_defconfig
um                             i386_defconfig
m68k                          multi_defconfig
csky                                defconfig
mips                        vocore2_defconfig
powerpc                    adder875_defconfig
arm                        mini2440_defconfig
mips                         tb0226_defconfig
sh                         ecovec24_defconfig
powerpc                   motionpro_defconfig
ia64                                defconfig
ia64                          tiger_defconfig
mips                      loongson3_defconfig
sh                   sh7724_generic_defconfig
mips                           ip32_defconfig
m68k                         amcore_defconfig
powerpc                     taishan_defconfig
powerpc                 mpc837x_mds_defconfig
ia64                      gensparse_defconfig
parisc                           allyesconfig
arc                      axs103_smp_defconfig
arm                        shmobile_defconfig
arm                           viper_defconfig
um                                  defconfig
arm                  randconfig-c002-20220103
arm                  randconfig-c002-20220102
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
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
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
x86_64               randconfig-a005-20220103
x86_64               randconfig-a001-20220103
x86_64               randconfig-a004-20220103
x86_64               randconfig-a006-20220103
x86_64               randconfig-a002-20220103
x86_64               randconfig-a003-20220103
i386                 randconfig-a003-20220103
i386                 randconfig-a005-20220103
i386                 randconfig-a004-20220103
i386                 randconfig-a006-20220103
i386                 randconfig-a001-20220103
i386                 randconfig-a002-20220103
x86_64               randconfig-a015-20220102
x86_64               randconfig-a012-20220102
x86_64               randconfig-a014-20220102
x86_64               randconfig-a013-20220102
x86_64               randconfig-a011-20220102
x86_64               randconfig-a016-20220102
i386                 randconfig-a012-20220102
i386                 randconfig-a016-20220102
i386                 randconfig-a014-20220102
i386                 randconfig-a015-20220102
i386                 randconfig-a011-20220102
i386                 randconfig-a013-20220102
s390                 randconfig-r044-20220102
arc                  randconfig-r043-20220102
riscv                randconfig-r042-20220102
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                           x86_64_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
arm                  randconfig-c002-20220102
mips                 randconfig-c004-20220102
i386                 randconfig-c001-20220102
riscv                randconfig-c006-20220102
powerpc              randconfig-c003-20220102
x86_64               randconfig-c007-20220102
s390                 randconfig-c005-20220102
arm64                            allyesconfig
mips                     cu1000-neo_defconfig
mips                      bmips_stb_defconfig
arm                        multi_v5_defconfig
mips                          ath79_defconfig
powerpc                        icon_defconfig
powerpc                    socrates_defconfig
powerpc                       ebony_defconfig
arm                          pcm027_defconfig
mips                         tb0287_defconfig
mips                     cu1830-neo_defconfig
powerpc                   bluestone_defconfig
arm                      pxa255-idp_defconfig
arm                                 defconfig
mips                       lemote2f_defconfig
arm                            mmp2_defconfig
arm                        mvebu_v5_defconfig
hexagon                             defconfig
powerpc                 mpc836x_rdk_defconfig
mips                      malta_kvm_defconfig
mips                           ip22_defconfig
arm                       spear13xx_defconfig
arm                    vt8500_v6_v7_defconfig
x86_64                           allyesconfig
arm                           omap1_defconfig
x86_64               randconfig-a005-20220102
x86_64               randconfig-a001-20220102
x86_64               randconfig-a004-20220102
x86_64               randconfig-a006-20220102
x86_64               randconfig-a002-20220102
x86_64               randconfig-a003-20220102
i386                 randconfig-a003-20220102
i386                 randconfig-a005-20220102
i386                 randconfig-a004-20220102
i386                 randconfig-a006-20220102
i386                 randconfig-a001-20220102
i386                 randconfig-a002-20220102
x86_64               randconfig-a015-20220103
x86_64               randconfig-a012-20220103
x86_64               randconfig-a013-20220103
x86_64               randconfig-a011-20220103
x86_64               randconfig-a016-20220103
x86_64               randconfig-a014-20220103
i386                 randconfig-a012-20220103
i386                 randconfig-a016-20220103
i386                 randconfig-a014-20220103
i386                 randconfig-a015-20220103
i386                 randconfig-a011-20220103
i386                 randconfig-a013-20220103
hexagon              randconfig-r041-20220102
hexagon              randconfig-r045-20220102
hexagon              randconfig-r041-20220103
hexagon              randconfig-r045-20220103
riscv                randconfig-r042-20220103

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
