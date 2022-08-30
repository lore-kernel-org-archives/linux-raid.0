Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFE3ECAAA1
	for <linux-raid@archiver.kernel.org>; Tue, 30 Aug 2022 13:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiH3NDZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 Aug 2022 09:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiH3NDY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 Aug 2022 09:03:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E64893201
        for <linux-raid@vger.kernel.org>; Tue, 30 Aug 2022 06:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661864603; x=1693400603;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=7Dz1ULU7SGibLFMjvVWDeY4DQgsfkv00eFjvjNyZ5PU=;
  b=bbzkmyw8+h2nRvQhj+jOMaFizqamj/xPb47gRGYRgbBdRg7AnO6jgIXy
   f1+8Op1eHCnHO2spCeV/JKsR3Adlu7id1LvemMuSTBkkb+lNXuLDzMCna
   CD/RJdUItsYk2k69EgZdn4MSNGvFArHAddnjoDjZ+rl+ggBNp4r8QJBI4
   UPdHQhKu8M5Xamt5QhE8En6YvXlkcBDL9z6MQNaguEfcNXsHcB6GxOB2E
   cdG4nZ+/J5pXBOIWJ7bXStKx5316K4n1gvin4XI25uwSPXySMw5c1OEwy
   yNbqLczB3XJvLKtb8+7h4uMoKzSvZRcimBYl/JfqQ5L6zFrJVZVi1sHNn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295168936"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295168936"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 06:03:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="940011028"
Received: from lkp-server02.sh.intel.com (HELO 77b6d4e16fc5) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 30 Aug 2022 06:03:19 -0700
Received: from kbuild by 77b6d4e16fc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oT0ti-0000Hf-1r;
        Tue, 30 Aug 2022 13:03:18 +0000
Date:   Tue, 30 Aug 2022 21:02:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 f11c5343fa3f0af0760bd64a76f638f9bc17ac55
Message-ID: <630e0a73.9dQhmfoWQDOuwJh3%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: f11c5343fa3f0af0760bd64a76f638f9bc17ac55  md/raid5: Ensure stripe_fill happens on non-read IO with journal

elapsed time: 856m

configs tested: 90
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                           x86_64_defconfig
um                             i386_defconfig
powerpc                           allnoconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
arc                  randconfig-r043-20220829
x86_64               randconfig-a003-20220829
i386                                defconfig
x86_64               randconfig-a004-20220829
i386                 randconfig-a004-20220829
x86_64               randconfig-a005-20220829
x86_64                              defconfig
i386                 randconfig-a005-20220829
x86_64               randconfig-a002-20220829
i386                 randconfig-a006-20220829
i386                 randconfig-a001-20220829
x86_64               randconfig-a006-20220829
x86_64               randconfig-a001-20220829
i386                 randconfig-a003-20220829
i386                 randconfig-a002-20220829
i386                             allyesconfig
arm                                 defconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
ia64                             allmodconfig
arm64                            allyesconfig
arm                              allyesconfig
x86_64                           alldefconfig
sh                      rts7751r2d1_defconfig
powerpc                  storcenter_defconfig
arc                               allnoconfig
alpha                             allnoconfig
riscv                             allnoconfig
csky                              allnoconfig
powerpc                     ep8248e_defconfig
sh                        sh7757lcr_defconfig
sh                          sdk7780_defconfig
sh                          rsk7264_defconfig
sparc                               defconfig
parisc                           alldefconfig
m68k                          amiga_defconfig
sh                            migor_defconfig
arm                         lpc18xx_defconfig

clang tested configs:
i386                 randconfig-a011-20220829
hexagon              randconfig-r041-20220829
riscv                randconfig-r042-20220829
i386                 randconfig-a014-20220829
hexagon              randconfig-r045-20220829
i386                 randconfig-a013-20220829
i386                 randconfig-a015-20220829
s390                 randconfig-r044-20220829
i386                 randconfig-a016-20220829
i386                 randconfig-a012-20220829
x86_64               randconfig-a011-20220829
x86_64               randconfig-a012-20220829
x86_64               randconfig-a013-20220829
x86_64               randconfig-a014-20220829
x86_64               randconfig-a016-20220829
x86_64               randconfig-a015-20220829
s390                 randconfig-r044-20220830
hexagon              randconfig-r045-20220830
hexagon              randconfig-r041-20220830
riscv                randconfig-r042-20220830
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
mips                       rbtx49xx_defconfig
arm                            dove_defconfig
powerpc                     pseries_defconfig
arm                       netwinder_defconfig
arm                      pxa255-idp_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
