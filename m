Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC732DCC0C
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 02:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748311867; cv=none; b=tr3N0mSxUbqkSx426DVhQD43VRn2xLJxyL/xaUiXRyeo9s1XohtECcmfMmvX2x7Jsg7jZejVV/tboP6Vz4kKc3M+xk6eGJzYTnvY3d3hlKRRiYX85VzjKQuUi5BN230ba3SbSuKepCdlk5oy3DVp1zXDtlGSI3q9dGUfR7SHot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748311867; c=relaxed/simple;
	bh=Xt/VoWHrY4d51DECyTQfcTUkcTs2E87KfglGvHQFEdM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VY3HvOd9GKl3ENDeyGCTIQDcYwOim7oLvjTPwCm7/XzJ29gipZKEiomdVIUlg3f8g0/PLvQJtOugkve6dzJ6J95hWEkg5utxUga3PJpAEmQa3RmvH1UEK8L+K4NnvPhjymh/cUWhzIJ8DP54Xkqp/6LWdb+o4lcsnOYtRPHTeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b5x1S0FSjz4f3lw3
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 10:10:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4A86E1A1132
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 10:11:01 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgA3m180HzVoKpqENg--.39370S3;
	Tue, 27 May 2025 10:11:01 +0800 (CST)
Subject: Re: [PATCH 2/2] md: call del_gendisk in control path
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com, ncroxon@redhat.com, song@kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250515090847.2356-1-xni@redhat.com>
 <20250515090847.2356-3-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8780c2aa-0dcd-613c-6dd1-16084a66aaff@huaweicloud.com>
Date: Tue, 27 May 2025 10:11:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250515090847.2356-3-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m180HzVoKpqENg--.39370S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WrWrGr1UtrW7GryDGw45Jrb_yoWxAr48pa
	y8tF9xKr4Uta4Sq3y7JF4ku3W5Zwn7KrWktryfG3sYv3W3XrnxGF1FgayjyrykGas3urs0
	qa1UJFsxCrW0grDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUG0PhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/15 17:08, Xiao Ni Ð´µÀ:
> Now del_gendisk and put_disk are called asynchronously in workqueue work.
> The asynchronous way also has a problem that the device node can still
> exist after mdadm --stop command returns in a short window. So udev rule
> can open this device node and create the struct mddev in kernel again.
> 
> So put del_gendisk in control path and still leave put_disk in
> md_kobj_release to avoid uaf.
> 
> But there is a window that sysfs can be accessed between mddev_unlock and
> del_gendisk. So some actions (add disk, change level, .e.g) can happen
> which lead unexpected results. And if we delete MD_DELETED and only use
> MD_CLOSING in stop control path, the sysfs files can't be accessed if
> do_md_stop stuck when io hange. So we keep MD_DELETED here and set
> MD_DELETED before mddev_unlock.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 53 ++++++++++++++++++++++++++++++++++++++++++-------
>   drivers/md/md.h | 16 ++++++++++++++-
>   2 files changed, 61 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9b9950ed6ee9..a62867f34aa8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -606,15 +606,13 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
>   }
>   
>   static void mddev_delayed_delete(struct work_struct *ws);
> +static bool can_delete_gendisk(struct mddev *mddev);

Plese define new helper here directly.
>   
>   static void __mddev_put(struct mddev *mddev)
>   {
> -	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
> -	    mddev->ctime || mddev->hold_active)
> -		return;
>   
> -	/* Array is not configured at all, and not held active, so destroy it */
> -	set_bit(MD_DELETED, &mddev->flags);
> +	if (can_delete_gendisk(mddev) == false)
> +		return;
>   
>   	/*
>   	 * Call queue_work inside the spinlock so that flush_workqueue() after
> @@ -4400,6 +4398,7 @@ array_state_show(struct mddev *mddev, char *page)
>   	return sprintf(page, "%s\n", array_states[st]);
>   }
>   
> +static void delete_gendisk(struct mddev *mddev);

This helper looks unnecessary, it doesn't make code cleaner.

>   static int do_md_stop(struct mddev *mddev, int ro);
>   static int md_set_readonly(struct mddev *mddev);
>   static int restart_array(struct mddev *mddev);
> @@ -4533,6 +4532,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>   	    (err && st == clear))
>   		clear_bit(MD_CLOSING, &mddev->flags);
>   
> +	if ((st == clear || st == inactive) && !err)
> +		delete_gendisk(mddev);

I think it's better to do this in mddev_unlock() if MD_DELETED is set,
like what we did for rdev. Meanwhile, mddev->to_remove and all related
hacks can be removed now.
> +
>   	return err ?: len;
>   }
>   static struct md_sysfs_entry md_array_state =
> @@ -5721,19 +5723,30 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
>   	struct md_sysfs_entry *entry = container_of(attr, struct md_sysfs_entry, attr);
>   	struct mddev *mddev = container_of(kobj, struct mddev, kobj);
>   	ssize_t rv;
> +	struct kernfs_node *kn = NULL;
>   
>   	if (!entry->store)
>   		return -EIO;
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EACCES;
> +
> +	if (entry->store == array_state_store && cmd_match(page, "clear"))
> +		kn = sysfs_break_active_protection(kobj, attr);
> +
>   	spin_lock(&all_mddevs_lock);
>   	if (!mddev_get(mddev)) {
>   		spin_unlock(&all_mddevs_lock);
> +		if (kn)
> +			sysfs_unbreak_active_protection(kn);
>   		return -EBUSY;
>   	}
>   	spin_unlock(&all_mddevs_lock);
>   	rv = entry->store(mddev, page, length);
>   	mddev_put(mddev);
> +
> +	if (kn)
> +		sysfs_unbreak_active_protection(kn);
> +
>   	return rv;
>   }
>   
> @@ -5746,7 +5759,6 @@ static void md_kobj_release(struct kobject *ko)
>   	if (mddev->sysfs_level)
>   		sysfs_put(mddev->sysfs_level);
>   
> -	del_gendisk(mddev->gendisk);
>   	put_disk(mddev->gendisk);
>   }
>   
> @@ -6526,6 +6538,28 @@ static int md_set_readonly(struct mddev *mddev)
>   	return err;
>   }
>   
> +static bool can_delete_gendisk(struct mddev *mddev)
> +{
> +	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
> +	    mddev->ctime || mddev->hold_active)
> +		return false;
> +
> +	return true;
> +}
> +
> +/* Call this function after do_md_stop with mode 0.
> + * And it can't call this function under reconfig_mutex to
> + * avoid deadlock(e.g. call del_gendisk under the lock and
> + * an access to sysfs files waits the lock)
> + */
> +static void delete_gendisk(struct mddev *mddev)
> +{
> +	if (can_delete_gendisk(mddev) == false)
> +		return;
> +
> +	del_gendisk(mddev->gendisk);
> +}
> +
>   /* mode:
>    *   0 - completely stop and dis-assemble array
>    *   2 - stop but do not disassemble array
> @@ -6588,8 +6622,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		mddev->bitmap_info.offset = 0;
>   
>   		export_array(mddev);
> -
>   		md_clean(mddev);
> +		set_bit(MD_DELETED, &mddev->flags);
>   	}
>   	md_new_event();
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> @@ -6616,6 +6650,7 @@ static void autorun_array(struct mddev *mddev)
>   	if (err) {
>   		pr_warn("md: do_md_run() returned %d\n", err);
>   		do_md_stop(mddev, 0);
> +		delete_gendisk(mddev);
>   	}
>   }
>   
> @@ -7886,6 +7921,10 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
>   out:
>   	if (cmd == STOP_ARRAY_RO || (err && cmd == STOP_ARRAY))
>   		clear_bit(MD_CLOSING, &mddev->flags);
> +
> +	if (cmd == STOP_ARRAY && err == 0)
> +		delete_gendisk(mddev);
> +
>   	return err;
>   }
>   #ifdef CONFIG_COMPAT
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1cf00a04bcdd..45f1027986e4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -697,11 +697,25 @@ static inline bool reshape_interrupted(struct mddev *mddev)
>   
>   static inline int __must_check mddev_lock(struct mddev *mddev)
>   {
> -	return mutex_lock_interruptible(&mddev->reconfig_mutex);
> +	int ret = 0;
> +
> +	ret = mutex_lock_interruptible(&mddev->reconfig_mutex);
> +
> +	/* MD_DELETED is set in do_md_stop with reconfig_mutex
> +	 * So check it here also.
> +	 */
> +	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
> +		ret = -EBUSY;
> +		mutex_unlock(&mddev->reconfig_mutex);
> +	}
> +
> +	return ret;
>   }

There are also other helpers like mddev_lock_nointr,
mddev_suspend_and_lock_nointr, mddev_trylock.

Thanks,
Kuai

>   
>   /* Sometimes we need to take the lock in a situation where
>    * failure due to interrupts is not acceptable.
> + * It doesn't need to check MD_DELETED here, the owner which
> + * holds the lock here can't be stopped.
>    */
>   static inline void mddev_lock_nointr(struct mddev *mddev)
>   {
> 

