Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792424081;
	b=yxRoxmOpSwjWCeqB6X+brWX2xW6KxOibrtLwfVitPRiL0XH0hJiQ5S3Zv62qT0AHgIsT
	 HXRZ0cloQktolm4Ne0o/QcEtu9tWN4np3qWJKIdf20eQslgUmDBIMtjoBkS0+NJdDB+Vf
	 NxdQHY/n/qT1arIY4Q8IMAMZXTT3Di9ymXJP35sK7emB4LKraandw12fwh6Oy63EIMWK7
	 2H4rWowNcuKeIfbnx6dT7I9SSskXM6dCMpM8tOnM+qGkb35AEAz+t9JT0X/ObITGJPads
	 tlEYmwcc+PDt1ze4tvsvBiE4inGGOGkDkvVawuVwz948VWYrnX+ogU0zSyU6GymjfMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792424081;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6u8MkbRgPXGIfcuMuQWHOghF0MVIXMQ778vLUgvR7i0=;
	b=R/GwYYS3h8i7xbIwrqcm5KqggZMF2HhIu89jpJg4c6Qy2nPTXYedLQYHZG9fG4Ww9vxS
	 2XEqCrEbLizd0dyTFNWHdpaqmgobV9cfYj/ocIgihFkIyzZJccRkOArXLNIgHHRxRBu/f
	 ny496vNIH11Ft67MuS5+9ex/skSXxumTQrS8gEZIA/kMELf0JVbWMTZoc35m9DSUjKjx6
	 AXrdOWGM0pBdvdNDERrLSsjqcRfNbX0zqhFmQvkGnCnyPQKhzbQmAcw8Z9o963tlWbOO8
	 G3GI+mx/plA4da+SAwTJyXo4ZmIAIG0aDqpnIZd+ClprlqmNJwhDttCxZatDkb5+RLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJ6Q1djL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9273E606EFC7
	for <linux-raid@vger.kernel.org>; Mon, 19 Oct 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJ6Q1djL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D16E1F0283C;
	Mon, 19 Oct 2026 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792424080;
	bh=6u8MkbRgPXGIfcuMuQWHOghF0MVIXMQ778vLUgvR7i0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AJ6Q1djLUxOKz1JdY4s/YNgmzSs3q1CPmUZu88OChBwXyqqilFqAmMcpEfsrQaO6L
	 SrNh+D04CfBmm14XWvyYS/173szA3y7q8VZq1PRIJKRXmLzZoOgiCnYQE/cDGXmrnn
	 1CEIP0AVjhG9Te3wtGu9uk6cEWOFgyhlVYEjXsOLdlLSNT5tsscb76F3pSiS3iv/fv
	 CmUqZRi2Zbgn7JSiqWwvIxWTLM+dtql8P7MneSCZhFT9v4GPmA1T4iWhQlQOwmaIsN
	 ByS0dHH8NId32dVs68uFLoPqPQkfXWQWagbZoUVSwHR1CnmGkL+nxTyq19VMxM4gcG
	 YfSp8dHdzdTxQ==
Message-ID: <sashiko-outbox-177759@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] md: skip bitmap accounting for empty write
 ranges
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261019135441.1420968-307-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-307-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 15:34:39 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] md: missing sectors check in md_free_cloned_bio() before md_bitmap=
_end()
--

commit 6836aa7ecbc70ba01261dda2960c8f2c78bf3f55
Author: Yu Kuai <yukuai@fygo.io>

md: skip bitmap accounting for empty write ranges

This commit skips md bitmap start_write() and end_write() accounting when a
write bio has zero sectors or when personality bitmap mapping turns the bio
into an empty bitmap range.

Link: https://patch.msgid.link/20260802195038.164272-11-yukuai@kernel.org

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03d328506b285..ce3bd127e3bb3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9266,6 +9266,8 @@ static void md_bitmap_start(struct mddev *mddev,
>  		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
>  					   &md_io_clone->sectors);
> =20
> +	if (!md_io_clone->sectors)
> +		return;
>  	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
>  }
> =20
> @@ -9284,7 +9286,8 @@ static void md_end_clone_io(struct bio *bio)
>  	struct bio *orig_bio =3D md_io_clone->orig_bio;
>  	struct mddev *mddev =3D md_io_clone->mddev;
> =20
> -	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mddev, fal=
se))
> +	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_io_clone->sectors &&
> +	    md_bitmap_enabled(mddev, false))
>  		md_bitmap_end(mddev, md_io_clone);
> =20
>  	if (bio->bi_status && !orig_bio->bi_status)
> @@ -9308,12 +9311,14 @@ static void md_clone_bio(struct mddev *mddev, str=
uct bio **bio)
>  	md_io_clone =3D container_of(clone, struct md_io_clone, bio_clone);
>  	md_io_clone->orig_bio =3D *bio;
>  	md_io_clone->mddev =3D mddev;
> +	md_io_clone->sectors =3D 0;
>  	if (blk_queue_io_stat(bdev->bd_disk->queue))
>  		md_io_clone->start_time =3D bio_start_io_acct(*bio);
>  	else
>  		md_io_clone->start_time =3D 0;
> =20
> -	if (bio_data_dir(*bio) =3D=3D WRITE && md_bitmap_enabled(mddev, false))=
 {
> +	if (bio_data_dir(*bio) =3D=3D WRITE && bio_sectors(*bio) &&
> +	    md_bitmap_enabled(mddev, false)) {
>  		md_io_clone->offset =3D (*bio)->bi_iter.bi_sector;
>  		md_io_clone->sectors =3D bio_sectors(*bio);
>  		md_io_clone->rw =3D op_stat_group(bio_op(*bio));

[Severity: High]
Should md_free_cloned_bio() in drivers/md/md.c also check
md_io_clone->sectors before calling md_bitmap_end(), just like
md_end_clone_io() does here?

In drivers/md/md.c, md_free_cloned_bio() still has:

	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mddev, false))
		md_bitmap_end(mddev, md_io_clone);

In raid5_make_request() -> md_account_bio() -> md_clone_bio(), the bio is
cloned before calling make_stripe_request(). If make_stripe_request()
returns STRIPE_WAIT_RESHAPE when a reshape is interrupted,
raid5_make_request() aborts the cloned bio via md_free_cloned_bio():

	if (res =3D=3D STRIPE_WAIT_RESHAPE) {
		md_free_cloned_bio(bi);
		return false;
	}

With this patch, there are two cases where md_bitmap_start() is skipped
with md_io_clone->sectors =3D=3D 0:

1. When bio_sectors(*bio) =3D=3D 0 (for example, a zero-sector REQ_OP_WRITE=
 |
REQ_FUA bio, or a zero-sector REQ_OP_WRITE | REQ_PREFLUSH bio falling
through log_handle_flush_request() with -EAGAIN), md_clone_bio() sets
md_io_clone->sectors =3D 0 and skips initializing md_io_clone->offset and
md_io_clone->rw (leaving stale contents from the mddev->io_clone_set
mempool) and skips calling md_bitmap_start().

2. When bio_sectors(*bio) !=3D 0, but mddev->pers->bitmap_sector()
(raid5_bitmap_sector()) maps the range to md_io_clone->sectors =3D=3D 0,
md_bitmap_start() returns early without calling start_write() or
start_discard().

If make_stripe_request() then returns STRIPE_WAIT_RESHAPE,
md_free_cloned_bio() will unconditionally call md_bitmap_end(mddev,
md_io_clone) with md_io_clone->sectors =3D=3D 0 (and uninitialized offset a=
nd
rw in the first case). For llbitmap, llbitmap_end_write() and
llbitmap_end_discard() compute:

	unsigned long end =3D (offset + sectors - 1) >> llbitmap->chunkshift;

When sectors =3D=3D 0, if offset =3D=3D 0 this underflows to ULONG_MAX and =
walks
llbitmap->pctl[] out of bounds, or if offset > 0 it calls
llbitmap_release_barrier() to drop page barrier references on
pctl->active that were never raised.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-307-sashal@kernel.org?part=3D1
