Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9823EC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 07:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhLQHvB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Dec 2021 02:51:01 -0500
Received: from mga07.intel.com ([134.134.136.100]:45259 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhLQHvA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 17 Dec 2021 02:51:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639727460; x=1671263460;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=YlDSyHL2MprT+AmV2pyNHRBayU2BH/0y3twOLeYLVEo=;
  b=Q+XttLhN70n/PupXVxxD//zEyOiEZglb2xlX4T9ehI3Mf+qm3nO8JPFs
   79HXkXG3PK0MUt4lK4GXnMn9MdDhog3f0tHKNSn01WAHJyn0To1OvtaD8
   B/Um9lJoWbc8AzGT7qOSIUXCT10fMJZ/QNjeqfMX/yqrsKVzpyVfjWKdE
   ytP5bkZPNOrt4e1SkuUoNuMwf4tQujaH7yXu/8bxE6tAkRvax8LzerJW1
   gTl/I0EjGyE2pIHFgOPqreGnIziudM/qobvXMyJF1Is2eZrEJNtd86dtM
   hM1MH88mMFb9LNYMKjGT/pDAsafbOBk+RODhmPkl3EBcW9AozXvUrjkff
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="303080011"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="303080011"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 23:51:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="466416659"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 23:50:59 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1my814-0004RZ-FB; Fri, 17 Dec 2021 07:50:58 +0000
Date:   Fri, 17 Dec 2021 15:50:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 04f913cd08324d14b55fbbc8a1110696af9f36ca
Message-ID: <61bc4147.K8TwLZmUKjeC9nJg%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 04f913cd08324d14b55fbbc8a1110696af9f36ca  lib/raid6: Reduce high latency by using migrate instead of preempt

elapsed time: 727m

configs tested: 139
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211216
m68k                       m5475evb_defconfig
sh                           se7712_defconfig
arm                         lubbock_defconfig
arm                        magician_defconfig
arm                         s3c2410_defconfig
ia64                            zx1_defconfig
arm                      tct_hammer_defconfig
powerpc                      katmai_defconfig
sh                            migor_defconfig
sh                           se7724_defconfig
m68k                       m5208evb_defconfig
sparc                               defconfig
mips                        vocore2_defconfig
sh                   rts7751r2dplus_defconfig
i386                             allyesconfig
powerpc                 xes_mpc85xx_defconfig
arm                            pleb_defconfig
mips                         mpc30x_defconfig
powerpc                   currituck_defconfig
mips                     loongson1b_defconfig
m68k                          atari_defconfig
h8300                    h8300h-sim_defconfig
sh                        dreamcast_defconfig
arm                           sunxi_defconfig
sh                           se7722_defconfig
mips                           mtx1_defconfig
arm                        mvebu_v7_defconfig
sparc                       sparc32_defconfig
powerpc                 mpc836x_mds_defconfig
arm                         cm_x300_defconfig
sh                 kfr2r09-romimage_defconfig
arm                         assabet_defconfig
arm                           h5000_defconfig
arm                           sama5_defconfig
riscv                            alldefconfig
mips                malta_qemu_32r6_defconfig
parisc                generic-32bit_defconfig
arm                          ixp4xx_defconfig
arm                        oxnas_v6_defconfig
m68k                            q40_defconfig
sh                         microdev_defconfig
arm                       omap2plus_defconfig
arm                           u8500_defconfig
m68k                         amcore_defconfig
arm                      integrator_defconfig
s390                       zfcpdump_defconfig
arm                       imx_v4_v5_defconfig
arm                        mvebu_v5_defconfig
sparc64                             defconfig
mips                           ip32_defconfig
mips                            e55_defconfig
m68k                             alldefconfig
powerpc                      walnut_defconfig
mips                         bigsur_defconfig
arc                    vdk_hs38_smp_defconfig
mips                          ath25_defconfig
arm                          lpd270_defconfig
sparc                            allyesconfig
ia64                        generic_defconfig
mips                          malta_defconfig
mips                    maltaup_xpa_defconfig
microblaze                      mmu_defconfig
sh                     magicpanelr2_defconfig
h8300                            allyesconfig
powerpc                    adder875_defconfig
arm                  randconfig-c002-20211216
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
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a006-20211216
x86_64               randconfig-a005-20211216
x86_64               randconfig-a001-20211216
x86_64               randconfig-a002-20211216
x86_64               randconfig-a003-20211216
x86_64               randconfig-a004-20211216
i386                 randconfig-a001-20211216
i386                 randconfig-a002-20211216
i386                 randconfig-a005-20211216
i386                 randconfig-a003-20211216
i386                 randconfig-a006-20211216
i386                 randconfig-a004-20211216
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
x86_64               randconfig-a011-20211216
x86_64               randconfig-a014-20211216
x86_64               randconfig-a012-20211216
x86_64               randconfig-a013-20211216
x86_64               randconfig-a016-20211216
x86_64               randconfig-a015-20211216
hexagon              randconfig-r045-20211216
s390                 randconfig-r044-20211216
riscv                randconfig-r042-20211216
hexagon              randconfig-r041-20211216

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
