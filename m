Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4F7C64EC6
	for <linux-raid@archiver.kernel.org>; Wed,  8 Feb 2023 07:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjBHHfB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Feb 2023 02:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjBHHe6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Feb 2023 02:34:58 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8103533456
        for <linux-raid@vger.kernel.org>; Tue,  7 Feb 2023 23:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675841697; x=1707377697;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Qu8XIegJfzk9AEbH+fmZ3s+p9+v0H4+E1tYKymiZbDc=;
  b=iJ2Nwti9OkqNVhQ6T0uTrfPqkmKU0yh41g0XQVj3dKOZtIfTWVDSSINo
   SSqCDdTpC+POj6sEc8EUGkxE5/lWDL/hi2Nwr6kPA3HOmRWb61G5Bi+Yl
   mW1wcJtXy7zPIB05R1tWMUCVJlLsz5oDrCyKhen4RtH2N8QdwXNBjThZ7
   XB+enkVilea29Pz3L7yL3JRtbX2REgJkwxGImwMw34O8bbyYFlV8hLRev
   TzJmGBzLJ08frCCwevS3QEBl7nn1Ea8SNkRVLm+XXwOGSUIk7uHcISfcd
   Kw7weZcjI120kaFbk+Z6B2sojM+3yK5pFzIiGH2GfvBWiq61Sb5nI2LBP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="415954663"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="415954663"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 23:34:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="667150952"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="667150952"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 07 Feb 2023 23:34:55 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pPeyl-0004HJ-0e;
        Wed, 08 Feb 2023 07:34:55 +0000
Date:   Wed, 08 Feb 2023 15:34:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 3f7c3f2b0f113ac56fc202733110e1b738206be3
Message-ID: <63e35079.7ThKn+K9yXBlFemQ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 3f7c3f2b0f113ac56fc202733110e1b738206be3  md: account io_acct_set usage with active_io

elapsed time: 726m

configs tested: 68
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
um                             i386_defconfig
um                           x86_64_defconfig
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                                defconfig
s390                             allyesconfig
m68k                             allmodconfig
alpha                            allyesconfig
powerpc                           allnoconfig
m68k                             allyesconfig
arc                              allyesconfig
x86_64                           rhel-8.3-bpf
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
sh                               allmodconfig
ia64                             allmodconfig
arm                                 defconfig
mips                             allyesconfig
powerpc                          allmodconfig
arm64                            allyesconfig
x86_64                              defconfig
arm                              allyesconfig
i386                                defconfig
x86_64               randconfig-a013-20230206
i386                 randconfig-a011-20230206
i386                 randconfig-a014-20230206
x86_64               randconfig-a011-20230206
i386                 randconfig-a012-20230206
x86_64               randconfig-a015-20230206
i386                 randconfig-a016-20230206
x86_64               randconfig-a012-20230206
x86_64                               rhel-8.3
i386                 randconfig-a013-20230206
i386                 randconfig-a015-20230206
x86_64               randconfig-a016-20230206
x86_64               randconfig-a014-20230206
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
i386                             allyesconfig
x86_64                           allyesconfig
s390                 randconfig-r044-20230206
arc                  randconfig-r043-20230205
arm                  randconfig-r046-20230205
arc                  randconfig-r043-20230206
riscv                randconfig-r042-20230206
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005

clang tested configs:
x86_64                          rhel-8.3-rust
hexagon              randconfig-r041-20230205
riscv                randconfig-r042-20230205
hexagon              randconfig-r045-20230206
hexagon              randconfig-r041-20230206
arm                  randconfig-r046-20230206
s390                 randconfig-r044-20230205
hexagon              randconfig-r045-20230205
x86_64               randconfig-a002-20230206
x86_64               randconfig-a004-20230206
x86_64               randconfig-a003-20230206
x86_64               randconfig-a001-20230206
x86_64               randconfig-a005-20230206
x86_64               randconfig-a006-20230206
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
