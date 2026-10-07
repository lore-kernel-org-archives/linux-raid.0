Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53C039B949
	for <linux-raid@vger.kernel.org>; Wed,  7 Oct 2026 12:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374489; cv=none; b=WvFZjWI5cSctUs0u1bwTV0y6RKz9NUvdGHVvJ3mNHktro1ckNDqlMsTAprRNa9O+Yv60cAKyggZCBHq+4SUGzLdss6dfWVWyXmlrWP0q8PicymWXlNfGts0Cubf7hIBTM2rhqGq2tawdGIyh3HEFnoNaZ0feJsUVNDD08vmZMhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374489; c=relaxed/simple;
	bh=9ZgBM2cn58Mxpo103356ZaaNoUUQVqvfRgtbfKRuqJ8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=O5EqoGpU7v5PYRy6DCEUqeGCS2iM6efKnoLX7jAbjViWyAuKQCu2+HrsWP1cykYCRbOWQ2wWrazm366s32B/JTG/CQNS1dcwbPeAZGC5JQLtzc6dgKoU668bM+ztL/ZPs+VBz/XEyXUM4I9cwSwYQwl0DmBp4J+uTaWLtio7eXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwxHMRk7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwxHMRk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AC31F0089B;
	Wed,  7 Oct 2026 12:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791374480;
	bh=b8sb0X0gIKNrmIYsH4yzysJsBPCsDy4T4RXUIHLHzJA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jwxHMRk73cfZb2b9Jy0I9Bap9LTi3beX/gZjIuFOGhu0RWfTnRG3F9MaWCrbYo4NL
	 /HvOLXnWhWfJy3fQ0DmF7SGTV2YyPl7BAhIGO9gl0f994tFj4MBXuMVEpjsnwgZb8c
	 V5pq0nu4a+3PO7uct2ZjiqAgwzAzXFmZ2ZBKIDIAOjNPL0FfFMxPtBUU4J5ct1Btpl
	 b/aWpMiXKmVZFTF8vLCLxrI55BpnhwPKlmvpD7H5nt2xxbjGW6SH+SYuYz2/lz+uGz
	 znGxzFx0d2kRKyIYO0gGdhUxJ/TgOT9QhzfqrUb2gdOQXE5yC00AVKt40WdS7Fi3GU
	 1PV9BhP0dHGrw==
Message-ID: <sashiko-outbox-162963@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 3/4] md: use struct mdu_array_info64 for
 SET_ARRAY_INFO
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWFzYWxraGksIEFiZCBBbHJobWFu?= <abd.masalkhi@gatech.edu>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261007115104.13884-4-abd.masalkhi@gatech.edu>
References: <20261007115104.13884-1-abd.masalkhi@gatech.edu>
 <20261007115104.13884-4-abd.masalkhi@gatech.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 12:01:19 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] md: format string mismatch for major_version in pr_warn
--

commit 4b1b8271e62fda3b747c4ac07bffdb6f7582ebcf
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>

md: use struct mdu_array_info64 for SET_ARRAY_INFO

The md control device passes array information as struct mdu_array_info64.
Make md_set_array_info() and update_array_info() take the new struct
mdu_array_info64, so that the md control device and the old SET_ARRAY_INFO
ioctl can share them. md_set_array_info() no longer checks for a negative
major_version since the field is unsigned now.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index be1634ae1d09c..63b9468285b09 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7904,12 +7904,11 @@ static int set_bitmap_file(struct mddev *mddev, i=
nt fd)
>   *  The minor and patch _version numbers are also kept incase the
>   *  super_block handler wishes to interpret them.
>   */
> -int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
> +int md_set_array_info(struct mddev *mddev, struct mdu_array_info64 *info)
>  {
>  	if (info->raid_disks =3D=3D 0) {
>  		/* just setting version number for superblock loading */
> -		if (info->major_version < 0 ||
> -		    info->major_version >=3D ARRAY_SIZE(super_types) ||
> +		if (info->major_version >=3D ARRAY_SIZE(super_types) ||
>  		    super_types[info->major_version].name =3D=3D NULL) {
>  			/* maybe try to auto-load a module? */
>  			pr_warn("md: superblock version %d not known\n",
>  				info->major_version);

[Severity: Low]
Is there a format string mismatch here?

Since info->major_version is now an unsigned __u32 type, should the format
specifier in this warning be updated from %d to %u? A large unsigned value
provided by userspace could incorrectly print as a negative number.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007115104.1388=
4-1-abd.masalkhi@gatech.edu?part=3D3
