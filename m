Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302BDC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 23:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbiCIXE3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236583AbiCIXE1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 18:04:27 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2670120F70
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 15:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646867007; x=1678403007;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Bo3+qEejyFF7IPMyZ2NBAqitRsGe6tafnpUKb2QZcXE=;
  b=BHNsOa+0VrqsFVnAt7GgXIBHo5ScxkIO8a+R4XMTtXAVxoHhGQNYdq7M
   P/9L9byqYZBJM7UXMcyibXwkxVrYnae+JwxtxI/+M68EnzerGYGqPb6ta
   zCGI0oj2z1MIXja3eYgAxNFBXIPuTbEfuUZ+hh/9azkKTzXyn1LsRTU/g
   mnMushpMpW1G4MLLxU/rVV7s3fnBgBfvgk+gvnvyRYEfXG5ThDuHlosO0
   lLYyrRn2gqk140UyHt2OB+Mk0AO12KZkhXUKsm6TgwEoRf/LHFx/DF5wI
   FfKT5eztOk7fZdkUGSgL0xSim4HNPw+DpFii82HDZsgLYMC4NIiJYO7oP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="315828362"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="315828362"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 15:03:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="496020145"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 09 Mar 2022 15:03:12 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nS5Kp-0003vo-LV; Wed, 09 Mar 2022 23:03:11 +0000
Date:   Thu, 10 Mar 2022 07:02:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:tmp/fix-5.17] BUILD SUCCESS
 c06ccb305e697d89fe99376c9036d1a2ece44c77
Message-ID: <6229321c.v1nPBGhuWlWdyV1h%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tmp/fix-5.17
branch HEAD: c06ccb305e697d89fe99376c9036d1a2ece44c77  block: check morerequests for multiple_queues in blk_attempt_plug_merge

elapsed time: 723m

configs tested: 173
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                          randconfig-c001
mips                  maltasmvp_eva_defconfig
powerpc                     sequoia_defconfig
powerpc                     taishan_defconfig
ia64                             alldefconfig
arm                        clps711x_defconfig
m68k                       m5208evb_defconfig
sparc64                          alldefconfig
sh                              ul2_defconfig
sh                          r7785rp_defconfig
sh                     magicpanelr2_defconfig
powerpc                      tqm8xx_defconfig
arm                         cm_x300_defconfig
arm                       multi_v4t_defconfig
sh                            migor_defconfig
h8300                     edosk2674_defconfig
sh                           se7206_defconfig
arm                           corgi_defconfig
arm                        spear6xx_defconfig
mips                           gcw0_defconfig
sh                          sdk7786_defconfig
mips                       capcella_defconfig
arm                           viper_defconfig
sh                          rsk7203_defconfig
powerpc                    klondike_defconfig
powerpc                 mpc8540_ads_defconfig
arc                          axs103_defconfig
arm                       aspeed_g5_defconfig
sh                        apsh4ad0a_defconfig
openrisc                 simple_smp_defconfig
openrisc                    or1ksim_defconfig
m68k                         apollo_defconfig
parisc64                         alldefconfig
powerpc                  iss476-smp_defconfig
powerpc                   currituck_defconfig
powerpc                 mpc85xx_cds_defconfig
sh                           se7780_defconfig
powerpc                      pasemi_defconfig
m68k                        m5307c3_defconfig
sh                             sh03_defconfig
m68k                        mvme16x_defconfig
sh                                  defconfig
sh                 kfr2r09-romimage_defconfig
sparc                       sparc64_defconfig
arm                           tegra_defconfig
arm                         axm55xx_defconfig
arc                 nsimosci_hs_smp_defconfig
h8300                               defconfig
m68k                          multi_defconfig
mips                     loongson1b_defconfig
sh                          lboxre2_defconfig
mips                         rt305x_defconfig
sh                          rsk7264_defconfig
arm                          exynos_defconfig
sh                   sh7724_generic_defconfig
arm                        mini2440_defconfig
powerpc                      chrp32_defconfig
sh                         ap325rxa_defconfig
parisc                generic-32bit_defconfig
powerpc                 mpc837x_mds_defconfig
sh                            hp6xx_defconfig
openrisc                         alldefconfig
sh                             espt_defconfig
powerpc                     rainier_defconfig
mips                            gpr_defconfig
powerpc                        cell_defconfig
sh                           se7705_defconfig
sh                           se7722_defconfig
arm                        keystone_defconfig
powerpc                 mpc837x_rdb_defconfig
s390                          debug_defconfig
sh                               j2_defconfig
arm                            qcom_defconfig
powerpc                     stx_gp3_defconfig
mips                           xway_defconfig
arm                  randconfig-c002-20220309
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
csky                                defconfig
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
parisc64                            defconfig
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
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
arc                  randconfig-r043-20220309
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
x86_64                         rhel-8.3-kunit
x86_64                                  kexec

clang tested configs:
x86_64                        randconfig-c007
riscv                randconfig-c006-20220309
powerpc              randconfig-c003-20220309
i386                          randconfig-c001
arm                  randconfig-c002-20220309
powerpc                 mpc836x_rdk_defconfig
powerpc                 mpc832x_rdb_defconfig
powerpc                       ebony_defconfig
mips                           ip22_defconfig
powerpc                      obs600_defconfig
mips                malta_qemu_32r6_defconfig
arm                            mmp2_defconfig
powerpc                          allyesconfig
arm                           sama7_defconfig
mips                            e55_defconfig
powerpc                     ppa8548_defconfig
powerpc               mpc834x_itxgp_defconfig
powerpc                     akebono_defconfig
arm                       mainstone_defconfig
arm                      pxa255-idp_defconfig
powerpc                 mpc8315_rdb_defconfig
mips                        omega2p_defconfig
arm                        neponset_defconfig
arm                       netwinder_defconfig
powerpc                      katmai_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a011
i386                          randconfig-a013
i386                          randconfig-a015
hexagon              randconfig-r045-20220309
hexagon              randconfig-r041-20220309
riscv                randconfig-r042-20220309

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
