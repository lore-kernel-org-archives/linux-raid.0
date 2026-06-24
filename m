Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB792F8E9C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284697; cv=none; b=eCjxEDH/zBQ64JaRNr4fTBqpQo9XU81C7tLhR+V9UNWN4JF6j+9cSoE8KDNBwJl5lKk1kyjiDT+4yfJGgvkzhn7ubJyoCD/VSrVGzAlLkEErsRoQGmGxnz41X+t39CwcvfvxKug13f4/KEXTrGxEJUN3hiD5fbQ0NzFn6RSKOww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284697; c=relaxed/simple;
	bh=lC7lc0An0jRQwuOdju+YjKoUz+dc1qDIC8fP5QixAno=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MybzPdlFqaSyPLCiWfSpn0pKMapisvDx9+QFTf2ViQzTxpM8QqNNLM8SkCVGqREtjq1HkvKq0fv/194qA+ExB2zJ+Uqc+T/Fk5JKUc36hYPucSJNVc+XGuO8z9VCgaY3NIHWESnPp0tEZHvFc8jTTx6eqJaSrJeS8b5ze24xxsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Azuj4UYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Azuj4UYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A771F000E9;
	Wed, 24 Jun 2026 07:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284696;
	bh=KYyVDqqR1k5GoTMxP9/6NvhsunnhuBIfHQtu3CYSDSY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Azuj4UYJrnnwTco9ZN7xH4ZrduhBHE5FHf8KCADsxICK7ZWyXlDi1YEA/hyJcuGnW
	 zFfxwK/gl/Tp0EDiGpyGFnPgkSlFUwJyghsxDgmMsQnyoTti5qFwu3FgH9a7y1FzIr
	 QIb4UhOuEpYdcvcCFpMeC5YI6tyTLXg1Yv8sk0SJlylm/heFF5HSg5y4Mh7BS0Tglm
	 R0PuxUyQrw5ICwym069ymFm/vCG4SlRy2bC2W0yzeE9qCJv4OPyPf01FCeUjEkif+c
	 H70uQ78qD/6XnjxUMy21yY1cGnmr9s7Pi6DfyK98PXt2+48S0l8ZQ7SK4FYve5zUUy
	 qv4mlSgRoRy3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/20] md/md-llbitmap: remap checkpointed bits as
 reshape progresses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <8700112d660a7f9fa48d174ee9b395fbe309e7c9.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <8700112d660a7f9fa48d174ee9b395fbe309e7c9.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:04:55 +0000
Message-Id: <20260624070456.39A771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] In-place array modification during reshape overwrites un-resha=
ped source data before it can be read.
- [High] Non-atomic read-modify-write cycle in `llbitmap_reshape_merge` rac=
es with concurrent normal I/O, dropping `BitDirty` flags.
- [High] Missing handling for `BitNeedSyncUnwritten` and `BitCleanUnwritten=
` in `llbitmap_rmerge_state` silently demotes them.
- [High] The `level_456` condition in `llbitmap_rmerge_state` is completely=
 ineffective and subsumed by the subsequent fallback.
--

commit a1307817c41ef916bb59f41a3af5b2d7a709caa2
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: remap checkpointed bits as reshape progresses

Merge checkpointed old llbitmap state forward as reshape_position
advances and record the checkpoint remap through reshape_mark().

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index c62397743d9a0..00b77ecd600be 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -906,6 +914,33 @@ static int llbitmap_prepare_resize(struct llbitmap *=
llbitmap,
>  	return 0;
>  }
> =20
> +static enum llbitmap_state
> +llbitmap_rmerge_state(struct llbitmap *llbitmap,
> +		      enum llbitmap_state dst,
> +		      enum llbitmap_state src)
> +{
> +	bool level_456 =3D raid_is_456(llbitmap->mddev);
> +
> +	if (dst =3D=3D BitNeedSync || dst =3D=3D BitSyncing ||
> +	    src =3D=3D BitNeedSync || src =3D=3D BitSyncing)
> +		return BitNeedSync;

[Severity: High]
Are BitNeedSyncUnwritten and BitCleanUnwritten states meant to be handled
here?

Because they do not match BitNeedSync, BitSyncing, BitDirty, or BitClean,
they fall through these conditions. If paired with BitClean, they
incorrectly evaluate to BitClean; otherwise, they fall through to
BitUnwritten. Both outcomes silently drop the sync requirement.

> +
> +	if (dst =3D=3D BitDirty || src =3D=3D BitDirty)
> +		return BitDirty;
> +
> +	/*
> +	 * Reshape generates valid target parity/data for both already-written
> +	 * and not-yet-written regions in the checkpointed range, so a mix of
> +	 * clean and unwritten still results in a clean destination bit.
> +	 */
> +	if (level_456 && ((dst =3D=3D BitClean && src =3D=3D BitUnwritten) ||
> +			  (src =3D=3D BitClean && dst =3D=3D BitUnwritten)))
> +		return BitClean;
> +	if (dst =3D=3D BitClean || src =3D=3D BitClean)
> +		return BitClean;

[Severity: High]
Does the fallback condition "dst =3D=3D BitClean || src =3D=3D BitClean" re=
nder the
preceding level_456 check dead code?

The fallback unconditionally forces any BitClean mix to BitClean, which
entirely overrides the level_456 restriction. Could this lead to RAID10
incorrectly resolving mixed BitClean and BitUnwritten states to BitClean,
causing skipped resync operations?

> +	return BitUnwritten;
> +}

[ ... ]

> +static void llbitmap_reshape_merge(struct llbitmap *llbitmap,
> +				   const struct llbitmap_reshape_range *old,
> +				   const struct llbitmap_reshape_range *new)
> +{
> +	unsigned long dst_start;
> +	unsigned long dst_end;
> +	unsigned long dst;
> +
> +	if (!new->sectors)
> +		return;
> +
> +	dst_start =3D div64_u64(new->offset, llbitmap->reshape_chunksize);
> +	dst_end =3D div64_u64(new->end - 1, llbitmap->reshape_chunksize);
> +
> +	for (dst =3D dst_start; dst <=3D dst_end; dst++) {
> +		struct llbitmap_reshape_range dst_range;
> +		struct llbitmap_reshape_range src;
> +		enum llbitmap_state state;
> +
> +		llbitmap_reshape_dst_range(llbitmap, dst, new, &dst_range);
> +		state =3D llbitmap_reshape_init_dst(llbitmap, dst, new);

[Severity: High]
Does this non-atomic read-modify-write cycle race with concurrent normal I/=
O?

llbitmap_reshape_init_dst() reads the chunk state, computes the merged state
through llbitmap_rmerge_src(), and writes it back via llbitmap_write() below
without being protected by locks.

Concurrent normal I/O operating on stripes outside the reshape window but
within the same bitmap chunk can set BitDirty. The llbitmap_reshape_merge()
thread will blindly overwrite this BitDirty flag with its locally computed
state, potentially causing silent data corruption due to lost BitDirty
flags.

> +		if (llbitmap_reshape_src_range(old, new, &dst_range, &src))
> +			state =3D llbitmap_rmerge_src(llbitmap, state, &src);
> +		else
> +			state =3D llbitmap_rmerge_state(llbitmap, state, BitUnwritten);
> +		llbitmap_write(llbitmap, state, dst);

[Severity: Critical]
Does writing directly to the shared pctl array overwrite un-reshaped source
data before it can be read?

When adding disks to a RAID5 array, new->sectors > old->sectors. This causes
the forward iteration of dst to outpace bit in llbitmap_rmerge_src()
(e.g., dst =3D 10, bit =3D 5).

Because llbitmap_write() updates the array in place, the state at index 5
is overwritten before it is read for dst =3D 10, destroying the original ch=
unk
state.

> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D12
