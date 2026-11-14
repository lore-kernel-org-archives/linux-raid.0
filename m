Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794619927;
	b=DofL4Pk/OLPdtqsKPvinyBCQqS1lJaUm1yb2iZASx8H7KbTaofHy9UN5Juokpk5ywDen
	 wFxOQBNX1VFM1V93p7M0cYUAGadV1vnYFlkzz0bRDu2RcPVH7utuPb8G7U2aGOXc8SXu8
	 RH98UtO234rS+biZrcIrjgNFgbXlGjrYhx22jxEMWJA8Od8feU6Gjmdz32hP++8zZez7l
	 CKGj1JCEJeSpoa2sDX3B+PVQ/bZrQM3l1G8H8CuN9Lyuu7CMfVGJLDGTgSGZPxyCSx5hm
	 ig2uZIUOQKkYqAreeIHpA08VWQNMxq+/Xfl/5Z0uUpdAv2q/NVk3AOq6sz5+J3DQsfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794619927;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ocCPvrdHmwjH21HnsoEsq7cTVjjRmGUqJJnJcSHAd4Y=;
	b=CdrC5/rGeP/ObEflZMCxFKVuKK8UajXhbRcqXn2zEV9E8xz79brAhtHQefd4sX41epBl
	 maZzb9886p5/XXVgaWIiBCErKUUgnaNkyyxc7khBNCQzmj1I958g4p4dZF3u18bT36ML7
	 TTdZ5bzP39GTb6ZAb3vgEVtWV6jhDIHWKdhOEvBNBOVwmRvlSelcSaS+6Apoyj3PZIHje
	 1LqNKIoWVDf75sQq+o8pJTh33i8RqUkIyD0gyE/+dTlarHAfl2nFhQV1r0m6H1sl3a9mn
	 +BHETnUPQXxxmipB1lIsO4AAAKNFMSYD87vtx/h29FfajQ9oeWr9AEmPbsgLDVK4b2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kX2zDz8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A0606A337
	for <linux-raid@vger.kernel.org>; Sat, 14 Nov 2026 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kX2zDz8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3222C1F000C4;
	Sat, 14 Nov 2026 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794619927;
	bh=ocCPvrdHmwjH21HnsoEsq7cTVjjRmGUqJJnJcSHAd4Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kX2zDz8oNJMK5p+k72RhtMPYPBJVIQ/MhQ0j2+upwkvZbt1x8N53b8zvpoFT5HHoZ
	 zdMu2qwZX0NQN5K+H7A2MPwBPcnKacV7iXzgGhglS811gkCwAF29BV7mWgl0+rcrHF
	 B9cZYr/gCFd4OvptWIFXHz0gpp71PEpcWoikOkYwMLCeHj887uLWzxcJguhyDIS15I
	 QHIpLfHZHJIm6IcjFRf2roflEeZGfU2s52MBwMGOd9pAN/SulPWIAKEZTIrwP4IAnC
	 A3LMr9FyvbHV9VAp9flg95YhTtJrBrcVCHD4GNZuqExMEpm5hvDawMnxnhVwHE6TmI
	 deDrfZKKhKA3Q==
Message-ID: <sashiko-outbox-214006@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md: enforce MD_SB_DISKS bounds across v0.90
 superblock paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <20261114010635.6048-1-chandradhar.2003@gmail.com>
References: <20261114010635.6048-1-chandradhar.2003@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 01:32:06 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] md: incomplete MD_SB_DISKS validation in super_90_validate()
- [Medium] md: missing mddev->max_disks update in md_set_array_info()
  and MD_SB_DISKS check in update_raid_disks()
- [Medium] md: signed overflow of mddev->raid_disks in
  raid_disks_store() bypasses metadata_store() check
--

commit 5e97b94d742c20742fe700227c811d79a4c7ba7c
Author: Chandradhar Kumar <chandradhar.2003@gmail.com>

md: enforce MD_SB_DISKS bounds across v0.90 superblock paths

This commit adds MD_SB_DISKS bounds checks across v0.90 superblock load,
validation, sync, sysfs configuration, and ioctl paths to prevent
out-of-bounds accesses on sb->disks[].

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..71f536d6257cd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -1587,6 +1588,8 @@ static int super_90_validate(struct mddev *mddev, s=
truct md_rdev *freshest, stru
>  			return 0;
>  	}
> =20
> +	if (rdev->desc_nr < 0 || rdev->desc_nr >=3D MD_SB_DISKS)
> +		return -EINVAL;
>  	desc =3D sb->disks + rdev->desc_nr;
> =20
>  	if (desc->state & (1<<MD_DISK_FAULTY))

[Severity: High]
Does super_90_validate() still leave v0.90 superblock fields unvalidated
against MD_SB_DISKS?

First, the new rdev->desc_nr check is placed after the mddev->pers =3D=3D N=
ULL
branch, which already indexes sb->disks[rdev->desc_nr].state.  Second,
desc->raid_disk is copied into rdev->raid_disk and rdev->saved_raid_disk
without checking that desc->raid_disk < MD_SB_DISKS:

drivers/md/md.c:super_90_validate() {
    ...
	} else if (desc->state & (1<<MD_DISK_SYNC)) {
		set_bit(In_sync, &rdev->flags);
		rdev->raid_disk =3D desc->raid_disk;
		rdev->saved_raid_disk =3D desc->raid_disk;
    ...
}

When md_add_new_disk() -> add_bound_rdev() runs on an active array,
add_bound_rdev() ignores validate_super()'s return value and passes rdev
directly to mddev->pers->hot_add_disk() without going through analyze_sbs(),
allowing an out-of-range desc->raid_disk to index conf->mirrors[] out of
bounds in raid1_add_disk() or raid10_add_disk().

In addition, for minor_version >=3D 91, super_90_validate() copies
sb->delta_disks into mddev->delta_disks without bounds checking; a negative
sb->delta_disks (or desc->raid_disk >=3D 0x80000000 wrapping to a negative
int in rdev->raid_disk) bypasses the rdev->raid_disk >=3D (mddev->raid_disk=
s -
min(0, mddev->delta_disks)) check in analyze_sbs().

[ ... ]

> @@ -4442,6 +4473,13 @@ raid_disks_store(struct mddev *mddev, const char *=
buf, size_t len)
>  	if (err)
>  		return err;
>  	noio_flags =3D memalloc_noio_save();
> +	if ((mddev->max_disks && n > mddev->max_disks) ||
> +	    (mddev->persistent && mddev->major_version =3D=3D 0 &&
> +	     n > MD_SB_DISKS)) {
> +		err =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
>  	if (mddev->pers) {
>  		if (n !=3D mddev->raid_disks)
>  			err =3D update_raid_disks(mddev, n);
[ ... ]
> @@ -5056,10 +5096,14 @@ metadata_store(struct mddev *mddev, const char *b=
uf, size_t len)
>  	err =3D -ENOENT;
>  	if (major >=3D ARRAY_SIZE(super_types) || super_types[major].name =3D=
=3D NULL)
>  		goto out_unlock;
> +	err =3D -EINVAL;
> +	if (major =3D=3D 0 && mddev->raid_disks > MD_SB_DISKS)
> +		goto out_unlock;
>  	mddev->major_version =3D major;
>  	mddev->minor_version =3D minor;
>  	mddev->persistent =3D 1;
>  	mddev->external =3D 0;
> +	mddev->max_disks =3D (major =3D=3D 0) ? MD_SB_DISKS : 0;
>  	err =3D 0;
>  out_unlock:
>  	mddev_unlock(mddev);

[Severity: Medium]
Can an unsigned value >=3D 2147483648 written to raid_disks_store() overflow
mddev->raid_disks and bypass the check in metadata_store()?

raid_disks_store() parses buf into unsigned int n with kstrtouint().  When
raid_disks is written while metadata_version is still "none", both
mddev->max_disks and mddev->persistent are 0, so n > INT_MAX is stored into
the signed int mddev->raid_disks as a negative number.  Writing "0.90" to
metadata_store() then passes the signed comparison mddev->raid_disks >
MD_SB_DISKS, leaving the v0.90 array configured with a negative
mddev->raid_disks.

> @@ -7951,6 +7995,14 @@ int md_set_array_info(struct mddev *mddev, struct =
mdu_array_info_s *info)
>  		mddev->ctime         =3D ktime_get_real_seconds();
>  		return 0;
>  	}
> +
> +	if (info->raid_disks < 0 ||
> +	    (!info->not_persistent && info->raid_disks > MD_SB_DISKS)) {
> +		pr_warn("md: %s: invalid raid_disks %d for v0.90 superblock\n",
> +			mdname(mddev), info->raid_disks);
> +		return -EINVAL;
> +	}
> +
>  	mddev->major_version =3D MD_MAJOR_VERSION;
>  	mddev->minor_version =3D MD_MINOR_VERSION;
>  	mddev->patch_version =3D MD_PATCHLEVEL_VERSION;

[Severity: Medium]
Does the info->raid_disks =3D=3D 0 branch in md_set_array_info() leave
mddev->max_disks unset?

When SET_ARRAY_INFO is called with info->raid_disks =3D=3D 0,
md_set_array_info() sets mddev->major_version and mddev->persistent and
returns early without updating mddev->max_disks.  If userspace then sets
raid_disks via sysfs and starts the array, md_run() skips analyze_sbs()
because mddev->raid_disks is already non-zero, so mddev->max_disks remains 0
on a persistent v0.90 array.  As a result, bind_rdev_to_array() and
update_array_info() -> update_raid_disks() (which only checks
mddev->max_disks) do not enforce MD_SB_DISKS.

Conversely, if metadata_store() set mddev->max_disks =3D MD_SB_DISKS and
md_set_array_info() is later called with info->not_persistent =3D=3D 1 or w=
ith
info->raid_disks =3D=3D 0 and info->major_version !=3D 0, mddev->max_disks =
is
never cleared to 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114010635.6048=
-1-chandradhar.2003@gmail.com?part=3D1
