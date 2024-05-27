Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCB563B;
	Mon, 27 May 2024 01:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716772122; cv=none; b=M5JIru8bh9pj+EQzrhouhzz73nlNPOjiohTdy6Mr/DZJ580yA6YSJYdrDgQuRndNKwWnfqlC5DulxYBjIcQLYACGBt2h0FvZW2qDC14rc0SaL3ld5B88pDuCZlfbLdkz7BNmKGTSsVe8mu17xGAxkkphW1U1kiAnBl4iW92V0fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716772122; c=relaxed/simple;
	bh=aI+EFZH1rjfUKSaYYHxiFlWEFPTZhL+Hgux59hPbcqc=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gfSQ145mHdtf5U5IVqEjo3IutpRiKtRB/GQjzD14AxJqWLJbYU28uK0gOZKYOsJYEKma4j9+g89o1jGZ7VPn2ny4v21135DEHk1v/Ov62garQ3trvxOUVVlhE0Lh57lViRRFgUn+QLJE50Vt1T9Qodbp2hNfjSp1eSuaT/5GW5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Vnctj3wKfzcd27;
	Mon, 27 May 2024 09:07:09 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 44FEE14037D;
	Mon, 27 May 2024 09:08:29 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 27 May 2024 09:08:28 +0800
Subject: Re: [PATCH AUTOSEL 6.9 02/15] md: Fix overflow in is_mddev_idle
To: Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
CC: Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	<axboe@kernel.dk>, <linux-raid@vger.kernel.org>,
	<linux-block@vger.kernel.org>
References: <20240526094152.3412316-1-sashal@kernel.org>
 <20240526094152.3412316-2-sashal@kernel.org>
From: Yu Kuai <yukuai3@huawei.com>
Message-ID: <217cd112-b5cb-9b6b-9dc9-b11490c2f137@huawei.com>
Date: Mon, 27 May 2024 09:08:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240526094152.3412316-2-sashal@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Hi,

ÔÚ 2024/05/26 17:41, Sasha Levin Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> [ Upstream commit 3f9f231236ce7e48780d8a4f1f8cb9fae2df1e4e ]
> 
> UBSAN reports this problem:
> 
>    UBSAN: Undefined behaviour in drivers/md/md.c:8175:15
>    signed integer overflow:
>    -2147483291 - 2072033152 cannot be represented in type 'int'
>    Call trace:
>     dump_backtrace+0x0/0x310
>     show_stack+0x28/0x38
>     dump_stack+0xec/0x15c
>     ubsan_epilogue+0x18/0x84
>     handle_overflow+0x14c/0x19c
>     __ubsan_handle_sub_overflow+0x34/0x44
>     is_mddev_idle+0x338/0x3d8
>     md_do_sync+0x1bb8/0x1cf8
>     md_thread+0x220/0x288
>     kthread+0x1d8/0x1e0
>     ret_from_fork+0x10/0x18
> 
> 'curr_events' will overflow when stat accum or 'sync_io' is greater than
> INT_MAX.
> 
> Fix it by changing sync_io, last_events and curr_events to 64bit.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Link: https://lore.kernel.org/r/20240117031946.2324519-2-linan666@huaweicloud.com
> Signed-off-by: Song Liu <song@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi, please notice that this patch doesn't fix real issue expect for
the ubsan warning, and this patch is reverted:
> ---
>   drivers/md/md.c        | 7 ++++---
>   drivers/md/md.h        | 4 ++--
>   include/linux/blkdev.h | 2 +-
>   3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e575e74aabf5e..c88b50a4be82f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8576,14 +8576,15 @@ static int is_mddev_idle(struct mddev *mddev, int init)
>   {
>   	struct md_rdev *rdev;
>   	int idle;
> -	int curr_events;
> +	long long curr_events;
>   
>   	idle = 1;
>   	rcu_read_lock();
>   	rdev_for_each_rcu(rdev, mddev) {
>   		struct gendisk *disk = rdev->bdev->bd_disk;
> -		curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
> -			      atomic_read(&disk->sync_io);
> +		curr_events =
> +			(long long)part_stat_read_accum(disk->part0, sectors) -
> +			atomic64_read(&disk->sync_io);
>   		/* sync IO will cause sync_io to increase before the disk_stats
>   		 * as sync_io is counted when a request starts, and
>   		 * disk_stats is counted when it completes.
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 097d9dbd69b83..d0db98c0d33be 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -51,7 +51,7 @@ struct md_rdev {
>   
>   	sector_t sectors;		/* Device size (in 512bytes sectors) */
>   	struct mddev *mddev;		/* RAID array if running */
> -	int last_events;		/* IO event timestamp */
> +	long long last_events;		/* IO event timestamp */
>   
>   	/*
>   	 * If meta_bdev is non-NULL, it means that a separate device is
> @@ -621,7 +621,7 @@ extern void mddev_unlock(struct mddev *mddev);
>   
>   static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
>   {
> -	atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
> +	atomic64_add(nr_sectors, &bdev->bd_disk->sync_io);
>   }
>   
>   static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 69e7da33ca49a..f10fb01a629fb 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -174,7 +174,7 @@ struct gendisk {
>   	struct list_head slave_bdevs;
>   #endif
>   	struct timer_rand_state *random;
> -	atomic_t sync_io;		/* RAID */
> +	atomic64_t sync_io;		/* RAID */
>   	struct disk_events *ev;
>   
>   #ifdef CONFIG_BLK_DEV_ZONED
> 
