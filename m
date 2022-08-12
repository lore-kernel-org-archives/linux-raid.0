Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0E4C00140
	for <linux-raid@archiver.kernel.org>; Fri, 12 Aug 2022 06:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbiHLGsi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Aug 2022 02:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiHLGsh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 Aug 2022 02:48:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EEAA573D
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 23:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660286916; x=1691822916;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=oiLZCrjQ+12b9KgyJH+mXaFOQGLtKsboggmnuWMZrQg=;
  b=ZSoDjz4jWQ7gUm7XgIFmfpVHuXlRCmOOkTpdGEhTH/bOJI3FLxaRiiLz
   nB1ICdfhZdA7tjhhPjt+913ng3anxyKji8T+FE6aGiZE2km/Jwls6IKyE
   S7HGclfYKOZEFgHThDxxIKigxFozdvCmO0abxRt+pXRC/nU6fvq/FNnZM
   IBNWPImzjJG6e56Y72yny3hWd/GdPDAV005kq+OUfX/denrUO82OEITg4
   saqpApJkdXKbh9LzCrLdTmX4oXbJGVrZq65cZ35953k/ZGcQfpZnEwH9I
   l3yAmbNkGg7ox+XNRF4BmGe0OlG2vauiluH5QE8DVDF6tKshJjlG9XAdZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="292799474"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="292799474"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 23:48:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="638798057"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 11 Aug 2022 23:48:35 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMOTC-0000GJ-1s;
        Fri, 12 Aug 2022 06:48:34 +0000
Date:   Fri, 12 Aug 2022 14:47:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 0518e991b2da0d829f8c09028f0cad066f9a6efa
Message-ID: <62f5f79a.v6I20timPMxvY4yK%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 0518e991b2da0d829f8c09028f0cad066f9a6efa  md: Flush workqueue md_rdev_misc_wq in md_alloc()

elapsed time: 715m

configs tested: 89
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
i386                                defconfig
i386                             allyesconfig
um                             i386_defconfig
um                           x86_64_defconfig
arc                  randconfig-r043-20220811
x86_64                    rhel-8.3-kselftests
i386                          randconfig-a014
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
i386                          randconfig-a012
arc                              allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
alpha                            allyesconfig
mips                             allyesconfig
x86_64                           rhel-8.3-syz
i386                          randconfig-a016
i386                          randconfig-a001
x86_64                           rhel-8.3-kvm
m68k                             allmodconfig
i386                          randconfig-a003
arm                                 defconfig
x86_64                        randconfig-a004
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a002
sh                               allmodconfig
x86_64                        randconfig-a011
m68k                             allyesconfig
x86_64                              defconfig
x86_64                        randconfig-a015
x86_64                        randconfig-a006
arm                              allyesconfig
x86_64                               rhel-8.3
arm64                            allyesconfig
x86_64                           allyesconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
xtensa                  cadence_csp_defconfig
arm64                            alldefconfig
ia64                            zx1_defconfig
loongarch                           defconfig
loongarch                         allnoconfig
ia64                             allmodconfig
sh                   secureedge5410_defconfig
sh                          rsk7264_defconfig
m68k                       m5475evb_defconfig
sh                        sh7757lcr_defconfig
arc                           tb10x_defconfig
sh                            titan_defconfig
arm                           tegra_defconfig
i386                          randconfig-c001
m68k                        mvme147_defconfig
csky                             alldefconfig
mips                            gpr_defconfig
xtensa                           allyesconfig
arc                        nsimosci_defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func

clang tested configs:
hexagon              randconfig-r045-20220811
hexagon              randconfig-r041-20220811
riscv                randconfig-r042-20220811
s390                 randconfig-r044-20220811
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a002
i386                          randconfig-a015
i386                          randconfig-a006
x86_64                        randconfig-a005
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a001
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a003
x86_64                        randconfig-k001
mips                        omega2p_defconfig
mips                  cavium_octeon_defconfig
powerpc                 xes_mpc85xx_defconfig
arm                   milbeaut_m10v_defconfig
powerpc                     kmeter1_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
