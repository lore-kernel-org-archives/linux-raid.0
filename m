Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7042C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 12 May 2022 14:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354997AbiELOEg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 May 2022 10:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354979AbiELOEc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 May 2022 10:04:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDD625B076
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 07:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652364271; x=1683900271;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ldDxHSZS1KnE4YddfV23OZBStgEgvRVHIdarP0vkUkM=;
  b=nVmg8VYo49lP/C50yk0B/dTlhzBp9glYWgkTqARbHt+c9Ju23GjicJAE
   J611jRxlVPj5b/DLgWCzGpEPkg7WPvdwDxEt/f5C1vcbh7fqz8XRA+plh
   u2AJx8DG4AYQz3H1X/6LI2eBqHzPSC9Q2LFSoFJso/hVGF1+48i0+iFnt
   bqzbuPvGhV3EgQOzrjEROH8WvTJCyeBtJ4oRMMtsvOjdRw8hMd7H+iee+
   anhr/s9D/rZhmiADkDa/bw0QxGe5E3lNkKjV9BwQ6W1mzvYUWY/EXVuFz
   ju1IyhNgf6pFasq11LHOW2i1yjJcUUCNSsi33l6XAPQqyB8ha3LocyACA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="252060002"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="252060002"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 07:04:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="542783916"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2022 07:04:27 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1np9QY-000KXd-K8;
        Thu, 12 May 2022 14:04:26 +0000
Date:   Thu, 12 May 2022 22:03:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 74fe94569da7d7aaac7dcf315a1a3a2e4026349f
Message-ID: <627d13c9.ERQac4rm5xdDo28U%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 74fe94569da7d7aaac7dcf315a1a3a2e4026349f  md: protect md_unregister_thread from reentrancy

elapsed time: 933m

configs tested: 192
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                               defconfig
arm64                            allyesconfig
arm                              allmodconfig
arm                                 defconfig
arm                              allyesconfig
i386                          randconfig-c001
i386                 randconfig-c001-20220509
arm                         lpc18xx_defconfig
sh                          rsk7269_defconfig
mips                          rb532_defconfig
powerpc                 mpc834x_mds_defconfig
powerpc64                           defconfig
sh                        edosk7760_defconfig
arc                          axs101_defconfig
h8300                       h8s-sim_defconfig
xtensa                generic_kc705_defconfig
ia64                         bigsur_defconfig
arm                            pleb_defconfig
xtensa                          iss_defconfig
arc                        nsim_700_defconfig
powerpc                 linkstation_defconfig
powerpc                       eiger_defconfig
arm                           h3600_defconfig
arm                          iop32x_defconfig
arm                         cm_x300_defconfig
um                               alldefconfig
xtensa                  cadence_csp_defconfig
arm                         at91_dt_defconfig
sh                          r7785rp_defconfig
sh                                  defconfig
powerpc                  storcenter_defconfig
sparc                       sparc64_defconfig
arm                       aspeed_g5_defconfig
ia64                        generic_defconfig
xtensa                  nommu_kc705_defconfig
sh                          polaris_defconfig
sh                            hp6xx_defconfig
sparc                            alldefconfig
arc                         haps_hs_defconfig
m68k                          multi_defconfig
sh                          sdk7780_defconfig
s390                             allyesconfig
nios2                         10m50_defconfig
openrisc                 simple_smp_defconfig
sh                         ecovec24_defconfig
mips                  maltasmvp_eva_defconfig
sparc                       sparc32_defconfig
sh                           se7750_defconfig
arm                          exynos_defconfig
m68k                       m5208evb_defconfig
powerpc                      pcm030_defconfig
mips                       capcella_defconfig
arc                    vdk_hs38_smp_defconfig
mips                            ar7_defconfig
xtensa                    smp_lx200_defconfig
sh                         microdev_defconfig
m68k                        m5272c3_defconfig
powerpc                 mpc837x_mds_defconfig
m68k                        mvme147_defconfig
powerpc                        cell_defconfig
ia64                                defconfig
sh                           se7722_defconfig
openrisc                  or1klitex_defconfig
m68k                        m5407c3_defconfig
riscv                               defconfig
xtensa                           alldefconfig
powerpc                   currituck_defconfig
sh                     sh7710voipgw_defconfig
ia64                          tiger_defconfig
sh                        apsh4ad0a_defconfig
powerpc                      ep88xc_defconfig
powerpc                         ps3_defconfig
arm                             rpc_defconfig
arm                        spear6xx_defconfig
openrisc                         alldefconfig
powerpc                 mpc834x_itx_defconfig
powerpc                      cm5200_defconfig
x86_64               randconfig-c001-20220509
arm                  randconfig-c002-20220509
x86_64                        randconfig-c001
arm                  randconfig-c002-20220512
ia64                             allmodconfig
ia64                             allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
nios2                               defconfig
arc                              allyesconfig
alpha                               defconfig
csky                                defconfig
alpha                            allyesconfig
nios2                            allyesconfig
arc                                 defconfig
h8300                            allyesconfig
xtensa                           allyesconfig
sh                               allmodconfig
s390                                defconfig
s390                             allmodconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
sparc                               defconfig
i386                             allyesconfig
sparc                            allyesconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64               randconfig-a015-20220509
x86_64               randconfig-a012-20220509
x86_64               randconfig-a016-20220509
x86_64               randconfig-a014-20220509
x86_64               randconfig-a013-20220509
x86_64               randconfig-a011-20220509
i386                 randconfig-a011-20220509
i386                 randconfig-a013-20220509
i386                 randconfig-a016-20220509
i386                 randconfig-a015-20220509
i386                 randconfig-a014-20220509
i386                 randconfig-a012-20220509
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
s390                 randconfig-r044-20220512
riscv                randconfig-r042-20220512
arc                  randconfig-r043-20220512
arc                  randconfig-r043-20220509
s390                 randconfig-r044-20220509
riscv                randconfig-r042-20220509
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
riscv                            allmodconfig
riscv                            allyesconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                                  kexec
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                         rhel-8.3-kunit
x86_64                               rhel-8.3

clang tested configs:
s390                 randconfig-c005-20220512
powerpc              randconfig-c003-20220512
x86_64                        randconfig-c007
riscv                randconfig-c006-20220512
mips                 randconfig-c004-20220512
i386                          randconfig-c001
arm                  randconfig-c002-20220512
powerpc                      acadia_defconfig
mips                       rbtx49xx_defconfig
mips                        maltaup_defconfig
mips                      maltaaprp_defconfig
mips                        omega2p_defconfig
arm                  colibri_pxa300_defconfig
arm                       versatile_defconfig
powerpc                     ppa8548_defconfig
arm                         shannon_defconfig
powerpc                    mvme5100_defconfig
x86_64               randconfig-a006-20220509
x86_64               randconfig-a002-20220509
x86_64               randconfig-a001-20220509
x86_64               randconfig-a004-20220509
x86_64               randconfig-a005-20220509
x86_64               randconfig-a003-20220509
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
i386                 randconfig-a004-20220509
i386                 randconfig-a006-20220509
i386                 randconfig-a002-20220509
i386                 randconfig-a003-20220509
i386                 randconfig-a001-20220509
i386                 randconfig-a005-20220509
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
hexagon              randconfig-r045-20220509
hexagon              randconfig-r041-20220509
hexagon              randconfig-r045-20220512
hexagon              randconfig-r041-20220512

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
