Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39BD326927
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229400; cv=none; b=fA+dsOFqNOJgQMnJr17ucR2Kdyy7Y5vYJhVZ35PSCCgyWDJmGsZvB3nAdGa5Dg0H/BqHiUt3AT95fZNrOc1eUJWfeCL6bOCHla7ei/242v9GYG0SOQejBCgB5jAhtyOYnspft4W4WS1kvIl/ZisCl4GcX2DNSRsPUwlZn4fbHuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229400; c=relaxed/simple;
	bh=88sJG0Mwj4nqU+ej+uUunTKnKa4X8IYmF71uvfv99L4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AYmHs49nBSncDR+mYXXluALS7vi69A9p+V07ySdSTYhQeOZVZ16ZYV7nKBcMZZiR5DVoEyXtgoSFHEjEjyyBcVC3A7q+XTurluCrBYxmYk0/lNuw7UdlZWDUCtpwGkRHaRWgwif3oU0KJt39PxzVT0Ps3XfzOX4pzI5fQoQqFSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V1XQCLYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1XQCLYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479861F000E9;
	Tue, 28 Jul 2026 09:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229399;
	bh=DM2PRVx+zpuZwP0HzKZVtXt12GlQB65JqFLWhMmYBjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V1XQCLYDw5wKZbJViSLBwVyyoX2vW10TORzxVoY24jM+MGicFDHYkERAocKWUOOpI
	 Bo4q4hEWJMD76CHQ3TuWybhIkHR6gC3RnmxDPcPovPgaoM5mtOJB2yiVMd4L2V1ecl
	 m/otS24BMBR+lI1Roj994J4LXIlG6SSWVM7Or7PaHjiUigL05VcE/kKpYUgm8vNkIX
	 jaEJi6JypcLij0LVlqPNDW0vs4paHTJ/S7YC46A7iNkRslqxJzyrhZVz5MVCCwJCm9
	 wfsv79GNnvuynWOzWyp/Zr4+5jucdHCWuvkNOLZOBFgmqBx8h1xMnSfChiuom368Lq
	 8CuqFyK+GTpjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/21] md: add helper to split bios at reshape offset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <94dbcd6afed02f9838d2b9aabea69d041e83aa8b.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <94dbcd6afed02f9838d2b9aabea69d041e83aa8b.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:03:18 +0000
Message-Id: <20260728090319.479861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Lockless read of the 64-bit `mddev->reshape_position` and missing =
memory barriers after `MD_RECOVERY_RESHAPE` cause torn reads and inconsiste=
nt state observation.
--

--- Patch [4]: [PATCH v3 04/21] md: add helper to split bios at reshape off=
set ---
commit df6c72a7c4a6271ac6b7e8dc1420ce49f5ef19d3
Author: Yu Kuai <yukuai@fygo.io>

md: add helper to split bios at reshape offset

This commit adds mddev_bio_split_at_reshape_offset() so personalities can
share reshape-offset bio splitting instead of open-coding the same helper
in multiple places.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0b59c676f7c03..c18a7f3c27e65 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9361,6 +9361,45 @@ void md_submit_discard_bio(struct mddev *mddev, st=
ruct md_rdev *rdev,
>  }
>  EXPORT_SYMBOL_GPL(md_submit_discard_bio);
> =20
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
> +	boundary =3D mddev->reshape_position;

[Severity: High]
Can this lockless read of mddev->reshape_position lead to torn reads?

Since reshape_position is a 64-bit value, reading it concurrently with
background reshape updates from sync_thread might result in a torn read on
32-bit architectures. A torn read could produce an arbitrary split boundary,
potentially causing misaligned bio splits and IO errors.

Additionally, are memory barriers needed after testing MD_RECOVERY_RESHAPE
to ensure a consistent value is observed on weakly ordered architectures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D4
