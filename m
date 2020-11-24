Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40EFC2D0E4
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 14:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F6442076B
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 14:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbgKXOMB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 09:12:01 -0500
Received: from mga07.intel.com ([134.134.136.100]:26690 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728399AbgKXOMA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Nov 2020 09:12:00 -0500
IronPort-SDR: xOybBf+7rx3sQSMOUF5XoFSByHREqfbh8GysEHCi/751bgY3nSG3yJWhIscSSbwZlbY7xacjTO
 vhdWIBHv1oHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="236086714"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="236086714"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 06:11:59 -0800
IronPort-SDR: LaW5qh0PKq958vBVr16vVAOO8BF98ym7gfI5ougdSzjNcrRD6WjnkyKVqNIBmTLzEnzfoC2x/y
 wgaiHvRxvfxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="361894866"
Received: from lkp-server01.sh.intel.com (HELO 2820ec516a85) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 24 Nov 2020 06:11:57 -0800
Received: from kbuild by 2820ec516a85 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1khZ2z-000080-9z; Tue, 24 Nov 2020 14:11:57 +0000
Date:   Tue, 24 Nov 2020 22:11:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 7603064859ca22c5e5d95a5fa685432ae00a388f
Message-ID: <5fbd149a.qAQDlz+jplmYS4BJ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git  md-next
branch HEAD: 7603064859ca22c5e5d95a5fa685432ae00a388f  md/cluster: fix deadlock when node is doing resync job

elapsed time: 720m

configs tested: 137
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
arc                          axs101_defconfig
c6x                        evmc6678_defconfig
mips                          malta_defconfig
mips                         bigsur_defconfig
mips                           jazz_defconfig
powerpc                      pmac32_defconfig
mips                       lemote2f_defconfig
mips                      maltasmvp_defconfig
powerpc                      ppc44x_defconfig
mips                     loongson1b_defconfig
arm                           sama5_defconfig
arc                            hsdk_defconfig
mips                       rbtx49xx_defconfig
m68k                        m5272c3_defconfig
powerpc                  mpc866_ads_defconfig
mips                           ip32_defconfig
arm                        multi_v5_defconfig
powerpc                 mpc837x_mds_defconfig
sh                           se7619_defconfig
powerpc                 mpc832x_mds_defconfig
arm                          badge4_defconfig
powerpc                     stx_gp3_defconfig
arm                      integrator_defconfig
sh                         ecovec24_defconfig
mips                             allyesconfig
powerpc                     akebono_defconfig
sparc                               defconfig
sh                             shx3_defconfig
sh                           se7750_defconfig
arm                       imx_v6_v7_defconfig
sh                          sdk7786_defconfig
sh                            titan_defconfig
xtensa                       common_defconfig
m68k                        stmark2_defconfig
m68k                        m5407c3_defconfig
arm                            lart_defconfig
m68k                          amiga_defconfig
powerpc                        fsp2_defconfig
powerpc                      ppc40x_defconfig
powerpc                      makalu_defconfig
arm                       mainstone_defconfig
powerpc                 xes_mpc85xx_defconfig
powerpc                 mpc832x_rdb_defconfig
sh                        edosk7760_defconfig
arm                           h5000_defconfig
arm                        oxnas_v6_defconfig
mips                         rt305x_defconfig
arc                      axs103_smp_defconfig
powerpc                      arches_defconfig
powerpc                      ppc64e_defconfig
arm                          collie_defconfig
h8300                     edosk2674_defconfig
arm                          gemini_defconfig
powerpc                      obs600_defconfig
arm                         vf610m4_defconfig
xtensa                    xip_kc705_defconfig
mips                            ar7_defconfig
arm                     am200epdkit_defconfig
arm                         orion5x_defconfig
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
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
i386                                defconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a006-20201124
x86_64               randconfig-a003-20201124
x86_64               randconfig-a004-20201124
x86_64               randconfig-a005-20201124
x86_64               randconfig-a001-20201124
x86_64               randconfig-a002-20201124
i386                 randconfig-a004-20201124
i386                 randconfig-a003-20201124
i386                 randconfig-a002-20201124
i386                 randconfig-a005-20201124
i386                 randconfig-a001-20201124
i386                 randconfig-a006-20201124
i386                 randconfig-a012-20201124
i386                 randconfig-a013-20201124
i386                 randconfig-a011-20201124
i386                 randconfig-a016-20201124
i386                 randconfig-a014-20201124
i386                 randconfig-a015-20201124
i386                 randconfig-a012-20201123
i386                 randconfig-a013-20201123
i386                 randconfig-a011-20201123
i386                 randconfig-a016-20201123
i386                 randconfig-a014-20201123
i386                 randconfig-a015-20201123
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                                   rhel
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a015-20201124
x86_64               randconfig-a011-20201124
x86_64               randconfig-a014-20201124
x86_64               randconfig-a016-20201124
x86_64               randconfig-a012-20201124
x86_64               randconfig-a013-20201124

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
