Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9913002CF
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606674; cv=none; b=AWmdFqmJOUECsMaaNTXuygxjT1C/SqjyA9kpjYX93bpIVgMr+yVK5va5K4y22bsCpec92ZYgIjxB8gCOPOuBM960C/DpChDYPW0CrcpO0TzT2yJJhBTXPRCZNDgeM/KdHtzFlLobmgQkenyy8uENwaOmvmlikt5D7wkaMD8rV8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606674; c=relaxed/simple;
	bh=o0+csFjCg602w6WKmVkmges1W2h0p0PxaEhaVbA2Erk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mftpAjsCN4Thd+gCccGKaAuMNTli8S2y9CHu9iCFGYQ9+eAXo0V5V60gnV9fjcT3eZuB5OxblTxpwW+qoE0HGf37MmaMOpPmiX7PKs9CnfXGqubCNonhmbKsN5piu6axF5ZhNK8Y7qMqCvXyPny5KW4tkjdKp9Qc0ZeY/9xVWs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFQHm1XN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFQHm1XN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E48B1F00AC4;
	Sat,  1 Aug 2026 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606673;
	bh=DL4RE5dIdaezcHT2nhYv4NTBCwo/NK3btnqU3DcZcvk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZFQHm1XNW1MAAtUK6zmb/3K1b0Kx84a/UskmU2t8LYRITuTESKL/GdRdolwao3ssi
	 B6lvwcYfMeUPwIw0ynfx1/1mpl5dWGMlAFapRpfmrYIQfjNbzNo0NR/7/wMMvfdVWu
	 Qg8wy/eZAQJBeWCYi2bzPoYcF3oVAHFHwVSlytJrBp6FkaUNExknObOzgszmZ7SDAu
	 le5cpE1LZUTx8gSlmRgnDPR0jofrqIDOeOnlWy4DUGbBOK6fUn1lbKIhil0UjWWEOr
	 BVIHClBoLbSDr5IUuo/sZ90DOOKWx+ukjMxjp1GeVM73yM5MJ7L5crqJrsZ2u/n9+b
	 tmrKVi4WJ8dHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 12/25] md/md-llbitmap: track target reshape geometry
 fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-13-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-13-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:51:12 +0000
Message-Id: <20260801175113.6E48B1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Target reshape geometry is silently discarded across reboots due t=
o NULL `mddev->pers` during array assembly.
- [High] Reshape geometry tracking fails completely because target personal=
ity callbacks are unimplemented.

Pre-existing issues:
- [Critical] Expanded array regions suffer silent data loss during I/O due =
to mismatched chunkshift indexing.
- [Critical] Use-After-Free (UAF) in timer callback during subsystem teardo=
wn due to inadequate synchronization.
--

--- Patch [12]: [PATCH v4 12/25] md/md-llbitmap: track target reshape geome=
try fields ---
commit fff2be87a121aeeb8a4cb9f28329398a1b07d67a
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: track target reshape geometry fields

Track llbitmap bookkeeping for the target reshape geometry while keeping
a single live bitmap instance. Add the reshape geometry fields, refresh
helper, and update the load and resize paths to keep the target geometry
in sync.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index cf522fae78f8a..37d1312e3eab9 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -430,6 +433,39 @@ static void llbitmap_calculate_chunks(struct mddev *=
mddev, sector_t blocks,
>  	}
>  }
> =20
> +static bool llbitmap_reshaping(struct llbitmap *llbitmap)
> +{
> +	return llbitmap->mddev->reshape_position !=3D MaxSector;
> +}
> +
> +static sector_t llbitmap_personality_sync_size(struct llbitmap *llbitmap,
> +					       bool previous)
> +{
> +	struct mddev *mddev =3D llbitmap->mddev;
> +
> +	if (!llbitmap_reshaping(llbitmap) || !mddev->private || !mddev->pers ||
> +	    !mddev->pers->bitmap_sync_size)
> +		return llbitmap->sync_size;

[Severity: High]
Does this code handle array assembly correctly across reboots?

During array assembly, md_run() invokes md_bitmap_create() to load the
bitmap before explicitly assigning mddev->pers. Because mddev->pers is still
NULL during this bitmap loading phase, this check will unconditionally
hit the fallback path and return the old pre-reshape llbitmap->sync_size.

Could this cause the target reshape geometry to be completely lost if the
system reboots during a reshape, leading to inconsistent tracking?

[Severity: High]
Are there any RAID personality drivers that actually implement the new
bitmap_sync_size callback?

It appears these callbacks are not yet implemented in any RAID personality
drivers (e.g., raid5, raid1). Consequently, the check for
!mddev->pers->bitmap_sync_size will always evaluate to true, forcing a sile=
nt
fallback to the old geometry sizes.

Will this render the newly introduced reshape tracking mechanisms unable
to track the target geometry?

> +	return mddev->pers->bitmap_sync_size(mddev, previous);
> +}
> +
> +static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
> +{

[ ... ]

> @@ -1289,6 +1327,9 @@ static int llbitmap_resize(struct mddev *mddev, sec=
tor_t blocks, int chunksize)
>  		goto out;
> =20
>  	if (reshape) {
> +		llbitmap->reshape_sync_size =3D blocks;
> +		llbitmap->reshape_chunksize =3D bitmap_chunksize;
> +		llbitmap->reshape_chunks =3D chunks;
>  		llbitmap->chunks =3D max(old_chunks, chunks);

[Severity: High]
This is a pre-existing issue, but does this code scale the chunkshift to ma=
tch
the updated chunksize?

When a reshape increases array capacity beyond the bitmap's physical limits,
bitmap_chunksize is scaled up. The code updates llbitmap->chunks but seems
to miss updating llbitmap->chunkshift to match the new chunk size.

Later, during I/O operations, llbitmap_start_write() calculates the chunk
index using the stale, smaller chunkshift:

    unsigned long start =3D offset >> llbitmap->chunkshift;

This produces artificially large chunk indices for data in the expanded reg=
ion,
which llbitmap_state_machine() then detects as exceeding llbitmap->chunks a=
nd
silently drops:

    if (start >=3D llbitmap->chunks)
        return BitNone;

Could this lead to silent data corruption if writes to the expanded capacity
are never tracked in the bitmap?

>  	} else {
>  		if (blocks < old_blocks && chunks < old_chunks)

[ ... ]

[Severity: High]
This is a pre-existing issue, but is there adequate synchronization when
tearing down the bitmap?

During array destruction, llbitmap_destroy() initiates teardown by deleting
the timer and flushing the workqueue:

    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);

However, the function doesn't seem to set any shutdown flag. If the backgro=
und
work md_llbitmap_daemon_fn() is executing or queued when flush_workqueue()
is called, it runs to completion and unconditionally re-arms the timer:

    mod_timer(&llbitmap->pending_timer, ...);

Once the workqueue is flushed, llbitmap_destroy() proceeds to free the
llbitmap structure. The newly re-armed timer can subsequently fire and atte=
mpt
to access the freed memory inside llbitmap_pending_timer_fn().

Could this sequence result in a use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D12
