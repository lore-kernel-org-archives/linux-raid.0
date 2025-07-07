Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19786288530;
	Mon,  7 Jul 2025 08:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751876761; cv=none; b=h0zFro2GKSdyrtMrunO7HdYQe1ZHiEafTSa7kC1wQXv69ktZt4kmMi5d3cjRW2d42njYqALShX5rloX0FP2VoTOwdeBgiXUX786gMkmyQoQ8hh7LwYRKB1ILg9vYcr2/ewkKF+bePetUoX87jzt1w0b9lp0vKwmsFfmcJjJgeX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751876761; c=relaxed/simple;
	bh=bP139+8C1wJwvg0E5XAk1ETIbH4Do4HXk3wI2vvnOtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bn15ugZzfBMrtnIolzOecUP2Fb48e13v1Ol6wT+eZuJcE/wkZsrhXCk/DD7G+DtfxF8CU1FXhvAaI4HTQw81QIhUZFrwpMC/NUjYPbzof/HWUg1U/XHlUGCGHKPgJcCU0/bh+p2uBVRQog6/U4Jq3FpGYqKmAagZlgrBSf0kO+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bbHPb4QSfzKHMhh;
	Mon,  7 Jul 2025 16:25:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 1478D1A0EEC;
	Mon,  7 Jul 2025 16:25:54 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP3 (Coremail) with SMTP id _Ch0CgAXeCWPhGtoxpywAw--.45030S3;
	Mon, 07 Jul 2025 16:25:53 +0800 (CST)
Message-ID: <8b58c4c4-dd16-6c4d-369e-65d5dd7cf269@huaweicloud.com>
Date: Mon, 7 Jul 2025 16:25:51 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: allow removing faulty rdev during resync
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com
References: <20250707075412.150301-1-zhengqixing@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250707075412.150301-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAXeCWPhGtoxpywAw--.45030S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJw1xuw4xKFWxKr4rGw1UGFg_yoW5WFyUpa
	1xt3Z8Gr4UJ34fGa1UW34DGa45Xr18XrW8try7Wa4fA3ZxAr92ga4fW3WjvryYyasYgF4r
	Xw18K3y5Cw1SqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/7/7 15:54, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> During RAID resync, faulty rdev cannot be removed and will result in
> "Device or resource busy" error when attempting hot removal.
> 
> Reproduction steps:
>    mdadm -Cv /dev/md0 -l1 -n3 -e1.2 /dev/sd{b..d}
>    mdadm /dev/md0 -f /dev/sdb
>    mdadm /dev/md0 -r /dev/sdb
>    -> mdadm: hot remove failed for /dev/sdb: Device or resource busy
> 
> After commit 4b10a3bc67c1 ("md: ensure resync is prioritized over
> recovery"), when a device becomes faulty during resync, the
> md_choose_sync_action() function returns early without calling
> remove_and_add_spares(), preventing faulty device removal.
> 
> This patch extracts a helper function remove_spares() to support
> removing faulty devices during RAID resync operations.
> 
> Fixes: 4b10a3bc67c1 ("md: ensure resync is prioritized over recovery")
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md.c | 24 +++++++++++++++++-------
>   1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0f03b21e66e4..7f5e5a16243a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9456,17 +9456,11 @@ static bool md_spares_need_change(struct mddev *mddev)
>   	return false;
>   }
>   
> -static int remove_and_add_spares(struct mddev *mddev,
> -				 struct md_rdev *this)
> +static int remove_spares(struct mddev *mddev, struct md_rdev *this)
>   {
>   	struct md_rdev *rdev;
> -	int spares = 0;
>   	int removed = 0;
>   
> -	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> -		/* Mustn't remove devices when resync thread is running */
> -		return 0;
> -
>   	rdev_for_each(rdev, mddev) {
>   		if ((this == NULL || rdev == this) && rdev_removeable(rdev) &&
>   		    !mddev->pers->hot_remove_disk(mddev, rdev)) {
> @@ -9480,6 +9474,21 @@ static int remove_and_add_spares(struct mddev *mddev,
>   	if (removed && mddev->kobj.sd)
>   		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
>   
> +	return removed;
> +}
> +
> +static int remove_and_add_spares(struct mddev *mddev,
> +				 struct md_rdev *this)
> +{
> +	struct md_rdev *rdev;
> +	int spares = 0;
> +	int removed = 0;
> +
> +	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> +		/* Mustn't remove devices when resync thread is running */
> +		return 0;
> +
> +	removed = remove_spares(mddev, this);
>   	if (this && removed)
>   		goto no_add;
>   
> @@ -9522,6 +9531,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
>   
>   	/* Check if resync is in progress. */
>   	if (mddev->recovery_cp < MaxSector) {
> +		remove_spares(mddev, NULL);
>   		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>   		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   		return true;


LGTM, feel free to add

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

