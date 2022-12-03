Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8047C4708D
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 08:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiLCIW5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 03:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLCIWu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 03:22:50 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAA8C75A
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 00:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670055767; x=1701591767;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=uhHGccNwZldgRAAY7oe5yz/guOVdt0D7sY7uzwMFSa8=;
  b=AEKGeM2y8ic0SN2pq58yQYI7mWG5LyR4t59xWlJPkbOBGclUBbuUOfcV
   BrIxQ0mw2148l+rklvKXoNMQL9PFNIVdxOs9lblgSG3Ds9ok9Wvvx6jr9
   R1eCb3gWOv53Csf0OcVNYa3F9q4Ewcp4H6DflARt352VThyhKqsTFg85c
   G1Hwn+Qq773NUNqZ3WEdLbEkKZTDiK7mDwlV6aW2jgONllSzBubcnlTo8
   QtEW2f9aGUoCvdxGO8F5DMwQc8lJ+8c6srS9Rk18oD86CLcWHyioqU/Wd
   0EQ9gZGOmX5ME1EMaqVVxnJsb1O1mB9xYN7qWu/DklmhbuRwAdDnMcV89
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="380397372"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="380397372"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2022 00:22:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="676082548"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="676082548"
Received: from lkp-server01.sh.intel.com (HELO 64a2d449c951) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 03 Dec 2022 00:22:44 -0800
Received: from kbuild by 64a2d449c951 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p1NnH-000EPF-1o;
        Sat, 03 Dec 2022 08:22:43 +0000
Date:   Sat, 03 Dec 2022 16:22:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 b5c1acf012a7a73e3d0c5c3605ececcca6797267
Message-ID: <638b0741.RbGWrRgGwa/tIXdc%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: b5c1acf012a7a73e3d0c5c3605ececcca6797267  md: fold unbind_rdev_from_array into md_kick_rdev_from_array

elapsed time: 721m

configs tested: 58
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                        randconfig-a011
x86_64                        randconfig-a015
x86_64                        randconfig-a013
x86_64                              defconfig
x86_64                        randconfig-a002
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                               rhel-8.3
arc                  randconfig-r043-20221201
x86_64                           allyesconfig
riscv                randconfig-r042-20221201
s390                 randconfig-r044-20221201
i386                                defconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
i386                             allyesconfig
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
powerpc                           allnoconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
sh                               allmodconfig
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
mips                             allyesconfig
s390                                defconfig
powerpc                          allmodconfig
arm                                 defconfig
ia64                             allmodconfig
s390                             allyesconfig
m68k                             allyesconfig
arm64                            allyesconfig
alpha                            allyesconfig
m68k                             allmodconfig
arm                              allyesconfig
arc                              allyesconfig

clang tested configs:
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
hexagon              randconfig-r045-20221201
hexagon              randconfig-r041-20221201
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a013
i386                          randconfig-a006
i386                          randconfig-a011
i386                          randconfig-a015

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
