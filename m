Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2893411F92;
	Wed, 22 Jul 2026 19:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747809; cv=none; b=noO/CjfWgAgrdCSpgl2ZmFJ73mv93+CK2TMxH1AEdOUe0f+aJuMnNEY9ty/+3Il6YIr9cUm5DF4qE9OV87nbE5CgleEFLcfWkUeok4u2gYQK0T9I8AYpmj7lDSZSwCpWUEbyvQtIdLO0sRQSYaYPcCz5t4SXnTCsXQNd+Y/og5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747809; c=relaxed/simple;
	bh=zXqpDuaksru2jHIO8DfdyA2NhNdn4G+RQcT5d9ZyVQo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WGhVOOIq50MSpRvm9+lEI5HaMScGzs+/2IltwWE1f7cyGB+R3kZzpNeQXWNIzU/9rLdurfnS4s5uy4JgvJZR5GLPIQqI08iX3U9m0ofwAthZMhz6D5Hx8YL34NbJKlU4dfw05gxlBZYfZOoXjxklZ5j99uLiOjU11rXVjmDm9zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buyrAIne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buyrAIne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC511F000E9;
	Wed, 22 Jul 2026 19:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747806;
	bh=oiKz9Do/vPJ0TfnhlihNppYWPOr/C/hYs9a1jk9QGEw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=buyrAInerrZ832uGlVqiZk1N0nPmL6xcISUbCj2aT4OCOkMvvBjpSmqTodOnyZKnM
	 k0XZBcuiGZiibM2nk1ZHA6ZUUG5aVxI421dOmqW0UDFoaU9P2FAqNZV4nKdGNho7C3
	 7DQ2qQ29i4g8RMQO8EmUhV9fIWTKzANimtxHM4A8fKiZWXGYZ0efw6JbDL2lQS7e8C
	 wHRzJZTtARLCAP/YE4Kvo5K3uza3sNEd5C9NUrxJAAPhqG4jvOHHsPoHtzLyaJ6T95
	 v79p5JHW5ZpJEp7no4EKUuGSLt0KSsA6Acy4e92PbI9ZrMm32dGtczd5e5W5o6c3X9
	 CftpETY0EJrmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 6/9] md/raid1,raid10: keep REQ_NOMERGE on
 narrow_write_error() retry clones
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, linux-pci@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260722185841.449934-7-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-7-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:16:45 +0000
Message-Id: <20260722191646.3AC511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] narrow_write_error() incorrectly coerces dataless operations into =
data-bearing REQ_OP_WRITE states, causing block layer crashes.
--

--- Patch [6]: [PATCH v4 6/9] md/raid1,raid10: keep REQ_NOMERGE on narrow_w=
rite_error() retry clones ---
commit 4017c1a8ef243dcaefd606ee7c22696e4aaccaa1
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones

This commit fixes a missing REQ_NOMERGE flag on P2PDMA retry clones in
narrow_write_error(). It ensures that member queues do not merge P2PDMA
segments incorrectly when a bio is retried after a write error.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2561,6 +2561,9 @@ static void narrow_write_error(struct r1bio *r1_bio=
, int i)
>  		}
> =20
>  		wbio->bi_opf =3D REQ_OP_WRITE;
> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;

[Severity: High]
This is a pre-existing issue, but does setting wbio->bi_opf unconditionally=
 to
REQ_OP_WRITE here cause a NULL pointer dereference for dataless requests?

If the array is processing a REQ_OP_SECURE_ERASE request (which has bi_size=
 > 0
but bi_io_vec is NULL) and hits a write error, narrow_write_error() will fo=
rce
the operation to REQ_OP_WRITE. Because REQ_OP_WRITE expects a data vector, =
the
subsequent call to bio_trim() in this loop will attempt to advance a NULL
bi_io_vec during chunk iteration, resulting in a crash.

>  		wbio->bi_iter.bi_sector =3D r1_bio->sector;
>  		wbio->bi_iter.bi_size =3D r1_bio->sectors << 9;

[ ... ]

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2823,6 +2823,9 @@ static void narrow_write_error(struct r10bio *r10_b=
io, int i)
>  		wbio->bi_iter.bi_sector =3D wsector +
>  				   choose_data_offset(r10_bio, rdev);
>  		wbio->bi_opf =3D REQ_OP_WRITE;
> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;

[Severity: High]
This is a pre-existing issue, but similar to the raid1.c case above, could
this coercion to REQ_OP_WRITE crash lower-level drivers?

If a REQ_OP_SECURE_ERASE request hits a write error and is retried here,
wbio->bi_opf is overridden to REQ_OP_WRITE before calling submit_bio_wait().
When this malformed write bio with a NULL bi_io_vec is sent to lower layers
(like NVMe or SCSI), it can cause a panic during DMA mapping since those
drivers expect a valid bvec for REQ_OP_WRITE.

> =20
>  		if (submit_bio_wait(wbio) &&
>  		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D6
