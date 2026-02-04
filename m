Received: from sg-1-35.ptr.blmpb.com (sg-1-35.ptr.blmpb.com [118.26.132.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765BF1D63F0
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224249; cv=none; b=Cnh99zqN8Jz+P74vimUolM2LSY4wBA2zZHkwWCx9BbLblYb+9pGfoutNtSeX5j19DkGHS9Dccu8KG9rzynOpHs/JYzhaF0vsVpRT7QqRdH5LxfpYnEly1Pa+7X7BiMxiwCDmstse9+q+NNWs5S5e6A8Y47rlRyZd+n+fDC2ogys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224249; c=relaxed/simple;
	bh=M1z0F/kQ6yt0hHUSyy6phr9wbMe7y5dLly8gZHffz3M=;
	h=To:Subject:In-Reply-To:Cc:Mime-Version:Content-Type:References:
	 Message-Id:From:Date; b=qQ+QDXz2nJr58MB4wyKdrjUncaZpCWHvXiF/s9VCqIXiBVZ7MazRog/q9VwNLLdKv1eHDnobjmDPawB/6u9PcGcmpiurY052bnbMwu5ppAzUQwBIZoEP6wjVvqyLf+Y5RwaASQ0LYLz0ybCBnLgXBWi/zW2WzSLfg/ZTztkl2B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=vpXFsg4X; arc=none smtp.client-ip=118.26.132.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="vpXFsg4X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770224244;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nRnAUppUebqp8RHAEzRyezsK5RVtrhDvLjl1+sSeO/8=;
 b=vpXFsg4XfWrrCGrioae+MbW407lU1y1hF9gUizIkWwUpYyrBnMg/dmM+vF33N4N2cJXhq+
 x9aGk5OMOedtVcM+NzguXr3TEesQOUOWhZzKvIic0BSOCqUb5dNm9eCoQ3n6beFOtQ/HUF
 O6zDybxKrFxTzQpigYYHdU6/ImrVamGLBMKgyu5TXIVWq1SuR8pP4tJVG8Aa7iouvg/Gg+
 NYIHQ5p5ITfVYMAO17mNpj4sJGU2OFBrzWAPAx3NnVl8DmPdGma5790BqXGMJaAPunYumO
 LT1YQMng5fbb7IFoZGYE8Hp9GES+x7+H4fBA/vA1t46q4+D16KcNKasMHzPjew==
To: <linan666@huaweicloud.com>, <song@kernel.org>
Subject: Re: [PATCH v2 10/14] md/raid1,raid10: clean up resync_fetch_folio
In-Reply-To: <20260128075708.2259525-11-linan666@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+269837a72+996ac4+vger.kernel.org+yukuai@fnnas.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-11-linan666@huaweicloud.com>
Message-Id: <3fe2e132-f5bd-466a-b43b-7a2ac27813d7@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:57:22 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Thu, 5 Feb 2026 00:57:20 +0800
Content-Language: en-US

Hi,

=E5=9C=A8 2026/1/28 15:57, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> The helper resync_fetch_folio() only returns the folio member without
> any additional logic. Clean it up by accessing rf->folio directly.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/raid1-10.c |  7 +------
>   drivers/md/raid1.c    | 10 ++++------
>   drivers/md/raid10.c   |  3 +--
>   3 files changed, 6 insertions(+), 14 deletions(-)

Again, I think this patch should be merged into patch 5.

>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 568ab002691f..2ff1f8855900 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -55,11 +55,6 @@ static inline void resync_free_folio(struct resync_fol=
io *rf)
>   	folio_put(rf->folio);
>   }
>  =20
> -static inline struct folio *resync_fetch_folio(struct resync_folio *rf)
> -{
> -	return rf->folio;
> -}
> -
>   /*
>    * 'strct resync_folio' stores actual pages used for doing the resync
>    *  IO, and it is per-bio, so make .bi_private points to it.
> @@ -74,7 +69,7 @@ static void md_bio_reset_resync_folio(struct bio *bio, =
struct resync_folio *rf,
>   			       int size)
>   {
>   	/* initialize bvec table again */
> -	if (WARN_ON(!bio_add_folio(bio, resync_fetch_folio(rf),
> +	if (WARN_ON(!bio_add_folio(bio, rf->folio,
>   				   min_t(int, size, RESYNC_BLOCK_SIZE),
>   				   0))) {
>   		bio->bi_status =3D BLK_STS_RESOURCE;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 27e3b2375b16..a303349eeff4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2981,8 +2981,8 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>   		max_sector =3D sector_nr + good_sectors;
>   	nr_sectors =3D 0;
>   	do {
> -		struct folio *folio;
>   		int len =3D RESYNC_BLOCK_SIZE;
> +
>   		if (sector_nr + (len>>9) > max_sector)
>   			len =3D (max_sector - sector_nr) << 9;
>   		if (len =3D=3D 0)
> @@ -2996,13 +2996,11 @@ static sector_t raid1_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>   			len =3D sync_blocks<<9;
>  =20
>   		for (i =3D 0 ; i < conf->raid_disks * 2; i++) {
> -			struct resync_folio *rf;
> -
>   			bio =3D r1_bio->bios[i];
> -			rf =3D get_resync_folio(bio);
>   			if (bio->bi_end_io) {
> -				folio =3D resync_fetch_folio(rf);
> -				bio_add_folio_nofail(bio, folio, len, 0);
> +				struct resync_folio *rf =3D get_resync_folio(bio);
> +
> +				bio_add_folio_nofail(bio, rf->folio, len, 0);
>   			}
>   		}
>   		nr_sectors +=3D len>>9;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 06257eea97ed..d8a5fadfc933 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3630,9 +3630,8 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>   			break;
>   		for (bio=3D biolist ; bio ; bio=3Dbio->bi_next) {
>   			struct resync_folio *rf =3D get_resync_folio(bio);
> -			struct folio *folio =3D resync_fetch_folio(rf);
>  =20
> -			if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
> +			if (WARN_ON(!bio_add_folio(bio, rf->folio, len, 0))) {
>   				bio->bi_status =3D BLK_STS_RESOURCE;
>   				bio_endio(bio);
>   				*skipped =3D 1;

--=20
Thansk,
Kuai
