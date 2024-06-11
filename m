Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14D3176252
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 08:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718096196; cv=none; b=RTOphtyEqCqhiVCOb6p3n7A7N0M/enguZjyVlyFSpsaksl536of+qm5VXZBFoJiehuyHs0RFkoGkBAif2CY6Jg5O7+R6d1yF77EiY1Bhy7KPv9EZaXfE72/vQiZMSk/4XrbtzUKhiZ60n4SjDp4dWwWy6VJl39RU00h+Bnau+sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718096196; c=relaxed/simple;
	bh=iwlVxIk2TaCrfaE0518On05K/JvW7nCKeeL5kk2nXjU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=py7tquCZtVbINHKl5aViJY4N5rZXIAl4ELoxNVJqhx9vkptvpWrUtVtoJz+SOiiFCAePig+Yo9sz3CYcKzYvF9+2atRnQz76ZYc+eZcHPQe5Ha5armOR3QNlPvFxQnFx5RJ3zJynFQq9J0btkLUs8P5IB0KSac2K+0SJF2bQ3pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vz2b83tqZz4f3jXt
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 16:56:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 83AEB1A144D
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 16:56:30 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAn+RE8EWhmRiazPA--.43111S3;
	Tue, 11 Jun 2024 16:56:30 +0800 (CST)
Subject: Re: [PATCH v6 1/1] md: generate CHANGE uevents for md device
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20240522073310.8014-1-kinga.stefaniuk@intel.com>
 <20240522073310.8014-2-kinga.stefaniuk@intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <42c3e4cf-2da9-97d0-be80-c801ee822529@huaweicloud.com>
Date: Tue, 11 Jun 2024 16:56:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240522073310.8014-2-kinga.stefaniuk@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn+RE8EWhmRiazPA--.43111S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ZF4kGF1ktr15ur45Gr1fCrg_yoWDCFWDpa
	yftF90krs8JrWfX3y5XFyDua4Yqw18tr9rKry3W34xX34Ygr1kGF1rWry5Jr98Aa95Zr4Y
	qa15KFsxC34xWFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

Please CC me in the next version. Some nits below.

ÔÚ 2024/05/22 15:33, Kinga Stefaniuk Ð´µÀ:
> In mdadm commit 49b69533e8 ("mdmonitor: check if udev has finished
> events processing") mdmonitor has been learnt to wait for udev to finish
> processing, and later in commit 9935cf0f64f3 ("Mdmonitor: Improve udev
> event handling") pooling for MD events on /proc/mdstat file has been
> deprecated because relying on udev events is more reliable and less bug
> prone (we are not competing with udev).
> 
> After those changes we are still observing missing mdmonitor events in
> some scenarios, especially SpareEvent is likely to be missed. With this
> patch MD will be able to generate more change uevents and wakeup
> mdmonitor more frequently to give it possibility to notice events.
> MD has md_new_event() functionality to trigger events and with this
> patch this function is extended to generate udev CHANGE uevents. It
> cannot be done directly for md_error because this function is called on
> interrupts context, so appropriate workqueue is used. Uevents are less time
> critical, it is safe to use workqueue. It is limited to CHANGE event as
> there is no need to generate other uevents for now.
> With this change, mdmonitor events are less likely to be missed. Our
> internal tests suite confirms that, mdmonitor reliability is (again)
> improved.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> 
> ---
> 
> v6: use another workqueue and only on md_error, make configurable
>      if kobject_uevent is run immediately on event or queued
> v5: fix flush_work missing and commit message fixes
> v4: add more detailed commit message
> v3: fix problems with calling function from interrupt context,
>      add work_queue and queue events notification
> v2: resolve merge conflicts with applying the patch
> Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> ---
>   drivers/md/md.c     | 47 ++++++++++++++++++++++++++++++---------------
>   drivers/md/md.h     |  2 +-
>   drivers/md/raid10.c |  2 +-
>   drivers/md/raid5.c  |  2 +-
>   4 files changed, 35 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aff9118ff697..2ec696e17f3d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -313,6 +313,16 @@ static int start_readonly;
>    */
>   static bool create_on_open = true;
>   
> +/*
> + * Send every new event to the userspace.
> + */
> +static void trigger_kobject_uevent(struct work_struct *work)

I'll prefer the name md_kobject_uevent_fn().
> +{
> +	struct mddev *mddev = container_of(work, struct mddev, event_work);
> +
> +	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +}
> +
>   /*
>    * We have a system wide 'event count' that is incremented
>    * on any 'interesting' event, and readers of /proc/mdstat
> @@ -325,10 +335,15 @@ static bool create_on_open = true;
>    */
>   static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
>   static atomic_t md_event_count;
> -void md_new_event(void)
> +void md_new_event(struct mddev *mddev, bool trigger_event)

You're going to send uevent anyway, the differece is sync/asyn, hence
I'll use the name 'bool sync' instead.
>   {
>   	atomic_inc(&md_event_count);
>   	wake_up(&md_event_waiters);
> +
> +	if (trigger_event)
> +		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +	else
> +		schedule_work(&mddev->event_work);

As I said in the last version, please use the workqueue md_misc_wq
that is allocated by raid.
>   }
>   EXPORT_SYMBOL_GPL(md_new_event);
>   
> @@ -863,6 +878,7 @@ static void mddev_free(struct mddev *mddev)
>   	list_del(&mddev->all_mddevs);
>   	spin_unlock(&all_mddevs_lock);
>   
> +	cancel_work_sync(&mddev->event_work);

This is too late, you must cancel the work before deleting the mddev
kobject in mddev_delayed_delete().

BTW, I think is reasonable to add a kobject_del() here as well.
>   	mddev_destroy(mddev);
>   	kfree(mddev);
>   }
> @@ -2940,7 +2956,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
>   	if (mddev->degraded)
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   }
>   
> @@ -3057,7 +3073,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>   				md_kick_rdev_from_array(rdev);
>   				if (mddev->pers)
>   					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -				md_new_event();
> +				md_new_event(mddev, true);
>   			}
>   		}
>   	} else if (cmd_match(buf, "writemostly")) {
> @@ -4173,7 +4189,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
>   	sysfs_notify_dirent_safe(mddev->sysfs_level);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	rv = len;
>   out_unlock:
>   	mddev_unlock_and_resume(mddev);
> @@ -4700,7 +4716,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>   		export_rdev(rdev, mddev);
>   	mddev_unlock_and_resume(mddev);
>   	if (!err)
> -		md_new_event();
> +		md_new_event(mddev, true);
>   	return err ? err : len;
>   }
>   
> @@ -5902,6 +5918,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
>   		return ERR_PTR(error);
>   	}
>   
> +	INIT_WORK(&mddev->event_work, trigger_kobject_uevent);

Please add a new work struct, and add INIT_WORK() in mddev_init() with
other works.
>   	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>   	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
>   	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
> @@ -6244,7 +6261,7 @@ int md_run(struct mddev *mddev)
>   	if (mddev->sb_flags)
>   		md_update_sb(mddev, 0);
>   
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   
>   bitmap_abort:
> @@ -6603,7 +6620,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		if (mddev->hold_active == UNTIL_STOP)
>   			mddev->hold_active = 0;
>   	}
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
>   	return 0;
>   }
> @@ -7099,7 +7116,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   
>   	return 0;
>   busy:
> @@ -7179,7 +7196,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>   	 * array immediately.
>   	 */
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   
>   abort_export:
> @@ -8159,7 +8176,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   	}
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
> -	md_new_event();
> +	md_new_event(mddev, false);

md_error() has lots of callers, and I'm not quite sure yet if this can
concurent with deleting mddev. Otherwise you must check if 'MD_DELETED'
is not set before queuing the new work.

Thanks,
Kuai


>   }
>   EXPORT_SYMBOL(md_error);
>   
> @@ -9049,7 +9066,7 @@ void md_do_sync(struct md_thread *thread)
>   		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
>   	mddev->curr_resync_completed = j;
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	update_time = jiffies;
>   
>   	blk_start_plug(&plug);
> @@ -9120,7 +9137,7 @@ void md_do_sync(struct md_thread *thread)
>   			/* this is the earliest that rebuild will be
>   			 * visible in /proc/mdstat
>   			 */
> -			md_new_event();
> +			md_new_event(mddev, true);
>   
>   		if (last_check + window > io_sectors || j == max_sectors)
>   			continue;
> @@ -9386,7 +9403,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>   			sysfs_link_rdev(mddev, rdev);
>   			if (!test_bit(Journal, &rdev->flags))
>   				spares++;
> -			md_new_event();
> +			md_new_event(mddev, true);
>   			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   		}
>   	}
> @@ -9505,7 +9522,7 @@ static void md_start_sync(struct work_struct *ws)
>   		__mddev_resume(mddev, false);
>   	md_wakeup_thread(mddev->sync_thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return;
>   
>   not_running:
> @@ -9757,7 +9774,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
>   	wake_up(&resync_wait);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ca085ecad504..6c0a45d4613e 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -803,7 +803,7 @@ extern int md_super_wait(struct mddev *mddev);
>   extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>   		struct page *page, blk_opf_t opf, bool metadata_op);
>   extern void md_do_sync(struct md_thread *thread);
> -extern void md_new_event(void);
> +extern void md_new_event(struct mddev *mddev, bool trigger_event);
>   extern void md_allow_write(struct mddev *mddev);
>   extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
>   extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index a4556d2e46bf..4f4adbe5da95 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4545,7 +4545,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	conf->reshape_checkpoint = jiffies;
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   
>   abort:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2bd1ce9b3922..085206f1cdcc 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8503,7 +8503,7 @@ static int raid5_start_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	conf->reshape_checkpoint = jiffies;
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   }
>   
> 

