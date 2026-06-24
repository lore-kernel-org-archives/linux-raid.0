Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB28E396B7F
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285632; cv=none; b=sDZLRy+8XYCZaEhqRQzrohytdKGD5UQGs+AuUYjtvmwPHfZ8Qv7CNFLogvwgNiDduRxLTkNO7LOzs/DILPPxz/xARBvQ/Mm2xB6qryTgA6R4EXbK/XDnJp55MyetiC2RkaC3+0tAe5ktqeXP3HxQw61h+MW8SvE9u2O2DSSspTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285632; c=relaxed/simple;
	bh=V9DE7GxCzREGy7k1fSmxSH0giibUxy6s9Qk+VOHxq8w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oR3SE0FR7UaT7AYt4tWT96CmZNuqgiQGm54mEsfmdExbqlsozgpTUXjDLs1wy9DY54np5ckUDUbxn7OmQ20bxJEHYuFMeNRCgWy6s0rUGmYnQ7186ZCf4117r3Tt0Mc7t0dhBY9P0YJL+I7C85hRsVRSAPVE4ULx9UrUSxVju/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tq/7/ewl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tq/7/ewl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B5F1F000E9;
	Wed, 24 Jun 2026 07:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782285627;
	bh=b/qiHK9rWrYbce6L9wI3iKtK2/MeIThidkqzyyj+XTE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tq/7/ewldYeqvvW/TYuPK4Vr8mfQ0/S+5YsdsFLEvicgvhGyXgh4+gcus5RtRia4H
	 hw2e3MwkqMflQY3FYBJKr5Bo6TEni46fwwgoYojZfZH8zyv6DEbElrZUtDdZKP6GnB
	 vNkaiJ36cO7VlUQYjDPX86eig6cEvmykXbsGsi5v7zSE1oyBb8tkFv6lKdlUdB/b4w
	 +lnKTAViBq9KlI4EIto29Qr/1ObMEmjo+cQnhuO3mlh+paZoF0O8y1Zz0oZL08k0Lc
	 6Hb6qKzZuuMs9oGDa564h7U1jb1Wi9fq0GAKUMhZb5GB5wxC4HYNF5I/M6F93jhfkh
	 p0Abbt9ZlgpmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 19/20] md/raid5: wire llbitmap reshape lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <55686793056df8053d1797d22c18fce8df7eebe8.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <55686793056df8053d1797d22c18fce8df7eebe8.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:20:25 +0000
Message-Id: <20260624072026.52B5F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Checkpointing the translated llbitmap to disk before the MD su=
perblock is updated creates a crash window that leads to silent data corrup=
tion on restart.
- [Critical] The llbitmap page control array (`llbitmap->pctl`) can be acce=
ssed after being freed during RAID5 reshape initialization because the bitm=
ap resize happens before the array is quiesced.
--

commit 18675e43f792016c6cde2f177af7a007c667120d
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: wire llbitmap reshape lifecycle

Prepare llbitmap before RAID5 reshape starts, checkpoint the bitmap
before advancing reshape_position, and finish the llbitmap geometry
update when reshape completes.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9de648f75dd04..ac7ea483502fd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -6430,6 +6430,13 @@ static sector_t reshape_request(struct mddev *mdde=
v, sector_t sector_nr, int *sk
>  			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>  		if (atomic_read(&conf->reshape_stripes) !=3D 0)
>  			return 0;
> +		if (md_bitmap_enabled(mddev, false) &&
> +		    mddev->bitmap_ops->reshape_mark &&
> +		    conf->reshape_safe !=3D conf->reshape_progress) {
> +			mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
> +						       conf->reshape_progress);
> +			mddev->bitmap_ops->unplug(mddev, true);
> +		}

[Severity: Critical]
Does checkpointing the translated llbitmap to disk before the MD superblock
is updated create a crash window that leads to silent data corruption on
restart?

During RAID5 reshape, the code translates the bitmap to the new layout via
reshape_mark() and flushes it to disk before asynchronously waking the MD
thread to update the superblock.

If the system crashes after the bitmap flush but before the superblock write
completes, the on-disk metadata will still point to the old reshape position
(reshape_safe), while the on-disk bitmap for the region=20
[reshape_safe, reshape_progress] will be stored in the new layout.

On reboot, the array will resume the reshape from reshape_safe and
misinterpret the newly mapped bitmap bits as if they were in the old layout.
If the array is degraded during this restart, it might incorrectly assume t=
he
parity for these sectors is in-sync and reconstruct missing data using
corrupted parity.

>  		mddev->reshape_position =3D conf->reshape_progress;
>  		mddev->curr_resync_completed =3D sector_nr;
>  		if (!mddev->reshape_backwards)

[ ... ]

> @@ -8571,6 +8585,12 @@ static int raid5_start_reshape(struct mddev *mddev)
>  			mdname(mddev));
>  		return -EINVAL;
>  	}
> +	if (md_bitmap_enabled(mddev, false) &&
> +	    mddev->bitmap_id =3D=3D ID_LLBITMAP) {
> +		i =3D mddev->bitmap_ops->resize(mddev, mddev->dev_sectors, 0);
> +		if (i)
> +			return i;
> +	}

[Severity: Critical]
Can this resize operation trigger a use-after-free regression since it
occurs before raid5_quiesce() stops concurrent I/O?

In raid5_start_reshape(), mddev->bitmap_ops->resize() is called to prepare
the bitmap for the new geometry before raid5_quiesce() is invoked. This mea=
ns
the array is not suspended, and concurrent I/O is actively being handled.

If the resize operation calls llbitmap_expand_pages() and frees the old
pctl array via kfree() without RCU synchronization, concurrent fast-path I/O
threads executing llbitmap_start_write() could locklessly dereference the
freed pointer array in llbitmap_raise_barrier().

> =20
>  	atomic_set(&conf->reshape_stripes, 0);
>  	spin_lock_irq(&conf->device_lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D19
