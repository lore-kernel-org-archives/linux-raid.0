Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297E6145335
	for <linux-raid@vger.kernel.org>; Thu,  8 Aug 2024 09:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723109622; cv=none; b=b0zc7NQVVBqLhKwsvZhyeHYGvZft+/F/j23Pl11WbiKeHlWEyHp/e0sOI6Se4j3rOAP6KyjoKICwytkCyQyJpP0xyzOo8/ZH5k6Ia2UJWJlsW4jIuaH1mDhRMr/8ke4rrTlp1Oh2rpP7X5+aKRrvu3cKP2tvG2vgff7OWVW4VYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723109622; c=relaxed/simple;
	bh=2ffDPkohLBrFJsDC+9hEHC2nBDrBVRrFrqH4PgMspoY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l86K1dYlz0alnlQ3Z7YQD9Fr7TI9Yg4URmqJzC1cx2i4ipU4Kn0rrLgAdjmYSvfvluLMafk15ledr6utexJ+r0tkICJVAtnHbqDA8YUnPf0TNO07RhUgg4n1vE1JNClMGlvqU7D8mxhCqHvPSl0+KuxT8AG7kYDe+81is8cMxtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8yjw33c; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8yjw33c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723109620; x=1754645620;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2ffDPkohLBrFJsDC+9hEHC2nBDrBVRrFrqH4PgMspoY=;
  b=f8yjw33cxlP1mrAqsYB7TUSydnAYuMrwOJxYTO73WwsopkufHs4MWEn1
   Iga/80Mgh7fvnsA7B6YKaz9m9VQqevieOeA1tyb5SUsAuimJcSt+9x/Hm
   Q6veXF/VzZiVEwLf4OYNmqtwwa3kIBoBS5x9bRFYYCfo+2UlGld6fOXab
   HZH1Mq018g3omF2jzOnF7ZLiwDBuyX1YuHziS9nh0A/eS+kV0KaD/DcWv
   26XncDzBSiBiDsJutQaBTbrKjXUxnpogpe+7eJkJvr+5JvpCRxyrWxUf6
   o6M6jzzPovqXW0tTTdPXZxQ4pe65wRAbI23ieRc+QIjb0vx5PvUK30oeK
   w==;
X-CSE-ConnectionGUID: Z38bVZLFSaGFbquu6GR6Sw==
X-CSE-MsgGUID: IJ+s3fsDQheD0RlUwso2CQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="21391893"
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="21391893"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 02:33:39 -0700
X-CSE-ConnectionGUID: rNNMxl6fQE6M3b6YwCCB2A==
X-CSE-MsgGUID: 9Kn2zz7UTpmV6X1T12ATNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="87810919"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.245.167.161])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 02:33:37 -0700
Date: Thu, 8 Aug 2024 11:33:33 +0200
From: Kinga Stefaniuk <kinga.stefaniuk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org,
 song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v8 1/1] md: generate CHANGE uevents for md device
Message-ID: <20240808113333.00004fd4@intel.linux.com>
In-Reply-To: <cbc38c9c-e0bd-29d7-ba71-5596f089e999@huaweicloud.com>
References: <20240722131340.29880-1-kinga.stefaniuk@intel.com>
	<20240722131340.29880-2-kinga.stefaniuk@intel.com>
	<cbc38c9c-e0bd-29d7-ba71-5596f089e999@huaweicloud.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit

On Fri, 26 Jul 2024 11:57:03 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
> 
> ÔÚ 2024/07/22 21:13, Kinga Stefaniuk Ð´µÀ:
> > In mdadm commit 49b69533e8 ("mdmonitor: check if udev has finished
> > events processing") mdmonitor has been learnt to wait for udev to
> > finish processing, and later in commit 9935cf0f64f3 ("Mdmonitor:
> > Improve udev event handling") pooling for MD events on /proc/mdstat
> > file has been deprecated because relying on udev events is more
> > reliable and less bug prone (we are not competing with udev).
> > 
> > After those changes we are still observing missing mdmonitor events
> > in some scenarios, especially SpareEvent is likely to be missed.
> > With this patch MD will be able to generate more change uevents and
> > wakeup mdmonitor more frequently to give it possibility to notice
> > events. MD has md_new_events() functionality to trigger events and
> > with this patch this function is extended to generate udev CHANGE
> > uevents. It cannot be done directly because this function is called
> > on interrupts context, so appropriate workqueue is created. Uevents
> > are less time critical, it is safe to use workqueue. It is limited
> > to CHANGE event as there is no need to generate other uevents for
> > now. With this change, mdmonitor events are less likely to be
> > missed. Our internal tests suite confirms that, mdmonitor
> > reliability is (again) improved.
> > 
> > Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> > Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> > 
> > ---
> > v8: fix possible conflict with del_work by adding spin_lock,
> >      change default sync value to true, now false only on md_error
> > v7: add new work struct for these events, use md_misc_wq workqueue,
> >      fix work cancellation
> > v6: use another workqueue and only on md_error, make configurable
> >      if kobject_uevent is run immediately on event or queued
> > v5: fix flush_work missing and commit message fixes
> > v4: add more detailed commit message
> > v3: fix problems with calling function from interrupt context,
> >      add work_queue and queue events notification
> > v2: resolve merge conflicts with applying the patch
> > 
> > Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> > ---
> >   drivers/md/md.c     | 73
> > +++++++++++++++++++++++++++++++-------------- drivers/md/md.h     |
> >  3 +- drivers/md/raid10.c |  2 +-
> >   drivers/md/raid5.c  |  2 +-
> >   4 files changed, 55 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 64693913ed18..d49031aba0d5 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -107,6 +107,7 @@ static int remove_and_add_spares(struct mddev
> > *mddev, static void mddev_detach(struct mddev *mddev);
> >   static void export_rdev(struct md_rdev *rdev, struct mddev
> > *mddev); static void md_wakeup_thread_directly(struct md_thread
> > __rcu *thread); +static inline struct mddev *mddev_get(struct mddev
> > *mddev); 
> >   /*
> >    * Default number of read corrections we'll attempt on an rdev
> > @@ -323,6 +324,30 @@ static int start_readonly;
> >    */
> >   static bool create_on_open = true;
> >   
> > +/*
> > + * Enables to iterate over all existing md arrays
> > + * all_mddevs_lock protects this list.
> > + */
> > +static LIST_HEAD(all_mddevs);
> > +static DEFINE_SPINLOCK(all_mddevs_lock);
> > +
> > +/*
> > + * Send every new event to the userspace.
> > + */
> > +static void md_kobject_uevent_fn(struct work_struct *work)
> > +{
> > +	struct mddev *mddev = container_of(work, struct mddev,
> > uevent_work); +
> > +	spin_lock(&all_mddevs_lock);
> > +	mddev = mddev_get(mddev);
> > +	spin_unlock(&all_mddevs_lock);
> > +	if (!mddev)
> > +		return;
> > +
> > +	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj,
> > KOBJ_CHANGE);
> > +	mddev_put(mddev);
> > +}
> > +
> >   /*
> >    * We have a system wide 'event count' that is incremented
> >    * on any 'interesting' event, and readers of /proc/mdstat
> > @@ -335,20 +360,21 @@ static bool create_on_open = true;
> >    */
> >   static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
> >   static atomic_t md_event_count;
> > -void md_new_event(void)
> > +
> > +void md_new_event(struct mddev *mddev, bool sync)
> >   {
> >   	atomic_inc(&md_event_count);
> >   	wake_up(&md_event_waiters);
> > +
> > +	if (mddev_is_dm(mddev))
> > +		return;
> > +	if (sync)
> > +		schedule_work(&mddev->uevent_work);  
> 
> Why stop using workqueue md_wq?
> > +	else
> > +		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj,
> > KOBJ_CHANGE);  
> 
> I see you pass in 'false' from md_error, and 'true' otherwise,
> however, this implementation is in reverse.
> 
> >   }
> >   EXPORT_SYMBOL_GPL(md_new_event);
> >   
> > -/*
> > - * Enables to iterate over all existing md arrays
> > - * all_mddevs_lock protects this list.
> > - */
> > -static LIST_HEAD(all_mddevs);
> > -static DEFINE_SPINLOCK(all_mddevs_lock);
> > -
> >   static bool is_md_suspended(struct mddev *mddev)
> >   {
> >   	return percpu_ref_is_dying(&mddev->active_io);
> > @@ -773,6 +799,7 @@ int mddev_init(struct mddev *mddev)
> >   	mddev->resync_max = MaxSector;
> >   	mddev->level = LEVEL_NONE;
> >   
> > +	INIT_WORK(&mddev->uevent_work, md_kobject_uevent_fn);
> >   	INIT_WORK(&mddev->sync_work, md_start_sync);
> >   	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
> >   
> > @@ -2898,7 +2925,7 @@ static int add_bound_rdev(struct md_rdev
> > *rdev) if (mddev->degraded)
> >   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> >   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	return 0;
> >   }
> >   
> > @@ -3015,7 +3042,7 @@ state_store(struct md_rdev *rdev, const char
> > *buf, size_t len) md_kick_rdev_from_array(rdev);
> >   				if (mddev->pers)
> >   					set_bit(MD_SB_CHANGE_DEVS,
> > &mddev->sb_flags);
> > -				md_new_event();
> > +				md_new_event(mddev, true);
> >   			}
> >   		}
> >   	} else if (cmd_match(buf, "writemostly")) {
> > @@ -4131,7 +4158,7 @@ level_store(struct mddev *mddev, const char
> > *buf, size_t len) if (!mddev->thread)
> >   		md_update_sb(mddev, 1);
> >   	sysfs_notify_dirent_safe(mddev->sysfs_level);
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	rv = len;
> >   out_unlock:
> >   	mddev_unlock_and_resume(mddev);
> > @@ -4658,7 +4685,7 @@ new_dev_store(struct mddev *mddev, const char
> > *buf, size_t len) export_rdev(rdev, mddev);
> >   	mddev_unlock_and_resume(mddev);
> >   	if (!err)
> > -		md_new_event();
> > +		md_new_event(mddev, true);
> >   	return err ? err : len;
> >   }
> >   
> > @@ -5850,6 +5877,7 @@ static void mddev_delayed_delete(struct
> > work_struct *ws) {
> >   	struct mddev *mddev = container_of(ws, struct mddev,
> > del_work); 
> > +	cancel_work_sync(&mddev->uevent_work);  
> 
> This is not needed now. The mddev_get/mddev_put will make sure won't
> concurrent with this.
> 
> Thanks,
> Kuai
> >   	kobject_put(&mddev->kobj);
> >   }
> >   
> > @@ -6276,7 +6304,7 @@ int md_run(struct mddev *mddev)
> >   	if (mddev->sb_flags)
> >   		md_update_sb(mddev, 0);
> >   
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	return 0;
> >   
> >   bitmap_abort:
> > @@ -6635,7 +6663,7 @@ static int do_md_stop(struct mddev *mddev,
> > int mode) if (mddev->hold_active == UNTIL_STOP)
> >   			mddev->hold_active = 0;
> >   	}
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> >   	return 0;
> >   }
> > @@ -7131,7 +7159,7 @@ static int hot_remove_disk(struct mddev
> > *mddev, dev_t dev) set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> >   	if (!mddev->thread)
> >   		md_update_sb(mddev, 1);
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   
> >   	return 0;
> >   busy:
> > @@ -7202,7 +7230,7 @@ static int hot_add_disk(struct mddev *mddev,
> > dev_t dev)
> >   	 * array immediately.
> >   	 */
> >   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	return 0;
> >   
> >   abort_export:
> > @@ -8176,7 +8204,8 @@ void md_error(struct mddev *mddev, struct
> > md_rdev *rdev) }
> >   	if (mddev->event_work.func)
> >   		queue_work(md_misc_wq, &mddev->event_work);
> > -	md_new_event();
> > +	if (!test_bit(MD_DELETED, &mddev->flags))
> > +		md_new_event(mddev, false);
> >   }
> >   EXPORT_SYMBOL(md_error);
> >   
> > @@ -9072,7 +9101,7 @@ void md_do_sync(struct md_thread *thread)
> >   		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no
> > longer delayed */ mddev->curr_resync_completed = j;
> >   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	update_time = jiffies;
> >   
> >   	blk_start_plug(&plug);
> > @@ -9144,7 +9173,7 @@ void md_do_sync(struct md_thread *thread)
> >   			/* this is the earliest that rebuild will
> > be
> >   			 * visible in /proc/mdstat
> >   			 */
> > -			md_new_event();
> > +			md_new_event(mddev, true);
> >   
> >   		if (last_check + window > io_sectors || j ==
> > max_sectors) continue;
> > @@ -9410,7 +9439,7 @@ static int remove_and_add_spares(struct mddev
> > *mddev, sysfs_link_rdev(mddev, rdev);
> >   			if (!test_bit(Journal, &rdev->flags))
> >   				spares++;
> > -			md_new_event();
> > +			md_new_event(mddev, true);
> >   			set_bit(MD_SB_CHANGE_DEVS,
> > &mddev->sb_flags); }
> >   	}
> > @@ -9529,7 +9558,7 @@ static void md_start_sync(struct work_struct
> > *ws) __mddev_resume(mddev, false);
> >   	md_wakeup_thread(mddev->sync_thread);
> >   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	return;
> >   
> >   not_running:
> > @@ -9781,7 +9810,7 @@ void md_reap_sync_thread(struct mddev *mddev)
> >   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
> >   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	if (mddev->event_work.func)
> >   		queue_work(md_misc_wq, &mddev->event_work);
> >   	wake_up(&resync_wait);
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index a0d6827dced9..ab340618828c 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -582,6 +582,7 @@ struct mddev {
> >   						*/
> >   	struct work_struct flush_work;
> >   	struct work_struct event_work;	/* used by dm to
> > report failure event */
> > +	struct work_struct uevent_work;
> >   	mempool_t *serial_info_pool;
> >   	void (*sync_super)(struct mddev *mddev, struct md_rdev
> > *rdev); struct md_cluster_info		*cluster_info;
> > @@ -883,7 +884,7 @@ extern int md_super_wait(struct mddev *mddev);
> >   extern int sync_page_io(struct md_rdev *rdev, sector_t sector,
> > int size, struct page *page, blk_opf_t opf, bool metadata_op);
> >   extern void md_do_sync(struct md_thread *thread);
> > -extern void md_new_event(void);
> > +extern void md_new_event(struct mddev *mddev, bool sync);
> >   extern void md_allow_write(struct mddev *mddev);
> >   extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct
> > mddev *mddev); extern void md_set_array_sectors(struct mddev
> > *mddev, sector_t array_sectors); diff --git a/drivers/md/raid10.c
> > b/drivers/md/raid10.c index 2a9c4ee982e0..f76571079845 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -4542,7 +4542,7 @@ static int raid10_start_reshape(struct mddev
> > *mddev) set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> >   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >   	conf->reshape_checkpoint = jiffies;
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	return 0;
> >   
> >   abort:
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index c14cf2410365..9da091b000d7 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -8525,7 +8525,7 @@ static int raid5_start_reshape(struct mddev
> > *mddev) set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> >   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >   	conf->reshape_checkpoint = jiffies;
> > -	md_new_event();
> > +	md_new_event(mddev, true);
> >   	return 0;
> >   }
> >   
> >   
> 
> 

Thank you for review. I've sent v9.

Regards,
Kinga
