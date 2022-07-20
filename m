Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6C5C43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 06:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiGTGYU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 02:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239846AbiGTGYM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 02:24:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F039459B2
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 23:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658298252; x=1689834252;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=vEbKmareAjUsbgsbja99cTO2r0Wj3L5/B1Ty6MgMVho=;
  b=G0zQoF7Mgfy5HXVOes88xTGQB1jfCE2ZApTGb1KxLTLonw9Jz+HTDK/s
   kVH5iuRqAdR8RMAx5KE9pL+2W9W20rzhdkqqZFGJN6q0XS4k5VsuBL2Nu
   PSw3+Q+bf9K7H+cKRW7qYYafR3tIWYHj3ZsFbyFCf5k4O6hrxhKKng6T4
   RP4/X4ZX72B1OStDJ8kjuBflL8osrDIwbEDVVgeIYYp46m1bV9qrvbEl5
   HmwPvsUS/4l98W4BwYMs9+2w6jpeky+ArSZNFjmOlZBsfR+VAdg9sR8TV
   nBULW0SI6jwGZgml+fSY/SqIFgYUCeFsz4IywhQ79GlDoL9DDgMmJWUVu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="348385376"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="348385376"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 23:24:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="625527806"
Received: from lkp-server01.sh.intel.com (HELO 7dfbdc7c7900) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 19 Jul 2022 23:24:10 -0700
Received: from kbuild by 7dfbdc7c7900 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oE37x-00006B-Rd;
        Wed, 20 Jul 2022 06:24:09 +0000
Date:   Wed, 20 Jul 2022 14:23:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 5f7ef4875f99538b741527963ffe09e869b49826
Message-ID: <62d79f68.PP37EMyhdRV5i9nM%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 5f7ef4875f99538b741527963ffe09e869b49826  md/raid5: missing error code in setup_conf()

elapsed time: 724m

configs tested: 116
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
i386                          randconfig-c001
i386                 randconfig-c001-20220718
arm                        realview_defconfig
arm                             rpc_defconfig
powerpc                     sequoia_defconfig
powerpc                 mpc837x_rdb_defconfig
powerpc                    sam440ep_defconfig
xtensa                    smp_lx200_defconfig
arm                          pxa3xx_defconfig
powerpc                       maple_defconfig
m68k                        m5307c3_defconfig
m68k                             alldefconfig
arc                     haps_hs_smp_defconfig
powerpc                     pq2fads_defconfig
sh                         microdev_defconfig
arc                     nsimosci_hs_defconfig
powerpc                      ep88xc_defconfig
arm                      footbridge_defconfig
powerpc                     ep8248e_defconfig
arc                        nsimosci_defconfig
sh                             shx3_defconfig
mips                           jazz_defconfig
xtensa                  cadence_csp_defconfig
sh                           se7343_defconfig
arm                         at91_dt_defconfig
mips                      loongson3_defconfig
sh                        dreamcast_defconfig
xtensa                       common_defconfig
mips                            gpr_defconfig
sh                          lboxre2_defconfig
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
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
i386                             allyesconfig
i386                                defconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
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
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
s390                 randconfig-r044-20220718
riscv                randconfig-r042-20220718
arc                  randconfig-r043-20220718
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit

clang tested configs:
arm                     am200epdkit_defconfig
riscv                            alldefconfig
arm                        magician_defconfig
powerpc                 mpc832x_rdb_defconfig
arm                          pcm027_defconfig
mips                          malta_defconfig
hexagon                          alldefconfig
powerpc                    gamecube_defconfig
mips                      maltaaprp_defconfig
mips                        maltaup_defconfig
powerpc                     mpc5200_defconfig
mips                          ath25_defconfig
x86_64                        randconfig-k001
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
i386                 randconfig-a004-20220718
i386                 randconfig-a001-20220718
i386                 randconfig-a005-20220718
i386                 randconfig-a006-20220718
i386                 randconfig-a002-20220718
i386                 randconfig-a003-20220718
hexagon              randconfig-r041-20220718
hexagon              randconfig-r045-20220718

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
