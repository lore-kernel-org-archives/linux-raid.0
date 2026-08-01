Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56623009D6
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607198; cv=none; b=EQ9AxjRzc1h1/dIeZa4gwJf9ZtdX0o59iHkBN7OvGfIRJpQLp1toHNHh+5Ot2IFSFnXvAEu5lfpkM0GfHpxexbhHtDZriflalVTLtedNR5SXYQph2ObZ2WlTDoXcqN/JW1SRAKvvV8liZ23w067jh6jBNN4SYhhEfJSmDl4edAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607198; c=relaxed/simple;
	bh=w65ezLNJES0eKHw01uJUF+EF+CBAYzwLncZ5m05zdNw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LczR4Eb6Diig80a5U12eS2vZrs44QGroYc7Y+W9J3msfKhbY2Ok2CWcxuMA3s7R1Q48V87gH8dz8uRJnBT3Oo9dCTD4L2yd4nZvEXs0aqh3cXRwGWeIkeLW4Ef+0c6XxSZ14Ia4DyE1dUI38RaepQ3cZBCnCHbQFdllGZe7VWSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WM86AE6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WM86AE6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354321F00ACA;
	Sat,  1 Aug 2026 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785607197;
	bh=FocEs9Gj3ojCqc0cu+Hs2JH2sk5PPlHtw/rAhHD9f7g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WM86AE6gtVOhwWWLA4c5zhIEa9R96JL0Kp0d7HtNWHSdcer5t3G1Mo4bAfU/W+i9K
	 DikjdmMpTAxeoOHFi73APj6mdmuMsqQiFej+sk/z3xCGKwvSKlt5QwypmgJ1B8MLlY
	 1Ry1rlprmck55kFozV1nxH6ukNdkq4oc7ORQbEf1iASYWMFAgnOGyVtaVOu7itsjNt
	 aIcBvt5ICWPsIDJqXUyv0m3qLtEdbb5ChDBsQ7i+DKhQ1eXKNERwU+AhoW/yq2abSh
	 QwJiJB6v0uhm6jh/cNvUjHiyk2l9lqASx5EOxlvgPGYFEdyTebGeAib1vUdxfxTG1j
	 KOKXoDl3tpqbg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 21/25] md/raid10: split reshape bios before bitmap
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-22-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-22-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:59:56 +0000
Message-Id: <20260801175957.354321F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Nested double allocation from the same `conf->bio_split` mempool c=
an cause a self-deadlock when a bio crosses a chunk or reshape boundary and=
 encounters a bad block.
- [Low] Passing 'int *' to 'unsigned int *' triggers a compiler error with =
-Werror=3Dincompatible-pointer-types.
--

--- Patch [21]: [PATCH v4 21/25] md/raid10: split reshape bios before bitma=
p accounting ---
commit ac17607a8057c3c9040bf0443e50aa65062e0d48
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: split reshape bios before bitmap accounting

This commit updates raid10 to submit only one-side bios to llbitmap
during reshape. It accomplishes this by using the shared helper
mddev_bio_split_at_reshape_offset() to split bios at reshape boundaries.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e50e4adee389f..61900ace190fd 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1886,6 +1886,7 @@ static bool raid10_make_request(struct mddev *mddev=
, struct bio *bio)
>  {
>  	struct r10conf *conf =3D mddev->private;
>  	sector_t chunk_mask =3D (conf->geo.chunk_mask & conf->prev.chunk_mask);
> +	const int rw =3D bio_data_dir(bio);
>  	int chunk_sects =3D chunk_mask + 1;
>  	int sectors =3D bio_sectors(bio);
> =20
[ ... ]
> @@ -1911,6 +1912,15 @@ static bool raid10_make_request(struct mddev *mdde=
v, struct bio *bio)
>  		sectors =3D chunk_sects -
>  			(bio->bi_iter.bi_sector &
>  			 (chunk_sects - 1));
> +
> +	bio =3D mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
> +						&conf->bio_split);

[Severity: Low]
Will this cause a build failure with -Werror=3Dincompatible-pointer-types?

The sectors variable is declared as an int, but
mddev_bio_split_at_reshape_offset() expects an unsigned int pointer for
its third argument.

[Severity: High]
Could this introduce a mempool self-deadlock when encountering a bad block?

If the bio crosses a chunk or reshape boundary, it allocates a split bio fr=
om
conf->bio_split here. This newly allocated bio is then passed down the stac=
k:

raid10_make_request() -> __make_request() -> raid10_write_request()

If a partial bad block is encountered in raid10_write_request():

drivers/md/raid10.c:raid10_write_request() {
    ...
    if (r10_bio->sectors < bio_sectors(bio)) {
        ...
        bio =3D bio_submit_split_bioset(bio, r10_bio->sectors, &conf->bio_s=
plit);
    ...
}

It attempts to split the bio a second time using the exact same
conf->bio_split mempool. Because the original bio is already holding an
element from conf->bio_split, nested allocations from the same pool by
concurrent threads can exhaust it and cause the I/O threads to hang.

> +	if (!bio) {
> +		if (rw =3D=3D WRITE)
> +			md_write_end(mddev);
> +		return true;
> +	}
> +
>  	if (!__make_request(mddev, bio, sectors))
>  		md_write_end(mddev);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D21
