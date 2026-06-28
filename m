Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70323AE197
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782657494; cv=none; b=DQTFv+strh/BHUVSywLgixGspAt/GAsJzmxiQwXqnpmbM02WzFC84tkLv7f5cp3bDrydf2TaTxFMp70zLV071DhOZ+XZ6hqcpf/ifif05TlGR/q6AyfiELaw+fwIRp0KlrVsGz575P22HUBYZ1XMYkz1lKT9HmoKaovKKIt/mmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782657494; c=relaxed/simple;
	bh=3LLGDjI04mFGxcOZtdJ506EnlmigdYtin2A5c8NrH6g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fdZBy61r/Lg6rLKYEKoB3QKlnTG996fEkyVOBaEnhjzGE6LHdejdrDxy4CK0Os0HmeKqPBpA49ABbbJDcybVuDhzjgMdnYo1/9dQMbkygqZA6F4QxL3tt/sbN/1XaoVprsIrdyWo35/RTiR5Qqkshc/PizK7ZrgRAM1KXrPuPSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEAJ7ESg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEAJ7ESg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C801F00A3D;
	Sun, 28 Jun 2026 14:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782657492;
	bh=0byPDz6+dVwX8sB6g3ZqvtzNIYVukyBsIyRSA+F3R8E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fEAJ7ESg+fEr6BX8XRLOk/inN+y4IAlTzyg5mZF+oT5We0yFVqHcL7zAx4WWQz+R/
	 j49XXAhCzYsj/4fIeS902CgYoQYN1UXvcg0UdB8RdM98Q7llQsHvOS/y4AsubF0Nuh
	 npM8/U3rKoIcT81N3rP3P69hpDVwC6LRI32ZxFIJbOQ8bZ7g6MfpgmYu73gmmh9aAS
	 3bnLynIfztGzcjioLy/OfzhL9DoFiA8Ur0YKPQZ8cE6CMLoqXFnDdWOqp3LPQv4qxG
	 FxQVbIaE76/BCmtyIEn9wtVdsB3QzlWsJE2Xg/OifVlDAnQz2Znc8Lt86so5GfGToy
	 sBzjOuG+abs3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/7] md/raid1: advertise atomic write limits and
 handle runtime constraints
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260628142420.1051027-3-abd.masalkhi@gmail.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-3-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 28 Jun 2026 14:38:11 +0000
Message-Id: <20260628143812.30C801F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Atomic write limits are improperly configured and completely overw=
ritten during limit stacking.
--

commit c2837eff05b0ac2b80653d924f40f1bef7bad6d3
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid1: advertise atomic write limits and handle runtime constraints

Atomic writes in RAID1 must fit within a single barrier unit. Advertise
this restriction through the queue limits by setting
atomic_write_hw_unit_max to BARRIER_UNIT_SECTOR_SIZE so that bios which
would cross a barrier-unit boundary are rejected by the block layer
before reaching MD.

A bio that passes block-layer validation may still become unserviceable
within RAID1 due to bad blocks or write-behind constraints. In the former
case, complete the bio with EIO. In the latter case, disable
write-behind rather than failing the bio with EIO.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1633,10 +1620,24 @@ static bool raid1_write_request(struct mddev *mdd=
ev, struct bio *bio,
[ ... ]
>  	if (max_sectors < bio_sectors(bio)) {
> +		if (atomic) {
> +			bio_io_error(bio);
> +			goto err_dec_pending;
> +		}
> +

[Severity: High]
Will this result in atomic writes dynamically failing with unexpected I/O
errors instead of being properly rejected early by the block layer?

Because the limits configured in raid1_set_limits() appear to get overwritt=
en
during stacking, boundary-crossing bios will bypass block layer validation =
and
trigger an error dynamically here.

>  		bio =3D bio_submit_split_bioset(bio, max_sectors,
>  					      &conf->bio_split);
[ ... ]
> @@ -3229,6 +3230,7 @@ static int raid1_set_limits(struct mddev *mddev)
>  	lim.max_write_zeroes_sectors =3D 0;
>  	lim.max_hw_wzeroes_unmap_sectors =3D 0;
>  	lim.logical_block_size =3D mddev->logical_block_size;
> +	lim.atomic_write_hw_unit_max =3D BARRIER_UNIT_SECTOR_SIZE;
> +	lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
> +	lim.features |=3D BLK_FEAT_PCI_P2PDMA;
>  	err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);

[Severity: High]
Is BARRIER_UNIT_SECTOR_SIZE being assigned in sectors while the
atomic_write_hw_unit_max limit expects bytes? If so, this might artificially
cap atomic writes to mismatched units.

Additionally, will these custom RAID1 atomic limits be completely overwritt=
en
when stacking?

Because atomic_write_hw_max is left unmodified from its default of UINT_MAX,
when mddev_stack_rdev_limits() is called:

mddev_stack_rdev_limits() ->
   queue_limits_stack_bdev() ->
      blk_stack_atomic_writes_limits() ->
         blk_stack_atomic_writes_head()

The stacking code will see UINT_MAX and unconditionally overwrite the newly
configured RAID1 limit with the first underlying device's limits.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260628142420.1051=
027-1-abd.masalkhi@gmail.com?part=3D2
