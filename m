Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FBFC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Mar 2022 02:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243513AbiCHCNJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Mar 2022 21:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344367AbiCHCNH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Mar 2022 21:13:07 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B7022BDF
        for <linux-raid@vger.kernel.org>; Mon,  7 Mar 2022 18:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646705532; x=1678241532;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=MONcJ+SWTLGtF6OsqGcVzwToMol7RVMGVDC7fyqBNJM=;
  b=jm0T3jYb6hGBiop2JpXWcjL/6mF+b7xVMsb1ZWgCg+MWEfv+32dj6ggS
   KZqccQrVJW0S//pehe03Ig41F2NPRFFyKpFhpwvou4QE5vPFCej69H2by
   et4YvXObxDHAXra08fJ50eifOd2nGCMeyv7lWTmiPQje1Yskz54IXdGf9
   Y/ZAzSeALEkkF9g7O8VrFUs1E7FiQYkEigtSC3itohHTaj3JSdoME47d8
   aL4hULgZjrpD8siZtJXLamgRcEWDiufZ4bKo5qcG72dQETK4Ps78br92F
   1QZbgbMcgJ4GG41I3RI7hMUaErFigyJ6goie7oKRnpip96SDFb5rTCefJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="279277834"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="279277834"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 18:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="687759257"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 07 Mar 2022 18:12:11 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nRPKc-0000rR-A7; Tue, 08 Mar 2022 02:12:10 +0000
Date:   Tue, 08 Mar 2022 10:11:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 0a43d103a1779d768bc52be4613f59d7c00c9a8a
Message-ID: <6226bb64.wdysGf0x6jy4bWT6%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 0a43d103a1779d768bc52be4613f59d7c00c9a8a  md: use msleep() in md_notify_reboot()

elapsed time: 5487m

configs tested: 118
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20220307
mips                 randconfig-c004-20220307
powerpc                     pq2fads_defconfig
ia64                          tiger_defconfig
m68k                        m5272c3_defconfig
arm                        multi_v7_defconfig
um                             i386_defconfig
sh                               alldefconfig
mips                     loongson1b_defconfig
powerpc                      ppc40x_defconfig
powerpc                    amigaone_defconfig
sh                           se7724_defconfig
arm                           tegra_defconfig
openrisc                 simple_smp_defconfig
xtensa                         virt_defconfig
mips                         db1xxx_defconfig
arm                      jornada720_defconfig
powerpc                    klondike_defconfig
arm                         vf610m4_defconfig
arm                          exynos_defconfig
arm                           h3600_defconfig
mips                         rt305x_defconfig
powerpc                    adder875_defconfig
powerpc                     tqm8555_defconfig
sh                          lboxre2_defconfig
arm                  randconfig-c002-20220307
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
arc                                 defconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc64                            defconfig
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
x86_64               randconfig-a006-20220307
x86_64               randconfig-a004-20220307
x86_64               randconfig-a005-20220307
x86_64               randconfig-a001-20220307
x86_64               randconfig-a003-20220307
x86_64               randconfig-a002-20220307
i386                 randconfig-a005-20220307
i386                 randconfig-a004-20220307
i386                 randconfig-a003-20220307
i386                 randconfig-a006-20220307
i386                 randconfig-a002-20220307
i386                 randconfig-a001-20220307
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
riscv                    nommu_virt_defconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-c007-20220307
i386                 randconfig-c001-20220307
powerpc              randconfig-c003-20220307
riscv                randconfig-c006-20220307
mips                 randconfig-c004-20220307
arm                  randconfig-c002-20220307
s390                 randconfig-c005-20220307
arm                       imx_v4_v5_defconfig
x86_64                           allyesconfig
mips                           rs90_defconfig
powerpc                     tqm8540_defconfig
powerpc                      ppc64e_defconfig
powerpc                      obs600_defconfig
arm                        magician_defconfig
x86_64               randconfig-a016-20220307
x86_64               randconfig-a012-20220307
x86_64               randconfig-a015-20220307
x86_64               randconfig-a013-20220307
x86_64               randconfig-a014-20220307
x86_64               randconfig-a011-20220307
i386                 randconfig-a012-20220307
i386                 randconfig-a013-20220307
i386                 randconfig-a015-20220307
i386                 randconfig-a011-20220307
i386                 randconfig-a014-20220307
i386                 randconfig-a016-20220307
hexagon              randconfig-r045-20220307
riscv                randconfig-r042-20220307
hexagon              randconfig-r041-20220307

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
