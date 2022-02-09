Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7D9C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 18:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241206AbiBISzh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241348AbiBISzY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 13:55:24 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF75FC03C19B
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 10:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644432727; x=1675968727;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=7PEMsExkXLLcSki/9GEqqqIQYA2NcDxcaZ7uD3GG3xM=;
  b=c+k4Kk6DkVDPAtWZFXJqojTxuzO0fmnJEW2sY7gpo3czloZydKNFl12p
   fh74J9bdgLRs+kLptM8YJphTnqJgxQSM/9pcCEvg477LQthlyfLPFn1mV
   n3dE2KNxhAGO8Jazj7Uv7OqjlyX09Vvlc3M2ZKImK+UlP9a+x13mZT5xn
   GoREM9meK4inZ7XME4MzjbehgXtFyN4xv/dJMhCRpivjC6TW4dNLa0f2T
   FtQv/Cm+ves+9dZ6BSXoSJoVxuCLoc7/JaaXtQsK5uXg1f1V7ztyC4juf
   YZlgizYLSzzLummEbHhl/xqcmT70Pl7+AsdErx1+ODOim2dWOP+A4wZG5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249061852"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249061852"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 10:52:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="773600272"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 09 Feb 2022 10:52:04 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nHs4S-0002BC-1r; Wed, 09 Feb 2022 18:52:04 +0000
Date:   Thu, 10 Feb 2022 02:51:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 ca9c1082dc798a84561ba501e8daa9ff8077388d
Message-ID: <62040d1b.OwBjkWbFGQ4AbBAF%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: ca9c1082dc798a84561ba501e8daa9ff8077388d  lib/raid6: Include <asm/ppc-opcode.h> for VPERMXOR

elapsed time: 1307m

configs tested: 76
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm                              allyesconfig
arm64                            allyesconfig
arm                              allmodconfig
arm64                               defconfig
i386                          randconfig-c001
arm                           stm32_defconfig
powerpc                     taishan_defconfig
powerpc                     tqm8548_defconfig
powerpc                 mpc834x_itx_defconfig
sh                          sdk7780_defconfig
powerpc                     sequoia_defconfig
sh                   rts7751r2dplus_defconfig
sh                         apsh4a3a_defconfig
mips                    maltaup_xpa_defconfig
m68k                        m5272c3_defconfig
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
nds32                               defconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
nios2                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
nds32                             allnoconfig
nios2                               defconfig
arc                              allyesconfig
parisc                              defconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
s390                             allyesconfig
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
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                            allmodconfig
riscv                               defconfig
riscv                          rv32_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec
x86_64                              defconfig

clang tested configs:
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a015
hexagon              randconfig-r045-20220208
hexagon              randconfig-r041-20220208
riscv                randconfig-r042-20220208

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
