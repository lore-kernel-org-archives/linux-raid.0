Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CFBC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 09:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiFWJCf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 05:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiFWJCd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 05:02:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1183546CB1
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 02:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655974950; x=1687510950;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=IadRANFap85jIARCP9dcsvnk+8y2Y7z1GybpfCLJjwo=;
  b=jfWkI6cksiBvfj9VK30pLkhIZhV44Tpr/i3eLQLPd4X2zfBtGH6cRnbc
   /0GmP88bsOYWlPWq5R27Ag7xdW3dvBnyXkhmAA/Eq6o/+urhQt2T+PF7b
   htV0Koo3YsVI8YOJVr0slsAcjMwCv5ZKcm6EC0rw/307gYTpCAqCdnyJC
   q5Vot9Ybojx/qYpOlau0NwtPDKjuSW9dht/wxksu3OJthubTdtqUUat4C
   1HcUKXIG5txyIoU6fIa1h3iwZCKLV6CFrdj8Dz6PMrELikwTucXF91idD
   MpvG0jdHnVfMdemDLEf6SobPVj8JGgKvn2rrWgdnANzBNS6ukd99GICEJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="278215957"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="278215957"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 02:02:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="715752384"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 23 Jun 2022 02:02:27 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o4IjK-0000zn-Qf;
        Thu, 23 Jun 2022 09:02:26 +0000
Date:   Thu, 23 Jun 2022 17:01:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
Subject: [song-md:md-next 26/28] ERROR: modpost: "__hexagon_udivdi3"
 [drivers/md/raid456.ko] undefined!
Message-ID: <202206231700.QHLMIY3O-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
head:   57c19f921f8081c1a9444dc7f3f6b3ea43fe612e
commit: 681fb14a7100b57c43313f04b4110e7438228bfd [26/28] md/raid5: Pivot raid5_make_request()
config: hexagon-randconfig-r045-20220623 (https://download.01.org/0day-ci/archive/20220623/202206231700.QHLMIY3O-lkp@intel.com/config)
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

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__hexagon_udivdi3" [drivers/md/raid456.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
