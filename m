Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13886212F89
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 18:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607937; cv=none; b=igJmFnJQh8TvBX4TVWNpdMdeTshPoc5KQCFjnaxNcA2PMm2gM8bW8msuV5RW/78QPrgBV8aEeLheovOCGyrfBxdJ93bYthA1hKvrW0WxQOcHDFtInzD61TFVKEUUWp8A4WwwOoeb4bTioiFe6EBZ763SVj9KqVp/9C91f0ptjlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607937; c=relaxed/simple;
	bh=Q6NF76qsHS9WUV2UyvkhYW7XjW0dcj4iwr9kx4NCsJ4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QdPT9RZZee5bFbiAPDXhybUQJAtsn0LoHYibRuveNCTV76hHvkDaWirzVyGvyg6+uPAYVsQhp5k+ZpY6yvcJ1seWi/Dp76P1ODaco6rzwmxW0EH3rv6o7sgxXw3SyUhHS7TP74bV2hTlfT9eTbNkDz9gRGcxlXk7IM9FsEW6t+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnIvFcMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnIvFcMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D67E1F00ACA;
	Sat,  1 Aug 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785607935;
	bh=y13NHEhT/Cmg3OqPd0pRRBgcJ2SmtL7E+YPDDtmx2Zo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fnIvFcMRDeeq0+r2pNPOZPzONETLgLPVh5dLrqKLTcCtk5Rdl0WeQusPTR3VLsRnj
	 RUG22UVhMphf9xk7nLJf4ll/Pxrvx5HgkSRe9I9NnNf+s9STqz2qhexrFrbRTGa6ae
	 I5wT76VXLJ2ghDJZOT0DzasXFPgs19dQvscI9QFeTAzR74LgR+PVeQiT+X/kQfSTAR
	 R3cLVHZQF+h14LpvG3ru0+0Mrk1z4w29f57RDUmxckjU6t/nwU9uFIPxKZeEqxV7eI
	 bon8HQwdXr8d4Vy2sG0bOudGNDGREPxD10H5OWFL5fAbe3t4MCiF9Xm4c70EMP+lQO
	 vuOFewo7UpBWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 17/25] md/md-llbitmap: remap checkpointed bits as
 reshape progresses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-18-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-18-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 18:12:14 +0000
Message-Id: <20260801181215.7D67E1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Data race and potential bitmap state corruption due to missing `re=
shape_lock` acquisitions.
- [High] Incomplete feature implementation causing unreachable reshape chec=
kpointing (dead code).
- [High] `llbitmap_rmerge_state` incorrectly drops 'Unwritten' sync state e=
xtensions, causing array inconsistency.

Pre-existing issues:
- [Critical] Pre-existing Use-After-Free in llbitmap teardown due to daemon=
_work re-arming pending_timer.
--

--- Patch [17]: [PATCH v4 17/25] md/md-llbitmap: remap checkpointed bits as=
 reshape progresses ---
commit 51b23c29cf446cf378d49a002b1a356940be2ccd
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: remap checkpointed bits as reshape progresses

This patch introduces logic to remap checkpointed old llbitmap state forward
as reshape_position advances. It records the checkpoint remap through
reshape_mark() and adds a reshape_lock to serialize reshape checkpoint
remapping against normal I/O bitmap updates.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
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
Does this switch logic drop the proactive sync extensions like
BitNeedSyncUnwritten, BitSyncingUnwritten, and BitCleanUnwritten?

If either dst or src holds one of these states, it fails the explicit equal=
ity
checks and falls through to the default BitUnwritten. Could this cause the
array to lose its proactive sync requirement or pre-built parity state duri=
ng a
reshape checkpoint merge?

[ ... ]

> @@ -1294,6 +1334,7 @@ static void md_llbitmap_daemon_fn(struct work_struc=
t *work)
> =20
>  	if (llbitmap->mddev->degraded)
>  		return;
> +
>  retry:
>  	start =3D 0;
>  	end =3D min(llbitmap->chunks, PAGE_SIZE - BITMAP_DATA_OFFSET) - 1;

[Severity: Critical]
This is a pre-existing issue, but does the teardown path have a use-after-f=
ree
involving pending_timer?

In llbitmap_destroy(), timer_delete_sync() is called followed by
flush_workqueue(md_llbitmap_io_wq). If md_llbitmap_daemon_fn() is running,
flush_workqueue() will wait for it. However, md_llbitmap_daemon_fn() blindly
re-arms the timer at the end if there are unexpired dirty pages:

md_llbitmap_daemon_fn() {
    ...
    if (restart)
        mod_timer(&llbitmap->pending_timer, ...);
}

Could this cause the timer to fire after the llbitmap struct is freed, since
it re-arms after the teardown path has already deleted it?

[ ... ]

> @@ -1520,7 +1562,9 @@ static void llbitmap_start_write(struct mddev *mdde=
v, sector_t offset,
>  		page_start++;
>  	}
> =20
> +	read_lock(&llbitmap->reshape_lock);
>  	llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
> +	read_unlock(&llbitmap->reshape_lock);
>  }

[Severity: High]
Does this lock need to be acquired in other paths that call
llbitmap_state_machine() as well?

The reshape_lock is taken here to serialize against llbitmap_reshape_mark(),
but paths like md_llbitmap_daemon_fn() and llbitmap_start_sync() appear to
modify the state bytes without acquiring reshape_lock.

Since llbitmap_reshape_mark() bypasses page suspension, could this allow
concurrent execution with the daemon or sync threads, leading to
read-modify-write data races on the bitmap state bytes?

[ ... ]

> @@ -1873,6 +2049,33 @@ static void llbitmap_reshape_finish(struct mddev *=
mddev)
>  		mddev->pers->quiesce(mddev, 0);
>  }
> =20
> +static void llbitmap_reshape_mark(struct mddev *mddev, sector_t old_pos,
> +				  sector_t new_pos)
> +{

[Severity: High]
Is llbitmap_reshape_mark() ever invoked by the md subsystem during a reshape
operation?

A search through the tree doesn't show any callers invoking
mddev->bitmap_ops->reshape_mark(). If this callback is never executed, won't
the reshape checkpoint remapping fail to run and leave the bitmap in a stale
state?

> +	struct llbitmap *llbitmap =3D mddev->bitmap;
> +	sector_t lo;
> +	sector_t hi;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D17
