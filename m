Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEC1C61DA4
	for <linux-raid@archiver.kernel.org>; Sun,  5 Feb 2023 02:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjBECBK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Feb 2023 21:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBECBH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Feb 2023 21:01:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E0721A3D
        for <linux-raid@vger.kernel.org>; Sat,  4 Feb 2023 18:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675562466; x=1707098466;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=2nG9e/QK/X0LhxYAnhihPwov07FWWmpWn5TumjcxcIw=;
  b=g67OLD0ewskXgAw53wR1EwJ0smajnxco1OnEyYeQKGta6p179x9V5e9G
   7lPXjeVc4ljFvW4vR0T8Cc3PxqOsz/dQQxoc6HAZ4Kr3iejCGs74yk9zd
   aRvWlTtbclqTgBONTfgLGTtr9sauyUDsmKCgKM+PCA40dfeuUcZqivSUf
   lWlKjYIM6twn0jGO92QSG/0EO1Ssp2rd0pGZWGeMu3aHya4wo2Jp0rOGd
   BY/9ZfixRMoJ6Av17ovYZReHtmyD+56k+nwxouOAi/BuYYoP04PMeQHna
   mDhNLDnebvthU/Fyps3mVJTJJ2LrohLRxd3uOlk5DKBqGUhdv/IaqRV8f
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="312668943"
X-IronPort-AV: E=Sophos;i="5.97,274,1669104000"; 
   d="scan'208";a="312668943"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 18:01:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10611"; a="668059001"
X-IronPort-AV: E=Sophos;i="5.97,274,1669104000"; 
   d="scan'208";a="668059001"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 04 Feb 2023 18:01:04 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pOUL1-0001ei-2I;
        Sun, 05 Feb 2023 02:01:03 +0000
Date:   Sun, 05 Feb 2023 10:00:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:new_module_alloc_build_test] BUILD SUCCESS
 9e278a4880d5bee01bab987f06b709da7d532e93
Message-ID: <63df0daa.eKYOEelTitBUzF+e%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git new_module_alloc_build_test
branch HEAD: 9e278a4880d5bee01bab987f06b709da7d532e93  module: replace module_layout with module_memory

elapsed time: 1618m

configs tested: 60
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
powerpc                           allnoconfig
x86_64                            allnoconfig
um                           x86_64_defconfig
um                             i386_defconfig
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
ia64                             allmodconfig
s390                                defconfig
sh                               allmodconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
s390                             allyesconfig
mips                             allyesconfig
powerpc                          allmodconfig
x86_64                        randconfig-a006
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-bpf
x86_64                              defconfig
arc                  randconfig-r043-20230204
x86_64                               rhel-8.3
s390                 randconfig-r044-20230204
riscv                randconfig-r042-20230204
x86_64                           allyesconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                                defconfig
i386                             allyesconfig
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
arm                                 defconfig

clang tested configs:
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
hexagon              randconfig-r041-20230204
arm                  randconfig-r046-20230204
hexagon              randconfig-r045-20230204
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
x86_64                          rhel-8.3-rust
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
