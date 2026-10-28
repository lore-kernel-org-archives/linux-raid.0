Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202000;
	b=zociBF2YzbdfjnaGtVQuGcI49jLY9Px/Hgxk8anMCv1fO5T547aC6GzbjwxOdDrvHF6f
	 8488lbp7m9OAmMcM5/gR7E4LNBlR4NNCcgMclXYXnpm4/A6iY4sahu57Dq6E58MaFX3ma
	 kGWk73eJKGIbGayDEx2wVDZMRR9LyiTFmkMWjDIBwJqow1I8ylgA47Z8sEkhu03qJhlLm
	 hY4IhrjHZGvB4tudwpYttqRiCnCJTlRQqtQKQ79+43gcjrJ/sOGv2iCYtr4KyZ572nF9x
	 L3csseXbbKUl6ueQyYL4kJOoxLeF1XSQuJnFKZiQNvsC5Uto7Dpti0bOM1c9KuiVQqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202000;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YSure+dzzWVVvzEyesFZyUken20tC742HKQPjHWC3CM=;
	b=k2ojB1vVMDvy66H/6fzX6fhUhvDTrTBeSVCeJwGfFF8hUhovf4HO5257tZqYR4D0rhDL
	 qEGjS+or6KE5AYZvW+i07xm28wOEyzfGBPtMvdIoo/wOgP/1JAePUppq7IKB86XlLIHKW
	 w8BbzGtD17zIcldxIQAwuwYc7IKWcIiq4HY0TOEFR8M56CiHkoGJOlPGya5Xdqq74iFL+
	 x0fVM8z+gt7BpXI3IsyfeB6FjVpQhl/pYwFf1kg11Ncyfg7/H8DAOjJOZP6LqUrResC/p
	 VscJsdy7xAQhxZ35Zh1T55+MqhKGmqjQtNSYmt2UeDEDEDIpLxyH4c3HpdXIQTJZCfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=juR+7qwT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F829606A31C
	for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2026 15:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=juR+7qwT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82441F01825;
	Wed, 28 Oct 2026 15:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202000;
	bh=YSure+dzzWVVvzEyesFZyUken20tC742HKQPjHWC3CM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=juR+7qwTn2LiJjnaVNpFl/qKjeagiwsPJnHpXDYR74YG7EFONZdAPxYCUMTLyZPCW
	 QcjmJ8BAVw2CzUxjnjxQ4KOaa3gNVHWLNypU404L/jNC57OCuIuA+R1RngcRntKsjm
	 2Edgo5hmNBWILFHQY8cLUsAADmEKlG0/+j3IilJ3smahE7Na/majXJs5eSTim7r7DS
	 ipebuH1NkMI/XJLuk41xJpB+zN52qFS/YnMJDRmo0rBnEIovYualgr5ojxxQnfyt1B
	 TuaSX/qV+PojP7gufn9EWC2KC+A7pkteKy4HxvXpc2J2jiYi1dK8z1fnQp2SpLCAh1
	 7Uss698X0PwaA==
Message-ID: <sashiko-outbox-188067@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid1: Prevent excessively large memory allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gowtham S Bhushan" <gowtham398gs@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261028152755.383821-1-gowtham398gs@gmail.com>
References: <20261028152755.383821-1-gowtham398gs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:39:59 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] md/raid1: incorrect allocation size calculation in setup_conf()
--

commit c8cc718382c763b1d6426dcf4d4968c6557c8e89
Author: Gowtham S Bhushan <gowtham398gs@gmail.com>

md/raid1: Prevent excessively large memory allocations

This commit adds a bounds check on mddev->raid_disks in setup_conf() to
prevent integer overflow and allocations exceeding KMALLOC_MAX_SIZE.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 894efb50c6d58..8ed871792bf48 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3020,6 +3020,16 @@ static struct r1conf *setup_conf(struct mddev *mdd=
ev)
>  	struct md_rdev *rdev;
>  	size_t r1bio_size;
>  	int err =3D -ENOMEM;
> +	size_t calculated_size;
> +
> +	/* prevent baseline integer wrap-around anomalies first*/
> +	/* Safely calculate size; overflows automatically saturate to SIZE_MAX =
*/
> +
> +	calculated_size =3D size_add(sizeof(struct r1conf),
> +				   size_mul(mddev->raid_disks, sizeof(struct r1bio)));
> +
> +	if (mddev->raid_disks <=3D 0 || calculated_size >=3D KMALLOC_MAX_SIZE)
> +		return ERR_PTR(-EINVAL);

[Severity: Medium]
Does calculated_size match the actual allocations in drivers/md/raid1.c that
scale with mddev->raid_disks?

struct r1conf is a fixed-size structure with no flexible array member, and
struct r1bio is not allocated as an array of mddev->raid_disks elements. The
per-disk allocations are:

drivers/md/raid1.c:setup_conf() {
	...
	conf->mirrors =3D kzalloc(array3_size(sizeof(struct raid1_info),
					    mddev->raid_disks, 2),
				GFP_KERNEL);
	...
	r1bio_size =3D offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
	conf->r1bio_pool =3D mempool_create_kmalloc_pool(NR_RAID_BIOS, r1bio_size);
	...
}

and during resync initialization via raid1_sync_request() -> init_resync() =
->
mempool_init() -> r1buf_pool_alloc():

drivers/md/raid1.c:r1buf_pool_alloc() {
	...
	rps =3D kmalloc_objs(struct resync_pages, conf->raid_disks * 2, gfp_flags);
	...
}

Because calculated_size only checks mddev->raid_disks * sizeof(struct r1bio=
),
several allocations can still exceed KMALLOC_MAX_SIZE and trigger the
WARN_ON_ONCE_GFP(size > KMALLOC_MAX_SIZE, flags) warning in mm/slub.c:

1. On 64-bit systems with 4KB pages, sizeof(struct r1bio) is 80 bytes while
   2 * sizeof(struct resync_pages) is 272 bytes per disk. A raid_disks value
   such as 20,000 passes setup_conf() (~1.6 MB) and then requests ~5.44 MB =
in
   r1buf_pool_alloc(), exceeding a 4 MB KMALLOC_MAX_SIZE.

2. On 32-bit systems, sizeof(struct r1bio) is 48 bytes while
   2 * sizeof(struct raid1_info) is 56 or 64 bytes per disk. A raid_disks
   value such as 70,000 or 80,000 passes calculated_size < KMALLOC_MAX_SIZE
   and then exceeds a 4 MB KMALLOC_MAX_SIZE when allocating conf->mirrors in
   setup_conf().

Also, since mddev->raid_disks is a signed int, calling
size_mul(mddev->raid_disks, ...) before checking mddev->raid_disks <=3D 0
implicitly converts negative values to a large size_t first.

Could mddev->raid_disks <=3D 0 be checked first, and the upper bound be
validated against the actual allocation sizes (or a reasonable maximum devi=
ce
count)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028152755.3838=
21-1-gowtham398gs@gmail.com?part=3D1
