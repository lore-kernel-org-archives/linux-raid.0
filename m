Received: from sg-1-38.ptr.blmpb.com (sg-1-38.ptr.blmpb.com [118.26.132.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9EE3368A0
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 02:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772590271; cv=none; b=PGNPGePVVKxNJ2dS4bvNOxxtF2gpXt6m/NaCNhno+XD+3Z4vjEq3g5KVRfim85lUClJbNudrQpCrgtzvJKZTrRatkMyCftpG2J12ZfHSoO5kg3yWDSU8HmPnty9snurTfJWQJBMpJaEd1hUGHbj6Qj4lYcRhAV+Gi1ht+rWjshQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772590271; c=relaxed/simple;
	bh=oHrDftp9uc6brc0j6JlyNgD7xKxsHM5OPwrXYbL/TdU=;
	h=Cc:Mime-Version:Content-Type:Subject:To:From:Message-Id:
	 References:In-Reply-To:Date; b=cOjPE6KAbsGprNYQoMYjAb0hMWw9KcBRtU1zF9xlFjrcWgP9ikf2L2FwznaS0y7j1CCggBwKB1DipaDEdPq9FE0YykAmS2Dg0eOVGiQcw/uxFIdiQ26F4OHzcb//9gkaxw8oUlOJRR8Uejlw1aPpgEwjPaYCDsU71fNT8V0bJ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=aQ8lpece; arc=none smtp.client-ip=118.26.132.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="aQ8lpece"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772590258;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ejB5lESGeXwcr3YJxQVws8Nr1+8avxwfMR3ejhmjx9c=;
 b=aQ8lpeceUSx7ekEWvcYNskcJ2/5w3PHiWUrHCG9xvPGCm0ldvRgOtbfMIrWDeRRVUtBXg5
 LJaCsTWAAzWXKHYegheUJfybyiTSn/UWFpXtdMCpcGBuZLVrweLYEU6K32dF+Bana/VJeZ
 dOgx4UFTu1te3xzucH5SMvIMg7ibq8nz5bN8IHR7pX38iobzmk+VOy6bSlaru/DKNCexPQ
 bqVuMzsjZ2dJKqz4IjVzz7eN4AXQwoX1r7UbJ7w2x8krTUpJOphPE/AbH1l8gNleVE2S8k
 CWwPuiRdSsZtSHfG0UknbaqWrU4aIQgqISBx87ROCG1NmkFfIBhTOvXUQRSvVg==
X-Lms-Return-Path: <lba+269a794b0+51cffe+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Subject: Re: [PATCH] md/raid5: clean up stale declaration and misplaced comment
To: "Chen Cheng" <chencheng@fnnas.com>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <32158c5e-4408-4e13-aef7-6d6337417755@fnnas.com>
References: <20260303111608.7259-1-chencheng@fnnas.com>
In-Reply-To: <20260303111608.7259-1-chencheng@fnnas.com>
Date: Wed, 4 Mar 2026 10:10:53 +0800
Received: from [192.168.1.104] ([39.182.0.182]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 10:10:55 +0800
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/3/3 19:16, Chen Cheng =E5=86=99=E9=81=93:
> Remove the unused md_raid5_kick_device() declaration from raid5.h -
> no definition exists for this function.
>
> Move the handle_stripe() documentation comment from above
> analyse_stripe() to directly above handle_stripe() where it belongs.

Looks fine to me, however, please split and just do one thing in one patch.

> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 26 ++++++++++++--------------
>   drivers/md/raid5.h |  1 -
>   2 files changed, 12 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..48504b0e496b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4594,20 +4594,6 @@ static void handle_stripe_expansion(struct r5conf =
*conf, struct stripe_head *sh)
>   	async_tx_quiesce(&tx);
>   }
>  =20
> -/*
> - * handle_stripe - do things to a stripe.
> - *
> - * We lock the stripe by setting STRIPE_ACTIVE and then examine the
> - * state of various bits to see what needs to be done.
> - * Possible results:
> - *    return some read requests which now have data
> - *    return some write requests which are safely on storage
> - *    schedule a read on some buffers
> - *    schedule a write of some buffers
> - *    return confirmation of parity correctness
> - *
> - */
> -
>   static void analyse_stripe(struct stripe_head *sh, struct stripe_head_s=
tate *s)
>   {
>   	struct r5conf *conf =3D sh->raid_conf;
> @@ -4901,6 +4887,18 @@ static void break_stripe_batch_list(struct stripe_=
head *head_sh,
>   		set_bit(STRIPE_HANDLE, &head_sh->state);
>   }
>  =20
> +/*
> + * handle_stripe - do things to a stripe.
> + *
> + * We lock the stripe by setting STRIPE_ACTIVE and then examine the
> + * state of various bits to see what needs to be done.
> + * Possible results:
> + *    return some read requests which now have data
> + *    return some write requests which are safely on storage
> + *    schedule a read on some buffers
> + *    schedule a write of some buffers
> + *    return confirmation of parity correctness
> + */
>   static void handle_stripe(struct stripe_head *sh)
>   {
>   	struct stripe_head_state s;
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 110b1c2d0a86..1c7b710fc9c1 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -801,7 +801,6 @@ raid5_get_dev_page(struct stripe_head *sh, int disk_i=
dx)
>   }
>   #endif
>  =20
> -void md_raid5_kick_device(struct r5conf *conf);
>   int raid5_set_cache_size(struct mddev *mddev, int size);
>   sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previ=
ous);
>   void raid5_release_stripe(struct stripe_head *sh);

--=20
Thansk,
Kuai
