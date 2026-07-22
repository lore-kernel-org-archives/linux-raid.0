Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48E32517AF;
	Wed, 22 Jul 2026 19:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747493; cv=none; b=Zdk14zyeRJmlT8n8uEi88WMxrasadHBhXuCBe29Er+5i89n8KgMfIVSgd93XQ65PS8ARcKVDqVrW8OZS5Wc+NIcyykfoH/a9hsllBglch/qYzNqnaggWJjy61StrMYiaHpzdcLoZnYGj2FLT5BfdZdV5w/DQy+wKN8OK3NYPaBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747493; c=relaxed/simple;
	bh=5qqwQ17C9v6H5XRlfD1D3dpj8P3Sw325tm+kbz9JiI4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i2qTFsmh2YzK8i3a+DfgJDoFCRS4CGhBvoxFxHQs41G/DJGole77fMs/Kl+L0OgUdRMhU3xD3B12XC+tAtSb88YhFpkQNvNgMOv4VCR/Lw+Q6upBWeQbRtb7irl6JojEU2ubIu+XdJyZ/T/rXlh3iAHJ7a2p3GbfnZfksJPDaOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9zZu8GT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9zZu8GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C41D1F000E9;
	Wed, 22 Jul 2026 19:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747492;
	bh=t2rcaIbqQGzQfkM7Wks63XjWcsba6wGP+ylRIctO5eU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c9zZu8GTRTDp1II5j9M34QPWURCsGKipmYVDOfqk3pqX5T05QyCq7GftLTvBSlja2
	 BgxvEzormQXgzXK05vtbm+6E96uPdZ8lOtgQGwV6zor7yfwJz1xChOZwlvBKyOsI9H
	 MXR7FzY9N2HQq6eAX9GoeEcHfBHd59q3xrlR9teAIErzUdsiN/UxjBKHJSioPI+4Sq
	 36h8fTeipaL/J4VjiVdE0JahUpAlhYYqCk4ig2ggOdj4Gd57Olwoz2cZqos6g9Jg5H
	 MYU9g3Xi8sPJbbPZvuSg0ruhtR4Y5l/iUWIZXREY/oIoJMLa+HY/GQi4niGp7jk/Pl
	 jxZHsdB9n78mA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/9] md/raid1: don't use write-behind for P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260722185841.449934-5-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-5-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:11:31 +0000
Message-Id: <20260722191132.3C41D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] raid1_write_request() can block on resource allocations and serial=
ization when processing a REQ_NOWAIT bio, violating non-blocking guarantees.
--

--- Patch [4]: [PATCH v4 4/9] md/raid1: don't use write-behind for P2PDMA b=
ios ---
commit 1a1224f9f3e6ee3f02e62a2f1a4ff02688f39f0d
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1: don't use write-behind for P2PDMA bios

This commit skips write-behind for P2PDMA bios as they are written directly
to all members, including write-mostly ones. A CPU copy via bio_copy_data()
defeats the point of a peer-to-peer transfer.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 997f79c05db7b..7d769b6460ca7 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1523,6 +1523,7 @@ static bool raid1_write_request(struct mddev *mddev=
, struct bio *bio,
>  	bool write_behind =3D false;
>  	bool nowait =3D bio->bi_opf & REQ_NOWAIT;
>  	bool is_discard =3D op_is_discard(bio->bi_opf);
> +	bool is_p2pdma =3D md_bio_is_p2pdma(bio);
>  	sector_t sector =3D bio->bi_iter.bi_sector;
> =20
>  	if (mddev_is_clustered(mddev) &&
[ ... ]
> @@ -1575,9 +1576,12 @@ static bool raid1_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		/*
>  		 * The write-behind io is only attempted on drives marked as
>  		 * write-mostly, which means we could allocate write behind
> -		 * bio later.
> +		 * bio later. P2PDMA bios are excluded: write-behind copies
> +		 * the data with bio_copy_data(), a CPU copy that cannot be
> +		 * assumed safe or fast on P2PDMA (device BAR) pages.
>  		 */
> -		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags))
> +		if (!is_discard && !is_p2pdma && rdev &&
> +		    test_bit(WriteMostly, &rdev->flags))
>  			write_behind =3D true;
> =20
>  		r1_bio->bios[i] =3D NULL;

[Severity: High]
This is a pre-existing issue, but does raid1_write_request() properly suppo=
rt
REQ_NOWAIT semantics without blocking?

Earlier in raid1_write_request(), we allocate r1_bio unconditionally using
GFP_NOIO, which can sleep under memory pressure:

    r1_bio =3D alloc_r1bio(mddev, bio);

alloc_r1bio() {
    ...
    r1_bio =3D mempool_alloc(conf->r1bio_pool, GFP_NOIO);
    ...
}

Later down in raid1_write_request(), if CollisionCheck is set, we can
unconditionally put the thread to sleep, ignoring the REQ_NOWAIT context:

    if (test_bit(CollisionCheck, &rdev->flags))
        wait_for_serialization(rdev, r1_bio);

wait_for_serialization() {
    ...
    si =3D mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
    ...
    wait_for_completion(&si->ready);
}

Could a REQ_NOWAIT write bio submitted to an md raid1 array block under
memory pressure or in-flight I/O overlapping, causing thread starvation in
io_uring workers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D4
