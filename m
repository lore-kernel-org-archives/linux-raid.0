Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A93A3AAF71
	for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2026 10:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787914546; cv=none; b=nNmERwzBdoPSvVWYfvCefRveBeJUC8bSV/OqdkrSghtVslX6JCofzoe8F/eOdKwkQdSlH1mPGJ0kqGdw5wmMG6DzT/EXwZfjtZ1iWuIxW/6knSVbGbjnkhOqWQZoo24+rIjGmjC+SFEQO1iib6EsaezkDfoGkYtgN581SyUn4yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787914546; c=relaxed/simple;
	bh=OItBJ8JERJbN2Bd7lZ3CR9n5/gcB9X/8/kDXoHpCLkQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r3+M2HXkd0FF6n1JFvZ5N0LJ9OaBSoKejW1vdVmknRijFSP/M9lIF9reyl7AGnjoN4QVPyhMPt8q+0xaDUo4eZRCpYIiM2GhzNb7lVBwWew3ERYTZO1Nwvxen3FJJZmqbb23rmhCGENg59OVF3xUCg7M8LlHH7pm5CskdrfMs+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOik2cal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOik2cal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162E71F000E9;
	Fri, 28 Aug 2026 10:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787914545;
	bh=tUpb0Amm2kateQ3rHqBbIvQix1QyRvZMZU+O7Z27L+0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KOik2calr+WU9xLKSmHM/IPyJF1h7OtAPhHVDwva4R1Mjl+QBsxB2pW3wMwH9vU4y
	 LEq1ToSNgEy1PFv6v9s05yigNfFD1nRym/W3yJIZ52NGQ/VRJSD0MOIXgXr9FoCGET
	 EUFtDj0z5QwfZ1Kl+ABQ2vPFrTlY2V5Ytb6ituKWFOGk/SZ3RGFzrBO1+4ms9QE0yT
	 MdhRZ/WT2RqeUMrg3sl+5M8edkJeO5lLhvZQ94pAcw58HcqN7Offn1z4ZepcseJFWS
	 p3OKQoXf712vvcO/PG61vX6wFtCkyXdViw+KLyBiiBSR72F1z2T+bkSN/TSz9aWgYf
	 RzqniFTsLcOiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid1: prevent a race between write and stop request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Adam Davis" <eadavis@sina.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260828103957.245658-1-eadavis@sina.com>
References: <6a908777.1d9ded08.62e62.00da.GAE@google.com>
 <20260828103957.245658-1-eadavis@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 28 Aug 2026 10:55:44 +0000
Message-Id: <20260828105545.162E71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] Using an interruptible mutex in the I/O path causes normal use=
r-space signals to spuriously fail legitimate writes with I/O errors.
- [High] Global lock acquisition in the high-frequency block I/O fast path =
completely serializes all RAID1 write requests.
- [High] Acquiring `reconfig_mutex` in the block I/O submission path causes=
 a fatal lock-inversion deadlock during memory reclaim.
- [High] Holding `reconfig_mutex` while sleeping in `wait_blocked_rdev()` i=
ndefinitely blocks the MD management thread from clearing the blocked state.

Pre-existing issues:
- [High] The patch only protects WRITE requests, leaving the READ path enti=
rely unpatched and vulnerable to the original race condition causing a NULL=
 pointer dereference.
--

commit 75f3c8447cce610e8b9e2c583ca2b414877078df
Author: Edward Adam Davis <eadavis@sina.com>

md/raid1: prevent a race between write and stop request

This commit attempts to fix a race condition between write and stop requests
that leads to a null pointer dereference. It introduces synchronization in
the write path using the mddev lock to ensure the consistent state of mddev
members during a write request.

Closes: https://syzkaller.appspot.com/bug?extid=3D3fe892ea5fc292e1353f

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f0646fb24371f..3b9f1fa65e654 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1692,11 +1693,36 @@ static bool raid1_make_request(struct mddev *mdde=
v, struct bio *bio)
>  	if (bio_data_dir(bio) =3D=3D READ)
>  		raid1_read_request(mddev, bio, sectors, NULL);

[Severity: High]
This is a pre-existing issue, but it appears the read path is still
unprotected and vulnerable to the same race condition.

Since the patch only wraps the write path, if a concurrent do_md_stop() runs
while a READ request is processed, raid1_read_request() will fetch
mddev->private without protection. Could this result in the exact same null
pointer dereference crash on reads when wait_read_barrier() is called?

>  	else {
> +		int err;
> +
>  		md_write_start(mddev, bio);
> -		if (!raid1_write_request(mddev, bio, sectors))
> +		err =3D mddev_lock(mddev);

[Severity: High]
By acquiring mddev_lock() (which takes the global reconfig_mutex) in the
hot I/O submission path, are all RAID1 write requests completely serialized?
Taking a global reconfiguration mutex on every single write request could
degrade array scalability and I/O concurrency.

[Severity: High]
Could acquiring reconfig_mutex in the block I/O submission path also cause
a lock-inversion deadlock during memory reclaim?

If a thread holds reconfig_mutex (for example, during md_import_device())
and performs a GFP_KERNEL allocation, direct reclaim could write dirty pages
to the RAID array. Since raid1_make_request() attempts to acquire
reconfig_mutex via mddev_lock(), this might cause a direct self-deadlock.

> +
> +		if (err < 0) {
> +			md_write_end(mddev);
> +			status =3D BLK_STS_IOERR;
> +			goto done;
> +		}

[Severity: Critical]
By translating a failed interruptible mutex lock into BLK_STS_IOERR, could
normal user-space signals spuriously fail legitimate writes?

mddev_lock() uses mutex_lock_interruptible(), which returns -EINTR if a
signal is pending. If a userspace process performing I/O receives a benign
signal (like SIGALRM) while submitting a write, this path seems to fail the
write with an I/O error instead of transparently retrying or blocking.

> +
> +		if (!mddev->private) {
> +			mddev_unlock(mddev);
> +			md_write_end(mddev);
> +			status =3D BLK_STS_OFFLINE;
> +			goto done;
> +		}
> +
> +		err =3D raid1_write_request(mddev, bio, sectors);
> +		mddev_unlock(mddev);

[Severity: High]
Since reconfig_mutex is held across the entirety of raid1_write_request(),
could this block the MD management thread indefinitely?

If a write request encounters a blocked device and sleeps in
wait_blocked_rdev() inside raid1_write_request(), the I/O thread will be
holding reconfig_mutex. The MD management thread (md_check_recovery()) needs
to clear the blocked state, but it uses mddev_trylock() to acquire
reconfig_mutex. Since the I/O thread holds the lock, the management thread
will fail to acquire it, potentially leaving the I/O thread blocked forever.

> +
> +		if (!err)
>  			md_write_end(mddev);
>  	}
> +out:
>  	return true;
> +done:
> +	bio->bi_status =3D status;
> +	bio_endio(bio);
> +	goto out;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260828103957.2456=
58-1-eadavis@sina.com?part=3D1
