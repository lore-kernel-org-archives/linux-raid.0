Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19D1F2B8D
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 01:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779326708; cv=none; b=qIjTurd54NTFOESO3GxSaQUslSTjLScvxMTEanjLuPN5LNkxRFYCVfBaaIt5gX+RsKglYj/R+6SBsOV9B+yr1XhrxGnhLZcyIEmx4wX4inPH/mVaC06jN6ndHao5CeriaxXc5FEoOeLYi5L2JncouCBm06No2ULzvb0Ds/td0aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779326708; c=relaxed/simple;
	bh=U/WjruAKohq6rINxtu4KmSLp08jRLIMuOC2HDx+bp28=;
	h=From:Mime-Version:In-Reply-To:References:To:Cc:Subject:
	 Content-Type:Date:Message-Id; b=OHZN7iDCjiS3UlUck9lP0lX4TS9cq9fl9Y5SC0iQhACcOQGDJjNWbeZQYYRfdsTNSNqPeCh36VevCOR6dCYG/oAFzqjYBl0N9QQ6imk2Vn03L539L5bBlXJgXBbSzGGUOPUY5L0OvIdU0AogCYdO6fWr4O9xnEqjypWQmnqIOsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AiANEJQP; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AiANEJQP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779326701;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=B8AmDtAxEMMKZavYMUG7prsupaSll5A2/AvG/8OM7gE=;
 b=AiANEJQPdMnFBagmFZM8WJ389PdfWnmoQ0Hl6tpQ6W2izNioqYrKIMZIM1Ka2q0UndtxER
 gGmiySTrs158Z/igBt8oQElWU4+x3DI7Gh/pST7wSVnlrLfxbbcRA9Lq+uA/TP4c0HsmoQ
 BcafLmUcmmywlGg1wYHcoLTQCAcJcNOfqYkSAJla3eC7oF6s9Sd+dJ3Eqcb+NVUIO4BnNt
 CDkse77gJTD2cKebC2HQ3mGMiDNJh0Ge+6gBF8iyUtONbDVkddlhtIMOyCzMd+yCNyPueT
 bkSym9/nwas2LUTqab2lxIfBp0ocFSzGS3BWclFjfGtC5kKtNuYOkWA3l2a1pA==
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260501114652.590037-3-abd.masalkhi@gmail.com>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com> <20260501114652.590037-3-abd.masalkhi@gmail.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Thu, 21 May 2026 09:24:58 +0800
X-Original-From: Yu Kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a0e5eeb+8a3aa9+vger.kernel.org+yukuai@fnnas.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<xni@redhat.com>, <neilb@suse.com>, <shli@fb.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
Subject: Re: [PATCH v2 2/3] md/raid1,raid10: fix error-path detection with md_cloned_bio()
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 May 2026 09:24:56 +0800
Message-Id: <71990de4-1113-4b7d-8a50-ca1d82802a03@fygo.io>
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Hi,

=E5=9C=A8 2026/5/1 19:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Detect the error path using md_cloned_bio() instead of relying
> on r1_bio in raid1 or r10_bio->read_slot in raid10, which may be
> NULL or -1 after splitting and resubmitting a failed bio.
>
> As a result, the error path may not be recognized and memory
> allocations can incorrectly use GFP_NOIO instead of
> (GFP_NOIO | __GFP_HIGH), which can lead to a deadlock under
> memory pressure.

I don't think this patch will fix this problem. Because split bio
is a new bio that will be resubmit by md_submit_bio(), such bio is
not a md_cloned_bio yet until md_account_bio().

>
> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
> Fixes: 545250f24809 ("md/raid10: simplify handle_read_error()")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> This patch depends on patch 1.
>
> Changes in v2:
>   - New patch.
> ---
>   drivers/md/raid1.c  | 13 ++++++++++---
>   drivers/md/raid10.c | 20 ++++++++++++++------
>   2 files changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index cc9914bd15c1..c52ecd38c163 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1321,11 +1321,18 @@ static void raid1_read_request(struct mddev *mdde=
v, struct bio *bio,
>   	bool r1bio_existed =3D !!r1_bio;
>  =20
>   	/*
> -	 * If r1_bio is set, we are blocking the raid1d thread
> -	 * so there is a tiny risk of deadlock.  So ask for
> +	 * An md cloned bio indicates we are in the error path.
> +	 * This is more reliable than checking r1_bio, which might
> +	 * be NULL even in the error path if a failed bio was split.
> +	 */
> +	bool err_path =3D md_cloned_bio(mddev, bio);
> +
> +	/*
> +	 * If we are in the error path, we are blocking the raid1d
> +	 * thread so there is a tiny risk of deadlock.  So ask for
>   	 * emergency memory if needed.
>   	 */
> -	gfp_t gfp =3D r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
> +	gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>  =20
>   	/*
>   	 * Still need barrier for READ in case that whole
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3a591e60a144..8c6fc398260e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1155,7 +1155,20 @@ static void raid10_read_request(struct mddev *mdde=
v, struct bio *bio,
>   	char b[BDEVNAME_SIZE];
>   	int slot =3D r10_bio->read_slot;
>   	struct md_rdev *err_rdev =3D NULL;
> -	gfp_t gfp =3D GFP_NOIO;
> +
> +	/*
> +	 * An md cloned bio indicates we are in the error path.
> +	 * This is more reliable than checking slot, which might
> +	 * be -1 even in the error path if a failed bio was split.
> +	 */
> +	bool err_path =3D md_cloned_bio(mddev, bio);
> +
> +	/*
> +	 * If we are in the error path, we are blocking the raid10d
> +	 * thread so there is a tiny risk of deadlock.  So ask for
> +	 * emergency memory if needed.
> +	 */
> +	gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>  =20
>   	if (slot >=3D 0 && r10_bio->devs[slot].rdev) {
>   		/*
> @@ -1166,11 +1179,6 @@ static void raid10_read_request(struct mddev *mdde=
v, struct bio *bio,
>   		 * we lose the device name in error messages.
>   		 */
>   		int disk;
> -		/*
> -		 * As we are blocking raid10, it is a little safer to
> -		 * use __GFP_HIGH.
> -		 */
> -		gfp =3D GFP_NOIO | __GFP_HIGH;
>  =20
>   		disk =3D r10_bio->devs[slot].devnum;
>   		err_rdev =3D conf->mirrors[disk].rdev;

--=20
Thansk,
Kuai
