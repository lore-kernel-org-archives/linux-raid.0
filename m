Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDADDF76
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 05:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776575692; cv=none; b=dTr8RnzJunht2q8g7zEPG2CK4BV/+we66q02X5VbZcCxZMu9mz07Jkxmf9prV8rIKJafaKQ0TRTmeII1nwOxgdPZIvUCC6s5up/z5MkIk5fDxoqI8NScYHOdolICuzTQFXtLvmWhxI0+oukGZBAqA+Xb4fxu5+Ai+ITpcNiitwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776575692; c=relaxed/simple;
	bh=JA4Sz0ZkvtTlvzTIpQcPAB/VdRsC7F5es2CbNBU+L5Q=;
	h=To:From:Content-Type:Subject:Date:In-Reply-To:References:Cc:
	 Message-Id:Mime-Version; b=dcDngL0gPzD7sNR8h7GmC0gwXBRv9QmYCk90cztJIMJAseEYGqM5qcpgzPFsqKXO+d5of1XdIkFiSiwJCOPyWQzIZ65VvssL4qvdGi5FEnAaeLqBvWZS4HhUhlsUUz8HmTm39hmDU0BjikDvD+M70C9odMC/5yKMYFMBAroqfQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=w5GA4Y8k; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="w5GA4Y8k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776575678;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vxjrJXjizni1qTdQTFFgJWz9CCMmVGT8Pu88wlRE2Oc=;
 b=w5GA4Y8kZB0/VxMyysCOL8trCt1R8rjKKL26f930lAgkAUpgKPI/etx+du+vumFu8pkVaI
 T8I2+lf1IoxgRFTm1lPlfnl4AIkMD4MTiOwudeV1+hHqCEIDz6dCHjdTQmTFJAJ8GUPD7H
 LTpAhQ9fALkt0316/UaBOKAwWSyGBGYER0iiyigGgnEozamt6n5BbqOgu1xJ6NtR5qCz0q
 emBI+p92gntnN2eaz8WGHKgKdLxCdCmuSxQVSo/jNTQ/3jsx3mpjnpawJ/tmIZ7RxNUBEd
 6gkDAapXk0tVDGkPZvY9yMFZRnWslMK6OCW9tyYU9mmLd2flXJ4S80xrdI0ICg==
To: "FengWei Shih" <dannyshih@synology.com>, <song@kernel.org>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 13:14:35 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269e464bc+383c4f+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Subject: Re: [PATCH] md/raid5: fix race between reshape and chunk-aligned read
Date: Sun, 19 Apr 2026 13:14:34 +0800
In-Reply-To: <20260409051722.2865321-1-dannyshih@synology.com>
References: <20260409051722.2865321-1-dannyshih@synology.com>
Cc: <linan122@huawei.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
Message-Id: <68b61dc3-f7fa-49ba-9f26-f07b7fa4768d@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/4/9 13:17, FengWei Shih =E5=86=99=E9=81=93:
> raid5_make_request() checks mddev->reshape_position to decide whether
> to allow chunk-aligned reads. However in raid5_start_reshape(), the
> layout configuration (raid_disks, algorithm, etc.) is updated before
> mddev->reshape_position is set:
>
>    reshape (raid5_start_reshape)        read (raid5_make_request)
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    write_seqcount_begin
>    update raid_disks, algorithm...
>    set conf->reshape_progress
>    write_seqcount_end
>                                          check mddev->reshape_position
>                                            * still MaxSector, allow
>                                          raid5_read_one_chunk()
>                                            * use new layout
>    raid5_quiesce()
>    set mddev->reshape_position

While we're here, I think it's pretty ugly to disable raid5_read_one_chunk
when reshape is not fully done. So a better solution should be:

- data behind reshape: read with new layout
- data ahead of reshape: read with old layout, reshape will also need to wa=
it
for this IO to be done, before reshape can make progress.
- data intersecting the active reshape window: wait for reshape to make pro=
gress.

>
> Since reshape_position is not yet updated, raid5_make_request()
> considers no reshape is in progress and proceeds with the
> chunk-aligned path, but the layout has already changed, causing
> raid5_compute_sector() to return an incorrect physical address.
>
> Fix this by reading conf->reshape_progress under gen_lock in
> raid5_read_one_chunk() and falling back to the stripe path if a
> reshape is in progress.
>
> Signed-off-by: FengWei Shih <dannyshih@synology.com>
> ---
>   drivers/md/raid5.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..bded2b86f0ef 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5421,6 +5421,11 @@ static int raid5_read_one_chunk(struct mddev *mdde=
v, struct bio *raid_bio)
>   	sector_t sector, end_sector;
>   	int dd_idx;
>   	bool did_inc;
> +	int seq;
> +
> +	seq =3D read_seqcount_begin(&conf->gen_lock);
> +	if (unlikely(conf->reshape_progress !=3D MaxSector))
> +		return 0;
>  =20
>   	if (!in_chunk_boundary(mddev, raid_bio)) {
>   		pr_debug("%s: non aligned\n", __func__);
> @@ -5431,6 +5436,9 @@ static int raid5_read_one_chunk(struct mddev *mddev=
, struct bio *raid_bio)
>   				      &dd_idx, NULL);
>   	end_sector =3D sector + bio_sectors(raid_bio);
>  =20
> +	if (read_seqcount_retry(&conf->gen_lock, seq))
> +		return 0;
> +
>   	if (r5c_big_stripe_cached(conf, sector))
>   		return 0;
>  =20

--=20
Thansk,
Kuai
