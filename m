Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3B3C43334
	for <linux-raid@archiver.kernel.org>; Fri,  8 Jul 2022 19:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbiGHTAH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Jul 2022 15:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbiGHTAF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Jul 2022 15:00:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC0021801
        for <linux-raid@vger.kernel.org>; Fri,  8 Jul 2022 12:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657306804; x=1688842804;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=lJ/uIuxc5uPacR8v+kVBlBpsWw1p2YC0neHsUBTiYSw=;
  b=bQ2rpvdH16UVLcEYSUCynLbZaFlkDAIUlgvN8DA3jL9m6OfBZSW1+hGe
   Ib7HPUMHg7NJvFCr+W6HLjMSpk+ZDBXfx1bgwIlD6DdLFwD2MT7PRlCxz
   Y4IYqUR2ypAqFwL4JQ+i9RvxqOpgD+p+5ZXNvRldVgm/EhXGuWtF2azV6
   B2hTUobWdpwQ/4U4al9vd2wNHSCAv7zbsUl6OyPYMrxN6BkXEzNIiIJre
   T0FSIB1aJi5W1AzTAMtqFwIDMe6t3EQtKRQghzse/k5vPk2SbJ08l5ovf
   UZYrsEvIopTA9plwmrQ6fmsISWlWrrGdjFua8JD6GlplPzf/UlkqYMKsj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="284366251"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="284366251"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 12:00:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="661866110"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 08 Jul 2022 12:00:03 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9tCs-000NoT-As;
        Fri, 08 Jul 2022 19:00:02 +0000
Date:   Sat, 09 Jul 2022 02:59:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 e3ce2720dc12b8cc9ac5057007b12ac34dfdb58b
Message-ID: <62c87e83.cfQUyvSQzhxboaUd%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: e3ce2720dc12b8cc9ac5057007b12ac34dfdb58b  md/raid5: Convert prepare_to_wait() to wait_woken() api

elapsed time: 726m

configs tested: 80
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
i386                          randconfig-c001
sh                               j2_defconfig
powerpc                     sequoia_defconfig
arm                           h3600_defconfig
mips                         rt305x_defconfig
powerpc                      mgcoge_defconfig
sh                             shx3_defconfig
mips                           xway_defconfig
sh                           se7721_defconfig
sh                           se7750_defconfig
alpha                            alldefconfig
riscv                               defconfig
sh                           se7722_defconfig
xtensa                              defconfig
powerpc                     tqm8555_defconfig
m68k                       m5475evb_defconfig
sh                   sh7770_generic_defconfig
sh                         microdev_defconfig
mips                             allmodconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
ia64                             allmodconfig
m68k                             allmodconfig
alpha                            allyesconfig
arc                              allyesconfig
m68k                             allyesconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
i386                             allyesconfig
i386                                defconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
riscv                randconfig-r042-20220707
arc                  randconfig-r043-20220707
s390                 randconfig-r044-20220707
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit

clang tested configs:
powerpc                  mpc885_ads_defconfig
powerpc                    mvme5100_defconfig
x86_64                        randconfig-k001
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r045-20220707
hexagon              randconfig-r041-20220707

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
