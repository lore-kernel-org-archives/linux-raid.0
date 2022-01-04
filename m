Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 638A3C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  4 Jan 2022 12:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbiADM5w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Jan 2022 07:57:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:18780 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbiADM5v (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 4 Jan 2022 07:57:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641301071; x=1672837071;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=oK1jmrxVUxHU/Yor1sXMs5McfVxqpWoLn1MfUFx6yEk=;
  b=fPNb+FhcIudhFYikpOS3edrBfX0Aw6+NkEqTh0J+85uUTyLZNHKonXB4
   0JEe9AQxg/B7s8INi0DNrEsxDSEngFrH1QNDEG3IKW7CxIX4vaVaJgPr4
   PJ47G5aLOheelbjJFWlaY3pTwopzUYMlZe8FMrhpwVJ7eD3zMS4qk9r5z
   +rEJGdrousyFHROu3G61Ld9igavyzlVIXkd4rPBYcuFSXYl+8Tec/oP3n
   wN97eUzz/mQrIIzOXJuedjzJ194pI0aAIv5owhuO3PGEAvmHmYUhDTDsb
   ODGa19yYug7JjbYXKg9diYcNk4ZBym1ZgmB05rg+WxQ5LHkDgvGAXcpEY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="222211061"
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="222211061"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 04:57:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="688558753"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 04 Jan 2022 04:57:49 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n4jNt-000FMA-B1; Tue, 04 Jan 2022 12:57:49 +0000
Date:   Tue, 04 Jan 2022 20:57:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 46669e8616c649c71c4cfcd712fd3d107e771380
Message-ID: <61d44425.EnhrUBbGE/gBBhdP%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: 46669e8616c649c71c4cfcd712fd3d107e771380  md/raid1: fix missing bitmap update w/o WriteMostly devices

elapsed time: 724m

configs tested: 54
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm                              allyesconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allmodconfig
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
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
s390                             allyesconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                             allyesconfig
sparc                               defconfig
sparc                            allyesconfig
mips                             allmodconfig
mips                             allyesconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
