Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73DA272E53
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703453; cv=none; b=n2l/Q8Ev64sUeVMC9S+dmC6RwZD7GzPnDFPHngzMPz6fRHpIecxSfeMHSGNiBk75dhdknscezw9rLV/LkOa18DkjqJ7hsynndSJwoc/5pXxAPp8elIKTuva5p9xZF89JHXG+0GnH2NwHlePpgenx5EAoRnlR0rQS8xl6NQZgU6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703453; c=relaxed/simple;
	bh=ewtZnxcird0m62I1czljjccviu7i3FkVA700fYsHK6A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EV/xTMuKT7wjxc34iRP8mt31PAO80N7VIZPvsVXkXDNUwFqhvRavoGP6IKcr0IZhxpuH8m/sd4rNOnlL1iiY+wkpcxFB1uKJowAa5Qy+Qj2jPoEdgYuQJ2giVIUIB/3JQDqoIz7WK1mnknMgiTaXxMn/Xx5yUxVOFPX/UpK9pK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOPOcVZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOPOcVZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8706D1F000E9;
	Sun,  2 Aug 2026 20:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703452;
	bh=XKWC9x64CF92Z1EbskgivVcvwMzxdEJddfSDKC2FAfY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OOPOcVZz4k3xSsBXERo3EfsIV7ztzxmyPN9cTNeRNhu7mXggwIAfSGMmdOzjw7wst
	 P2T4gbsNzn2DvVI4s+DlHY0EUtK2ROCWnwAvH5037nPg44QioZ6yWM8CvNnQuN4BzU
	 QislzbKNAPAjngkME1XCZDQKLkjUMtU+7u/DbQzQEkmJ9VUUS3lcQRp67a7QzLhca5
	 8hgojJM6HQGNkw3JmG2a1WQztmKLSHrbAd87kOkx4nDsGxdzsv1CsCjp3wK/MNqInW
	 iOB9sKOdXq2HXCXaFMTNRy5bpEZrcPGuoK0D1z6vRQflOVzgaU4lljXe3NPK4vyKjf
	 1Vw1kXNstexBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 18/29] md/md-llbitmap: refuse reshape while llbitmap
 still needs sync
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-19-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-19-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:44:12 +0000
Message-Id: <20260802204412.8706D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The newly added reshape callbacks (`reshape_can_start`, `reshape_f=
inish`, and `reshape_mark`) are completely unreferenced by the core MD subs=
ystem, rendering the patch ineffective.
- [Medium] llbitmap_reshape_can_start() ignores proactive sync states for u=
nwritten regions, which would allow reshape to conflict with ongoing or pen=
ding syncs if the function were called.
--

--- Patch [18]: [PATCH v5 18/29] md/md-llbitmap: refuse reshape while llbit=
map still needs sync ---
commit 4b812e132deb0c081e68cf2925523d86a890d935
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: refuse reshape while llbitmap still needs sync

This commit rejects reshape when llbitmap still contains NeedSync or
Syncing bits. This is intended to keep reshape from starting until the
current llbitmap state has been reconciled.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index a7c229db3058d..f8a1b0f79be6a 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1718,6 +1718,29 @@ static void llbitmap_dirty_bits(struct mddev *mdde=
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
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Medium]
Does this check omit the unwritten equivalents of these sync states?

It appears that BitNeedSyncUnwritten and BitSyncingUnwritten are not
checked here.=20

Since these states also represent active or pending parity syncs, would
omitting them allow a reshape to conflict with an ongoing sync?

> +			ret =3D -EBUSY;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&mddev->bitmap_info.mutex);
> +
> +	return ret;
> +}
> +
>  static void llbitmap_reshape_finish(struct mddev *mddev)
>  {
>  	struct llbitmap *llbitmap =3D mddev->bitmap;

[ ... ]

> @@ -2034,6 +2057,7 @@ static struct bitmap_operations llbitmap_ops =3D {
>  	.dirty_bits		=3D llbitmap_dirty_bits,
>  	.prepare_range		=3D llbitmap_prepare_range,
>  	.reshape_finish		=3D llbitmap_reshape_finish,
> +	.reshape_can_start	=3D llbitmap_reshape_can_start,
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Are there any callers that actually use this new callback?

This patch populates the reshape_can_start callback in llbitmap_ops, but
does not appear to update the core MD subsystem (such as drivers/md/md.c)
to invoke mddev->bitmap_ops->reshape_can_start().

Without a caller, does this validation logic become unreachable dead code
that fails to reject the reshape?

>  	.write_all		=3D llbitmap_write_all,
> =20
>  	.groups			=3D md_llbitmap_groups,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D18
