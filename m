Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0563BB680
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029442; cv=none; b=M6RTI1320sG0jWqIxMpdbcfbFEa0Gu4eYxAbs/iKmHB51Pk9tiF2BQGP48d0b38GVR5TYn23f18tXMUR8+zXpW6r8sRRi/DopuXC1OvLTWCjFxSuBC2OJNYq5gXRn5FeA0RtoDhaegWmVnXcqT5a+l4B0HjasnbxpKEUwHFGEic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029442; c=relaxed/simple;
	bh=j4pmiz1SnboxsJI7SZR/CdbLahuV5KH0mvaicQM5cGE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eOKIq5njYzXpgw0WKMkt89lLzKcXyqa9rhS4Ffovjm3PAgqOcrr5x3laOXK0H8sU5B85uLtRRiAIYMaLpdWD7Irzlx3GdiefJr5foti0TafglACzcPQfnR8rpNTVmTbCBkjikxPpSDTy9dL25tPxnThru4AVtnLJfEiHfzbOY2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AFC+mG7P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AFC+mG7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B635D1F000FF;
	Thu, 10 Sep 2026 08:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789029441;
	bh=gyS3PSFBxsT599BhEfeq2f/AxzNG5/1a2S8JkoKYKoQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AFC+mG7PB5l/hnmRl9rmJ+PI6pASe9OgVK6KfTtKF5/QCX3UW51Nwu2rWnlbB4aax
	 k+NinPBHX9Xk8YSvbjaACgcxY9NAUdwE0B2Tv5hZn3tDr4r0LMb/k+BjiopGegS23A
	 RbbAGy2ouVH+VQuFv5xiwNtqL4TBUNE4YxoNYLGBFcjKx/6+DEPmEBQgudNwpdKhXy
	 DLc3FYpTNbBTzO61fXKzVnRt3AEVID6rtoeJfMYTGrgn129T386pLE32rFYXmCJoRk
	 ntDaOKyPhXsHYQ6XNT0TtDmKDPHODFO8iTVqHFoPUKTYTbYBgkWaRN+1aWxtk8O69F
	 NerNlgCrEvznQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/8] md: defer the io_opt update out of the sync
 thread
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260910081114.1605746-5-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
 <20260910081114.1605746-5-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 08:37:20 +0000
Message-Id: <20260910083720.B635D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ABBA/4-thread deadlock in __md_stop() when synchronously flushing =
io_opt_work while holding reconfig_mutex.
--

commit d238224db360133630dc01a16a121d6c63417309
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: defer the io_opt update out of the sync thread

This patch defers the mddev_update_io_opt() call from the sync thread into a
work item to avoid hanging a finishing reshape when taking q->limits_lock.
The __md_stop() function is updated to flush this work item during array
suspension.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3067ea05ba276..87e17ba86d93a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -7139,6 +7172,8 @@ static void __md_stop(struct mddev *mddev)
>  {
>  	struct md_personality *pers =3D mddev->pers;
> =20
> +	/* the deferred io_opt update suspends the array, so let it finish */
> +	flush_work(&mddev->io_opt_work);

[Severity: High]
Can this flush_work() call lead to a deadlock when the array is stopped whi=
le
I/O is active?

The array stop sequence holds reconfig_mutex while calling __md_stop(), whi=
ch
blocks here waiting for md_io_opt_work() to complete.

Meanwhile, md_io_opt_work() calls mddev_suspend(), which blocks indefinitely
waiting for the active_io refcount to drop to zero:

drivers/md/md.c:md_io_opt_work() {
    ...
	lim =3D queue_limits_start_update(q);
	if (mddev_suspend(mddev, false) < 0) {
    ...
}

However, a concurrent write I/O can increment active_io and then block in
md_write_start() waiting for the MD management thread to clear
MD_SB_CHANGE_PENDING:

drivers/md/md.c:md_write_start() {
    ...
	wait_event(mddev->sb_wait,
		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
    ...
}

The MD management thread cannot clear this flag because it wakes up to upda=
te
the superblock but fails to acquire reconfig_mutex:

drivers/md/md.c:md_check_recovery() {
    ...
	if (mddev_trylock(mddev)) {
    ...
}

Since the array stop sequence holds reconfig_mutex, this creates a 4-thread
circular dependency:

1. array stop thread waits for md_io_opt_work() to complete
2. md_io_opt_work() thread waits for active_io to reach zero
3. write I/O holding active_io waits for MD thread to clear
   MD_SB_CHANGE_PENDING
4. MD thread waits for array stop thread to release reconfig_mutex

Does the flush_work() call need to be moved outside the section holding
reconfig_mutex, or could the workqueue be drained earlier?

>  	mddev_detach(mddev);
>  	md_bitmap_destroy(mddev);
>  	spin_lock(&mddev->lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910081114.1605=
746-1-jinpu.wang@ionos.com?part=3D4
