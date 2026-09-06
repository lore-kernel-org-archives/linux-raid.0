Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEE1233924
	for <linux-raid@vger.kernel.org>; Sun,  6 Sep 2026 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788720934; cv=none; b=fpbfQ2JDL76F0RVevHGXktIHp1PPkRlRoo7GffIKuM0+N+CnoJIYB5oiVHxYqTgvWLzI+DyQAqjfwjzSV+1xGmCfRQndHwFzNYxvK/ENjgkwKzuPKyu9WA48z5kpmhnCadxKKuAm85gngN3+ofy9MrFpF/fnlQn5FsXy1/S/szM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788720934; c=relaxed/simple;
	bh=Z8VkikbWuqxW3M9i9edGXVi62tbW4qiyA2qvDHSMmWg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KBhWb4oSgjI2mO2gC0VU2WHhPRQc8BwPigVrastvVqWGLm2SM4eXHUpI00WsowTPZ4z7pEDiYmxIG17KBg6D31vFPaYc/U2fAy9oAkZhMS2rXG2dv5OFi71uEfCimr1MgKHR8NtLCkVmmNc0XXVElwWk//dWAgtw604L05T5EW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4zCT8Yt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4zCT8Yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26CC1F00A3A;
	Sun,  6 Sep 2026 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788720933;
	bh=X9Naxk1u7HATaUI2dFBh+rDaqizFpHqgxfs7iHMcqRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y4zCT8YtL4BZU30FERvIThhEq0V6SKKy+3xuwtWCbRwwYmNckUV8020faUG/B5Eh5
	 /j9T5sfBk0AeijxdoConcpd/mO+YtC7PJGIVmB+0cqBEhBGC9kADs5zKMNUG591Srv
	 avzvDJOZlJ/gRn2i4lx+EF/i+PJK0pqyNHBNwZXbFuZQJfUEEP+2s/mTjmVBaQvoMO
	 Mt/aGDDADkQm+z4AjXiFl7Zntffe3cIgyufVuz+43iBwu5BEYCuYbFg81FrK9O5g91
	 N3zxSXppZlPlpuzNfXCJWffuKvDgLe/sbxzP9aiyE5S9o0jXscq3Gaofv81YHSB+Ms
	 3wN2JNoskWiRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md/raid0: validate device count before allocating
 devlist
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260906184406.2141-1-chandradhar.2003@gmail.com>
References: <20260906184406.2141-1-chandradhar.2003@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 06 Sep 2026 18:55:32 +0000
Message-Id: <20260906185532.E26CC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Integer overflow in `chunk_size` sysfs handler allows a zero-divis=
ion kernel panic in `map_sector()`.
--

commit ff4c12b29e562bce41f4e75365704e1e7f8e00b2
Author: Chandradhar Kumar <chandradhar.2003@gmail.com>

md/raid0: validate device count before allocating devlist

create_strip_zones() allocates conf->devlist based on mddev->raid_disks
before verifying that enough devices are present. Validate the number of
member devices before allocating devlist to reject invalid
configurations early.

Reported-by: syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=3Da32ff75e417c0f49a8e9

> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 35e103f0c2c3e..8eaf078606d6f 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
[ ... ]
> @@ -144,6 +147,21 @@ static int create_strip_zones(struct mddev *mddev, s=
truct r0conf **private_conf)
>  	}
> =20
>  	err =3D -ENOMEM;
> +
> +	if (mddev->raid_disks <=3D 0) {
> +		pr_warn("md/raid0:%s: invalid number of disks %d - aborting!\n",
> +			mdname(mddev), mddev->raid_disks);
> +		err =3D -EINVAL;
> +		goto abort;
> +	}
> +
> +	if (nr_devs < mddev->raid_disks) {
> +		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
> +			mdname(mddev), nr_devs, mddev->raid_disks);
> +		err =3D -EINVAL;
> +		goto abort;
> +	}
> +
>  	conf->strip_zone =3D kvzalloc_objs(struct strip_zone, conf->nr_strip_zo=
nes);

[Severity: High]
This is a pre-existing issue, but does this code allow an integer overflow
in mddev->chunk_sectors that leads to a division-by-zero kernel panic in
map_sector()?

In drivers/md/md.c:chunk_size_store(), the chunk size is parsed with no
upper bounds checking:

	err =3D kstrtoul(buf, 10, &n);
	...
	mddev->chunk_sectors =3D n >> 9;

A large value written to the chunk_size sysfs node of a non-running RAID0
array is bitshifted and truncated into the 32-bit signed integer
mddev->chunk_sectors.

When the array is started and I/O is submitted, the code in map_sector()
can overflow:

drivers/md/raid0.c:map_sector() {
	...
		sector_div(chunk, zone->nb_dev << chunksect_bits);
	} else{
		sect_in_chunk =3D sector_div(sector, chunk_sects);
		chunk =3D *sector_offset;
		sector_div(chunk, chunk_sects * zone->nb_dev);
	}
	...
}

If chunk_sects is a power of 2 (e.g., 0x80000000) and nb_dev =3D 2,
zone->nb_dev << chunksect_bits evaluates to 2 << 31, which overflows to 0
in 32-bit math.

If chunk_sects is not a power of 2 (e.g., 0xC0000000) and nb_dev =3D 4,
chunk_sects * zone->nb_dev evaluates to 0xC0000000 * 4, which also overflows
to 0.

In both branches, sector_div(chunk, 0) executes and panics the kernel. Can
chunk_size_store() be updated to validate the upper bounds of chunk_size to
prevent this crash?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260906184406.2141=
-1-chandradhar.2003@gmail.com?part=3D1
