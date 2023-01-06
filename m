Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7625BC3DA7A
	for <linux-raid@archiver.kernel.org>; Fri,  6 Jan 2023 20:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbjAFUWz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 Jan 2023 15:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbjAFUWg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 Jan 2023 15:22:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567CF88DE7
        for <linux-raid@vger.kernel.org>; Fri,  6 Jan 2023 12:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673036468; x=1704572468;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Wz7eIUDiE4+B/o1SzyrBzvsdOuLbNkWF56z4xYDcSSY=;
  b=aXgepsMGUPZGdKoW0gUafSAQizdQBGknd1GmoTr6K2RHfV2lLCJ+/6os
   m739c4/fk1R9KPbvtk9tAgPLyuYZRt+9N+pqKkTfmSleHRepdgcThKmaX
   BEVUQAdrpV3h7qe9M7kC1ZEuU47QXhXyftd1jjO+kohtMXhqP5XMkBdIf
   6qzH6qgQFgvHvKdTwAQe0SBDfbPGHOEOxzNg0dbszF6qPo9vaVVFC3tn2
   v5oM8FuvEGCYIUYBcaZHZg33s+12f8CKTeh2qBxpYWw30iIM3FOwiy25q
   3zAkMpTV+kXY+kso/lGT2KkL3G1ulZbnBJjq40XidF0YBJL3hOKRCMW87
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="302917092"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="302917092"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 12:21:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763628591"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="763628591"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jan 2023 12:21:06 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pDtD8-0003rY-05;
        Fri, 06 Jan 2023 20:21:06 +0000
Date:   Sat, 07 Jan 2023 04:20:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:new_module_alloc_build_test] BUILD REGRESSION
 59c58e6f71e349eab2b969a214f7a2c0f60490ae
Message-ID: <63b8827e.clJQX2wg+I+tiX7m%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git new_module_alloc_build_test
branch HEAD: 59c58e6f71e349eab2b969a214f7a2c0f60490ae  module: replace module_layout with module_memory

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202301061151.XetztmJd-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

arch/parisc/kernel/module.c:89:21: error: 'lod' undeclared (first use in this function); did you mean 'loc'?

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
`-- parisc-allyesconfig
    `-- arch-parisc-kernel-module.c:error:lod-undeclared-(first-use-in-this-function)

elapsed time: 720m

configs tested: 72
configs skipped: 2

gcc tested configs:
x86_64                            allnoconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a014
i386                          randconfig-a012
arc                  randconfig-r043-20230106
i386                          randconfig-a016
arm                  randconfig-r046-20230106
arm                      jornada720_defconfig
i386                          randconfig-a005
powerpc                       maple_defconfig
sh                           se7751_defconfig
csky                             alldefconfig
sh                        edosk7760_defconfig
arm                        spear6xx_defconfig
sh                                  defconfig
sh                          sdk7786_defconfig
i386                             allyesconfig
i386                                defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
x86_64                           rhel-8.3-bpf
x86_64                         rhel-8.3-kunit
i386                          randconfig-c001
powerpc                    klondike_defconfig
mips                     decstation_defconfig
powerpc                        warp_defconfig
powerpc                           allnoconfig
um                             i386_defconfig
arm                                 defconfig
um                           x86_64_defconfig
arc                                 defconfig
m68k                             allyesconfig
s390                             allmodconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                               defconfig
arm                              allyesconfig
alpha                            allyesconfig
s390                                defconfig
arm64                            allyesconfig
sh                               allmodconfig
s390                             allyesconfig
mips                             allyesconfig
powerpc                          allmodconfig

clang tested configs:
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a013
i386                          randconfig-a011
x86_64                        randconfig-a016
hexagon              randconfig-r041-20230106
s390                 randconfig-r044-20230106
i386                          randconfig-a015
arm                          pxa168_defconfig
riscv                randconfig-r042-20230106
i386                              allnoconfig
hexagon              randconfig-r045-20230106
arm                       netwinder_defconfig
arm                         orion5x_defconfig
arm                           omap1_defconfig
powerpc                 mpc8272_ads_defconfig
arm                            dove_defconfig
i386                          randconfig-a006
mips                        maltaup_defconfig
x86_64                          rhel-8.3-rust

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
