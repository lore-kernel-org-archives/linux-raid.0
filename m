Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A22DC61DA4
	for <linux-raid@archiver.kernel.org>; Thu,  9 Feb 2023 13:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjBINUt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Feb 2023 08:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBINUs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Feb 2023 08:20:48 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4632D2D7B
        for <linux-raid@vger.kernel.org>; Thu,  9 Feb 2023 05:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675948847; x=1707484847;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=z7biFJNbk1woSyiJNESkMtJkDXpDG6SmWKKHSPnmV8c=;
  b=fck0VB8M+A0kMBlPmtJOdu17OCYhdCXb3EZDY9V9CFOyg+a+lLplkryV
   j8gKI9vfRtPVxeXUnnhpQsni+zXnCybWp3wtdM80VkYAlpXYvUuoh4tYM
   wpeU1dJ9TPk2EbZRt8Cf82Y69j34XHSwcgfHmlJtiducb4ywUQDEhuJej
   RD2F0o+Hf9BGJwwZKTpOfc35MpLo/Zmvy+7JuvXu2TrWk1F/ZdNo4LLHm
   AkA9dENF5vUMGpHf80Cn9wCEUJt+C8QCmSdF0j76RNjYVOH8RtG1QTgqT
   f4AiGe4Xuh/Dlduh6GgiPvyTrObHf2geXYZkw37mU82gOZSYBKFhjWK9L
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="330125251"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="330125251"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 05:20:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776478070"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="776478070"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 09 Feb 2023 05:20:42 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQ6qv-00055u-2V;
        Thu, 09 Feb 2023 13:20:41 +0000
Date:   Thu, 09 Feb 2023 21:20:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:new_module_alloc_build_test] BUILD SUCCESS
 efe6ec771369ca06ed80182c30ffcf9c494146dd
Message-ID: <63e4f303.j6By4V0MXNgfXo7G%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git new_module_alloc_build_test
branch HEAD: efe6ec771369ca06ed80182c30ffcf9c494146dd  module: replace module_layout with module_memory

elapsed time: 720m

configs tested: 57
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
um                           x86_64_defconfig
um                             i386_defconfig
powerpc                           allnoconfig
x86_64                        randconfig-a006
x86_64                              defconfig
i386                                defconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
x86_64                           allyesconfig
alpha                            allyesconfig
sh                               allmodconfig
ia64                             allmodconfig
i386                          randconfig-a014
arc                  randconfig-r043-20230209
arm                  randconfig-r046-20230209
i386                          randconfig-a012
i386                          randconfig-a016
i386                             allyesconfig
mips                             allyesconfig
powerpc                          allmodconfig
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                                defconfig
s390                             allyesconfig
x86_64                           rhel-8.3-bpf
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig

clang tested configs:
x86_64                          rhel-8.3-rust
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a013
i386                          randconfig-a006
hexagon              randconfig-r041-20230209
hexagon              randconfig-r045-20230209
i386                          randconfig-a011
s390                 randconfig-r044-20230209
riscv                randconfig-r042-20230209
i386                          randconfig-a015
x86_64                        randconfig-a014
x86_64                        randconfig-a012
x86_64                        randconfig-a016

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
