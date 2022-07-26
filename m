Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E30C00140
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jul 2022 17:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiGZR4x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jul 2022 13:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbiGZR4w (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jul 2022 13:56:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D802F236
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 10:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658858211; x=1690394211;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=AaLCrzMoD6HTb6Q/Lu3M9hGDKoRatZKJzVrmvMV1tw4=;
  b=gN+EsmrDfVrZrqYebt3dNEJWqSiYJUqRr2cnwgxguyEhiCMOLNYDy0vG
   Q4uwPSBSbAvqCbVeXKkRtTL4Kd2OtUbHLPzLzrSxiIXuiNmIwgNWpUV7Q
   KPR9iuDm9Gvlkwq524LDnYrd/L6BpOSidFr1LDtM23bZKF1HMIDeImhBM
   5DYvetLPnby79pxx81m70Su/RG7QE2fqKGgsFL0X7CU7bo7SEOiOsqnyM
   Quo/gnlxy/cglrHzYhoV4Dc+zVopus9A40pbwy70iL+mlvNyYkmNudWiu
   /JCAKGZeaw6oW1J53E1ifL0zYQiEq0A6zvxpvfbdPtUg1GXT1aO7xKrEt
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="268407018"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="268407018"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 10:56:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="550502351"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 26 Jul 2022 10:56:50 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oGOnZ-0007Oa-2C;
        Tue, 26 Jul 2022 17:56:49 +0000
Date:   Wed, 27 Jul 2022 01:55:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 a23a50ee4b6215d4fc6ebdece70c3fee418464cb
Message-ID: <62e02aa6.lAJ3K4ap5+45RNNZ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: a23a50ee4b6215d4fc6ebdece70c3fee418464cb  md-raid: destroy the bitmap after destroying the thread

elapsed time: 725m

configs tested: 84
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
i386                          randconfig-c001
sh                   sh7724_generic_defconfig
arm                         s3c6400_defconfig
m68k                       m5249evb_defconfig
arm                       multi_v4t_defconfig
sh                            shmin_defconfig
powerpc                       eiger_defconfig
parisc                generic-32bit_defconfig
mips                         rt305x_defconfig
powerpc                     ep8248e_defconfig
sh                        sh7763rdp_defconfig
mips                     loongson1b_defconfig
sh                             espt_defconfig
m68k                                defconfig
mips                           gcw0_defconfig
mips                         tb0226_defconfig
sh                     sh7710voipgw_defconfig
m68k                          atari_defconfig
mips                 decstation_r4k_defconfig
powerpc                      tqm8xx_defconfig
powerpc                     tqm8555_defconfig
mips                      fuloong2e_defconfig
arm                        oxnas_v6_defconfig
ia64                             allmodconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
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
s390                 randconfig-r044-20220724
riscv                randconfig-r042-20220724
arc                  randconfig-r043-20220724
arc                  randconfig-r043-20220726
s390                 randconfig-r044-20220726
riscv                randconfig-r042-20220726
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                           rhel-8.3-kvm
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit

clang tested configs:
x86_64                        randconfig-k001
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r045-20220726
hexagon              randconfig-r041-20220726

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
