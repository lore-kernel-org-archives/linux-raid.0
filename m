Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794960717;
	b=zh8d5dQCk6yoYb5Wsu7jqTz0R7fo0hnFO3tKweT8Gs3dCO7sF3v/KOCpHKFXecyRlgh1
	 ncZUAp9eJzuubN+HoyySzoaVlYgemM5GOSnXaZ7+4b73yGLCfaF/Gh8aV11G0/qj+DWmN
	 W9kSBZ7Gj2nUXVXFXhg8fToQZcY1ERpaPfYyAOr0IpdS4pSUJb3mGb4CpKfGey4kqsety
	 fK4TY/5Qr6rjqkLFzFJtwgvbbnV00qwpmEdJwFJ+OqD/MIfqFML7Komn30oqe1Nplncvd
	 7qYg/epgq0jrwDeMymtAYUWi1MFZUT+PwtR9knztFv8XyIcceErhT8XM0ftd3Sq316g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794960717;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O0FrYWYdiQUG6F0LW4fyAz5kz7yJr8i5H27a/sDnJsY=;
	b=GCbgX+izMXYQzu+qZZjb8SkseQiF+2PzVUgPv3Yaxw08AyqXshfG2SYWORFrxuIm66r/
	 N0kCDUJkoaYrOXZ9GVAZrcsVE9Xh8VJqF1O0DyI8Vc6VWHSCHRLUpvDYWq/tABYOH4zDK
	 Y2DgM4K87ZaICi8bp3UG5ufacaDNcwUDIUb498vY6uvEl5WGdISOXQs9HteSijxjy8mfp
	 7WLdaSc41AknrJ6kN3quarhJqNf5Q3xDHCjD6/ZBaqOkGlHx4/OcTluor7ad/Hvzoe+0q
	 AgXVRGOzMxT4j2zE8kAnbRlvjY0Xe+nJEWRMuhuQe/0gP7xWsUICFVo6pdcnJu9NaCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f4xQ6+5L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597D8606A333
	for <linux-raid@vger.kernel.org>; Wed, 18 Nov 2026 00:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f4xQ6+5L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A295A1F000C5;
	Wed, 18 Nov 2026 00:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794960716;
	bh=O0FrYWYdiQUG6F0LW4fyAz5kz7yJr8i5H27a/sDnJsY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f4xQ6+5LuugT0VJsSGAT+zdgNTzIDwiVUmRpAprqIY/ti4XYiete7q5RROKtW2gPF
	 IwvnCvPEcBi8XN8hYHO0RKHItnWsuWtDXFtFOYYWbFfNLeluxwb23UB1kPwAuX0S6v
	 gZJIMHiYmtxbWcBU8LTNVEIA6383wHfQ+FyxD/9yooHe81HBUBnQRGnV/sjKvvMjWT
	 Kba1OcdUNWeVt8+iDlA59V+n0ZV75pwHA0wpuAJVjF49xhArvuxoeWjeiwu17Zqrfq
	 KkrjncuLSl3En6mEW7cLqFCbEpew9ydAtMxsN/LLQbOiH9nmX1eVjh4S6qVQ3ie1nO
	 z8n/mrMlWSLrQ==
Message-ID: <sashiko-outbox-219833@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid1: reject oversized raid_disks values
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aibing Chen" <chenaibing@cmss.chinamobile.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261117235714.1101-1-chenaibing@cmss.chinamobile.com>
References: <20261117235714.1101-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 00:11:56 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] md/raid1: raid1_run() upper bound fails to bound
  conf->mirrors on 64K pages
- [Medium] md/raid1: missing raid_disks upper-bound check in
  raid1_reshape()
--

commit 377f5560edb8ce6de0f74acd8535bb4eba6e1103
Author: Aibing Chen <chenaibing@cmss.chinamobile.com>

md/raid1: reject oversized raid_disks values

This commit rejects negative, zero, or oversized mddev->raid_disks values in
raid1_run() before allocating the RAID1 configuration structures and resync
buffer pool.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 894efb50c6d58..875c985526928 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3169,6 +3169,18 @@ static int raid1_run(struct mddev *mddev)
>  		return -EIO;
>  	}
> =20
> +	/*
> +	 * The resync and r1bio pools are sized from raid_disks * 2.  A
> +	 * raid_disks value large enough to make those allocations exceed
> +	 * KMALLOC_MAX_SIZE would only trigger a kmalloc WARN_ON() when the
> +	 * resync starts, see r1buf_pool_alloc(), and the resync would not
> +	 * run at all.  Reject such a value before anything is allocated.
> +	 */
> +	if (mddev->raid_disks <=3D 0 ||
> +	    mddev->raid_disks > KMALLOC_MAX_SIZE /
> +				(2 * sizeof(struct resync_pages)))
> +		return -EINVAL;

[Severity: Medium]
Can conf->mirrors in setup_conf() still exceed KMALLOC_MAX_SIZE on 64 KiB p=
age
kernels?

When PAGE_SIZE is 64 KiB, RESYNC_PAGES is 1, so sizeof(struct resync_pages)=
 is
16 bytes while sizeof(struct raid1_info) is 32 bytes.  A raid_disks value in
(KMALLOC_MAX_SIZE / 64, KMALLOC_MAX_SIZE / 32] passes this check and then
triggers the WARN_ON_ONCE_GFP() in setup_conf() when allocating conf->mirro=
rs:

drivers/md/raid1.c:setup_conf() {
	...
	conf->mirrors =3D kzalloc(array3_size(sizeof(struct raid1_info),
					    mddev->raid_disks, 2),
				GFP_KERNEL);
	...
}

Dividing by 2 * max(sizeof(struct resync_pages), sizeof(struct raid1_info))
would cover both allocations across all page sizes.

[Severity: Medium]
Does raid1_reshape() also need this upper-bound check on raid_disks?

On a running non-persistent or external-metadata RAID1 array where
mddev->max_disks is 0, updating raid_disks via the SET_ARRAY_INFO ioctl or
sysfs raid_disks calls update_raid_disks() -> raid1_reshape() without
re-running raid1_run():

drivers/md/raid1.c:raid1_reshape() {
	...
	raid_disks =3D mddev->raid_disks + mddev->delta_disks;
	...
	new_r1bio_size =3D offsetof(struct r1bio, bios[raid_disks * 2]);
	newpool =3D mempool_create_kmalloc_pool(NR_RAID_BIOS, new_r1bio_size);
	if (!newpool) {
		return -ENOMEM;
	}
	newmirrors =3D kzalloc(array3_size(sizeof(struct raid1_info),
					 raid_disks, 2),
			     GFP_KERNEL);
	...
}

Depending on the new raid_disks value, this either updates conf->raid_disks
and hits the same WARN_ON_ONCE_GFP() in r1buf_pool_alloc() when recovery
starts, triggers the kmalloc warning directly in raid1_reshape(), or overfl=
ows
raid_disks * 2 when computing new_r1bio_size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117235714.1101=
-1-chenaibing@cmss.chinamobile.com?part=3D1
