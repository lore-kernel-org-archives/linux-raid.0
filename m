Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5B53E0233;
	Sat, 18 Jul 2026 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784393920; cv=none; b=Ylj95ZXrmsIGqJclIY7xpgnPTtGoxt4mZZj7tmdUzHKaV/s6m2tYC3XZ54ePLK69eRMS4NE5pnQyq5ogxZMCbZqv+hVAuCYiXu7pvgS3mASQTFCNVqgNP1gdr0vo8AUiw+wkI9FPyYLbn6o9GouE0I89ycTvQ8k1LOQrdlYCRGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784393920; c=relaxed/simple;
	bh=Dm50SiCA8UKllVv8M1wkrIl6Bas+4HGt2/GL5DkR91A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Uk2eRpuHatkYaApy5KR1JP6M4D4jcVf+Vrld+rrUiTp/oRJWwnm6nqxLtTM159Wkf/bt15B/ThC6CiUr5MCAOMAP1IGidD1XzIE6kUUPWTrUEvARSQKWfG8qCAKAxD+ATDAw+0lEou5e9ni9rZZw2McC1mBLM5fy7rq1HdJJy8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jc5lAKtw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jc5lAKtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC5F1F000E9;
	Sat, 18 Jul 2026 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784393918;
	bh=gDjsq/c3v22vsS/P9jqfcxZ3lEgUrv84Ne5Yq7vvFZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jc5lAKtwAP22dZ/NYGagm/Brf0TLstQMGcUi2gOAY3r/tmcMidhXzTN1oHUM6xLq8
	 mR5+PPeyqY7z0Dw0zHIhejuxTpvF2RQKUiMMmCs/AsRM78BEdaaLgBdBlUDnzhMLk2
	 0y0iBSDeeaLrfYZkuw6fhGtWtetoPnG63O1bfUTbbPlHTC4co7w6ZJf3Kh3IXy3sox
	 4ZtTLGSo9GwfK50SK/0dyn6imZ9S8nGRGNVrUyg8rIrDgQeXYBN/0MgjeKW7huV5P7
	 eRFH+EQhOnylZBLYBaCtBxr/aCBTNlZADAlpMfIm6ZJP5RHf8CBc+LmXP1wv2D38Bs
	 ybyB1hYLAZydw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/6] md/raid1: don't use write-behind for P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260718162547.448892-4-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260718162547.448892-4-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Jul 2026 16:58:37 +0000
Message-Id: <20260718165838.6BC5F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] P2PDMA bios bypass write-behind but fail to serialize against =
outstanding write-behind I/O, leading to silent data corruption on write-mo=
stly devices.
--

--- Patch [3]: [PATCH 3/6] md/raid1: don't use write-behind for P2PDMA bios=
 ---
commit bbb98e00f3bb1bd5712cfce20170706425ddb589
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1: don't use write-behind for P2PDMA bios

alloc_behind_master_bio() copies the bio's data with bio_copy_data(),
a CPU copy. P2PDMA pages are peer device (BAR) memory; generic code
must not assume CPU load/store access to them is safe or fast on
every architecture, and bouncing peer memory through the CPU defeats
the point of a peer-to-peer transfer.

Skip write-behind for P2PDMA bios: they are written directly to all
members, including write-mostly ones.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index afe2ca96ad8c2..57f64e8901024 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1575,9 +1575,12 @@ static bool raid1_write_request(struct mddev *mdde=
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
> +		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags) &&
> +		    !md_bio_is_p2pdma(bio))
>  			write_behind =3D true;
> =20

[Severity: Critical]
This is a pre-existing issue, but by excluding P2PDMA bios from
write-behind, does this expose them to silent data corruption due to
missing serialization checks?

When a normal write to a sector uses write-behind, it can be acknowledged
to the caller once fast devices complete, leaving the write-behind bio
in-flight to the write-mostly device.

If a subsequent P2PDMA write is issued to the same sector, this patch
explicitly disables write-behind for it. Because of this,
r1_bio->behind_master_bio remains NULL, and execution falls into the else
branch further down in raid1_write_request():

drivers/md/raid1.c:raid1_write_request() {
    ...
		if (r1_bio->behind_master_bio) {
			mbio =3D bio_alloc_clone(rdev->bdev,
					       r1_bio->behind_master_bio,
					       GFP_NOIO, &mddev->bio_set);
			if (test_bit(CollisionCheck, &rdev->flags))
				wait_for_serialization(rdev, r1_bio);
                ...
		} else {
			mbio =3D bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
					       &mddev->bio_set);

			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
				wait_for_serialization(rdev, r1_bio);
		}
    ...
}

Because the else branch skips the CollisionCheck test,
wait_for_serialization() is bypassed (unless MD_SERIALIZE_POLICY is globally
set). Can the block layer then reorder these concurrent requests, overwriti=
ng
the newer P2PDMA data with the older in-flight write-behind data?

>  		r1_bio->bios[i] =3D NULL;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260718162547.4488=
92-1-mykola@meshstor.io?part=3D3
