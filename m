Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B6E41B36C
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229959; cv=none; b=IGGkeTQfVHbRAfyxxsoQpPQPXv8mOFJ6q2yk8AQ8psz5Y4m72jFoUE8oZ1epIkavRAN9XLhmlX42pxYSI95yNGX1ii1Gw3VoAkkkySdyookrzLkrh1EQyhFHQro/nWzpbPXcwjT2cDKY16rFtJHduA98gxqd4yDFm9pf1FGrgsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229959; c=relaxed/simple;
	bh=bHm9x1Tl9lcxU9sxYmfI7vnldXNwdVYRQ3AIFBt4Dw4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Sn90191N7lxe6wMqTxg8MDoNUDr6Hsc36q96Xic73Sl0y9Kflw/zQmltmWohiDUCKUyZiP99JN3P2yRc1Q3zCpAeC+BD6DKUh+mCwk13OspM3vy5IqDlnoAlnuHRg+s8jibJ2EmyEk+7jSZqXfLJUHVdWx6lMUxPgzxmHzf2Pqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fzd+Fv15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fzd+Fv15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C0D1F00A3A;
	Tue, 28 Jul 2026 09:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229957;
	bh=fIwxmW/tAIuIrw864fdueF++Koo1fc3RFFQYQj//mdQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fzd+Fv15Zq7J+55v/IcWVUQWc7ARgjtGYQI37e9HTwnAByQFI1SVQhNoaHVg3j3fK
	 fZcH8UQBn8DHF41IWyUAirR5o6p39iYGLM8vAR54STf31TOCqq0G0iIie2LDpIFDwM
	 tiF40Izitw+NWPSHhox/RKdUqUtYvuyyvUUZFyeK5hKoAyCG2Kms9OqPxaR0LAMsGK
	 nf0UmGSEdsqTiSpD3MpDoLHjiWg+JKk8J5GhdkazvsQrN7+jVVDIHsDxhCWVUTe5Hh
	 GVWSMtjEzfNfk0sXFyI5DjV8c6AneiDVtKSvB/rFglng/TJmdgMUlV2lehPBRwKCwA
	 CFd68dIZFPq/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/21] md/md-llbitmap: refuse reshape while llbitmap
 still needs sync
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <0acf74e3881021e14f5a254480f06642ad911d3a.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <0acf74e3881021e14f5a254480f06642ad911d3a.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:12:37 +0000
Message-Id: <20260728091237.82C0D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The newly introduced reshape rejection callback is never invoked b=
y the core MD subsystem, rendering the fix ineffective.
- [Medium] The `llbitmap_reshape_can_start` function caches the bitmap poin=
ter outside of the mutex lock, creating a Time-Of-Check to Time-Of-Use vuln=
erability that can lead to a Use-After-Free.
- [Medium] The reshape check ignores `BitNeedSyncUnwritten` and `BitSyncing=
Unwritten`, allowing reshape to start during proactive sync.
--

--- Patch [10]: [PATCH v3 10/21] md/md-llbitmap: refuse reshape while llbit=
map still needs sync ---
commit b7405e7962d5eb002f38e66bc1e8cec9737a66ea
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: refuse reshape while llbitmap still needs sync

This commit rejects reshape operations when the llbitmap still contains
NeedSync or Syncing bits. It aims to prevent reshape from starting until
the current llbitmap state has been reconciled.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 55ab2a8a11e5f..f5df82adef640 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -1689,6 +1689,29 @@ static void llbitmap_dirty_bits(struct mddev *mdde=
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

[Severity: Medium]
Is there a race condition between reading the bitmap pointer and taking the
mutex?

If llbitmap_destroy() executes concurrently, acquires the mutex, sets
mddev->bitmap to NULL, and frees the bitmap while we are checking the point=
er
outside the lock, could we end up dereferencing a freed pointer inside the =
loop
once the lock is acquired here?

> +	for (chunk =3D 0; chunk < llbitmap->chunks; chunk++) {
> +		enum llbitmap_state state =3D llbitmap_read(llbitmap, chunk);
> +
> +		if (state =3D=3D BitNeedSync || state =3D=3D BitSyncing) {

[Severity: Medium]
Does this condition miss the unwritten sync states?

If BitNeedSyncUnwritten or BitSyncingUnwritten are omitted here, could resh=
ape
be allowed to start during proactive parity synchronization on unwritten
regions, potentially leading to data corruption?

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

> @@ -2011,6 +2034,7 @@ static struct bitmap_operations llbitmap_ops =3D {
>  	.dirty_bits		=3D llbitmap_dirty_bits,
>  	.prepare_range		=3D llbitmap_prepare_range,
>  	.reshape_finish		=3D llbitmap_reshape_finish,
> +	.reshape_can_start	=3D llbitmap_reshape_can_start,

[Severity: High]
Is the reshape_can_start callback invoked anywhere in the core MD subsystem?

It doesn't appear that any callers for reshape_can_start are added in this
patch or exist in the current subsystem code. Without a caller, is this
reshape rejection logic effectively dead code?

>  	.write_all		=3D llbitmap_write_all,
> =20
>  	.groups			=3D md_llbitmap_groups,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D10
