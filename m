Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852C155893
	for <linux-raid@vger.kernel.org>; Mon, 26 Aug 2024 03:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724643341; cv=none; b=KmOq4rdHL78lcmvfcbPbHP8EaAnGr5leGUEKcINQH2/V+c3f9MbCTco22ibrlZuMDuGF1zrjh88luNMx+7VTYjuARG0CX6vhZ4n9AJLzViyC73/dFnfhp69xz4+G6Z5ujPE2ytGWO0OLVpnkiOYTImle/vwjVTW8VPTe9vBmzjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724643341; c=relaxed/simple;
	bh=YeGT/UNxg0rCpsLj4y4SYnPGdt7J2RBiEa749Zt+IBc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=g65AmtSraicSwkuEj05hEZAHQGwuNnAFijeq4gQGyzgsKMRdcYyrIY7Aeebm7O0fHT3zJmo6MdNDNa8369EoGzKLMJ3aKPxgyUYupkvQMO4atQo0bKpuE6fXRcZ6Gg86Ekg6mKmFE3qyd3xFo4figLpcH0CiZX7cXfWumD8L1go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wsbsl6xLgz4f3jjk
	for <linux-raid@vger.kernel.org>; Mon, 26 Aug 2024 11:35:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CE5F61A058E
	for <linux-raid@vger.kernel.org>; Mon, 26 Aug 2024 11:35:33 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB37IIE+Mtmk6rzCg--.10261S3;
	Mon, 26 Aug 2024 11:35:33 +0800 (CST)
Subject: Re: [PATCH v11 1/1] md: generate CHANGE uevents for md device
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20240823145438.23432-1-kinga.stefaniuk@intel.com>
 <20240823145438.23432-2-kinga.stefaniuk@intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <233d3f41-08bb-4050-cfe3-4ec5870faf7b@huaweicloud.com>
Date: Mon, 26 Aug 2024 11:35:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240823145438.23432-2-kinga.stefaniuk@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB37IIE+Mtmk6rzCg--.10261S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ZF4kGF1kuw1DZryUtrWrXwb_yoWkuw4kpa
	yftF90kr4kXrWfXrW5XFyDua4Yqw10qr9rtry3W34fArn0gr1kGF1rWry5Jr98ua95Zr1Y
	qa1UKFs8C34xWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/08/23 22:54, Kinga Stefaniuk Ð´µÀ:
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
> v11: use irq methods to lock/unlock all_mddevs_lock
> v10: move mddev_get into md_new_event
> v9: add using md_wq and fix if (sync) condition
> v8: fix possible conflict with del_work by adding spin_lock,
>      change default sync value to true, now false only on md_error
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
> Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> ---
>   drivers/md/md.c     | 75 +++++++++++++++++++++++++++++++--------------
>   drivers/md/md.h     |  3 +-
>   drivers/md/raid10.c |  2 +-
>   drivers/md/raid5.c  |  2 +-
>   4 files changed, 56 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3a837506a36..8b146120cc62 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -107,6 +107,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>   static void mddev_detach(struct mddev *mddev);
>   static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
>   static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
> +static inline struct mddev *mddev_get(struct mddev *mddev);
>   
>   /*
>    * Default number of read corrections we'll attempt on an rdev
> @@ -323,6 +324,24 @@ static int start_readonly;
>    */
>   static bool create_on_open = true;
>   
> +/*
> + * Enables to iterate over all existing md arrays
> + * all_mddevs_lock protects this list.
> + */
> +static LIST_HEAD(all_mddevs);
> +static DEFINE_SPINLOCK(all_mddevs_lock);
> +
> +/*
> + * Send every new event to the userspace.
> + */
> +static void md_kobject_uevent_fn(struct work_struct *work)
> +{
> +	struct mddev *mddev = container_of(work, struct mddev, uevent_work);
> +
> +	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +	mddev_put(mddev);
> +}
> +
>   /*
>    * We have a system wide 'event count' that is incremented
>    * on any 'interesting' event, and readers of /proc/mdstat
> @@ -335,20 +354,29 @@ static bool create_on_open = true;
>    */
>   static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
>   static atomic_t md_event_count;
> -void md_new_event(void)
> +
> +void md_new_event(struct mddev *mddev, bool sync)
>   {
>   	atomic_inc(&md_event_count);
>   	wake_up(&md_event_waiters);
> +
> +	if (mddev_is_dm(mddev))
> +		return;
> +
> +	if (!sync) {
> +		unsigned long flags;
> +
> +		spin_lock_irq(&all_mddevs_lock);
> +		mddev = mddev_get(mddev);
> +		spin_unlock_irq(&all_mddevs_lock);
> +		if (mddev == NULL)
> +			return;
> +		queue_work(md_wq, &mddev->uevent_work);

You forgot to return here. And you should use spin_lock_irqsave() and
spin_unlock_irqrestore() instead, because this is interupt context.

> +	}
> +	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
>   }
>   EXPORT_SYMBOL_GPL(md_new_event);
>   
> -/*
> - * Enables to iterate over all existing md arrays
> - * all_mddevs_lock protects this list.
> - */
> -static LIST_HEAD(all_mddevs);
> -static DEFINE_SPINLOCK(all_mddevs_lock);
> -
>   static bool is_md_suspended(struct mddev *mddev)
>   {
>   	return percpu_ref_is_dying(&mddev->active_io);
> @@ -720,7 +748,7 @@ void mddev_put(struct mddev *mddev)

atomic_dec_and_lock() from mddev_put() also need to use irq version.
And also all the other places as well.

sed -i 
's/spin_lock(\&all_mddevs_lock)/spin_lock_irq(\&all_mddevs_lock)/g' 
drivers/md/md.c
sed -i 
's/spin_unlock(\&all_mddevs_lock)/spin_unlock_irq(\&all_mddevs_lock)/g' 
drivers/md/md.c

Thanks,
Kuai

>   		return;
>   
>   	__mddev_put(mddev);
> -	spin_unlock(&all_mddevs_lock);
> +	spin_unlock_irq(&all_mddevs_lock);
>   }
>   
>   static void md_safemode_timeout(struct timer_list *t);
> @@ -773,6 +801,7 @@ int mddev_init(struct mddev *mddev)
>   	mddev->resync_max = MaxSector;
>   	mddev->level = LEVEL_NONE;
>   
> +	INIT_WORK(&mddev->uevent_work, md_kobject_uevent_fn);
>   	INIT_WORK(&mddev->sync_work, md_start_sync);
>   	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
>   
> @@ -2898,7 +2927,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
>   	if (mddev->degraded)
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   }
>   
> @@ -3015,7 +3044,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>   				md_kick_rdev_from_array(rdev);
>   				if (mddev->pers)
>   					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -				md_new_event();
> +				md_new_event(mddev, true);
>   			}
>   		}
>   	} else if (cmd_match(buf, "writemostly")) {
> @@ -4131,7 +4160,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
>   	sysfs_notify_dirent_safe(mddev->sysfs_level);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	rv = len;
>   out_unlock:
>   	mddev_unlock_and_resume(mddev);
> @@ -4658,7 +4687,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>   		export_rdev(rdev, mddev);
>   	mddev_unlock_and_resume(mddev);
>   	if (!err)
> -		md_new_event();
> +		md_new_event(mddev, true);
>   	return err ? err : len;
>   }
>   
> @@ -6276,7 +6305,7 @@ int md_run(struct mddev *mddev)
>   	if (mddev->sb_flags)
>   		md_update_sb(mddev, 0);
>   
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   
>   bitmap_abort:
> @@ -6635,7 +6664,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		if (mddev->hold_active == UNTIL_STOP)
>   			mddev->hold_active = 0;
>   	}
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
>   	return 0;
>   }
> @@ -7131,7 +7160,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   
>   	return 0;
>   busy:
> @@ -7202,7 +7231,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>   	 * array immediately.
>   	 */
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   
>   abort_export:
> @@ -8176,7 +8205,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   	}
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
> -	md_new_event();
> +	md_new_event(mddev, false);
>   }
>   EXPORT_SYMBOL(md_error);
>   
> @@ -9073,7 +9102,7 @@ void md_do_sync(struct md_thread *thread)
>   		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
>   	mddev->curr_resync_completed = j;
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	update_time = jiffies;
>   
>   	blk_start_plug(&plug);
> @@ -9145,7 +9174,7 @@ void md_do_sync(struct md_thread *thread)
>   			/* this is the earliest that rebuild will be
>   			 * visible in /proc/mdstat
>   			 */
> -			md_new_event();
> +			md_new_event(mddev, true);
>   
>   		if (last_check + window > io_sectors || j == max_sectors)
>   			continue;
> @@ -9411,7 +9440,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>   			sysfs_link_rdev(mddev, rdev);
>   			if (!test_bit(Journal, &rdev->flags))
>   				spares++;
> -			md_new_event();
> +			md_new_event(mddev, true);
>   			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   		}
>   	}
> @@ -9530,7 +9559,7 @@ static void md_start_sync(struct work_struct *ws)
>   		__mddev_resume(mddev, false);
>   	md_wakeup_thread(mddev->sync_thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return;
>   
>   not_running:
> @@ -9782,7 +9811,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
>   	wake_up(&resync_wait);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index a0d6827dced9..ab340618828c 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -582,6 +582,7 @@ struct mddev {
>   						*/
>   	struct work_struct flush_work;
>   	struct work_struct event_work;	/* used by dm to report failure event */
> +	struct work_struct uevent_work;
>   	mempool_t *serial_info_pool;
>   	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
>   	struct md_cluster_info		*cluster_info;
> @@ -883,7 +884,7 @@ extern int md_super_wait(struct mddev *mddev);
>   extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>   		struct page *page, blk_opf_t opf, bool metadata_op);
>   extern void md_do_sync(struct md_thread *thread);
> -extern void md_new_event(void);
> +extern void md_new_event(struct mddev *mddev, bool sync);
>   extern void md_allow_write(struct mddev *mddev);
>   extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
>   extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 2a9c4ee982e0..f76571079845 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4542,7 +4542,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	conf->reshape_checkpoint = jiffies;
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   
>   abort:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c14cf2410365..9da091b000d7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8525,7 +8525,7 @@ static int raid5_start_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	conf->reshape_checkpoint = jiffies;
> -	md_new_event();
> +	md_new_event(mddev, true);
>   	return 0;
>   }
>   
> 

