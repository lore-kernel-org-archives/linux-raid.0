Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A306E33710F
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703427; cv=none; b=DoDX4xsokcvuRQAg6aX8uy7hICyKyOLPaK0xUmsVvHFovHFyiV0Xo+l+rrg6psYf+ekp5dVEEAqQ09vu3tpLjgQZznvEhlMxYYSTxpN5fz8IjCdvIzAFP1nsKjRUgqD88aC1FY6BGf2ZI1TyIowd1gzK0pqHCHXVyICNc+WZmDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703427; c=relaxed/simple;
	bh=B8voCtSH5JYE5UI6H+rqwxlXJCnxA8LtJb+v4/JLm80=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fyol/SahQc9DurLvdcDAd6pRV8R51wBB4LdvAasiNKdM6alMJiY0wzzUMHa4if7p+HIZg+iBP8k5iT1G9jQHqmR5v7ET+gQpwF5C9TzzpyQdiada1bAUOfdm2L8eGJMmDHuk9GiXTz5wBdAh7QmnYIGOWnoYJ7kjY+OjFdZoJZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhbrDmsD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhbrDmsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3138D1F000E9;
	Sun,  2 Aug 2026 20:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703426;
	bh=vTFAEWYH4TVWDWj6XYO+D+9ow19fRRd/oYAaq8QZyK0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NhbrDmsD2WwNQ0SIW8aUpdWY3GKkxzOmXup96O535VtddrNipjqV4E4MMTjCIIX0J
	 Rj+IBqZWyWrr/syWxapFH/ONbZpDTRmo0QVrUfW0x/WXi5YdBxpo0bqaJ4DdqarBYj
	 7y4gnFawSjEEoM0f17k8CBNkx6dJPMCzr70AGNG4OyZ5Eg7ekvgkG+G0TJhASlye/i
	 vNuBtTirmyW+gBfI/gVrupNCg889gj55vvc8YpJLIVH0QXCnVvvRUGqpycgKqmJJZq
	 cykugZ7wzIxfG0ZxAen2BcVapI92w6vIWgu7KkZhhFLLJlmc1IB7z+TsO/6FKDXt8J
	 cZk4nlD/Mc7iA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 21/29] md/md-llbitmap: remap checkpointed bits as
 reshape progresses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-22-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-22-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:43:45 +0000
Message-Id: <20260802204346.3138D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing read_lock(&llbitmap->reshape_lock) in background daemon an=
d sysfs paths causes read-modify-write data races with reshape checkpointin=
g.
- [High] llbitmap_rmerge_state() fails to handle BitCleanUnwritten and othe=
r unwritten sync states, incorrectly downgrading them to BitUnwritten.
- [High] The newly introduced reshape_mark feature to record checkpoint rem=
aps is dead code as it is never invoked by the MD subsystem.
--

--- Patch [21]: [PATCH v5 21/29] md/md-llbitmap: remap checkpointed bits as=
 reshape progresses ---
commit f911f407605f9d24ba29497958177e6d0f9e041f
Author: Yu Kuai <yukuai@fygo.io>
Subject: md/md-llbitmap: remap checkpointed bits as reshape progresses

This commit introduces a mechanism to merge checkpointed old llbitmap state
forward as reshape_position advances. It synchronizes reshape checkpoint
remapping against normal I/O bitmap updates using a read-write lock to avoid
data loss during concurrent read/modify/write paths.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index a20e55fdf82b0..5d95627ff9830 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -930,6 +943,33 @@ static int llbitmap_prepare_resize(struct llbitmap *=
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
> +	return BitUnwritten;
> +}

[Severity: High]
Does this logic handle unwritten sync states like BitCleanUnwritten?

If a chunk in BitCleanUnwritten, BitNeedSyncUnwritten, or
BitSyncingUnwritten is processed during a reshape on a RAID4/5/6 array,
the state evaluates through these checks and returns BitUnwritten.

Can this cause the array to lose track of valid parity or pending proactive
syncs, potentially triggering a full read-modify-write lazy recovery on the
next write, or leaving unwritten regions permanently unsynced?

[ ... ]

> @@ -1306,6 +1346,7 @@ static void md_llbitmap_daemon_fn(struct work_struc=
t *work)
> =20
>  	if (llbitmap->mddev->degraded)
>  		return;
> +
>  retry:
>  	start =3D 0;
>  	end =3D min(llbitmap->chunks, PAGE_SIZE - BITMAP_DATA_OFFSET) - 1;

[Severity: High]
Are there missing read locks for the reshape_lock in the background daemon
and sysfs paths?

The reshape_mark() function explicitly bypasses page suspension and uses
write_lock(&llbitmap->reshape_lock). However, the background daemon in
md_llbitmap_daemon_fn() calls llbitmap_state_machine() without acquiring
the read lock:

    llbitmap_state_machine(llbitmap, start, end, BitmapActionDaemon);

Similarly, sysfs writes via llbitmap_dirty_bits() call it without the lock:

    llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);

Could this result in read-modify-write data races? For example, if reshape
copies a BitNeedSync state and writes it, while the background daemon
concurrently evaluates a BitDirty to BitClean transition for the same chunk,
the daemon's write could overwrite the reshape's write and lose the
BitNeedSync state.

[ ... ]

> @@ -2181,6 +2384,7 @@ static struct bitmap_operations llbitmap_ops =3D {
>  	.prepare_range		=3D llbitmap_prepare_range,
>  	.reshape_finish		=3D llbitmap_reshape_finish,
>  	.reshape_can_start	=3D llbitmap_reshape_can_start,
> +	.reshape_mark		=3D llbitmap_reshape_mark,
>  	.write_all		=3D llbitmap_write_all,
> =20
>  	.groups			=3D md_llbitmap_groups,

[Severity: High]
Is the new llbitmap_reshape_mark() function dead code?

Although the reshape_mark operation is implemented and wired up in
struct bitmap_operations, it appears there are no callers in the MD core
subsystem (such as in md.c or raid5.c) that invoke
mddev->bitmap_ops->reshape_mark().

If the system crashes during reshape, could this missing hook prevent the
bitmap state from being correctly recovered because the remaps were never
recorded?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D21
