Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66AE2F7F15
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785702679; cv=none; b=vGKt/My0bm91QK4ThYRsPfzaL0nNPO9Blj+MFEx89xW1OvpbF08vczIqBlnpfyOneSNmg6hRkSVh15oBwykoi+byp63SQu4OT26/yDl5sRvrLL3JLoE6VdtwOXfkazsOF+TdTLTHZXor7FlcokGWMcQKjXq72OYf/heqf7jC4iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785702679; c=relaxed/simple;
	bh=XyP6LefNB27CJHBVxXlTLKSh+evo/bXmNtgzukvO3NE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SGVPtwmbMgeyFu6j+84A34Hwnh6W12IWRSjOPkiUSZ1rOydV9iz0QHfqcqcVQUOCywO3BJ3bS1P0TKPFdNcPg7mhwxmcrxsmRUNp5tBAezTYjeshqnPeBtkqPIY0AwmDVwVDSfAyut/REo0XTVyIAaMclbYD1pFPjfK6pKB3wOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAQodG8l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAQodG8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A181F000E9;
	Sun,  2 Aug 2026 20:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785702678;
	bh=nOErcBpPHX1JLpVzP79HRpz9XBaWmqkneOmXyXR9Abk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QAQodG8lGc4P1FQYq3ntaZR7F7Ck46OgNGf0SZBlNumUcoobmk3s8HNRQfrxiAkfz
	 XcVC4LxIHDh2p9bzEGR49NepDXnwnvxxU5FgjP7Pl84Y/UwkdydNfWlNDAaLCeoIvV
	 Zqmm+poqho5hOCD0ouf4yW0P45PH8WStLG7ueFo+heUFxFcMhvCt55sAQ9x3smsi6x
	 /j+bFuSwsLrGSTArWhhqmeeGDozi89/tIh5CGf2UuVkMoEbCQ2UZPtfvrCwI236fNs
	 O3GGglyrnhpiG4gjVd7T8jLJiGkfhVdGY1+Ywt/4Hh2NWdwOXVbWa9/CnNwngfEs22
	 zLcPE4gghPxng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 19/29] md/md-llbitmap: add reshape range mapping
 helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-20-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-20-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:31:17 +0000
Message-Id: <20260802203118.00A181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Missing implementation of `bitmap_array_sectors` and `bitmap_s=
ector_map` in RAID personalities breaks range mapping and drops valid array=
 writes.
- [Critical] Omitted post-mapping clamp allows out-of-bounds offsets to tri=
gger out-of-bounds array accesses in `llbitmap_start_write`.
- [Critical] Decoupled reshape geometry logic causes `start_sync` to decode=
 modified bits incorrectly during array recovery.
- [High] Skipping reshape boundary splitting when `MD_RECOVERY_RESHAPE` is =
clear corrupts straddling bios.
--

--- Patch [19]: [PATCH v5 19/29] md/md-llbitmap: add reshape range mapping =
helpers ---
commit 633da220a726aec9691f97e3c1481f36882f4315
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: add reshape range mapping helpers

Teach llbitmap to choose old versus new geometry during reshape and to
encode exact bitmap ranges for the active geometry. This is the mapping
groundwork for checkpoint remapping.

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index f8a1b0f79be6a..fa16a4224c45a 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> +static sector_t llbitmap_logical_size(struct llbitmap *llbitmap, bool pr=
evious)
> +{
> +	struct mddev *mddev =3D llbitmap->mddev;
> +
> +	if (!mddev->private || !mddev->pers ||
> +	    !mddev->pers->bitmap_array_sectors)
> +		return llbitmap_personality_sync_size(llbitmap, previous);
> +	return mddev->pers->bitmap_array_sectors(mddev, previous);
> +}

[Severity: Critical]
Since bitmap_array_sectors is absent from all RAID personalities in this
patch series, won't this always fall back to
llbitmap_personality_sync_size()?

If a write is issued to a RAID5 array at a logical offset greater than
dev_sectors, it appears this will incorrectly use the physical component
size (dev_sectors) as the limit for the logical array offset, causing
llbitmap_map_layout() to drop valid array writes.

[ ... ]

> +static void llbitmap_map_layout(struct llbitmap *llbitmap, sector_t *off=
set,
> +				unsigned long *sectors, bool previous)
> +{

[ ... ]

> +	if (llbitmap->mddev->pers->bitmap_sector_map)
> +		llbitmap->mddev->pers->bitmap_sector_map(llbitmap->mddev, offset,
> +							 sectors, previous);
> +	else if (!previous && llbitmap->mddev->pers->bitmap_sector)
> +		llbitmap->mddev->pers->bitmap_sector(llbitmap->mddev, offset,
> +							 sectors);
> +}

[Severity: Critical]
The commit message states we need to keep the existing sync-size clamp after
mapping, but does this code actually enforce that post-mapping clamp?

Without a clamp against llbitmap_personality_sync_size() here at the end
of the function, could an out-of-bounds logical offset bypass filtering?
If that happens, llbitmap_start_write() could calculate an out-of-bounds
page_start index and trigger memory corruption inside
llbitmap_raise_barrier() before the state machine drops it.

[ ... ]

> +static void llbitmap_encode_range(struct llbitmap *llbitmap, sector_t *o=
ffset,
> +				  unsigned long *sectors, bool previous)
> +{
> +	unsigned long chunksize =3D previous ? llbitmap->chunksize :
> +				      llbitmap->reshape_chunksize;

[ ... ]

> +	start =3D div64_u64(*offset, chunksize);
> +	end =3D div64_u64(*offset + *sectors - 1, chunksize);
> +	*offset =3D (sector_t)start << llbitmap->chunkshift;
> +	*sectors =3D (end - start + 1) << llbitmap->chunkshift;
> +}

[Severity: Critical]
Does this decoupling of reshape geometry logic cause issues for the sync pa=
th
during recovery?

Here, writers calculate the chunk index using the new geometry
(reshape_chunksize) but scale it using the old chunkshift. Later, during
array recovery, llbitmap_start_sync() unconditionally shifts the physical
component offset by the old chunkshift:

unsigned long p =3D offset >> llbitmap->chunkshift;

Will this mismatch cause llbitmap_start_sync() to decode the wrong bit
index and skip recovering modified active data?

[ ... ]

> +static bool llbitmap_map_previous(struct llbitmap *llbitmap, sector_t of=
fset,
> +				  unsigned long sectors)
> +{
> +	struct mddev *mddev =3D llbitmap->mddev;
> +	sector_t boundary =3D READ_ONCE(mddev->reshape_position);
> +
> +	if (boundary =3D=3D MaxSector)
> +		return false;
> +
> +	WARN_ON_ONCE(sectors && offset < boundary && offset + sectors > boundar=
y);
> +
> +	return mddev->reshape_backwards ? offset < boundary : offset >=3D bound=
ary;
> +}

[Severity: High]
Can a straddling bio trigger this WARN_ON_ONCE and corrupt the bitmap if a
reshape is paused?

If a user pauses a reshape or the array enters a degraded state,
MD_RECOVERY_RESHAPE might be cleared. If mddev_bio_split_at_reshape_offset()
checks this flag and skips splitting the bio, a fully unsplit straddling
bio could reach here. This would force the entire bio to be evaluated
against a single geometry based purely on its starting sector, destroying
bitmap integrity for the straddling tail.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D19
