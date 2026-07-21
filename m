Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCBC46D090;
	Tue, 21 Jul 2026 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656917; cv=none; b=ib0g0jhKWE/ADKnXilxMnkfpUd5soa9DH5k1RhLmp85u9Twr+5Ay5PPRSbJdIGc8I7RrHc/I+jXgJQqUj8ciY/r3UuBoXluZEizUpNiR1kJtbygaJyXwq4pwe6xxJcgGtAIVgNKz70xwKOyxO5SxB9ppi2E0VPw09XP+1qggRr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656917; c=relaxed/simple;
	bh=ZMcOhw3g73eUzYkVv/CAvbrfaF1937nucDRIm7SSD6I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dW5HKKB7jRnVA7udnT0a5BiVGe/+zL/EGXe4KF8upIbNIO2Abz/N6J6eozKgC4wYnu20DSn1aMkoh7k9HZKo9vTN2UJ58Uo6ns3DtZ74mObZugchZZ944rVKF5eYjJf9+m1/J8WHdoGI3s8w3VDBUGILs5Wk8Ztp7gxYu+x6VDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kP3+l4F9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kP3+l4F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE59B1F00A3D;
	Tue, 21 Jul 2026 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784656916;
	bh=4sN0D5RgvEFvtFbDtGrJJADW4fLuvK9V2AAEd8wXwa0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kP3+l4F9rplNw5+JrORJMVwARAYqRVizwmpzGqwuDr7/9hlwG2a0hbiEAxGN220yr
	 kdzNq73Wbf8K1q6eAJnsjZ1HddMymtxSuyXHpBj6PQxM6QE8PHHKAnsQ4hB60g9mvp
	 JpM+FoW1J01ht58+6L3FdY4QDWAiu1u3eZCi7m2gdZaQAkeoTR0guxiLALdzfQyNLN
	 wI2ncOgMY5I02CVlw+Kbc/DE4x2GohhvvheESAX1cGgtTyixc3lfj2e51e1FpexNJ+
	 omrd6Wn1kV9Tgw9GqxwP0IR7ag4HHIyOYdMo5EFJWDNQbQ9cLGhJia7GWa0QfQSdT/
	 HtglFttYRjrdg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/8] md/raid10: skip futile retries on P2PDMA mapping
 failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260721174502.111503-8-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
 <20260721174502.111503-8-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:01:55 +0000
Message-Id: <20260721180155.EE59B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] narrow_write_error() drops critical bio flags (e.g., REQ_FUA, REQ_=
PREFLUSH) during write error retries.
- [High] fix_read_error() incorrectly attributes read errors on a replaceme=
nt device to the primary device.
--

--- Patch [7]: [PATCH v3 7/8] md/raid10: skip futile retries on P2PDMA mapp=
ing failures ---
commit 850a2ebdf179522973aa4c7332fa7233fdc47fc1
Author: Mykola Marzhan <mykola@meshstor.io>
Subject: md/raid10: skip futile retries on P2PDMA mapping failures

This commit handles P2PDMA mapping failures by skipping futile retries
and retrying the write once as a whole range. It also leaves replacement
legs with the default fail-on-write-error policy to avoid silent holes
during rebuilds.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices=
 to RAID device")

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index f7ef903a3d4ec..4c3da50250a5a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -2814,9 +2831,12 @@ static void narrow_write_error(struct r10bio *r10_=
bio, int i)
>  		block_sectors =3D roundup(1 << rdev->badblocks.shift, lbs);
> =20
>  	sector =3D r10_bio->sector;
> -	sectors =3D ((r10_bio->sector + block_sectors)
> -		   & ~(sector_t)(block_sectors - 1))
> -		- sector;
> +	if (coarse)
> +		sectors =3D sect_to_write;
> +	else
> +		sectors =3D ((r10_bio->sector + block_sectors)
> +			   & ~(sector_t)(block_sectors - 1))
> +			- sector;
> =20
>  	while (sect_to_write) {
>  		struct bio *wbio;

[Severity: High]
This is a pre-existing issue, but does narrow_write_error() drop critical
bio flags like REQ_FUA and REQ_PREFLUSH here?

Further down in narrow_write_error(), the clone's operation flags are
overwritten with a bare write:

drivers/md/raid10.c:narrow_write_error() {
    ...
    wbio =3D bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->bio_set);
    bio_trim(wbio, sector - bio->bi_iter.bi_sector, sectors);
    ...
    wbio->bi_opf =3D REQ_OP_WRITE;
    ...
}

If the master bio was submitted with REQ_FUA to guarantee data persistence,
these flags are stripped and the retry is issued as a normal asynchronous
write.

If the retry succeeds by placing data in the drive's volatile cache, the
master bio completes successfully. Could a power failure before the cache
is flushed to stable media result in silent data loss, violating the
original REQ_FUA guarantees?

(Note: The identical logic appears to be present in drivers/md/raid1.c in
narrow_write_error() as well).

[ ... ]
> @@ -2856,6 +2876,7 @@ static void handle_read_error(struct mddev *mddev, =
struct r10bio *r10_bio)
>  {
>  	int slot =3D r10_bio->read_slot;
>  	struct bio *bio;
> +	bool p2pdma_error;
>  	struct r10conf *conf =3D mddev->private;
>  	struct md_rdev *rdev =3D r10_bio->devs[slot].rdev;
> =20
> @@ -2868,17 +2889,24 @@ static void handle_read_error(struct mddev *mddev=
, struct r10bio *r10_bio)
>  	 * frozen.
>  	 */
>  	bio =3D r10_bio->devs[slot].bio;
> +	/* evaluate before the bio_put() below */
> +	p2pdma_error =3D bio->bi_status =3D=3D BLK_STS_TARGET &&
> +		test_bit(R10BIO_P2PDMA, &r10_bio->state);
>  	bio_put(bio);
>  	r10_bio->devs[slot].bio =3D NULL;
> =20
>  	if (mddev->ro)
>  		r10_bio->devs[slot].bio =3D IO_BLOCKED;
> -	else if (!test_bit(FailFast, &rdev->flags)) {
> +	else if (p2pdma_error) {
> +		/* Peer can't reach this member: just redirect the read. */
> +		r10_bio->devs[slot].bio =3D IO_BLOCKED;
> +	} else if (test_bit(FailFast, &rdev->flags)) {
> +		md_error(mddev, rdev);
> +	} else {
>  		freeze_array(conf, 1);
>  		fix_read_error(conf, mddev, r10_bio);
>  		unfreeze_array(conf);
> -	} else
> -		md_error(mddev, rdev);
> +	}
> =20
>  	rdev_dec_pending(rdev, mddev);
>  	r10_bio->state =3D 0;

[Severity: High]
This is a pre-existing issue, but does fix_read_error() incorrectly attribu=
te
read errors on a replacement device to the primary device?

When read_balance() selects the replacement device for a read and it fails,
handle_read_error() passes the context to fix_read_error().

However, fix_read_error() ignores the actual device that failed
(r10_bio->devs[slot].rdev) and blindly selects the primary device:

drivers/md/raid10.c:fix_read_error() {
    ...
    /* still own a reference to this rdev, so it cannot
     * have been cleared recently.
     */
    rdev =3D conf->mirrors[d].rdev;

    if (test_bit(Faulty, &rdev->flags))
    ...
}

Later, bad blocks are also recorded on the primary device:

drivers/md/raid10.c:fix_read_error() {
    ...
    int dn =3D r10_bio->devs[slot].devnum;
    rdev =3D conf->mirrors[dn].rdev;

    if (!rdev_set_badblocks(
                rdev,
                r10_bio->devs[slot].addr
                + sect,
                s, 0)) {
    ...
}

Could this result in the healthy primary device being penalized via
exceed_read_errors() and incorrectly targeted for bad block recording,
while the faulty replacement device continues to operate without
correction?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721174502.1115=
03-1-mykola@meshstor.io?part=3D7
