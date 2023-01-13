Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6F4C54EBD
	for <linux-raid@archiver.kernel.org>; Fri, 13 Jan 2023 07:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbjAMHTx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Jan 2023 02:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbjAMHT1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Jan 2023 02:19:27 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0178C7458C
        for <linux-raid@vger.kernel.org>; Thu, 12 Jan 2023 23:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673593454; x=1705129454;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=FD4Ac1WjZjenQ+T9nMzr6uGAbnUMELXCt1nrNi59xRU=;
  b=I8Jj7fabB7oGPscNJpZyHcJpm+Ceu7nUG+Ck6xH7cXTXtXm3diKpPUmv
   xg8ogm/8p+dRRctgcfWR80F3OjBtkIhuXt3PwEJkuxdGGGpUk1N1heD2s
   KXLQxTez/R4JZ3gIVqseWcVgXCKvMccYetjhjv1SDr/fvQNG0kwYNoJrC
   39TdlE+vq3pKmfvKx+X64kUJ+uBBGH/qgUCPgfPSGb7fsxVaMRGu1+MYV
   oPueT6tMqJIDJyMKL8bNoMadrzOw1BEyiDyuV1SkSWr4vNlTeydLfaIc4
   U3DKjNoKzL6NxJQsjglENoH2/JXI4c20dak5prPhLCKgsX1nFB2GtoNDw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="322632774"
X-IronPort-AV: E=Sophos;i="5.97,213,1669104000"; 
   d="scan'208";a="322632774"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 23:04:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721424135"
X-IronPort-AV: E=Sophos;i="5.97,213,1669104000"; 
   d="scan'208";a="721424135"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jan 2023 23:04:12 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pGE6l-000ArS-1Y;
        Fri, 13 Jan 2023 07:04:11 +0000
Date:   Fri, 13 Jan 2023 15:04:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 b0907cadabcae6f1248f37a32a6e777f9ff6d4aa
Message-ID: <63c10266.pQ0AyASRdk3GX7JS%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: b0907cadabcae6f1248f37a32a6e777f9ff6d4aa  md: fix incorrect declaration about claim_rdev in md_import_device

elapsed time: 725m

configs tested: 88
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
ia64                             allmodconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
riscv                randconfig-r042-20230112
s390                 randconfig-r044-20230112
arc                  randconfig-r043-20230112
nios2                            allyesconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
i386                             allyesconfig
i386                                defconfig
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
x86_64                           rhel-8.3-bpf
x86_64                         rhel-8.3-kunit
arm                      integrator_defconfig
sh                           se7721_defconfig
m68k                          atari_defconfig
arc                          axs103_defconfig
m68k                       bvme6000_defconfig
arc                                 defconfig
alpha                               defconfig
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
s390                             allmodconfig
s390                                defconfig
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
s390                             allyesconfig
sparc                               defconfig
xtensa                           allyesconfig
csky                                defconfig
sparc                            allyesconfig
x86_64                                  kexec
arm                          pxa3xx_defconfig
sh                         ap325rxa_defconfig
sh                         microdev_defconfig
powerpc                           allnoconfig
sh                               allmodconfig
powerpc                          allmodconfig
mips                             allyesconfig
arm                           h3600_defconfig
arm                               allnoconfig
alpha                            alldefconfig
arc                              alldefconfig
sparc                       sparc64_defconfig
sh                        apsh4ad0a_defconfig
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
arm                        realview_defconfig
mips                            ar7_defconfig
arm                            zeus_defconfig
arc                            hsdk_defconfig

clang tested configs:
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
x86_64                        randconfig-k001
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
powerpc                      walnut_defconfig
s390                             alldefconfig
mips                       rbtx49xx_defconfig
x86_64                          rhel-8.3-rust

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
