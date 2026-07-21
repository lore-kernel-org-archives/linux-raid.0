Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E402D5436;
	Tue, 21 Jul 2026 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656982; cv=none; b=bLYFJJFwqZNa11osdjpTtGAgZZvul/ymKAHBL0yqZZzo8FJezBeZo4juPIc77zd+D/qw/0VtwNmOu6B3+5joRqhBzl8BEIUFofCwff3UU4XCZyZMnSyAYYAfBhrWWa/H9dJ5s9osovkgG5jzXlg0MOeHVNWFMfxfnN8ZwEiCQ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656982; c=relaxed/simple;
	bh=5GgZWPxQ4v7wU8fCQZm5gWiZIdzhXuuf1IxgiLFdyRI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=s7uK9RM7guwZNxqNaSXXZNVvQ3FoOV/VBY/B/PtTNMB2rfxyu/qFvRsqp/U24f9TzYHVvzj7wOE2caRckyWv/v9rmGQmy4NuXY7BdcS95uVXezVQfq2SWUT4iZP8S+YggSssK0EFOVA/F6arDRQ9ACUIvMNKwkUM5pQ8QAve7Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c53c+dm+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c53c+dm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0998A1F00A3A;
	Tue, 21 Jul 2026 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784656981;
	bh=RjK5evbB+pjLVWCqZ8jEHUNYTCn339VKlKUB8Up0fG0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c53c+dm+WOz36s8YoKVxVQGIhXZr0PYcQ/2MGlEqoUySrjN5zLgWeeiIPiBnLvKVP
	 3YKJgPvMPTEUIpqESlRPvY1SCkm2BwgXKx8tkzRW6DKWSHFqIi3iHwOSYS7bIaxg5C
	 1PWzTLSbOirVjjJZirvLBCynvWXWqtKK8khDeGtUnguLkIk5bruPmaIeOwRmJoRpOV
	 aAlvI8hictvGEZ8Nqr1/Hky6F3pgy0gyI+4EfBkSnJEa7SMLqxkyq5LeWjQE5BF8uU
	 SCfETkPQV10TuUJnLnmTQ4jHMELxE+wDx0yc5xZO3uLwSBNFpvyJsbDh3JGcH2Wdiq
	 6Y1F0dCp7fu+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/8] md/raid1: skip futile retries on P2PDMA mapping
 failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260721174502.111503-7-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
 <20260721174502.111503-7-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:02:59 +0000
Message-Id: <20260721180300.0998A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Coarse retries for persistent P2PDMA mapping failures exhaust the =
array's badblock list, forcing healthy device eviction.

Pre-existing issues:
- [High] Data corruption and kernel panics result from wbio->bi_opf =3D REQ=
_OP_WRITE; stripping critical flags and modifying bodiless bios.
- [High] A NULL pointer dereference occurs on rdev->bdev during concurrent =
read errors and hot-removes.
--

--- Patch [6]: [PATCH v3 6/8] md/raid1: skip futile retries on P2PDMA mappi=
ng failures ---
commit 808452a00e434c54e8f26591e906bbf52dd9e7f0
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1: skip futile retries on P2PDMA mapping failures

A member that cannot DMA-map peer memory fails the leg bio with
BLK_STS_TARGET.  The failure is a property of the peer/member
pairing -- retrying the same pages against the same member cannot
succeed, and there is nothing on the medium to repair. This patch
flags P2PDMA master bios with a new R1BIO_P2PDMA state bit at
submission to avoid evicting healthy members during unroutable I/O.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 16b7465c233ac..6334032c4bb8e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -1378,6 +1384,8 @@ static void raid1_read_request(struct mddev *mddev,=
 struct bio *bio,
>  	else
>  		init_r1bio(r1_bio, mddev, bio);
>  	r1_bio->sectors =3D max_read_sectors;
> +	if (md_bio_is_p2pdma(bio))
> +		set_bit(R1BIO_P2PDMA, &r1_bio->state);
> =20
>  	/*
>  	 * make_request() can abort the operation when read-ahead is being

[Severity: High]
This isn't a bug introduced by this patch, but could this lead to a NULL
pointer dereference?

When a read fails, handle_read_error() drops the reference to the rdev via
rdev_dec_pending(), which may trigger device removal if it's faulty. It then
calls raid1_read_request() to retry.

In raid1_read_request(), if read_balance() returns -1 (no other disks are
available), we hit a pr_crit_ratelimited statement:

    rdisk =3D read_balance(conf, r1_bio, &max_sectors);
    if (rdisk < 0) {
        /* couldn't find anywhere to read from */
        if (r1bio_existed)
            pr_crit_ratelimited("md/raid1:%s: %pg: unrecoverable I/O read e=
rror for block %llu\n",
                        mdname(mddev),
                        conf->mirrors[r1_bio->read_disk].rdev->bdev,
                        r1_bio->sector);

Is it possible that conf->mirrors[r1_bio->read_disk].rdev is NULL here due
to a concurrent hot-remove, causing a crash when dereferencing ->bdev?

[ ... ]
> @@ -2550,9 +2563,12 @@ static void narrow_write_error(struct r1bio *r1_bi=
o, int i)
>  		block_sectors =3D roundup(1 << rdev->badblocks.shift, lbs);
> =20
>  	sector =3D r1_bio->sector;
> -	sectors =3D ((sector + block_sectors)
> -		   & ~(sector_t)(block_sectors - 1))
> -		- sector;
> +	if (coarse)
> +		sectors =3D sect_to_write;
> +	else
> +		sectors =3D ((sector + block_sectors)
> +			   & ~(sector_t)(block_sectors - 1))
> +			- sector;
> =20
>  	while (sect_to_write) {
>  		struct bio *wbio;

[Severity: High]
This is a pre-existing issue, but does overwriting the operation entirely
strip critical upper durability flags here?

In narrow_write_error(), the cloned wbio is modified like this:

        wbio->bi_opf =3D REQ_OP_WRITE;

Could this strip flags like REQ_FUA or REQ_PREFLUSH, leading to potential
data loss on power failure? Furthermore, if a bodiless bio like
REQ_OP_WRITE_ZEROES is converted into a regular REQ_OP_WRITE, could this
cause a NULL pointer dereference in the block layer during segment mapping
(e.g., bio_for_each_segment) since it has no data vectors?

[Severity: High]
With the new coarse retry mechanism, what happens when persistent P2PDMA
mapping failures repeatedly occur?

If a P2PDMA write fails with BLK_STS_TARGET, we enter narrow_write_error()
with coarse =3D true. Later in this loop, if the retried coarse I/O also
fails, it adds a badblock:

        if (submit_bio_wait(wbio) &&
            !rdev_set_badblocks(rdev, sector, sectors, 0)) {

Since P2PDMA pairing failures are a persistent property of the peer/member
combination, repeated coarse retries will keep adding large badblock entrie=
s.

If this quickly exhausts the array's finite badblocks list, won't
rdev_set_badblocks() return 0, triggering a call to md_error() that forces
the eviction of a healthy device? Does this defeat the patch's purpose of
preventing healthy devices from being evicted?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721174502.1115=
03-1-mykola@meshstor.io?part=3D6
