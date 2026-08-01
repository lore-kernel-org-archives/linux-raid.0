Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6A130CD89
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785609835; cv=none; b=hGTHVPs2XN/qnc1pBuvYIdHGuy+0gZqBJ6yCYCSDd18DKYu6jFnbFNFwbPdY5XxBeJSYzeOyihEbPDKt/T26iImPgWEpYNBwsXzWGCVZ6XVaOM6RBTazvaaM0NvdnBhyTLFBwMM+fYtPlvdByr2pTKpomsyOMymAtmqitMo9+I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785609835; c=relaxed/simple;
	bh=Vqk5N9P5rtG+cR14QSBWBELC85AQBUVfoFsXgv5t2w0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kAmD0xl3BABfCWJ0i415+HrgKP5anvaSzSN/c1YQE54XggrRbIgpIeknvaJ0KnOgciF1XlNrulQ17oewOsUwSqB/TPpAprGvmd3QVLOmKsFZP6kfqlYthAEQc+Ik685SnppYU/zpwu1Ye6sgs7I5cdjiwStNEINPL2yM/lHcPHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxRHJ1lX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxRHJ1lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66B71F00AC4;
	Sat,  1 Aug 2026 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785609834;
	bh=sdcMICgVTYxbzVnU5HViRCP9bwjvLf0u97JErpNExxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PxRHJ1lXH8i2rqO382vwugmzI/YmcYiifP1vz2p72YZKcUI72BaYIq7FKheUqZG5J
	 fg0BGayqoIB4XT7JBQBKapE+pwvivhJ9kyawLbe72vPOWeJrx7hewb+AjNmooHJhFV
	 a35d8PzlLWqNyl0zTFcbssqx6Z15hLa5xueKjI81h5wsQPxynh7Q8aaU4cNcFhBiQi
	 9EAeO6aYdnZzoG2i/8HzEVRhyKQPxAJ2Szr/KPQ96Js3wn3GRfx9LCRYQcUuK4CoT/
	 iLxm8FtxnNF4LQQhCSx3O+ShjRStxp5dywzRjhPGh3lXqpwQSrqA9vcnoqOQWgiQ2a
	 yXTChFWxmpYAg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 25/25] md/raid5: split reshape bios before bitmap
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-26-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-26-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 18:43:53 +0000
Message-Id: <20260801184353.E66B71F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Double accounting of cgroup I/O statistics and double throttling=
 for resubmitted split bios.
- [Low] The error handling path for mddev_bio_split_at_reshape_offset() ret=
urning NULL is unreachable dead code.
--

--- Patch [25]: [PATCH v4 25/25] md/raid5: split reshape bios before bitmap=
 accounting ---
commit d432335f5c2f577d3656123bc3166f0ab441619d
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: split reshape bios before bitmap accounting

RAID5 maps array sectors through different geometries before and after the
reshape position. This commit splits bios that cross the reshape boundary
before md_account_bio() so the bitmap only sees ranges belonging to one
side. The split front bio is resubmitted directly after the reshape wait.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -6184,6 +6186,18 @@ static bool raid5_make_request(struct mddev *mddev=
, struct bio * bi)
>  		return true;
>  	}
> =20
> +	front_bio =3D bi;
> +	bi =3D mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
> +					       &conf->bio_split);
> +	if (!bi) {
> +		if (rw =3D=3D WRITE)
> +			md_write_end(mddev);
> +		return true;
> +	}

[Severity: Low]
Is this error handling path reachable?

mddev_bio_split_at_reshape_offset() uses bio_submit_split_bioset() to split
the bio using the conf->bio_split bioset. Since this is a mempool-backed
allocation with GFP_NOIO that reuses the original bvecs, the allocation
cannot fail.

> +	if (bi !=3D front_bio)
> +		split =3D true;
> +	front_bio =3D bi;
> +
>  	logical_sector =3D bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SEC=
TORS(conf)-1);
>  	bi->bi_next =3D NULL;

[ ... ]

> @@ -6284,6 +6298,11 @@ static bool raid5_make_request(struct mddev *mddev=
, struct bio * bi)
>  		bio_endio(bi);
> =20
>  		wait_for_completion(&done);
> +		front_bio->bi_status =3D BLK_STS_OK;
> +		if (split) {
> +			submit_bio_noacct(front_bio);

[Severity: Medium]
Will this cause the front split bio to be accounted and throttled twice?

When mddev_bio_split_at_reshape_offset() splits the bio, the newly allocated
clone (the front bio) does not inherit the BIO_CGROUP_ACCT or
BIO_BPS_THROTTLED flags from the original bio.

When make_stripe_request() returns STRIPE_WAIT_RESHAPE, this code resubmits
the split bio through submit_bio_noacct(). Because the flags are missing,
blk_cgroup_bio_start() and blk_throtl_bio() will account and throttle this
same I/O a second time.

> +			return true;
> +		}
>  		return false;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D25
