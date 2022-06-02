Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93401C43334
	for <linux-raid@archiver.kernel.org>; Thu,  2 Jun 2022 18:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbiFBS7o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238313AbiFBS7n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Jun 2022 14:59:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4E11F3
        for <linux-raid@vger.kernel.org>; Thu,  2 Jun 2022 11:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654196381; x=1685732381;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=UyXrf3Xsmt3xqRvg4ZFx6ojrlyA3HooWEfc6ahWAg5o=;
  b=lIBlaV2wsevV+6SJjmbE7cJj9q+WoG0JPUa2htgbG0DuSOtm5fJbowdS
   ZACNFWFpe++2A+BykkKM/MXAlbrT9g4wLOr09+rf1BDlk/Vyl2uDSh+kP
   x0DgHbnb9ok1ZXak4PLXntJW42KVwhIGU8HoZH2JI3dkeUAAhR3z3hTzl
   iqnJ2GkyLZ+amsbkWtFYcsqW7hqGuXYiD8BFpvUd2DLjr9sCACcDLjo+i
   lPOvuKM1vkmlLB85kYNxcsTi2gS1mb8RB31B6YBn78xc/HHrOMozSZFYb
   nDQIb4jrzXzMkP7bIqwtwjqch8ZF1G1eAhcoI1CmJnnB5asvmWCBG7Zau
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10366"; a="275780726"
X-IronPort-AV: E=Sophos;i="5.91,272,1647327600"; 
   d="scan'208";a="275780726"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 11:59:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,272,1647327600"; 
   d="scan'208";a="530702954"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 02 Jun 2022 11:59:40 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwq2l-0005Ml-GT;
        Thu, 02 Jun 2022 18:59:39 +0000
Date:   Fri, 03 Jun 2022 02:58:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:test/klp-trampoline] BUILD SUCCESS
 6fbf5243a0d6ac55cae9ed84bb5ef0d49d1c00bc
Message-ID: <62990873.0dk/imW2iFmyG2gi%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git test/klp-trampoline
branch HEAD: 6fbf5243a0d6ac55cae9ed84bb5ef0d49d1c00bc  bpf: trampoline: support FTRACE_OPS_FL_SHARE_IPMODIFY

elapsed time: 797m

configs tested: 81
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm64                               defconfig
arm64                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
alpha                               defconfig
csky                                defconfig
nios2                            allyesconfig
alpha                            allyesconfig
nios2                               defconfig
arc                              allyesconfig
arc                                 defconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
parisc                              defconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
s390                             allyesconfig
parisc64                            defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
powerpc                          allyesconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
arc                  randconfig-r043-20220531
riscv                randconfig-r042-20220531
s390                 randconfig-r044-20220531
riscv                             allnoconfig
riscv                            allyesconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
riscv                            allmodconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-syz
x86_64                              defconfig
x86_64                                  kexec
x86_64                           allyesconfig
x86_64                               rhel-8.3

clang tested configs:
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
hexagon              randconfig-r041-20220531
hexagon              randconfig-r045-20220531

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
