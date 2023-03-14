Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8165C74A44
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 09:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCNJN5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 05:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjCNJNm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 05:13:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB30A9
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 02:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678785219; x=1710321219;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=tLDxJMWw0FrWo/F+ZXIkpLxyaiQiBWIN3iYIqfBOqiU=;
  b=l+FMafizgv5HYJPCncdOmfFsYhu1WOzy3f1bNI+lUWv3LBR4FOyVys+5
   ZV0dg11mBbzOCgdm3Q1+mVRme5ICk4ilTLWaN1+RCfFQx8AbTuo2Pt/Cm
   wv86hrdLUmoIAZfRbFTagRpz6NEKHXw2AaFW0FA4qI9RJ6HRR1h2NJSqU
   eydwPRUg7lp3KXo117Oi1di6lWdPApGp7akbceAQ7gh793YOdz6wFieza
   egdUR78Mvl/1h2DlDku/N7D1Uz7qSHj+zxXfSNPMamR3PiSXTfp6Y6ees
   6V/TQBtUTr9u+R5Q9GQVVS1UJCZW8UdC42dwNbEU477qi1yt4iz3xyySm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337397885"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="337397885"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 02:13:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="789281024"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="789281024"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 14 Mar 2023 02:13:28 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pc0il-0006lF-1v;
        Tue, 14 Mar 2023 09:13:27 +0000
Date:   Tue, 14 Mar 2023 17:13:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
Subject: [song-md:md-next 15/18] drivers/md/md-cluster.c:425:42: error: use
 of undeclared identifier 'mddev'; did you mean 'mode'?
Message-ID: <202303141758.4EtLtIA1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
head:   ec7246c9455e83f452055cec9c39bd54e72217a4
commit: 48b34bba06372e5f6645716b57394db28fa7260c [15/18] md: refactor md_wakeup_thread()
config: s390-randconfig-r032-20230312 (https://download.01.org/0day-ci/archive/20230314/202303141758.4EtLtIA1-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=48b34bba06372e5f6645716b57394db28fa7260c
        git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
        git fetch --no-tags song-md md-next
        git checkout 48b34bba06372e5f6645716b57394db28fa7260c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/md/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303141758.4EtLtIA1-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/md-cluster.c:425:42: error: use of undeclared identifier 'mddev'; did you mean 'mode'?
                           md_wakeup_thread(&cinfo->recv_thread, mddev);
                                                                 ^~~~~
                                                                 mode
   drivers/md/md-cluster.c:418:37: note: 'mode' declared here
   static void ack_bast(void *arg, int mode)
                                       ^
   1 error generated.


vim +425 drivers/md/md-cluster.c

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
