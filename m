Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E824343FA
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 15:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783698282; cv=none; b=W/TM0ujT/J8xU3wpUhi8L1GivkJd+4Znpjy/EmTaBszStGGs9FH1T1wHDi3AYSEkzcmpJZeyqbmBfSYWfIhdvz3lCkfBwYCYYobbOX1YTBlNmJ/wzzrfK3ttwgpmPwYlYunuqIS4EqyqlnouAxfZwqbRLyJeAN/W/cxlFctrwGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783698282; c=relaxed/simple;
	bh=jAi/DtNIgDiZpmIHRGtoaqh0Dy48HOEc7Xzr0i379kY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lF1ALnxVY0Jffxa8RIMXFoq1YVQaLZ8OCCQ2tLkEdNL0bWJqOl27+MByibH2oEhDFssdx+e2mSwE02bxY5233t4fTRsAGZla15Ye6VdUW1UY2hMbb0QpVBjoGpNNr5nyioi1dqqKitNJ4sAWfau2f6On9rK7Fo65w6MCgIyfmGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cv8JFKMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cv8JFKMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAF91F000E9;
	Fri, 10 Jul 2026 15:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783698278;
	bh=nq/nRVS46N6o3D9GNspzdiAyiMLhLEj3UZpS1WxpIt8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cv8JFKMd+nYnenwDBnj0qG/mNiu1DqXAWsLgbA7UO9TP8PzHAC/McZT3rJh/HjqJ8
	 t7HJbpkh5XXWwI2gVN0oGdlZF2JO6kykdZJORsgd3eQxWnyBLkATjrc0HxH2AKmIfk
	 oYLo1Ccj9BD9sOdt7nf7rkxHtCLzW3GQ46PoVnDFav5tdSkE5B3qJ8vZZLUWDDDhJv
	 2SmaMJhC2K2kk/fXcp5pwcBNh8Rnyd6rdKawCz6sRCn0LZYrNVs//cXq1TzZA9GkGj
	 2KBRHVQ2/lp/R4IV7+C3wYYgBCENtzi/eeVS1jZuSoPFsnJtii70kIBj1Q23CH5NeO
	 agXfSUJ/TbtcA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] md: change chunk_sectors and stripe cache counts to
 unsigned int
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260710132329.7273-2-nishidafmly@gmail.com>
References: <20260710132329.7273-1-nishidafmly@gmail.com>
 <20260710132329.7273-2-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 15:44:37 +0000
Message-Id: <20260710154437.DFAF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Lockless read race on total_cached evaluates to a negative value=
, triggering unsigned promotion and false cache pressure signals.

Pre-existing issues:
- [Critical] The calculation of total sectors per chunk stripe (chunk size =
multiplied by data disks) is performed using 32-bit arithmetic, which can o=
verflow. This leads to a divide-by-zero kernel panic or incorrect boundary =
math if a maliciously large chunk size is provided.
--

--- Patch [1]: [PATCH 1/2] md: change chunk_sectors and stripe cache counts=
 to unsigned int ---
commit 6fa5b599e890f5ca04407ab1005af1cc096d709e
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md: change chunk_sectors and stripe cache counts to unsigned int

This commit changes various chunk and stripe counts from signed to
unsigned int in the md/raid5 subsystem to prevent negative values.
It allows the compiler to optimize division and modulo operations by
power-of-two chunk sizes to right shifts in the hot I/O path.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0c5c9fb0606ee..28828e083c2b3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -7929,7 +7929,7 @@ static int raid5_run(struct mddev *mddev)
>  		sector_t here_new, here_old;
>  		int old_disks;
>  		int max_degraded =3D (mddev->level =3D=3D 6 ? 2 : 1);
> -		int chunk_sectors;
> +		unsigned int chunk_sectors;
>  		int new_data_disks;

[Severity: Critical]
This isn't a bug introduced by this patch, but changing the types to
unsigned int fails to resolve an underlying 32-bit wrapping regression.

Does this code overflow when calculating total sectors per chunk stripe?

In raid5_run(), if a maliciously crafted RAID superblock sets chunksize
to 0x08000000 (64 GiB) and raid_disks to 33, the multiplication
(chunk_sectors * new_data_disks) evaluates to 0x08000000 * 32.

This wraps to 0 in 32-bit arithmetic, which is then passed to sector_div():

    if (sector_div(here_new, chunk_sectors * new_data_disks)) {

This triggers a divide-by-zero panic. A similar issue occurs in
make_discard_request() where DIV_ROUND_UP_SECTOR_T() is called with a
wrapped stripe_sectors value.

> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index cb5feae04db27..5cd9d0f36b6e0 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
[ ... ]
> @@ -572,12 +572,12 @@ struct r5conf {
>  	/* only protect corresponding hash list and inactive_list */
>  	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
>  	struct mddev		*mddev;
> -	int			chunk_sectors;
> +	unsigned int		chunk_sectors;
>  	int			level, algorithm, rmw_level;
>  	int			max_degraded;
>  	int			raid_disks;
> -	int			max_nr_stripes;
> -	int			min_nr_stripes;
> +	unsigned int		max_nr_stripes;
> +	unsigned int		min_nr_stripes;

[Severity: Medium]
Does changing min_nr_stripes to unsigned int introduce a spurious cache
flush regression due to type promotion?

In drivers/md/raid5-cache.c:r5c_do_reclaim(), total_cached can evaluate
to -1 if r5c_finish_stripe_write_out() concurrently decrements
r5c_flushing_partial_stripes and r5c_cached_partial_stripes during a
lockless read.

Since min_nr_stripes is now unsigned, the -1 is promoted to UINT_MAX in
this condition:

    if (total_cached > conf->min_nr_stripes * 3 / 4 ||

This makes the cache pressure check spuriously evaluate to true, leading
to unnecessary CPU wakeups and a performance regression during writeback
workloads.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132329.7273=
-1-nishidafmly@gmail.com?part=3D1
