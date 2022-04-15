Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC69CC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 15 Apr 2022 15:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354982AbiDOPYH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Apr 2022 11:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355015AbiDOPYD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Apr 2022 11:24:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18866D94D
        for <linux-raid@vger.kernel.org>; Fri, 15 Apr 2022 08:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650036087; x=1681572087;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=mL7OsHn7OQWPdVYd/05DzeC1nh5HRTIs3VNS0UopKZA=;
  b=cK/U6ipjR7me2IwxcvYmWxT3uz7lSt1iOYE0WkibP02PA0F3+gEnZbh0
   LgdNdI1f42ByeFKTnDrHbLIoOYOgdSHdubgM0TqyGoDgu/jCM4rTSXy+u
   zjg4jiZ9NvECL7mauQ4JDlowBMEdcjMnyunGEKtJKvEQ8ISXBQqv2P9/7
   ndKRzmgprtZVbOUpF0VJmscXyghhGqzMA5jPrwLsLUUqYLIYuKIQYW0S0
   zj7XHggj1BE2CphZbO7Ep3u9uDwBGzptt9YwuVaOkXeOZ3y7yXd74lcVo
   vF+E6ipmE/2loCPIvugXx/4HwVNcRFwUF21lRvqKZC3PsS8WYz2QuYyaI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="349602769"
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="349602769"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 08:21:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,262,1643702400"; 
   d="scan'208";a="553184771"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 15 Apr 2022 08:21:13 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nfNl2-00025T-Sa;
        Fri, 15 Apr 2022 15:21:12 +0000
Date:   Fri, 15 Apr 2022 23:20:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 190a901246c69d79dadd1ab574022548da612724
Message-ID: <62598d54.N8OeGONzW/uQTRf7%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 190a901246c69d79dadd1ab574022548da612724  md/raid0: Ignore RAID0 layout if the second zone has only one device

elapsed time: 722m

configs tested: 108
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
powerpc              randconfig-c003-20220414
sh                   secureedge5410_defconfig
powerpc                   motionpro_defconfig
arc                     haps_hs_smp_defconfig
arc                          axs103_defconfig
m68k                        stmark2_defconfig
powerpc64                           defconfig
powerpc                      bamboo_defconfig
microblaze                          defconfig
sparc                            allyesconfig
mips                     loongson1b_defconfig
arm                          pxa910_defconfig
powerpc                         wii_defconfig
arc                        vdk_hs38_defconfig
mips                           jazz_defconfig
sh                           se7724_defconfig
arm                           imxrt_defconfig
arm                            mps2_defconfig
mips                     decstation_defconfig
s390                          debug_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220414
ia64                             allmodconfig
ia64                             allyesconfig
ia64                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
nios2                               defconfig
arc                              allyesconfig
csky                                defconfig
nios2                            allyesconfig
alpha                               defconfig
alpha                            allyesconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                                defconfig
s390                             allmodconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                             allyesconfig
sparc                               defconfig
i386                             allyesconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
riscv                randconfig-r042-20220415
arc                  randconfig-r043-20220415
s390                 randconfig-r044-20220415
riscv                               defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
riscv                            allmodconfig
riscv                            allyesconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                          rhel-8.3-func
x86_64                                  kexec
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                         rhel-8.3-kunit
x86_64                               rhel-8.3

clang tested configs:
x86_64                        randconfig-c007
powerpc              randconfig-c003-20220414
arm                  randconfig-c002-20220414
i386                          randconfig-c001
riscv                randconfig-c006-20220414
x86_64                           allyesconfig
mips                           ip28_defconfig
powerpc                     kmeter1_defconfig
powerpc                      acadia_defconfig
arm                       mainstone_defconfig
mips                       rbtx49xx_defconfig
arm                      tct_hammer_defconfig
powerpc                     tqm5200_defconfig
arm                        multi_v5_defconfig
mips                           mtx1_defconfig
arm                        spear3xx_defconfig
arm                        vexpress_defconfig
arm                          collie_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
