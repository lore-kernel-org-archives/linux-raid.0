Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223F04500C
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 11:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719488760; cv=none; b=QSb9ZHHNyQh+sccd8mt0XO0Hur0RYQDs7F8H3R5ODX3c9C1aOgveuI3CvLAZVmAhqNmFgcaWGtRsN3+2Sog55BUi2z1lKR0677VGcxVxtHi6UQe28VTc93VLOZ/d6WaB7BPlL9U0jxAOWEekj1yUUk2r+Qfq7atahs3baAfkz7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719488760; c=relaxed/simple;
	bh=onGmmAuLqmoyIC/sEY0KvpIefRKy6037SAjBwO3oHRY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lCiJhKGECfE1KnPkagl4gWiSqK3tz5AX0WUQsF9Hm8Gg8NzU+R8LX/+qjiqMW3xC8S/zpM/g3gzOD7d47ddLHcxdleJzJHXuV7M/5WWm+0ld2kE/m4yCWgy3pRd4Uce80QB1lZG12dx2W1KAwqr4E+dO9HRtN53iC68CGWmmvo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W8xb90h0nz4f3m6v
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 19:45:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 4D3461A0568
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 19:45:53 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgBn0YbvUH1mkIH1AQ--.22258S3;
	Thu, 27 Jun 2024 19:45:53 +0800 (CST)
Subject: Re: [PATCH v7] md: generate CHANGE uevents for md device
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20240625142928.28090-1-kinga.stefaniuk@intel.com>
 <20240625142928.28090-2-kinga.stefaniuk@intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <63ad4a10-29cc-728a-4017-6626e1ba194e@huaweicloud.com>
Date: Thu, 27 Jun 2024 19:45:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240625142928.28090-2-kinga.stefaniuk@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBn0YbvUH1mkIH1AQ--.22258S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ZF4kGF1kuw1DZryUtrWrXwb_yoWDCw1Dpa
	yftF90kr4UJrWfXrW5JFyDua4Yqw18tr9rtry3W34fJF90gr1kGF1rWry5tr98Aa95Zr4Y
	qa1UKFsxC34xWFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/06/25 22:29, Kinga Stefaniuk Ð´µÀ:
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
> MD has md_new_events() functionality to trigger events and with this
> patch this function is extended to generate udev CHANGE uevents. It
> cannot be done directly because this function is called on interrupts
> context, so appropriate workqueue is created. Uevents are less time
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
> v7: add new work struct for these events, use md_misc_wq workqueue,
>      fix work cancellation
> v6: use another workqueue and only on md_error, make configurable
>      if kobject_uevent is run immediately on event or queued
> v5: fix flush_work missing and commit message fixes
> v4: add more detailed commit message
> v3: fix problems with calling function from interrupt context,
>      add work_queue and queue events notification
> v2: resolve merge conflicts with applying the patch
> 
> ---
>   drivers/md/md.c     | 50 +++++++++++++++++++++++++++++++--------------
>   drivers/md/md.h     |  3 ++-
>   drivers/md/raid10.c |  2 +-
>   drivers/md/raid5.c  |  2 +-
>   4 files changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aff9118ff697..3b976e3bd702 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -313,6 +313,16 @@ static int start_readonly;
>    */
>   static bool create_on_open = true;
>   
> +/*
> + * Send every new event to the userspace.
> + */
> +static void md_kobject_uevent_fn(struct work_struct *work)
> +{
> +	struct mddev *mddev = container_of(work, struct mddev, uevent_work);

Think about this a bit more, this is still not safe. To avoid concurrent
with del_work:

spin_lock(&all_mddevs_lock);
mddev = mddev_get(mddev));
spin_unlock(&all_mddevs_lock);

if (!mddev)
	return;

kobject_uevent(...);
mddev_put(mddev);

> +
> +	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +}
> +
>   /*
>    * We have a system wide 'event count' that is incremented
>    * on any 'interesting' event, and readers of /proc/mdstat
> @@ -325,10 +335,17 @@ static bool create_on_open = true;
>    */
>   static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
>   static atomic_t md_event_count;
> -void md_new_event(void)
> +void md_new_event(struct mddev *mddev, bool sync)

Now that you touch this line, please also add a blank line.
>   {
>   	atomic_inc(&md_event_count);
>   	wake_up(&md_event_waiters);
> +
> +	if (mddev_is_dm(mddev))
> +		return;
> +	if (sync)
> +		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +	else
> +		queue_work(md_misc_wq, &mddev->uevent_work);
>   }
>   EXPORT_SYMBOL_GPL(md_new_event);
>   
> @@ -765,6 +782,7 @@ int mddev_init(struct mddev *mddev)
>   
>   	INIT_WORK(&mddev->sync_work, md_start_sync);
>   	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
> +	INIT_WORK(&mddev->uevent_work, md_kobject_uevent_fn);
>   
>   	return 0;
>   }
> @@ -2940,7 +2958,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
>   	if (mddev->degraded)
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_new_event();
> +	md_new_event(mddev, false);

The second param is @sync, 'true' should be passed in, and for all the
following callers.
>   	return 0;
>   }
>   
> @@ -3057,7 +3075,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>   				md_kick_rdev_from_array(rdev);
>   				if (mddev->pers)
>   					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -				md_new_event();
> +				md_new_event(mddev, false);
>   			}
>   		}
>   	} else if (cmd_match(buf, "writemostly")) {
> @@ -4173,7 +4191,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
>   	sysfs_notify_dirent_safe(mddev->sysfs_level);
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	rv = len;
>   out_unlock:
>   	mddev_unlock_and_resume(mddev);
> @@ -4700,7 +4718,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>   		export_rdev(rdev, mddev);
>   	mddev_unlock_and_resume(mddev);
>   	if (!err)
> -		md_new_event();
> +		md_new_event(mddev, false);
>   	return err ? err : len;
>   }
>   
> @@ -5803,6 +5821,7 @@ static void mddev_delayed_delete(struct work_struct *ws)
>   {
>   	struct mddev *mddev = container_of(ws, struct mddev, del_work);
>   
> +	cancel_work_sync(&mddev->uevent_work);
>   	kobject_put(&mddev->kobj);
>   }
>   
> @@ -6244,7 +6263,7 @@ int md_run(struct mddev *mddev)
>   	if (mddev->sb_flags)
>   		md_update_sb(mddev, 0);
>   
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	return 0;
>   
>   bitmap_abort:
> @@ -6603,7 +6622,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		if (mddev->hold_active == UNTIL_STOP)
>   			mddev->hold_active = 0;
>   	}
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
>   	return 0;
>   }
> @@ -7099,7 +7118,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
> -	md_new_event();
> +	md_new_event(mddev, false);
>   
>   	return 0;
>   busy:
> @@ -7179,7 +7198,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>   	 * array immediately.
>   	 */
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	return 0;
>   
>   abort_export:
> @@ -8159,7 +8178,8 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   	}
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
> -	md_new_event();
> +	if (!test_bit(MD_DELETED, &mddev->flags))
> +		md_new_event(mddev, true);

And 'false' should be passed in here.

Thanks,
Kuai
>   }
>   EXPORT_SYMBOL(md_error);
>   
> @@ -9049,7 +9069,7 @@ void md_do_sync(struct md_thread *thread)
>   		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
>   	mddev->curr_resync_completed = j;
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	update_time = jiffies;
>   
>   	blk_start_plug(&plug);
> @@ -9120,7 +9140,7 @@ void md_do_sync(struct md_thread *thread)
>   			/* this is the earliest that rebuild will be
>   			 * visible in /proc/mdstat
>   			 */
> -			md_new_event();
> +			md_new_event(mddev, false);
>   
>   		if (last_check + window > io_sectors || j == max_sectors)
>   			continue;
> @@ -9386,7 +9406,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>   			sysfs_link_rdev(mddev, rdev);
>   			if (!test_bit(Journal, &rdev->flags))
>   				spares++;
> -			md_new_event();
> +			md_new_event(mddev, false);
>   			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   		}
>   	}
> @@ -9505,7 +9525,7 @@ static void md_start_sync(struct work_struct *ws)
>   		__mddev_resume(mddev, false);
>   	md_wakeup_thread(mddev->sync_thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	return;
>   
>   not_running:
> @@ -9757,7 +9777,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
>   	wake_up(&resync_wait);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ca085ecad504..e1fe88c1c0f7 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -528,6 +528,7 @@ struct mddev {
>   						*/
>   	struct work_struct flush_work;
>   	struct work_struct event_work;	/* used by dm to report failure event */
> +	struct work_struct uevent_work;
>   	mempool_t *serial_info_pool;
>   	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
>   	struct md_cluster_info		*cluster_info;
> @@ -803,7 +804,7 @@ extern int md_super_wait(struct mddev *mddev);
>   extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>   		struct page *page, blk_opf_t opf, bool metadata_op);
>   extern void md_do_sync(struct md_thread *thread);
> -extern void md_new_event(void);
> +extern void md_new_event(struct mddev *mddev, bool sync);
>   extern void md_allow_write(struct mddev *mddev);
>   extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
>   extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index a4556d2e46bf..fe743168dd35 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4545,7 +4545,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	conf->reshape_checkpoint = jiffies;
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	return 0;
>   
>   abort:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2bd1ce9b3922..6e61cc13b9c2 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8503,7 +8503,7 @@ static int raid5_start_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	conf->reshape_checkpoint = jiffies;
> -	md_new_event();
> +	md_new_event(mddev, false);
>   	return 0;
>   }
>   
> 

