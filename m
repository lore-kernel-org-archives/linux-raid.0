Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62A7C77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 06:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjEWGTH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 02:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbjEWGSv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 02:18:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6551611A
        for <linux-raid@vger.kernel.org>; Mon, 22 May 2023 23:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684822727; x=1716358727;
  h=date:from:to:cc:subject:message-id;
  bh=7YFJNKk33M1aV6lkgo96U6NHzFvTRft2x0sNDxDcNOM=;
  b=RrwdTG+RWyNwrHJLdco3Sreaz051c0AUZP4AqN3AKp0g+uRTtXm7MavH
   qy3/93cEps/u2aScaBtr6filq1w1aNSXLmpChmS8sd0jvpP9UxwWiT+kc
   voy2iUmQaJuLzgnTP94n/ly2n05C1bn+vPA2vMjZSi0jiUnQ6KrgEAcGo
   3ptkWSh0KKsZjRPj9WoFu/mmqAoQ1an4Xvf9qo877O/19bVYwNKBrq921
   abe6F3OU7Kb/3HKpEm3K2i0kL/g8/evyVGLbtHn4uK2t9wJDVJv6tCRk/
   HOJaID4NgURXuROw8jG8LvU220BGg/cMBsEgM484w+zAQD540M6jDyAYg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="416609571"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="416609571"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 23:18:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="1033918466"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="1033918466"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 22 May 2023 23:18:45 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q1LM4-000DWv-2Y;
        Tue, 23 May 2023 06:18:44 +0000
Date:   Tue, 23 May 2023 14:18:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 7f102f1ef365d75ff7ebc235d0d1e72c5b7f0314
Message-ID: <20230523061811.oIaoa%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: INFO setup_repo_specs: /db/releases/20230523114855/lkp-src/repo/*/song-md
git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 7f102f1ef365d75ff7ebc235d0d1e72c5b7f0314  md/raid10: fix wrong setting of max_corr_read_errors

elapsed time: 728m

configs tested: 67
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r026-20230522   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r021-20230522   gcc  
microblaze           randconfig-r022-20230522   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
nios2                               defconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                      pmac32_defconfig   clang
powerpc              randconfig-r023-20230522   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
sh                               allmodconfig   gcc  
sparc                               defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r025-20230522   clang
x86_64               randconfig-x051-20230522   clang
x86_64               randconfig-x052-20230522   clang
x86_64               randconfig-x053-20230522   clang
x86_64               randconfig-x054-20230522   clang
x86_64               randconfig-x055-20230522   clang
x86_64               randconfig-x056-20230522   clang
x86_64               randconfig-x061-20230522   clang
x86_64               randconfig-x062-20230522   clang
x86_64               randconfig-x063-20230522   clang
x86_64               randconfig-x064-20230522   clang
x86_64               randconfig-x065-20230522   clang
x86_64               randconfig-x066-20230522   clang
x86_64               randconfig-x081-20230522   gcc  
x86_64               randconfig-x082-20230522   gcc  
x86_64               randconfig-x083-20230522   gcc  
x86_64               randconfig-x084-20230522   gcc  
x86_64               randconfig-x085-20230522   gcc  
x86_64               randconfig-x086-20230522   gcc  
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
