Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53A0C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 11 Dec 2021 05:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhLKFcJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 11 Dec 2021 00:32:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:64665 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhLKFcI (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 11 Dec 2021 00:32:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639200513; x=1670736513;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=TYJEXaXqcoA1buj3ByvJnRm1C6zCk+66mPlVwZBmQhs=;
  b=JAUYOsx5yV0VrPkZuqFzUP6wQDIO6lOtjbPowfBtHs7Lsy5aHOkM+OaW
   oakG/lwlBDjnZSXiBUS/HzkQcyaDbgwhd6vVkPBvPGValKyEQoofPgDdo
   o7289crN7aYlWWbNwWbElQUtV0zAky+4MFWPgOBEJGx2vRprEwf9Jpk0X
   KH1H9eA8hnYMNKj3tv7mu5EvtW1IMnZn43GGpLZbX/kZyQd21N0Dft0Kr
   bG9RRhDqoBha6ELE7B4K3CglIgL0t6Xsaz2VbIXgNeEVMACCYIfRCqYpk
   GM0N5ugq+skUymUPd0Z3RjOFRjf4zNjwquX+0syQ/i+HUwYcrceywqKPs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="324775162"
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="324775162"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 21:28:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="581970001"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 10 Dec 2021 21:28:30 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mvuvu-00049Y-8v; Sat, 11 Dec 2021 05:28:30 +0000
Date:   Sat, 11 Dec 2021 13:28:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 07641b5f32f6991758b08da9b1f4173feeb64f2a
Message-ID: <61b436f1.oTlsu7qgklOZ3ylW%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 07641b5f32f6991758b08da9b1f4173feeb64f2a  md: fix double free of mddev->private in autorun_array()

elapsed time: 723m

configs tested: 160
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211210
mips                 randconfig-c004-20211210
sh                          r7780mp_defconfig
powerpc                          g5_defconfig
arm                  colibri_pxa270_defconfig
m68k                                defconfig
openrisc                         alldefconfig
powerpc                       ebony_defconfig
arm                           h5000_defconfig
sh                      rts7751r2d1_defconfig
arm                       aspeed_g5_defconfig
sparc64                             defconfig
arm                          ixp4xx_defconfig
sh                           se7780_defconfig
mips                     cu1830-neo_defconfig
powerpc                 xes_mpc85xx_defconfig
ia64                        generic_defconfig
arm                           sama7_defconfig
powerpc                       holly_defconfig
powerpc                   motionpro_defconfig
powerpc                    mvme5100_defconfig
sh                   sh7770_generic_defconfig
powerpc                        icon_defconfig
mips                       rbtx49xx_defconfig
h8300                       h8s-sim_defconfig
i386                             alldefconfig
arc                    vdk_hs38_smp_defconfig
mips                    maltaup_xpa_defconfig
mips                         cobalt_defconfig
mips                        bcm63xx_defconfig
xtensa                generic_kc705_defconfig
m68k                            q40_defconfig
arc                           tb10x_defconfig
arc                     nsimosci_hs_defconfig
nios2                         3c120_defconfig
arm                       multi_v4t_defconfig
sh                           se7619_defconfig
arm                      integrator_defconfig
mips                     loongson2k_defconfig
um                             i386_defconfig
powerpc                     sequoia_defconfig
arm                         lpc32xx_defconfig
microblaze                      mmu_defconfig
sh                        edosk7705_defconfig
m68k                         amcore_defconfig
parisc                generic-32bit_defconfig
powerpc                     kmeter1_defconfig
arm                        trizeps4_defconfig
sh                             sh03_defconfig
ia64                                defconfig
arm64                            alldefconfig
arm                       imx_v4_v5_defconfig
powerpc                  mpc866_ads_defconfig
m68k                          amiga_defconfig
m68k                          sun3x_defconfig
parisc                           allyesconfig
powerpc                 mpc8540_ads_defconfig
m68k                       bvme6000_defconfig
powerpc                      ppc40x_defconfig
arm                  colibri_pxa300_defconfig
arm                         socfpga_defconfig
x86_64                           allyesconfig
sparc                       sparc64_defconfig
mips                  cavium_octeon_defconfig
powerpc                      chrp32_defconfig
m68k                        m5407c3_defconfig
arc                            hsdk_defconfig
csky                             alldefconfig
riscv                    nommu_virt_defconfig
arm                        neponset_defconfig
openrisc                  or1klitex_defconfig
powerpc                     pq2fads_defconfig
alpha                            alldefconfig
arm                       netwinder_defconfig
powerpc                     tqm8541_defconfig
arm                          pxa3xx_defconfig
riscv                            alldefconfig
m68k                       m5275evb_defconfig
xtensa                          iss_defconfig
arm                  randconfig-c002-20211210
ia64                             allmodconfig
ia64                             allyesconfig
m68k                             allmodconfig
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
x86_64               randconfig-a006-20211210
x86_64               randconfig-a005-20211210
x86_64               randconfig-a001-20211210
x86_64               randconfig-a002-20211210
x86_64               randconfig-a003-20211210
x86_64               randconfig-a004-20211210
i386                 randconfig-a001-20211210
i386                 randconfig-a002-20211210
i386                 randconfig-a005-20211210
i386                 randconfig-a003-20211210
i386                 randconfig-a006-20211210
i386                 randconfig-a004-20211210
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
arm                  randconfig-c002-20211210
x86_64               randconfig-c007-20211210
riscv                randconfig-c006-20211210
mips                 randconfig-c004-20211210
i386                 randconfig-c001-20211210
s390                 randconfig-c005-20211210
powerpc              randconfig-c003-20211210
x86_64               randconfig-a012-20211210
x86_64               randconfig-a014-20211210
x86_64               randconfig-a013-20211210
x86_64               randconfig-a016-20211210
x86_64               randconfig-a015-20211210
x86_64               randconfig-a011-20211210
i386                 randconfig-a013-20211210
i386                 randconfig-a011-20211210
i386                 randconfig-a016-20211210
i386                 randconfig-a014-20211210
i386                 randconfig-a015-20211210
i386                 randconfig-a012-20211210
hexagon              randconfig-r045-20211210
riscv                randconfig-r042-20211210
s390                 randconfig-r044-20211210
hexagon              randconfig-r041-20211210

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
