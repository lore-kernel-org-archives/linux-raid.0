Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F48C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 23:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiCIXEQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiCIXEO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 18:04:14 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80858972E3
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 15:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646866994; x=1678402994;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=m1ku7kZvQOjSAYmzH0DeM/x4Lc09KJS+ggugCZmq3Ls=;
  b=Gt6eyn8J8aKLyjiBpVXJW/gTMIFe1X3+44zXb5cbztsjB6HSjWgGv1nI
   rhPvrq58TXrXyPhVErrlwYjot0j7wE9l/x6cfJYMFUPXC9XFa2WdSNeoS
   1ZN6FiLMxK1SX+JBy1jQ6IjNR/N6aC1OvZOXMUraQCstdmFJLrXjwPceo
   9cohAbpWh7Q1fbRf8Yh02GH56JDICx2RXka5LPNR/iKg9hp0K5EhU48BR
   trkOunprFWtUobVad6etkglYJdZlzTP7L62xHEhFR7GMZX0RGTqh7t3iL
   gHNkrah0bG9M5stcCIyAT3WgHTELdIKkiOY/OQUdH6leS8BEEywoTZqR8
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235718824"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235718824"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 15:03:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="578567593"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 09 Mar 2022 15:03:12 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nS5Kp-0003vu-No; Wed, 09 Mar 2022 23:03:11 +0000
Date:   Thu, 10 Mar 2022 07:02:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 03a6b195e8e846f7373bcbeb3ea2a756dfb9ae61
Message-ID: <62293220.fDpVXuoIpF3Flpc4%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 03a6b195e8e846f7373bcbeb3ea2a756dfb9ae61  raid5: initialize the stripe_head embeeded bios as needed

elapsed time: 724m

configs tested: 118
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allmodconfig
arm                              allyesconfig
i386                          randconfig-c001
arm                        clps711x_defconfig
m68k                       m5208evb_defconfig
sparc64                          alldefconfig
sh                              ul2_defconfig
sh                          r7785rp_defconfig
sh                     magicpanelr2_defconfig
h8300                     edosk2674_defconfig
sh                           se7206_defconfig
arm                           corgi_defconfig
arm                        spear6xx_defconfig
sh                          rsk7203_defconfig
powerpc                    klondike_defconfig
powerpc                     taishan_defconfig
powerpc                 mpc8540_ads_defconfig
arc                          axs103_defconfig
m68k                         apollo_defconfig
parisc64                         alldefconfig
powerpc                  iss476-smp_defconfig
mips                     loongson1b_defconfig
sh                          lboxre2_defconfig
powerpc                      chrp32_defconfig
sh                         ap325rxa_defconfig
parisc                generic-32bit_defconfig
powerpc                 mpc837x_mds_defconfig
sh                            hp6xx_defconfig
mips                            gpr_defconfig
powerpc                        cell_defconfig
sh                           se7705_defconfig
sh                           se7722_defconfig
arm                        keystone_defconfig
powerpc                 mpc837x_rdb_defconfig
mips                           xway_defconfig
arm                  randconfig-c002-20220309
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
csky                                defconfig
alpha                               defconfig
nds32                               defconfig
nios2                            allyesconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
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
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
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
x86_64                         rhel-8.3-kunit
x86_64                                  kexec

clang tested configs:
x86_64                        randconfig-c007
riscv                randconfig-c006-20220309
powerpc              randconfig-c003-20220309
i386                          randconfig-c001
arm                  randconfig-c002-20220309
powerpc                          allyesconfig
arm                           sama7_defconfig
mips                            e55_defconfig
powerpc                     ppa8548_defconfig
powerpc                     akebono_defconfig
arm                       mainstone_defconfig
arm                      pxa255-idp_defconfig
powerpc                 mpc8315_rdb_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a011
i386                          randconfig-a013
i386                          randconfig-a015
hexagon              randconfig-r045-20220309
hexagon              randconfig-r041-20220309
riscv                randconfig-r042-20220309

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
