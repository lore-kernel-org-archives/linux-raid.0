Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AAFEC77B7C
	for <linux-raid@archiver.kernel.org>; Wed, 26 Apr 2023 16:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbjDZQVA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Apr 2023 12:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjDZQU7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Apr 2023 12:20:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1422F7AAB
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 09:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682526047; x=1714062047;
  h=date:from:to:cc:subject:message-id;
  bh=Wk7y5RWuA8OzC5tm9adyWSk1YDKCtO1Df2FA9a0YkKU=;
  b=fZA95BuRpQ9IZY5DCdBbSXmazGaGonZjHblpVIHxIajGJZYjOPULrwxq
   rk6jVCVMU59caEFbrI4btL0CiHEaU5h+UFUMfmX2Fr67HZaghMxU0rEmp
   Hk471a/jgcNj6mlC+RJ1S1Pqq3jOi62Gwx8h3s4ztoFJKfSgVbWUOIFhD
   JXKZgxraQcA57izqPTV8RQJNnYhqE76ZVZA7Eq5+ltO83Owmw3pxK4iGH
   nb8kWxdByes9VwBDG9gSfZDYgDXjkWESCqSdrBeXgl2s9hNqD4w94HzA/
   DBP1RFiKRX3uYYc8Snqn1FQxdfZki3ODB+u0Np2kQpx4BDeCMEP5JJ2Fs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="331390985"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="331390985"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 09:19:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="694011053"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="694011053"
Received: from lkp-server01.sh.intel.com (HELO 041f065c1b1b) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 26 Apr 2023 09:19:44 -0700
Received: from kbuild by 041f065c1b1b with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1prhrr-0000MU-1f;
        Wed, 26 Apr 2023 16:19:43 +0000
Date:   Thu, 27 Apr 2023 00:19:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 871634828fc3c8069941c7b6a031a71faa61a9f4
Message-ID: <20230426161918.3i9u4%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 871634828fc3c8069941c7b6a031a71faa61a9f4  md: Fix bitmap offset type in sb writer

elapsed time: 726m

configs tested: 60
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r021-20230423   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r001-20230425   gcc  
csky                 randconfig-r022-20230423   gcc  
csky                 randconfig-r025-20230423   gcc  
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r005-20230425   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r004-20230425   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r024-20230423   gcc  
nios2                randconfig-r026-20230423   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r006-20230425   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
sh                               allmodconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r002-20230425   gcc  
sparc64              randconfig-r023-20230423   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a011-20230424   gcc  
x86_64               randconfig-a012-20230424   gcc  
x86_64               randconfig-a013-20230424   gcc  
x86_64               randconfig-a014-20230424   gcc  
x86_64               randconfig-a015-20230424   gcc  
x86_64               randconfig-a016-20230424   gcc  
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
