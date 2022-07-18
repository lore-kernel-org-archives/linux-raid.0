Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5780C43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 18:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiGRSZL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 14:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRSZJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 14:25:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F5413E2F
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 11:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658168708; x=1689704708;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=v3jKC+AA1hHYDrEIVV4YEk8hYkzlekNmR4vmxI3iiTI=;
  b=eYK1Wec16bxFt7a2l/wyFbPFWy4st7R1/0xYmonJ2EKW2rm2a/rbBEjL
   uut5YdPB7/kwnsyvm6LpC7yKtX/78ln2JlUguJlbGhNY+R/NN6M2ie+uy
   GpXaqAXlIIGlsSO3DYfGXyPEeini25QhBifsN6tF9I0LyZwZvgAv9vKEZ
   rcygzPPo55ZzpXa3ziqUtdYMFJb03Wdw7wm9CF1Vbm1bePBVWHSeDlTiN
   VB9MVHQckVQN9uc2ZrXkgxe9nO/PRxqX91mkHZXFSzpmAf7QXC6xQMhbd
   wMMykNQMUvdccvsaf5L21VS9saEwew+HdOeWN3lGBPc3937GHBzlDAV8r
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="311976596"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="311976596"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="572519977"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 18 Jul 2022 11:25:07 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDVQY-0004dm-I5;
        Mon, 18 Jul 2022 18:25:06 +0000
Date:   Tue, 19 Jul 2022 02:24:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 07ac95f0d934331ed71b45cc0bbcafe5f3136a79
Message-ID: <62d5a55a.8IjFxhfUsZ4uxI/P%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 07ac95f0d934331ed71b45cc0bbcafe5f3136a79  raid5: fix duplicate checks for rdev->saved_raid_disk

elapsed time: 721m

configs tested: 56
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm                              allyesconfig
arm64                            allyesconfig
ia64                             allmodconfig
arc                               allnoconfig
alpha                             allnoconfig
riscv                             allnoconfig
csky                              allnoconfig
alpha                            allyesconfig
arc                              allyesconfig
m68k                             allmodconfig
m68k                             allyesconfig
powerpc                           allnoconfig
sh                               allmodconfig
mips                             allyesconfig
powerpc                          allmodconfig
i386                                defconfig
i386                             allyesconfig
x86_64                        randconfig-a002
x86_64                        randconfig-a006
x86_64                        randconfig-a004
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a015
x86_64                        randconfig-a013
x86_64                        randconfig-a011
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
riscv                randconfig-r042-20220718
arc                  randconfig-r043-20220718
s390                 randconfig-r044-20220718
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                           allyesconfig
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests

clang tested configs:
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a014
i386                          randconfig-a013
i386                          randconfig-a015
i386                          randconfig-a011
hexagon              randconfig-r041-20220718
hexagon              randconfig-r045-20220718

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
