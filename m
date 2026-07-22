Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F03411F99;
	Wed, 22 Jul 2026 19:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747769; cv=none; b=VOKX3m09dMx8iIHQuDMk2QDtkqvumgotQD7E8NRbFsVxDR2broqIDuL8N686orTev/1FZtp9Smg8wjVPYko/DHP68wlo7OMolX3vwDVQppi84Lu166cuZgSXqgrIRPhX3iCyn28xZ9qnx2I06qpICnj9PE2DYTBOc6y3Z2mxC6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747769; c=relaxed/simple;
	bh=OwyUza2P2zdqG6sZeDZi556dNd27UZDQqlWHAq3lvmI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KdJ7/kQ1wY0y5GE/dkgOnPieDNCABNwpwWqBwx30ra2Ej8rrWD5Zn9CoXOQFXxQmftg/22+G2vqajlEsMn2KiuMGykGAHlPWSIPBiHatBkc9z+dUD97VDVW5eiVZWgXHDGanzFl731HpdMMisEUK3Z4jhUakILxQUHazQdosQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoLP/3k2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoLP/3k2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8431F000E9;
	Wed, 22 Jul 2026 19:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747765;
	bh=EqYoXuTjbXBU5twpT/kIupNNgjyWdvrMFDFCovVJ1js=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YoLP/3k2NMdNd+Hr5z294bQ205JuWgEZQMEt2o7mivj5gCsPJ2KCv3mGdJrNA0JNP
	 e5PNPzLrUvEXhvyZNQbCZilHsyPj2LM1Iz6t9b46rybRIQn+F8sf2WAAeagoqXnfwT
	 lU8u+IaG2SV+b4jkR8VSBWEUTLxaDF0oPgCorNQufgDfCrkzbKsoduYsIMatq7gTob
	 /fQTXnrfZ3E3jg+YuuYSEPWgpGnV2YYbLtj6Y0acLePpXui+fSag74uEj+0wCQrlrN
	 UeZ0uu/wMKy4/ZcBb1ewN7432sEPMJXx4PzSk0rJqDVqpdjRbEXgG8+nJbX/b4fg8o
	 webZ9PeJXEr6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/9] md/raid1,raid10: set IO_BLOCKED in case of
 BLK_STS_P2PDMA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260722185841.449934-9-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-9-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:16:04 +0000
Message-Id: <20260722191605.6E8431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] NULL pointer dereference when a read error occurs and the fail=
ing disk is concurrently removed.
- [High] Barrier count underflow leading to array deadlock for REQ_NOWAIT r=
etries.
--

--- Patch [8]: [PATCH v4 8/9] md/raid1,raid10: set IO_BLOCKED in case of BL=
K_STS_P2PDMA ---
commit 64027366aa2bf452a9087c9fd113c84027594e8b
Author: Logan Gunthorpe <logang@deltatee.com>

md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
   =20
A read that fails with BLK_STS_P2PDMA cannot succeed against that member, so
mark the leg IO_BLOCKED and let the retry redirect elsewhere. This skips the
read-error machinery, avoiding the eviction of healthy members under a P2P
read workload.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 917d694ef401a..76a1426e64f02 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -2675,7 +2677,7 @@ static void handle_read_error(struct r1conf *conf, =
struct r1bio *r1_bio)
>  	 * read error.  This is all done synchronously while the array is
>  	 * frozen.
>  	 */
> -	if (mddev->ro) {
> +	if (mddev->ro || p2pdma_error) {
>  		r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
>  	} else if (test_bit(FailFast, &rdev->flags)) {
>  		md_error(mddev, rdev);

[Severity: Critical]
This isn't a bug introduced by this patch, but can we hit a NULL pointer
dereference if the failing disk is concurrently removed?

When a read error occurs, the bio is routed here to handle_read_error().
This function drops the pending count via rdev_dec_pending(rdev), which
could allow a concurrent mdadm --remove to succeed and set
conf->mirrors[r1_bio->read_disk].rdev to NULL.

The retry is then submitted via raid1_read_request(). If all healthy disks
are blocked or unavailable, read_balance() can return -1, triggering this
logging path in raid1_read_request():

raid1_read_request() {
    ...
    if (rdisk < 0) {
        ...
        pr_crit_ratelimited("md/raid1:%s: %pg: unrecoverable I/O read error=
 for block %llu\n",
                            mdname(mddev),
                            conf->mirrors[r1_bio->read_disk].rdev->bdev,
                            ...);
    ...
}

Since rdev is now NULL, will this dereference rdev->bdev and panic the
kernel? For comparison, raid10_read_request() appears to correctly check
if rdev is NULL before logging in this scenario.

[Severity: High]
This is a pre-existing issue, but could this error path lead to a barrier
count underflow and array deadlock when retrying REQ_NOWAIT requests?

If a REQ_NOWAIT read fails and reaches handle_read_error(), it retries by
calling raid1_read_request() with the existing r1_bio.

Inside raid1_read_request(), wait_read_barrier() can return false due to
the nowait flag and the array being concurrently frozen, which leaves
nr_pending unchanged. However, raid1_read_request() then calls
raid_end_bio_io():

raid1_read_request() {
    ...
    if (r1bio_existed) {
        set_bit(R1BIO_Returned, &r1_bio->state);
        raid_end_bio_io(r1_bio);
    }
    ...
}

This calls allow_barrier(), decrementing the barrier count. Control then
returns to handle_read_error(), which ends with:

handle_read_error() {
    ...
    raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
    allow_barrier(conf, sector);
}

Does this second allow_barrier() decrement the count again for a single I/O,
causing a net barrier underflow that blocks future raise_barrier() calls
and deadlocks the array?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D8
