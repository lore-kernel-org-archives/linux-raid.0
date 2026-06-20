Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E4B1BBBFC
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 20:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781986700; cv=none; b=YZl7Y+B36u+a7PPYitNWIwNURnlgC0MWTxxHAu/qeGN5QwXqJ2o2t2Rhhk8D8gDVzK/lGIzEDY1mbcxGkAp1KYOUcHZOV/zUZr4C10XQ9o4T+xvZElDwhOgAz65SaztY8hi7eBgry7Pfb6Vd7bnY2gpwjsoL4PjwQ8qXAEDNVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781986700; c=relaxed/simple;
	bh=UkUEyherRMok6tYJHGnQiYLG1OmpTghjF0bkLcSYY/4=;
	h=Content-Type:To:Cc:Subject:Date:References:In-Reply-To:From:
	 Message-Id:Mime-Version; b=YBl1sh7W19SiDUgWm/o5v7a5yDunpAxpKONDFFeO518rTyavuIYeqWidM2zUHnCwKqfiwnyx85leIjp8Z5FgibTalsLd8o52DNn1OL83yA0wkDqgzsF+zBka5gNrQdBQtu2RpVEFSH11pruRmV+26fBfK74y8EwOpW36lKyZavc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=lKXPS11r; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="lKXPS11r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781986686;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9wMzmI+d1Zn+8RETLabqGNdT8egup+f4ZJfvTvQAl9w=;
 b=lKXPS11rE/I55lnXMgSxpegmKBLN2QnVUB6NjHLo1nV7L7qhC3wnZUEB5gkj7usakzJSqI
 nacIoMSLjOAu6XDrQfwSBL37Q/M+oHhmvxTiUG5N2FHoUY0XBFGhpcduNM7TeqGtJTlI6k
 fRVU6LVL8A/UWfRl4wKQjA5MrKx0IEGjsErFsuAHkUWTNrLYEvOW+Oypr0MMuYz0JD0mpI
 wpSRiERyeLeuPWohpy9D5woEFTX2lFy+YaFdfgoV9BOGoSA+dMLxhBtSdBL3LTceqpAwMV
 Myr6p61f/9UrPplavqY6D9GDu7DL7/PzY9u1oW8D269D5d+YoKLCSpsYbzCEsw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<yukuai@fygo.io>, <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<vverma@digitalocean.com>, <axboe@kernel.dk>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
Subject: Re: [PATCH] md/raid1: honor REQ_NOWAIT when waiting for behind writes
Date: Sun, 21 Jun 2026 04:18:01 +0800
References: <20260611083514.754922-1-abd.masalkhi@gmail.com>
X-Lms-Return-Path: <lba+26a36f57c+56ce88+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.feishu.cn with ESMTPS; Sun, 21 Jun 2026 04:18:03 +0800
In-Reply-To: <20260611083514.754922-1-abd.masalkhi@gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <61361f20-f81c-46c3-bdd2-3de24e90a0aa@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/6/11 16:35, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> raid1 supports REQ_NOWAIT reads by avoiding waits in the barrier path
> through wait_read_barrier(). However, a read can still block on a
> WriteMostly device when the array uses a bitmap and there are
> outstanding behind writes.
>
> In that case raid1 unconditionally calls wait_behind_writes(), which
> may sleep until all behind writes complete. As a result, a REQ_NOWAIT
> read can block despite the caller explicitly requesting non-blocking
> behavior.
>
> This ensures that raid1 consistently honors REQ_NOWAIT reads across all
> paths that may otherwise wait for behind writes.
>
> Fixes: 5aa705039c4f ("md: raid1 add nowait support")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
>   drivers/md/md-bitmap.c   |  9 +++++++--
>   drivers/md/md-bitmap.h   |  2 +-
>   drivers/md/md-llbitmap.c | 13 ++++++++-----
>   drivers/md/md.c          |  2 +-
>   drivers/md/raid1.c       | 10 +++++++---
>   5 files changed, 24 insertions(+), 12 deletions(-)

Applied to md-7.2.

One note, remove nowait support is already in my to-do lists. There is a ca=
se
that can't be handled for now, for example:

2 disk raid1, issue no wait write IO, rdev1 succeed while rdev2 failed. In =
this
case, we don't know if rdev2 failed issue because nowait or disk really hav=
e
badblocks. So we can't either record badblocks or issue again without nowai=
t,
for consequence, rdev1 and rdev2 will end up with different data.

I think the best solution is to remove nowait support for mdraid. Feel free
to cook a patch or if you have something else in mind.

>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 028b9ca8ce52..1206e31f323a 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2063,18 +2063,23 @@ static void bitmap_end_behind_write(struct mddev =
*mddev)
>   		 bitmap->mddev->bitmap_info.max_write_behind);
>   }
>  =20
> -static void bitmap_wait_behind_writes(struct mddev *mddev)
> +static bool bitmap_wait_behind_writes(struct mddev *mddev, bool nowait)
>   {
>   	struct bitmap *bitmap =3D mddev->bitmap;
>  =20
>   	/* wait for behind writes to complete */
>   	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
> +		if (nowait)
> +			return false;
> +
>   		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
>   			 mdname(mddev));
>   		/* need to kick something here to make sure I/O goes? */
>   		wait_event(bitmap->behind_wait,
>   			   atomic_read(&bitmap->behind_writes) =3D=3D 0);
>   	}
> +
> +	return true;
>   }
>  =20
>   static void bitmap_destroy(struct mddev *mddev)
> @@ -2084,7 +2089,7 @@ static void bitmap_destroy(struct mddev *mddev)
>   	if (!bitmap) /* there was no bitmap */
>   		return;
>  =20
> -	bitmap_wait_behind_writes(mddev);
> +	bitmap_wait_behind_writes(mddev, false);
>   	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
>   		mddev_destroy_serial_pool(mddev, NULL);
>  =20
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 214f623c7e79..f46674bdfeb9 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -98,7 +98,7 @@ struct bitmap_operations {
>  =20
>   	void (*start_behind_write)(struct mddev *mddev);
>   	void (*end_behind_write)(struct mddev *mddev);
> -	void (*wait_behind_writes)(struct mddev *mddev);
> +	bool (*wait_behind_writes)(struct mddev *mddev, bool nowait);
>  =20
>   	md_bitmap_fn *start_write;
>   	md_bitmap_fn *end_write;
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 1adc5b117821..5a4e2abaa757 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1574,16 +1574,19 @@ static void llbitmap_end_behind_write(struct mdde=
v *mddev)
>   		wake_up(&llbitmap->behind_wait);
>   }
>  =20
> -static void llbitmap_wait_behind_writes(struct mddev *mddev)
> +static bool llbitmap_wait_behind_writes(struct mddev *mddev, bool nowait=
)
>   {
>   	struct llbitmap *llbitmap =3D mddev->bitmap;
>  =20
> -	if (!llbitmap)
> -		return;
> +	if (llbitmap && atomic_read(&llbitmap->behind_writes) > 0) {
> +		if (nowait)
> +			return false;
>  =20
> -	wait_event(llbitmap->behind_wait,
> -		   atomic_read(&llbitmap->behind_writes) =3D=3D 0);
> +		wait_event(llbitmap->behind_wait,
> +			   atomic_read(&llbitmap->behind_writes) =3D=3D 0);
> +	}
>  =20
> +	return true;
>   }
>  =20
>   static ssize_t bits_show(struct mddev *mddev, char *page)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 096bb64e87bd..d1465bcd86c8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7050,7 +7050,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
>   static void mddev_detach(struct mddev *mddev)
>   {
>   	if (md_bitmap_enabled(mddev, false))
> -		mddev->bitmap_ops->wait_behind_writes(mddev);
> +		mddev->bitmap_ops->wait_behind_writes(mddev, false);
>   	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
>   		mddev->pers->quiesce(mddev, 1);
>   		mddev->pers->quiesce(mddev, 0);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index b1ed4cc6ade4..b2d7c13b64bd 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1341,6 +1341,7 @@ static void raid1_read_request(struct mddev *mddev,=
 struct bio *bio,
>   	int max_sectors;
>   	int rdisk;
>   	bool r1bio_existed =3D !!r1_bio;
> +	bool nowait =3D bio->bi_opf & REQ_NOWAIT;
>  =20
>   	/*
>   	 * An md cloned bio indicates we are in the error path.
> @@ -1360,8 +1361,7 @@ static void raid1_read_request(struct mddev *mddev,=
 struct bio *bio,
>   	 * Still need barrier for READ in case that whole
>   	 * array is frozen.
>   	 */
> -	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
> -				bio->bi_opf & REQ_NOWAIT)) {
> +	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
>   		bio_wouldblock_error(bio);
>   		return;
>   	}
> @@ -1402,7 +1402,11 @@ static void raid1_read_request(struct mddev *mddev=
, struct bio *bio,
>   		 * over-take any writes that are 'behind'
>   		 */
>   		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
> -		mddev->bitmap_ops->wait_behind_writes(mddev);
> +		if (!mddev->bitmap_ops->wait_behind_writes(mddev, nowait)) {
> +			bio_wouldblock_error(bio);
> +			set_bit(R1BIO_Returned, &r1_bio->state);
> +			goto err_handle;
> +		}
>   	}
>  =20
>   	if (max_sectors < bio_sectors(bio)) {

--=20
Thanks,
Kuai
