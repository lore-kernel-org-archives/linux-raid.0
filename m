Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FCDC433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 18:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB6B610CA
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 18:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhDHSI6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 14:08:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:25586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhDHSI6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 8 Apr 2021 14:08:58 -0400
IronPort-SDR: x10OuY6r04b2IigWW/LyNZCcBRftzF5/iuCN9lZMa6eJ9ojeFHFgCmPC1sEGJxP8kXA9n5X9ZW
 YWaDg8F4FmVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="257584203"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="257584203"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 11:08:46 -0700
IronPort-SDR: 4h+ohk1+++SboIFb+mOOpP76zIgZuo8B7CWE5lyGgvv7RnhAamG7VQZcpXmvomUwq2MGzDI2II
 nBdfnzFT36GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="449787717"
Received: from lkp-server01.sh.intel.com (HELO 69d8fcc516b7) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 08 Apr 2021 11:08:44 -0700
Received: from kbuild by 69d8fcc516b7 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lUZ59-000FR2-Ko; Thu, 08 Apr 2021 18:08:43 +0000
Date:   Fri, 09 Apr 2021 02:07:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 65aa97c4d2bfd76677c211b9d03ef05a98c6d68e
Message-ID: <606f4676.LGf8TFanNOTEkNOs%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 65aa97c4d2bfd76677c211b9d03ef05a98c6d68e  md: split mddev_find

elapsed time: 734m

configs tested: 118
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                            allyesconfig
arm64                               defconfig
arm                                 defconfig
arm                              allyesconfig
arm                              allmodconfig
x86_64                           allyesconfig
m68k                         apollo_defconfig
sh                          r7785rp_defconfig
powerpc                      pmac32_defconfig
openrisc                 simple_smp_defconfig
mips                       lemote2f_defconfig
sh                               j2_defconfig
powerpc                      ppc40x_defconfig
powerpc                     tqm8548_defconfig
arm                        oxnas_v6_defconfig
arm                         at91_dt_defconfig
powerpc                     rainier_defconfig
xtensa                    smp_lx200_defconfig
sh                      rts7751r2d1_defconfig
riscv             nommu_k210_sdcard_defconfig
m68k                            mac_defconfig
um                            kunit_defconfig
mips                      maltasmvp_defconfig
powerpc                    socrates_defconfig
mips                            ar7_defconfig
sh                          sdk7786_defconfig
arm                     am200epdkit_defconfig
sh                            shmin_defconfig
arm                           sunxi_defconfig
powerpc                      walnut_defconfig
arm                       netwinder_defconfig
m68k                       m5275evb_defconfig
arm                        mini2440_defconfig
xtensa                  audio_kc705_defconfig
arm                          exynos_defconfig
arm                         shannon_defconfig
powerpc                 mpc8272_ads_defconfig
openrisc                            defconfig
mips                          ath25_defconfig
mips                          ath79_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                             allyesconfig
s390                                defconfig
parisc                              defconfig
s390                             allmodconfig
parisc                           allyesconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a004-20210408
x86_64               randconfig-a005-20210408
x86_64               randconfig-a003-20210408
x86_64               randconfig-a001-20210408
x86_64               randconfig-a002-20210408
x86_64               randconfig-a006-20210408
i386                 randconfig-a006-20210408
i386                 randconfig-a003-20210408
i386                 randconfig-a001-20210408
i386                 randconfig-a004-20210408
i386                 randconfig-a005-20210408
i386                 randconfig-a002-20210408
i386                 randconfig-a014-20210408
i386                 randconfig-a016-20210408
i386                 randconfig-a011-20210408
i386                 randconfig-a012-20210408
i386                 randconfig-a013-20210408
i386                 randconfig-a015-20210408
i386                 randconfig-a014-20210407
i386                 randconfig-a011-20210407
i386                 randconfig-a016-20210407
i386                 randconfig-a012-20210407
i386                 randconfig-a015-20210407
i386                 randconfig-a013-20210407
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
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
x86_64               randconfig-a014-20210408
x86_64               randconfig-a015-20210408
x86_64               randconfig-a012-20210408
x86_64               randconfig-a011-20210408
x86_64               randconfig-a013-20210408
x86_64               randconfig-a016-20210408

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
