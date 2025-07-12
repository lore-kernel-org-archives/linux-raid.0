Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44D518E25;
	Sat, 12 Jul 2025 09:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752314297; cv=none; b=fSfghLePX4KDvrYH5vGqYuH6huRjsqH64Gu3pCtRsmkCL3VFfDjgYyaiH2Fpu0N16odH680hw14mYGBt91CLorLpS83nliAo2RfZvA0VAV7Z8yAN12mlI0/tfbkcNvAuq4k8/1V/qbv9eQrEXXr5zaiQ1OIWCYsQgtG7jWaD1Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752314297; c=relaxed/simple;
	bh=gnxCaMy1O7KGhqi2MGV44IWDxB3mKIgauizZuOVTC4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kz89V3xJ8sCQGp89WIv7nWr7/4OWPfjmKQdxTdKTy6RbdpA/i7ywl4rZEtSE6PoCoOxdkDENbbuU2Y89n6cvwB3DjHTv3U7tf5Q9EpB5N3RChqf9cv+oueXPnMqoR671UVWkUDV7eogx3YdRT0pgqlkJTE9dZL0m0xB/FFnNzfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vx06zARC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vx06zARC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D24C4CEEF;
	Sat, 12 Jul 2025 09:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752314297;
	bh=gnxCaMy1O7KGhqi2MGV44IWDxB3mKIgauizZuOVTC4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vx06zARCsflsUWxmUROt06Kx7PoCHIVRzI7SSRP0p/Q30Bjr2VV9YDZ9UeJyK0U4t
	 A1RwWDDWyAoB17C5Bnl7gPFzptzqGwJ33n4ybhArrDjHIKvRYfLqEyqcYORUuxlhst
	 KDEUSVqJbvf9dDdn86D3ERmcG017kXF5BMyqy+oMQhKPJrlpxn4CKky6PqGG4000rZ
	 u6U6jA8H5Eaf+XEulSuApH/5R16X1B5hXgYf+DoGtiarvf5SRhWDdOHSS+ETzwuoY3
	 BQKqyAsl10ebXCE6Co3HzdQLM6Uv5e1yH53XA968bOV5J4MHszOX742qBf8TbQoXBG
	 stcsRMa6jUu5g==
Message-ID: <9b504689-6c9a-48b5-882c-8ddfaf43a801@kernel.org>
Date: Sat, 12 Jul 2025 17:58:10 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: allow removing faulty rdev during resync
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai3@huawei.com, linan122@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com
References: <20250707075412.150301-1-zhengqixing@huaweicloud.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <20250707075412.150301-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

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

Applied to md-6.17

Thanks

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
