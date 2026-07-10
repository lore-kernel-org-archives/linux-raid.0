Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1459C3F1AB8
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690949; cv=none; b=K5Gbt/ZVXrb33DHJf40wvB9UggGLBAIrI1z4wCp+smbF5PTJjgpFSTVFHx8JiGcaV7xx3Fso/xLCkxRJEFYGMByaCVYcufRfST6B4uI8xK1qTi1P3Q7GTNqLGfzC1FAyMKOgBVb06rWBzr0uVy26gpmR9VVCxjQCSWZ2v6ljez8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690949; c=relaxed/simple;
	bh=IU2e/9bgU2Fwk6rdVwSDZiCbDnMDKITA9nf9vT6WFUc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AGH/TzvO5Jv3/IM5Eqc/Y9nYG8K02t0RijjiGu63EHUphY2wQ7PY9MvrW7I4p+/EFOFQPY91BfkzLsiVFn2nv33GbXDIdPwk8WqRW2tHEL6M/TxD3X1WRchAXQzTl55y1nKZQ/TIvRkbEv3gr+f3zYUAvMU/I+oKB75Ju39RwBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmUKllH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmUKllH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737781F000E9;
	Fri, 10 Jul 2026 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690947;
	bh=auWLF8ZBLLnAzDKZTW83m5b3UK7ot1Y0fDqgVsUn9RU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZmUKllH57uAFU9xN7G3Qg8nk+6aJECxJb8P8U8vX2tB3Q4SIYW4YeXV7vqAhDFUxX
	 5Wn4Dzjtw6d2dBB1ncqL/BWk8TB1XwImhikVexwn1PeN/GuTlH6tQarot5iK/ioW2p
	 7o6twCwXljh0p9JU1ZnyMwqX3jwO5twajNQso8ePirXGCaLRwhcZsTtDJEPl3LO3vr
	 vW/nMLezkSnZWrJJFMY+BgbbpFUoc9Zx83k07B8I7ILekQ6gzouuuLiHxITj40gK52
	 EyBLa1b/jLIPXAbr2/ednUFtbCO4t8eSAp4fu2uoJq48KHXcO9IxyLhjoeGGHxbWuy
	 A3cQBjmBZ10TA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/6] md/raid5: derive the default group_thread_cnt from
 the hardware
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260710132346.7295-7-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
 <20260710132346.7295-7-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:42:24 +0000
Message-Id: <20260710134227.737781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] Double-read of the sysfs-modifiable `group_thread_cnt_default` m=
odule parameter can cause an array initialization failure due to a large ne=
gative worker count.
- [Medium] Massive overallocation of worker threads and worker groups on sy=
stems with sparse NUMA node maps.

Pre-existing issues:
- [High] A failure to register the CPU hotplug instance in `raid5_alloc_per=
cpu()` causes a NULL pointer dereference (Oops) during error cleanup.
--

--- Patch [6]: [PATCH 6/6] md/raid5: derive the default group_thread_cnt fr=
om the hardware ---
commit 9c6dbf46ca41e580ada80950d4adaba43e7b0100
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: derive the default group_thread_cnt from the hardware

This commit updates the RAID5 subsystem to automatically configure the numb=
er of
worker threads per NUMA node based on the hardware CPU count, rather than
defaulting to a single raid5d thread. It calculates a default value bounded=
 by
a cap, and allows overriding this via a new module parameter or the existing
sysfs attribute.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8e1c2eba42417..6e91eb0ad5759 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -7584,6 +7589,31 @@ static unsigned long raid5_cache_count(struct shri=
nker *shrink,
>  #define RAID5_CACHE_DEFAULT_RAM_SHIFT	9	/* above it: ~1/512 of the extra=
 RAM */
>  #define RAID5_CACHE_DEFAULT_MAX		4096
> =20
> +/*
> + * Default group_thread_cnt (worker_cnt_per_group) for a new array when =
the
> + * group_thread_cnt_default module parameter is left at -1.  The histori=
cal
> + * default is 0 -- a single raid5d thread -- which cannot keep a fast, w=
ide
> + * array busy on a many-core host.  Derive a starting point from the CPU
> + * count: half the online CPUs divided across the NUMA nodes (this is a
> + * per-node count -- see alloc_thread_groups() -- so the total lands near
> + * half the online CPUs regardless of socket count), capped at
> + * RAID5_AUTO_GROUP_THREAD_MAX.  This is only a ceiling:
> + * raid5_wakeup_stripe_thread() wakes workers in proportion to the queued
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

[Severity: Medium]
Could this lead to massive overallocation of worker threads on systems with
sparse NUMA node maps?

Here in raid5_default_group_thread_cnt() in drivers/md/raid5.c, gtc is
calculated using num_possible_nodes(), which returns the actual count of
possible nodes. However, alloc_thread_groups() allocates threads based on
nr_node_ids:

drivers/md/raid5.c:alloc_thread_groups() {
	...
	*group_cnt =3D nr_node_ids;
	size =3D sizeof(struct r5worker) * cnt;
	workers =3D kcalloc(size, *group_cnt, GFP_NOIO);
	...
}

If a system has sparse NUMA node IDs (e.g., nodes 0 and 64, making
num_possible_nodes() =3D=3D 2 but nr_node_ids =3D=3D 65), would multiplying=
 the
large gtc value by the highest node ID cause hundreds of unused struct
r5worker and struct r5worker_group instances to be allocated?

> +
> +	if (gtc > RAID5_AUTO_GROUP_THREAD_MAX)
> +		gtc =3D RAID5_AUTO_GROUP_THREAD_MAX;
> +	return gtc =3D=3D 1 ? 0 : gtc;
> +}
> +
>  static struct r5conf *setup_conf(struct mddev *mddev)
>  {
>  	struct r5conf *conf;

[ ... ]

> @@ -7677,10 +7708,18 @@ static struct r5conf *setup_conf(struct mddev *md=
dev)
>  		goto abort;
>  	for (i =3D 0; i < PENDING_IO_MAX; i++)
>  		list_add(&conf->pending_data[i].sibling, &conf->free_list);
> -	/* Don't enable multi-threading by default*/
> -	if (!alloc_thread_groups(conf, 0, &group_cnt, &new_group)) {
> +	/*
> +	 * Multi-threading defaults to a hardware-derived worker count (see
> +	 * raid5_default_group_thread_cnt()); group_thread_cnt_default overrides
> +	 * the choice, and the group_thread_cnt sysfs attribute overrides it per
> +	 * array.
> +	 */
> +	def_threads =3D group_thread_cnt_default < 0 ?
> +		raid5_default_group_thread_cnt() :
> +		min(group_thread_cnt_default, RAID5_AUTO_GROUP_THREAD_MAX);

[Severity: Medium]
Is it possible for a concurrent sysfs write to cause an array initialization
failure due to a large negative worker count?

The module parameter group_thread_cnt_default is evaluated twice without
READ_ONCE() (once in the ternary condition, and once in the min() macro).

Could an administrator writing to the sysfs parameter concurrently with arr=
ay
assembly cause the ternary condition to read a positive value, and the min()
macro to read a negative value, resulting in def_threads becoming -1?

> +	if (!alloc_thread_groups(conf, def_threads, &group_cnt, &new_group)) {
>  		conf->group_cnt =3D group_cnt;
> -		conf->worker_cnt_per_group =3D 0;
> +		conf->worker_cnt_per_group =3D def_threads;
>  		conf->worker_groups =3D new_group;
>  	} else
>  		goto abort;

[Severity: High]
This isn't a bug introduced by this patch, but does the cleanup path for
setup failures lead to a NULL pointer dereference?

If cpuhp_state_add_instance() in raid5_alloc_percpu() previously returned
an error (like -ENOMEM) and failed to register the hotplug node, the error
bubbles up and causes a jump to the abort label.

In the cleanup path, raid5_free_percpu() unconditionally calls
cpuhp_state_remove_instance():

drivers/md/raid5.c:raid5_free_percpu() {
	if (!conf->percpu)
		return;
	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
	...
}

Because conf->node is completely zero-initialized and was never successfully
hashed, its pprev pointer is NULL. Won't the subsequent hlist_del() in the
teardown path dereference this NULL pointer and crash the kernel? Should we
check hlist_unhashed(&conf->node) before removing the instance?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132346.7295=
-1-nishidafmly@gmail.com?part=3D6
