Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A9DC54EE9
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 19:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiIVTml (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 15:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiIVTmj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 15:42:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F7D10B5A0
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 12:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663875759; x=1695411759;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=wba5orC0xrPlr3Ck6kheNyaMLU2YWOlf0ZehB2drUBI=;
  b=DlMjfqedPQT03Bfvg9hXxQXARVaE3UV1Fm1KrGSzXRzRias0dM1gsJfR
   XDMDX1iHNJWAgcwMY5ojsfonnBFSDBICjQktHgSKVivQP7CHBnGWI0f9+
   Y0fuGHM3DREynNr+ri9LXyzncOXOxbGy1l5CulVg2sCm1mUvbHZkeTUDR
   e5ZaZFEVJ6rt2ZTO+hwzajyQ+iVbN3xdia/bagPipTIZuDsHu1EXHTsBu
   xxnHAWIIxmWY32po7M7B01emEkrWiq+0rEGNg8VBMiKiKo5LD5/0I7NW4
   Zp/5dkuKT39Qgq5Q8wxlg38KYKSNrQaRy6WoHhA+YfGQ+tJ1qWkQK09jq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="298011610"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="298011610"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 12:42:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="688449255"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 22 Sep 2022 12:42:37 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1obS5l-0004uD-19;
        Thu, 22 Sep 2022 19:42:37 +0000
Date:   Fri, 23 Sep 2022 03:42:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 65b94b527dfcb700b84d043c5bdf2924663724e7
Message-ID: <632cba90.UEv0qMeDdUAjcmXE%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 65b94b527dfcb700b84d043c5bdf2924663724e7  md: Fix spelling mistake in comments of r5l_log

elapsed time: 726m

configs tested: 62
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
m68k                             allyesconfig
arm                                 defconfig
i386                                defconfig
um                             i386_defconfig
um                           x86_64_defconfig
arc                                 defconfig
arc                  randconfig-r043-20220921
riscv                randconfig-r042-20220921
alpha                               defconfig
s390                 randconfig-r044-20220921
i386                          randconfig-a001
i386                          randconfig-a003
arm                              allyesconfig
x86_64                              defconfig
arm64                            allyesconfig
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                    rhel-8.3-kselftests
s390                             allmodconfig
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
s390                                defconfig
x86_64                        randconfig-a011
x86_64                           rhel-8.3-kvm
i386                          randconfig-a014
x86_64                        randconfig-a004
x86_64                               rhel-8.3
s390                             allyesconfig
x86_64                        randconfig-a015
i386                             allyesconfig
x86_64                        randconfig-a002
x86_64                           rhel-8.3-syz
powerpc                           allnoconfig
powerpc                          allmodconfig
sh                               allmodconfig
mips                             allyesconfig
x86_64                           allyesconfig
alpha                            allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
ia64                             allmodconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig

clang tested configs:
hexagon              randconfig-r041-20220921
hexagon              randconfig-r045-20220921
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
i386                          randconfig-a013
x86_64                        randconfig-a016
x86_64                        randconfig-a012
i386                          randconfig-a011
x86_64                        randconfig-a005
hexagon              randconfig-r041-20220922
hexagon              randconfig-r045-20220922
riscv                randconfig-r042-20220922
s390                 randconfig-r044-20220922
x86_64                        randconfig-a003
x86_64                        randconfig-a001
i386                          randconfig-a015

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
