Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1649D15FA67
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 14:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715092029; cv=none; b=LZHQml2LdSyGmVKfO3o+zwKbjeYCMGnxtFoUkCvjnRASDqriM2/V22pjN25AxKkVFO6mYhxxiXyE+JzARFKlXu6pAxc3u+zlFlePz8AtTHlcmoKVbF1/GJc2ev6OCcG9xkYLQ9FC1in4qv0ropHG9xfK7GSIl/G+um+1Z+0g4sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715092029; c=relaxed/simple;
	bh=JwUSmnyi34yds3S/xYTK2LzaDPUKgIyC5RCByIc0wLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NBUzUcZmW4a2a9O6WoWAftyXDe99XU30dWs8GimIfaftHfJb36OLXjDsQHgcH/snWZkdDMSSxZTxp2roN3x/h1k09DpkiSSYNWos7kAn+7ysnaoRSg8mDfFGRHNaEWo9TUL32tAThDULc1iB60XkOtRQDjNnI9TgRKimraevPUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.34] (g34.guest.molgen.mpg.de [141.14.220.34])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 58D1661E5FE01;
	Tue,  7 May 2024 16:26:26 +0200 (CEST)
Message-ID: <b0263ec1-6677-4aca-a24b-ebd467cd2e43@molgen.mpg.de>
Date: Tue, 7 May 2024 16:26:25 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] md: generate CHANGE uevents for md device
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org
References: <20240507140657.6974-1-kinga.stefaniuk@intel.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240507140657.6974-1-kinga.stefaniuk@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Kinga,


Thank you for the patch.

Am 07.05.24 um 16:06 schrieb Kinga Stefaniuk:
> Due to changes in mdadm event handling and moving to udev based
> approach, more CHANGE uevents need to be added.

Can you please reference these changes in the commit message?

> Generate CHANGE uevents to give a udev based software (for ex. mdmonitor)
> chance to see changes in case of any array reconfiguration.

*a* chance

> Add emitting a new CHANGE uevent into md_new_event() to keep consistency
> with previous mdstat based approach.

Excuse my ignorance. What was the mdstat based approach?


Kind regards,

Paul


> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> ---
>   drivers/md/md.c     | 41 ++++++++++++++++++++++++++---------------
>   drivers/md/md.h     |  3 ++-
>   drivers/md/raid10.c |  2 +-
>   drivers/md/raid5.c  |  2 +-
>   4 files changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e575e74aabf5..98a7f2c1182c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -313,6 +313,15 @@ static int start_readonly;
>    */
>   static bool create_on_open = true;
>   
> +/*
> + * Send every new event to the userspace.
> + */
> +static void trigger_event(struct work_struct *work)
> +{
> +	struct mddev *mddev = container_of(work, struct mddev, uevent_work);
> +	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +}
> +
>   /*
>    * We have a system wide 'event count' that is incremented
>    * on any 'interesting' event, and readers of /proc/mdstat
> @@ -325,10 +334,11 @@ static bool create_on_open = true;
>    */
>   static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
>   static atomic_t md_event_count;
> -void md_new_event(void)
> +void md_new_event(struct mddev *mddev)
>   {
>   	atomic_inc(&md_event_count);
>   	wake_up(&md_event_waiters);
> +	schedule_work(&mddev->uevent_work);
>   }
>   EXPORT_SYMBOL_GPL(md_new_event);
>   
> @@ -2940,7 +2950,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
>   	if (mddev->degraded)
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_new_event();
> +	md_new_event(mddev);
>   	return 0;
>   }
>   
> @@ -3057,7 +3067,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>   				md_kick_rdev_from_array(rdev);
>   				if (mddev->pers)
>   					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -				md_new_event();
> +				md_new_event(mddev);
>   			}
>   		}
>   	} else if (cmd_match(buf, "writemostly")) {
> @@ -4173,7 +4183,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
>   	sysfs_notify_dirent_safe(mddev->sysfs_level);
> -	md_new_event();
> +	md_new_event(mddev);
>   	rv = len;
>   out_unlock:
>   	mddev_unlock_and_resume(mddev);
> @@ -4700,7 +4710,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>   		export_rdev(rdev, mddev);
>   	mddev_unlock_and_resume(mddev);
>   	if (!err)
> -		md_new_event();
> +		md_new_event(mddev);
>   	return err ? err : len;
>   }
>   
> @@ -5902,6 +5912,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
>   		return ERR_PTR(error);
>   	}
>   
> +	INIT_WORK(&mddev->uevent_work, trigger_event);
>   	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>   	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
>   	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
> @@ -6244,7 +6255,7 @@ int md_run(struct mddev *mddev)
>   	if (mddev->sb_flags)
>   		md_update_sb(mddev, 0);
>   
> -	md_new_event();
> +	md_new_event(mddev);
>   	return 0;
>   
>   bitmap_abort:
> @@ -6603,7 +6614,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		if (mddev->hold_active == UNTIL_STOP)
>   			mddev->hold_active = 0;
>   	}
> -	md_new_event();
> +	md_new_event(mddev);
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
>   	return 0;
>   }
> @@ -7099,7 +7110,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
> -	md_new_event();
> +	md_new_event(mddev);
>   
>   	return 0;
>   busy:
> @@ -7179,7 +7190,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>   	 * array immediately.
>   	 */
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_new_event();
> +	md_new_event(mddev);
>   	return 0;
>   
>   abort_export:
> @@ -8158,7 +8169,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   	}
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
> -	md_new_event();
> +	md_new_event(mddev);
>   }
>   EXPORT_SYMBOL(md_error);
>   
> @@ -9044,7 +9055,7 @@ void md_do_sync(struct md_thread *thread)
>   		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
>   	mddev->curr_resync_completed = j;
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
> -	md_new_event();
> +	md_new_event(mddev);
>   	update_time = jiffies;
>   
>   	blk_start_plug(&plug);
> @@ -9115,7 +9126,7 @@ void md_do_sync(struct md_thread *thread)
>   			/* this is the earliest that rebuild will be
>   			 * visible in /proc/mdstat
>   			 */
> -			md_new_event();
> +			md_new_event(mddev);
>   
>   		if (last_check + window > io_sectors || j == max_sectors)
>   			continue;
> @@ -9381,7 +9392,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>   			sysfs_link_rdev(mddev, rdev);
>   			if (!test_bit(Journal, &rdev->flags))
>   				spares++;
> -			md_new_event();
> +			md_new_event(mddev);
>   			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   		}
>   	}
> @@ -9500,7 +9511,7 @@ static void md_start_sync(struct work_struct *ws)
>   		__mddev_resume(mddev, false);
>   	md_wakeup_thread(mddev->sync_thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> -	md_new_event();
> +	md_new_event(mddev);
>   	return;
>   
>   not_running:
> @@ -9752,7 +9763,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
> -	md_new_event();
> +	md_new_event(mddev);
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
>   	wake_up(&resync_wait);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 097d9dbd69b8..111aa3a0f60c 100644
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
> @@ -802,7 +803,7 @@ extern int md_super_wait(struct mddev *mddev);
>   extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>   		struct page *page, blk_opf_t opf, bool metadata_op);
>   extern void md_do_sync(struct md_thread *thread);
> -extern void md_new_event(void);
> +extern void md_new_event(struct mddev *mddev);
>   extern void md_allow_write(struct mddev *mddev);
>   extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
>   extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index a4556d2e46bf..6f459d47e2a5 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4545,7 +4545,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	conf->reshape_checkpoint = jiffies;
> -	md_new_event();
> +	md_new_event(mddev);
>   	return 0;
>   
>   abort:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d874abfc1836..f5736fa1b318 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8512,7 +8512,7 @@ static int raid5_start_reshape(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	conf->reshape_checkpoint = jiffies;
> -	md_new_event();
> +	md_new_event(mddev);
>   	return 0;
>   }
>   
