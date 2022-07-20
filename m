Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804C8C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 18:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiGTSvK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 14:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiGTSvC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 14:51:02 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7701547BB5
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 11:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658343060; x=1689879060;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=5I+qru0EQlIJLtZQMToseSWZ2rbkihwWSlNNM2sFKQY=;
  b=HvkI2AC90UokPuH3Su1iM87lCHfT9dmR28j06Ic/otYcFBxE86tzv8Bg
   JGFJGznAdlGyF75+wIDWiPXwBVfl3DTWt9DyYWGMgVEVE3ntD+C17AFqF
   627HxtK/IVhfwpk8HwwBbzHH3CiFLE3foLzXZbIPtN0Zmr+c5m08YHooZ
   1l9QOaOgug2XBbnRaN8tDvGPJeQB79OaryuRX5NQPMtNRgfcurI4HiIZI
   7YR71MV+dXfQs/uyCaRwtQtkYRk5++aC9eCDUWKFsK0DzhTE8JzD2gdKr
   UUnAClAo0MmnKvcpsFGj027vjIaSaOCH4XCtvaLk5BXh4+JFzY4VewzbB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="373160037"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="373160037"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:50:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="630880300"
Received: from lkp-server01.sh.intel.com (HELO 7dfbdc7c7900) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2022 11:50:58 -0700
Received: from kbuild by 7dfbdc7c7900 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oEEmf-0000oN-P7;
        Wed, 20 Jul 2022 18:50:57 +0000
Date:   Thu, 21 Jul 2022 02:50:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 211a3702d5aecd9f20823ebe7dcea5b915fae08f
Message-ID: <62d84e7a.0XsXULGjoQOcwcXl%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 211a3702d5aecd9f20823ebe7dcea5b915fae08f  raid5: fix duplicate checks for rdev->saved_raid_disk

elapsed time: 727m

configs tested: 99
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm                              allyesconfig
arm64                            allyesconfig
i386                 randconfig-c001-20220718
m68k                             alldefconfig
arc                     haps_hs_smp_defconfig
powerpc                     pq2fads_defconfig
sh                         microdev_defconfig
arc                     nsimosci_hs_defconfig
sh                   secureedge5410_defconfig
m68k                        mvme147_defconfig
nios2                         10m50_defconfig
xtensa                              defconfig
m68k                            mac_defconfig
arm                           viper_defconfig
m68k                            q40_defconfig
mips                  decstation_64_defconfig
loongarch                        alldefconfig
s390                                defconfig
s390                             allmodconfig
arc                                 defconfig
alpha                               defconfig
s390                             allyesconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
loongarch                           defconfig
loongarch                         allnoconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
i386                                defconfig
i386                             allyesconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64               randconfig-a014-20220718
x86_64               randconfig-a016-20220718
x86_64               randconfig-a012-20220718
x86_64               randconfig-a013-20220718
x86_64               randconfig-a015-20220718
x86_64               randconfig-a011-20220718
i386                 randconfig-a015-20220718
i386                 randconfig-a011-20220718
i386                 randconfig-a012-20220718
i386                 randconfig-a014-20220718
i386                 randconfig-a016-20220718
i386                 randconfig-a013-20220718
s390                 randconfig-r044-20220718
riscv                randconfig-r042-20220718
arc                  randconfig-r043-20220718
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit

clang tested configs:
arm                      tct_hammer_defconfig
mips                           ip28_defconfig
mips                           rs90_defconfig
arm                           spitz_defconfig
x86_64                        randconfig-k001
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
i386                 randconfig-a004-20220718
i386                 randconfig-a001-20220718
i386                 randconfig-a005-20220718
i386                 randconfig-a006-20220718
i386                 randconfig-a002-20220718
i386                 randconfig-a003-20220718
x86_64               randconfig-a001-20220718
x86_64               randconfig-a005-20220718
x86_64               randconfig-a003-20220718
x86_64               randconfig-a002-20220718
x86_64               randconfig-a006-20220718
x86_64               randconfig-a004-20220718
hexagon              randconfig-r045-20220718
hexagon              randconfig-r041-20220718

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
