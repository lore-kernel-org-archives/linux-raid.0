Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB234C433E6
	for <linux-raid@archiver.kernel.org>; Wed, 10 Feb 2021 04:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E3264E56
	for <linux-raid@archiver.kernel.org>; Wed, 10 Feb 2021 04:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhBJEFi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:05:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:4840 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhBJEFg (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 9 Feb 2021 23:05:36 -0500
IronPort-SDR: wz57psgndFtmmrkMxK5DR4GG4eVKzCV84OC8t+f85snbqvIV9a07/Gt/R4XqR3vLzyFmzZPJWu
 TUM2oDDNS3cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9890"; a="246076431"
X-IronPort-AV: E=Sophos;i="5.81,167,1610438400"; 
   d="scan'208";a="246076431"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 20:04:53 -0800
IronPort-SDR: HWhPcXVkvTmdrKCiNNW3lhya3RrnTbYTS50R1LJEnWXhhQV62PxewH42PTeth7EAeQLqRRHlhA
 bpv8SJInUd1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,167,1610438400"; 
   d="scan'208";a="419918317"
Received: from lkp-server02.sh.intel.com (HELO cd560a204411) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Feb 2021 20:04:52 -0800
Received: from kbuild by cd560a204411 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1l9gkF-0002dH-Az; Wed, 10 Feb 2021 04:04:51 +0000
Date:   Wed, 10 Feb 2021 12:04:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 c5eec74f252dfba25269cd68f9a3407aedefd330
Message-ID: <60235b52.3Jla9/oD/DlIi4p8%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: c5eec74f252dfba25269cd68f9a3407aedefd330  md/raid5: cast chunk_sectors to sector_t value

elapsed time: 731m

configs tested: 123
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
m68k                       m5249evb_defconfig
sh                   sh7770_generic_defconfig
c6x                        evmc6472_defconfig
mips                         cobalt_defconfig
arc                        nsimosci_defconfig
powerpc                     pseries_defconfig
arm                       spear13xx_defconfig
powerpc                     kmeter1_defconfig
mips                       lemote2f_defconfig
s390                          debug_defconfig
openrisc                  or1klitex_defconfig
powerpc                 linkstation_defconfig
arm                            xcep_defconfig
powerpc                mpc7448_hpc2_defconfig
ia64                             alldefconfig
powerpc                      pasemi_defconfig
arm                             mxs_defconfig
arc                              alldefconfig
mips                          ath79_defconfig
c6x                        evmc6474_defconfig
arm                          pxa3xx_defconfig
powerpc                    socrates_defconfig
xtensa                    smp_lx200_defconfig
mips                        jmr3927_defconfig
powerpc                       ppc64_defconfig
c6x                              allyesconfig
xtensa                  audio_kc705_defconfig
arc                        vdk_hs38_defconfig
mips                           rs90_defconfig
powerpc                     sequoia_defconfig
powerpc                     taishan_defconfig
mips                      maltaaprp_defconfig
arm                       cns3420vb_defconfig
alpha                            allyesconfig
sh                             shx3_defconfig
arm                          ixp4xx_defconfig
xtensa                  nommu_kc705_defconfig
arm                        mvebu_v7_defconfig
arm                         s3c2410_defconfig
powerpc                        cell_defconfig
sh                   rts7751r2dplus_defconfig
arm                       imx_v4_v5_defconfig
arm                     am200epdkit_defconfig
microblaze                      mmu_defconfig
sh                  sh7785lcr_32bit_defconfig
arm                           sama5_defconfig
arm                         orion5x_defconfig
m68k                        stmark2_defconfig
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
h8300                            allyesconfig
arc                                 defconfig
xtensa                           allyesconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                               defconfig
i386                               tinyconfig
i386                                defconfig
sparc                            allyesconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a006-20210209
x86_64               randconfig-a001-20210209
x86_64               randconfig-a005-20210209
x86_64               randconfig-a004-20210209
x86_64               randconfig-a002-20210209
x86_64               randconfig-a003-20210209
i386                 randconfig-a001-20210209
i386                 randconfig-a005-20210209
i386                 randconfig-a003-20210209
i386                 randconfig-a002-20210209
i386                 randconfig-a006-20210209
i386                 randconfig-a004-20210209
i386                 randconfig-a016-20210209
i386                 randconfig-a013-20210209
i386                 randconfig-a012-20210209
i386                 randconfig-a014-20210209
i386                 randconfig-a011-20210209
i386                 randconfig-a015-20210209
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
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a013-20210209
x86_64               randconfig-a014-20210209
x86_64               randconfig-a015-20210209
x86_64               randconfig-a012-20210209
x86_64               randconfig-a016-20210209
x86_64               randconfig-a011-20210209

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
