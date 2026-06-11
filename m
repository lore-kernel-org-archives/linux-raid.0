Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14363403B13
	for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 13:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781185292; cv=none; b=XFfZK2rwqNoTMrjXmpsNh6YxjjND6M+IO9vqgcDDD3LWxOFocz1UBOch35Oc7DSZe/kIzSzO/a0i7/zE1pF32mS3SU98CT/a8VdzUssZPRdbSesYAw+xilNe3FlSjLCD0nzux/lV/3djYr1AB5DeHIORhpl7tfic4/v2moGt3HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781185292; c=relaxed/simple;
	bh=7Iaj8sWD8FhDln4mHnro7gZqNr/5cW6+tbO/xUj3Kpc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VkgV695X1gDAsLh2bd9Vawhq06pKCXi03kOZ+twrScI3nIJstdSxbLef10ZDaB+jSct5Kn8A+0BsAlCiKtONibPZZQfPk8SPAX0rDdo2vwtQNDWA+0ENe4hUfmp6QBn33bjhc+wOZ6gYVGU3Qb1nZD7csgXyNYaxjNSpY12v/8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N2VtWpkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N2VtWpkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E911F00893;
	Thu, 11 Jun 2026 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781185290;
	bh=9xaB7sqAL3+nsjBOWsN+Qv03YmQHrOa3kYaMes+FByY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N2VtWpkn4xyb48PKJKxV7Ajcs6qHQ7Zaqey1JPpMHlhojwDfXn5PUGUB2lNh+fwpL
	 nxBXiFuWXfvT3ow+1dh5YZ4cFEWoDIhGTgFdvUfYH9jSkEEaIXqPPS/iUU/RohB8fu
	 XcZn8XFq5/+bBFKLY6+ElY/kkhLNGeJsmnFQs2NI1Kn5qVFDGw7OABBmRaTs97X02u
	 PtBwch/BQ9bCva7yyMnX+CyuUC8bLVQx7ap1leC83/PPf2wS2eJ0ny+jmKO9IpoGFx
	 i2m1+lkk0HaLZGchT1m30nogdGohuwbOztqdcV+57fAjs+XMnjIxI3q41Z/GBt8K5X
	 URB3RcL18YxqA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid1: release barrier when REQ_NOWAIT write would
 block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260611132500.763528-1-abd.masalkhi@gmail.com>
References: <20260611132500.763528-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 13:41:30 +0000
Message-Id: <20260611134130.B4E911F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing RCU read lock around `conf->mirrors[i].rdev` access in=
 `wait_blocked_rdev()`.
- [High] Early failure paths in `raid1_write_request()` leak the `mddev->wr=
ites_pending` reference.
- [High] Allocating bios and r1bios can sleep even when the `REQ_NOWAIT` fl=
ag is set.
--

commit 3db9da0ec804800aa3afb93361ccd18de39ce5f0
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid1: release barrier when REQ_NOWAIT write would block

raid1_write_request() leaks the barrier reference taken by wait_barrier()
if wait_blocked_rdev() fails for a REQ_NOWAIT write. This patch releases
the barrier on this failure path to prevent array freeze hangs.

Closes: https://sashiko.dev/#/patchset/20260611083514.754922-1-abd.masalkhi=
@gmail.com?part=3D1

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 5b9368bd9e700..f3cc30932ba2b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1512,6 +1512,7 @@ static void raid1_write_request(struct mddev *mddev=
, struct bio *bio,
>  	int max_sectors;
>  	bool write_behind =3D false;
>  	bool is_discard =3D (bio_op(bio) =3D=3D REQ_OP_DISCARD);
> +	sector_t sector =3D bio->bi_iter.bi_sector;
> =20
>  	if (mddev_is_clustered(mddev) &&
>  	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
> @@ -1540,6 +1541,7 @@ static void raid1_write_request(struct mddev *mddev=
, struct bio *bio,
> =20
>  	if (!wait_blocked_rdev(mddev, bio)) {
>  		bio_wouldblock_error(bio);
> +		allow_barrier(conf, sector);

[Severity: High]
This is a pre-existing issue, but does this early return path also leak the
mddev->writes_pending reference?

In raid1_make_request(), md_write_start() unconditionally takes a per-cpu
reference on mddev->writes_pending before calling raid1_write_request().
Normally, this is released via md_write_end() inside close_write().

By directly returning here after bio_wouldblock_error(bio), we never call
md_write_end(). Does this permanently leak the writes_pending counter and
prevent the array from transitioning to a clean state?

It looks like this same leak exists on the clustered area_resyncing and
wait_barrier REQ_NOWAIT failure paths earlier in this function, as well as
the err_handle path if bio_submit_split_bioset() fails.

>  		return;
>  	}

[Severity: Critical]
This is a pre-existing issue, but is it safe to call wait_blocked_rdev()
here without holding the RCU read lock?

Looking at wait_blocked_rdev():

	for (i =3D 0; i < disks; i++) {
		struct md_rdev *rdev =3D conf->mirrors[i].rdev;

		if (!rdev)
			continue;

		/* don't write here until the bad block is acknowledged */
		if (test_bit(WriteErrorSeen, &rdev->flags) &&

It accesses the rdev pointer and its fields without rcu_read_lock().
Could a concurrent device removal (via md_ioctl -> raid1_remove_conf)
replace the pointer with NULL and free the rdev structure while we are
dereferencing it here, resulting in a use-after-free?

[Severity: High]
This is also a pre-existing issue, but if we proceed past this point for a
REQ_NOWAIT bio, we call alloc_r1bio() and eventually bio_alloc_clone(),
both of which use GFP_NOIO.

Since memory pool allocations with GFP_NOIO can block when the mempool is
exhausted under memory pressure, could this cause REQ_NOWAIT writes to
sleep, defeating the purpose of the REQ_NOWAIT flag?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611132500.7635=
28-1-abd.masalkhi@gmail.com?part=3D1
