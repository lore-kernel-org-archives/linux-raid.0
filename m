Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BBB2F8E9C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284686; cv=none; b=eVyPH9dqQGKFBrFRcFRaW8O1uSfPL3QHWAnEJx+owsc2Tkw05H08lLzQuwetcl3/R0fgakx9yythhQQhISIa9hfwuaJSKPvNLfjZtpZgaLQs1RmD0I/1eZuQO7QlsDFeYYcX3/e5B2CY4Jdk0PZOSBBLHdkxmKQSsnhzPH4k/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284686; c=relaxed/simple;
	bh=l1J1lnC1sDkwiSGbIsbJe+p0USQaLZte+/ruxEOyNqw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m6+r/hV+c3bonBDlC1rP8uADYVVEbTKaFNM64JyKOD/fR1eBy6sfGWajyVhCrU5GJjRYEzup8E6EMTBe+bM9n7j3dP3dXdar1VB48DtpHX7sFDcZZm/jgfzeRJzxLIm0t6smmNL1lBNOAj9ynKNdhVwXxa2J5NSG10DjxbulaQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aq0jlcr1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aq0jlcr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34711F000E9;
	Wed, 24 Jun 2026 07:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284685;
	bh=LGPpD2onetZt8heOyfutHM9g3aZNcr0zNKN/XxeczmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aq0jlcr1NTo1C0BkDbR+gkn4y9hzPs5r3Ai7eqM2BCVq4Y8VFvtO3ix7SJxSBrhiV
	 ugaihtCy4u6/9Kqf9f3ZaBVamPAeeEqzSg5jRSwFonFIf/V38FSMEHuZnM7lb9Ua2z
	 F1WUfsMMRhTxlO0J3h+jQ8X3REVdk2IIPG+qqwzXqsBLqzwJH5ZHpc65kSS4yIsg0j
	 PtvGxjJyey7VigIYtzzkkw3v/4tjEgehIR9fDVtwwNmVyx8N0bDUJ2VHr/eMgvCWOe
	 C+oBG2uQYcHgjJ4xIxFzor/JRtNZssIxfqZV3NjV6UZOzG2VIiBv1McJ/MYvZcMGu3
	 V182lEk/07Y5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/20] md/md-llbitmap: refuse reshape while llbitmap
 still needs sync
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <fde37bced9be5e6b4d0f71cdd7d33d9387c022f6.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <fde37bced9be5e6b4d0f71cdd7d33d9387c022f6.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:04:44 +0000
Message-Id: <20260624070444.D34711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] llbitmap_reshape_can_start() fails to reject reshape when chunks a=
re in BitNeedSyncUnwritten or BitSyncingUnwritten states.
- [High] The newly introduced reshape_can_start callback is never invoked b=
y the RAID5 subsystem, rendering the reshape refusal logic non-functional f=
or RAID5/6.
--

commit fc17ecb84d03fe66b3e1048dc17b6b8022da7f9b
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: refuse reshape while llbitmap still needs sync

Reject reshape when llbitmap still contains NeedSync or Syncing bits.

This keeps reshape from starting until the current llbitmap state has
been reconciled.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index ae2e87fd58874..11fede1fc79fd 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1680,6 +1680,29 @@ static void llbitmap_dirty_bits(struct mddev *mdde=
v, unsigned long s,
>  	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
>  }
> =20
> +static int llbitmap_reshape_can_start(struct mddev *mddev)
> +{
> +	struct llbitmap *llbitmap =3D mddev->bitmap;
> +	unsigned long chunk;
> +	int ret =3D 0;
> +
> +	if (!llbitmap)
> +		return 0;
> +
> +	mutex_lock(&mddev->bitmap_info.mutex);
> +	for (chunk =3D 0; chunk < llbitmap->chunks; chunk++) {
> +		enum llbitmap_state state =3D llbitmap_read(llbitmap, chunk);
> +
> +		if (state =3D=3D BitNeedSync || state =3D=3D BitSyncing) {

[Severity: High]
Should this check also include BitNeedSyncUnwritten and BitSyncingUnwritten
states?

Reshaping an array while it has regions pending or undergoing proactive par=
ity
synchronization could change the array layout while the background sync pro=
cess
is running, potentially leading to corrupt parity.

> +			ret =3D -EBUSY;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&mddev->bitmap_info.mutex);
> +
> +	return ret;
> +}
> +

[ ... ]

> @@ -2002,6 +2025,7 @@ static struct bitmap_operations llbitmap_ops =3D {
>  	.dirty_bits		=3D llbitmap_dirty_bits,
>  	.prepare_range		=3D llbitmap_prepare_range,
>  	.reshape_finish		=3D llbitmap_reshape_finish,
> +	.reshape_can_start	=3D llbitmap_reshape_can_start,

[Severity: High]
Is the reshape_can_start callback invoked by the RAID5 subsystem when start=
ing
a reshape?

Looking at raid5_start_reshape() in drivers/md/raid5.c:

    if (md_bitmap_enabled(mddev, false) &&
        mddev->bitmap_id =3D=3D ID_LLBITMAP) {
        i =3D mddev->bitmap_ops->resize(mddev, mddev->dev_sectors, 0);

It doesn't appear to call mddev->bitmap_ops->reshape_can_start. This could
allow RAID5/6 arrays to start a reshape while the bitmap still contains
pending sync bits, causing the array layout to change before parity is
reconciled.

>  	.write_all		=3D llbitmap_write_all,
> =20
>  	.groups			=3D md_llbitmap_groups,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D9
