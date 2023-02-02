Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC95C61DA4
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 17:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjBBRTq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 12:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjBBRTo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 12:19:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDEA73060
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 09:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675358381; x=1706894381;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=wB0dxaaJDmTn6V9BrH2V1xBHnCHisiAD7ziVQyCLJMM=;
  b=VG9phpxFzOMjFmvyYg7O2i3qeTjuYVPvskUAE/YPrzjt+VCaTzCQaH37
   JR6I5myMQ0dTuPYG7v2xy+KB0qZq7f66N1y0s0tTXqWSA+rRYL/3ojYOz
   0vxBPj95QGhwhykk74ipk/FXgs/OFmCmziJN3vZZe9Np2qF2t6lx+I3mb
   hJF7MTUwGMnBJhH6t6fxvZiuap90bq0oCgr5mvjgm3bOnInmCO1uBh95X
   fePrrzCJ4hU2S+6MsDEMf8QgBw+mL5Ccxds6Hqt/DgKH9n58FL3rRnml3
   6WBKD83nd5bqXgBUM3GidnnqbVhWThM3ok1mCb9WB+GLfeXmRQRzJbBTD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="328524304"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="328524304"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 09:19:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="615370247"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="615370247"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 02 Feb 2023 09:19:39 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNdFK-0006gC-34;
        Thu, 02 Feb 2023 17:19:38 +0000
Date:   Fri, 03 Feb 2023 01:18:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 ed821cf84e7b969fb5b63598c89d3428a30d8d31
Message-ID: <63dbf083.p8moRg6msdZS2k67%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: ed821cf84e7b969fb5b63598c89d3428a30d8d31  md: use MD_RESYNC_* whenever possible

elapsed time: 1376m

configs tested: 68
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
arc                                 defconfig
alpha                               defconfig
s390                                defconfig
x86_64               randconfig-a001-20230130
x86_64               randconfig-a003-20230130
x86_64               randconfig-a004-20230130
s390                             allmodconfig
x86_64               randconfig-a002-20230130
x86_64               randconfig-a006-20230130
x86_64               randconfig-a005-20230130
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
alpha                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
s390                             allyesconfig
i386                 randconfig-a002-20230130
i386                 randconfig-a001-20230130
i386                 randconfig-a004-20230130
i386                 randconfig-a003-20230130
i386                 randconfig-a005-20230130
i386                 randconfig-a006-20230130
ia64                             allmodconfig
um                           x86_64_defconfig
um                             i386_defconfig
powerpc                           allnoconfig
sh                               allmodconfig
mips                             allyesconfig
powerpc                          allmodconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                           allyesconfig
arc                  randconfig-r043-20230129
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
arm                  randconfig-r046-20230129
x86_64                           rhel-8.3-bpf
arm                  randconfig-r046-20230130
arc                  randconfig-r043-20230130
i386                                defconfig
i386                             allyesconfig
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig

clang tested configs:
x86_64                          rhel-8.3-rust
x86_64               randconfig-a014-20230130
x86_64               randconfig-a012-20230130
x86_64               randconfig-a013-20230130
x86_64               randconfig-a011-20230130
x86_64               randconfig-a015-20230130
x86_64               randconfig-a016-20230130
hexagon              randconfig-r041-20230129
riscv                randconfig-r042-20230129
riscv                randconfig-r042-20230130
hexagon              randconfig-r045-20230130
hexagon              randconfig-r041-20230130
hexagon              randconfig-r045-20230129
s390                 randconfig-r044-20230129
s390                 randconfig-r044-20230130
i386                 randconfig-a013-20230130
i386                 randconfig-a011-20230130
i386                 randconfig-a012-20230130
i386                 randconfig-a014-20230130
i386                 randconfig-a015-20230130
i386                 randconfig-a016-20230130

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
