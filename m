Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A59C6FD1D
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 10:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCNKQk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 06:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjCNKQY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 06:16:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E539F66D26
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 03:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678788939; x=1710324939;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=g60jSxQll0A7P8/+8Y/Ke216w5oCZw8ZaRepH1DIdjQ=;
  b=IhbDArVQ/DWzFFZeZYoJl/H3R47nuvtO7w2pK3ZLXzHgSvq3hE/cmBRO
   3lq+se3AP916dptvmBwtuyZJM8OI8gmgdX9cZ9VaE3eMrbdl0i/oNSYH0
   UARy13YDbUqEH/wgWdS7/2vlqJ/KvBttHkZJNqoQOCI/h7P69xa+KqPh7
   RvgYYBgSoiTiIwxXwiAe+nCe6vPwaP8ft7Z6xia1JyDqOI1Fy0ETY02HE
   On6/1dMUe8nrXNCaPmI2HKbC5rJcJIEDXqTlcyB2a8tV7/OYET299P5My
   wtDX+sxGZ1rj6H7RerrJ3t7BxWbwM1/wqSYZz153RiJ2r3oD9Z/Q7JJeP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="317771659"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="317771659"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 03:15:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="853121752"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="853121752"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2023 03:15:30 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pc1gn-0006oa-2B;
        Tue, 14 Mar 2023 10:15:29 +0000
Date:   Tue, 14 Mar 2023 18:14:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: [song-md:md-next 15/18] drivers/md/md-cluster.c:425:63: error:
 'mddev' undeclared
Message-ID: <202303141841.7hUZnSGb-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
head:   ec7246c9455e83f452055cec9c39bd54e72217a4
commit: 48b34bba06372e5f6645716b57394db28fa7260c [15/18] md: refactor md_wakeup_thread()
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230314/202303141841.7hUZnSGb-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=48b34bba06372e5f6645716b57394db28fa7260c
        git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
        git fetch --no-tags song-md md-next
        git checkout 48b34bba06372e5f6645716b57394db28fa7260c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303141841.7hUZnSGb-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/md-cluster.c: In function 'ack_bast':
>> drivers/md/md-cluster.c:425:63: error: 'mddev' undeclared (first use in this function)
     425 |                         md_wakeup_thread(&cinfo->recv_thread, mddev);
         |                                                               ^~~~~
   drivers/md/md-cluster.c:425:63: note: each undeclared identifier is reported only once for each function it appears in


vim +/mddev +425 drivers/md/md-cluster.c

   412	
   413	/*
   414	 * The BAST function for the ack lock resource
   415	 * This function wakes up the receive thread in
   416	 * order to receive and process the message.
   417	 */
   418	static void ack_bast(void *arg, int mode)
   419	{
   420		struct dlm_lock_resource *res = arg;
   421		struct md_cluster_info *cinfo = res->mddev->cluster_info;
   422	
   423		if (mode == DLM_LOCK_EX) {
   424			if (test_bit(MD_CLUSTER_ALREADY_IN_CLUSTER, &cinfo->state))
 > 425				md_wakeup_thread(&cinfo->recv_thread, mddev);
   426			else
   427				set_bit(MD_CLUSTER_PENDING_RECV_EVENT, &cinfo->state);
   428		}
   429	}
   430	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
