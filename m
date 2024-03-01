Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C1F111B1
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 02:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709260713; cv=none; b=otBVa0o9Ag0ER3Nnme7ZJ0NXMkGKNPwnBC4O9w9EsRawHMuDjww7TxZot2fVpBxFTDqch20yL0A1VudQtQNoQyFUXCn5PoCGGRk/r+177M946rc2H61OmkJNNVdt3A1s+YmE2TTIJKYXx2G/dI6OPvCUFDXuEW0F519bdS0iF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709260713; c=relaxed/simple;
	bh=V6upNgmhdmcRUL7ZrX1TciWBwxbBuEsnjF29JjdS9Cs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Nsrw5G0sTIkybIsyJr4Tb/ZdntrRWyFgCsDHIe4758b+7ivp3N5ClYwRGFU455+i8062Q6XK30L8XhJ8lu86ITzJ2HzSZKhJ21wVdgpHsiuRGGI6wlut0dOTutJL58Ug00IJX2jW00zsLYnA1swcj2/0f0uAm48mBtJQtS4B9Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TmC271tkWz4f3jJG
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 10:38:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A3E8B1A07FA
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 10:38:26 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBXKBGgP+FlyLJOFg--.8943S3;
	Fri, 01 Mar 2024 10:38:26 +0800 (CST)
Subject: Re: [PATCH 1/6] md: Revert "md: Don't register sync_thread for
 reshape directly"
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com,
 snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <20240229154941.99557-1-xni@redhat.com>
 <20240229154941.99557-2-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <042093c6-6deb-535c-918e-78160e7addc4@huaweicloud.com>
Date: Fri, 1 Mar 2024 10:38:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240229154941.99557-2-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXKBGgP+FlyLJOFg--.8943S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GrWrGw15GF4UXw1kCr15urg_yoW7GrWUpa
	yrJFn8Ar4UA343ZFW3ta4DuFW5Ww10qrWqyFy3W34rAFn3t3yfJr15uFyUJFWDXa4kta1Y
	qa4rtFWDuFy09aUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
	Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/02/29 23:49, Xiao Ni Ð´µÀ:
> This reverts commit ad39c08186f8a0f221337985036ba86731d6aafe.
> 
> Function stop_sync_thread only wakes up sync task. It also needs to
> wake up sync thread. This problem will be fixed in the following
> patch.

I don't think so, unlike mddev->thread, sync_thread will only be
executed once and must be executed each time it's registered, and caller
must make sure to wake up registered sync_thread.

Thanks,
Kuai
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c     |  5 +----
>   drivers/md/raid10.c | 16 ++++++++++++++--
>   drivers/md/raid5.c  | 29 +++++++++++++++++++++++++++--
>   3 files changed, 42 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9e41a9aaba8b..db4743ba7f6c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9376,7 +9376,6 @@ static void md_start_sync(struct work_struct *ws)
>   	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
>   	int spares = 0;
>   	bool suspend = false;
> -	char *name;
>   
>   	/*
>   	 * If reshape is still in progress, spares won't be added or removed
> @@ -9414,10 +9413,8 @@ static void md_start_sync(struct work_struct *ws)
>   	if (spares)
>   		md_bitmap_write_all(mddev->bitmap);
>   
> -	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
> -			"reshape" : "resync";
>   	rcu_assign_pointer(mddev->sync_thread,
> -			   md_register_thread(md_do_sync, mddev, name));
> +			   md_register_thread(md_do_sync, mddev, "resync"));
>   	if (!mddev->sync_thread) {
>   		pr_warn("%s: could not start resync thread...\n",
>   			mdname(mddev));
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index a5f8419e2df1..7412066ea22c 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4175,7 +4175,11 @@ static int raid10_run(struct mddev *mddev)
>   		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>   		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>   		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> -		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +		rcu_assign_pointer(mddev->sync_thread,
> +			md_register_thread(md_do_sync, mddev, "reshape"));
> +		if (!mddev->sync_thread)
> +			goto out_free_conf;
>   	}
>   
>   	return 0;
> @@ -4569,8 +4573,16 @@ static int raid10_start_reshape(struct mddev *mddev)
>   	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>   	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> -	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +
> +	rcu_assign_pointer(mddev->sync_thread,
> +			   md_register_thread(md_do_sync, mddev, "reshape"));
> +	if (!mddev->sync_thread) {
> +		ret = -EAGAIN;
> +		goto abort;
> +	}
>   	conf->reshape_checkpoint = jiffies;
> +	md_wakeup_thread(mddev->sync_thread);
>   	md_new_event();
>   	return 0;
>   
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6a7a32f7fb91..8497880135ee 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7936,7 +7936,11 @@ static int raid5_run(struct mddev *mddev)
>   		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>   		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>   		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> -		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +		rcu_assign_pointer(mddev->sync_thread,
> +			md_register_thread(md_do_sync, mddev, "reshape"));
> +		if (!mddev->sync_thread)
> +			goto abort;
>   	}
>   
>   	/* Ok, everything is just fine now */
> @@ -8502,8 +8506,29 @@ static int raid5_start_reshape(struct mddev *mddev)
>   	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>   	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
>   	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> -	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +	rcu_assign_pointer(mddev->sync_thread,
> +			   md_register_thread(md_do_sync, mddev, "reshape"));
> +	if (!mddev->sync_thread) {
> +		mddev->recovery = 0;
> +		spin_lock_irq(&conf->device_lock);
> +		write_seqcount_begin(&conf->gen_lock);
> +		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
> +		mddev->new_chunk_sectors =
> +			conf->chunk_sectors = conf->prev_chunk_sectors;
> +		mddev->new_layout = conf->algorithm = conf->prev_algo;
> +		rdev_for_each(rdev, mddev)
> +			rdev->new_data_offset = rdev->data_offset;
> +		smp_wmb();
> +		conf->generation--;
> +		conf->reshape_progress = MaxSector;
> +		mddev->reshape_position = MaxSector;
> +		write_seqcount_end(&conf->gen_lock);
> +		spin_unlock_irq(&conf->device_lock);
> +		return -EAGAIN;
> +	}
>   	conf->reshape_checkpoint = jiffies;
> +	md_wakeup_thread(mddev->sync_thread);
>   	md_new_event();
>   	return 0;
>   }
> 

