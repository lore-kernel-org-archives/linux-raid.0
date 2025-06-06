Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16345283FF9
	for <linux-raid@vger.kernel.org>; Fri,  6 Jun 2025 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749199572; cv=none; b=pPvJqtYqzFHrq5RKCbcVwjwq6gHeSVk1gmqu1c1fbjrzT0N6J2ZpogbiIxoIdTBjM6dkEeo0W2D5RkWLnngUaUuhPuyOg62j3j8hz6lZc8E16Nge0YMaQMkE/jWOXlVm6p+zFZxa6iuEAGZDYssPnfxs/xnB1VJnDGMwjYrT7KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749199572; c=relaxed/simple;
	bh=w2ktm1xYopKkaOncsMcWfVB76GWPaXOHnjgSpDvz86w=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hcbKSUDZbvAjJNlVjpSVLl/HxCTwlSF7p/jFAinGr/73fQPa5bwbz178kwfjJB2TljaRoK+7FJlXMcsQlILnkzPpbaJcsI+ocq41wd48/PM22MarVNkIXVnzPhCcRTlaYIJPD2oz3AAfpviyFMs8jZFws3FrKTpcEsfrdBNUlo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bDFK870YvzYQw3H
	for <linux-raid@vger.kernel.org>; Fri,  6 Jun 2025 16:46:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F31661A0EF8
	for <linux-raid@vger.kernel.org>; Fri,  6 Jun 2025 16:46:03 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl_KqkJo5DmvOg--.59739S3;
	Fri, 06 Jun 2025 16:46:03 +0800 (CST)
Subject: Re: [PATCH 1/3] md: call del_gendisk in control path
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, song@kernel.org, yukuai1@huaweicloud.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250604090742.37089-1-xni@redhat.com>
 <20250604090742.37089-2-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <30a77424-e5f4-ee83-52a2-cab7e3cbc1ed@huaweicloud.com>
Date: Fri, 6 Jun 2025 16:46:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250604090742.37089-2-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl_KqkJo5DmvOg--.59739S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtrW8CFyfArWDCr1DWw45KFg_yoWxGF4xp3
	y8tFWakrWUJFWSgrZrtas7WFy5Zwn7KFWkKry3G34Sya4YqrnF9F15WrWqvryDW3s3Ar4j
	qa18WFs8ua40gFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/06/04 17:07, Xiao Ni Ð´µÀ:
> Now del_gendisk and put_disk are called asynchronously in workqueue work.
> The asynchronous way has a problem that the device node can still exist
> after mdadm --stop command returns in a short window. So udev rule can
> open this device node and create the struct mddev in kernel again. So put
> del_gendisk in control path and still leave put_disk in md_kobj_release
> to avoid uaf of gendisk.
> 
> Function del_gendisk can't be called with reconfig_mutex. If it's called
> with reconfig mutex, a deadlock can happen. del_gendisk waits all sysfs
> files access to finish and sysfs file access waits reconfig mutex. So
> put del_gendisk after releasing reconfig mutex.
> 
> But there is still a window that sysfs can be accessed between mddev_unlock
> and del_gendisk. So some actions (add disk, change level, .e.g) can happen
> which lead unexpected results. MD_DELETED is used to resolve this problem.
> MD_DELETED is set before releasing reconfig mutex and it should be checked
> for these sysfs access which need reconfig mutex. For sysfs access which
> don't need reconfig mutex, del_gendisk will wait them to finish.
> 
> But it doesn't need to do this in function mddev_lock_nointr. There are
> ten places that call it.
> * Five of them are in dm raid which we don't need to care. MD_DELETED is
> only used for md raid.
> * stop_sync_thread, md_do_sync and md_start_sync are related sync request,
> and it needs to wait sync thread to finish before stopping an array.
> * md_ioctl: md_open is called before md_ioctl, so ->openers is added. It
> will fail to stop the array. So it doesn't need to check MD_DELETED here
> * md_set_readonly:
> It needs to call mddev_set_closing_and_sync_blockdev when setting readonly
> or read_auto. So it will fail to stop the array too because MD_CLOSING is
> already set.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 28 +++++++++++++++++++++++-----
>   drivers/md/md.h | 26 ++++++++++++++++++++++++--
>   2 files changed, 47 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0fde115e921f..e58bb80bf2e9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -636,9 +636,6 @@ static void __mddev_put(struct mddev *mddev)
>   	    mddev->ctime || mddev->hold_active)
>   		return;
>   
> -	/* Array is not configured at all, and not held active, so destroy it */
> -	set_bit(MD_DELETED, &mddev->flags);
> -
>   	/*
>   	 * Call queue_work inside the spinlock so that flush_workqueue() after
>   	 * mddev_find will succeed in waiting for the work to be done.
> @@ -873,6 +870,16 @@ void mddev_unlock(struct mddev *mddev)
>   		kobject_del(&rdev->kobj);
>   		export_rdev(rdev, mddev);
>   	}
> +
/*
  * xxx
  */

> +	/* Call del_gendisk after release reconfig_mutex to avoid
> +	 * deadlock (e.g. call del_gendisk under the lock and an
> +	 * access to sysfs files waits the lock)
> +	 * And MD_DELETED is only used for md raid which is set in
> +	 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
> +	 * doesn't need to check MD_DELETED when getting reconfig lock
> +	 */
> +	if (test_bit(MD_DELETED, &mddev->flags))
> +		del_gendisk(mddev->gendisk);
>   }
>   EXPORT_SYMBOL_GPL(mddev_unlock);
>   
> @@ -5774,19 +5781,30 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
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
> @@ -5799,7 +5817,6 @@ static void md_kobj_release(struct kobject *ko)
>   	if (mddev->sysfs_level)
>   		sysfs_put(mddev->sysfs_level);

Since del_gendisk will remove the sysfs_file, should the above sysfs_put
and all other sysfs entries be removed before del_gendisk?

Thanks,
Kuai
>   
> -	del_gendisk(mddev->gendisk);
>   	put_disk(mddev->gendisk);
>   }
>   
> @@ -6646,8 +6663,9 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		mddev->bitmap_info.offset = 0;
>   
>   		export_array(mddev);
> -
>   		md_clean(mddev);
> +		set_bit(MD_DELETED, &mddev->flags);
> +
>   		if (mddev->hold_active == UNTIL_STOP)
>   			mddev->hold_active = 0;
>   	}
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index d45a9e6ead80..de47b2500ef0 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -700,11 +700,26 @@ static inline bool reshape_interrupted(struct mddev *mddev)
>   
>   static inline int __must_check mddev_lock(struct mddev *mddev)
>   {
> -	return mutex_lock_interruptible(&mddev->reconfig_mutex);
> +	int ret = 0;
> +
> +	ret = mutex_lock_interruptible(&mddev->reconfig_mutex);
> +
> +	/* MD_DELETED is set in do_md_stop with reconfig_mutex.
> +	 * So check it here.
> +	 */
> +	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
> +		ret = -EBUSY;
> +		mutex_unlock(&mddev->reconfig_mutex);
> +	}
> +
> +	return ret;
>   }
>   
>   /* Sometimes we need to take the lock in a situation where
>    * failure due to interrupts is not acceptable.
> + * It doesn't need to check MD_DELETED here, the owner which
> + * holds the lock here can't be stopped. And all paths can't
> + * call this function after do_md_stop.
>    */
>   static inline void mddev_lock_nointr(struct mddev *mddev)
>   {
> @@ -713,7 +728,14 @@ static inline void mddev_lock_nointr(struct mddev *mddev)
>   
>   static inline int mddev_trylock(struct mddev *mddev)
>   {
> -	return mutex_trylock(&mddev->reconfig_mutex);
> +	int ret = 0;
> +
> +	ret = mutex_trylock(&mddev->reconfig_mutex);
> +	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
> +		ret = -EBUSY;
> +		mutex_unlock(&mddev->reconfig_mutex);
> +	}
> +	return ret;
>   }
>   extern void mddev_unlock(struct mddev *mddev);
>   
> 

