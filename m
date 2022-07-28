Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1E6C19F2B
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 23:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiG1Xp7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 19:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG1Xp6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 19:45:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3379F193EC
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 16:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659051958; x=1690587958;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=SanPTBDFkygamGyjjMkVX/ZksSQzCVVDopl1PklAbXQ=;
  b=EjZVRk1WqYSDDifYBp4KXBqw894spHkVZSCEwtB5XeLyGA+EmFUx4A4x
   PjyqSjn+MG07/gRAryKAsS54+gYIKFL7KMDzC9mY5bWv1wdaLlY/REYg1
   WG2PD77eVDOaVPgWCgyiYjC75znyXul1LqWjLB7UUH/etNZ3z+BtFIRtk
   itirpEgNeW+zH18OJ5OC0G6ceeXeta/1JPe1vEKBsRHrptmm+WnUzaUIu
   zAGXI74NI7WrXrGWzJDZ4dEXhY2ajWqnPb43d8o0xqStdByBiK0QnELow
   gBXl/h1kGHe/WWUI1zJcSxcWADPSsVh3JWfYIv2CdQIJVi2L03rmcFzd0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268416653"
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="268416653"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 16:45:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="576722060"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 28 Jul 2022 16:45:56 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oHDCW-000Aik-0O;
        Thu, 28 Jul 2022 23:45:56 +0000
Date:   Fri, 29 Jul 2022 07:45:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 ae0a80935d6a65764b0db00c8b03d3807b4110a6
Message-ID: <62e31fb0.5RB/YlhuZ0HYHVrI%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: ae0a80935d6a65764b0db00c8b03d3807b4110a6  drivers:md:fix a potential use-after-free bug

elapsed time: 1020m

configs tested: 103
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                           x86_64_defconfig
um                             i386_defconfig
arc                  randconfig-r043-20220728
i386                                defconfig
s390                 randconfig-r044-20220728
i386                          randconfig-a001
riscv                randconfig-r042-20220728
i386                          randconfig-a003
x86_64                    rhel-8.3-kselftests
x86_64                        randconfig-a015
x86_64                          rhel-8.3-func
x86_64                        randconfig-a013
i386                          randconfig-a005
i386                             allyesconfig
x86_64                         rhel-8.3-kunit
x86_64                        randconfig-a011
x86_64                        randconfig-a002
arm                                 defconfig
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
x86_64                        randconfig-a006
x86_64                        randconfig-a004
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
arm64                            allyesconfig
arm                              allyesconfig
powerpc                           allnoconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                         amcore_defconfig
powerpc                 mpc837x_rdb_defconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
powerpc                          allmodconfig
loongarch                         allnoconfig
mips                             allyesconfig
sh                               allmodconfig
arm                            hisi_defconfig
m68k                        m5272c3_defconfig
loongarch                           defconfig
i386                          randconfig-c001
arc                           tb10x_defconfig
powerpc                 mpc8540_ads_defconfig
m68k                       m5475evb_defconfig
powerpc                      pasemi_defconfig
sparc                       sparc64_defconfig
arm                           sama5_defconfig
sh                         ecovec24_defconfig
arm                            qcom_defconfig
s390                       zfcpdump_defconfig
openrisc                         alldefconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
xtensa                  cadence_csp_defconfig
mips                           ip32_defconfig
arc                            hsdk_defconfig
sh                 kfr2r09-romimage_defconfig
sh                     sh7710voipgw_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220728
m68k                        m5407c3_defconfig
powerpc                     taishan_defconfig
sh                         ap325rxa_defconfig
powerpc                      tqm8xx_defconfig
arm                          lpd270_defconfig
sparc                               defconfig
xtensa                           allyesconfig
csky                                defconfig
sparc                            allyesconfig
x86_64                                  kexec

clang tested configs:
hexagon              randconfig-r045-20220728
hexagon              randconfig-r041-20220728
i386                          randconfig-a002
i386                          randconfig-a004
x86_64                        randconfig-a014
i386                          randconfig-a006
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
i386                          randconfig-a013
i386                          randconfig-a015
i386                          randconfig-a011
mips                malta_qemu_32r6_defconfig
powerpc                    gamecube_defconfig
arm                          collie_defconfig
x86_64                        randconfig-k001
arm                       imx_v4_v5_defconfig
arm                       versatile_defconfig
powerpc                      obs600_defconfig
arm                     davinci_all_defconfig
powerpc                     tqm5200_defconfig
powerpc                        fsp2_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
