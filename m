Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D03AC433E2
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 09:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5361B2075B
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 09:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgH2Jy5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 05:54:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:24263 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgH2Jy5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 29 Aug 2020 05:54:57 -0400
IronPort-SDR: +9YyvdTkEiw5cL2mgGrJJ+oGzpR3elDJwLPo1OGjAhPX62Ca7w8PYe6SXzGfJmwSgjk9bL89+/
 3o4TQQAmnQbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9727"; a="144466459"
X-IronPort-AV: E=Sophos;i="5.76,367,1592895600"; 
   d="scan'208";a="144466459"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2020 02:54:56 -0700
IronPort-SDR: NY3MC3GgU1fY3JXDi8Fqv8+8Fq4FaN7fWIngBmnLB6nALbmwfVDZFPN32dzGpnGIqug86AcqAx
 7kfpHkekkdjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,367,1592895600"; 
   d="scan'208";a="324328371"
Received: from lkp-server02.sh.intel.com (HELO 301dc1beeb51) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2020 02:54:55 -0700
Received: from kbuild by 301dc1beeb51 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kBxZW-0000R1-NO; Sat, 29 Aug 2020 09:54:54 +0000
Date:   Sat, 29 Aug 2020 17:54:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 13f6b6b1f883e02068ff107075dac6dd35fb137d
Message-ID: <5f4a25e5.4iO75fqXl04XhP6o%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git  md-next
branch HEAD: 13f6b6b1f883e02068ff107075dac6dd35fb137d  md/raid10: pull codes that wait for blocked dev into one function

elapsed time: 726m

configs tested: 91
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
arm                         s3c6400_defconfig
arm                        vexpress_defconfig
mips                   sb1250_swarm_defconfig
sh                        edosk7760_defconfig
arm                        realview_defconfig
mips                          rb532_defconfig
ia64                         bigsur_defconfig
arm                           viper_defconfig
arm64                            alldefconfig
powerpc                          g5_defconfig
arm                          tango4_defconfig
arm                      jornada720_defconfig
sh                           se7780_defconfig
arm                             pxa_defconfig
mips                 pnx8335_stb225_defconfig
sh                          sdk7780_defconfig
arm                          ixp4xx_defconfig
sh                   rts7751r2dplus_defconfig
arm                           sunxi_defconfig
arm                       mainstone_defconfig
mips                     decstation_defconfig
m68k                        stmark2_defconfig
mips                      malta_kvm_defconfig
sh                ecovec24-romimage_defconfig
m68k                          sun3x_defconfig
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
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
c6x                              allyesconfig
parisc                              defconfig
s390                             allyesconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                             defconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a002-20200828
i386                 randconfig-a005-20200828
i386                 randconfig-a003-20200828
i386                 randconfig-a004-20200828
i386                 randconfig-a001-20200828
i386                 randconfig-a006-20200828
x86_64               randconfig-a015-20200828
x86_64               randconfig-a012-20200828
x86_64               randconfig-a016-20200828
x86_64               randconfig-a014-20200828
x86_64               randconfig-a011-20200828
x86_64               randconfig-a013-20200828
i386                 randconfig-a013-20200828
i386                 randconfig-a012-20200828
i386                 randconfig-a011-20200828
i386                 randconfig-a016-20200828
i386                 randconfig-a014-20200828
i386                 randconfig-a015-20200828
riscv                            allyesconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                            allmodconfig
x86_64                                   rhel
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
