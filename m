Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C523BED69
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607958; cv=none; b=ffbgsTVcwApea/iGlKPBMXUN0Ert1Fauk97oYG7RTYEp8WmJ6/VP6+5vFHr5+gtq560t9p+D5wtAzcxQUoONMI3kLLrh5xQQpasapbBYHpnJsmpQajsC9+41/NiMPbyAsBqG0SpzXGCGrwiO7dC1NIr00lRqERdZpTJ8lEIFbxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607958; c=relaxed/simple;
	bh=zFT8mHeRF+RSDfNwY/NGz5wm43n5vxrrcr5m4YuzAuM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qRF4i7Am/KHOMHmBBdUAUnpfpVQKyJIfW+fELircs87o77l1n0HkA11/icnhW7cZmFWO+OZ0/oLyaEEMGQmxjmxbUXFNS+d5MssTJmKRDUamDg60bpv9n5Jiz7iZjfgjEMtlHZS7kMBg66NPh4dTW4uKqZ1X0FqQsPQH/S1Dv2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZubIf81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZubIf81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A611F00AC4;
	Sat,  1 Aug 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785607956;
	bh=hJsKF+/MOUvkZeU9ckRP2RXHECidcj1nNWXcQfTa+6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KZubIf81couyaTZ7/0o8Qvz7vPIM1iXtWgNM8I8dEVzGSBiu38cKTRcfTZT1hw4Nv
	 Rle/09iAtaeNlwGTtNLYufY9Wnwmwwftj8aNE8ZV0J9VdyTn/3SBWHcCzrRhUCCoAe
	 K78zKj6Zs+Z2j6Jwls1pW4dp+p5AEpiyQmHun+FUULoUbZfeGdx8jME6U7AwX2kiof
	 J0LbQ363F8N03GO5aIMMX4sAYHpAM/opmJBkLdqY0LjQ44EwrjFt7trOiN5syMFMAE
	 CEysKk8Mm1lHIizDcUkfEkw+CKJUCaaoCPqJdAVFEdMqOAofY+sVx4VoagkvWczBXc
	 GRsWUbrao4ZSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 24/25] md/raid5: wire llbitmap reshape lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-25-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-25-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 18:12:35 +0000
Message-Id: <20260801181236.45A611F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] raid5_start_reshape fails to invoke the reshape_can_start bitmap o=
peration before starting the reshape process.
- [High] raid5_finish_reshape unconditionally sets mddev->resync_offset =3D=
 0 when llbitmap is enabled, forcing an immediate full array parity rebuild.

Pre-existing issues:
- [High] The llbitmap daemon work and pending timer can mutually re-arm eac=
h other during llbitmap_destroy(), leading to a Use-After-Free.
--

--- Patch [24]: [PATCH v4 24/25] md/raid5: wire llbitmap reshape lifecycle =
---
commit 5324dd2fc19c643561ddccf4575506b5ce251538
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: wire llbitmap reshape lifecycle

Prepare llbitmap before RAID5 reshape starts, checkpoint the bitmap before
advancing reshape_position, and finish the llbitmap geometry update when
reshape completes.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5697570120da9..896aa522f446c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -8579,6 +8593,12 @@ static int raid5_start_reshape(struct mddev *mddev)
>  			mdname(mddev));
>  		return -EINVAL;
>  	}
> +	if (md_bitmap_enabled(mddev, false) &&
> +	    mddev->bitmap_id =3D=3D ID_LLBITMAP) {
> +		i =3D mddev->bitmap_ops->resize(mddev, mddev->dev_sectors, 0);

[Severity: High]
Does this code need to call the reshape_can_start() bitmap operation before
proceeding with the resize?

If a reshape begins while the llbitmap is actively tracking out-of-sync
chunks (BitNeedSync or BitSyncing), couldn't the reshape incorrectly map the
sync state to the new geometry?=20

This might lead to a loss of sync tracking and potential data regressions.

> +		if (i)
> +			return i;
> +	}
> =20
>  	atomic_set(&conf->reshape_stripes, 0);

[ ... ]

> @@ -8693,8 +8722,16 @@ static void raid5_finish_reshape(struct mddev *mdd=
ev)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	struct md_rdev *rdev;
> +	bool llbitmap =3D mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +		md_bitmap_enabled(mddev, false);
> =20
>  	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> +		if (llbitmap && mddev->bitmap_ops->reshape_finish)
> +			mddev->bitmap_ops->reshape_finish(mddev);
> +		if (llbitmap) {
> +			mddev->resync_offset =3D 0;

[Severity: High]
Does setting mddev->resync_offset to 0 here force an immediate full array
parity rebuild?

By unconditionally resetting the resync offset, the MD core might be
instructed that the entire array is out-of-sync upon reshape completion.

This would force a full resync of all sectors, despite the reshape correctly
remapping in-sync sectors, and cause performance regressions.

> +			mddev->resync_max_sectors =3D mddev->dev_sectors;
> +		}
> =20
>  		if (mddev->delta_disks <=3D 0) {


As a related note regarding llbitmap teardown:

[Severity: High]
This isn't a bug introduced by this patch, but can the llbitmap daemon work
and pending timer mutually re-arm each other during llbitmap_destroy(),
leading to a use-after-free regression?

Looking at drivers/md/md-llbitmap.c:llbitmap_destroy():

    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);

If the daemon_work is queued, the flush executes md_llbitmap_daemon_fn().

If there are unexpired dirty pages inside the work function, it will
unconditionally re-arm the timer via mod_timer().

Since there is no cancel_work_sync() or subsequent timer deletion, could the
newly armed timer fire after kfree(llbitmap) completes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D24
