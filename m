Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2086C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  6 Jan 2022 08:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiAFIMN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Jan 2022 03:12:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:19414 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236348AbiAFIMM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 6 Jan 2022 03:12:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641456732; x=1672992732;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=fZ1KVvR5IVISH3jepAYgROhI/6uFGAJ1izvHxLH2B4k=;
  b=bdN1ji//v69VcXtcBzUeTilZA449Amejd3Mdlb1EbJDENm7CSWKGnO1N
   Y5p9FHH7rxSw/Egae1WbQwdeSO0wgJc1NWhtGRre1M4mP1zO8iZsdE/sP
   D52Zrpb80dDyJDUDxt5Ltbf1Ixd9YXdMM5P3Vuvl1Ww8+sjkrr4ng06i0
   wjXZartq0jtR2V5fFZk4gHs0jhPyVjZJEGnvg8o0fgjkUu0m9oLpAt2+D
   v8oeyrKoiBMx4WAY4exyuS/oZufZfjZI2ONPpQPIUMpiPtmC1CqNcr1tS
   3mIJK/3aokdgwz4/7LSKWuRLIpvJiZHFj6kXGTPQUAztadXz3KebnihkM
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242411369"
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="242411369"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 00:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="526894330"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jan 2022 00:12:10 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n5NsX-000HUd-Se; Thu, 06 Jan 2022 08:12:09 +0000
Date:   Thu, 06 Jan 2022 16:11:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 8612bcac0b8db175ebc88fae40bab8c9d4b195dc
Message-ID: <61d6a444.AzqT4JW1Rc6mqoWz%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 8612bcac0b8db175ebc88fae40bab8c9d4b195dc  md: Move alloc/free acct bioset in to personality

elapsed time: 727m

configs tested: 83
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20220105
sh                          r7785rp_defconfig
sh                            titan_defconfig
powerpc                      tqm8xx_defconfig
h8300                     edosk2674_defconfig
m68k                          amiga_defconfig
arm                          iop32x_defconfig
powerpc                      makalu_defconfig
mips                           gcw0_defconfig
openrisc                         alldefconfig
arm                          pxa910_defconfig
powerpc                    sam440ep_defconfig
arm                         assabet_defconfig
arm                  randconfig-c002-20220105
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
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
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
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a003-20220105
i386                 randconfig-a005-20220105
i386                 randconfig-a004-20220105
i386                 randconfig-a006-20220105
i386                 randconfig-a002-20220105
i386                 randconfig-a001-20220105
x86_64               randconfig-a005-20220105
x86_64               randconfig-a001-20220105
x86_64               randconfig-a004-20220105
x86_64               randconfig-a006-20220105
x86_64               randconfig-a003-20220105
x86_64               randconfig-a002-20220105
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                            allmodconfig
riscv                          rv32_defconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec
x86_64                          rhel-8.3-func

clang tested configs:
hexagon              randconfig-r041-20220105
hexagon              randconfig-r045-20220105
riscv                randconfig-r042-20220105

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
