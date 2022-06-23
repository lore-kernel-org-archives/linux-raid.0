Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2342C43334
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 08:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiFWIA2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 04:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiFWIA1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 04:00:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E7347395
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 01:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655971226; x=1687507226;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=d+4jRdN0KNoClg6QfIWq8GL24Zsj0b7ZeW9wn5xmmOM=;
  b=Yl2F7uBdI8OTwpbBABJQz/6SN75FM0TIlYIuwts+jijAuyZPwBjS583f
   R7qHuJnrkN/BnLKJDssSAn8VsxKBM2oiwDzgM6r9wCyuvW6u1D5SS7V+m
   rVJEfc7Rwm5ypAEToOoUq7R6fDF+J3QdwdBMty7BCdQL3kgbWucS2YOM2
   nLYbOnzggNJeiS7c+gxeZUXyS4QPAp2d00kuECRMUOZ7eciLD43RjbJKc
   aP/URzRKgMsjXEZcxtQso9vsZSfQfQv6RNKkpHFav3OZEhj2LJ7cvJZvj
   dMkiXGN80rJMhZ2NLubA4QwPqDoBOcnttiRaj7OfaKTtZnIykKKDy9/86
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="281384992"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="281384992"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 01:00:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="915087958"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jun 2022 01:00:23 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o4HlH-0000ur-2o;
        Thu, 23 Jun 2022 08:00:23 +0000
Date:   Thu, 23 Jun 2022 16:00:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
Subject: [song-md:md-next 26/28] ld.lld: error: undefined symbol:
 __hexagon_udivdi3
Message-ID: <202206231549.ILjOxl8Z-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
head:   57c19f921f8081c1a9444dc7f3f6b3ea43fe612e
commit: 681fb14a7100b57c43313f04b4110e7438228bfd [26/28] md/raid5: Pivot raid5_make_request()
config: hexagon-randconfig-r041-20220622 (https://download.01.org/0day-ci/archive/20220623/202206231549.ILjOxl8Z-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 46be5faaf03466c3751f8a2882bef5a217e15926)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=681fb14a7100b57c43313f04b4110e7438228bfd
        git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
        git fetch --no-tags song-md md-next
        git checkout 681fb14a7100b57c43313f04b4110e7438228bfd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __hexagon_udivdi3
   >>> referenced by raid5.c
   >>>               md/raid5.o:(raid5_make_request) in archive drivers/built-in.a
   >>> referenced by raid5.c
   >>>               md/raid5.o:(raid5_make_request) in archive drivers/built-in.a
   >>> did you mean: __hexagon_udivsi3
   >>> defined in: arch/hexagon/built-in.a(lib/udivsi3.o)

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
