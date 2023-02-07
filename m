Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D7EC636CC
	for <linux-raid@archiver.kernel.org>; Tue,  7 Feb 2023 12:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjBGM6H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Feb 2023 07:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjBGM6G (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Feb 2023 07:58:06 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC0F7EE4
        for <linux-raid@vger.kernel.org>; Tue,  7 Feb 2023 04:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675774686; x=1707310686;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=SIoFRioU1cDInwKtct29ujklT87kt5XCvfvyh86c8uk=;
  b=j8Rd+YH0JkctU8PRbw7CaPm5wwtB3yVUnAlXeOvW4dxtUet8J/2b2bBA
   M1buIb4+Pm0Cg9opUPW2EabQAYSYC9xbTJS7E5FpyFWC4rqxed75SxKWP
   tmiDCrHDvnj0oRW1zdRAmlEVzlJZhFLmTWQxTxr0OTLAcrqh+tztmNwEN
   +RpCYrl9F58josN3ALfDyFsjE0biSGouB/Kggf6/y4drL2BjEspHgzNLK
   RJVLZRogQIgw0/dLXs5D+YKCOE3hc09Hl1z/WcBLARhmoReb9wnK2PnIo
   ARMNOqVS6JLC+f7uv0wuacjhqgR9UBA9E4BgVN9d9zYqSwb400z3wylEf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317514718"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="317514718"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 04:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="666829579"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="666829579"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 07 Feb 2023 04:58:02 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pPNXt-0003YU-1s;
        Tue, 07 Feb 2023 12:58:01 +0000
Date:   Tue, 07 Feb 2023 20:58:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:new_module_alloc_build_test] BUILD SUCCESS
 d63bee3fea6c9ac940de7b3725bf9adf7050a430
Message-ID: <63e24ad8.E9ReLZWAWH4ka1+X%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git new_module_alloc_build_test
branch HEAD: d63bee3fea6c9ac940de7b3725bf9adf7050a430  module: replace module_layout with module_memory

elapsed time: 721m

configs tested: 68
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
x86_64                           rhel-8.3-bpf
powerpc                           allnoconfig
x86_64                              defconfig
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                               rhel-8.3
sh                               allmodconfig
powerpc                          allmodconfig
mips                             allyesconfig
i386                          randconfig-a014
ia64                             allmodconfig
x86_64                           allyesconfig
i386                          randconfig-a012
i386                          randconfig-a016
arm                                 defconfig
x86_64               randconfig-a014-20230206
x86_64               randconfig-a013-20230206
x86_64               randconfig-a011-20230206
x86_64               randconfig-a012-20230206
x86_64               randconfig-a015-20230206
s390                 randconfig-r044-20230206
x86_64               randconfig-a016-20230206
arc                  randconfig-r043-20230205
arm                  randconfig-r046-20230205
arc                  randconfig-r043-20230206
riscv                randconfig-r042-20230206
i386                                defconfig
arm                              allyesconfig
arm64                            allyesconfig
i386                             allyesconfig
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                                defconfig
s390                             allyesconfig
um                           x86_64_defconfig
um                             i386_defconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allyesconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests

clang tested configs:
i386                          randconfig-a013
i386                          randconfig-a011
x86_64               randconfig-a001-20230206
x86_64               randconfig-a002-20230206
i386                 randconfig-a002-20230206
x86_64               randconfig-a003-20230206
i386                 randconfig-a005-20230206
i386                          randconfig-a015
i386                 randconfig-a004-20230206
i386                 randconfig-a003-20230206
x86_64               randconfig-a005-20230206
i386                 randconfig-a001-20230206
i386                 randconfig-a006-20230206
x86_64               randconfig-a006-20230206
hexagon              randconfig-r041-20230205
x86_64               randconfig-a004-20230206
riscv                randconfig-r042-20230205
hexagon              randconfig-r045-20230206
hexagon              randconfig-r041-20230206
arm                  randconfig-r046-20230206
s390                 randconfig-r044-20230205
hexagon              randconfig-r045-20230205
x86_64                          rhel-8.3-rust

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
