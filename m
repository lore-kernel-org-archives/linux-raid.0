Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7555C38A29A
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 06:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284335; cv=none; b=eqvGbAtgAMJHoFmiJB4RlQt0NpDWXtaqAdJUzzAsyocplHSHVSi9W+QtaOLJPS2wN/S39CDUNXqUGXrFS31NeD1kfa9987LXNbQCmeaKSCDIabrmNKj9uqitwFAH/z6iS1Ht5M3YcPy2cNzimi3Dy+CU1JKe9rN948j0lgsCPIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284335; c=relaxed/simple;
	bh=FhMMgFTy6aM5NTF82HiPHn3gIHJIwp5r8jBEzxwVrHc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pFwLdsFZt7x7SwomtnSxYSqHXuLcTkpMhTFoMYVWP7y7ik48wSuWjT+TvNuLtXrPFfdiv3dufkmI35AitmfpphZElRReEIinNHIeF+tJoT/ezgdtcCYuG6FTQO0NatmtRc8gTU8WjciVb60exd4sIm3hftzsy/2cqhPiptuC9aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAY2enHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAY2enHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5D21F00A3A;
	Wed, 24 Jun 2026 06:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284334;
	bh=5ZvB/PIIco5iZeNZWccBUb2ooPevuSNWrQIYZgzF240=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gAY2enHTJmdo5+gnEgoFQJtMc80EsNnnj5QFM2vn0Az62fYzYoIj9DvxUHAvz0dbd
	 HRQsRXN2/Oi1GY9A9Dm1YmZZhZlkUtip36tX6twWqnLpXn1CNIVF2OLXI45W3z1ExI
	 NZTn8uCcnqxts8yxh9sxIEMu4jGQRt0W3z+bzcCtSXXAojQNBpYlkU5ziDP3rBpQl3
	 AppnmMFoJv4JTchOqoePHtU4GGKMYVh7tTI4G7u/Vcs/7Svx93buzEWLpZ7ca7yQtr
	 rwDlh18kEWAqYZ6Un+uxmtV26Hs1/FeuSxe+e4ftPLJM/jrb6ug2bCZYmR6WI8Kvwk
	 CUExMz+rAYKhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/20] md/md-llbitmap: don't skip reshape ranges from
 bitmap state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <11d028037df1acf02db6d67a362ab02e96a7dd57.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <11d028037df1acf02db6d67a362ab02e96a7dd57.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 06:58:53 +0000
Message-Id: <20260624065853.ED5D21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Use-After-Free (UAF) of `llbitmap` memory during dynamic bitma=
p unregistration.
- [High] Signed integer overflow in `llbitmap_skip_sync_blocks` can cause p=
remature resync termination.
--

commit 008d5398fa7aa1473594e503af861f03ef4f2548
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: don't skip reshape ranges from bitmap state

Reshape progress is tracked by array metadata rather than llbitmap.
Do not let llbitmap skip_sync_blocks() suppress reshape ranges based on
stale bitmap state before the corresponding checkpoint is persisted.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index d27993cfb13da..c62397743d9a0 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1647,6 +1647,14 @@ static sector_t llbitmap_skip_sync_blocks(struct m=
ddev *mddev, sector_t offset)
>  		return 0;
>  	c =3D llbitmap_read(llbitmap, p);
> =20
> +	/*
> +	 * Reshape progress is tracked by array metadata rather than llbitmap.
> +	 * Skipping reshape ranges from stale bitmap state can lose data after a
> +	 * restart before the corresponding bits are checkpointed to disk.
> +	 */
> +	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> +		return 0;
> +
>  	/* always skip unwritten blocks */
>  	if (c =3D=3D BitUnwritten)
>  		return blocks;

[Severity: High]
This is a pre-existing issue, but since we are modifying this function, is
there a risk of signed integer overflow when returning blocks here?

If the array is extremely large and reserved bitmap space is small,
llbitmap->chunksize can be doubled during initialization until it exceeds
INT_MAX.

Because blocks is calculated earlier in this function as an int:

    int blocks =3D llbitmap->chunksize - (offset & (llbitmap->chunksize - 1=
));

If chunksize exceeds INT_MAX, blocks could become negative.

When this negative value is implicitly cast to the sector_t (unsigned 64-bi=
t)
return type, it becomes a massive positive number.

Could this cause md_do_sync() to jump to the end of the array and
prematurely abort the synchronization?

Would it be safer to change the type of blocks to unsigned long or sector_t?


[Severity: Critical]
This isn't a bug introduced by this patch, but looking at the teardown
sequence elsewhere in this file for dynamic bitmap unregistration, does
llbitmap_destroy() have a use-after-free vulnerability?

When clearing the bitmap at runtime, llbitmap_destroy() deletes the timer
and flushes the workqueues without setting the LLPageFlush flag:

    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);
    flush_workqueue(md_llbitmap_unplug_wq);
   =20
    mddev->bitmap =3D NULL;
    llbitmap_free_pages(llbitmap);
    kfree(llbitmap);

If the daemon worker (md_llbitmap_daemon_fn) is running on the workqueue,
timer_delete_sync() might do nothing if the timer already fired. The
flush_workqueue() call then waits for the worker to finish.

Inside the worker, because LLPageFlush is not set and idle pages have an
expire of LONG_MAX, it sets restart =3D true and re-arms the timer:

    if (!test_bit(LLPageFlush, &pctl->flags) &&
        time_before(jiffies, pctl->expire)) {
        restart =3D true;
        continue;
    }
    ...
    if (restart)
        mod_timer(&llbitmap->pending_timer, ...);

Once the worker finishes, flush_workqueue() returns and llbitmap is freed.
Does this leave the timer armed on freed memory, potentially causing memory
corruption when it fires?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D11
