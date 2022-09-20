Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A50C54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 07:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiITH3i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Sep 2022 03:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiITH3Q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Sep 2022 03:29:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1417960510
        for <linux-raid@vger.kernel.org>; Tue, 20 Sep 2022 00:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663658950; x=1695194950;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=trEVbY03Y2cPpzuunCPO9QGimsVi7DFILMOacBNyVDA=;
  b=YwePuw/iTJPpn/FXHWJUtgTiVYaeBvFPpXxH3+9bN08ChypjbJdmPgUJ
   HA1K7XJPZOweU6k/rJDn3/+hDk7g1wD1Gz55jif7gRYZnCb0/J5zRkE4h
   yZHF4dudPo6+HkURgtB7e636xV0FV2bcVYXcUEkEOUK9tBB1SJKOhWiy/
   SfyTQJ+XQkzM+1Av9OnPjeEZQzex2L0WmS/3Cg/SOHzGdsZTYa0qYMkAa
   KWd0fKNf1WR0YSv6RFqJ7kHHFWvZ4zpz1YULC2tIcDL5uNcmBjuiJJjw+
   p4HTC4Aam0S2vaaSLdFK6PNUIZibJmFzSd4fSVce1VoHjspc1gPRB7dxZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="361361164"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="361361164"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 00:29:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="596409325"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 20 Sep 2022 00:29:07 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oaXgo-0002ZZ-12;
        Tue, 20 Sep 2022 07:29:06 +0000
Date:   Tue, 20 Sep 2022 15:28:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 673164f606ec776de795c15396faa80288c523d0
Message-ID: <63296b8c.M8M1OefmfqBAISG0%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 673164f606ec776de795c15396faa80288c523d0  Merge branch 'md-next-raid10-optimize' into md-next

elapsed time: 725m

configs tested: 58
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
alpha                               defconfig
um                           x86_64_defconfig
um                             i386_defconfig
alpha                            allyesconfig
arc                              allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
x86_64                              defconfig
s390                                defconfig
s390                             allmodconfig
x86_64                               rhel-8.3
powerpc                           allnoconfig
powerpc                          allmodconfig
i386                 randconfig-a013-20220919
mips                             allyesconfig
s390                             allyesconfig
i386                 randconfig-a012-20220919
x86_64                           allyesconfig
i386                 randconfig-a014-20220919
arc                  randconfig-r043-20220919
x86_64                    rhel-8.3-kselftests
i386                 randconfig-a011-20220919
sh                               allmodconfig
i386                                defconfig
x86_64               randconfig-a012-20220919
i386                 randconfig-a016-20220919
x86_64                           rhel-8.3-syz
i386                 randconfig-a015-20220919
x86_64               randconfig-a011-20220919
s390                 randconfig-r044-20220919
x86_64                          rhel-8.3-func
x86_64               randconfig-a013-20220919
x86_64                         rhel-8.3-kunit
riscv                randconfig-r042-20220919
x86_64               randconfig-a015-20220919
x86_64                           rhel-8.3-kvm
x86_64               randconfig-a016-20220919
arm                                 defconfig
x86_64               randconfig-a014-20220919
ia64                             allmodconfig
i386                             allyesconfig
arm64                            allyesconfig
arm                              allyesconfig

clang tested configs:
i386                 randconfig-a001-20220919
i386                 randconfig-a002-20220919
i386                 randconfig-a003-20220919
i386                 randconfig-a004-20220919
i386                 randconfig-a005-20220919
hexagon              randconfig-r041-20220919
i386                 randconfig-a006-20220919
x86_64               randconfig-a003-20220919
hexagon              randconfig-r045-20220919
x86_64               randconfig-a001-20220919
x86_64               randconfig-a002-20220919
x86_64               randconfig-a004-20220919
x86_64               randconfig-a006-20220919
x86_64               randconfig-a005-20220919

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
