Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22452D3ECF
	for <linux-raid@vger.kernel.org>; Mon,  8 Jun 2026 17:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780940415; cv=none; b=HCabA6GJM9WyDwC0pP82QeKqO9T3y2IF1zAd6SuCEQ40wkTFPicqmLLDZ2dq+ey/DbvP3mGHf7iT9yUmmWGkoq8CSt2PZAvVaZiFktXlLe5kjGefjBd+ZPi9hstqMzYzQ/OilYbTNBXT1Shx1uF6nI2UczC9/4NDdh7VWIYj88M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780940415; c=relaxed/simple;
	bh=8mba+JRPoF7PwZsAk1Pvzgzq4hJpwycUnSkIr57ApFA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tH6xWN+WmW5FCAFXCoc/SkEiv5/uuZmJdaYczIWiMfekIbi0Ij92n5uAln0HlLC9uTRtZXzgW0n+rWRcKmyG2VatU5EqQJ9rqKTOIBNv2LzJtcJMVwGr36qfkVgSVP7CDufiZea2NimMHohrCreSpBi5XShDSGBLqWZ2PvyXjW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j44r5+da; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j44r5+da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EB41F00893;
	Mon,  8 Jun 2026 17:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780940413;
	bh=B+hOPsXe5WGPXeP/+ec8ixbp/U4JZPXlXU4lDIq8VdM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j44r5+dab3SgoUy5gsRRNTrSWb3QwCIv/8ev6mUJ4ubs2YCEZxG3zMRdcE6cE8wtN
	 aHrqhw7vAGMFxFmbJanZE1WVJC3E1V9/ZgtICMqwDNanuv8voZVvmg17HzxeAPlQY7
	 nyDwYtdMAorHZtBmBHC5N+5AR8vPbYOwKlCrUJRWHOSCO6aE9px6bgzscoduz4IXu7
	 +hlBozfT2eO0w9skz5Ep60cywYpgOij4wm0EDClEUXFeHjmERgBdJiQ+upJl4ijF6q
	 pSAA4wK4DaPr9olDZr9+3kVH23xY9fjI3KDQtd5m1rFBaRdXLsq96g0kLD8TdCQBdk
	 q5I8orYteDmnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] md/raid1: move the exceed_read_errors condition out
 of fix_read_error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260529054308.2720300-3-hch@lst.de>
References: <20260529054308.2720300-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 08 Jun 2026 17:40:13 +0000
Message-Id: <20260608174013.79EB41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Low] The initialization of `rdev` at the beginning of `fix_read_error()`=
 is a dead store.

Pre-existing issues:
- [High] Memory leak of `r1_bio` when retrying `REQ_NOWAIT` reads during an=
 array freeze or resync barrier.
- [High] Infinite loop of read retries on a `FailFast` device when it is th=
e last good device.
- [High] Lockless access to `conf->mirrors[d].rdev` in `fix_read_error` wit=
hout RCU protection or `reconfig_mutex` leads to a Use-After-Free race cond=
ition.
--

commit 8f0f2f192596802d5deb747f4831c98556fe83cc
Author: Christoph Hellwig <hch@lst.de>

md/raid1: move the exceed_read_errors condition out of fix_read_error

This commit moves the exceed_read_errors() check from fix_read_error() to
its caller, handle_read_error(). This restricts fix_read_error() to only
fixing up data devices after a read error.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2411,11 +2411,6 @@ static void fix_read_error(struct r1conf *conf, st=
ruct r1bio *r1_bio)
>  	struct mddev *mddev =3D conf->mddev;
>  	struct md_rdev *rdev =3D conf->mirrors[read_disk].rdev;

[Severity: Low]
Is this initialization of rdev a dead store? Since the exceed_read_errors()
check was moved out of fix_read_error(), this initial assignment of rdev
is no longer used before being unconditionally reassigned inside the while
loop.

> -	if (exceed_read_errors(mddev, rdev)) {
> -		r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
> -		return;
> -	}
> -
>  	while(sectors) {
>  		int s =3D sectors;
>  		int d =3D read_disk;

[Severity: High]
This isn't a bug introduced by this patch, but does the lockless access to
conf->mirrors[d].rdev inside the while(sectors) loop lead to a
Use-After-Free race condition?

Looking at fix_read_error(), the code iterates over mirror indices and
dereferences rdev without holding rcu_read_lock():

    do {
        rdev =3D conf->mirrors[d].rdev;
        if (rdev &&
            (test_bit(In_sync, &rdev->flags) ||
             (!test_bit(Faulty, &rdev->flags) &&
              rdev->recovery_offset >=3D sect + s)) &&
            rdev_has_badblock(rdev, sect, s) =3D=3D 0) {
            atomic_inc(&rdev->nr_pending);

If a concurrent management thread executes hot_remove_disk ->
raid1_remove_disk() -> raid1_remove_conf(), it can check nr_pending
(seeing 0 for mirrors where d !=3D read_disk), set the pointer to NULL, and
kick the device. Since md_kick_rdev_from_array uses synchronize_rcu() and
fix_read_error() holds no RCU lock, can rdev be freed while
fix_read_error() continues to access it?

[ ... ]

> @@ -2652,7 +2647,10 @@ static void handle_read_error(struct r1conf *conf,=
 struct r1bio *r1_bio)
>  		md_error(mddev, rdev);
>  	} else {

[Severity: High]
This isn't a bug introduced by this patch, but can the FailFast branch
cause an infinite loop of read retries when it is the last good device?

In handle_read_error(), if a read error occurs on an rdev with the FailFast
flag set, md_error(mddev, rdev) is called and the else branch is completely
skipped. If this rdev happens to be the last good device, raid1_error()
refuses to set the Faulty bit.

Because the else branch is skipped, r1_bio->bios[r1_bio->read_disk] is not
set to IO_BLOCKED. Since the device is neither Faulty nor IO_BLOCKED,
raid1_read_request() considers the same device readable and selects it
again, causing an immediate failure and re-queuing that hangs the thread.

>  		freeze_array(conf, 1);
> -		fix_read_error(conf, r1_bio);
> +		if (exceed_read_errors(mddev, rdev))
> +			r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
> +		else
> +			fix_read_error(conf, r1_bio);
>  		unfreeze_array(conf);
>  	}

[Severity: High]
This is a pre-existing issue, but does retrying a REQ_NOWAIT read during an
array freeze or resync barrier leak r1_bio?

When handle_read_error() queues a retry for a read request with REQ_NOWAIT,
it calls raid1_read_request() and passes the existing r1_bio:

drivers/md/raid1.c:handle_read_error() {
    ...
    r1_bio->state =3D 0;
    raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
    allow_barrier(conf, sector);
}

If there is an active barrier, wait_read_barrier() correctly identifies the
nowait flag and returns false. raid1_read_request() handles this by calling
bio_wouldblock_error() and returning early:

drivers/md/raid1.c:raid1_read_request() {
    ...
    if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
                           bio->bi_opf & REQ_NOWAIT)) {
        bio_wouldblock_error(bio);
        return;
    }
    ...
}

Does this early return bypass the cleanup, permanently leaking the mempool
allocated r1_bio and potentially causing a system deadlock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260529054308.2720=
300-1-hch@lst.de?part=3D2
