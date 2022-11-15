Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28557C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 15 Nov 2022 07:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiKOHoE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Nov 2022 02:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiKOHoD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Nov 2022 02:44:03 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3601C92F
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 23:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668498242; x=1700034242;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=j/B98LwtyISS2z4Frzkh3MkvOvXTkV9akHGsTmRC+rw=;
  b=UH2zdjRIYuwgSnabL0tvvk1fqIAzZBaDpWoUjuGtiFcv7HQXMsp2xpvH
   31/Y81bbOV+9lOPb6A01C6b4cenwkPnNU7U67FIMaMjzIzZPBJSSFJXFi
   Zigi+Vae7BP9eGbzqPr6TU4yAI5GUhxumk/jEFdXCG9BE3OGE/5c+X5eH
   54hSIP779cM9IOZ6vm3SwSEU870Re8wAUg2JJYBnWA+pEZNTMp7xWOoRZ
   3j0/iEhCFFmxgwh9cmccVRHz44JUztIcqR8u3jATaGYTFkuMcRR/ukT9g
   kRXfYed0+kyI5Nbjgd4aPt8bzMmB+lYzmyg1KBHCQzTQpoElfRUS+315y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="299712119"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="299712119"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 23:44:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="638849023"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="638849023"
Received: from lkp-server01.sh.intel.com (HELO ebd99836cbe0) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 14 Nov 2022 23:44:00 -0800
Received: from kbuild by ebd99836cbe0 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ouqbv-0001B8-2O;
        Tue, 15 Nov 2022 07:43:59 +0000
Date:   Tue, 15 Nov 2022 15:43:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 b611ad14006e5be2170d9e8e611bf49dff288911
Message-ID: <6373430b.8VO3mBIC8FbdZhzZ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: b611ad14006e5be2170d9e8e611bf49dff288911  md/raid1: stop mdx_raid1 thread when raid1 array run failed

elapsed time: 722m

configs tested: 92
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
alpha                               defconfig
um                           x86_64_defconfig
um                             i386_defconfig
s390                             allmodconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
s390                             allyesconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                               rhel-8.3
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                              defconfig
arc                  randconfig-r043-20221114
x86_64               randconfig-a002-20221114
i386                                defconfig
x86_64               randconfig-a001-20221114
x86_64               randconfig-a003-20221114
x86_64                           allyesconfig
ia64                             allmodconfig
alpha                            allyesconfig
i386                             allyesconfig
i386                 randconfig-a001-20221114
arc                              allyesconfig
i386                 randconfig-a004-20221114
i386                 randconfig-a002-20221114
i386                 randconfig-a005-20221114
i386                 randconfig-a006-20221114
i386                 randconfig-a003-20221114
m68k                             allmodconfig
x86_64                            allnoconfig
s390                                defconfig
sh                               allmodconfig
parisc                generic-32bit_defconfig
sh                     magicpanelr2_defconfig
mips                           gcw0_defconfig
xtensa                         virt_defconfig
sh                            shmin_defconfig
xtensa                              defconfig
mips                        vocore2_defconfig
m68k                             allyesconfig
arm                           sunxi_defconfig
arm                               allnoconfig
loongarch                 loongson3_defconfig
arc                         haps_hs_defconfig
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
mips                  decstation_64_defconfig
powerpc                    sam440ep_defconfig
sh                            hp6xx_defconfig
sparc64                          alldefconfig
powerpc                     stx_gp3_defconfig
sh                           sh2007_defconfig
loongarch                        allmodconfig
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
sh                               j2_defconfig
arm                           stm32_defconfig
parisc                           alldefconfig
arm                         assabet_defconfig
arc                               allnoconfig
x86_64               randconfig-a005-20221114
x86_64               randconfig-a004-20221114
x86_64               randconfig-a006-20221114
i386                 randconfig-c001-20221114

clang tested configs:
x86_64               randconfig-a014-20221114
x86_64               randconfig-a012-20221114
hexagon              randconfig-r045-20221114
x86_64               randconfig-a016-20221114
x86_64               randconfig-a015-20221114
hexagon              randconfig-r041-20221114
x86_64               randconfig-a013-20221114
x86_64               randconfig-a011-20221114
s390                 randconfig-r044-20221114
riscv                randconfig-r042-20221114
i386                 randconfig-a011-20221114
i386                 randconfig-a014-20221114
i386                 randconfig-a013-20221114
i386                 randconfig-a012-20221114
i386                 randconfig-a015-20221114
arm                        multi_v5_defconfig
arm                       aspeed_g4_defconfig
powerpc                     kmeter1_defconfig
hexagon              randconfig-r041-20221115
hexagon              randconfig-r045-20221115
i386                 randconfig-a016-20221114
x86_64               randconfig-k001-20221114

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
