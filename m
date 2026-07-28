Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ED241D120
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230747; cv=none; b=WHHn/ConG+F+UQk7LFnLlDcZC3oZv/aDm/gjSHeL9dn+BAY4m2Ac/+UVahdbCPQl3G1J+YxzZgVIGlu0DDnk4tUdslYQIRtM8FRTkukOXQJGpCiSp4rI5ogVLuPlgWDZpr/8A2NinJyWJPfbf8j1Q40wM6jOfPmNScblIiReP6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230747; c=relaxed/simple;
	bh=x2dsAKb/3dqMR43xKKqF8gwLEsigmuqKP3674qL3IbE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EUXRMOQr6obGxvRHtLMJ+FLhOOwtYNno4n2kSWypJqmbKg8X/mQ/rO4uiACOKh/Y0pvGi4dT4OFyI58Km/XJHdvkZiPpo/mpHbEXUyi103hW85rlul/uxwKsPc5krToUyGbwaiioYRT61e0fc8sXGp2EOZ0BwTRr+CeuIGLxcyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9mcqgyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9mcqgyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529BE1F00A3A;
	Tue, 28 Jul 2026 09:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230744;
	bh=L25rXWFIFwI59MYEvDjl5muQlFUH5RTHdXG6JkSmXXc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J9mcqgyyOrROeBAz9Z0JOh6SAZPXLGuSj/Yi0pAaPiB2KPXXUJmlIxHgzdHZK4krX
	 +Z5iHjlLu3M3TWuSuW+bV405/nLGkmzIvfzdDrmwKoJ6BxZlRPNTIQd4gd/qjIP3n0
	 2eYlz+1QhEPMY/otxlALtnpVle1tWUt60OXdXFKiioWawtLKwAuR5RMlPDtPlaJGRN
	 qJ62Ub8/HplwtK38n5PMYAKhEhSOWWCcQU9BFucT0GyZwZ/g55vIsfJfE3aLKv4AnQ
	 abqDIy2eMOec9eNbk3s9p+9wc8C3wyTsxXFmRcz2J/PYOZMqgD1JvUFikaVDr/5JBr
	 DWcqQkZthXccg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 18/21] md/raid5: add exact old and new llbitmap
 mapping helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <ff64d014a1a12e231aef460dbf72f088bf835ee3.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <ff64d014a1a12e231aef460dbf72f088bf835ee3.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:25:43 +0000
Message-Id: <20260728092544.529BE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Integer overflow in `raid5_bitmap_sector` leading to silent da=
ta corruption on 32-bit architectures during reshape.
--

--- Patch [18]: [PATCH v3 18/21] md/raid5: add exact old and new llbitmap m=
apping helpers ---
commit c431d4e1772c99b9b41c44d5e8369daa1885b7eb
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: add exact old and new llbitmap mapping helpers

This commit refactors the bitmap sector calculations in RAID5 to export
exact old and new mappings, along with sync and array sizes, to support
reshape-aware bitmap users.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 35910bc6683bf..8b28afa538e2b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -5992,7 +6001,7 @@ static void raid5_bitmap_sector(struct mddev *mddev=
, sector_t *offset,
>  	 * we set bits for both.
>  	 */
>  	*offset =3D min(start, prev_start);
> -	*sectors =3D max(end, prev_end) - *offset;
> +	*sectors =3D max(end, prev_start + prev_sectors) - *offset;

[Severity: Critical]
This is a pre-existing issue, but does this calculation overflow on 32-bit
architectures during a large array reshape?

When an IO is issued ahead of the reshape progress, raid5_bitmap_sector()
merges the old and new physical mappings into a single range. For very large
arrays, the distance between the old and new physical device offsets can
easily exceed 2TB.

Because the sectors parameter is an unsigned long pointer, which is 32-bit
on 32-bit systems, subtracting these 64-bit sector_t endpoints produces a
64-bit difference that is silently truncated when assigned to *sectors.

If a crash occurs during this reshape, wouldn't the bitmap layer record only
a truncated fraction of the required range, causing the array to fail to
resync the full region and potentially resulting in silent data corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D18
