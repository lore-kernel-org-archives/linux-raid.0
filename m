Received: from va-2-17.ptr.blmpb.com (va-2-17.ptr.blmpb.com [209.127.231.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5D73CBE8F
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 21:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785446262; cv=none; b=Npcuu1y2j8+0bzMUvdHcr2rJZW9KO1C3aOgl29G9fbVQkdSn2Sw4XRWt0YIPCh/j1XG8aGt1goKzO16NoC7wQpcdsPqeH+7qdYpVfGpYILgLlmnJd4cbq5+8pO1gpbVYY3e+VEJ6jgizyLm7XVDv+UgUv8uoLDcEElKGz+nvroU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785446262; c=relaxed/simple;
	bh=r4IY0t1jCOMm7MPBcBC9WYUIzSD4j/ghllO5arRGEHo=;
	h=Date:To:Message-Id:Content-Type:Mime-Version:In-Reply-To:Cc:From:
	 Subject:References; b=KfNQBOtYSXztc5BQvDvUJFCGyTqlogUSTVcU4pghksZqK+qZ7m299ASCKF8LF/DiA2TX4FfFNurs0dPKYX/hAiqhjXmjQAqewRFraTZR5padTbE0mZ/xTH9VtbPvypyrFnwef/MSqHmbgW9BJjZq4ecYilF9VezJLcs5ChT5SzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=dWptmauc; arc=none smtp.client-ip=209.127.231.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="dWptmauc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785446250;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=56qAAKPwB6z/FTriGN9uX8ul2jI6j7Vbc3qHN5hdNrA=;
 b=dWptmauc5gWWDFoLXyd6mIvQEP3vcgdxkM51iTLZ92VY1xX0mZghnrhbrWTShyX+S7HvW6
 iGJ7rRGbqcmwO9R08WociYa88LoEv+nYGkCkU3lIud7gkzllx/GlLl6WNAe5adBYlOpnBV
 f1OTVRWoVTJmlu+IwBrQ8ZYNVeaouBXHBHUGj3UwiSHSbx9ayAaSGoiOtVFNr+a7/Nntup
 xsZkV7oIFT2UlVM2OGUHL/iVkgQQJh5462mY2bmiG/t7eU5LQxjKwRUIIy6mPhm2VnmEEA
 /gOmwL/4j+6TjAw/Vs7XMwRvUiS8Ydnnxz9hVcZnHWDXdFcIGcqpQ1XKFoXRWw==
Reply-To: yukuai@fygo.io
Date: Fri, 31 Jul 2026 05:17:25 +0800
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <158faaad-0542-4187-8158-eab5b9876d29@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a6bbf6a+ed8ac4+vger.kernel.org+yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260710132346.7295-6-nishidafmly@gmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 5/6] md/raid5: scale the default stripe cache size with system memory
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 21:17:29 +0000
References: <20260710132346.7295-1-nishidafmly@gmail.com> <20260710132346.7295-6-nishidafmly@gmail.com>
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:
> setup_conf() starts every array with min_nr_stripes =3D NR_STRIPES (256),
> about 12MB of stripe cache on a 12-disk array.  That fixed default was
> chosen for small systems and is never revisited: a server with hundreds
> of GB of RAM backing a wide array still creates its arrays with the same
> 256 stripes, and only benefits from more after an administrator writes
> stripe_cache_size by hand.
>
> Auto-size the initial count from memory when the new
> stripe_cache_size_default module parameter is 0 (the default): keep the
> historical NR_STRIPES up to RAID5_CACHE_DEFAULT_BASE_GB (8GB) of RAM, the=
n
> grow the count using about 1/512 of the RAM above that baseline, capped a=
t
> RAID5_CACHE_DEFAULT_MAX (4096).  A system with 8GB or less is therefore
> unchanged -- same count, same footprint -- while larger ones scale up
> smoothly (no jump at the baseline) to a bounded maximum.  A non-zero
> stripe_cache_size_default sets a fixed initial size for administrators wh=
o
> want one; existing arrays are unaffected, and a reshape still forces at
> least its window's worth of stripes.

I will not accept changing the default value for now, unless it's tested an=
d
validated across various architectures and environments.

BTW, if you want to do this, I'll suggest you write a user space tool.

>
> Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
> ---
>   drivers/md/raid5.c | 44 +++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 41 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5f0825c5effe..8e1c2eba4241 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -83,6 +83,11 @@ module_param(max_stripe_batch, uint, 0644);
>   MODULE_PARM_DESC(max_stripe_batch,
>   		 "Number of stripes a worker thread handles per device_lock acquisiti=
on, 1-32 (default 8).  Larger values amortise the lock over more stripes on=
 busy multi-threaded arrays at some latency cost.  Read when an array is cr=
eated");
>  =20
> +static unsigned int stripe_cache_size_default;
> +module_param(stripe_cache_size_default, uint, 0644);
> +MODULE_PARM_DESC(stripe_cache_size_default,
> +		 "Initial stripe_cache_size for newly created arrays.  0 (the default)=
 auto-sizes it from system memory: the historical 256 on small hosts, scali=
ng up with RAM to a capped maximum on larger ones.  A non-zero value sets a=
 fixed initial size.  Existing arrays are unaffected");
> +
>   static bool devices_handle_discard_safely =3D false;
>   module_param(devices_handle_discard_safely, bool, 0644);
>   MODULE_PARM_DESC(devices_handle_discard_safely,
> @@ -7568,6 +7573,17 @@ static unsigned long raid5_cache_count(struct shri=
nker *shrink,
>   	return max_stripes - min_stripes;
>   }
>  =20
> +/*
> + * Auto-sizing of the initial stripe cache (stripe_cache_size_default =
=3D=3D 0):
> + * stay at the historical NR_STRIPES up to RAID5_CACHE_DEFAULT_BASE_GB o=
f RAM,
> + * then grow the count using about 1/512 of the RAM above that base, cap=
ped at
> + * RAID5_CACHE_DEFAULT_MAX.  So a system at or below the base is unchang=
ed and
> + * keeps the historical footprint, while larger ones scale.
> + */
> +#define RAID5_CACHE_DEFAULT_BASE_GB	8	/* unchanged at or below this much=
 RAM */
> +#define RAID5_CACHE_DEFAULT_RAM_SHIFT	9	/* above it: ~1/512 of the extra=
 RAM */
> +#define RAID5_CACHE_DEFAULT_MAX		4096
> +
>   static struct r5conf *setup_conf(struct mddev *mddev)
>   {
>   	struct r5conf *conf;
> @@ -7801,15 +7817,37 @@ static struct r5conf *setup_conf(struct mddev *md=
dev)
>   		conf->prev_algo =3D conf->algorithm;
>   	}
>  =20
> -	conf->min_nr_stripes =3D NR_STRIPES;
> +	/*
> +	 * Choose the initial stripe cache size.  stripe_cache_size_default
> +	 * selects it: 0 (the default) auto-sizes from memory -- the historical
> +	 * NR_STRIPES up to RAID5_CACHE_DEFAULT_BASE_GB of RAM, then scaling up
> +	 * to at most RAID5_CACHE_DEFAULT_MAX -- and a non-zero value sets it
> +	 * directly.  A reshape still forces at least enough stripes for its
> +	 * window, below.
> +	 */
> +	if (stripe_cache_size_default) {
> +		conf->min_nr_stripes =3D clamp_t(unsigned long,
> +					stripe_cache_size_default, 16, INT_MAX);
> +	} else {
> +		unsigned long per_stripe =3D sizeof(struct stripe_head) +
> +			max_disks * (sizeof(struct bio) + PAGE_SIZE);
> +		unsigned long ram =3D totalram_pages() << PAGE_SHIFT;
> +		unsigned long base =3D (unsigned long)RAID5_CACHE_DEFAULT_BASE_GB << 3=
0;
> +		unsigned long extra =3D ram > base ?
> +			((ram - base) >> RAID5_CACHE_DEFAULT_RAM_SHIFT) / per_stripe : 0;
> +
> +		conf->min_nr_stripes =3D clamp_t(unsigned long, NR_STRIPES + extra,
> +					       NR_STRIPES, RAID5_CACHE_DEFAULT_MAX);
> +	}
>   	if (mddev->reshape_position !=3D MaxSector) {
>   		int stripes =3D max_t(int,
>   			((mddev->chunk_sectors << 9) / RAID5_STRIPE_SIZE(conf)) * 4,
>   			((mddev->new_chunk_sectors << 9) / RAID5_STRIPE_SIZE(conf)) * 4);
> -		conf->min_nr_stripes =3D max(NR_STRIPES, stripes);
> -		if (conf->min_nr_stripes !=3D NR_STRIPES)
> +		if (stripes > conf->min_nr_stripes) {
> +			conf->min_nr_stripes =3D stripes;
>   			pr_info("md/raid:%s: force stripe size %d for reshape\n",
>   				mdname(mddev), conf->min_nr_stripes);
> +		}
>   	}
>   	memory =3D conf->min_nr_stripes * (sizeof(struct stripe_head) +
>   		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;

--=20
Thanks,
Kuai
