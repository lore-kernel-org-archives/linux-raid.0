Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E123525B0AE
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785701962; cv=none; b=GtMVq1LGTY6+M1QJorF4N2vfzs8Q6VYvVViYhbYiG9sraYLy8swBh8qozHgNJ9JMSMi/H+y9efWTt9bWJZ8p0Wl93MzkSXvjRtMqPnhjP+C8F7bW5hm0qA4B/QVP5L/XBVSMDZIqjZZotf8bBu5DlnLqf6e5l9zcRI4PjNjU67I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785701962; c=relaxed/simple;
	bh=tMDdH9KjkWldQ1IxYCYOwnbQMJMYns0K5kZy/0B+1wM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BbTa8My6MgnJtk3FQkiQAaP33o417hvI8fuXMl9ZfEQ2SHEUKN6/G7ugpWlGAvca4eak+aYKDikQ2DG/WyckRJ0YDK238orQS0eDNJrhhWRUJxo3r1EPL9pEDUI5ZjmM6cjQbj5TZpgJT0M3INwO11Yo+Rbu+NaX+t2u/otqYY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jp98xt+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jp98xt+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903331F00A3A;
	Sun,  2 Aug 2026 20:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785701961;
	bh=TbUC7CAeRaNFYR9ZsZOkekbwDiVMBXy9X0HMH416ydY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jp98xt+eYhhn1kQKhaMZBLXU4ihd9GWE15FJlx43SFPgNwRmFkSySNArJg5SW00dy
	 MIpnTL0b9Ok1Vr37VCdpVd0rXEXx0ZGsFP9UmXuup9o8bDF3X0Hor5+WDCL7tNuTef
	 FUVNWrfYKH65Fi/c+lLkxCZixqG+gJoTM4v//IxyV2nanfu3wEKF/5pwls5sB+6awl
	 1wiY/P/8J7pbpgqg3c30Biy99ZG173vhBVJm/CatkDIFBVRT2ofKtGLzfLdyC0AVAI
	 uS4Kz4pvLgXPNapGaE2oS3CLUjeispeA+Rwju06sF/Kl8/yxlys3PcvVuQ/fh0eYLm
	 EWQVHo6UkGBAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/29] md/raid5: round bitmap stripes with sector
 division
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-6-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-6-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:19:21 +0000
Message-Id: <20260802201921.903331F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] `prev_end` is incorrectly rounded down instead of up during a =
reshape, potentially causing silent data corruption.
--

--- Patch [5]: [PATCH v5 05/29] md/raid5: round bitmap stripes with sector =
division ---
commit ecc755c8b2e63f314261ab6ac1c1f566e26c875a
Author: Yu Kuai <yukuai@fygo.io>
md/raid5: round bitmap stripes with sector division

This commit changes the rounding logic in raid5_bitmap_sector() and
raid5_bitmap_sector_map() to use sector_div() rather than round_down()
and round_up(). This aligns the array ranges to actual RAID5 stripe widths
that are not always a power of two.

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -6048,8 +6051,10 @@ static void raid5_bitmap_sector(struct mddev *mdde=
v, sector_t *offset,
> =20
>  	sectors_per_chunk =3D conf->prev_chunk_sectors *
>  		(conf->previous_raid_disks - conf->max_degraded);
> -	prev_start =3D round_down(prev_start, sectors_per_chunk);
> -	prev_end =3D round_down(prev_end, sectors_per_chunk);
> +	sector_div(prev_start, sectors_per_chunk);
> +	prev_start *=3D sectors_per_chunk;
> +	sector_div(prev_end, sectors_per_chunk);
> +	prev_end *=3D sectors_per_chunk;

[Severity: Critical]
This is a pre-existing issue, but does rounding down prev_end leave the
tail of the IO unmarked in the bitmap for the previous layout?

If an active reshape reduces the RAID5 stripe width and a write request
spans across the boundary of an old chunk, it appears this code calculates
an incorrectly small component end sector.=20

If the max(end, prev_end) fallback fails to cover the affected component
sectors for the old layout, could they be left unmarked in the bitmap? A
system crash at this moment might skip rebuilding those dirty sectors upon
recovery, leading to inconsistent parity or outdated data.

Should this translation to sector_div() also include logic to round up
prev_end, similar to how end is handled in raid5_bitmap_sector_map()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D5
