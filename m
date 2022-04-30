Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3216C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 30 Apr 2022 23:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbiD3X2I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 30 Apr 2022 19:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiD3X2H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 30 Apr 2022 19:28:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94EA5A5A9
        for <linux-raid@vger.kernel.org>; Sat, 30 Apr 2022 16:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651361084; x=1682897084;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=9qLQeHdM+s8P6T3HiuIDbZeKIAfYcvqI3c3k0TSmr8c=;
  b=XSbQ776bxSYGxDAP96K5boEyqHbO+UPZKx4p3SFJT2lcaE3Av4UWtGDG
   1gUCqKeRF3z6CX2C8BXSpLBfnRTLXEGMxuGBKGcA5dYTAuXaQcaAnIG1z
   SW74+Z1tjMsOzkUCFlpix9uDrsBCrrS4a26PYmjpzJZaVgQHsSriVqpIy
   FuukrKh1dsPrZAaTpPY8Zd1VKzYzh4DSJX3A7fGNgbNUjC8kwM3wjGGac
   IbMdNb/a/ri/l4Ayq+Qm0iNaYxbkMLjkR66/moN6n2J/ykNMcnWHlq0fK
   ClJARDUcSgJNClhalRiPH6jGXp5cX4ZqzfQi6VzsxnZITBDMM357DAaRQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10333"; a="292111194"
X-IronPort-AV: E=Sophos;i="5.91,189,1647327600"; 
   d="scan'208";a="292111194"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2022 16:24:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,189,1647327600"; 
   d="scan'208";a="566650034"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 30 Apr 2022 16:24:43 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nkwSA-0007m7-Rt;
        Sat, 30 Apr 2022 23:24:42 +0000
Date:   Sun, 01 May 2022 07:24:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 9151ad5d8676a89cf1b6a4051037ab3ca077d938
Message-ID: <626dc534.RbjCy7/8VMF672AK%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 9151ad5d8676a89cf1b6a4051037ab3ca077d938  md: Replace role magic numbers with defined constants

elapsed time: 7266m

configs tested: 248
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                               defconfig
arm64                            allyesconfig
arm                              allmodconfig
arm                                 defconfig
arm                              allyesconfig
i386                 randconfig-c001-20220425
i386                          randconfig-c001
ia64                          tiger_defconfig
sh                            shmin_defconfig
mips                           ip32_defconfig
sh                           se7724_defconfig
parisc                generic-32bit_defconfig
sh                  sh7785lcr_32bit_defconfig
powerpc                       ppc64_defconfig
sh                        sh7785lcr_defconfig
powerpc                    sam440ep_defconfig
powerpc                      pasemi_defconfig
sh                           se7619_defconfig
sh                           se7750_defconfig
powerpc                      pcm030_defconfig
xtensa                          iss_defconfig
arm                      integrator_defconfig
m68k                            q40_defconfig
arc                              alldefconfig
arm                           sunxi_defconfig
arm                         lubbock_defconfig
m68k                                defconfig
sh                          sdk7780_defconfig
powerpc                     tqm8555_defconfig
powerpc                     ep8248e_defconfig
s390                                defconfig
mips                         tb0226_defconfig
sh                        edosk7760_defconfig
powerpc                 mpc834x_mds_defconfig
powerpc                      ppc6xx_defconfig
arm                       multi_v4t_defconfig
arm                      jornada720_defconfig
arc                     haps_hs_smp_defconfig
parisc                           alldefconfig
sh                         microdev_defconfig
sh                             sh03_defconfig
arm                       imx_v6_v7_defconfig
ia64                      gensparse_defconfig
m68k                            mac_defconfig
ia64                         bigsur_defconfig
m68k                          sun3x_defconfig
arm                         nhk8815_defconfig
powerpc                        cell_defconfig
arm                         assabet_defconfig
xtensa                generic_kc705_defconfig
openrisc                  or1klitex_defconfig
m68k                       bvme6000_defconfig
arc                           tb10x_defconfig
mips                            gpr_defconfig
arm                            lart_defconfig
powerpc                         ps3_defconfig
sh                          r7785rp_defconfig
powerpc                 mpc8540_ads_defconfig
sh                              ul2_defconfig
sh                          sdk7786_defconfig
arm                           viper_defconfig
m68k                       m5249evb_defconfig
arm                        cerfcube_defconfig
arm                          iop32x_defconfig
xtensa                              defconfig
m68k                        m5272c3_defconfig
sh                             shx3_defconfig
sh                           se7780_defconfig
mips                      maltasmvp_defconfig
arc                     nsimosci_hs_defconfig
sparc                       sparc64_defconfig
xtensa                           alldefconfig
arm                          gemini_defconfig
m68k                       m5208evb_defconfig
xtensa                  cadence_csp_defconfig
parisc                              defconfig
powerpc                     tqm8548_defconfig
sh                         ecovec24_defconfig
sh                   sh7724_generic_defconfig
mips                     loongson1b_defconfig
m68k                        m5307c3_defconfig
arm                          simpad_defconfig
sh                           se7206_defconfig
nios2                            allyesconfig
m68k                          multi_defconfig
arc                        nsim_700_defconfig
mips                       capcella_defconfig
powerpc                 mpc837x_rdb_defconfig
m68k                        mvme147_defconfig
h8300                       h8s-sim_defconfig
arm                       aspeed_g5_defconfig
arm                         cm_x300_defconfig
sh                      rts7751r2d1_defconfig
sparc64                             defconfig
powerpc                  storcenter_defconfig
riscv                            allmodconfig
arc                      axs103_smp_defconfig
powerpc                    amigaone_defconfig
sh                           se7721_defconfig
powerpc                           allnoconfig
powerpc                   currituck_defconfig
powerpc                      cm5200_defconfig
i386                             alldefconfig
m68k                        mvme16x_defconfig
mips                           jazz_defconfig
powerpc                      chrp32_defconfig
h8300                            alldefconfig
arm                        mvebu_v7_defconfig
parisc64                            defconfig
sh                ecovec24-romimage_defconfig
sh                          kfr2r09_defconfig
openrisc                    or1ksim_defconfig
riscv                               defconfig
arm                        spear6xx_defconfig
m68k                          amiga_defconfig
mips                      fuloong2e_defconfig
m68k                         amcore_defconfig
m68k                       m5475evb_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220428
x86_64               randconfig-c001-20220425
arm                  randconfig-c002-20220425
arm                  randconfig-c002-20220427
arm                  randconfig-c002-20220429
arm                  randconfig-c002-20220501
arm                  randconfig-c002-20220426
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
nios2                               defconfig
arc                              allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                             allyesconfig
sparc                               defconfig
sparc                            allyesconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                             allyesconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
x86_64                        randconfig-a002
x86_64               randconfig-a015-20220425
x86_64               randconfig-a014-20220425
x86_64               randconfig-a011-20220425
x86_64               randconfig-a012-20220425
x86_64               randconfig-a016-20220425
x86_64               randconfig-a013-20220425
i386                 randconfig-a011-20220425
i386                 randconfig-a012-20220425
i386                 randconfig-a013-20220425
i386                 randconfig-a015-20220425
i386                 randconfig-a016-20220425
i386                 randconfig-a014-20220425
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
arc                  randconfig-r043-20220425
riscv                randconfig-r042-20220425
s390                 randconfig-r044-20220425
arc                  randconfig-r043-20220428
arc                  randconfig-r043-20220429
s390                 randconfig-r044-20220429
riscv                randconfig-r042-20220429
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
riscv                            allyesconfig
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                          rhel-8.3-func
x86_64                                  kexec
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                         rhel-8.3-kunit
x86_64                               rhel-8.3
x86_64                           rhel-8.3-syz

clang tested configs:
riscv                randconfig-c006-20220428
mips                 randconfig-c004-20220428
x86_64                        randconfig-c007
i386                          randconfig-c001
s390                 randconfig-c005-20220428
arm                  randconfig-c002-20220428
powerpc              randconfig-c003-20220428
powerpc              randconfig-c003-20220501
riscv                randconfig-c006-20220501
mips                 randconfig-c004-20220501
arm                  randconfig-c002-20220501
riscv                randconfig-c006-20220425
mips                 randconfig-c004-20220425
x86_64               randconfig-c007-20220425
arm                  randconfig-c002-20220425
i386                 randconfig-c001-20220425
powerpc              randconfig-c003-20220425
riscv                randconfig-c006-20220429
mips                 randconfig-c004-20220429
arm                  randconfig-c002-20220429
powerpc              randconfig-c003-20220429
arm                        vexpress_defconfig
arm                       cns3420vb_defconfig
arm                         palmz72_defconfig
powerpc                    mvme5100_defconfig
powerpc                      ppc44x_defconfig
arm                         s3c2410_defconfig
arm                            mmp2_defconfig
powerpc                      katmai_defconfig
arm                      pxa255-idp_defconfig
powerpc                 mpc8315_rdb_defconfig
arm                     davinci_all_defconfig
x86_64                           allyesconfig
mips                           ip28_defconfig
mips                      maltaaprp_defconfig
arm                         hackkit_defconfig
mips                           mtx1_defconfig
powerpc                        fsp2_defconfig
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
i386                 randconfig-a006-20220425
i386                 randconfig-a002-20220425
i386                 randconfig-a005-20220425
i386                 randconfig-a003-20220425
i386                 randconfig-a001-20220425
i386                 randconfig-a004-20220425
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64               randconfig-a002-20220425
x86_64               randconfig-a004-20220425
x86_64               randconfig-a003-20220425
x86_64               randconfig-a001-20220425
x86_64               randconfig-a005-20220425
x86_64               randconfig-a006-20220425
hexagon              randconfig-r041-20220425
hexagon              randconfig-r045-20220425
hexagon              randconfig-r041-20220428
riscv                randconfig-r042-20220428
hexagon              randconfig-r045-20220428

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
