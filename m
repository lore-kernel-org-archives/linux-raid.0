Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FC4ECAAD8
	for <linux-raid@archiver.kernel.org>; Thu,  1 Sep 2022 06:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiIAGp4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Sep 2022 02:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiIAGpz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Sep 2022 02:45:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1341D11EB5D
        for <linux-raid@vger.kernel.org>; Wed, 31 Aug 2022 23:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662014754; x=1693550754;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Zlxz0ynYk6w5yFebBhboSoycgMSVmwrej/XewsLoTzc=;
  b=THgn4PoVwUKElVxpwuhHlzPjo1fckSWfPpiVTSz5Y/HgLNKsxC9Vqm37
   I2iwOIAgL+JN4OLESLSR3shdIDy6Vg4wDeaXaO2raYph+hd+0FWK2Nokq
   XI0NfGolAU2LZwFbdGeWhJgWEisBF56cCHtHzxJ7EEsm5OGo6dw3iuiSw
   nX/CZXCZ47OQbzvNFFN8WCUV9wNH1DxnuW7qvvYxCfa5yCj87eKVtFcmA
   fjkL3VRlc1jzw9aka5pVzRBV/otiBZNS0NHbbAhX71y/UO+cgWKiM8bt8
   GUfvy9RtfoM2kjoIk2ENPFysLi7VkJtEk14VdU6JeOyfUoIl6F1S20NDu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="359591864"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="359591864"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 23:45:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="940729261"
Received: from lkp-server02.sh.intel.com (HELO 811e2ceaf0e5) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 31 Aug 2022 23:45:52 -0700
Received: from kbuild by 811e2ceaf0e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTdxX-0001Er-33;
        Thu, 01 Sep 2022 06:45:51 +0000
Date:   Thu, 01 Sep 2022 14:45:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 526bd69b9d330eed1db59b2cf6a7d18caf866847
Message-ID: <631054fb.rRhs0tqMfM0XUffB%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 526bd69b9d330eed1db59b2cf6a7d18caf866847  Merge branch 'md-next-raid10-optimize' into md-next

elapsed time: 726m

configs tested: 83
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
arc                  randconfig-r043-20220831
powerpc                           allnoconfig
riscv                randconfig-r042-20220831
s390                 randconfig-r044-20220831
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
arc                              allyesconfig
alpha                            allyesconfig
sh                               allmodconfig
mips                             allyesconfig
powerpc                          allmodconfig
m68k                             allmodconfig
m68k                             allyesconfig
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
arm                                 defconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
i386                                defconfig
i386                             allyesconfig
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-syz
x86_64                           rhel-8.3-kvm
arm64                            allyesconfig
arm                              allyesconfig
ia64                             allmodconfig
sh                   sh7724_generic_defconfig
sparc                       sparc32_defconfig
arc                 nsimosci_hs_smp_defconfig
sh                          rsk7203_defconfig
sh                               alldefconfig
arc                           tb10x_defconfig
arm                       multi_v4t_defconfig
parisc64                            defconfig
powerpc                      cm5200_defconfig
arm                            hisi_defconfig
powerpc                      pcm030_defconfig
sh                   rts7751r2dplus_defconfig
powerpc                     rainier_defconfig
arm                      jornada720_defconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
mips                         cobalt_defconfig
mips                           xway_defconfig
loongarch                           defconfig
loongarch                         allnoconfig
xtensa                         virt_defconfig
powerpc                        warp_defconfig
arm                        multi_v7_defconfig
arm64                            alldefconfig
i386                          randconfig-c001

clang tested configs:
hexagon              randconfig-r041-20220831
hexagon              randconfig-r045-20220831
x86_64                        randconfig-a014
x86_64                        randconfig-a012
x86_64                        randconfig-a016
x86_64                        randconfig-a001
x86_64                        randconfig-a003
i386                          randconfig-a002
i386                          randconfig-a004
x86_64                        randconfig-a005
i386                          randconfig-a006
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
arm                         socfpga_defconfig
arm                        vexpress_defconfig
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
