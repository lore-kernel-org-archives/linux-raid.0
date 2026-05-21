Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A203363CB
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 05:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779341539; cv=none; b=W34wbB1ebeemk2b9zvTOAfMcC1EtsjJ3Vmv1b/kRgT2+MPesnkoz6zoxTd2SjSfOGpHTlJstiYSpNeJ7PaM6xth07nAC1ReW+aFBdt3RxDqwZ+7r9YmwYjZPR+KslOs1oR3eCUfM3YKxrKDA8OrZe4uQNo6VbI9f/vt9zV2KAcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779341539; c=relaxed/simple;
	bh=6KF7SCmRmH8qXo6wKepgXQrwQSkBuFGca2x+z6H03nc=;
	h=From:Message-Id:Mime-Version:References:Cc:In-Reply-To:To:Subject:
	 Date:Content-Type; b=Zl1jdhYAf0l8QwN6OZLd5BHZ4lMu/UZ4xeEOoI0WQf1jnB+IcgmGCUeSWm9uchf2uYfNbsDdO+VW7u26P95/Z2cFIPwAXaXTOyYCH9nPvNVofI/Ysr4egVtjAttslwyHiRZZfTgAeI0uPOsjaqWpgn3Q2Y0fDqX3PXyvLFK3IBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=TIMXQ7Df; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="TIMXQ7Df"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779341529;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=L1iXSKjT/fTdrLQUUz+Y42C7pxvchP4H0RxNYlXaPYg=;
 b=TIMXQ7DfJJiVWA+uvctMllYPwF3B7OU6Kn/adi2qUYyncS+gkRmdjCiMLT3MSesgTPb4g3
 OFtx14IgWhg7817cUBiupmOv0gy9XMEao/qzK3ky1NrhbrBSu9CafPZsjaO+9KbWyaBLCT
 vOh1LebZhjO2U8gye8khE5BwANBhFEB3OM4ShZgcAraSFICtt/j0mouViAdgBVls3oN8K1
 7aaV7aBn2BRCVPSrhu/pQGFaQjh93wrFANwIFAIDRAkad5brgSihmifC628cf68KW4PThq
 8X/DSyeEEpJLLfsXN/Ixn+/sXuDdFOHfW2C4r65X+dbkTMDCdOSJ77zvx3gVaQ==
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <14ffe5d6-8929-40b3-8c19-4f8b65dc9536@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
User-Agent: Mozilla Thunderbird
References: <20260515093019.3436882-1-chencheng@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260515093019.3436882-1-chencheng@fnnas.com>
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <yukuai@fygo.io>
Subject: Re: [PATCH] raid10_handle_discard() reuses r10bio objects from r10bio_pool.
Date: Thu, 21 May 2026 13:32:04 +0800
X-Original-From: Yu Kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Thu, 21 May 2026 13:32:06 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a0e98d7+e0964e+vger.kernel.org+yukuai@fnnas.com>

=E5=9C=A8 2026/5/15 17:30, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng <chencheng@fnnas.com>
>
> put_all_bios() always drops devs[i].bio, but it only drops
> devs[i].repl_bio when r10_bio->read_slot < 0. If discard reuses an
> r10bio that was previously used for a read, read_slot can still be
> non-negative, and discard cleanup can skip bio_put() on repl_bio.
>
> Reset read_slot to -1 when preparing an r10bio for discard so the
> replacement bio is always released correctly.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid10.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 39085e7dd6d2..7dc2a5a127e8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1727,6 +1727,7 @@ static int raid10_handle_discard(struct mddev *mdde=
v, struct bio *bio)
>   	r10_bio->mddev =3D mddev;
>   	r10_bio->state =3D 0;
>   	r10_bio->sectors =3D 0;
> +	r10_bio->read_slot =3D -1;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
>   	wait_blocked_dev(mddev, r10_bio);
>  =20

Applied with the subject fix:

md/raid10: reset read_slot when reusing r10bio for discard

--=20
Thansk,
Kuai
