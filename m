Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18A735E950
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473610; cv=none; b=KrH5VBdyctuvm7Q86TajIIhpRPf0oIrVhFMe3/8y6NN2E0pZ9jnYObFkCaD8WTWzLvIw8cuX7VuRG75fgElKl6Cd2SvGqVNjWYm6imevgNtgB1u+bnr9qIdEl0NCOS9srWG+QFRSsbOtfr8ke30FOZFo0fT4TaDn9PYh71EHahk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473610; c=relaxed/simple;
	bh=XRsTnxTCIS4TWncRZgUHXkYZpuna0lOJ5LHOjsCtS1w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NaMh/9WQ3jj66ezM6v7O4AyO6sO9yw3pqqtoIFjuU03qDdI0TQDj9D2AhG6X2kqS7G7y6/GGp3cpPSSkbnqRtMTbYK6wa/dFoaAwdL/gTPJgynFZJG1qz6kpKWLLsfXGzowZzNjCM1sUI7O9MBfa+ukqfoxN09/pHaKhBb6uLFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZlv1jRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZlv1jRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6511F000E9;
	Sun, 19 Jul 2026 15:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473608;
	bh=BrX2EB94vE7t+g0WFoH4zho93BlaOq52BV9ONpQGTks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hZlv1jRa5J5a+OwHxFkH0avuq8dymY3RzH3FcEDT2qXQtOTcBsdPX8Eqyn+nRESw7
	 XD/n6BInU8KG/Nljqy+8AoHjk+iV4SF1UclTVWZV5qP2IzuSEfkic7tBYcdTMtpEnl
	 6GF3+KvtdyDAcVK7++Txacw0ty0y7SdsMXmVIQVYPQM/Lvv/70PhMZxjsfQ3oseQW1
	 IAOglxj0y4apAYvMgvNCLjsJxjuxYsFo/Sf4w0lo8cIv11OpIKtM1Fr4hpnZhRD+Pa
	 TnmUtZ/Gm3a5NIFOzwW+W8i7V+Ckv9C0HcjOdkZltvGLTW5tHzPVROKMRSlNGuhAYK
	 arqbe9e6cHN/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] md/md-bitmap: mask sb->state on load to drop
 runtime-only bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260719144409.940492-2-mykola@meshstor.io>
References: <20260719144409.940492-1-mykola@meshstor.io>
 <20260719144409.940492-2-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 15:06:48 +0000
Message-Id: <20260719150648.6C6511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The lockless bitmap implementation (llbitmap) remains vulnerable t=
o the exact same persistent WRITE_ERROR bug that this commit fixes for the =
standard bitmap.
- [High] Internal bitmap pages allocated with alloc_page() are leaked durin=
g array teardown when CONFIG_MD_BITMAP_FILE is enabled.
- [High] Cluster superblock flags leak across `re_read` loop iterations, ca=
using spurious state inheritance from node 0.
--

--- Patch [1]: [PATCH 1/4] md/md-bitmap: mask sb->state on load to drop run=
time-only bits ---
commit f4f8e55ab2fda3c56252ec133561c13874aeb19a
Author: Mykola Marzhan <mykola@meshstor.io>

md/md-bitmap: mask sb->state on load to drop runtime-only bits

This patch masks the loaded state to BITMAP_STALE in md_bitmap_read_sb() so
any runtime-only bits like BITMAP_WRITE_ERROR are dropped. This fixes an
issue where an array refuses to assemble if it previously hit a transient
bitmap write error under an older kernel.

> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 0f02e2956398d..4dd3fc2a9e15b 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -931,8 +931,13 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>  		}
>  	}
> =20
> -	/* assign fields using values from superblock */
> -	bitmap->flags |=3D le32_to_cpu(sb->state);
> +	/*
> +	 * Only BITMAP_STALE is meaningful to this loader from sb->state:
> +	 * WRITE_ERROR and DAEMON_BUSY are kernel-runtime signals (kernels
> +	 * before v4.15 persisted WRITE_ERROR), FIRST_USE/CLEAN are
> +	 * llbitmap-only, and HOSTENDIAN is derived from sb->version below.
> +	 */
> +	bitmap->flags |=3D le32_to_cpu(sb->state) & BIT(BITMAP_STALE);

[Severity: High]
This isn't a bug introduced by this patch, but does this bitwise OR cause
cluster superblock flags to leak across re_read loop iterations?

In md_bitmap_read_sb(), when nodes > 0, the code reads offset 0 initially a=
nd
accumulates flags into bitmap->flags. It then computes a new offset for its
own cluster_slot and jumps back to the re_read label, but bitmap->flags is
never cleared.

Could this cause a local node to spuriously inherit BITMAP_STALE or
BITMAP_HOSTENDIAN from node 0, incorrectly forcing a full array recovery?

[Severity: High]
This is a pre-existing issue, but does the lockless bitmap implementation in
drivers/md/md-llbitmap.c remain vulnerable to the exact same WRITE_ERROR bug
this patch fixes for standard bitmaps?

In llbitmap_read_sb():

    llbitmap->flags =3D le32_to_cpu(sb->state);

Since it reads the superblock state entirely unmasked, wouldn't a single
instance of on-disk corruption or transient error set BITMAP_WRITE_ERROR
permanently and force a full resync on every restart?

[Severity: High]
This is also a pre-existing issue, but do internal bitmap pages leak during
array teardown when CONFIG_MD_BITMAP_FILE is enabled?

In md_bitmap_file_unmap(), free_buffers() is called for each page:

drivers/md/md-bitmap.c:free_buffers() {
    ...
    if (!PagePrivate(page))
        return;
    ...
}

For internal bitmaps, reads and writes use sync_page_io() without buffer
heads, so PagePrivate is never set. Does this early return skip put_page()
and permanently leak all dynamically allocated metadata pages whenever the
array is stopped or the bitmap is resized?

>  	if (le32_to_cpu(sb->version) =3D=3D BITMAP_MAJOR_HOSTENDIAN)
>  		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
>  	bitmap->events_cleared =3D le64_to_cpu(sb->events_cleared);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719144409.9404=
92-1-mykola@meshstor.io?part=3D1
