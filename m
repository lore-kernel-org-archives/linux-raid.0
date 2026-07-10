Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0431E0E14
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690869; cv=none; b=O03Wd7WkH+FASSAXEZUdJUuxh/pLCE7+FfGo9Pnx4obD2RLQHkEA/brRwsHrN7VMv1VRnj3e/jQynPVIhlyJkKyUCH/XGK4r4jljGmV2OwUpQIzK/1LenRJ3O5RkEKpiPI1W+PBjvWd6tnm29T8ChzI16jqTwLSM60LorzDR79g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690869; c=relaxed/simple;
	bh=Q9nyyo3lFedrGWj661Ej5LWM9nOL7dZu981R0cfuFIg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KcxPKBj2or7pljrMpYgfvZeiE+8wbQ34iOiV2x0hy0Si2RkSHqApX+Zqk0X3Oh4+MrnMgPPhIRW5r9M342Bv1WCqJ03/M09dO+buip493ptCzTj8ofA3DsnW23v+tZwqAKdlKrShqRfMJMXjFevLpokHGG7Gtf16MS/G+S6FhqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/bxNT7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/bxNT7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E1F1F000E9;
	Fri, 10 Jul 2026 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690867;
	bh=Mcd/q2rcYOHJUeyANeW4/f8cqjwdFQQfKHqYB2wemq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L/bxNT7iLMimfm2iPr3Ue6RJ5ySvrSZqKjaoySn8UzhdK1G2lzsbAMBGhJQO7qJkl
	 c8EMt4NwiqD/5dj/jWw0wDymae3lWr6wEaP/ojoB++kcUwFGrwB3jQtweK/2XyYhNj
	 t0G11hkHLc3xdAqylkAU+J9P3ZSY+9lUZoKYG6NQVyMvIbpRn9jEZAUvM3yJB29S2j
	 0y3qaolz5C4WOW8E3ToS2+zbVoCHGlLGbooH3f0reA5BzFH0tqM6xIR3qS3pyIHcTN
	 +WjcBgGf6AqPwrwbi3Q8JtvmvsesK4pPFxJEXiew97FHFxS2zFi45HKlVq7LzntEDu
	 TiGKQakYWatyg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] md/raid5: size stripe-cache hash locks from the CPU
 count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260710132346.7295-3-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
 <20260710132346.7295-3-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:41:07 +0000
Message-Id: <20260710134107.A1E1F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Time-of-check to time-of-use (TOCTOU) race condition in `nr_stripe=
_hash_locks` module parameter evaluation can lead to undefined behavior and=
 a potential kernel panic during array creation.

Pre-existing issues:
- [High] The worker threads (`r5worker->work`) are not explicitly canceled =
or flushed during array teardown, which can lead to a Use-After-Free.
--

--- Patch [2]: [PATCH 2/6] md/raid5: size stripe-cache hash locks from the =
CPU count ---
commit bae2376a7fe52c6b3de7d64514b554d3101957fe
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: size stripe-cache hash locks from the CPU count

This commit modifies the stripe cache hash to use a per-array dynamic count
of spinlocks instead of a fixed 8, automatically sizing it based on the
online CPU count to reduce lock contention on many-core systems.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d8807114a6932..7f72981121fd5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -7448,6 +7453,9 @@ static void free_conf(struct r5conf *conf)
>  	kfree(conf->disks);
>  	bioset_exit(&conf->bio_split);
>  	kfree(conf->stripe_hashtbl);
> +	kfree(conf->hash_locks);
> +	kfree(conf->inactive_list);
> +	kfree(conf->temp_inactive_list);
>  	kfree(conf->pending_data);

[Severity: High]
This is a pre-existing issue, but looking at the teardown sequence, could
the worker threads access freed memory here?

During array teardown, md_stop() eventually causes a wait for
active_stripes to reach 0. In a worker thread executing raid5_do_work(),
active_stripes drops to 0 when handle_active_stripes() finishes releasing
the final stripes.

At this point, raid5_quiesce() wakes up and teardown proceeds to call
free_thread_groups() which frees the worker structures without calling
flush_workqueue() or cancel_work_sync().

The still-executing worker thread could then drop its lock and continue
to execute flush_deferred_bios() and r5l_flush_stripe_to_raid() using the
freed structures.

Should the worker threads be explicitly canceled or flushed before the
structures are freed?

[ ... ]
> @@ -7565,6 +7573,38 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>  	if (conf =3D=3D NULL)
>  		goto abort;
> =20
> +	/*
> +	 * Size the stripe cache hash-lock striping per array.  The
> +	 * nr_stripe_hash_locks module parameter selects the count: 0 (the
> +	 * default) auto-sizes it from the online CPU count so busier machines
> +	 * stripe the locks wider, while a non-zero value overrides that.  The
> +	 * result is rounded up to a power of two (the hash uses it as a
> +	 * bitmask) and capped at NR_STRIPE_HASH_LOCKS_MAX; the auto path also
> +	 * keeps at least the historical NR_STRIPE_HASH_LOCKS_DEFAULT so small
> +	 * systems are unchanged.  Allocating per array means an untuned system
> +	 * uses no more memory than before.
> +	 */
> +	if (nr_stripe_hash_locks =3D=3D 0)
> +		conf->nr_hash_locks =3D clamp_t(unsigned int,
> +				roundup_pow_of_two(num_online_cpus()),
> +				NR_STRIPE_HASH_LOCKS_DEFAULT,
> +				NR_STRIPE_HASH_LOCKS_MAX);
> +	else
> +		conf->nr_hash_locks =3D roundup_pow_of_two(
> +				min_t(unsigned int, nr_stripe_hash_locks,
> +				      NR_STRIPE_HASH_LOCKS_MAX));

[Severity: High]
Could this be vulnerable to a time-of-check to time-of-use race if the
sysfs parameter is modified concurrently?

If the module parameter is changed from a non-zero value to 0 right after
the check:

Thread 1 in setup_conf():
    if (nr_stripe_hash_locks =3D=3D 0)
        // check fails, proceeds to else block

Thread 2 writing to sysfs:
    nr_stripe_hash_locks =3D 0;

Thread 1 inside the else block:
    conf->nr_hash_locks =3D roundup_pow_of_two(min_t(..., 0, ...));

In this scenario, roundup_pow_of_two() would evaluate to 0. When kcalloc()
is subsequently called, it would return the zero size pointer placeholder
value (16).

The safety check testing for a null pointer would fail to catch this since
16 is non-null, and the kernel could panic when spin_lock_init()
dereferences it.

Would it be safer to read the parameter into a local variable first?

    unsigned int locks =3D READ_ONCE(nr_stripe_hash_locks);
    if (locks =3D=3D 0)
        conf->nr_hash_locks =3D clamp_t(...);
    else
        conf->nr_hash_locks =3D roundup_pow_of_two(...);

> +	conf->hash_locks_mask =3D conf->nr_hash_locks - 1;
> +	conf->hash_locks =3D kcalloc(conf->nr_hash_locks,
> +				   sizeof(*conf->hash_locks), GFP_KERNEL);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132346.7295=
-1-nishidafmly@gmail.com?part=3D2
