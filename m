Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCE2C04AA5
	for <linux-raid@archiver.kernel.org>; Thu, 25 Aug 2022 06:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiHYG6e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Aug 2022 02:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiHYG6c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 Aug 2022 02:58:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CD3A031E
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 23:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661410711; x=1692946711;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=6yQbePxeN571NPwHu2wAyZEdE+KMvYr4bnHIrL7ZAu0=;
  b=TysD5pdCx7I5PE9mGrufRFDVeHtwyoiIWCLgCczguqJVywY21FVUf470
   1wUTKe0UtwtIfh2NwpiXG3HHK3Q6gCaiac0N0GdPQIYzV1WYA0JOQ39zU
   3q8TGcqpLxhxbcoM81EXy+D0EGURgWa1LTsPP0NsTQFKzHP4VhJ27hKkb
   pEtfqzFLtPWc+gK7axto5AjHBQtTlg0HIORrfIvtfAy1Z9/sk2I8t7yby
   0PnUs6mR4pTC+GHeAG5kfqSXprNdmpkuefU1QDiJ5AbXh1HprvZXapBGp
   SeTMa35SZ74XOTresKKeuU5OP8IV2UsCPlPkChrPNUz2+zPRAy1s9pZpV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="292908838"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="292908838"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 23:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="606302619"
Received: from lkp-server02.sh.intel.com (HELO 34e741d32628) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 24 Aug 2022 23:58:29 -0700
Received: from kbuild by 34e741d32628 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oR6ou-0001qQ-0n;
        Thu, 25 Aug 2022 06:58:28 +0000
Date:   Thu, 25 Aug 2022 14:57:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 5c9bfa62b67fa155b432fa94c8e8ec16f672bdae
Message-ID: <63071d59.uQdweMKT+4r65fcD%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 5c9bfa62b67fa155b432fa94c8e8ec16f672bdae  md : Replace snprintf with scnprintf

elapsed time: 778m

configs tested: 122
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
i386                                defconfig
x86_64                        randconfig-a002
x86_64                        randconfig-a004
x86_64                              defconfig
x86_64                        randconfig-a006
x86_64                               rhel-8.3
arc                  randconfig-r043-20220823
x86_64                           allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
i386                          randconfig-a001
alpha                            allyesconfig
i386                          randconfig-a003
i386                          randconfig-a005
m68k                             allyesconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
i386                          randconfig-a014
x86_64                        randconfig-a013
x86_64                        randconfig-a011
i386                          randconfig-a012
i386                             allyesconfig
i386                          randconfig-a016
arm                                 defconfig
x86_64                        randconfig-a015
sh                               allmodconfig
x86_64                           rhel-8.3-kvm
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-syz
arm64                            allyesconfig
arm                              allyesconfig
riscv                randconfig-r042-20220824
s390                 randconfig-r044-20220824
arc                  randconfig-r043-20220824
loongarch                           defconfig
loongarch                         allnoconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
powerpc                          allyesconfig
riscv                               defconfig
riscv                            allmodconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
s390                                defconfig
s390                             allmodconfig
arc                                 defconfig
alpha                               defconfig
s390                             allyesconfig
nios2                            allyesconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
arm                            lart_defconfig
m68k                       m5249evb_defconfig
sh                             espt_defconfig
sh                          rsk7269_defconfig
m68k                                defconfig
sh                   secureedge5410_defconfig
sh                         ap325rxa_defconfig
xtensa                    smp_lx200_defconfig
sh                      rts7751r2d1_defconfig
xtensa                         virt_defconfig
sh                   sh7724_generic_defconfig
powerpc                      makalu_defconfig
arm                            pleb_defconfig
sparc                               defconfig
xtensa                           allyesconfig
csky                                defconfig
sparc                            allyesconfig
x86_64                                  kexec
i386                          randconfig-c001
ia64                          tiger_defconfig
sh                           se7721_defconfig
powerpc                      pcm030_defconfig
arc                    vdk_hs38_smp_defconfig
ia64                                defconfig
mips                    maltaup_xpa_defconfig
sh                         ecovec24_defconfig
um                                  defconfig
microblaze                      mmu_defconfig
arm                        realview_defconfig
arm64                               defconfig
arm                              allmodconfig
mips                             allmodconfig
ia64                             allmodconfig
arm                            zeus_defconfig
s390                          debug_defconfig
ia64                            zx1_defconfig

clang tested configs:
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
hexagon              randconfig-r041-20220823
hexagon              randconfig-r045-20220823
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a013
i386                          randconfig-a011
riscv                randconfig-r042-20220823
i386                          randconfig-a006
s390                 randconfig-r044-20220823
i386                          randconfig-a015
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
arm                      pxa255-idp_defconfig
powerpc                 mpc8560_ads_defconfig
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
