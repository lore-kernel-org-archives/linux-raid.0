Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EED416D1A
	for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2026 11:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787915093; cv=none; b=RT3XOm1IZjjYgXtASGF/EgOByfmDWgC3bj+wGG5/oqCuocwguAmXBuC3e61Cb/lNoEvT3+Dsxj8rX0w9vaXk8e0JgD5eCTFdidktXsk4c4y3HOrNs7bvFtw00WYgAB3Sy3QFqWDn9YO3hLB2m91azuF8ePy11hDpBySs5xsjtG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787915093; c=relaxed/simple;
	bh=qbyK7L4C3jcKWuriP9XCs/buSubJwCWe+SyAXeYjpss=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VNRs0CP+sDtZAP1ScuRI7FaupZn2EgSfb93tvWryxVYvLNmp5w2HCXWsW/gTjvLEB8OHRdWtMlo5JE1542QwBBlu9svzJGXm1TopxFdhbTYHa8EvNH3EDrxxzpvwUK3h8MHOzVBxjTQCaCidH1Qs62YOSB4FTzG43WSHhv7uM2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cT8BpChX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cT8BpChX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005741F000E9;
	Fri, 28 Aug 2026 11:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787915084;
	bh=qGSkaBWgQf9YNLB48+kyFWIBrtXJ3mHhOKc6clU+5Ck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cT8BpChX6fsKOXlwpCxQlKAESzxxuL063e1l+XqY7AWP1ero8W0VYx/XbIYP6fosF
	 0l5yf9yq+cT5Soud6uXx3tlMxfvgG+C6jHZzEIaiMbbE3NcTKx+/6DV2fZezaf2gqg
	 666THZO0GjZ93M5oEKonDbMbnzTEEaMYvS6I6c5tJ3X+CGS+FMw/FvCJnQ0jjJeZjV
	 zS/YSqIWh6T7DZzs6+bayxfk7imjcSa3NcA41a2btKkURP5kACJUBW09oswTWTjYJ6
	 EYjPiab+4vWpAfDTnSrYVjOTiM33OfbrArgAB1caIBP/4nQd6FcMmM7qbFFilQ5b64
	 z4g/u7J3E0hBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md/raid1: prevent a race between write and stop
 request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Adam Davis" <eadavis@sina.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260828104944.246837-1-eadavis@sina.com>
References: <20260828103957.245658-1-eadavis@sina.com>
 <20260828104944.246837-1-eadavis@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 28 Aug 2026 11:04:43 +0000
Message-Id: <20260828110444.005741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Acquiring a global configuration mutex (`reconfig_mutex`) in the I=
/O fast path serializes all RAID1 writes and violates non-blocking semantic=
s.
- [High] Using an interruptible lock (`mutex_lock_interruptible`) in the bl=
ock I/O submission path causes spurious block I/O errors (`BLK_STS_IOERR`) =
if the submitting process receives a signal.
- [High] Acquiring `reconfig_mutex` in the block I/O submission path (`raid=
1_make_request`) introduces a classic memory reclaim deadlock between in-fl=
ight IOs, `kswapd`, and array management.

Pre-existing issues:
- [Critical] The patch leaves the READ path completely unprotected against =
the concurrent `do_md_stop` Use-After-Free race that it was intended to fix=
 for writes.
--

commit d721c8b809d2e452fb1806262577569049151fb3
Author: Edward Adam Davis <eadavis@sina.com>

md/raid1: prevent a race between write and stop request

The commit aims to resolve a use-after-free triggered by a race condition
between write requests and array stop requests. It does this by taking the
array's reconfig_mutex inside the write I/O submission path.

Closes: https://syzkaller.appspot.com/bug?extid=3D3fe892ea5fc292e1353f

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f0646fb24371f..3b9f1fa65e654 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1692,11 +1693,36 @@ static bool raid1_make_request(struct mddev *mdde=
v, struct bio *bio)
>  	if (bio_data_dir(bio) =3D=3D READ)
>  		raid1_read_request(mddev, bio, sectors, NULL);

[Severity: Critical]
This is a pre-existing issue, but does this bypass leave the read path
completely unprotected against the exact same race condition?

If an array stop operation clears mddev->private concurrently, wouldn't
raid1_read_request() still dereference a freed or NULL conf pointer at:

wait_read_barrier(conf, bio->bi_iter.bi_sector);

>  	else {
> +		int err;
> +
>  		md_write_start(mddev, bio);
> -		if (!raid1_write_request(mddev, bio, sectors))
> +		err =3D mddev_lock(mddev);

[Severity: High]
Does acquiring a global configuration mutex (reconfig_mutex) in the I/O
fast path forcibly serialize all concurrent RAID1 writes and severely degra=
de
block I/O performance?

Will taking a sleeping lock here also violate non-blocking semantics for
asynchronous I/O if REQ_NOWAIT is set?

[Severity: High]
Can acquiring reconfig_mutex in the block I/O submission path introduce a
memory reclaim deadlock?

If memory pressure forces kswapd to write out dirty pages to the RAID1 arra=
y,
will those memory-reclaim writes attempt to acquire reconfig_mutex in
raid1_make_request()?

Since configuration pathways like do_md_stop() hold reconfig_mutex while
waiting for in-flight IOs to drain or performing memory allocations, wouldn=
't
this create an ABBA deadlock that hangs the I/O subsystem?

> +
> +		if (err < 0) {
> +			md_write_end(mddev);
> +			status =3D BLK_STS_IOERR;

[Severity: High]
Does this incorrectly convert a signal interruption into a hard I/O error?

Since mddev_lock() uses mutex_lock_interruptible() to acquire the lock, it
returns -EINTR if the submitting process receives a signal.

Will converting this directly to BLK_STS_IOERR cause spurious block I/O
errors for user space applications and potentially abort filesystem journal=
s?

> +			goto done;
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260828104944.2468=
37-1-eadavis@sina.com?part=3D1
