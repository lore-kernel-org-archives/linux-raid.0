Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B53DC433B4
	for <linux-raid@archiver.kernel.org>; Fri, 16 Apr 2021 07:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FCAC60238
	for <linux-raid@archiver.kernel.org>; Fri, 16 Apr 2021 07:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239299AbhDPH0g (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Apr 2021 03:26:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:57817 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231666AbhDPH0f (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 16 Apr 2021 03:26:35 -0400
IronPort-SDR: Mwsaf5CpmyJ901Vg8hmfOiXVKQRgJq1WAnSU2RFdIHdm/hnph5sLiNQQIzcmnry9EhRDaBm5S8
 tEH5oqxzplww==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="194561443"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="194561443"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:26:11 -0700
IronPort-SDR: iDZggWRBfkN+C7tDagZZAYlE8Al8BjbhqA3qTjVNbIPHZEWElTZ0R+e/kq8O6rfEyfRSyuCQVi
 5IL0rwxvjvRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="419032123"
Received: from lkp-server01.sh.intel.com (HELO e2aa577b5d78) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 16 Apr 2021 00:26:10 -0700
Received: from kbuild by e2aa577b5d78 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lXIrh-00001Y-ON; Fri, 16 Apr 2021 07:26:09 +0000
Date:   Fri, 16 Apr 2021 15:25:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 404a8ef512587b2460107d3272c17a89aef75edf
Message-ID: <60793bee.uPQVUc/Nh5EC57Zu%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 404a8ef512587b2460107d3272c17a89aef75edf  md/bitmap: wait for external bitmap writes to complete during tear down

elapsed time: 727m

configs tested: 122
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
x86_64                           allyesconfig
riscv                            allmodconfig
riscv                            allyesconfig
i386                             alldefconfig
m68k                        m5307c3_defconfig
arm                         lpc32xx_defconfig
sh                     sh7710voipgw_defconfig
arm                         orion5x_defconfig
arm                    vt8500_v6_v7_defconfig
powerpc                     mpc5200_defconfig
sh                         apsh4a3a_defconfig
powerpc                     taishan_defconfig
s390                             alldefconfig
arm                          pxa168_defconfig
h8300                     edosk2674_defconfig
powerpc                     tqm5200_defconfig
powerpc                    klondike_defconfig
mips                     cu1000-neo_defconfig
powerpc                 mpc832x_mds_defconfig
sparc64                          alldefconfig
powerpc                 mpc832x_rdb_defconfig
powerpc                       ebony_defconfig
arm                           sama5_defconfig
mips                            ar7_defconfig
m68k                        m5272c3_defconfig
powerpc                     tqm8560_defconfig
nios2                            allyesconfig
sh                ecovec24-romimage_defconfig
arm                          simpad_defconfig
powerpc                      ppc44x_defconfig
arm                         cm_x300_defconfig
sh                          rsk7203_defconfig
arm                          pxa910_defconfig
arm                           sunxi_defconfig
mips                           ip32_defconfig
mips                  decstation_64_defconfig
powerpc                        cell_defconfig
arm                      tct_hammer_defconfig
sh                        apsh4ad0a_defconfig
arm                        mvebu_v7_defconfig
alpha                               defconfig
mips                            e55_defconfig
ia64                             alldefconfig
powerpc                     kilauea_defconfig
arm                        trizeps4_defconfig
m68k                          multi_defconfig
powerpc                    sam440ep_defconfig
mips                        workpad_defconfig
arm                         s3c6400_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nds32                               defconfig
csky                                defconfig
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
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a003-20210415
x86_64               randconfig-a002-20210415
x86_64               randconfig-a005-20210415
x86_64               randconfig-a001-20210415
x86_64               randconfig-a006-20210415
x86_64               randconfig-a004-20210415
i386                 randconfig-a003-20210415
i386                 randconfig-a006-20210415
i386                 randconfig-a001-20210415
i386                 randconfig-a005-20210415
i386                 randconfig-a004-20210415
i386                 randconfig-a002-20210415
i386                 randconfig-a015-20210415
i386                 randconfig-a014-20210415
i386                 randconfig-a013-20210415
i386                 randconfig-a012-20210415
i386                 randconfig-a016-20210415
i386                 randconfig-a011-20210415
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
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
x86_64               randconfig-a014-20210415
x86_64               randconfig-a015-20210415
x86_64               randconfig-a011-20210415
x86_64               randconfig-a013-20210415
x86_64               randconfig-a012-20210415
x86_64               randconfig-a016-20210415

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
