Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FE5C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 08:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJUImR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Oct 2022 04:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiJUImQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Oct 2022 04:42:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5534824E3A5
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 01:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666341733; x=1697877733;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=I8ecKh7aWDplHi9q6X3WU2mW++Z9UQ4rDkleAvVoik8=;
  b=KjQgZRAOg4D/7sCole5LENjp29Nq1k92ZFeUp+FAozFKQyngcoM6aBZy
   2sDUHOW/pcZmyaTisTz84kVupvtkMIZYfEGPZo7TxKezZXwLxbZkjpIP8
   cGb0zHNz02ZN0Tkfjwz4gnVT/npKMs//I+00D2S4EgddFhJbrJvijHxIl
   A+/CKVWaTUctDRe7iY526//aJGZJ95SIdlw5KFGjYcfP+52sCSSsUpT4f
   G72IwBdQKqXAXePN33ZkCq6PaHwHYuVuR0Sz+EAn3JanDtNP5NPHcFny0
   yi8c6muGpGgKSGAWKZ+8kEK/mAQ87Wzj28hfrg8f3u/binpAlk4eWKWR+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="305687061"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="305687061"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 01:41:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="661485211"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="661485211"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 21 Oct 2022 01:41:56 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1olnbH-0002Rb-1k;
        Fri, 21 Oct 2022 08:41:55 +0000
Date:   Fri, 21 Oct 2022 16:41:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 c748adfcbe0bd0c760c68d78434a1dfc0344b6b6
Message-ID: <63525b49.Ea214q4upqHANjSU%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: c748adfcbe0bd0c760c68d78434a1dfc0344b6b6  md/bitmap: Fix bitmap chunk size overflow issues

elapsed time: 726m

configs tested: 102
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
powerpc                           allnoconfig
arc                                 defconfig
x86_64                          rhel-8.3-func
s390                             allmodconfig
x86_64                    rhel-8.3-kselftests
alpha                               defconfig
s390                                defconfig
x86_64                              defconfig
s390                             allyesconfig
arc                  randconfig-r043-20221019
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
i386                                defconfig
x86_64                           rhel-8.3-kvm
sh                               allmodconfig
x86_64                               rhel-8.3
mips                             allyesconfig
arm                                 defconfig
x86_64                           allyesconfig
powerpc                          allmodconfig
m68k                             allmodconfig
i386                             allyesconfig
x86_64                        randconfig-a013
arc                              allyesconfig
x86_64                        randconfig-a011
alpha                            allyesconfig
arm64                            allyesconfig
x86_64                        randconfig-a015
arm                              allyesconfig
m68k                             allyesconfig
x86_64                        randconfig-a002
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
sh                           se7750_defconfig
sh                           se7343_defconfig
nios2                         10m50_defconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a006
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
m68k                       m5475evb_defconfig
xtensa                              defconfig
sparc                            alldefconfig
arm                          badge4_defconfig
mips                           ci20_defconfig
m68k                        mvme147_defconfig
openrisc                            defconfig
mips                       bmips_be_defconfig
sh                ecovec24-romimage_defconfig
arm                      footbridge_defconfig
sh                     magicpanelr2_defconfig
arm                          gemini_defconfig
mips                  maltasmvp_eva_defconfig
arc                  randconfig-r043-20221018
arc                  randconfig-r043-20221020
s390                 randconfig-r044-20221018
s390                 randconfig-r044-20221020
riscv                randconfig-r042-20221018
riscv                randconfig-r042-20221020
i386                          randconfig-c001
m68k                            q40_defconfig
powerpc                     tqm8541_defconfig
arm                           stm32_defconfig
powerpc                      chrp32_defconfig
openrisc                         alldefconfig
powerpc                       holly_defconfig
m68k                         apollo_defconfig
arc                        vdk_hs38_defconfig
sh                           se7712_defconfig

clang tested configs:
riscv                randconfig-r042-20221019
hexagon              randconfig-r045-20221019
hexagon              randconfig-r041-20221019
s390                 randconfig-r044-20221019
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a002
x86_64                        randconfig-a001
i386                          randconfig-a004
i386                          randconfig-a006
i386                          randconfig-a013
i386                          randconfig-a015
x86_64                        randconfig-a003
i386                          randconfig-a011
x86_64                        randconfig-a005
mips                          ath79_defconfig
arm                         shannon_defconfig
mips                     cu1830-neo_defconfig
arm                       mainstone_defconfig
arm                  colibri_pxa300_defconfig
hexagon              randconfig-r045-20221018
hexagon              randconfig-r041-20221018
x86_64                        randconfig-k001
arm                        magician_defconfig
hexagon              randconfig-r041-20221020
hexagon              randconfig-r045-20221020
arm                          ep93xx_defconfig
powerpc                 mpc836x_rdk_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
