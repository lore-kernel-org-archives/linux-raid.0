Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7C41A9F99;
	Tue, 12 Aug 2025 07:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984366; cv=none; b=RwUT3KqHYsRqsv1XAl35bxaH8NYpB5Y9gecGAZj1zaGBx6EObwnP81K8wxwy6pbRccSekzZW/9xfYWHriv0dPYfYJM/caO9lZZuOkZZpm66fTo/o8z904GsrPH2fuWNUQ+u4KHaXS58VErEmgDbAWYXtpX5xkzysn3R5Tc0OPBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984366; c=relaxed/simple;
	bh=XKD7DlFpMgjKkbysOhN5zMLBr97T/g9HvMvGTtflrVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HoQd2jWHfVnJJJXmryLSsjI11mp1sMrqpWdAWbnRNbuqhTrZ39Nid8+tFpB3xyRkcutqBKbYFEuX7OQpXBYurg8U7+FB6Zcn+KNvkoqz5l+hCgnQaeuaBcVdKnQzKlqmM7fW2E57oqCc7SDSA8itqYam0MSUqTInD2d2YOWrvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.13.134] (g389.RadioFreeInternet.molgen.mpg.de [141.14.13.134])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0E68561E647B3;
	Tue, 12 Aug 2025 09:38:41 +0200 (CEST)
Message-ID: <613fed75-efb7-46b8-8598-3b32f4f0b012@molgen.mpg.de>
Date: Tue, 12 Aug 2025 09:38:40 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] md: add helper rdev_needs_recovery()
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linan122@huawei.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com
References: <20250812021738.3722569-1-zhengqixing@huaweicloud.com>
 <20250812021738.3722569-2-zhengqixing@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250812021738.3722569-2-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Zheng,


Thank you for your patch.

Am 12.08.25 um 04:17 schrieb Zheng Qixing:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Add a helper for checking if an rdev needs recovery.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..4ea956a80343 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4835,6 +4835,16 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
>   static struct md_sysfs_entry md_metadata =
>   __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
>   
> +static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
> +{
> +	if (!test_bit(Journal, &rdev->flags) &&
> +	    !test_bit(Faulty, &rdev->flags) &&
> +	    !test_bit(In_sync, &rdev->flags) &&
> +	    rdev->recovery_offset < sectors)
> +		return true;
> +	return false;
> +}
> +
>   enum sync_action md_sync_action(struct mddev *mddev)
>   {
>   	unsigned long recovery = mddev->recovery;
> @@ -8969,10 +8979,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
>   		rcu_read_lock();
>   		rdev_for_each_rcu(rdev, mddev)
>   			if (rdev->raid_disk >= 0 &&
> -			    !test_bit(Journal, &rdev->flags) &&
> -			    !test_bit(Faulty, &rdev->flags) &&
> -			    !test_bit(In_sync, &rdev->flags) &&
> -			    rdev->recovery_offset < start)
> +			    rdev_needs_recovery(rdev, start))
>   				start = rdev->recovery_offset;
>   		rcu_read_unlock();
>   
> @@ -9333,10 +9340,7 @@ void md_do_sync(struct md_thread *thread)
>   				rdev_for_each_rcu(rdev, mddev)
>   					if (rdev->raid_disk >= 0 &&
>   					    mddev->delta_disks >= 0 &&
> -					    !test_bit(Journal, &rdev->flags) &&
> -					    !test_bit(Faulty, &rdev->flags) &&
> -					    !test_bit(In_sync, &rdev->flags) &&
> -					    rdev->recovery_offset < mddev->curr_resync)
> +					    rdev_needs_recovery(rdev, mddev->curr_resync))
>   						rdev->recovery_offset = mddev->curr_resync;
>   				rcu_read_unlock();
>   			}

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
