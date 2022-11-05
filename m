Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59675C4332F
	for <linux-raid@archiver.kernel.org>; Sat,  5 Nov 2022 06:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKEGYQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Nov 2022 02:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiKEGYO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Nov 2022 02:24:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A52B13D1A
        for <linux-raid@vger.kernel.org>; Fri,  4 Nov 2022 23:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667629454; x=1699165454;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=qse/7qILfOEvFiHVvI6NTYkbKA/WfTET79t2WYFXTmQ=;
  b=LKvQWS5xhD3yDdE33G3+iCgFFa1OPTImFDfxM5P/rMzskTScIzPJF618
   Y+dcMnxJC6Sd22M/pY5yrUvmYE5KWa+AZ9cM5K9HgBcxhlkWOSfkOQcv9
   eXfqoAWneKueQATw1Kn3s9qMR2KR/A6FikWosM28bbq28ZcUaXsFLn7N5
   tevWvPvXZEnb0dtTYdEJyDi8GVQYEO98vqcy4kPKm8jdGj/0mpO63mImK
   CSv4FRa5HCAmgYTdrupqMAAIv8O7xRM+XV1acH4dhLZwp15OnR/YBfIjs
   WSOpr2ZBPrSlADbrP0MTAU098VKEceEh1TQCkQxJQ9A2tJrwSBnWMPPxL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="374375399"
X-IronPort-AV: E=Sophos;i="5.96,140,1665471600"; 
   d="scan'208";a="374375399"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 23:24:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="964587901"
X-IronPort-AV: E=Sophos;i="5.96,140,1665471600"; 
   d="scan'208";a="964587901"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 04 Nov 2022 23:24:12 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1orCbD-000HhX-22;
        Sat, 05 Nov 2022 06:24:11 +0000
Date:   Sat, 05 Nov 2022 14:23:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 7476cc5394a10e982a4daa56079093a8b88e4bf3
Message-ID: <63660153.YDtlqI8kSHyX4u//%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 7476cc5394a10e982a4daa56079093a8b88e4bf3  md/raid0, raid10: Don't set discard sectors for request queue

elapsed time: 720m

configs tested: 76
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
arc                                 defconfig
alpha                               defconfig
s390                                defconfig
arc                  randconfig-r043-20221104
um                           x86_64_defconfig
s390                             allmodconfig
um                             i386_defconfig
x86_64                        randconfig-a002
i386                                defconfig
s390                             allyesconfig
riscv                randconfig-r042-20221104
alpha                            allyesconfig
s390                 randconfig-r044-20221104
x86_64                        randconfig-a006
m68k                             allmodconfig
x86_64                          rhel-8.3-func
x86_64                        randconfig-a004
arc                              allyesconfig
x86_64                    rhel-8.3-kselftests
m68k                             allyesconfig
arm                                 defconfig
i386                          randconfig-a014
ia64                             allmodconfig
i386                          randconfig-a012
i386                          randconfig-a001
i386                          randconfig-a016
powerpc                           allnoconfig
i386                          randconfig-a003
powerpc                          allmodconfig
x86_64                              defconfig
mips                             allyesconfig
i386                          randconfig-a005
x86_64                        randconfig-a013
i386                             allyesconfig
x86_64                        randconfig-a011
sh                               allmodconfig
x86_64                        randconfig-a015
x86_64                               rhel-8.3
arm64                            allyesconfig
arm                              allyesconfig
x86_64                           allyesconfig
powerpc                     taishan_defconfig
powerpc                      ppc6xx_defconfig
mips                     loongson1b_defconfig
arm                           viper_defconfig
i386                          randconfig-c001
powerpc              randconfig-c003-20221104
arm                         s3c6400_defconfig
arc                      axs103_smp_defconfig
m68k                       bvme6000_defconfig

clang tested configs:
hexagon              randconfig-r041-20221104
hexagon              randconfig-r045-20221104
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
x86_64                        randconfig-a014
i386                          randconfig-a002
i386                          randconfig-a006
x86_64                        randconfig-a016
i386                          randconfig-a004
x86_64                        randconfig-a012
mips                        bcm63xx_defconfig
powerpc                   bluestone_defconfig
mips                        omega2p_defconfig
powerpc                     akebono_defconfig
powerpc                     mpc512x_defconfig
x86_64                        randconfig-k001
arm                        spear3xx_defconfig
mips                           ip28_defconfig
powerpc                 xes_mpc85xx_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
