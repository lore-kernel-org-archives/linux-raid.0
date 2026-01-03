Received: from sg-1-36.ptr.blmpb.com (sg-1-36.ptr.blmpb.com [118.26.132.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545D1262BD
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 10:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767435850; cv=none; b=Z+yk+nmWjDEDyYG5VAIfOZ5koVM/of/ZmoYmeM1LBnTT/A2t1upqqQG4lOvdCOUeMRNfUvBcXw/QPjxUut1xoQ9bAZm7StIoP9wW9+OmfeyAhjXeYbKTW5QmZxSSWPB5yJI9dg4VYY2TFnNygQVWW3aXUUHD8hW4rjSVdE0+wro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767435850; c=relaxed/simple;
	bh=umJVSaS48N4rV6PgIMUTWv+bt0y28qHvC4m+CCRnF8Y=;
	h=Subject:Date:Message-Id:Mime-Version:References:Cc:To:In-Reply-To:
	 Content-Type:From; b=oICVjkRhasfnxeem9qfrpzxarsyr5VRnfHT6Xi274C44UH4YDfRZO3VUd5Au9MmTzPHFkmZm1IU4+Jo3h88pvfhbTuw6nhHkXtoQf1JDMrtNwcihYv546RdbIo4SHlHvDgd5dV2ogU8Onn3yYvG8zbRXtzphD/NIlIXeS8BdDec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=uA0NYMoQ; arc=none smtp.client-ip=118.26.132.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="uA0NYMoQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767435833;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1VNgryJwuZq0r2QESiJuOXzkNn4fmwGzLx7G28Op9z0=;
 b=uA0NYMoQ6agRuoqmgEgil6tdIybLzQ4gPpNJxSnBWkCX/6SN6HENpRqovVZ5/vZDDlFSP1
 jgSTMqZFnQHwUveAY9U/e65z8mYsl0BCkzvrPk4ZZxBm7/fiTolvk506tKgfFvQxV+OaJJ
 Wdl248DyBUnMAQeY2lfzeKp+obk88myOTczLyd03NJc0inllZOXtC6ZZWPMwHDrWEFrgRb
 ry64fjSNG/t3haEg+OzAXvO/eIzUo8+5FBo9rpQYmRbJ2MPK1AXedFR1wLj8APSb+grzRj
 7XaXGurxLA3naCaM4EGw5Vz/njVCwUH9jz7N9ChCbPQBNhWvWnnVj2OYR1wCwQ==
Subject: Re: [PATCH v3 05/13] md/raid1,raid10: support narrow_write_error when badblocks is disabled
Date: Sat, 3 Jan 2026 18:23:47 +0800
Message-Id: <38c3ef0d-c330-4e33-87aa-a34acd878c87@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
References: <20251215030444.1318434-1-linan666@huaweicloud.com> <20251215030444.1318434-6-linan666@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<k@mgml.me>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>, 
	<yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.186]) by smtp.feishu.cn with ESMTPS; Sat, 03 Jan 2026 18:23:50 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
Content-Language: en-US
X-Lms-Return-Path: <lba+26958ee37+3d2f76+vger.kernel.org+yukuai@fnnas.com>
In-Reply-To: <20251215030444.1318434-6-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
From: "Yu Kuai" <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/12/15 11:04, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> When badblocks.shift < 0 (badblocks disabled), narrow_write_error()
> return false, preventing write error handling. Since narrow_write_error()
> only splits IO into smaller sizes and re-submits, it can work with
> badblocks disabled.
>
> Adjust to use the logical block size for block_sectors when badblocks is
> disabled, allowing narrow_write_error() to function in this case.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid1.c  | 8 ++++----
>   drivers/md/raid10.c | 8 ++++----
>   2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index bd63cf039381..8e0312fad3a2 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2503,17 +2503,17 @@ static bool narrow_write_error(struct r1bio *r1_b=
io, int i)
>   	 * We currently own a reference on the rdev.
>   	 */
>  =20
> -	int block_sectors;
> +	int block_sectors, lbs =3D bdev_logical_block_size(rdev->bdev) >> 9;
>   	sector_t sector;
>   	int sectors;
>   	int sect_to_write =3D r1_bio->sectors;
>   	bool ok =3D true;
>  =20
>   	if (rdev->badblocks.shift < 0)
> -		return false;

So, I just realize patch 3 missed this change, patch 3 itself is not correc=
t in
the case badblocks is not enabled.

Please also move this patch before patch 3.

> +		block_sectors =3D lbs;
> +	else
> +		block_sectors =3D roundup(1 << rdev->badblocks.shift, lbs);
>  =20
> -	block_sectors =3D roundup(1 << rdev->badblocks.shift,
> -				bdev_logical_block_size(rdev->bdev) >> 9);
>   	sector =3D r1_bio->sector;
>   	sectors =3D ((sector + block_sectors)
>   		   & ~(sector_t)(block_sectors - 1))
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index db6fbd423726..e1f63f4f1384 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2790,17 +2790,17 @@ static bool narrow_write_error(struct r10bio *r10=
_bio, int i)
>   	 * We currently own a reference to the rdev.
>   	 */
>  =20
> -	int block_sectors;
> +	int block_sectors, lbs =3D bdev_logical_block_size(rdev->bdev) >> 9;
>   	sector_t sector;
>   	int sectors;
>   	int sect_to_write =3D r10_bio->sectors;
>   	bool ok =3D true;
>  =20
>   	if (rdev->badblocks.shift < 0)
> -		return false;
> +		block_sectors =3D lbs;
> +	else
> +		block_sectors =3D roundup(1 << rdev->badblocks.shift, lbs);
>  =20
> -	block_sectors =3D roundup(1 << rdev->badblocks.shift,
> -				bdev_logical_block_size(rdev->bdev) >> 9);
>   	sector =3D r10_bio->sector;
>   	sectors =3D ((r10_bio->sector + block_sectors)
>   		   & ~(sector_t)(block_sectors - 1))

--=20
Thansk,
Kuai
