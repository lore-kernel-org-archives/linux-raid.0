Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36C52BE02C;
	Sat, 20 Sep 2025 09:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758362089; cv=pass; b=TUzy6cjbhbXLchjyMZHVgun7+cxnZMOAKL74PTsD9f2zZTUT+dtN09xBrkhcUHvOEAKGxwh3ZBCJfbw8X3LLsnIejiczjk9RCuPlE5JC8bX2RUbuL82sh+UJPxhHb0M6WY/Xe+OfDU1vBmHj0Q/LC7ZWcrn7bov361m6eB+aZ5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758362089; c=relaxed/simple;
	bh=KWQfePgXddwFd0Gk5BYgPFbgbEZBdXGjHQYPHrGTczA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAcJ9d99jiQVTuxtAXZVKqvDFkcXFruxlMNlX9e8wT0FAJjIUgv0AxGw/k06hEuyxxFJ9pY55W8NXrjAt3yYi1VwyD0ar2ACwAmlcJy8Xlp22dEgiwHAj2VS6C9owUWXj2HDe/URPdGKvHzzmoD2ZSfaUdW1l58Nek3AcaN6A6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=TtGKhf/c; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="TtGKhf/c"
ARC-Seal: i=1; a=rsa-sha256; t=1758362055; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=c+NmoLhOjA6FQnoFfQx/eBdzyEDdY+QZjwik1Ho7k+X2UJYjRV6ThIpNrbAaPOhTq8DFacn96pRpvuPIkJL1YcmxBW+i82Rxt3R7wJ38fXr98iOA/hmv5Meanp4TrGr8QYOhVpAyY0VEuzEUaBrmXgEFZ/TfeRNR9HMofl5x1ZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1758362055; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=SVm5bc+Jd9FLAMO+Tj/zbIrlf8uOoE/IqtAPLR3fPSU=; 
	b=NjvQNI73a7v7/GzcfkMkNmnrpirB5cdTLWdgTzcXgxTCEKijFaa8WM3v6PV+3yUHAGcnC9Pzq35CD7GmMey2S3p16F+qx40dAJa7/y7glBtDdYwIJY7HzOPSPHgvxhUoBCGgMkHxlcEX8RWcH+7pB8JYUVbLchdY6F3w/l0LqKw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1758362055;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=SVm5bc+Jd9FLAMO+Tj/zbIrlf8uOoE/IqtAPLR3fPSU=;
	b=TtGKhf/c0+ktWdJG0PObvX+pUlYdoQwHS6UdtWodN8v1s7TocpZlUULAfzDTL7HA
	VHeNvTzJ+KW8uh/9CLsC/yNH/i/P2hZEIvaPgJUKDqmXwFPm8f/Hr8hIfaWGMih3mnh
	MnMo8U0MLD1667Dc8spNNkoTRS1MhezfSh9n3LSI=
Received: by mx.zohomail.com with SMTPS id 1758362052290800.2558743226634;
	Sat, 20 Sep 2025 02:54:12 -0700 (PDT)
Message-ID: <39f18982-813a-4bf5-8866-ddedf6fe664b@yukuai.org.cn>
Date: Sat, 20 Sep 2025 17:54:08 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] md: prevent incorrect update of resync/recovery offset
To: linan666@huaweicloud.com, song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 pmenzel@molgen.mpg.de, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250904073452.3408516-1-linan666@huaweicloud.com>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <20250904073452.3408516-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

在 2025/9/4 15:34, linan666@huaweicloud.com 写道:

> From: Li Nan <linan122@huawei.com>
>
> In md_do_sync(), when md_sync_action returns ACTION_FROZEN, subsequent
> call to md_sync_position() will return MaxSector. This causes
> 'curr_resync' (and later 'recovery_offset') to be set to MaxSector too,
> which incorrectly signals that recovery/resync has completed, even though
> disk data has not actually been updated.
>
> To fix this issue, skip updating any offset values when the sync action
> is FROZEN. The same holds true for IDLE.
>
> Fixes: 7d9f107a4e94 ("md: use new helpers in md_do_sync()")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
> v3: add INTR flag, otherwise resync_min/max will be updated incorrectly.
> v2: fix typo.
>
>   drivers/md/md.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e78f80d39271..f926695311a2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9397,6 +9397,11 @@ void md_do_sync(struct md_thread *thread)
>   	}
>   
>   	action = md_sync_action(mddev);
> +	if (action == ACTION_FROZEN || action == ACTION_IDLE) {
> +		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		goto skip;
> +	}
> +
>   	desc = md_sync_action_name(action);
>   	mddev->last_sync_action = action;
>   

Applied to md-6.18
Thanks

