Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EE4C77B7C
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 11:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjEaLMU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 07:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjEaLMT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 07:12:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1523A107
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 04:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685531538; x=1717067538;
  h=date:from:to:cc:subject:message-id;
  bh=ZxdAai7aOGubkSb+MkeDu5Fwzvd1ty0M7yzGaMqr/UA=;
  b=l6mhPOnBZRtaz9/+iwKfnZZblkbAKdAhggYvQJXp0qSZBLg6X0efmjAJ
   RGg0lAHS0euCNY8G4gAaHfQCDSnruura5MevMMPpUUaECzs//nosci3xc
   u2+ubGAbqSU6AtFXxuPNdK9VJSu9g/fjhfLJ8M/0pz3tQV31E0jzsNu8c
   aH8F7MWVdPjoD1KVH8r8UcLhMKr5cy7Zz1oEg3ACuIBIRw3/eV7s6olXd
   v3PpI3LgJsZv4xEEyN2BwpAttGOUPm8Ld6MpAPAcfcOZqt27yUIFt3RfT
   z9+UztQdjx4kqa+LtQIqFA3e/Ld6WFSB8tTHG5Baa/j68y4lu/hDfs5oh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="335552400"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="335552400"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 04:12:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="881136983"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="881136983"
Received: from lkp-server01.sh.intel.com (HELO fb1ced2c09fb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 31 May 2023 04:12:16 -0700
Received: from kbuild by fb1ced2c09fb with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q4JkV-0001Hf-32;
        Wed, 31 May 2023 11:12:15 +0000
Date:   Wed, 31 May 2023 19:11:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 979f277d08f143765eb427e86a2210d2d706ecfe
Message-ID: <20230531111159.w-HqG%lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 979f277d08f143765eb427e86a2210d2d706ecfe  md/raid10: clean up md_add_new_disk()

elapsed time: 723m

configs tested: 45
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r006-20230531   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r005-20230531   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-r004-20230531   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r003-20230531   clang
nios2                               defconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r002-20230531   gcc  
sh                               allmodconfig   gcc  
sparc                               defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
