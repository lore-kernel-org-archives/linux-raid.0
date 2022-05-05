Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0892C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  5 May 2022 18:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382754AbiEESIn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 May 2022 14:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243825AbiEESIm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 May 2022 14:08:42 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D385373C
        for <linux-raid@vger.kernel.org>; Thu,  5 May 2022 11:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651773902; x=1683309902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xJVaziiJiO/giX8r3WzYf4FZE6x1ucwWfymWctZyaUg=;
  b=OY4DXedzdk14yiquYMYExCG0RG++HekbwiSvVXFEUIQtXQ1GlqEACwva
   mK3St78ZFcNePSjrcxlDhWeym6INQPDKy+ixYHXVU9NO0yXkHw7GaFAlf
   YitYZ112suPWmmeqoLqK38myU0E3+ibvEJNkhNUEtaO+jRmHjENMOn+hh
   oqxccYT0pbcRffZPPK1sK16VhskiqgqwJhNuBuugV203N5SHS0XskoZ5H
   X3auN+29bHrtD9LM3Db3BczmrS1qEwcRE73DMI0xBmt4G18jCoDdOL+8E
   9WtA25ZZnV7EewscyjFZ9x0t5PdDyKivFQS/lMY9JCmm4ZesBQNFTudw1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268093391"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="268093391"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:05:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="585473235"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 05 May 2022 11:04:59 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmfqU-000Ce0-V5;
        Thu, 05 May 2022 18:04:59 +0000
Date:   Fri, 6 May 2022 02:04:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        buczek@molgen.mpg.de, linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH V3 1/2] md: don't unregister sync_thread with
 reconfig_mutex held
Message-ID: <202205060116.J42KgtCW-lkp@intel.com>
References: <20220505081641.21500-2-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505081641.21500-2-guoqing.jiang@linux.dev>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Guoqing,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on song-md/md-next]
[also build test WARNING on v5.18-rc5 next-20220505]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Guoqing-Jiang/two-fixes-for-md/20220505-162202
base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
config: hexagon-randconfig-r045-20220505 (https://download.01.org/0day-ci/archive/20220506/202205060116.J42KgtCW-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e004fb787698440a387750db7f8028e7cb14cfc)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e8e9c97eb79c337a89a98a92106cfa6139a7c9e0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guoqing-Jiang/two-fixes-for-md/20220505-162202
        git checkout e8e9c97eb79c337a89a98a92106cfa6139a7c9e0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/md/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/md/md.c:9448:3: warning: ignoring return value of function declared with 'warn_unused_result' attribute [-Wunused-result]
                   mddev_lock(mddev);
                   ^~~~~~~~~~ ~~~~~
   1 warning generated.


vim +/warn_unused_result +9448 drivers/md/md.c

  9434	
  9435	void md_reap_sync_thread(struct mddev *mddev)
  9436	{
  9437		struct md_rdev *rdev;
  9438		sector_t old_dev_sectors = mddev->dev_sectors;
  9439		bool is_reshaped = false, is_locked = false;
  9440	
  9441		if (mddev_is_locked(mddev)) {
  9442			is_locked = true;
  9443			mddev_unlock(mddev);
  9444		}
  9445		/* resync has finished, collect result */
  9446		md_unregister_thread(&mddev->sync_thread);
  9447		if (is_locked)
> 9448			mddev_lock(mddev);
  9449	
  9450		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
  9451		    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
  9452		    mddev->degraded != mddev->raid_disks) {
  9453			/* success...*/
  9454			/* activate any spares */
  9455			if (mddev->pers->spare_active(mddev)) {
  9456				sysfs_notify_dirent_safe(mddev->sysfs_degraded);
  9457				set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
  9458			}
  9459		}
  9460		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
  9461		    mddev->pers->finish_reshape) {
  9462			mddev->pers->finish_reshape(mddev);
  9463			if (mddev_is_clustered(mddev))
  9464				is_reshaped = true;
  9465		}
  9466	
  9467		/* If array is no-longer degraded, then any saved_raid_disk
  9468		 * information must be scrapped.
  9469		 */
  9470		if (!mddev->degraded)
  9471			rdev_for_each(rdev, mddev)
  9472				rdev->saved_raid_disk = -1;
  9473	
  9474		md_update_sb(mddev, 1);
  9475		/* MD_SB_CHANGE_PENDING should be cleared by md_update_sb, so we can
  9476		 * call resync_finish here if MD_CLUSTER_RESYNC_LOCKED is set by
  9477		 * clustered raid */
  9478		if (test_and_clear_bit(MD_CLUSTER_RESYNC_LOCKED, &mddev->flags))
  9479			md_cluster_ops->resync_finish(mddev);
  9480		clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
  9481		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
  9482		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
  9483		clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
  9484		clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
  9485		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
  9486		/*
  9487		 * We call md_cluster_ops->update_size here because sync_size could
  9488		 * be changed by md_update_sb, and MD_RECOVERY_RESHAPE is cleared,
  9489		 * so it is time to update size across cluster.
  9490		 */
  9491		if (mddev_is_clustered(mddev) && is_reshaped
  9492					      && !test_bit(MD_CLOSING, &mddev->flags))
  9493			md_cluster_ops->update_size(mddev, old_dev_sectors);
  9494		wake_up(&resync_wait);
  9495		/* flag recovery needed just to double check */
  9496		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
  9497		sysfs_notify_dirent_safe(mddev->sysfs_action);
  9498		md_new_event();
  9499		if (mddev->event_work.func)
  9500			queue_work(md_misc_wq, &mddev->event_work);
  9501	}
  9502	EXPORT_SYMBOL(md_reap_sync_thread);
  9503	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
