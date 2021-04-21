Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3165C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 10:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF8361430
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 10:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbhDUKKT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Apr 2021 06:10:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:62794 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234167AbhDUKKT (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 21 Apr 2021 06:10:19 -0400
IronPort-SDR: HKwDuTPaVQfJ2gOzx7AvxSfG2dPg3CCitLnTYQe3txJPdnMtrtdTgMtYICF+Fhdwj4P2JzJ0Vi
 fkDWHHAfQKkg==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="281003468"
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="281003468"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 03:09:46 -0700
IronPort-SDR: O4njNfNxOfkBhttqzQGHw3VExV4xYXogg+LnZ4euNAy+LRWOle6kcL9FRZ0Ep2qY+G5Bj9h7zo
 Np1K9f4SIRhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="445895101"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 21 Apr 2021 03:09:44 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lZ9nk-0003XD-25; Wed, 21 Apr 2021 10:09:44 +0000
Date:   Wed, 21 Apr 2021 18:09:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 b70dbcef094b6d0318a97554c4daa92b4a6c72ed
Message-ID: <607ff9bc.9qZYTowjoPkpvYc5%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: b70dbcef094b6d0318a97554c4daa92b4a6c72ed  md-cluster: fix use-after-free issue when removing rdev

elapsed time: 722m

configs tested: 99
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
x86_64                           allyesconfig
i386                             allyesconfig
riscv                            allyesconfig
sh                           se7705_defconfig
powerpc                     tqm8541_defconfig
m68k                        m5307c3_defconfig
powerpc                     rainier_defconfig
powerpc                  storcenter_defconfig
mips                          ath79_defconfig
mips                           jazz_defconfig
sh                        sh7763rdp_defconfig
powerpc                 mpc837x_mds_defconfig
sh                     sh7710voipgw_defconfig
sparc                       sparc64_defconfig
mips                        nlm_xlr_defconfig
powerpc                        cell_defconfig
powerpc                          allyesconfig
mips                      fuloong2e_defconfig
powerpc                 linkstation_defconfig
mips                      pic32mzda_defconfig
arm                         nhk8815_defconfig
mips                         tb0287_defconfig
sh                          rsk7203_defconfig
sh                          landisk_defconfig
powerpc                       eiger_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a005-20210420
i386                 randconfig-a002-20210420
i386                 randconfig-a001-20210420
i386                 randconfig-a006-20210420
i386                 randconfig-a004-20210420
i386                 randconfig-a003-20210420
x86_64               randconfig-a015-20210420
x86_64               randconfig-a016-20210420
x86_64               randconfig-a011-20210420
x86_64               randconfig-a014-20210420
x86_64               randconfig-a013-20210420
x86_64               randconfig-a012-20210420
i386                 randconfig-a012-20210420
i386                 randconfig-a014-20210420
i386                 randconfig-a011-20210420
i386                 randconfig-a013-20210420
i386                 randconfig-a015-20210420
i386                 randconfig-a016-20210420
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                               allmodconfig
um                                allnoconfig
um                               allyesconfig
um                                  defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a004-20210420
x86_64               randconfig-a002-20210420
x86_64               randconfig-a001-20210420
x86_64               randconfig-a005-20210420
x86_64               randconfig-a006-20210420
x86_64               randconfig-a003-20210420

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
