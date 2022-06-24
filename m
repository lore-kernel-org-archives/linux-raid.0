Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8923C43334
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 04:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiFXExy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 00:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiFXExi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 00:53:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3A77707C
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 21:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656046245; x=1687582245;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=DxRwg2Y1mhVBFvsLYK7mtEhZxj7b4HAr2uv771FwjkM=;
  b=V1O4av9FN3ZccEZ2rTfb7CfYy3SrREo2zwcUUlAVjcsg8xWe2KlyuPoV
   hNT+CvNcVKCNFavj7kZTYAkhYa3kgcZRJCXFOw5OyQt6eLjCwJ9ZajrPE
   JOzTz7Cx5a18o8SFMERfHDAtmpco6RTmtfstCh0N2Pxf1lw8sP20w9VhX
   gnsT8lALBN9TN/TiWnUWvXmSIEZJst4cSBHAmcsNhk1XH/gMEdTfwKzlx
   dJwHHvm9fctE44YXZhzkGFp7hxCGZYSBr2mPgPw2vtKC+QFFI2cDQdc1w
   jzyR6Tp524/v3d1oUIhsWILMIcX9G3gE0ScJwvt4oyixnoeNIhjdd24yn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344916180"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344916180"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:50:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="765626944"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 23 Jun 2022 21:50:41 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o4bHE-0003fr-GY;
        Fri, 24 Jun 2022 04:50:40 +0000
Date:   Fri, 24 Jun 2022 12:49:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 26dbd28727d0b79eaf75fd8d36a4588d2db8b290
Message-ID: <62b54277.fPU6Uq0Itqpn1RSI%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 26dbd28727d0b79eaf75fd8d36a4588d2db8b290  md/raid5: Increase restriction on max segments per request

elapsed time: 730m

configs tested: 58
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm                              allyesconfig
arm64                            allyesconfig
ia64                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
i386                   debian-10.3-kselftests
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a002
x86_64                        randconfig-a004
x86_64                        randconfig-a006
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
arc                  randconfig-r043-20220622
riscv                             allnoconfig
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz

clang tested configs:
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
x86_64                        randconfig-a012
x86_64                        randconfig-a016
x86_64                        randconfig-a014
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r041-20220622
hexagon              randconfig-r045-20220622
riscv                randconfig-r042-20220622
s390                 randconfig-r044-20220622

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
