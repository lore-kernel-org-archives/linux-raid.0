Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAEC46F4B0
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 07:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706807; cv=none; b=Pvr5kDZNBmy92n9eSplwrRPbRtkZdGE7eGx38Bm2cej8FQ5B8JkZImQPJWhJONRR1Kk+hitvwonhd8uOnyGTuVR/qlbRHlVK0ntOAhkHWY6dvvfWHI9cDIdNUZWV7hhNxd97Iyn7QhbQ9445qNZXMV5YaVgE4XQC7bUPemBJaUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706807; c=relaxed/simple;
	bh=4rYBQtJkHbu1W5FCyVPd0aBY/YJDW+RscnYeu+2Gcos=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YdJfUUk91B8TrKi1qcYjrk1Pr5oSAjQ2leA36lgfaQcLI9rq2ZehYeqo/K6llt1yVoUj/c5S4t3kN5xoMmKK6/mvTrYqM14Rc1d/N1s3ZOhKW9eYKI619LXz+8WMjrB8S7dLNEC2Viuqujhr75rQxXaiPyB2vSARtZh7LIY+fj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0m10Wl+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0m10Wl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6DE1F000E9;
	Wed, 22 Jul 2026 07:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706806;
	bh=GTkTXNvfilaR6b9gSkZ8i0J1XjPlSfphGwCVUPPew2E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B0m10Wl+Kv4kjm9R3oz7R3w89le9iej6DI8lyGvz/F3vnWfZd8Mje+gu3Fg+r9Nj+
	 7QXC5YtptMM+rElpSOE3ROtPN0Ul/cJoGRChqsOKLavbPnaUqMHzMZFhEsmOXcE8ym
	 uqd4hZ3NvVQFMahOgyOpsypyjwTfW0SqrweJRHV417PQKtOJ1XNvvCLIh5x5z4kO3h
	 ozN5s4OY7y2MTZVUAnhbKM6qXfDHzGk6yEuYxKoA/ky/ii5AR/bzLMw24G+F54WGsU
	 MoNr+6giy/2MmfTno2KqM8Fr1nxiM6Rhuecug/2VUPeIvg0dOgPw4ERRjc+sQIgRM/
	 A4DUsAxAzdCEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid10: honor REQ_NOWAIT in wait_blocked_dev()
Reply-To: sashiko-reviews@lists.linux.dev
To: dayou5941@163.com
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260722072645.2714771-1-dayou5941@163.com>
References: <20260722072645.2714771-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 07:53:25 +0000
Message-Id: <20260722075325.CC6DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Dropping the barrier in `wait_blocked_dev()` allows concurrent=
 reshape to invalidate the physical mapping, leading to data corruption.
- [High] Pre-existing memory leak of `r10_bio` in `raid10_write_request()` =
when returning early due to `REQ_NOWAIT`.
- [High] `wait_blocked_dev()` incorrectly checks the first `conf->copies` p=
hysical disks for blocked state, rather than the dynamically calculated tar=
get disks.
- [High] Allocation of `r10_bio` unconditionally sleeps, violating `REQ_NOW=
AIT` semantics.
- [High] TOCTOU Use-After-Free of `md_rdev` due to missing `rcu_read_lock()=
` in `raid10_write_request()` and `wait_blocked_dev()`.
--

--- Patch [1]: [PATCH] md/raid10: honor REQ_NOWAIT in wait_blocked_dev() ---
commit 4ef20896ea5200b8191d2a0afa7c08883eacb0e6
Author: liyouhong <liyouhong@kylinos.cn>

md/raid10: honor REQ_NOWAIT in wait_blocked_dev()

The patch modifies wait_blocked_dev() in the raid10 driver to honor the
REQ_NOWAIT flag. It returns false immediately if a blocked device is
encountered during a nowait write request, instead of sleeping. The write
path then releases the barrier, frees the bio, and returns a wouldblock err=
or.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df8..2ccca42e07029 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1293,7 +1293,8 @@ static void raid10_write_one_disk(struct mddev *mdd=
ev, struct r10bio *r10_bio,
>  	}
>  }
> =20
> -static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
> +static bool wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio,
> +			     bool nowait)
>  {

[Severity: High]
This isn't a bug introduced by this patch, but how does wait_blocked_dev()
identify the correct mapped target disks?

The loop examines conf->mirrors[i] instead of using the dynamically
calculated target disk indices:

wait_blocked_dev() {
    ...
    for (i =3D 0; i < conf->copies; i++) {
        struct md_rdev *rdev, *rrdev;
        rdev =3D conf->mirrors[i].rdev;
    ...
}

Might this loop hardcode the check for the first conf->copies physical
disks, ignoring the actual target disks stored in r10_bio->devs[i].devnum
by raid10_find_phys()? This could risk bypassing blocked checks for disks
that the IO will actually touch.

>  	struct r10conf *conf =3D mddev->private;
>  	struct md_rdev *blocked_rdev;
[ ... ]
> @@ -1323,6 +1324,8 @@ static void wait_blocked_dev(struct mddev *mddev, s=
truct r10bio *r10_bio)
>  				set_bit(BlockedBadBlocks, &rdev->flags);
> =20
>  			if (rdev_blocked(rdev)) {
> +				if (nowait)
> +					return false;
>  				blocked_rdev =3D rdev;
>  				atomic_inc(&rdev->nr_pending);

[Severity: High]
This is a pre-existing issue, but is there a use-after-free risk for
md_rdev here?

Because atomic_inc(&rdev->nr_pending) is executed without holding
rcu_read_lock(), could a concurrent raid10_remove_disk() check the
pending count, find it zero, and call md_kick_rdev_from_array(),
freeing the device before the increment occurs?

A similar pattern happens in raid10_write_request() where
atomic_inc(&rdev->nr_pending) is also called without rcu_read_lock()
protection.

>  				break;
>  			}
[ ... ]
> @@ -1347,6 +1352,7 @@ static void wait_blocked_dev(struct mddev *mddev, s=
truct r10bio *r10_bio)
>  		wait_barrier(conf, false);

[Severity: Critical]
This isn't a bug introduced by this patch, but can dropping the barrier
allow a concurrent reshape to invalidate the physical mapping?

When a blocked device is found, the synchronization barrier is dropped:

wait_blocked_dev() {
    ...
    allow_barrier(conf);
    md_wait_for_blocked_rdev(blocked_rdev, mddev);
    wait_barrier(conf, false);
    ...
}

Since raid10_find_phys() was already called before wait_blocked_dev(),
could a waiting reshape thread freeze the array, move data, and advance
reshape_progress while the barrier is dropped? If that happens,
raid10_write_request() might use a stale physical mapping in
r10_bio->devs to submit the IO after the barrier is re-acquired.

>  		goto retry_wait;
>  	}
> +	return true;
>  }
> =20
>  static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
> @@ -1421,7 +1427,12 @@ static bool raid10_write_request(struct mddev *mdd=
ev, struct bio *bio,
>  	r10_bio->read_slot =3D -1; /* make sure repl_bio gets freed */
>  	raid10_find_phys(conf, r10_bio);
> =20
> -	wait_blocked_dev(mddev, r10_bio);
> +	if (!wait_blocked_dev(mddev, r10_bio, bio->bi_opf & REQ_NOWAIT)) {

[Severity: High]
This is a pre-existing issue, but are we leaking the r10_bio structure
on early returns in raid10_write_request()?

When REQ_NOWAIT is set and the IO overlaps with a clustered resync or
reshape, the function correctly bails out early, for example:

raid10_write_request() {
    ...
    if (bio->bi_opf & REQ_NOWAIT) {
        allow_barrier(conf);
        bio_wouldblock_error(bio);
        return false;
    }
    ...
}

If the function returns false without calling free_r10bio(r10_bio), will
this permanently leak the slab memory allocated for r10_bio?

[Severity: High]
This isn't a bug introduced by this patch, but would the initial allocation
of r10_bio violate REQ_NOWAIT semantics?

Before reaching the newly added nowait logic, the caller (__make_request)
unconditionally allocates r10_bio using GFP_NOIO:

__make_request() {
    ...
    r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
    ...
}

Since GFP_NOIO allows direct reclaim, could this allocation sleep if the
mempool is exhausted, regardless of whether bio->bi_opf & REQ_NOWAIT
is set?

> +		allow_barrier(conf);
> +		free_r10bio(r10_bio);
> +		bio_wouldblock_error(bio);
> +		return false;
> +	}
> =20
>  	max_sectors =3D r10_bio->sectors;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722072645.2714=
771-1-dayou5941@163.com?part=3D1
