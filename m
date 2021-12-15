Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A4BC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 00:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhLOA0i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 19:26:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:17742 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230072AbhLOA0i (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 14 Dec 2021 19:26:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639527998; x=1671063998;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=rCcCmbGc8I9AarfAcF0Jj/ljE+vPe51+E8OEhB4YgPY=;
  b=GX0kWAqpyYGusgzAVAFbfzmhR0xzwSiAlXOpuaxEAcdROLwyA1PppFdj
   rAaAjtyIGd3hJpJeqdSfpdBF88XgURDYtXxFy+SyOEdI2i9HdgXOkUFxc
   Wipq4FadlBJnzslzRl+pQYs5Ret/o48mHHtl9cnDDpdVKOhrgU606nXqK
   5HqpGQspoxmvdWghFo/+srGhCwyHpDHXdV2ObHL5Ip5Z4gQUYq3BqRgSM
   FYesWW7jwtmhiWruiy6XYdRZ40hXos6KFju9cu1dBCwKZuG6am1KPdfrI
   iI7aWYH1/AOluxRwyb7mFdPkSwVvA7k3enRpQXzshDLDGo28FYdf0s1fs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="302489963"
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="302489963"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 16:26:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="614503330"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 14 Dec 2021 16:26:36 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxI7w-0000yt-2m; Wed, 15 Dec 2021 00:26:36 +0000
Date:   Wed, 15 Dec 2021 08:25:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 c14704e1cb5564b5097e2888099dc65950370ec3
Message-ID: <61b9360c.RZZzHN3/GWQeiQhT%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: c14704e1cb5564b5097e2888099dc65950370ec3  md/raid5: play nice with PREEMPT_RT

elapsed time: 1354m

configs tested: 211
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211214
mips                 randconfig-c004-20211214
i386                 randconfig-c001-20211215
sh                           se7705_defconfig
arc                              allyesconfig
arm                          gemini_defconfig
powerpc                      walnut_defconfig
powerpc                      cm5200_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                 kfr2r09-romimage_defconfig
xtensa                    xip_kc705_defconfig
powerpc                    klondike_defconfig
sh                          urquell_defconfig
mips                      bmips_stb_defconfig
arm                            hisi_defconfig
powerpc                      acadia_defconfig
arm                            mps2_defconfig
mips                           ip22_defconfig
mips                  maltasmvp_eva_defconfig
mips                     loongson1c_defconfig
arm                        mini2440_defconfig
xtensa                  audio_kc705_defconfig
arm                         orion5x_defconfig
powerpc                   motionpro_defconfig
powerpc                 mpc834x_itx_defconfig
sh                               alldefconfig
arm                             mxs_defconfig
powerpc                      pasemi_defconfig
powerpc                    gamecube_defconfig
powerpc64                        alldefconfig
mips                  cavium_octeon_defconfig
arm                     eseries_pxa_defconfig
arm                      footbridge_defconfig
arm                          pxa168_defconfig
riscv                            allmodconfig
m68k                          sun3x_defconfig
arm                         s5pv210_defconfig
mips                         tb0226_defconfig
mips                         tb0219_defconfig
powerpc                 xes_mpc85xx_defconfig
arm64                            alldefconfig
arc                    vdk_hs38_smp_defconfig
powerpc                   lite5200b_defconfig
arc                     nsimosci_hs_defconfig
powerpc                 mpc85xx_cds_defconfig
arm                         hackkit_defconfig
arm                         s3c2410_defconfig
m68k                           sun3_defconfig
sh                          r7780mp_defconfig
csky                             alldefconfig
arm                   milbeaut_m10v_defconfig
arm                  colibri_pxa270_defconfig
powerpc                      makalu_defconfig
arm                      jornada720_defconfig
arm                           sama5_defconfig
mips                            ar7_defconfig
arm                       aspeed_g5_defconfig
riscv             nommu_k210_sdcard_defconfig
arm                       imx_v4_v5_defconfig
mips                      fuloong2e_defconfig
arm                         assabet_defconfig
arm                      integrator_defconfig
arm                        shmobile_defconfig
arc                 nsimosci_hs_smp_defconfig
xtensa                    smp_lx200_defconfig
i386                                defconfig
h8300                               defconfig
powerpc                 mpc832x_rdb_defconfig
arm                          lpd270_defconfig
powerpc                     ppa8548_defconfig
mips                      maltaaprp_defconfig
arm                          imote2_defconfig
sh                      rts7751r2d1_defconfig
sparc                               defconfig
sh                         microdev_defconfig
powerpc                     stx_gp3_defconfig
parisc                           alldefconfig
m68k                        m5307c3_defconfig
xtensa                          iss_defconfig
sh                            shmin_defconfig
m68k                        stmark2_defconfig
h8300                       h8s-sim_defconfig
x86_64                           allyesconfig
arm                         lubbock_defconfig
arm                         lpc32xx_defconfig
mips                        vocore2_defconfig
i386                             alldefconfig
mips                           rs90_defconfig
mips                    maltaup_xpa_defconfig
sparc                       sparc32_defconfig
mips                         tb0287_defconfig
arm                         vf610m4_defconfig
powerpc                   currituck_defconfig
m68k                             alldefconfig
arm                            qcom_defconfig
sh                           se7724_defconfig
sparc64                             defconfig
h8300                    h8300h-sim_defconfig
arm                         socfpga_defconfig
powerpc                      bamboo_defconfig
ia64                         bigsur_defconfig
arm                        multi_v5_defconfig
arm                        oxnas_v6_defconfig
arm                        magician_defconfig
sh                          rsk7269_defconfig
m68k                        m5272c3_defconfig
mips                       lemote2f_defconfig
riscv                          rv32_defconfig
parisc                              defconfig
sh                           se7712_defconfig
sh                        dreamcast_defconfig
powerpc                     tqm8540_defconfig
powerpc                          g5_defconfig
arm                           sama7_defconfig
arm                  randconfig-c002-20211214
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
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
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                           allnoconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
x86_64               randconfig-a006-20211214
x86_64               randconfig-a005-20211214
x86_64               randconfig-a001-20211214
x86_64               randconfig-a002-20211214
x86_64               randconfig-a003-20211214
x86_64               randconfig-a004-20211214
i386                 randconfig-a001-20211214
i386                 randconfig-a002-20211214
i386                 randconfig-a005-20211214
i386                 randconfig-a003-20211214
i386                 randconfig-a006-20211214
i386                 randconfig-a004-20211214
x86_64               randconfig-a011-20211213
x86_64               randconfig-a012-20211213
x86_64               randconfig-a013-20211213
x86_64               randconfig-a016-20211213
x86_64               randconfig-a015-20211213
x86_64               randconfig-a014-20211213
i386                 randconfig-a013-20211213
i386                 randconfig-a011-20211213
i386                 randconfig-a014-20211213
i386                 randconfig-a012-20211213
i386                 randconfig-a015-20211213
i386                 randconfig-a016-20211213
arc                  randconfig-r043-20211213
s390                 randconfig-r044-20211213
riscv                randconfig-r042-20211213
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec
x86_64                          rhel-8.3-func

clang tested configs:
arm                  randconfig-c002-20211214
x86_64               randconfig-c007-20211214
riscv                randconfig-c006-20211214
mips                 randconfig-c004-20211214
i386                 randconfig-c001-20211214
s390                 randconfig-c005-20211214
powerpc              randconfig-c003-20211214
x86_64               randconfig-a011-20211214
x86_64               randconfig-a014-20211214
x86_64               randconfig-a012-20211214
x86_64               randconfig-a013-20211214
x86_64               randconfig-a016-20211214
x86_64               randconfig-a015-20211214
i386                 randconfig-a013-20211214
i386                 randconfig-a011-20211214
i386                 randconfig-a016-20211214
i386                 randconfig-a014-20211214
i386                 randconfig-a015-20211214
i386                 randconfig-a012-20211214
hexagon              randconfig-r045-20211214
s390                 randconfig-r044-20211214
riscv                randconfig-r042-20211214
hexagon              randconfig-r041-20211214
hexagon              randconfig-r041-20211213
hexagon              randconfig-r045-20211213

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
