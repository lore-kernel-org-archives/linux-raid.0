Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B719A280CE5
	for <linux-raid@vger.kernel.org>; Mon, 20 Jul 2026 02:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784514328; cv=none; b=BMfXMx+4gf+LFi1ce0MuE9lbM+GKLUrqgSLnWzny7j1hr/eXFqSGkC+Y0jW87x3sxYPEQyC5TnGjAOpP+DFA7Z2WgCvVmA8Ds2WkceZ0LrqGZzXZUPC5w4zrXgNsfUkgiqRbNejGeMDtm5UDwF2MJItV1oRvv/O+8F9Iyv1/3JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784514328; c=relaxed/simple;
	bh=aLxjRwOT5KZEnVzETWc9pi8Pi5S6/IaKzkfMHj1iQxw=;
	h=To:From:Date:Message-Id:References:Mime-Version:In-Reply-To:Cc:
	 Subject:Content-Type; b=ffyMSMh2Y+E2ysrWGqPYTFODtrJ0Gw6e/laPBWho9vc6T3Uj8oqYtiqy7/NaQ1/CS4CYF0M5Q/sdTJmEV/pRx2u35EWu/vUFb/qJeA3TREVt8N5wGbeLlayBoo4AhUCF/mn7jD1t/y+jE2LnFNgQsn1+u4btHogP3vlGAJdj8b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=DcGBno5K; arc=none smtp.client-ip=209.127.231.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="DcGBno5K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784514318;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Z+mfNXhRZD/K20F86DDEVJPPTFTVXarF2Xk9qMgjNn0=;
 b=DcGBno5Kst+SPgpAuBOuVjc94j3RCbjhXIQ+/DU2y61UIfw/50uDeRjSqhgEgBHP0ofcyA
 OySrrPR80iHz1BwUJCv/RcD9IMLq7dC2hMBdFVSJLI9gGqQT0EW+cK5qTGiyiNb0XScAJs
 p/meZxWDH7J5mDKZo4zNdbBR4KR5l7MWkKE7sPeidYrIpgJ7jjC9333khaRoQYfQCX4k53
 IvR7+PMk2ZED8ZB9HzNXD+359D3iFTIYrtXxgBYHWUWtJJeGYNSxNMOB0kWf7fAbvewrGC
 jd6V8YBDSWoRue5fv2DQ2FssL/g8rrWHprzT0/lSNYdHBO9Ntz4we3tUJdtOXA==
To: "Mykola Marzhan" <mykola@meshstor.io>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 10:25:13 +0800
Message-Id: <7aa16dbf-9931-4c7d-9368-a828a1767034@fygo.io>
X-Lms-Return-Path: <lba+26a5d870e+b89227+vger.kernel.org+yukuai@fygo.io>
References: <20260719144227.940444-1-mykola@meshstor.io> <20260719144227.940444-3-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Mon, 20 Jul 2026 02:25:17 +0000
In-Reply-To: <20260719144227.940444-3-mykola@meshstor.io>
Reply-To: yukuai@fygo.io
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Hannes Reinecke" <hare@suse.de>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] md: only consult skip_sync_blocks when 'j' is in the bitmap's domain
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/7/19 22:42, Mykola Marzhan =E5=86=99=E9=81=93:
> Rebuilding a raid10 member with llbitmap can complete in a few
> hundred milliseconds having copied nothing: md_do_sync() offers
> every position 'j' to bitmap_ops->skip_sync_blocks(), the bitmap
> answers for the wrong chunks, the whole rebuild is skipped as
> "unwritten", and the array reports optimal with a stale member.  The
> staleness is typically noticed only when the mirror partner fails;
> writes made while the array was degraded vanish.
>
> The bitmap spans [0, resync_max_sectors) in the personality's
> sync-cursor space.  Resync walks exactly that range for every
> personality and may always consult the bitmap.  Recovery walks
> per-device offsets, which match the bitmap's space only for raid1
> (device space is array space) and raid456 (the bitmap is indexed by
> the per-device sync cursor; bitmap_sector() translates array IO
> into it).  raid10's bitmap is in array space -- near-2 on four
> disks spans twice a member's size; far-2 on two disks puts array
> chunk 2c+d at device chunk c of disk d -- so
> llbitmap_skip_sync_blocks() was consulted with offsets it cannot
> interpret.
>
> Only call the hook when the offsets match what the bitmap expects.
> Reshape must visit every stripe regardless of bitmap state --
> skipping would desync reshape_position from 'j' -- so never skip
> there.  For recovery, add an md_personality capability,
> recovery_in_bitmap_space, set by raid1 and raid456.  raid10 leaves
> it unset (raid10_find_virt() needs the disk number, which
> md_do_sync() does not have); raid0 and linear too, but no recovery
> path of theirs reaches the hook.  No performance is lost against any
> released kernel: the hook is llbitmap-only and new in v6.18, so
> raid10 recovery returns to its earlier path -- walk every stripe,
> skip clean chunks inside raid10_sync_request().
>
> A capability rather than a geometry test: for raid10 layouts with
> raid_disks =3D=3D near_copies * far_copies, resync_max_sectors equals
> dev_sectors while the spaces can still differ (far and offset
> variants), so an arithmetic proxy reopens the same hole on those
> layouts.  Disabling the hook for all recovery instead would
> forfeit llbitmap's fast-forward over unwritten chunks for raid1 and
> raid456 rebuilds.  Opt-in is also the safe default: a new
> personality gets no bitmap consultation during recovery until it
> declares otherwise.
>
> Verified for near-2 and far-2 layouts: a rebuild onto an added spare
> copies the writes made while the array was degraded.
>
> Fixes: f196d7288864 ("md/md-bitmap: add a new method skip_sync_blocks() i=
n bitmap_operations")
> Cc: stable@vger.kernel.org # v6.18+
> Assisted-by: Claude-Code:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
> ---
>   drivers/md/md.c    | 13 ++++++++++++-
>   drivers/md/md.h    | 11 +++++++++++
>   drivers/md/raid1.c |  1 +
>   drivers/md/raid5.c |  3 +++
>   4 files changed, 27 insertions(+), 1 deletion(-)

There is already a patchset to support llbitmap reshape for raid10 and raid=
5:

[PATCH v2 00/20] md/md-llbitmap: support reshape for RAID10 and RAID5 -=20
Yu Kuai <https://lore.kernel.org/linux-raid/cover.1782282042.git.yukuai@ker=
nel.org/>

Before this set, reshape for raid10 or raid5 is not safe. Kernel panic or d=
ata lost
is observed. Please check if your problems still exist with this set.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c8..d60ea7aaca3a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9846,7 +9846,18 @@ void md_do_sync(struct md_thread *thread)
>   		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>   			break;
>  =20
> -		if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blocks) {
> +		/*
> +		 * The bitmap may be consulted with 'j' for a plain resync,
> +		 * but for recovery only when the personality declares that
> +		 * its recovery cursor addresses the bitmap's space; raid10
> +		 * recovery walks per-device offsets the bitmap cannot
> +		 * interpret.  Reshape must relocate every stripe regardless
> +		 * of bitmap state, so never skip there either.
> +		 */
> +		if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blocks &&
> +		    !test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +		    (!test_bit(MD_RECOVERY_RECOVER, &mddev->recovery) ||
> +		     mddev->pers->recovery_in_bitmap_space)) {
>   			sectors =3D mddev->bitmap_ops->skip_sync_blocks(mddev, j);
>   			if (sectors)
>   				goto update;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index d8daf0f75cbb..a490a47736b0 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -798,6 +798,17 @@ struct md_personality
>   	/* convert io ranges from array to bitmap */
>   	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
>   			      unsigned long *sectors);
> +	/*
> +	 * The position md_do_sync() walks during MD_RECOVERY_RECOVER
> +	 * addresses the space the write-intent bitmap is indexed by, so
> +	 * recovery may consult bitmap_ops->skip_sync_blocks() directly.
> +	 * True for raid1 (device space is array space) and raid456 (the
> +	 * bitmap is indexed by the per-device sync cursor).  raid10 must
> +	 * leave this unset: its recovery walks per-device offsets while
> +	 * its bitmap is indexed by array sectors, and translating needs
> +	 * the disk number, which md_do_sync() does not have.
> +	 */
> +	bool recovery_in_bitmap_space;
>   };
>  =20
>   struct md_sysfs_entry {
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index afe2ca96ad8c..1222c0470ab6 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3518,6 +3518,7 @@ static struct md_personality raid1_personality =3D
>   	.check_reshape	=3D raid1_reshape,
>   	.quiesce	=3D raid1_quiesce,
>   	.takeover	=3D raid1_takeover,
> +	.recovery_in_bitmap_space =3D true,
>   };
>  =20
>   static int __init raid1_init(void)
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ffb5fcde54a9..25f8d829a986 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -9078,6 +9078,7 @@ static struct md_personality raid6_personality =3D
>   	.change_consistency_policy =3D raid5_change_consistency_policy,
>   	.prepare_suspend =3D raid5_prepare_suspend,
>   	.bitmap_sector	=3D raid5_bitmap_sector,
> +	.recovery_in_bitmap_space =3D true,
>   };
>   static struct md_personality raid5_personality =3D
>   {
> @@ -9108,6 +9109,7 @@ static struct md_personality raid5_personality =3D
>   	.change_consistency_policy =3D raid5_change_consistency_policy,
>   	.prepare_suspend =3D raid5_prepare_suspend,
>   	.bitmap_sector	=3D raid5_bitmap_sector,
> +	.recovery_in_bitmap_space =3D true,
>   };
>  =20
>   static struct md_personality raid4_personality =3D
> @@ -9139,6 +9141,7 @@ static struct md_personality raid4_personality =3D
>   	.change_consistency_policy =3D raid5_change_consistency_policy,
>   	.prepare_suspend =3D raid5_prepare_suspend,
>   	.bitmap_sector	=3D raid5_bitmap_sector,
> +	.recovery_in_bitmap_space =3D true,
>   };
>  =20
>   static int __init raid5_init(void)

--=20
Thanks,
Kuai
