Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEE48488;
	Thu, 25 Sep 2025 08:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758790262; cv=none; b=j1XcSQsTwyKohQogMskBqcGdNVRnIk562nB9d6xxD6HL6LQFgD3iVzdoa/NpJDWqJo309cWWl/C55EGw+nJ6zrpZbHjY4YdJAhxMT3hesI1qwdgDzAwkmcob7++L1PcGEBMb2p9IHWp/jO7GViS+iRPeli/W/3jmQOhQW6pC5oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758790262; c=relaxed/simple;
	bh=kqyPgax74q2Ym86nQVylM9PwqrF1xsefWTR2RkwFBQw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UlBbNo4IBj8ZixVHcBBFmdLw37MVrwB0gQhAl7bMv3VpbO4utwrECvrjIQexmbTOgn2NI3HP9YbKj7ZRX08vMzDpi8x5oUByYfRHgR8MyoGrLrA8B2vgd+qsnSbxyVzsJOHCS9jvLhPzatRDQw7lXR9eJp5hFw5ZvtDkQkkhS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cXS9N44q6zKHMny;
	Thu, 25 Sep 2025 16:50:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6F2771A1339;
	Thu, 25 Sep 2025 16:50:56 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCna2NuAtVodzcKAw--.12961S3;
	Thu, 25 Sep 2025 16:50:56 +0800 (CST)
Subject: Re: [PATCH 3/7] md: cleanup MD_RECOVERY_ERROR flag
To: linan666@huaweicloud.com, song@kernel.org, neil@brown.name,
 namhyung@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250917093508.456790-1-linan666@huaweicloud.com>
 <20250917093508.456790-4-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d8b4e30a-c711-f5b4-4c48-3c8a7e62c85f@huaweicloud.com>
Date: Thu, 25 Sep 2025 16:50:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250917093508.456790-4-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2NuAtVodzcKAw--.12961S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4Uuw17Jw13Kr18uw1rJFb_yoW5CFWfpa
	93JF9IyrWUAFW3ZFWqqa4DJF95Zr1jyFWqyFWa93yfJasYyF17GFy5u3W7JrWDt34vyF4F
	q3s5GrsxZF18WaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/09/17 17:35, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> The MD_RECOVERY_ERROR flag prevented bad sectors from updating
> 'resync_offset' when badblocks failed to set during sync errors.
> Now that failure to set badblocks definitively marks the disk as
> Faulty, this flag is redundant. In both scenarios (successful
> badblock marking or disk fault), the bad sectors becomes unreadable
> and its handling is considered completed.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.h |  2 --
>   drivers/md/md.c | 22 ++++------------------
>   2 files changed, 4 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ba567b63afd3..07a22f3772d8 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -644,8 +644,6 @@ enum recovery_flags {
>   	MD_RECOVERY_FROZEN,
>   	/* waiting for pers->start() to finish */
>   	MD_RECOVERY_WAIT,
> -	/* interrupted because io-error */
> -	MD_RECOVERY_ERROR,
>   
>   	/* flags determines sync action, see details in enum sync_action */
>   
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 05b6b3145648..c4d765d57af7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8949,7 +8949,6 @@ void md_sync_error(struct mddev *mddev)
>   {
>   	// stop recovery, signal do_sync ....
>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -	set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
>   	md_wakeup_thread(mddev->thread);
>   }
>   EXPORT_SYMBOL(md_sync_error);
> @@ -9598,7 +9597,6 @@ void md_do_sync(struct md_thread *thread)
>   	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
>   
>   	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> -	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&

Not sure why this is removed, otherwise LGTM.

Thanks,
Kuai

>   	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
>   		mddev->curr_resync_completed = mddev->curr_resync;
>   		sysfs_notify_dirent_safe(mddev->sysfs_completed);
> @@ -9607,24 +9605,12 @@ void md_do_sync(struct md_thread *thread)
>   
>   	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
>   	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
> +		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> +			mddev->curr_resync = MaxSector;
> +
>   		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
> -			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> -				if (mddev->curr_resync >= mddev->resync_offset) {
> -					pr_debug("md: checkpointing %s of %s.\n",
> -						 desc, mdname(mddev));
> -					if (test_bit(MD_RECOVERY_ERROR,
> -						&mddev->recovery))
> -						mddev->resync_offset =
> -							mddev->curr_resync_completed;
> -					else
> -						mddev->resync_offset =
> -							mddev->curr_resync;
> -				}
> -			} else
> -				mddev->resync_offset = MaxSector;
> +			mddev->resync_offset = mddev->curr_resync;
>   		} else {
> -			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> -				mddev->curr_resync = MaxSector;
>   			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>   			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
>   				rcu_read_lock();
> 

