Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DEE82D7F;
	Mon, 26 Aug 2024 08:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724659853; cv=none; b=KuLekPBwB0RTMx6oaspDOtm4OFJwkQ92ATe4pZk6aTjuXb8GxKq11Hg/tZEKWTPtuMTu715r6c5Zm2lgzVv8AFShohDM6XVX6jqgVsNV0zwokSs1oFb+z/XSVIYyo3ybuT8uafpsY6ufBj504dDKMsKZy5OigafPYHmJBhbvkGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724659853; c=relaxed/simple;
	bh=4li89C+k10Z6jV6GIvOq3bmgKwqbj4ZSssX7A9oEgiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oTlQdoTTNIWgGAlmEuVnZiG0fVoLL0RasZcwGxklQaAufiXuozgD+CX7w/M608aXw7+0tRWBmzWvD8g7PNQyPrSNhZbZvQcceAGmkxRQjn8MfUoAlIyVG7IaoFZrkELCYK8fhfOJb1OisIGJRw2KUK0Vg3c0eRDVaK+mgZKH6xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.53] (ip5f5aead7.dynamic.kabel-deutschland.de [95.90.234.215])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3E39361E5FE05;
	Mon, 26 Aug 2024 10:09:54 +0200 (CEST)
Message-ID: <dedf0d3b-bc45-4d04-a987-9df498f51661@molgen.mpg.de>
Date: Mon, 26 Aug 2024 10:09:53 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.12 v2 29/42] md/md-bitmap: mrege
 md_bitmap_cond_end_sync() into bitmap_operations
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, xni@redhat.com, song@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
 <20240826074452.1490072-30-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240826074452.1490072-30-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Thank you for your patch. (I am still confused, what your given and 
surname is.)

Am 26.08.24 um 09:44 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>

There is a typo in the summary: mrege → merge.

> So that the implementation won't be exposed, and it'll be possible
> to invent a new bitmap by replacing bitmap_operations.
> 
> Also change the parameter from bitmap to mddev, to avoid access
> bitmap outside md-bitmap.c as much as possible.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md-bitmap.c | 6 ++++--
>   drivers/md/md-bitmap.h | 2 +-
>   drivers/md/raid1.c     | 6 +++---
>   drivers/md/raid10.c    | 2 +-
>   drivers/md/raid5.c     | 2 +-
>   5 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index e1dceff2d9a5..2d9d9689f721 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1690,10 +1690,12 @@ static void bitmap_close_sync(struct mddev *mddev)
>   	}
>   }
>   
> -void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
> +static void bitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
> +				 bool force)
>   {
>   	sector_t s = 0;
>   	sector_t blocks;
> +	struct bitmap *bitmap = mddev->bitmap;
>   
>   	if (!bitmap)
>   		return;
> @@ -1718,7 +1720,6 @@ void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
>   	bitmap->last_end_sync = jiffies;
>   	sysfs_notify_dirent_safe(bitmap->mddev->sysfs_completed);
>   }
> -EXPORT_SYMBOL(md_bitmap_cond_end_sync);
>   
>   void md_bitmap_sync_with_cluster(struct mddev *mddev,
>   			      sector_t old_lo, sector_t old_hi,
> @@ -2747,6 +2748,7 @@ static struct bitmap_operations bitmap_ops = {
>   	.endwrite		= bitmap_endwrite,
>   	.start_sync		= bitmap_start_sync,
>   	.end_sync		= bitmap_end_sync,
> +	.cond_end_sync		= bitmap_cond_end_sync,
>   	.close_sync		= bitmap_close_sync,
>   
>   	.update_sb		= bitmap_update_sb,
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 5d919b530317..027de097f96a 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -262,6 +262,7 @@ struct bitmap_operations {
>   	bool (*start_sync)(struct mddev *mddev, sector_t offset,
>   			   sector_t *blocks, bool degraded);
>   	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
> +	void (*cond_end_sync)(struct mddev *mddev, sector_t sector, bool force);
>   	void (*close_sync)(struct mddev *mddev);
>   
>   	void (*update_sb)(struct bitmap *bitmap);
> @@ -272,7 +273,6 @@ struct bitmap_operations {
>   void mddev_set_bitmap_ops(struct mddev *mddev);
>   
>   /* these are exported */
> -void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
>   void md_bitmap_sync_with_cluster(struct mddev *mddev,
>   				 sector_t old_lo, sector_t old_hi,
>   				 sector_t new_lo, sector_t new_hi);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 52ca5619d9b4..00174cacb1f4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2828,9 +2828,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>   	 * sector_nr + two times RESYNC_SECTORS
>   	 */
>   
> -	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
> -		mddev_is_clustered(mddev) && (sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
> -
> +	mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
> +		mddev_is_clustered(mddev) &&
> +		(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
>   
>   	if (raise_barrier(conf, sector_nr))
>   		return 0;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5b1c86c368b1..5a7b19f48c45 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3543,7 +3543,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>   		 * safety reason, which ensures curr_resync_completed is
>   		 * updated in bitmap_cond_end_sync.
>   		 */
> -		md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
> +		mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
>   					mddev_is_clustered(mddev) &&
>   					(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
>   
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d2b8d2517abf..87b8d19ab601 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6540,7 +6540,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
>   		return sync_blocks * RAID5_STRIPE_SECTORS(conf);
>   	}
>   
> -	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr, false);
> +	mddev->bitmap_ops->cond_end_sync(mddev, sector_nr, false);
>   
>   	sh = raid5_get_active_stripe(conf, NULL, sector_nr,
>   				     R5_GAS_NOBLOCK);

The diff looks good to me.


Kind regards,

Paul
