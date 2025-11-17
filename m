Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B242FD1AD;
	Mon, 17 Nov 2025 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763398669; cv=none; b=PLSQP5dqI89WCE6ReMs6pxpPpnaUBkt26SuyemQTUx2fyeSUQWgCtx+OyUQUahMnyxqOog+lPNFiXcTuVqdaHBB6OYTKRbqDEEPOddQMGl3kA0U9SPZ7vKx8EjXZdH6QYY6708UqsyGAJQttJBueRmy3SPBWa5ZQwFvHWukMHIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763398669; c=relaxed/simple;
	bh=d8KkW7zEMk6mrYLSOzk0a8/JAgTEqQL8XjclYDdA8og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jScX5t++7QGfvwNhDCYlu0TSpo4MTfR9ymHDi3Uha+v+u6VZawytBSjOl+rVtN6B1d6+jgaJp1rCuYepAcZIxZk1BY8fvB8HtIK3oEDiZ/XrT7SzNYmWHrHDHPgwOqNo9lyGWFHBqhLPhyDEjj9NCVEFd1j7RxtOsdmcMyrv7gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 287BD61CC3FCC;
	Mon, 17 Nov 2025 17:57:08 +0100 (CET)
Message-ID: <fa88d3de-29ce-403a-a681-8cd35dca044b@molgen.mpg.de>
Date: Mon, 17 Nov 2025 17:57:07 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid0: fix NULL pointer dereference in
 create_strip_zones() for dm-raid
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, linan122@huawei.com, xni@redhat.com,
 czhong@redhat.com
References: <20251116021816.107648-1-yukuai@fnnas.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20251116021816.107648-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Kuai,


Thank you for your patch.

Am 16.11.25 um 03:18 schrieb Yu Kuai:
> Commit 2107457e31fa ("md/raid0: Move queue limit setup before r0conf
> initialization") dereference mddev->gendisk unconditionally, which is
> NULL for dm-raid.
> 
> Fix this problem by reverting to old codes for dm-raid.
> 
> Fixes: 2107457e31fa ("md/raid0: Move queue limit setup before r0conf initialization")
> Reported-and-tested-by: Changhui Zhong <czhong@redhat.com>
> Closes: https://lore.kernel.org/all/CAGVVp+VqVnvGeneUoTbYvBv2cw6GwQRrR3B-iQ-_9rVfyumoKA@mail.gmail.com/
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid0.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 47aee1b1d4d1..985c377356eb 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -68,7 +68,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>   	struct strip_zone *zone;
>   	int cnt;
>   	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
> -	unsigned int blksize = queue_logical_block_size(mddev->gendisk->queue);
> +	unsigned int blksize = 512;
> +
> +	if (!mddev_is_dm(mddev))
> +		blksize = queue_logical_block_size(mddev->gendisk->queue);
>   
>   	*private_conf = ERR_PTR(-ENOMEM);
>   	if (!conf)
> @@ -84,6 +87,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>   		sector_div(sectors, mddev->chunk_sectors);
>   		rdev1->sectors = sectors * mddev->chunk_sectors;
>   
> +		if (mddev_is_dm(mddev))
> +			blksize = max(blksize, queue_logical_block_size(
> +				      rdev1->bdev->bd_disk->queue));
> +
>   		rdev_for_each(rdev2, mddev) {
>   			pr_debug("md/raid0:%s:   comparing %pg(%llu)"
>   				 " with %pg(%llu)\n",

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
