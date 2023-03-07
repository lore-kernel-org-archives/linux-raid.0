Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB45BC6FD1E
	for <linux-raid@archiver.kernel.org>; Tue,  7 Mar 2023 20:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjCGUXj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Mar 2023 15:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCGUX2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Mar 2023 15:23:28 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9E4A6146
        for <linux-raid@vger.kernel.org>; Tue,  7 Mar 2023 12:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678220600; x=1709756600;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qI8CoqW2efVzO0YiakN72LxognMrZNMeakLCvojG/mU=;
  b=Ys1Sy4KZky+QPsps+rTdZE+rfvOMIkxYbEzq+Jlr1rRWNa/x6Bgfs7XG
   6jNMQs8+C0Ieo5u7HlFSR+Rw3Dwg33InUnSS7Uk6SVMSlykISslz2xBs5
   eNMsqGMHe+E3Vn8fdQuFnhJh25xLvHCVKJ+UNxpKtWapmocZvtYJkWB8L
   UA4F7e7GS7KTCwn0YvOWptbeMz+mw26vlOsao3CBrEAB+Fo+w53HGXRQE
   oJPMlwO/qllXAUGCJ/X/L9GGO8bSibKNh61WlSJ5Th+rxYQKObi3AqWfk
   sv2BQ9PC9C2M++sHyqeqGvFlVjVDIul11qz24dBpkoO7Z+uypJRZ4k02Z
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338286553"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="338286553"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 12:23:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="679088125"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="679088125"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 07 Mar 2023 12:23:18 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pZdq9-0001Zb-1P;
        Tue, 07 Mar 2023 20:23:17 +0000
Date:   Wed, 8 Mar 2023 04:23:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     heinzm@redhat.com, linux-raid@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: Re: [PATCH 06/34] md: move trailing statements to next line [ERROR]
Message-ID: <202303080447.5GUM9IKU-lkp@intel.com>
References: <12a6970ce1bf7489aa67a3c6d70438a48b8f8987.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12a6970ce1bf7489aa67a3c6d70438a48b8f8987.1678136717.git.heinzm@redhat.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on song-md/md-next]
[also build test ERROR on linus/master v6.3-rc1 next-20230307]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/heinzm-redhat-com/md-fix-required-prohibited-spaces-ERROR/20230307-053327
base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
patch link:    https://lore.kernel.org/r/12a6970ce1bf7489aa67a3c6d70438a48b8f8987.1678136717.git.heinzm%40redhat.com
patch subject: [PATCH 06/34] md: move trailing statements to next line [ERROR]
config: i386-randconfig-a011-20230306 (https://download.01.org/0day-ci/archive/20230308/202303080447.5GUM9IKU-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0ad2607399ded916c63c96e5e3ac18f74e8a74d2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review heinzm-redhat-com/md-fix-required-prohibited-spaces-ERROR/20230307-053327
        git checkout 0ad2607399ded916c63c96e5e3ac18f74e8a74d2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303080447.5GUM9IKU-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/md.c:7533:10: error: label at end of compound statement: expected statement
           default:
                   ^
                    ;
   1 error generated.


vim +7533 drivers/md/md.c

  7503	
  7504	static int md_ioctl(struct block_device *bdev, fmode_t mode,
  7505				unsigned int cmd, unsigned long arg)
  7506	{
  7507		int err = 0;
  7508		void __user *argp = (void __user *)arg;
  7509		struct mddev *mddev = NULL;
  7510		bool did_set_md_closing = false;
  7511	
  7512		if (!md_ioctl_valid(cmd))
  7513			return -ENOTTY;
  7514	
  7515		switch (cmd) {
  7516		case RAID_VERSION:
  7517		case GET_ARRAY_INFO:
  7518		case GET_DISK_INFO:
  7519			break;
  7520		default:
  7521			if (!capable(CAP_SYS_ADMIN))
  7522				return -EACCES;
  7523		}
  7524	
  7525		/*
  7526		 * Commands dealing with the RAID driver but not any
  7527		 * particular array:
  7528		 */
  7529		switch (cmd) {
  7530		case RAID_VERSION:
  7531			err = get_version(argp);
  7532			goto out;
> 7533		default:
  7534		}
  7535	
  7536		/*
  7537		 * Commands creating/starting a new array:
  7538		 */
  7539	
  7540		mddev = bdev->bd_disk->private_data;
  7541	
  7542		if (!mddev) {
  7543			BUG();
  7544			goto out;
  7545		}
  7546	
  7547		/* Some actions do not requires the mutex */
  7548		switch (cmd) {
  7549		case GET_ARRAY_INFO:
  7550			if (!mddev->raid_disks && !mddev->external)
  7551				err = -ENODEV;
  7552			else
  7553				err = get_array_info(mddev, argp);
  7554			goto out;
  7555	
  7556		case GET_DISK_INFO:
  7557			if (!mddev->raid_disks && !mddev->external)
  7558				err = -ENODEV;
  7559			else
  7560				err = get_disk_info(mddev, argp);
  7561			goto out;
  7562	
  7563		case SET_DISK_FAULTY:
  7564			err = set_disk_faulty(mddev, new_decode_dev(arg));
  7565			goto out;
  7566	
  7567		case GET_BITMAP_FILE:
  7568			err = get_bitmap_file(mddev, argp);
  7569			goto out;
  7570	
  7571		}
  7572	
  7573		if (cmd == ADD_NEW_DISK || cmd == HOT_ADD_DISK)
  7574			flush_rdev_wq(mddev);
  7575	
  7576		if (cmd == HOT_REMOVE_DISK)
  7577			/* need to ensure recovery thread has run */
  7578			wait_event_interruptible_timeout(mddev->sb_wait,
  7579							 !test_bit(MD_RECOVERY_NEEDED,
  7580								   &mddev->recovery),
  7581							 msecs_to_jiffies(5000));
  7582		if (cmd == STOP_ARRAY || cmd == STOP_ARRAY_RO) {
  7583			/* Need to flush page cache, and ensure no-one else opens
  7584			 * and writes
  7585			 */
  7586			mutex_lock(&mddev->open_mutex);
  7587			if (mddev->pers && atomic_read(&mddev->openers) > 1) {
  7588				mutex_unlock(&mddev->open_mutex);
  7589				err = -EBUSY;
  7590				goto out;
  7591			}
  7592			if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
  7593				mutex_unlock(&mddev->open_mutex);
  7594				err = -EBUSY;
  7595				goto out;
  7596			}
  7597			did_set_md_closing = true;
  7598			mutex_unlock(&mddev->open_mutex);
  7599			sync_blockdev(bdev);
  7600		}
  7601		err = mddev_lock(mddev);
  7602		if (err) {
  7603			pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
  7604				 err, cmd);
  7605			goto out;
  7606		}
  7607	
  7608		if (cmd == SET_ARRAY_INFO) {
  7609			err = __md_set_array_info(mddev, argp);
  7610			goto unlock;
  7611		}
  7612	
  7613		/*
  7614		 * Commands querying/configuring an existing array:
  7615		 */
  7616		/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
  7617		 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
  7618		if ((!mddev->raid_disks && !mddev->external)
  7619		    && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
  7620		    && cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
  7621		    && cmd != GET_BITMAP_FILE) {
  7622			err = -ENODEV;
  7623			goto unlock;
  7624		}
  7625	
  7626		/*
  7627		 * Commands even a read-only array can execute:
  7628		 */
  7629		switch (cmd) {
  7630		case RESTART_ARRAY_RW:
  7631			err = restart_array(mddev);
  7632			goto unlock;
  7633	
  7634		case STOP_ARRAY:
  7635			err = do_md_stop(mddev, 0, bdev);
  7636			goto unlock;
  7637	
  7638		case STOP_ARRAY_RO:
  7639			err = md_set_readonly(mddev, bdev);
  7640			goto unlock;
  7641	
  7642		case HOT_REMOVE_DISK:
  7643			err = hot_remove_disk(mddev, new_decode_dev(arg));
  7644			goto unlock;
  7645	
  7646		case ADD_NEW_DISK:
  7647			/* We can support ADD_NEW_DISK on read-only arrays
  7648			 * only if we are re-adding a preexisting device.
  7649			 * So require mddev->pers and MD_DISK_SYNC.
  7650			 */
  7651			if (mddev->pers) {
  7652				mdu_disk_info_t info;
  7653				if (copy_from_user(&info, argp, sizeof(info)))
  7654					err = -EFAULT;
  7655				else if (!(info.state & (1<<MD_DISK_SYNC)))
  7656					/* Need to clear read-only for this */
  7657					break;
  7658				else
  7659					err = md_add_new_disk(mddev, &info);
  7660				goto unlock;
  7661			}
  7662			break;
  7663		}
  7664	
  7665		/*
  7666		 * The remaining ioctls are changing the state of the
  7667		 * superblock, so we do not allow them on read-only arrays.
  7668		 */
  7669		if (!md_is_rdwr(mddev) && mddev->pers) {
  7670			if (mddev->ro != MD_AUTO_READ) {
  7671				err = -EROFS;
  7672				goto unlock;
  7673			}
  7674			mddev->ro = MD_RDWR;
  7675			sysfs_notify_dirent_safe(mddev->sysfs_state);
  7676			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
  7677			/* mddev_unlock will wake thread */
  7678			/* If a device failed while we were read-only, we
  7679			 * need to make sure the metadata is updated now.
  7680			 */
  7681			if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
  7682				mddev_unlock(mddev);
  7683				wait_event(mddev->sb_wait,
  7684					   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
  7685					   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
  7686				mddev_lock_nointr(mddev);
  7687			}
  7688		}
  7689	
  7690		switch (cmd) {
  7691		case ADD_NEW_DISK:
  7692		{
  7693			mdu_disk_info_t info;
  7694			if (copy_from_user(&info, argp, sizeof(info)))
  7695				err = -EFAULT;
  7696			else
  7697				err = md_add_new_disk(mddev, &info);
  7698			goto unlock;
  7699		}
  7700	
  7701		case CLUSTERED_DISK_NACK:
  7702			if (mddev_is_clustered(mddev))
  7703				md_cluster_ops->new_disk_ack(mddev, false);
  7704			else
  7705				err = -EINVAL;
  7706			goto unlock;
  7707	
  7708		case HOT_ADD_DISK:
  7709			err = hot_add_disk(mddev, new_decode_dev(arg));
  7710			goto unlock;
  7711	
  7712		case RUN_ARRAY:
  7713			err = do_md_run(mddev);
  7714			goto unlock;
  7715	
  7716		case SET_BITMAP_FILE:
  7717			err = set_bitmap_file(mddev, (int)arg);
  7718			goto unlock;
  7719	
  7720		default:
  7721			err = -EINVAL;
  7722			goto unlock;
  7723		}
  7724	
  7725	unlock:
  7726		if (mddev->hold_active == UNTIL_IOCTL &&
  7727		    err != -EINVAL)
  7728			mddev->hold_active = 0;
  7729		mddev_unlock(mddev);
  7730	out:
  7731		if (did_set_md_closing)
  7732			clear_bit(MD_CLOSING, &mddev->flags);
  7733		return err;
  7734	}
  7735	#ifdef CONFIG_COMPAT
  7736	static int md_compat_ioctl(struct block_device *bdev, fmode_t mode,
  7737			    unsigned int cmd, unsigned long arg)
  7738	{
  7739		switch (cmd) {
  7740		case HOT_REMOVE_DISK:
  7741		case HOT_ADD_DISK:
  7742		case SET_DISK_FAULTY:
  7743		case SET_BITMAP_FILE:
  7744			/* These take in integer arg, do not convert */
  7745			break;
  7746		default:
  7747			arg = (unsigned long)compat_ptr(arg);
  7748			break;
  7749		}
  7750	
  7751		return md_ioctl(bdev, mode, cmd, arg);
  7752	}
  7753	#endif /* CONFIG_COMPAT */
  7754	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
