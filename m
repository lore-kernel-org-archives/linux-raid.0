Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC897C19F29
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jul 2022 06:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiG0GbD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jul 2022 02:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiG0GbA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Jul 2022 02:31:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EA1A441
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 23:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658903459; x=1690439459;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=KloebxEd8umrL1N3eaTqRYYwtGGjacnMnhNtNqzNR8o=;
  b=j2Iin8YmM5Eu+046hdReR24GdonkfU5038kcKCaQ3KoNgFoyub1Wgaat
   3rXruMHwyBYdqLIz2UstZJ4RfHA1VCu2ER9PMQTHnR8xCzyK6zn0hxuzj
   GVhJ0eXnfCD0Xx0ik6JctnFsxxz2oBmqq2VCZMZTIhk2Wn4GjOROHKKt1
   fn/6VDK3tesXBvVNbQN+WJ+QJKnQKMbebU3PFrUWD5c0M61rwiNbzGnBw
   QXOrjry3MNIyOurYuGEXxO+fREWrAyQgR+fKz6UQsf5Xw0Jyg+ICr1WZU
   JOk7wxsouqrU95NMhAWtiduH5IasH9rxfR8IyvTagelLgMMbrZraKIvLv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="349861518"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="349861518"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 23:30:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="668214803"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jul 2022 23:30:54 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oGaZJ-0008PO-23;
        Wed, 27 Jul 2022 06:30:53 +0000
Date:   Wed, 27 Jul 2022 14:30:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 7a6f9e9cf1befa0a1578501966d3c9b0cae46727
Message-ID: <62e0db9c.0diy2qC7IBsqXLAH%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 7a6f9e9cf1befa0a1578501966d3c9b0cae46727  md-raid10: fix KASAN warning

elapsed time: 726m

configs tested: 74
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
i386                          randconfig-c001
arm64                               defconfig
arm                        spear6xx_defconfig
powerpc                         ps3_defconfig
arm                        keystone_defconfig
nios2                            allyesconfig
arc                          axs103_defconfig
nios2                               defconfig
m68k                         apollo_defconfig
um                                  defconfig
parisc                           allyesconfig
ia64                             allmodconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
i386                                defconfig
i386                             allyesconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a015
x86_64                        randconfig-a013
x86_64                        randconfig-a011
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                        randconfig-a002
x86_64                        randconfig-a006
x86_64                        randconfig-a004
s390                 randconfig-r044-20220724
riscv                randconfig-r042-20220724
arc                  randconfig-r043-20220724
arc                  randconfig-r043-20220726
s390                 randconfig-r044-20220726
riscv                randconfig-r042-20220726
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                           allyesconfig
x86_64                           rhel-8.3-kvm
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit

clang tested configs:
powerpc                          allmodconfig
mips                  cavium_octeon_defconfig
powerpc               mpc834x_itxgp_defconfig
powerpc                 mpc836x_rdk_defconfig
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r045-20220726
hexagon              randconfig-r041-20220726

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
