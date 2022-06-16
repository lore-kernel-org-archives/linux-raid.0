Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28B3C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 16 Jun 2022 06:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358891AbiFPGDI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Jun 2022 02:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358520AbiFPGDG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Jun 2022 02:03:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E264C1CB02
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 23:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655359386; x=1686895386;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ffvWlvl0n/Y37MAWfouGfW3caBFA/zPmzKbsBgkcVF0=;
  b=ch+3uzMJNejYC12vK2AgQlBYK33ekJAs1U53alvA9DkhyfFrDubB8iLg
   hlKZl/ueCfPMIcvg45nyLTLtVLwbkpJruX4/YNoxJndoKHpAgBqlOB/2G
   NVtNl58hLMHBit+s8VgsNFq15RvcO7ByvuqNqQvXp2kIZuda2GRDw8NRd
   /0+sXxjqHeP6JLpdpuXf4Tl8pCWLc8oH7v3N6AD/mxeDI3YuyqKkwzTYo
   BNNHJYuXCNEc6j1sNJztsesorVOrEb9jaq5dsKZ1l2+JfEbSjvqVmx3JU
   +kMj+4ytFqtg8CIeeu0e2VhuTiSz2Pqr8I3ruJRg3ZJpK9DXxQqDpIRYe
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="276748299"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="276748299"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 23:02:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="653019571"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2022 23:02:49 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o1iae-000O83-UX;
        Thu, 16 Jun 2022 06:02:48 +0000
Date:   Thu, 16 Jun 2022 14:02:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-fixes] BUILD SUCCESS
 f34fdcd4a0e7a0b92340ad7e48e7bcff9393fab5
Message-ID: <62aac785.imn5rwAIsgZ1l4lC%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
branch HEAD: f34fdcd4a0e7a0b92340ad7e48e7bcff9393fab5  md/raid5-ppl: Fix argument order in bio_alloc_bioset()

elapsed time: 740m

configs tested: 51
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                               defconfig
arm64                            allyesconfig
arm                              allmodconfig
arm                                 defconfig
arm                              allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
nios2                               defconfig
arc                              allyesconfig
csky                                defconfig
nios2                            allyesconfig
alpha                               defconfig
alpha                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
xtensa                           allyesconfig
s390                                defconfig
s390                             allmodconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                             allyesconfig
sparc                               defconfig
i386                             allyesconfig
sparc                            allyesconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
riscv                               defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
riscv                            allmodconfig
riscv                            allyesconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                                  kexec
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
