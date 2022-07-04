Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF941C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Jul 2022 03:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiGDDo4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 23:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiGDDoy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 23:44:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0F82620
        for <linux-raid@vger.kernel.org>; Sun,  3 Jul 2022 20:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656906294; x=1688442294;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=kkfYXHBD7HTMhAENJ6Krdzxx2zsK8L+Yo9ImlmdrKao=;
  b=EhbM347ZMQcvA+4TB96i6tt/ZyRBbQKN7wox7veIuMcgjk1HyWhW9/Bm
   HWq/leDK3F4gniAoJBg18EmZb1BRM59qC9lESPmBdXLWHJYwwZA9jebVy
   8bQ99Sek2+WJiheQZwVLHwgy6IEt2n+CUr+XoRGR7BbJJ4veVb48co9kN
   HiVBxktrHZPChFJN4pF5hUTvAHrC4YfUuHZjqHv9yVinAsPPi0C5XpCJU
   jNL64gZmAfR84l0PJijMu93csIIQI21X/anoXaWNaleVB/9m7pbbaEA/b
   rpnv7RoaIqobinA/P4oEtjVib74mcCCr/40jA+/0oCL5TDkg/8O+6+4+R
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="280578549"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="280578549"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2022 20:44:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="649355236"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 03 Jul 2022 20:44:53 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8D12-000HPb-IF;
        Mon, 04 Jul 2022 03:44:52 +0000
Date:   Mon, 04 Jul 2022 11:44:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 ff4ec5f79108cf82fe7168547c76fe754c4ade0a
Message-ID: <62c26218.9XfUKR3d0aFMsSkV%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: ff4ec5f79108cf82fe7168547c76fe754c4ade0a  md: Fix spelling mistake in comments

elapsed time: 724m

configs tested: 69
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
i386                          randconfig-c001
powerpc                     ep8248e_defconfig
sh                          r7785rp_defconfig
arm                        oxnas_v6_defconfig
arm                           h3600_defconfig
sh                     magicpanelr2_defconfig
m68k                        mvme16x_defconfig
sh                      rts7751r2d1_defconfig
sh                        dreamcast_defconfig
sh                          rsk7269_defconfig
arm                            xcep_defconfig
openrisc                  or1klitex_defconfig
sh                           sh2007_defconfig
powerpc                     pq2fads_defconfig
powerpc                     mpc83xx_defconfig
m68k                            mac_defconfig
ia64                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allmodconfig
m68k                             allyesconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
i386                                defconfig
i386                             allyesconfig
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
riscv                randconfig-r042-20220703
s390                 randconfig-r044-20220703
arc                  randconfig-r043-20220703
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit

clang tested configs:
x86_64                        randconfig-k001
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a015
i386                          randconfig-a011
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
hexagon              randconfig-r041-20220703
hexagon              randconfig-r045-20220703

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
