Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599CA25B093
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785701962; cv=none; b=kHVe3UNEB94Txlr0pEsUrLTIefvv+Za8Y6jcoAffdwHT0mbszBJ0kSiWHRvsFUlQQ5VijCOytnmIUkOanPZ5PINb+N5A4KKPUpfimtQ86lxj0lwSYKsImFDYAVYjP1k+R4EMWkFiq+3vlcnI16KUnUDwlPC1UpEbyYS8EBnxpfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785701962; c=relaxed/simple;
	bh=PuEC4i/6Yu+GGDSBf9T6D7ag144UqGLFzGNe8LM1ZGk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LXFmQKcnmfwoMHah6FPcLR4BOFOMPA0BLMrFLR7ySEpAJBayTJVQaNXfrKCzD1XQm2L3um4WqZ8NGOcyV+W4NNhUkMWOWhG+l0pwE9fhiL9HFr6ILpV9sdatZrjpZ7zuYAAYFX8UjWWAikCLeyhLwIQ8vTCYKhVbRyIcvsczRD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUV3iUiw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUV3iUiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BB61F000E9;
	Sun,  2 Aug 2026 20:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785701961;
	bh=i0DWrkKAdcXUUOLi8YnUnjOpNiP15KCsXxzATva+oys=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bUV3iUiwalBuTloy9l4UlF5TR8W+fHk9ITU8G1RhQLhuES0ylHTssnUJqbcOV5vxb
	 16ZpU9cdNcxOnwPFIz5ayi5zjLqVTaLuOZuNzISDu9GkKC1eKO2rdID7otDsCX88Rp
	 XTCFoHuYQTlsYZpnpYr7giXgMhZwHQUnfIjxc9IuQt1Ua2R4nmiC2oEH2DIiibNpYx
	 wZhk825kV4C0DMsTBQVKrFlRu/o3pgSW+hFZXMCjLLdocK29lsRR6ckagdb7n/Ee6A
	 VpZbe4zCRJtWKsLHAimcruhjgpuEZ6N9Z71bSVQEoCtlA7fXe3BuaSCm1eGHWOfCHE
	 2Mhi6IJw19BLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/29] md: add helper to split bios at reshape offset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-12-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-12-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:19:20 +0000
Message-Id: <20260802201920.B9BB61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Torn read of 64-bit reshape_position on 32-bit architectures l=
eads to silent data corruption.
--

--- Patch [11]: [PATCH v5 11/29] md: add helper to split bios at reshape of=
fset ---
commit 7816e7809a77baa291a2c8013717413f881d0cdc
Author: Yu Kuai <yukuai@fygo.io>

md: add helper to split bios at reshape offset

This commit adds mddev_bio_split_at_reshape_offset() to allow md
personalities to share reshape-offset bio splitting. It snapshots
mddev->reshape_position to determine if the bio crosses the reshape
boundary and limits the front bio accordingly.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -9388,6 +9388,45 @@ void md_submit_discard_bio(struct mddev *mddev, st=
ruct md_rdev *rdev,
> +struct bio *mddev_bio_split_at_reshape_offset(struct mddev *mddev,
> +					      struct bio *bio,
> +					      unsigned int *max_sectors,
> +					      struct bio_set *bs)
> +{
> +	sector_t boundary;
> +	sector_t start;
> +	sector_t end;
> +	unsigned int split_sectors;
> +
> +	split_sectors =3D bio_sectors(bio);
> +	if (max_sectors && *max_sectors && *max_sectors < split_sectors)
> +		split_sectors =3D *max_sectors;
> +
> +	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> +		goto split;
> +
> +	boundary =3D READ_ONCE(mddev->reshape_position);

[Severity: Critical]
Is it safe to use READ_ONCE() on a 64-bit value here?

On 32-bit architectures, sector_t is 64-bit, so READ_ONCE() will generate t=
wo
non-atomic 32-bit memory load instructions. If the reshape thread updates
mddev->reshape_position concurrently, this could result in a torn read.

A torn read would make boundary completely incorrect, causing split_sectors
to be miscalculated. Because the reshape boundary separates two different
physical data layouts, could sending IO based on a torn boundary write data
to the wrong physical disk locations and cause data corruption?

> +	start =3D bio->bi_iter.bi_sector;
> +	end =3D bio_end_sector(bio);
> +	if (start >=3D boundary || end <=3D boundary)
> +		goto split;
> +
> +	if (boundary - start < split_sectors)
> +		split_sectors =3D boundary - start;
> +
> +split:
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D11
