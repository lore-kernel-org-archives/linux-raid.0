Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707F5C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 23 Dec 2021 15:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349002AbhLWPct (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Dec 2021 10:32:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:34785 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348994AbhLWPcs (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 23 Dec 2021 10:32:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640273568; x=1671809568;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=UFKtvTvd6DuMUXlWjPHJMtRzg2PpqE4ruR88VYc/EwU=;
  b=CRwxrvysp99/s3w/yB0AA7R4icR/TyImrf1E6o7+zjNZtLSJePG7at/m
   yxEGq8HimihIqNxJrfiHiztEKLSgl/R72UvbFAYN0ECUtKVAGK7Lpjf4F
   xwdkiqxvuoRtZmqAHxuWwPACua+Ih/a3WPoXqmYZlGcaGGE0wph6pkTbF
   tZnCrqvthCw86ENs6bc45FnCNBDdnUwtPmfo4MhaRr79iOTYb0RcUc8RX
   s37wgvMTSZMCMRGkWnW0tJG8yJp50Twn6qEqgyTe414KKJ3zXnttIB8Xe
   prWyE5SpLBXVj1Hr9v2DyQ0bd2RGnqBnlm1KXEdwZ17PHt0BjqfkuEkfo
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="238377310"
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="238377310"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 07:32:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="685407998"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 23 Dec 2021 07:32:47 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n0Q5G-00020A-Cn; Thu, 23 Dec 2021 15:32:46 +0000
Date:   Thu, 23 Dec 2021 23:32:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 278cc27f7ff05a643acf0005e460719388a5aa12
Message-ID: <61c4969a.rnDXbjFkMCAwWV9p%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 278cc27f7ff05a643acf0005e460719388a5aa12  md: raid456 add nowait support

elapsed time: 722m

configs tested: 112
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211223
arm                          moxart_defconfig
powerpc               mpc834x_itxgp_defconfig
sparc                       sparc64_defconfig
powerpc                         wii_defconfig
powerpc64                        alldefconfig
powerpc                      ppc44x_defconfig
sh                 kfr2r09-romimage_defconfig
powerpc                      pcm030_defconfig
arc                     nsimosci_hs_defconfig
h8300                     edosk2674_defconfig
arc                        vdk_hs38_defconfig
m68k                       m5208evb_defconfig
powerpc                     tqm8555_defconfig
arm                         lpc32xx_defconfig
mips                   sb1250_swarm_defconfig
arm                       aspeed_g4_defconfig
arm                             pxa_defconfig
sh                          kfr2r09_defconfig
powerpc                 mpc832x_mds_defconfig
ia64                             allyesconfig
powerpc                     skiroot_defconfig
mips                  cavium_octeon_defconfig
arm                         lpc18xx_defconfig
m68k                          atari_defconfig
powerpc                 canyonlands_defconfig
arm                        neponset_defconfig
sh                            migor_defconfig
powerpc                 mpc8313_rdb_defconfig
h8300                            alldefconfig
sh                          lboxre2_defconfig
arm                  randconfig-c002-20211223
ia64                             allmodconfig
ia64                                defconfig
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
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a013-20211223
x86_64               randconfig-a015-20211223
x86_64               randconfig-a014-20211223
x86_64               randconfig-a011-20211223
x86_64               randconfig-a012-20211223
x86_64               randconfig-a016-20211223
i386                 randconfig-a012-20211223
i386                 randconfig-a011-20211223
i386                 randconfig-a014-20211223
i386                 randconfig-a016-20211223
i386                 randconfig-a015-20211223
i386                 randconfig-a013-20211223
arc                  randconfig-r043-20211223
riscv                randconfig-r042-20211223
s390                 randconfig-r044-20211223
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a001-20211223
x86_64               randconfig-a003-20211223
x86_64               randconfig-a005-20211223
x86_64               randconfig-a006-20211223
x86_64               randconfig-a004-20211223
x86_64               randconfig-a002-20211223
i386                 randconfig-a006-20211223
i386                 randconfig-a004-20211223
i386                 randconfig-a002-20211223
i386                 randconfig-a003-20211223
i386                 randconfig-a005-20211223
i386                 randconfig-a001-20211223

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
