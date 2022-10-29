Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723EDC38A02
	for <linux-raid@archiver.kernel.org>; Sat, 29 Oct 2022 11:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJ2L1c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Oct 2022 07:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJ2L1b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Oct 2022 07:27:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65D66888E
        for <linux-raid@vger.kernel.org>; Sat, 29 Oct 2022 04:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667042850; x=1698578850;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=5t3UrktjgrkGZCdZcCVKJPE/H52xKRpDY6WK4U4Y+eQ=;
  b=M2Ur0BaldTNy8HB03CDwG0EitbzKxUAEd/Fki1avusKZ9TjyhLcIiyHA
   BngIgjtP49orRuxwOYiAQ8SERv0lNx8WVD43iXQX5RnNPftZ2KU0ELydE
   Q84zsJkOZQVGQPjsJ/Fjy/cLu8NmMNjCaT6h78vOEyXBzvu8kvABactjH
   kI2+PjY4X19vBh+ABL57nR2BvBmDKLQ8SlfYMiP5JLV8ZMJzbpw3ELGrh
   FtZr1pTUKKvSmcQPpOXR3+IxDn5NiHLxt15bgtHx7EVLlpsnHAK0NMYi/
   7wZNdQNM21dWciIf4fDpDSpCtO1Yvmki3o6hULG0PG1LQKfANUppREsXU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="310353441"
X-IronPort-AV: E=Sophos;i="5.95,223,1661842800"; 
   d="scan'208";a="310353441"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 04:27:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="702030600"
X-IronPort-AV: E=Sophos;i="5.95,223,1661842800"; 
   d="scan'208";a="702030600"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 29 Oct 2022 04:27:29 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oojzs-000AyN-1N;
        Sat, 29 Oct 2022 11:27:28 +0000
Date:   Sat, 29 Oct 2022 19:26:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 a24fec3fdfc56203e3cbb3b6c723babc6c4f1053
Message-ID: <635d0def.DouM+RKZFHRhVnMg%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: a24fec3fdfc56203e3cbb3b6c723babc6c4f1053  Add mddev->io_acct_cnt for raid0_quiesce

elapsed time: 853m

configs tested: 84
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                             allyesconfig
x86_64                          rhel-8.3-func
um                             i386_defconfig
s390                                defconfig
um                           x86_64_defconfig
x86_64                    rhel-8.3-kselftests
arc                  randconfig-r043-20221028
powerpc                          allmodconfig
mips                             allyesconfig
riscv                randconfig-r042-20221028
powerpc                           allnoconfig
s390                 randconfig-r044-20221028
x86_64                              defconfig
sh                               allmodconfig
x86_64                           rhel-8.3-syz
x86_64                        randconfig-a013
i386                                defconfig
x86_64                        randconfig-a011
arm                                 defconfig
x86_64                         rhel-8.3-kunit
ia64                             allmodconfig
i386                          randconfig-a001
x86_64                               rhel-8.3
i386                          randconfig-a014
i386                          randconfig-a003
alpha                            allyesconfig
x86_64                           rhel-8.3-kvm
x86_64                        randconfig-a015
i386                          randconfig-a005
m68k                             allyesconfig
i386                          randconfig-a012
x86_64                           allyesconfig
i386                          randconfig-a016
arc                              allyesconfig
i386                             allyesconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
arm64                            allyesconfig
arm                              allyesconfig
x86_64                        randconfig-a006
powerpc                      ep88xc_defconfig
powerpc                       ppc64_defconfig
powerpc                      makalu_defconfig
arm                           u8500_defconfig
arm                         lpc18xx_defconfig
arm                      jornada720_defconfig
m68k                             allmodconfig
i386                          randconfig-c001
arm                            hisi_defconfig
xtensa                  cadence_csp_defconfig
m68k                           virt_defconfig
powerpc                       holly_defconfig
arm                          pxa3xx_defconfig
sh                        dreamcast_defconfig
s390                       zfcpdump_defconfig
mips                     decstation_defconfig
mips                         bigsur_defconfig
powerpc                      arches_defconfig
nios2                            allyesconfig

clang tested configs:
hexagon              randconfig-r041-20221028
hexagon              randconfig-r045-20221028
i386                          randconfig-a013
i386                          randconfig-a015
i386                          randconfig-a002
x86_64                        randconfig-a012
i386                          randconfig-a011
i386                          randconfig-a004
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a006
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
s390                 randconfig-r044-20221029
hexagon              randconfig-r041-20221029
hexagon              randconfig-r045-20221029
riscv                randconfig-r042-20221029
mips                          rm200_defconfig
powerpc                     akebono_defconfig
mips                  cavium_octeon_defconfig
powerpc                      ppc44x_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
