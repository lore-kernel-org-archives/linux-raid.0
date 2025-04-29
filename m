Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEF52153FC
	for <linux-raid@vger.kernel.org>; Tue, 29 Apr 2025 02:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892311; cv=none; b=MC/OySXqeciFcIYvKw2jvw/H+cZpLjuPPZo0/fTdokiv21Ty9KlRFb1qMuuH1iKCklvXb+rKzur2WvypgJs1s5zsVHJ28a3fskfbkayJU6FV9oLC9DkxD9XyeJV03QiacFiGE/9xLsGY0rYRKou4SdwK0/G7kfHc1nSpiQJY6NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892311; c=relaxed/simple;
	bh=vA+vWrlDRRh9s5oTbMJuNeqEjndjk0uR/w674+F7yXs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pDBk0RVc9jDXqJCbZxqjPxy/IffQs9vqD0bpsE8z7TExLB+GuOfZ8/WXeawHQoDsm7nhKsK6OOGdfz1ndJdgmXijB4hRH3UO0UNBWd0g5YVMJmtN3cB2rVy5mOaE+pBqFLlexGSbzN9Iem5TSYqhKC/HvxgIP21V1icRKfepOT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ZmkD16WxkzYQtyX
	for <linux-raid@vger.kernel.org>; Tue, 29 Apr 2025 10:05:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6080F1A1957
	for <linux-raid@vger.kernel.org>; Tue, 29 Apr 2025 10:05:05 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGDPMxBokruCKw--.54499S3;
	Tue, 29 Apr 2025 10:05:05 +0800 (CST)
Subject: Re: [PATCH 2/3] md: replace ->openers with ->active
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai1@huaweicloud.com, ncroxon@redhat.com,
 mtkaczyk@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250428082641.45027-1-xni@redhat.com>
 <20250428082641.45027-3-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f5bdb816-6914-5901-416a-8eeef37c3a9f@huaweicloud.com>
Date: Tue, 29 Apr 2025 10:05:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250428082641.45027-3-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGDPMxBokruCKw--.54499S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr13XFyrAw4rXw4rZw1rXrb_yoW7tw4fpa
	yIqF9xCr4UJrZ0qrsrA3ykuF1Fqw1xKFWvyry7Ca4fZFnxZrsFgF1Ygry8Gr95Ka4fAr4D
	ta18Xa15uFy7Wr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

ÔÚ 2025/04/28 16:26, Xiao Ni Ð´µÀ:
> It only checks openers when stopping an array. But some users still can
> access mddev through sysfs interfaces. Now ->active is added once mddev
> is accessed which is done in function mddev_get protected by lock
> all_mddevs_lock. They are md_open, md_seq_show, md_attr_show/store and
> md_notify_reboot and md_exit.
> 
> ->openers is only added in md_open while mddev_get is called too. So we
> can replace ->openers with ->active. This can guarantee no one access the
> array once MD_CLOSING is set.
> 
> At the same time, ->open_mutex is replaced with all_mddevs_lock. Though
> all_mddevs_lock is a global lock, the only place checks ->active and sets
> MD_CLOSING in ioctl path. So it doesn't affect performance.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 47 +++++++++++++++++------------------------------
>   drivers/md/md.h | 11 -----------
>   2 files changed, 17 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e14253433c49..4ca3d04ce13f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -523,18 +523,27 @@ void mddev_resume(struct mddev *mddev)
>   EXPORT_SYMBOL_GPL(mddev_resume);
>   
>   /* sync bdev before setting device to readonly or stopping raid*/
> -static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev, int opener_num)
> +static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev)
>   {
> -	mutex_lock(&mddev->open_mutex);
> -	if (mddev->pers && atomic_read(&mddev->openers) > opener_num) {
> -		mutex_unlock(&mddev->open_mutex);
> +	spin_lock(&all_mddevs_lock);
> +
> +	/*
> +	 * there are two places that call this function and ->active
> +	 * is added before calling this function. So the array can't
> +	 *  be stopped when ->active is bigger than 1.
> +	 */
> +	if (mddev->pers && atomic_read(&mddev->active) > 1) {

I think this is not a good idea, this will introduce new synchronization
that read/write sysfs APIs will forbid ioctl to stop array. If you
really want to do this, you must also forbid new sysfs APIs and wait for
inflight sysfs APIs to be done, however, this looks more complicated.

Thanks,
Kuai

> +
> +		spin_unlock(&all_mddevs_lock);
>   		return -EBUSY;
>   	}
> +
>   	if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
> -		mutex_unlock(&mddev->open_mutex);
> +		spin_unlock(&all_mddevs_lock);
>   		return -EBUSY;
>   	}
> -	mutex_unlock(&mddev->open_mutex);
> +
> +	spin_unlock(&all_mddevs_lock);
>   
>   	sync_blockdev(mddev->gendisk->part0);
>   	return 0;
> @@ -663,7 +672,6 @@ int mddev_init(struct mddev *mddev)
>   	/* We want to start with the refcount at zero */
>   	percpu_ref_put(&mddev->writes_pending);
>   
> -	mutex_init(&mddev->open_mutex);
>   	mutex_init(&mddev->reconfig_mutex);
>   	mutex_init(&mddev->suspend_mutex);
>   	mutex_init(&mddev->bitmap_info.mutex);
> @@ -672,7 +680,6 @@ int mddev_init(struct mddev *mddev)
>   	INIT_LIST_HEAD(&mddev->deleting);
>   	timer_setup(&mddev->safemode_timer, md_safemode_timeout, 0);
>   	atomic_set(&mddev->active, 1);
> -	atomic_set(&mddev->openers, 0);
>   	atomic_set(&mddev->sync_seq, 0);
>   	spin_lock_init(&mddev->lock);
>   	init_waitqueue_head(&mddev->sb_wait);
> @@ -4421,8 +4428,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>   	case read_auto:
>   		if (!mddev->pers || !md_is_rdwr(mddev))
>   			break;
> -		/* write sysfs will not open mddev and opener should be 0 */
> -		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
> +		err = mddev_set_closing_and_sync_blockdev(mddev);
>   		if (err)
>   			return err;
>   		break;
> @@ -7738,7 +7744,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
>   		/* Need to flush page cache, and ensure no-one else opens
>   		 * and writes
>   		 */
> -		err = mddev_set_closing_and_sync_blockdev(mddev, 1);
> +		err = mddev_set_closing_and_sync_blockdev(mddev);
>   		if (err)
>   			return err;
>   	}
> @@ -7938,7 +7944,6 @@ static int md_set_read_only(struct block_device *bdev, bool ro)
>   static int md_open(struct gendisk *disk, blk_mode_t mode)
>   {
>   	struct mddev *mddev;
> -	int err;
>   
>   	spin_lock(&all_mddevs_lock);
>   	mddev = mddev_get(disk->private_data);
> @@ -7946,25 +7951,8 @@ static int md_open(struct gendisk *disk, blk_mode_t mode)
>   	if (!mddev)
>   		return -ENODEV;
>   
> -	err = mutex_lock_interruptible(&mddev->open_mutex);
> -	if (err)
> -		goto out;
> -
> -	err = -ENODEV;
> -	if (test_bit(MD_CLOSING, &mddev->flags))
> -		goto out_unlock;
> -
> -	atomic_inc(&mddev->openers);
> -	mutex_unlock(&mddev->open_mutex);
> -
>   	disk_check_media_change(disk);
>   	return 0;
> -
> -out_unlock:
> -	mutex_unlock(&mddev->open_mutex);
> -out:
> -	mddev_put(mddev);
> -	return err;
>   }
>   
>   static void md_release(struct gendisk *disk)
> @@ -7972,7 +7960,6 @@ static void md_release(struct gendisk *disk)
>   	struct mddev *mddev = disk->private_data;
>   
>   	BUG_ON(!mddev);
> -	atomic_dec(&mddev->openers);
>   	mddev_put(mddev);
>   }
>   
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index a9dccb3d84ed..60dc0943e05b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -496,19 +496,8 @@ struct mddev {
>   	int				recovery_disabled;
>   
>   	int				in_sync;	/* know to not need resync */
> -	/* 'open_mutex' avoids races between 'md_open' and 'do_md_stop', so
> -	 * that we are never stopping an array while it is open.
> -	 * 'reconfig_mutex' protects all other reconfiguration.
> -	 * These locks are separate due to conflicting interactions
> -	 * with disk->open_mutex.
> -	 * Lock ordering is:
> -	 *  reconfig_mutex -> disk->open_mutex
> -	 *  disk->open_mutex -> open_mutex:  e.g. __blkdev_get -> md_open
> -	 */
> -	struct mutex			open_mutex;
>   	struct mutex			reconfig_mutex;
>   	atomic_t			active;		/* general refcount */
> -	atomic_t			openers;	/* number of active opens */
>   
>   	int				changed;	/* True if we might need to
>   							 * reread partition info */
> 

