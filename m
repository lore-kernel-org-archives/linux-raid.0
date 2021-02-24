Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B9AC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 21:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8291160202
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 21:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhBXVIg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:08:36 -0500
Received: from mga05.intel.com ([192.55.52.43]:58795 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231970AbhBXVIe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Feb 2021 16:08:34 -0500
IronPort-SDR: n/Ya3XiWTLz+j5riSwByc7+laW9MQNb1q2o5sTpZjaWtl0vUTCokGaltI6sO0xTw7IdgcteByt
 IukdVJqA6LDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9905"; a="270281281"
X-IronPort-AV: E=Sophos;i="5.81,203,1610438400"; 
   d="scan'208";a="270281281"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2021 13:07:51 -0800
IronPort-SDR: bSghftEA1XWAbeWJE/w8R90U7CeCiIKVa2+uxR+W59yHXCbb/pF/qKvI7Yf2tQRAPzInz9m9s9
 0qKldwYUnY8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,203,1610438400"; 
   d="scan'208";a="381085766"
Received: from lkp-server01.sh.intel.com (HELO 16660e54978b) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 24 Feb 2021 13:07:50 -0800
Received: from kbuild by 16660e54978b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lF1Nt-0002Jh-Jd; Wed, 24 Feb 2021 21:07:49 +0000
Date:   Thu, 25 Feb 2021 05:07:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS WITH WARNING
 ec8263472f36ff06a9b5988675109cb0123e366b
Message-ID: <6036c020.jXc6fgqqu2UydUmc%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: ec8263472f36ff06a9b5988675109cb0123e366b  md/raid10: improve discard request for far layout

possible Warning in current branch:

drivers/md/raid10.c:1526:8-27: atomic_dec_and_test variation before object free at line 1532.

Warning ids grouped by kconfigs:

gcc_recent_errors
`-- microblaze-randconfig-c004-20210223
    `-- drivers-md-raid10.c:atomic_dec_and_test-variation-before-object-free-at-line-.

elapsed time: 726m

configs tested: 107
configs skipped: 2

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
mips                             allyesconfig
arm                   milbeaut_m10v_defconfig
arm                        vexpress_defconfig
sh                           sh2007_defconfig
powerpc                     kmeter1_defconfig
arm                          collie_defconfig
powerpc                      chrp32_defconfig
arm                           sama5_defconfig
arm                           omap1_defconfig
powerpc                mpc7448_hpc2_defconfig
powerpc                     tqm8560_defconfig
powerpc                     tqm5200_defconfig
mips                     loongson1c_defconfig
ia64                        generic_defconfig
m68k                       m5275evb_defconfig
sh                             shx3_defconfig
mips                        workpad_defconfig
sh                           se7712_defconfig
arm                       netwinder_defconfig
mips                        vocore2_defconfig
powerpc                      makalu_defconfig
powerpc                      tqm8xx_defconfig
powerpc                     tqm8541_defconfig
powerpc                     redwood_defconfig
sh                            titan_defconfig
sh                          lboxre2_defconfig
xtensa                generic_kc705_defconfig
powerpc                   lite5200b_defconfig
powerpc                     pseries_defconfig
mips                           rs90_defconfig
mips                         mpc30x_defconfig
openrisc                    or1ksim_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
c6x                              allyesconfig
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
i386                               tinyconfig
i386                                defconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a005-20210223
i386                 randconfig-a006-20210223
i386                 randconfig-a004-20210223
i386                 randconfig-a003-20210223
i386                 randconfig-a001-20210223
i386                 randconfig-a002-20210223
x86_64               randconfig-a015-20210223
x86_64               randconfig-a011-20210223
x86_64               randconfig-a012-20210223
x86_64               randconfig-a016-20210223
x86_64               randconfig-a014-20210223
x86_64               randconfig-a013-20210223
i386                 randconfig-a013-20210223
i386                 randconfig-a012-20210223
i386                 randconfig-a011-20210223
i386                 randconfig-a014-20210223
i386                 randconfig-a016-20210223
i386                 randconfig-a015-20210223
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a001-20210223
x86_64               randconfig-a002-20210223
x86_64               randconfig-a003-20210223
x86_64               randconfig-a005-20210223
x86_64               randconfig-a004-20210223
x86_64               randconfig-a006-20210223

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
