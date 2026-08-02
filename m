Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1BD314B6E
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703381; cv=none; b=gad1Ni9upNcPHm2uFLV3H0e0qy5wQQtDrLLAYfM/zy5P8/sVLMMc+b1vH0gs7KfBLU2619PKodgp6UOPHgWT0Xwi+S7p6G2D1Sbx1DyCYViaB3ijubLu1o+HKLIPKDQuF5L7jWF1DQyDRBc9qUgaTQQJ9r+DGCaY/QZBLjT2yto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703381; c=relaxed/simple;
	bh=mXnMRnyhiNb7yfruQx5g2QojQjp8E282dwd9BshU2Ek=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oWuV5rxoKbR2LZ0nGuJ2+syX2P6Ev6VQrX7v1H2mJ2nJI9tqEL8bC9ix4geKTWYk+v4yDDK74lm13XO666Df51NXegis1BPjk6LiY3mqTExjl8JA7B73QP3AeBepZ479LFd/9HmrIXqXqI6O1YkYD2fOngPzoytXf1JZuXy6Mxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEK3TB39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEK3TB39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794EE1F000E9;
	Sun,  2 Aug 2026 20:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703380;
	bh=Gh6mP8YmHcQ3zeZCW4hUkf14PebFl/IUAJKufR6O+io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AEK3TB39oIODFR0PNbXwmyaHGeAUOSyxupSKm9UuqoRJsbI4rvUCfNRlOqjaPS9Pt
	 RvCBGOBVhX9bzm90Ribq2VH8YWq8S0C1BeFKXjdS6FuMC+zKsoka3817FigIHnwsW9
	 Ub8kFY2zLvGDFsF2CsJ+sm2oqSf8dmQzoiLlsdR2Vnb+0P6i4oprietS8NOe2Iqi4l
	 hm109fGGga0KzY2+fqZWMwudx/lp4+sPgK18OEuxVTv81esx/N83gmT77MO3VSZ9yE
	 aspw0o0jIC4LoEmk/DPQ+PtX3nh9c9hDt/OzWd9jKpsEES5DLkdBb0Bvc6zGN74s0n
	 XLEaQDTtrG1XA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 27/29] md/raid5: reject llbitmap reshape when md
 chunk shrinks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-28-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-28-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:42:59 +0000
Message-Id: <20260802204300.794EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incomplete check for shrinking sectors_per_chunk during RAID5 llbi=
tmap reshape allows unsupported geometry changes.
--

--- Patch [27]: [PATCH v5 27/29] md/raid5: reject llbitmap reshape when md =
chunk shrinks ---
commit 25700e5b0d24da1aa9addea044a934a4d475781a
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: reject llbitmap reshape when md chunk shrinks

This commit prevents llbitmap reshapes from proceeding when the md chunk
size shrinks, as this reduces the effective data range covered by each
bitmap bit.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 88bf5a9ce5737..67d56c92c8a44 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -8580,6 +8580,9 @@ static int check_reshape(struct mddev *mddev)
>  	if (!check_stripe_cache(mddev))
>  		return -ENOSPC;
> =20
> +	if (mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +	    mddev->new_chunk_sectors < mddev->chunk_sectors)
> +		return -EOPNOTSUPP;

[Severity: High]
Does this check adequately cover reshapes that remove disks?

Looking at raid5_bitmap_sector_map(), sectors_per_chunk is calculated as
chunk_sectors * (raid_disks - max_degraded). If a reshape removes disks
(delta_disks < 0), the number of data disks decreases.

This means the effective sectors_per_chunk can shrink even if
new_chunk_sectors is equal to or slightly larger than chunk_sectors.

Will omitting a check for delta_disks < 0 allow these shrinking reshapes
to proceed, causing a single bitmap bit to incorrectly map to a smaller
logical data range and potentially corrupting the dirty bit mapping?

>  	if (mddev->new_chunk_sectors > mddev->chunk_sectors ||
>  	    mddev->delta_disks > 0)
>  		if (resize_chunks(conf,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D27
