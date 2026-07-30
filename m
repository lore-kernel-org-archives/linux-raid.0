Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C0E3C3C0B
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 21:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785445946; cv=none; b=bMPrZ2eXO99Pou/ZhzErVVKtai6Ys1bBBM8gikU1sbgQkIh0Y2MTUWI1IV/NrZl070SvyI9e2uS6dCvZZVlqKQhhT7A+SftniorZPRiU9p1zQqidM8vVQ903du7K6i5ecfmFX6YgboH87MP5amaSF3iJej7zYBOC3EMzz87bKz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785445946; c=relaxed/simple;
	bh=qEzxTLP7EwuugtQsoevdZvgPIYW0cNuvWPZMN5mbL9E=;
	h=To:Message-Id:References:Content-Type:Cc:Date:In-Reply-To:From:
	 Subject:Mime-Version; b=ajQyK4WotQenP4C7JCpYX4gxv5PWZ626C7hs1t4QU77/7R/BtoeB5iLG4BL6/cEnU5Fd7BJWLcUg5V7qJZmlqStYohZtS0iABItgMOugjS6QFpom87Xe0ZaG79z8AuL4FI0IIGcIulpNnc/3WtspdTMJBgHcXy5KqqvE01VU1I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=j2j3iYmZ; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="j2j3iYmZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785445939;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yqByWQlgEN+8jNFc27csIFm/KwLjCc0umHafHnJo40I=;
 b=j2j3iYmZFQeSPWiSEm6adotopPfeoLulw0lH2bKqBHYP/O5HoXFvIPD8mlU6oBbJI6sE31
 uvUmGnmJsf/IQDWdb4a70O5zaF6TB+Q2ChAkbK8AbZIg5Hq34+4EC63+g6jaCnynuuQ6pm
 SGc610U2h7CVQAdXMStFe8I1oxUfwY07JfIyOuYSQ7Dj4a0kp6SH96Mu7ZFAffwBtPhJ7P
 bOClv92ZCEsBL84Pnes0/CCuDZ9ztCVzSIaF/j4SVaP71jFRJHgr1c3Zc74LCitvhtL7Wq
 4CNoQsUuadlq93oktUnj/0M4oNi2PvVxM+sckvQVUzKP3vZrffR2IF4FWy4dbw==
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <722b6c6e-8b73-4bd6-8b20-0707ae891ad1@fygo.io>
X-Lms-Return-Path: <lba+26a6bbe32+46bbb7+vger.kernel.org+yukuai@fygo.io>
References: <20260710132346.7295-1-nishidafmly@gmail.com> <20260710132346.7295-5-nishidafmly@gmail.com>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 21:12:18 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 31 Jul 2026 05:12:14 +0800
In-Reply-To: <20260710132346.7295-5-nishidafmly@gmail.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 4/6] md/raid5: make the stripe batch size a module parameter
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:
> handle_active_stripes() dequeues up to MAX_STRIPE_BATCH (8) stripes from =
a
> worker group under a single device_lock acquisition, and
> raid5_wakeup_stripe_thread() divides group->stripes_cnt by the same value
> to decide how many additional workers to wake.  The two uses must move
> together: the dequeue cap bounds how many stripes one worker drains, whil=
e
> the spawn divisor sizes the worker fan-out to match.
>
> Make the batch size a per-array value chosen by a new max_stripe_batch
> module parameter (1-32, default 8, so behaviour is unchanged out of the
> box).  Both the dequeue cap and the spawn divisor read the single
> conf->max_stripe_batch, so they cannot drift apart.  The on-stack batch[]
> array in handle_active_stripes() is sized to the STRIPE_BATCH_MAX (32)
> upper bound; only conf->max_stripe_batch entries are ever used.
>
> The value is resolved when an array is created.  On busy multi-threaded
> arrays a larger batch amortises the device_lock over more stripes at some
> latency cost; unlike the hash-lock count and the cache-size limit there i=
s
> no general hardware signal for the best batch size, so the default is lef=
t
> at the historical 8 and the value is simply exposed for tuning.
>
> Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
> ---
>   drivers/md/raid5.c | 15 ++++++++++++---
>   drivers/md/raid5.h | 12 +++++++++++-
>   2 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e41d3fc92dd0..5f0825c5effe 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -78,6 +78,11 @@ module_param(stripe_cache_size_max, uint, 0644);
>   MODULE_PARM_DESC(stripe_cache_size_max,
>   		 "Maximum the per-array stripe_cache_size may be raised to.  0 (the d=
efault) derives the limit from system memory (never below the historical 32=
768), so large-memory hosts can grow the stripe cache without a recompile w=
hile small ones are not offered a limit above what RAM can back.  A non-zer=
o value sets a fixed limit");
>  =20
> +static unsigned int max_stripe_batch =3D STRIPE_BATCH_DEFAULT;
> +module_param(max_stripe_batch, uint, 0644);
> +MODULE_PARM_DESC(max_stripe_batch,
> +		 "Number of stripes a worker thread handles per device_lock acquisitio=
n, 1-32 (default 8).  Larger values amortise the lock over more stripes on =
busy multi-threaded arrays at some latency cost.  Read when an array is cre=
ated");
> +
>   static bool devices_handle_discard_safely =3D false;
>   module_param(devices_handle_discard_safely, bool, 0644);
>   MODULE_PARM_DESC(devices_handle_discard_safely,
> @@ -221,7 +226,7 @@ static void raid5_wakeup_stripe_thread(struct stripe_=
head *sh)
>   	/* at least one worker should run to avoid race */
>   	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
>  =20
> -	thread_cnt =3D group->stripes_cnt / MAX_STRIPE_BATCH - 1;
> +	thread_cnt =3D group->stripes_cnt / conf->max_stripe_batch - 1;
>   	/* wakeup more workers */
>   	for (i =3D 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
>   		if (group->workers[i].working =3D=3D false) {
> @@ -6734,11 +6739,11 @@ static int handle_active_stripes(struct r5conf *c=
onf, int group,
>   				 struct list_head *temp_inactive_list)
>   		__must_hold(&conf->device_lock)
>   {
> -	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
> +	struct stripe_head *batch[STRIPE_BATCH_MAX], *sh;
>   	int i, batch_size =3D 0, hash;
>   	bool release_inactive =3D false;
>  =20
> -	while (batch_size < MAX_STRIPE_BATCH &&
> +	while (batch_size < conf->max_stripe_batch &&
>   			(sh =3D __get_priority_stripe(conf, group)) !=3D NULL)
>   		batch[batch_size++] =3D sh;
>  =20
> @@ -7640,6 +7645,10 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>   	    !conf->temp_inactive_list)
>   		goto abort;
>  =20
> +	/* Resolve the stripe batch size (see STRIPE_BATCH_* in raid5.h). */
> +	conf->max_stripe_batch =3D clamp_t(int, max_stripe_batch,
> +					 1, STRIPE_BATCH_MAX);
> +
>   #if PAGE_SIZE !=3D DEFAULT_STRIPE_SIZE
>   	conf->stripe_size =3D DEFAULT_STRIPE_SIZE;
>   	conf->stripe_shift =3D ilog2(DEFAULT_STRIPE_SIZE) - 9;
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 10c45fa22955..69a41c1310af 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -490,7 +490,16 @@ struct disk_info {
>   #define BYPASS_THRESHOLD	1
>   #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
>   #define HASH_MASK		(NR_HASH - 1)
> -#define MAX_STRIPE_BATCH	8
> +/*
> + * Stripe batch size: how many stripes a worker dequeues from its group =
per
> + * device_lock acquisition in handle_active_stripes(); the same value di=
vides
> + * group->stripes_cnt in raid5_wakeup_stripe_thread() to choose how many=
 extra
> + * workers to spawn, so the two stay coupled.  Selected per array by the
> + * max_stripe_batch module parameter: STRIPE_BATCH_DEFAULT is the histor=
ical
> + * value and STRIPE_BATCH_MAX bounds the on-stack batch[] array.
> + */
> +#define STRIPE_BATCH_DEFAULT	8
> +#define STRIPE_BATCH_MAX	32
>  =20
>   /*
>    * The stripe cache hash is striped across a power-of-two number of spi=
nlocks,
> @@ -690,6 +699,7 @@ struct r5conf {
>   	struct r5worker_group	*worker_groups;
>   	int			group_cnt;
>   	int			worker_cnt_per_group;
> +	int			max_stripe_batch; /* stripes/dequeue, 1..STRIPE_BATCH_MAX */

This is still weird to use a global module parameter for per-array setting.=
 Please consider
a new per-array sysfs API as well, and pass in while creating or assembling=
 the array.

>   	struct r5l_log		*log;
>   	void			*log_private;
>  =20

--=20
Thanks,
Kuai
