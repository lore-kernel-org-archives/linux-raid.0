Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84856C352A1
	for <linux-raid@archiver.kernel.org>; Wed, 30 Nov 2022 17:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiK3RJF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Nov 2022 12:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiK3RIl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Nov 2022 12:08:41 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B188B18F
        for <linux-raid@vger.kernel.org>; Wed, 30 Nov 2022 09:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669827817; x=1701363817;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=b94jstjaKyTs40Va4qkS+V8ejoyGDBsMbFZdwSZKqFg=;
  b=Ro62l+sTfPIaYLm46qY5l8rbBpFszo3r/j4iuWcgyMCCNSx6miGErk0q
   21qjQzcBreQqAKneW9HT8FdhW2ccxGU+4o19RcVdti6GxuSyMoSBgABGl
   k8svm6JSzIckVo3e2M1rdeyXjAOWSwk76KYlI2VjiiOtbcZB4OMpXEKcs
   onnl/OFCgeidil1WFggCQ8uf2ViYfGQB6+9VJ6/kZP6rrl9sRxeJqyuqj
   GT5Q+Q/9EcEzjCL18HrLFkE5o/NgK12HLtW1PMfk3ZEFhC5GQScNWcj9P
   EQUxZSKq1pfIMS7mhI+4TIhndgZ64fh9DnMQbZv5DNTFUNK0CACGzGU08
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="342376367"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="342376367"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 09:02:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707718848"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="707718848"
Received: from lkp-server01.sh.intel.com (HELO 64a2d449c951) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 30 Nov 2022 09:02:31 -0800
Received: from kbuild by 64a2d449c951 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p0QTe-000BTk-2b;
        Wed, 30 Nov 2022 17:02:30 +0000
Date:   Thu, 01 Dec 2022 01:02:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 b41b054a24e7026fad2dac6363668841ad5019d5
Message-ID: <63878ca5.Ook2tI1V42DjzQn5%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: b41b054a24e7026fad2dac6363668841ad5019d5  md: fold unbind_rdev_from_array into md_kick_rdev_from_array

elapsed time: 922m

configs tested: 68
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                                defconfig
s390                             allyesconfig
um                             i386_defconfig
um                           x86_64_defconfig
powerpc                           allnoconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
x86_64                               rhel-8.3
x86_64                              defconfig
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
sh                               allmodconfig
x86_64                           allyesconfig
mips                             allyesconfig
powerpc                          allmodconfig
arc                  randconfig-r043-20221128
ia64                             allmodconfig
i386                                defconfig
i386                             allyesconfig
i386                 randconfig-a001-20221128
i386                 randconfig-a005-20221128
i386                 randconfig-a006-20221128
i386                 randconfig-a004-20221128
i386                 randconfig-a003-20221128
i386                 randconfig-a002-20221128
x86_64               randconfig-a002-20221128
x86_64               randconfig-a001-20221128
x86_64               randconfig-a004-20221128
x86_64               randconfig-a006-20221128
x86_64               randconfig-a005-20221128
x86_64               randconfig-a003-20221128
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
x86_64                            allnoconfig
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig

clang tested configs:
hexagon              randconfig-r045-20221128
riscv                randconfig-r042-20221128
hexagon              randconfig-r041-20221128
s390                 randconfig-r044-20221128
x86_64               randconfig-a013-20221128
x86_64               randconfig-a012-20221128
x86_64               randconfig-a014-20221128
x86_64               randconfig-a011-20221128
x86_64               randconfig-a015-20221128
x86_64               randconfig-a016-20221128
i386                 randconfig-a014-20221128
i386                 randconfig-a011-20221128
i386                 randconfig-a013-20221128
i386                 randconfig-a016-20221128
i386                 randconfig-a012-20221128
i386                 randconfig-a015-20221128
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
hexagon              randconfig-r041-20221130
hexagon              randconfig-r045-20221130
x86_64               randconfig-k001-20221128

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
