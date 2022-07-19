Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B76C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 10:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbiGSKuy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 06:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237187AbiGSKuv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 06:50:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455B8B7F3
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 03:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658227851; x=1689763851;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=yZbQAoRxQNwohf3HFyfAe/9JxC8hkH8btf27l5INlUQ=;
  b=eF0OA4mXz3uXN8UpwbZq9xvSRKhPU7yHt+kGD4qVIOvp6BlG+qG/GE42
   44MBwkOliGteK8VIMJLksVAgfmL4fF+embEgciA2N2Vpc51OVX2EBdqnZ
   4kXU+gXq3AzUBBhivSFPwArJJUthllFHVF8IR2wapU3JbIScvFsJlXU12
   yHNe1ML8ho7UjUJZJiTrG2yoB2ifgj9ukemo+u0Am7J9aadAlzCIvFwu6
   wb25e4BUXr5n3PlN684w30WRb9dekeqYO5a/sJL+1OzP58AOEp5d4Z3+V
   pk6mRBaSh5Hk1EWxGPBkzvaItpCbkmtVhmRfqEnBbjzdPZeeJzojb1EAW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="266237135"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="266237135"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 03:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="547870075"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 19 Jul 2022 03:50:49 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDkoS-0005Zm-Nj;
        Tue, 19 Jul 2022 10:50:48 +0000
Date:   Tue, 19 Jul 2022 18:50:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 f8584a43b407dc0b7277e722a4b7fbca9f4bee44
Message-ID: <62d68c66.+NobHIqFoeInna01%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: f8584a43b407dc0b7277e722a4b7fbca9f4bee44  raid5: fix duplicate checks for rdev->saved_raid_disk

elapsed time: 723m

configs tested: 52
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm                              allyesconfig
arm64                            allyesconfig
ia64                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
powerpc                          allmodconfig
mips                             allyesconfig
powerpc                           allnoconfig
sh                               allmodconfig
i386                                defconfig
i386                             allyesconfig
x86_64                        randconfig-a002
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64               randconfig-a013-20220718
x86_64               randconfig-a011-20220718
x86_64               randconfig-a012-20220718
x86_64               randconfig-a015-20220718
x86_64               randconfig-a014-20220718
x86_64               randconfig-a016-20220718
i386                 randconfig-a011-20220718
i386                 randconfig-a013-20220718
i386                 randconfig-a016-20220718
i386                 randconfig-a012-20220718
i386                 randconfig-a015-20220718
i386                 randconfig-a014-20220718
riscv                randconfig-r042-20220718
arc                  randconfig-r043-20220718
s390                 randconfig-r044-20220718
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                           allyesconfig

clang tested configs:
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
i386                 randconfig-a003-20220718
i386                 randconfig-a001-20220718
i386                 randconfig-a002-20220718
i386                 randconfig-a006-20220718
i386                 randconfig-a004-20220718
i386                 randconfig-a005-20220718
hexagon              randconfig-r041-20220718
hexagon              randconfig-r045-20220718

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
