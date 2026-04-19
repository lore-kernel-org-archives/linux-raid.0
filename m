Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDD7359FAA
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 04:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776574152; cv=none; b=XXrGCDASFfxTsXkOQimYtpa+ME89lr+kK55VgVLl+9GQNQTa9kihjawIUB+4JZkNEEw9/RSst8F3hvaK6/N2BOENJdVCPRHlAYdJNI843Oe2HsC+61E/EEhGsVOvmJDtfPSbKR1rEnf/Zv6YW8yrlaKhHgl9vrMeXg572bgEvAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776574152; c=relaxed/simple;
	bh=3TmKoHLgj8/97kxZjOWTlqJ5ZZnZfKz189HHLP37cgM=;
	h=To:Cc:Date:Subject:Mime-Version:References:From:Message-Id:
	 In-Reply-To:Content-Type; b=op8zx3BNCGHIxKrLL6rf9q70nU8uAB7A8mi1C39OC1zij0K9YYv3tpfPHNO7CGWywAZK0XJv0rfRdWsyTjJnFNzut+DwKhUj32ra2np7FxE0TTN6xzaGH8quK6empic3BWHil+blAgXniHQADlW2ex6XOJgNr0BuLHA6Ek8vO1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=GfymTpw5; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="GfymTpw5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776574136;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=zYarzdChCH02ltIpdxN+lOJ5cWp5I342HeII129BJU8=;
 b=GfymTpw5voIk+ecv51BN7jklXn1uMDGeU4hjfFNdg/Etm07ShA+8eFBuRDA5NCTQeluQ5M
 oalVpkrGAY/fp91bgH1eAqSKepL1m0ncCzHfdC8e1Zfh5C/J5PCHLJ0e6EYECeKxknfIVo
 M/eskO2dn1uMuyH/iiIX3oXe/MWJ1ubNDQEpzyCp+gsrJ1bbJe9TPVYRZFnu0r5eMaKpdk
 En2HWUlYH/9RCXM9cmgo1u0VYuruiCq6DSCi5qi4Xv7/8GmOl6VUku446blMKaFQsjSbTv
 HXLTqT77msnqNlsVk4EjxzgN7sPGlETfok0pbniGi251td/WPJLHEbRTm8A3VQ==
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
Date: Sun, 19 Apr 2026 12:48:52 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: factor out cloned bio cleanup into md_free_bio()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260414103813.307601-1-abd.masalkhi@gmail.com>
X-Lms-Return-Path: <lba+269e45eb7+d4265e+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <b33f52c1-0f10-4ac0-8792-4387848e40d4@fnnas.com>
Content-Language: en-US
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 12:48:54 +0800
In-Reply-To: <20260414103813.307601-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/4/14 18:38, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Refactor duplicated cloned bio completion and cleanup logic into
> a new helper, md_free_bio().
>
> md_end_clone_io() and md_free_cloned_bio() previously shared nearly
> identical teardown code, differing only in whether the original
> bio=E2=80=99s endio callback was invoked. Introduce a boolean parameter
> orig_endio to control this behavior and consolidate the logic.
>
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
>   drivers/md/md.c | 26 +++++++++-----------------
>   1 file changed, 9 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac71640ff3a8..707d605fee61 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9208,7 +9208,7 @@ static void md_bitmap_end(struct mddev *mddev, stru=
ct md_io_clone *md_io_clone)
>   	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
>   }
>  =20
> -static void md_end_clone_io(struct bio *bio)
> +static void md_free_bio(struct bio *bio, bool orig_endio)
>   {
>   	struct md_io_clone *md_io_clone =3D bio->bi_private;
>   	struct bio *orig_bio =3D md_io_clone->orig_bio;
> @@ -9224,10 +9224,16 @@ static void md_end_clone_io(struct bio *bio)
>   		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>  =20
>   	bio_put(bio);
> -	bio_endio(orig_bio);
> +	if (orig_endio)
> +		bio_endio(orig_bio);
>   	percpu_ref_put(&mddev->active_io);
>   }
>  =20
> +static void md_end_clone_io(struct bio *bio)
> +{
> +	md_free_bio(bio, true);
> +}
> +
>   static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>   {
>   	struct block_device *bdev =3D (*bio)->bi_bdev;
> @@ -9262,21 +9268,7 @@ EXPORT_SYMBOL_GPL(md_account_bio);
>  =20
>   void md_free_cloned_bio(struct bio *bio)
>   {
> -	struct md_io_clone *md_io_clone =3D bio->bi_private;
> -	struct bio *orig_bio =3D md_io_clone->orig_bio;
> -	struct mddev *mddev =3D md_io_clone->mddev;
> -
> -	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mddev, fal=
se))
> -		md_bitmap_end(mddev, md_io_clone);
> -
> -	if (bio->bi_status && !orig_bio->bi_status)
> -		orig_bio->bi_status =3D bio->bi_status;
> -
> -	if (md_io_clone->start_time)
> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
> -
> -	bio_put(bio);
> -	percpu_ref_put(&mddev->active_io);
> +	md_free_bio(bio, false);
>   }
>   EXPORT_SYMBOL_GPL(md_free_cloned_bio);

This patch is no longer needed after following patch:
https://lore.kernel.org/r/20260408043548.1695157-1-bmarzins@redhat.com

>  =20

--=20
Thansk,
Kuai
