Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E21CECAAA1
	for <linux-raid@archiver.kernel.org>; Sat, 10 Sep 2022 03:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIJDTq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 23:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIJDTn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 23:19:43 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AC0958F
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 20:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662779980; x=1694315980;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=zVnEmgINbnWzk8XFuD2M+8reF98XOtZQPWlghDYmH54=;
  b=ByoYt1F/pxtOCZ4NT5ASitiy4jXH47EQpr65i7fTxTzFQTb5g+9kYkQb
   89Gz91cG0uO9ITVSD4nTt/UL+8wNnyx+oTzJ+FJpOaibOojCwZeiEQjl4
   nZqpidJTeEQptqjveUUeSz8SwzUQW2QJm16fVzAYKescahjrKU4/6HZzM
   Kaju356VzZWCUEbwdNbv7GfF6xKuMcGWU3CAYLEdkFQ5X1PicK8Ao/oHb
   Ugz7Y5wSdFXCuAtpdBUUSzSxe0GVou2RecR9mZLJWVrHFgkUYCQeXqLgN
   nisaGA020uf0fDnmJqMHV2V1Od4GCx7Z7I24YH/68ETOE8jH6LQbdFx2O
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10465"; a="361563067"
X-IronPort-AV: E=Sophos;i="5.93,304,1654585200"; 
   d="scan'208";a="361563067"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 20:19:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,304,1654585200"; 
   d="scan'208";a="645775455"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 09 Sep 2022 20:19:31 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWr1m-00023x-2L;
        Sat, 10 Sep 2022 03:19:30 +0000
Date:   Sat, 10 Sep 2022 11:19:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 57f13b2f370be189aaa67299e400930632574ae4
Message-ID: <631c0230.HXcxKJFlMgKlm4/M%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 57f13b2f370be189aaa67299e400930632574ae4  md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

elapsed time: 724m

configs tested: 105
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                           x86_64_defconfig
um                             i386_defconfig
arc                              allyesconfig
alpha                            allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
m68k                             allmodconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
m68k                             allyesconfig
x86_64                           allyesconfig
i386                                defconfig
mips                             allyesconfig
sh                               allmodconfig
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-syz
i386                          randconfig-a001
x86_64                           rhel-8.3-kvm
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                             allyesconfig
x86_64                        randconfig-a006
arm64                            allyesconfig
arm                              allyesconfig
i386                          randconfig-a012
arm                                 defconfig
i386                          randconfig-a014
i386                          randconfig-a016
sh                             espt_defconfig
riscv             nommu_k210_sdcard_defconfig
arm                            mps2_defconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
powerpc                      ppc40x_defconfig
arm                         axm55xx_defconfig
mips                         db1xxx_defconfig
arm                            zeus_defconfig
parisc                              defconfig
sh                     sh7710voipgw_defconfig
arm                        keystone_defconfig
x86_64                           alldefconfig
xtensa                    xip_kc705_defconfig
mips                    maltaup_xpa_defconfig
mips                      maltasmvp_defconfig
i386                          randconfig-c001
m68k                        m5407c3_defconfig
nios2                         3c120_defconfig
loongarch                           defconfig
loongarch                         allnoconfig
arm                         cm_x300_defconfig
powerpc                    klondike_defconfig
arm                          badge4_defconfig
mips                      fuloong2e_defconfig
s390                       zfcpdump_defconfig
mips                        bcm47xx_defconfig
arm                            pleb_defconfig
arc                              alldefconfig
sh                              ul2_defconfig
arm                           sunxi_defconfig
arm                          exynos_defconfig
riscv                               defconfig
nios2                         10m50_defconfig
powerpc                 mpc837x_rdb_defconfig
sh                   secureedge5410_defconfig
arm                         lubbock_defconfig
sh                          rsk7264_defconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
mips                     decstation_defconfig
sh                         ecovec24_defconfig
sh                           se7712_defconfig
ia64                             allmodconfig
arm                        clps711x_defconfig
sh                             shx3_defconfig
riscv                            allmodconfig

clang tested configs:
i386                          randconfig-a002
i386                          randconfig-a004
x86_64                        randconfig-a012
riscv                randconfig-r042-20220909
hexagon              randconfig-r041-20220909
hexagon              randconfig-r045-20220909
s390                 randconfig-r044-20220909
i386                          randconfig-a006
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
x86_64                        randconfig-k001
riscv                randconfig-r042-20220907
hexagon              randconfig-r041-20220907
hexagon              randconfig-r045-20220907
s390                 randconfig-r044-20220907
hexagon              randconfig-r041-20220908
hexagon              randconfig-r045-20220908

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
