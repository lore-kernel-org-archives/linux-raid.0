Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B74F407CF1
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783679317; cv=none; b=ROehjex5W1EIY59UcWmG9CCTJnu6Ck2dhSZBPY2suFPaljmfKS0AEkcTjUfNFvmjTlZr6vzDopLPKM9w/jp+3ZopqwcIflGo4WDnQoRlIXyjG03t8B2gIb2+kfEqd2UqFVtcn57vBLCf/aKxR7IMvgnZo2Fcqtde01dvXm1Ja20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783679317; c=relaxed/simple;
	bh=vxau3Z4SZmAhQvthdtDV6A9I31JpEe0jOqZBX5IXGGs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FLuys6vn8jiRz8fvmNOro9APLEfJ9CTvyxW1OwS6ED9xG4bbAs7awEGCEnSBvGpzasdR3t+jAzMKEsMROuBYxhhJWtjoUcGDCuquLeLoS3r+Vyv2MmWUmPKfS5ZfHD2i4pwRQdtFUGXpLhOPhVnf5wmqyaLjXvR8adWErcz6DbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0K4OEDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0K4OEDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07391F000E9;
	Fri, 10 Jul 2026 10:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783679316;
	bh=ZLfeAvTMa2EQGwf9ymAFvh5UA2IESYttP8hu2WKxyGE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j0K4OEDjxKF9l5FfQuF+4dDfoHwlTIMIz6mTnvbqHBQxe4TKdEn6pssoAvNerCK9r
	 bQ4RG1Upjx/uKRZODRKWMwLyV2jBU8/UCkYTOW3ZXY1RT53Oq5eqaTkBKYP4GGjUe7
	 DcN5uJkazyOI5soMw/wVoVUk/fGS+T8QLc+897l4IJ3sklmmYEVYiAMLwtb11rxaWN
	 oZLZ/AN/5HEOKQUtm9SbHlQ/fZTyAvWjJOFMPT2JWevMD8ID5hwGYcS5xMsqJllT1z
	 oS7s9O/Pv3cgAoQTdDAnc9qj1BJXLq1oBt0c0x9EywR7BsB6y4bmTU5anLsuFMRbNo
	 s9zm/DTcOI8cw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/7] md/raid10: consistently fail atomic writes that
 require splitting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260710101521.1714-4-abd.masalkhi@gmail.com>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
 <20260710101521.1714-4-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 10:28:35 +0000
Message-Id: <20260710102835.D07391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Concurrent disk removal during a failed or split write causes a NU=
LL pointer dereference in the error handling path.
--

--- Patch [3]: [PATCH v4 3/7] md/raid10: consistently fail atomic writes th=
at require splitting ---
commit a682adb077534fe2522eacd5e431dab764a60d3f
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid10: consistently fail atomic writes that require splitting

This patch addresses atomic writes in RAID10 by checking if they require
splitting. If an atomic write would be split due to badblocks or other
limits, it now correctly fails the bio with EIO rather than allowing the
implicit EINVAL from bio_submit_split_bioset().

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index bd322eccdc3ff..3480fc7907f01 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -1493,6 +1484,9 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		r10_bio->sectors =3D max_sectors;
> =20
>  	if (r10_bio->sectors < bio_sectors(bio)) {
> +		if (atomic)
> +			goto err_handle;

[Severity: High]
This is a pre-existing issue, but can this jump to the error handling path
trigger a NULL pointer dereference if a disk removal happens concurrently?

If raid10_write_request() initiates an IO and skips a Faulty primary rdev,
it uses the replacement (setting repl_bio and incrementing rrdev->nr_pendin=
g).
If md_check_recovery() concurrently calls raid10_remove_disk() for the Faul=
ty
primary, it can promote the replacement to primary and set p->replacement
to NULL.

When this atomic check fails, it jumps to the error unwinding loop which
does:

    struct md_rdev *rrdev =3D conf->mirrors[d].replacement;
    ...
    if (r10_bio->devs[k].repl_bio) {
        rdev_dec_pending(rrdev, mddev);
        r10_bio->devs[k].repl_bio =3D NULL;
    }

Since replacement is now NULL, rrdev is NULL, and rdev_dec_pending() will
dereference it.

Looking at raid10_end_write_request(), it implements a fallback to handle
concurrent promotion by falling back to conf->mirrors[d].rdev when
replacement is NULL.

Does the error unwinding loop in raid10_write_request() need a similar
fallback?

> +
>  		allow_barrier(conf);
>  		bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
>  					      &conf->bio_split);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710101521.1714=
-1-abd.masalkhi@gmail.com?part=3D3
