Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794663372;
	b=yPI2tFSdHRbDTBPtw0QZ2O0MDiA1L+1+4c5VOMXd0ArzUg1GdVk7rSzRkTc0AyRj0gWc
	 8rIfQAdDi75DJx7kn4yEZoshDKjNQWCtzfM7t3ye2XlvF+KKZ3WeOn1e4O0uX2OR6MnHX
	 NoE3xmQ3EcFIHuclRIUY3dPwfObiuj7UPvzCq2kC0PYxdjFP8NU5F3wLw15SzX+N5u7WK
	 1ln3MgaL69tZCj4gxiih14RouMOtKniVWFG5MTGhuZpUzkonkVdDwYZRyktsTs/oTIvqv
	 6ooYbmRBEcz34f9HBwXsiv4b6rQ7+OpsQ7VCfzUiBFPhrSstQsaccHW65/gQG+qXWGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794663372;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=T25sSm4cDUEtkdKpz4QPQZD/yQ4B81NLxfMVX96nBxk=;
	b=gC75vjgrtbvBuibaKqY0+ry0y0whdTu2FbFLWH6+0ukgAk5AnSuKl2la4ZSmjsUxkGFb
	 SbkmFr2fRLHiyrMlhN5T19ZsHn7R9wlHFvIU8zGcFNpCW1fFRzr647s3SGgb64RfP39i/
	 WGHGNFTklt3/kfmjyDatOBIjNt+ABWOcUHaF2DifECiQkflzBsoCdFetI2Dr3GjORT5fL
	 n/xG1IsGRWRn+bs0XgdiebOa6nuIEgYrd7uDa37OSqe6raAvCpras4SW6S70p8YngQswq
	 N2wAY0dzG+yMayMbvUXAnBl0bbDwDinwehZrlKf2a87M5c8hjotnCits7gICC/kj6sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQXb3n34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36577606A332
	for <linux-raid@vger.kernel.org>; Sat, 14 Nov 2026 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQXb3n34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4D41F000C4;
	Sat, 14 Nov 2026 13:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794663371;
	bh=T25sSm4cDUEtkdKpz4QPQZD/yQ4B81NLxfMVX96nBxk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kQXb3n34CZFI2kBfEw6YM6pTykliOCAmBrXJexRj0w64fGaOet0nxzbRc5TepFc72
	 e+zEWlZZ79w0KvPpDhsJL32/sZWPF/m9NX7TsVqJzwCGnLAE/8OyqPEwBlJsfIrFLH
	 6n3SCzl4vkvD2uCZu6DI3iMKbaxUWe7IYW63+fq422bnAEcM82DTYcqA6I0DJElF4t
	 2daVmNHuJ8uZo+s5tJmpGMyBEwuqsPDPnKPRuzIB9cxVMMudAk9qtwW4Ypj9ml5uGa
	 jMq9U918/QCRrAYTNgG2+5LlSQ2xQQTL9Vjf8Ji3yDxPOg4TiwqPTSbOg+r1y7pqIL
	 0TNeg1gfjs/AA==
Message-ID: <sashiko-outbox-214578@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] md: enforce MD_SB_DISKS bounds across v0.90
 superblock paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <20261114130833.9039-1-chandradhar.2003@gmail.com>
References: <20261114130833.9039-1-chandradhar.2003@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 13:36:11 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] md: signed overflow and missing negative checks in v0.90
  metadata_store()
--

commit 6c7fdd3676be5c17e28344695572829adecbf502
Author: Chandradhar Kumar <chandradhar.2003@gmail.com>

md: enforce MD_SB_DISKS bounds across v0.90 superblock paths

This commit enforces MD_SB_DISKS bounds across v0.90 superblock load,
validation, configuration, and sync paths to prevent out-of-bounds
accesses on sb->disks[].

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..14e8f93471760 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -5056,10 +5113,16 @@ metadata_store(struct mddev *mddev, const char *b=
uf, size_t len)
>  	err =3D -ENOENT;
>  	if (major >=3D ARRAY_SIZE(super_types) || super_types[major].name =3D=
=3D NULL)
>  		goto out_unlock;
> +	err =3D -EINVAL;
> +	if (major =3D=3D 0 &&
> +	    (mddev->raid_disks > MD_SB_DISKS ||
> +	     mddev->raid_disks - mddev->delta_disks > MD_SB_DISKS))
> +		goto out_unlock;
>  	mddev->major_version =3D major;
>  	mddev->minor_version =3D minor;
>  	mddev->persistent =3D 1;
>  	mddev->external =3D 0;
> +	mddev->max_disks =3D (major =3D=3D 0) ? MD_SB_DISKS : 0;
>  	err =3D 0;
>  out_unlock:
>  	mddev_unlock(mddev);
> @@ -7941,16 +8004,32 @@ int md_set_array_info(struct mddev *mddev, struct=
 mdu_array_info_s *info)
>  				info->major_version);
>  			return -EINVAL;
>  		}
> +		if (!info->not_persistent && info->major_version =3D=3D 0 &&
> +		    (mddev->raid_disks < 0 ||
> +		     mddev->raid_disks > MD_SB_DISKS ||
> +		     mddev->raid_disks - mddev->delta_disks > MD_SB_DISKS))
> +			return -EINVAL;

[Severity: Medium]
Can mddev->raid_disks - mddev->delta_disks overflow 32-bit signed int or
accept negative disk counts in metadata_store() and md_set_array_info()?

When md_run() -> analyze_sbs() -> super_1_validate() processes a crafted
v1.x superblock before get_pers() fails and the rdev is removed,
mddev->raid_disks and mddev->delta_disks retain arbitrary 32-bit signed
values while mddev->disks is empty:

drivers/md/md.c:super_1_validate() {
	if (mddev->raid_disks =3D=3D 0) {
		...
		mddev->raid_disks =3D le32_to_cpu(sb->raid_disks);
		...
		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE)) {
			mddev->reshape_position =3D le64_to_cpu(sb->reshape_position);
			mddev->delta_disks =3D le32_to_cpu(sb->delta_disks);
}

Unlike super_90_load(), which casts to s64, evaluating mddev->raid_disks -
mddev->delta_disks in 32-bit signed int overflows when mddev->raid_disks is
in [0, MD_SB_DISKS] and mddev->delta_disks is a large negative value such
as INT_MIN, wrapping to a negative number that bypasses the > MD_SB_DISKS
check.  In addition, metadata_store() does not check mddev->raid_disks < 0,
and neither function rejects negative pre-reshape disk counts, allowing
negative mddev->raid_disks or invalid olddisks values to persist on a v0.90
array.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114130833.9039=
-1-chandradhar.2003@gmail.com?part=3D1
