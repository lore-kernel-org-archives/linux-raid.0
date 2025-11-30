Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B293B2A0
	for <linux-raid@vger.kernel.org>; Sun, 30 Nov 2025 01:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764467309; cv=none; b=J0VR71qKRPJSJU5qQlnFWI80PZTibE6ZniN0UuD3FzuWXvdtKm7RL80n1YsK6N+Ux1SY5N3nc2IkJoRAb5ujIbAFWWzUdnZ7bMJuiQo3R260ITNsK8KoxwYbzd5Rv+SJ4V+ZQ5To03gAU5kaHvXKVxu58Z59iYH6Cadm0j73Ruc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764467309; c=relaxed/simple;
	bh=n8O6oaX5Xg0UiQ7C4tBZiC2hNLSZDh03FMlgtJzG9AY=;
	h=From:To:Cc:In-Reply-To:Date:Mime-Version:Subject:Content-Type:
	 References:Message-Id; b=kun2h0tux5Bt++lsdK8HPBQnyap68PVp0NZKQ6vRDWu6TGDprybp+tVuuBl8UDgez5GlHHVS6rVc7bTrSz6gL8tEQddZ70gfOcYJGrfyUuVc6C8ycj0uoKD1dNIhAvyiCSGgGBV4Oqq4ET0ckaOq8u4ifo0oYlx8b8BfAniXz34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=1mTQ+fnX; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="1mTQ+fnX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764467294;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=299gRhltzE5PtzbDQALqqqfkj5TTTDpRFliJsFJdv3U=;
 b=1mTQ+fnXyjPam/hlJS6CIX/ADLUxeGzRSynMPmBVnE4T3PEdZsUNmYXg7q0EYWRU0d/WUe
 xy0U9KSf/cGOFT7CtDT6KLw/e0Y3hOuGsleCFg6zFcLWtFpIZQI0jYk67xo2yVTwJ+8pMJ
 BZSnG+J5x7OuvvvTAV9ynKbItDPze1ZC1hnEG0PFCiXRpopupzRWZxP9ORDewIjqi+3zsk
 grINcbrHZcMxbhb2aidTiZtODzF2ULfY3ebicaQNcHuCfhBlxUUfgv70GxhF6sVd3IMTLQ
 5fPA5ewjgBwbsfPGEd2I0odCa+1RQzV+ZtsGJt3lGuquwYs+ktZln4/vgzismQ==
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Language: en-US
X-Lms-Return-Path: <lba+2692ba25c+065a26+vger.kernel.org+yukuai@fnnas.com>
Organization: fnnas
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
To: <song@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "Yu Kuai" <yukuai@fnnas.com>
Cc: <linan122@huawei.com>, <xni@redhat.com>, <czhong@redhat.com>
In-Reply-To: <20251116021816.107648-1-yukuai@fnnas.com>
Date: Sun, 30 Nov 2025 09:48:10 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid0: fix NULL pointer dereference in create_strip_zones() for dm-raid
Content-Type: text/plain; charset=UTF-8
References: <20251116021816.107648-1-yukuai@fnnas.com>
Message-Id: <864870d9-d682-4a5d-918b-b52f2752cc71@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Sun, 30 Nov 2025 09:48:11 +0800

=E5=9C=A8 2025/11/16 10:18, Yu Kuai =E5=86=99=E9=81=93:
> Commit 2107457e31fa ("md/raid0: Move queue limit setup before r0conf
> initialization") dereference mddev->gendisk unconditionally, which is
> NULL for dm-raid.
>
> Fix this problem by reverting to old codes for dm-raid.
>
> Fixes: 2107457e31fa ("md/raid0: Move queue limit setup before r0conf init=
ialization")
> Reported-and-tested-by: Changhui Zhong <czhong@redhat.com>
> Closes: https://lore.kernel.org/all/CAGVVp+VqVnvGeneUoTbYvBv2cw6GwQRrR3B-=
iQ-_9rVfyumoKA@mail.gmail.com/
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid0.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 47aee1b1d4d1..985c377356eb 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -68,7 +68,10 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>   	struct strip_zone *zone;
>   	int cnt;
>   	struct r0conf *conf =3D kzalloc(sizeof(*conf), GFP_KERNEL);
> -	unsigned int blksize =3D queue_logical_block_size(mddev->gendisk->queue=
);
> +	unsigned int blksize =3D 512;
> +
> +	if (!mddev_is_dm(mddev))
> +		blksize =3D queue_logical_block_size(mddev->gendisk->queue);
>  =20
>   	*private_conf =3D ERR_PTR(-ENOMEM);
>   	if (!conf)
> @@ -84,6 +87,10 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>   		sector_div(sectors, mddev->chunk_sectors);
>   		rdev1->sectors =3D sectors * mddev->chunk_sectors;
>  =20
> +		if (mddev_is_dm(mddev))
> +			blksize =3D max(blksize, queue_logical_block_size(
> +				      rdev1->bdev->bd_disk->queue));
> +
>   		rdev_for_each(rdev2, mddev) {
>   			pr_debug("md/raid0:%s:   comparing %pg(%llu)"
>   				 " with %pg(%llu)\n",

Applied to md-6.19

--=20
Thanks,
Kuai
