Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B0EC05027
	for <linux-raid@archiver.kernel.org>; Fri, 10 Feb 2023 10:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjBJKBi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Feb 2023 05:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjBJKBf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Feb 2023 05:01:35 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9077AE06
        for <linux-raid@vger.kernel.org>; Fri, 10 Feb 2023 02:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676023295; x=1707559295;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=8QSfBML25jKxNVM9ZuCSjj+OmS3HqKyqJ2KfDpkN5y4=;
  b=RROnZAugGOgYTOqiQp9Lb3QcnGk11OHrJZawDIw/bV7owlSeBlKc3MiT
   mC/WprYjzi90RPblD5QZbgApkZG33bYCS/uWFo8WvlvbjUCrd2xQXXuNx
   KnIbjF0FmfFTQU+7mAD3QCg6q4LPKDoCjEe7FTc3US546AOUSgWyAmguv
   wJy9NvNnW9cV0swDwBCyiyPM0TRLeV+p6XwJ6Rt2aAWrXmSwXpC4yZzvy
   MPVwtBZx04jYorK9qh4dimp2QKpUUiA1DH65IS9J7llwnKtpP2DOmS4CM
   MOxN2Rd4GVrT6h0eVYUXhdBS96LprakT4GrQjUCVBtd2VZ19Bz4Hu2P/2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394988036"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="394988036"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 02:01:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="996911120"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="996911120"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 10 Feb 2023 02:01:33 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQQDk-0005jp-0c;
        Fri, 10 Feb 2023 10:01:32 +0000
Date:   Fri, 10 Feb 2023 18:01:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 76fed01420bb8b0e282745a4945925b25751d42b
Message-ID: <63e615dd.dZoNA7xphqQ4vuJ+%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 76fed01420bb8b0e282745a4945925b25751d42b  md: account io_acct_set usage with active_io

elapsed time: 2035m

configs tested: 63
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
powerpc                           allnoconfig
um                           x86_64_defconfig
um                             i386_defconfig
sh                               allmodconfig
arc                                 defconfig
s390                             allmodconfig
x86_64                              defconfig
mips                             allyesconfig
m68k                             allmodconfig
alpha                               defconfig
alpha                            allyesconfig
s390                                defconfig
x86_64                               rhel-8.3
x86_64                           rhel-8.3-bpf
powerpc                          allmodconfig
m68k                             allyesconfig
arm                                 defconfig
x86_64                           rhel-8.3-syz
s390                             allyesconfig
x86_64                           allyesconfig
arc                              allyesconfig
x86_64                        randconfig-a006
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                           rhel-8.3-kvm
x86_64                         rhel-8.3-kunit
i386                                defconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
arm64                            allyesconfig
arm                              allyesconfig
i386                             allyesconfig
ia64                             allmodconfig
loongarch                         allnoconfig
arm64                               defconfig
arm                              allmodconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
csky                                defconfig
sparc                               defconfig
x86_64                                  kexec
m68k                                defconfig
i386                              debian-10.3
loongarch                           defconfig
mips                             allmodconfig
riscv                             allnoconfig
riscv                            allmodconfig
riscv                               defconfig
riscv                          rv32_defconfig
ia64                                defconfig

clang tested configs:
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
x86_64                        randconfig-a016

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
