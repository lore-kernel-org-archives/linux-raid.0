Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4CD3290AF
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607555; cv=none; b=fw0W2Cjf6wTYrWhuhqAq19CStWGudHnp+YfC0SlQpLS5n2blFshbq/btM63JO1C9J20+H8T9vWArEkorYLsk1RqyLTK/9cwIVAspSnXthxN6qTgk657ip41x8OJNC6VA0kiso71Q6XWHLoe3FfVWebfXZAefdBw9JvEF+6eWgk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607555; c=relaxed/simple;
	bh=ogMND8zBLqW8ICBPJosYLNeuvFW6bTvLb5UHX24yeSc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TzpUhktpkNJGWMHCE3W8ca7OKr8xpjN9EjLRRUtO2+8o2D3IkrzHT9yt1SKnYXSilloSRMOptG8MLYyu6pKP0dyqtfTd+qCEDwXaBdQwh1MDZYrQAFH0EkoROD7EhAYL7yxNt2kGsNctjXH1HoV6qQd5Q9he+7ZXOn11G7EPmUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJk+AYCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJk+AYCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3006E1F00ACA;
	Sat,  1 Aug 2026 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785607554;
	bh=0t1+kX7aoJMtLK/dnslqQITHjoJKrChAu9EhRXeHB4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lJk+AYCOgpx4ucfPIcs3wR3TYio0ZEpYXWpmIPhoHETLpx20wpkNOfSKaZZ+0JqEs
	 Hqs7lWj4Bzy8cG+X8+6V3EFfts2eXOOMhhneDNpFAffYayn/EGE96IrN5lf/B8mitW
	 pJE91/uawKwimU00zyYPKgLDXtTQLkpiZnWwjfK3gfkJN1JqJwnm9M4XqVhReCxTua
	 lCyFjt4Hc3J6OwUTTunt/w2ZkzE0f7YrrIKOeNVC8GtdWc/YXOFqKGrsJRGnF8KEpt
	 EH8JQZrwZRn+k/MFsBFUDTITJrP7YtJWZ1xiyWFzYa/tDCiTRk/FYP+vPa9lmDcR3w
	 SkwA+aurJ8AxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 22/25] md/raid5: add exact old and new llbitmap
 mapping helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260801172519.2982121-23-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-23-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 18:05:53 +0000
Message-Id: <20260801180554.3006E1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The newly introduced `raid5_bitmap_array_sectors` incorrectly calc=
ulates the previous array size when shrinking, returning the new smaller si=
ze instead of the exact old size.

Pre-existing issues:
- [Critical] Bitmap mapping logic uses the current `conf->max_degraded` to =
compute the previous layout's data disks, corrupting mapping during RAID le=
vel migration.
- [High] Integer overflow on 32-bit architectures in `raid5_bitmap_sector` =
when computing `*sectors` during reshape of large arrays.
--

--- Patch [22]: [PATCH v4 22/25] md/raid5: add exact old and new llbitmap m=
apping helpers ---
commit 2b6e9c9ff8dbd00ebcd0c4b00c57f4d4ef3e5964
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: add exact old and new llbitmap mapping helpers
   =20
Teach RAID5 to export exact old and new llbitmap mappings and the
corresponding sync and array sizes for reshape-aware bitmap users.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8b3483674398d..af7775278af6d 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5942,28 +5942,46 @@ static enum reshape_loc get_reshape_loc(struct md=
dev *mddev,
>  	return LOC_BEHIND_RESHAPE;
>  }
> =20
> -static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
> -				unsigned long *sectors)
> +static void raid5_bitmap_sector_map(struct mddev *mddev, sector_t *offse=
t,
> +				    unsigned long *sectors,
> +				    bool previous)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	sector_t start =3D *offset;
>  	sector_t end =3D start + *sectors;
> -	sector_t prev_start =3D start;
> -	sector_t prev_end =3D end;
>  	int sectors_per_chunk;
> -	enum reshape_loc loc;
>  	int dd_idx;
> =20
> -	sectors_per_chunk =3D conf->chunk_sectors *
> -		(conf->raid_disks - conf->max_degraded);
> +	if (previous)
> +		sectors_per_chunk =3D conf->prev_chunk_sectors *
> +			(conf->previous_raid_disks - conf->max_degraded);

[Severity: Critical]
This is a pre-existing issue, but I noticed we are using the current layout=
's
max_degraded value to compute the previous layout's physical sectors here.

During a RAID5 to RAID6 migration, conf->max_degraded is updated to 2
immediately at the start of the reshape. However, the old RAID5 layout only
had 1 parity disk.

If we subtract 2 instead of 1, does this corrupt the logical-to-physical ch=
unk
translation for the previous layout? It seems write operations ahead of the
reshape might dirty the wrong bits in the bitmap, potentially leading to si=
lent
data corruption or skipped resyncs after a crash.

I also noticed raid5_compute_sector() applies the current max_degraded to t=
he
previous layout's data_disks computation:

drivers/md/raid5.c:raid5_compute_sector() {
        ...
        int raid_disks =3D previous ? conf->previous_raid_disks
                                  : conf->raid_disks;
        int data_disks =3D raid_disks - conf->max_degraded;
        ...
}

Should we be tracking the previous layout's parity disk count separately?

> +	else
> +		sectors_per_chunk =3D conf->chunk_sectors *
> +			(conf->raid_disks - conf->max_degraded);
>  	sector_div(start, sectors_per_chunk);
>  	start *=3D sectors_per_chunk;

[ ... ]

> @@ -5992,7 +6001,7 @@ static void raid5_bitmap_sector(struct mddev *mddev=
, sector_t *offset,
>  	 * we set bits for both.
>  	 */
>  	*offset =3D min(start, prev_start);
> -	*sectors =3D max(end, prev_end) - *offset;
> +	*sectors =3D max(end, prev_start + prev_sectors) - *offset;

[Severity: High]
This is a pre-existing issue, but could this subtraction result in an integ=
er
overflow on 32-bit architectures?

For large arrays (e.g., >24TB), the physical sector distance between the old
and new mappings for a single logical address can exceed ULONG_MAX.

Since *sectors is a 32-bit unsigned long pointer on 32-bit architectures, it
seems this subtraction could truncate the 64-bit sector_t value. If that
happens, might the bitmap logic only mark a small lower portion of the span
as dirty due to the integer wrap-around?

>  }
> =20
>  static enum stripe_result make_stripe_request(struct mddev *mddev,

[ ... ]

> @@ -9059,6 +9068,20 @@ static void raid5_prepare_suspend(struct mddev *md=
dev)
>  	wake_up(&conf->wait_for_reshape);
>  }
> =20
> +static sector_t raid5_bitmap_sync_size(struct mddev *mddev, bool previou=
s)
> +{
> +	return mddev->dev_sectors;
> +}
> +
> +static sector_t raid5_bitmap_array_sectors(struct mddev *mddev, bool pre=
vious)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +
> +	if (previous)
> +		return raid5_size(mddev, 0, 0);

[Severity: High]
When shrinking an array, the previous array size is larger than the new arr=
ay
size.

By passing 0 for the raid_disks argument, raid5_size() calculates the size
using min(conf->raid_disks, conf->previous_raid_disks).

Will this evaluate to the new, smaller size instead of the exact previous
capacity? If reshape-aware bitmap users are tracking the tail of the array
during a backwards reshape, this might fail to export the exact original ta=
il
boundaries and lead to missed bitmap synchronizations.

> +	return raid5_size(mddev, mddev->dev_sectors, conf->raid_disks);
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D22
