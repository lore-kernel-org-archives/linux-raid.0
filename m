Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3B63CC9EA
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 21:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785446452; cv=none; b=tcGpF2tmD1euH+e41nUFuIUjDsx+pvFdao4QpgffFgs6ZFxLMvhyCcoiMl7QhK8vnW1+XiKCM3i9Xwe+SMcy/JQgnTzT7+XoT1fw/of+oU1mhL90wJopy1Anm59qLAc2AbRjSGat1Ayt8vxG/pb9dDHdP8MhbwdEnOg6eQ7OkB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785446452; c=relaxed/simple;
	bh=wmUbHv8sink2+kwEE1Sgxy9M19irKMdTfp88f89iM70=;
	h=References:In-Reply-To:To:Subject:Date:Content-Type:Cc:From:
	 Mime-Version:Message-Id; b=Wh8x4Q9NEqtzCzAyo2E9DANWXBajVcPXMvo9KSsuPbtjgXzxH31l+zjcpZGrAN+6u5r0mnJGKjrJCs6e4eeXb0JlJDauBrYqzOEU2CSdX3ynBvCVPYI9Bb6FcoxAYe8noqVJVAC/45hssBJ4PadMu/VuzT/B70mQxNHVSlKSoY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=cmLgYCZe; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="cmLgYCZe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785446445;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LekFqNF5ITVYuu0NHbiKimn14kqZbTTuQ1vgAFXEn/c=;
 b=cmLgYCZeqpSEFMhXLhyV04zfoZLMrPHs2vFjTs95peuTh/KhcE6EtkWCKZSN1XBxCDFUO+
 3XZ+m5iQnSsVHHLAUJc0+Wf6P05aeYgcsEesJYCDv0u+wbCqmbPwFepRYc2byfsz6zeOgk
 KXUq/t5juHSvlVPzZDuH92+TUV0bnOdI313S0WaOZGXjWqfxRfDoZN5Gbl794tGagFknY9
 bEVIzpiOEm0VNYYZ9sR4ECwgp8FhDUJ20Lev2E8s+obJ0TbPCRthTngR+foYa8itYMA7PP
 1wyNUp+RfdWXjCGTIIbbMc8njx4RoqjNCqWxiKFPPul+BkkqtY9rEqcpVsSlLw==
References: <20260710132346.7295-1-nishidafmly@gmail.com> <20260710132346.7295-7-nishidafmly@gmail.com>
In-Reply-To: <20260710132346.7295-7-nishidafmly@gmail.com>
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 6/6] md/raid5: derive the default group_thread_cnt from the hardware
Date: Fri, 31 Jul 2026 05:20:41 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a6bc02d+e15fad+vger.kernel.org+yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 21:20:44 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Message-Id: <c482f95e-870e-4f6a-b9c2-4fdaf6cf713a@fygo.io>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:
> setup_conf() starts every array with worker_cnt_per_group =3D 0, i.e. a
> single raid5d thread and no worker groups.  On a many-core host backing a
> fast, wide array that single thread is the bottleneck; the multi-threadin=
g
> that group_thread_cnt enables has to be turned on by hand, per array,
> after every assembly.
>
> Pick a starting value from the CPU count instead.  When the new
> group_thread_cnt_default module parameter is left at -1 (the default),
> raid5_default_group_thread_cnt() uses half the online CPU count spread
> across the NUMA nodes, capped at 256:
>
> 	gtc =3D num_online_cpus() / (2 * nr_nodes)
>
> The count is per NUMA node, matching alloc_thread_groups(), so dividing b=
y
> the node count keeps the total near half the CPUs regardless of socket
> count.  It is only a ceiling: raid5_wakeup_stripe_thread() wakes workers
> in proportion to the queued stripe count, so a lightly loaded array uses
> far fewer than the maximum.  A lone worker is not worth its overhead over
> raid5d, so a result of 1 collapses back to 0, which keeps boxes with two
> or fewer CPUs single-threaded.
>
> Measured on a 16-disk raid6 array of NVMe SSDs (a 32-vCPU host: 16 cores,
> two NUMA nodes; steady state, interleaved runs): the derived count of 8
> raises throughput 2.1-3.2x over the single-threaded default -- 4K random
> write from ~39k to ~100k IOPS (2.6x), mixed database/OLTP/high-concurrenc=
y
> 2.1-2.5x, partial stripe write 3.2x.  There is no regression on smaller
> machines: a 4-CPU box gets 2 workers and is faster or equal on every
> workload, and a box with two or fewer CPUs gets 0 and is byte-for-byte
> unchanged.
>
> group_thread_cnt_default overrides the heuristic (0 forces the historical
> single-threaded behaviour; a positive value pins a count, capped at 256),
> and the existing per-array group_thread_cnt sysfs attribute continues to
> override it at runtime and still accepts up to its own 8192 limit.
>
> Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
> ---
>   drivers/md/raid5.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 42 insertions(+), 3 deletions(-)

There is no test and I'll not accept this patch. And again, please consider
a user space tool or a downstream patch for your production.

>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8e1c2eba4241..6e91eb0ad575 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -88,6 +88,11 @@ module_param(stripe_cache_size_default, uint, 0644);
>   MODULE_PARM_DESC(stripe_cache_size_default,
>   		 "Initial stripe_cache_size for newly created arrays.  0 (the default=
) auto-sizes it from system memory: the historical 256 on small hosts, scal=
ing up with RAM to a capped maximum on larger ones.  A non-zero value sets =
a fixed initial size.  Existing arrays are unaffected");
>  =20
> +static int group_thread_cnt_default =3D -1;
> +module_param(group_thread_cnt_default, int, 0644);
> +MODULE_PARM_DESC(group_thread_cnt_default,
> +		 "Initial group_thread_cnt (raid5 worker threads per NUMA node) for ne=
wly created arrays.  A negative value (the default, -1) auto-sizes it from =
the CPU count; 0 forces the single-threaded raid5d; a positive value sets a=
 fixed count (capped at 256).  The per-array group_thread_cnt sysfs attribu=
te overrides this and allows larger values");
> +
>   static bool devices_handle_discard_safely =3D false;
>   module_param(devices_handle_discard_safely, bool, 0644);
>   MODULE_PARM_DESC(devices_handle_discard_safely,
> @@ -7584,6 +7589,31 @@ static unsigned long raid5_cache_count(struct shri=
nker *shrink,
>   #define RAID5_CACHE_DEFAULT_RAM_SHIFT	9	/* above it: ~1/512 of the extr=
a RAM */
>   #define RAID5_CACHE_DEFAULT_MAX		4096
>  =20
> +/*
> + * Default group_thread_cnt (worker_cnt_per_group) for a new array when =
the
> + * group_thread_cnt_default module parameter is left at -1.  The histori=
cal
> + * default is 0 -- a single raid5d thread -- which cannot keep a fast, w=
ide
> + * array busy on a many-core host.  Derive a starting point from the CPU
> + * count: half the online CPUs divided across the NUMA nodes (this is a
> + * per-node count -- see alloc_thread_groups() -- so the total lands nea=
r
> + * half the online CPUs regardless of socket count), capped at
> + * RAID5_AUTO_GROUP_THREAD_MAX.  This is only a ceiling:
> + * raid5_wakeup_stripe_thread() wakes workers in proportion to the queue=
d
> + * stripe count, so a lightly loaded array uses far fewer.  A lone worke=
r is
> + * not worth its overhead, so 1 collapses back to 0.  The group_thread_c=
nt
> + * sysfs attribute overrides this per array.
> + */
> +#define RAID5_AUTO_GROUP_THREAD_MAX	256
> +
> +static int raid5_default_group_thread_cnt(void)
> +{
> +	unsigned int gtc =3D num_online_cpus() / (2 * num_possible_nodes());
> +
> +	if (gtc > RAID5_AUTO_GROUP_THREAD_MAX)
> +		gtc =3D RAID5_AUTO_GROUP_THREAD_MAX;
> +	return gtc =3D=3D 1 ? 0 : gtc;
> +}
> +
>   static struct r5conf *setup_conf(struct mddev *mddev)
>   {
>   	struct r5conf *conf;
> @@ -7594,6 +7624,7 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>   	int i;
>   	int group_cnt;
>   	struct r5worker_group *new_group;
> +	int def_threads;
>   	int ret =3D -ENOMEM;
>  =20
>   	if (mddev->new_level !=3D 5
> @@ -7677,10 +7708,18 @@ static struct r5conf *setup_conf(struct mddev *md=
dev)
>   		goto abort;
>   	for (i =3D 0; i < PENDING_IO_MAX; i++)
>   		list_add(&conf->pending_data[i].sibling, &conf->free_list);
> -	/* Don't enable multi-threading by default*/
> -	if (!alloc_thread_groups(conf, 0, &group_cnt, &new_group)) {
> +	/*
> +	 * Multi-threading defaults to a hardware-derived worker count (see
> +	 * raid5_default_group_thread_cnt()); group_thread_cnt_default override=
s
> +	 * the choice, and the group_thread_cnt sysfs attribute overrides it pe=
r
> +	 * array.
> +	 */
> +	def_threads =3D group_thread_cnt_default < 0 ?
> +		raid5_default_group_thread_cnt() :
> +		min(group_thread_cnt_default, RAID5_AUTO_GROUP_THREAD_MAX);
> +	if (!alloc_thread_groups(conf, def_threads, &group_cnt, &new_group)) {
>   		conf->group_cnt =3D group_cnt;
> -		conf->worker_cnt_per_group =3D 0;
> +		conf->worker_cnt_per_group =3D def_threads;
>   		conf->worker_groups =3D new_group;
>   	} else
>   		goto abort;

--=20
Thanks,
Kuai
