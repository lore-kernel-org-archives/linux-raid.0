Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94D5C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 16 Jul 2022 10:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGPKQJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 16 Jul 2022 06:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGPKQI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 16 Jul 2022 06:16:08 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFD31EEE1
        for <linux-raid@vger.kernel.org>; Sat, 16 Jul 2022 03:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657966567; x=1689502567;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=O94saDvox3vN8lIoUs/zZOfGN0gILoi7Mv8vLypBfq0=;
  b=J1fZvmh+TlecZQIAXWA5mltYUofcwCBZ5hcPAYvpcmXX3oTNvNuyTRF5
   RkNZf7x8h0gHZBJdTaz7w++1wYEt0uUZd4LNc70blN8rQF69G/SrzJDL4
   3/i6PEYtwI4E4ztGwoirMGMcrrfeDd0hTAesFdxe+j1A1ILZ7QwcgIeck
   GlvzMhQnMadAacz80LDchkLg/LMPm/RfTC/V2Z3o6Ry/Q4mBpo3fa+L0b
   4AtU1wtbI+zw/ztw0t8yMWat+s87EqGAYg7KUxNk0Ar5dAo4gf90OzCUA
   yhwFYU5zxif0qOJE5zb0jZIMHFusGzibT+epCnxhXuSh1+QeOcyV5Zcln
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="347652259"
X-IronPort-AV: E=Sophos;i="5.92,276,1650956400"; 
   d="scan'208";a="347652259"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2022 03:16:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,276,1650956400"; 
   d="scan'208";a="654662563"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jul 2022 03:16:06 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oCeqD-0001MC-DC;
        Sat, 16 Jul 2022 10:16:05 +0000
Date:   Sat, 16 Jul 2022 18:16:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 2369e0972c95bb8b8bc54d165bfc79cf77d297f5
Message-ID: <62d28fe3.IpHihyP4w0WXsrpK%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 2369e0972c95bb8b8bc54d165bfc79cf77d297f5  md/raid5: Convert prepare_to_wait() to wait_woken() api

elapsed time: 723m

configs tested: 108
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
i386                          randconfig-c001
arm                      footbridge_defconfig
xtensa                              defconfig
openrisc                    or1ksim_defconfig
s390                       zfcpdump_defconfig
m68k                             alldefconfig
arm                     eseries_pxa_defconfig
sh                         ap325rxa_defconfig
arm                          gemini_defconfig
arm                           sama5_defconfig
xtensa                generic_kc705_defconfig
mips                           jazz_defconfig
arm                          simpad_defconfig
arm                       multi_v4t_defconfig
powerpc                     ep8248e_defconfig
sh                        sh7763rdp_defconfig
mips                    maltaup_xpa_defconfig
xtensa                    xip_kc705_defconfig
powerpc                     tqm8555_defconfig
sh                        sh7785lcr_defconfig
sh                           se7721_defconfig
m68k                        mvme147_defconfig
sh                          polaris_defconfig
powerpc                  storcenter_defconfig
arc                            hsdk_defconfig
i386                                defconfig
s390                                defconfig
s390                             allmodconfig
arc                                 defconfig
alpha                               defconfig
s390                             allyesconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
m68k                             allmodconfig
alpha                            allyesconfig
arc                              allyesconfig
m68k                             allyesconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
i386                             allyesconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a015
x86_64                        randconfig-a013
x86_64                        randconfig-a011
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
arc                  randconfig-r043-20220716
arc                  randconfig-r043-20220715
s390                 randconfig-r044-20220716
riscv                randconfig-r042-20220716
x86_64                    rhel-8.3-kselftests
x86_64                           allyesconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit

clang tested configs:
i386                             allyesconfig
arm                    vt8500_v6_v7_defconfig
mips                      pic32mzda_defconfig
mips                           mtx1_defconfig
powerpc                      ppc64e_defconfig
arm                       aspeed_g4_defconfig
arm                          moxart_defconfig
powerpc                     ppa8548_defconfig
mips                      maltaaprp_defconfig
arm                        mvebu_v5_defconfig
arm                         bcm2835_defconfig
riscv                          rv32_defconfig
mips                  cavium_octeon_defconfig
arm                       netwinder_defconfig
mips                       lemote2f_defconfig
arm                   milbeaut_m10v_defconfig
powerpc                    ge_imp3a_defconfig
arm                          collie_defconfig
x86_64                        randconfig-k001
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a012
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r045-20220715
s390                 randconfig-r044-20220715
hexagon              randconfig-r041-20220715
riscv                randconfig-r042-20220715
hexagon              randconfig-r041-20220716
hexagon              randconfig-r045-20220716

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
