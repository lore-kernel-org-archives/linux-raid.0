Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AA43F58E1;
	Thu, 23 Jul 2026 21:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841193; cv=none; b=HE+rU6ywboSjf3XGFsfUWHQM2b7JKe4ru33pLI4ylpq8b/d3DfRCRvxbw3PX5QmegGkLYIYpDPGx9xfgpnm/vDqrRde0feND1U+JfoZ/tAwqk9nb757+H4/hWemIr5NjSC0MfLfwf637F9FeVcNzvsj2vdoLN5lZXw64kVhrssc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841193; c=relaxed/simple;
	bh=+G6WmaDtCQ1/qnRxFTuek7207uv8qT5jx8xUA6fFn9s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TOT+pfV5/ZBs0ZlJAHlv+yQUResd9bd5shBBw0nsX1ii/Nlcv9ubBXM+vVTz9qzzILeg8ZC9LsDGtZZJRPNxS4woKXRmKkFDE80PHv1+J8H695IXnGD4zBIxtk3coK0xhvp5aViKvO/B4m6L/19RnSPPl0zPCei/aHF/f5m/SVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQ/hVzBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQ/hVzBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4058D1F000E9;
	Thu, 23 Jul 2026 21:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784841188;
	bh=xCy5gErw1QYEeJmbO8xAUk7bv2N+eh3/oeB2zOswipI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BQ/hVzBHh+EEtWibMKkPgnwN8O0H5u3TozP3beI5ByN1MtgVkRi4EnSFcfxvRB/9L
	 nJQ8gYbNpGnSobMVpgAgbkgXebUe5ySQuKrGbWQYJru237rLJ5SErjAGkyYE3sUqGh
	 rnZPfe1ECTchrdCFJgzLhNQR3wXkNeXVNP0n7+4SGDzorzLREylq/pWgrNc4XnC/mX
	 ghiy2dGpV7wGA3mEVsS/J50+KJOR/153Vi+GzfQfEjzHgrVHSCxto2BCdaQhabh695
	 Na6r5lcKoYjH8MP7ju0U9rNZ2OmVLautMQ93hil/R4utdkbjQbQFX4++rqACkkQyUE
	 Jf1qrP+gh0rrQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/10] md/raid1,raid10: set IO_BLOCKED in case of
 BLK_STS_P2PDMA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260723204206.76930-9-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-9-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 21:13:07 +0000
Message-Id: <20260723211308.4058D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Bypassing `freeze_array()` for `BLK_STS_P2PDMA` in `raid1.c` intro=
duces a hard deadlock against concurrent array freezes.

Pre-existing issues:
- [High] Race condition leading to a NULL pointer dereference in `raid1_rea=
d_request()` when logging an unrecoverable read error.
- [High] Double barrier drop (`nr_pending` underflow) when a `REQ_NOWAIT` r=
ead fails while the array is frozen.
--

--- Patch [8]: [PATCH v5 08/10] md/raid1,raid10: set IO_BLOCKED in case of =
BLK_STS_P2PDMA ---
commit 39fd90f26512b119562fa95bb3bbc654fa9ed8a3
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA

A read that fails with BLK_STS_P2PDMA cannot succeed against that
member, so mark the leg IO_BLOCKED and let the retry redirect elsewhere.
Skip the read-error machinery: there is nothing on the medium to fix,
fix_read_error()'s probe reads into host pages and would "succeed", and
charging the read-error budget would evict a healthy member under a P2P
read workload.  FailFast eviction is skipped for the same reason -- the
request never reached the wire.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices=
 to RAID device")
Assisted-by: Claude:claude-fable-5
Co-developed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 83ebf40237d57..16a47568679f0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c

[ ... ]

> @@ -2674,7 +2676,7 @@ static void handle_read_error(struct r1conf *conf, =
struct r1bio *r1_bio)
>  	 * read error.  This is all done synchronously while the array is
>  	 * frozen.
>  	 */
> -	if (mddev->ro) {
> +	if (mddev->ro || status =3D=3D BLK_STS_P2PDMA) {
>  		r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;

[Severity: High]
Does skipping freeze_array() for P2PDMA errors here risk a hard deadlock?

If a concurrent thread calls freeze_array(conf, 0) during a management comm=
and,
it sets array_frozen =3D 1 and waits for get_unqueued_pending() =3D=3D 0.

Meanwhile, this handle_read_error() thread bypasses freeze_array() and
proceeds to call raid1_read_request() while holding the original nr_pending
reference.

When raid1_read_request() calls wait_read_barrier():

drivers/md/raid1.c:raid1_read_request() {
    ...
    if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
    ...
}

And wait_read_barrier() sees the array is frozen:

drivers/md/raid1.c:wait_read_barrier() {
    ...
    if (unlikely(conf->array_frozen)) {
        ...
        wait_event_lock_irq_cmd(...)
    ...
}

The raid1d thread will block on array_frozen, but because it still holds its
nr_pending reference, get_unqueued_pending() will remain >=3D 1. The freezer
thread will wait forever for the reference to drop, and raid1d will wait
forever for the array to unfreeze.

>  	} else if (test_bit(FailFast, &rdev->flags)) {
>  		md_error(mddev, rdev);

[Severity: High]
This is a pre-existing issue, but does dropping the active reference to the
failing device later in handle_read_error() introduce a race condition with
concurrent disk removal?

Looking further down in handle_read_error():

    rdev_dec_pending(rdev, conf->mddev);
    sector =3D r1_bio->sector;
    ...
    raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);

Since raid1d doesn't hold reconfig_mutex, a concurrent raid1_remove_disk() =
can
observe nr_pending =3D=3D 0 and clear the device pointer. If the subsequent=
 call
to raid1_read_request() fails to find an alternative disk in read_balance(),
it attempts to log a critical error:

drivers/md/raid1.c:raid1_read_request() {
    ...
    if (r1_bio->read_disk < 0) {
        ...
        pr_crit_ratelimited("md/raid1:%s: %pg: unrecoverable I/O read...\n",
                            mdname(mddev),
                            conf->mirrors[r1_bio->read_disk].rdev->bdev,
                            ...);
    ...
}

Dereferencing conf->mirrors[r1_bio->read_disk].rdev->bdev when rdev has been
set to NULL would cause a fatal page fault.


[Severity: High]
This is also a pre-existing issue, but could the unconditional allow_barrie=
r()
at the end of handle_read_error() lead to a double barrier drop if a
REQ_NOWAIT read fails while the array is frozen?

Looking at the end of the function:

    raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
    allow_barrier(conf, sector);

If wait_read_barrier() inside raid1_read_request() encounters a frozen array
and returns false due to REQ_NOWAIT, it does not increment nr_pending:

drivers/md/raid1.c:raid1_read_request() {
    ...
    if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
        bio_wouldblock_error(bio);
        raid_end_bio_io(r1_bio);
        return;
    ...
}

raid_end_bio_io() internally calls allow_barrier() to drop the original
reference. After raid1_read_request() returns, handle_read_error() will
unconditionally execute this second allow_barrier(conf, sector).

This would cause nr_pending to underflow, leading to a permanent deadlock on
any subsequent array freeze since raise_barrier() will block forever waiting
for nr_pending =3D=3D 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D8
