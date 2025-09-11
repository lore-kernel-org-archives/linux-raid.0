Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB3E22AE5D;
	Thu, 11 Sep 2025 03:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757560581; cv=none; b=hpQIswUX/VcMS4TzB+UgjawVjLdlsQeo24evo+m6g1Lvwo8oOa8GugzZ/fofFISPzGcsoy0/NdLMSf3ECCUP1C3MmlxZrsdnxnxv1veddtsswGjO1nzhLfT6mD5Exa4kVB6blfK3ksJxPTKP3tcKTB3LI9mgc0d35/j17fpkPjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757560581; c=relaxed/simple;
	bh=BCic20U1W6tjlE9fQUq/4Xj/TUPn96EwmRRFUqjcqHs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qo1LB6294KU9v01IOufgbAK1c1XBznR/ToBwEF5OrDNhCNapQhZU2hTW/fxACnVFNryES250/WGu7zGQdS8lsiQmTSeulpdDfWMa26F/ak46sSpadOuMbTOM54swiKZY72UEuqF+rOxkAQYUxr/VC/Vuj6U1B7ORHPn2nz5NGq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cMjPq0mBMzKHMtt;
	Thu, 11 Sep 2025 11:16:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 619551A135D;
	Thu, 11 Sep 2025 11:16:15 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAncY39PsJogZxrCA--.9809S3;
	Thu, 11 Sep 2025 11:16:15 +0800 (CST)
Subject: Re: [PATCH 2/3] md: fix incorrect sync progress update on sync read
 errors
To: linan666@huaweicloud.com, song@kernel.org, neil@brown.name,
 namhyung@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250911020441.2858174-1-linan666@huaweicloud.com>
 <20250911020441.2858174-2-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <319b7c8e-7595-d4a5-b9a2-11ebea670281@huaweicloud.com>
Date: Thu, 11 Sep 2025 11:16:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250911020441.2858174-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncY39PsJogZxrCA--.9809S3
X-Coremail-Antispam: 1UD129KBjvJXoW3AF4UuFyftw47Cr1xuF4Durg_yoW7WFykp3
	93XasxKr1UZFWaqFWUXw1DAFZ5ZrWjyFWDtrWag3yxJw1rtr17GFyY93W8JryDJ3sYya1F
	q34rJrsxZ3WUWaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/09/11 10:04, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> When a sync read fails and badblocks recording fails (exceeding the 512),

I think it's better to faulty this rdev directly, user really need to
replace this disk ASAP.

Thanks,
Kuai

> the device is not immediately marked Faulty. Instead, 'recovery_disabled'
> is set, and non-In_sync devices are removed later. This preserves array
> availability: if users never read the damaged region, the raid remains
> available and gains fault tolerance.
> 
> However, during the brief window before the device removal,
> resync/recovery_offset was incorrectly updated to include the bad sectors.
> This could lead to inconsistent data being read from those sectors.
> 
> Fix it by:
>   - Set MD_RECOVERY_ERROR when bad block recording fails for sync reads.
>   - Do not update curr_resync_completed if MD_RECOVERY_ERROR set.
>   - Use curr_resync_completed as the final resync progress indicator.
> 
> Fixes: 5e5702898e93 ("md/raid10: Handle read errors during recovery better.")
> Fixes: 3a9f28a5117e ("md/raid1: improve handling of read failure during recovery.")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c     | 48 ++++++++++++++++++---------------------------
>   drivers/md/raid10.c |  2 +-
>   2 files changed, 20 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0094830126b4..f3abfc140481 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9470,18 +9470,20 @@ void md_do_sync(struct md_thread *thread)
>   		     time_after_eq(jiffies, update_time + UPDATE_FREQUENCY) ||
>   		     (j - mddev->curr_resync_completed)*2
>   		     >= mddev->resync_max - mddev->curr_resync_completed ||
> -		     mddev->curr_resync_completed > mddev->resync_max
> -			    )) {
> +		     mddev->curr_resync_completed > mddev->resync_max)) {
>   			/* time to update curr_resync_completed */
>   			wait_event(mddev->recovery_wait,
>   				   atomic_read(&mddev->recovery_active) == 0);
> -			mddev->curr_resync_completed = j;
> -			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
> -			    j > mddev->resync_offset)
> -				mddev->resync_offset = j;
> -			update_time = jiffies;
> -			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
> -			sysfs_notify_dirent_safe(mddev->sysfs_completed);
> +
> +			if (!test_bit(MD_RECOVERY_ERROR, &mddev->recovery)) {
> +				mddev->curr_resync_completed = j;
> +				if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
> +				    j > mddev->resync_offset)
> +					mddev->resync_offset = j;
> +				update_time = jiffies;
> +				set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
> +				sysfs_notify_dirent_safe(mddev->sysfs_completed);
> +			}
>   		}
>   
>   		while (j >= mddev->resync_max &&
> @@ -9594,7 +9596,7 @@ void md_do_sync(struct md_thread *thread)
>   	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
>   
>   	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> -	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
> +	    !test_bit(MD_RECOVERY_ERROR, &mddev->recovery) &&
>   	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
>   		mddev->curr_resync_completed = mddev->curr_resync;
>   		sysfs_notify_dirent_safe(mddev->sysfs_completed);
> @@ -9602,32 +9604,20 @@ void md_do_sync(struct md_thread *thread)
>   	mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
>   
>   	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
> -	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
> +	    mddev->curr_resync_completed > MD_RESYNC_ACTIVE) {
> +		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> +			mddev->curr_resync_completed = MaxSector;
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
> +			mddev->resync_offset = mddev->curr_resync_completed;
>   		} else {
> -			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> -				mddev->curr_resync = MaxSector;
>   			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>   			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
>   				rcu_read_lock();
>   				rdev_for_each_rcu(rdev, mddev)
>   					if (mddev->delta_disks >= 0 &&
> -					    rdev_needs_recovery(rdev, mddev->curr_resync))
> -						rdev->recovery_offset = mddev->curr_resync;
> +					    rdev_needs_recovery(rdev, mddev->curr_resync_completed))
> +						rdev->recovery_offset = mddev->curr_resync_completed;
>   				rcu_read_unlock();
>   			}
>   		}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 02e1c3db70ca..c3cfbb0347e7 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2543,7 +2543,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
>   
>   					conf->mirrors[dw].recovery_disabled
>   						= mddev->recovery_disabled;
> -					set_bit(MD_RECOVERY_INTR,
> +					set_bit(MD_RECOVERY_ERROR,
>   						&mddev->recovery);
>   					break;
>   				}
> 

