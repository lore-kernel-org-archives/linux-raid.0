Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048DDC48BCD
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 18:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD485613D7
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 18:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhFISJi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Jun 2021 14:09:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:30676 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFISJh (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 9 Jun 2021 14:09:37 -0400
IronPort-SDR: qMBb4VIW6wb0TNWchS7WKfXftF5LFBxuoVRsYyzvvVu2w/QZDqduxXWhMYZ05iaCjzr9I8nbhr
 TjtT5ZCMaqGQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="204945624"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="204945624"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 11:07:42 -0700
IronPort-SDR: NyHByqkQVFCDL+4OuQTe/Mu7q3qBwowPN3ZEAfAmop/JaX+w8T8CIAPpBI9Egxwjvih2IUTkJb
 ztFGdmBpUNsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="482482963"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2021 11:07:40 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lr2c8-0009ej-Af; Wed, 09 Jun 2021 18:07:40 +0000
Date:   Thu, 10 Jun 2021 02:07:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 867a92060cfd29e5c011cc088916626005080c82
Message-ID: <60c10354.aYeZHU7FSa6+rkSn%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 867a92060cfd29e5c011cc088916626005080c82  md/raid5: avoid device_lock in read_one_chunk()

elapsed time: 724m

configs tested: 94
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
mips                         rt305x_defconfig
sh                         microdev_defconfig
sh                             espt_defconfig
powerpc                 mpc837x_rdb_defconfig
mips                  cavium_octeon_defconfig
sh                          sdk7780_defconfig
arm                             mxs_defconfig
mips                       rbtx49xx_defconfig
xtensa                         virt_defconfig
powerpc                 mpc832x_rdb_defconfig
arm                       imx_v6_v7_defconfig
arm                       netwinder_defconfig
sh                           se7343_defconfig
arc                           tb10x_defconfig
microblaze                          defconfig
powerpc                     kilauea_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
x86_64                            allnoconfig
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
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a003-20210608
i386                 randconfig-a006-20210608
i386                 randconfig-a004-20210608
i386                 randconfig-a001-20210608
i386                 randconfig-a005-20210608
i386                 randconfig-a002-20210608
i386                 randconfig-a015-20210608
i386                 randconfig-a013-20210608
i386                 randconfig-a016-20210608
i386                 randconfig-a011-20210608
i386                 randconfig-a012-20210608
i386                 randconfig-a014-20210608
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                           x86_64_defconfig
um                             i386_defconfig
um                            kunit_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a002-20210607
x86_64               randconfig-a004-20210607
x86_64               randconfig-a003-20210607
x86_64               randconfig-a006-20210607
x86_64               randconfig-a005-20210607
x86_64               randconfig-a001-20210607
x86_64               randconfig-a015-20210608
x86_64               randconfig-a012-20210608
x86_64               randconfig-a014-20210608
x86_64               randconfig-a011-20210608
x86_64               randconfig-a016-20210608
x86_64               randconfig-a013-20210608

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
