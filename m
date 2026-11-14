Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630750;
	b=2dw12FgxhglH1axqFuz/v623zq4pjBJvi6KXeTWnDFqcrgAA7w0JYHEo/+7dsjT4iKsb
	 cPR1b4z1+cSCs07e3bbjmsvuI4U4afMCbV8V2CrT4VKoYI9ifDKqQyCiflEYRGTAmi9sF
	 tuIrbcC1DWxwpu60fDcuNX4HZHS7lC8xtZuPfKZdpRRH/IizOte9ENBBnytgfUoJyLZk/
	 coEMit4YkC3mL6dt1imQG1qIsQBn2kAksgDL9HoQeuSrZkF8RIV1OoNggeJbGcScB3XgJ
	 XnIgjuSj4YBAUIK5AL/oZeAlqzTsVdqb4szfGqqukf6zD6K2HqhnYCiQeEfMqGjyFUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630750;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OiZquXIu/T9Xog+w1tPFPSt/ySBeumVbA9vSWCmhohw=;
	b=xsHF1wTLrr6PkVxMK8OsXdv/jJ0e8ZA25g0sJEPwUtzKbvjI71i2d7S5TdG7STJhtLuo
	 Rt8P+7XDry0tubVqcgrwCTasifXcbDea2/vFtGQ5iQ9Q49Nz+l7a18U6643i7jT30a0iE
	 DVm9cvHJJq3OtbxPNscINeIHSTHSZ4wsVmTbzOOHjZAdU4y3PnuzbEuhLhsFPKP5fGUSs
	 TtspX72AAC2UynS8wrs55fntQAuHwI7FRQjMZ4b7PJ8/6rUtFxw+QkD+fiR9RQ+Lir3/A
	 QxDCeCThXs5734jSneHmQ+uX8zkmLykFr7eGLPob0VH6l1ltguT2aKd+yu0ysAezFOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2LSCy09;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874C4606A323
	for <linux-raid@vger.kernel.org>; Sat, 14 Nov 2026 04:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2LSCy09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3B11F000C4;
	Sat, 14 Nov 2026 04:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630750;
	bh=OiZquXIu/T9Xog+w1tPFPSt/ySBeumVbA9vSWCmhohw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k2LSCy09G4q3sftwk7Phxcz4INcmJJ79roHP5nx6GOIrLuQj9ONxCN6UecT4qLY77
	 GyaL8dAkelqnATyDGfMukE8kT4u7IiwbQvCyPBK3F/d7oNP3iVppc/UiYYYecVoL0u
	 U3e3Ay+MzvmrQLwOLoljEG5+RNcWm415Fw+fHOGsX+HoLHE9sF8uEfsDpIR55o+aRM
	 SjN6tt7U5moBnKOwV5eiks2vft6G6mtVRRlNkC0uCu1VBFNEfD/BxKQGggnmGo5MUh
	 wnUTNkCRgkam552RIiOPxmfdJ/6+lGYhplywElJfLn04u3Fvfo853oLZRhS8sfIsxC
	 VCoCXhqT3mMog==
Message-ID: <sashiko-outbox-214141@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] md: enforce MD_SB_DISKS bounds across v0.90
 superblock paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <20261114040959.18009-1-chandradhar.2003@gmail.com>
References: <20261114040959.18009-1-chandradhar.2003@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 04:32:29 +0000
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
- [High] md: unsigned promotion of sb->delta_disks in super_90_load()
  breaks shrinking reshapes
- [Low] md: unresolvable Fixes trailer commit SHA 1da177e4c3f4 in commit
  message
- [Low] md: unvalidated pre-reshape disk count in metadata_store() for
  v0.90
--

commit bf5fb3bca8279f41d81399d06b4ff3fc1efa84b7
Author: Chandradhar Kumar <chandradhar.2003@gmail.com>

> md: enforce MD_SB_DISKS bounds across v0.90 superblock paths
>=20
> The legacy v0.90 superblock format (mdp_super_t) embeds a fixed-size
> array of MD_SB_DISKS (27) disk descriptors (sb->disks[27]). Currently,
> several configuration and metadata load paths fail to enforce this
> upper bound, allowing mddev->raid_disks, rdev->raid_disk, or
> rdev->desc_nr to exceed MD_SB_DISKS - 1 and trigger an out-of-bounds
> array access in super_90_sync():
>=20
>   UBSAN: array-index-out-of-bounds in drivers/md/md.c:1740:29
>   index 124 is out of range for type 'mdp_disk_t [27]'
>=20
> Fix this across all entry points and harden super_90_sync():
>=20
> 1. In super_90_load(), validate sb->this_disk.number, sb->delta_disks
>    (for v0.91+), and active/sync raid_disk indices against MD_SB_DISKS.
>    In super_90_validate(), check rdev->desc_nr at the start of the
>    function before any sb->disks[] dereference and guard desc->raid_disk
>    assignments.
> 2. In metadata_store() and md_set_array_info(), validate existing
>    mddev->raid_disks against MD_SB_DISKS for persistent v0.90 arrays
>    and maintain mddev->max_disks across both persistent and
>    non-persistent transitions.
> 3. In raid_disks_store() and slot_store(), reject values overflowing
>    INT_MAX or exceeding MD_SB_DISKS / mddev->max_disks across all
>    configuration and reshape branches.
> 4. In super_90_sync(), bounds-check desc_nr and mddev->raid_disks
>    before indexing sb->disks[], and synthesize a faulty/removed
>    this_disk descriptor if rdev->desc_nr is out of range rather than
>    indexing out-of-bounds or zeroing this_disk (which would alias
>    slot 0).
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D9e3014263a35700ab49b
> Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>

[Severity: Low]
Commit 1da177e4c3f4 ("Linux-2.6.12-rc2") cannot be resolved in the
repository (and points to the initial git epoch commit rather than a
specific introducing commit such as 1a33a379e678 ("md: reject v0.90 arrays
with too many devices")).

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..e733dcdd13a5b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1407,7 +1407,18 @@ static int super_90_load(struct md_rdev *rdev, str=
uct md_rdev *refdev, int minor
>  		goto abort;
>  	}
> =20
> -	if (sb->raid_disks <=3D 0 || sb->raid_disks > MD_SB_DISKS)
> +	if (sb->raid_disks <=3D 0 || sb->raid_disks > MD_SB_DISKS ||
> +	    sb->this_disk.number >=3D MD_SB_DISKS)
> +		goto abort;
> +
> +	if (sb->minor_version >=3D 91 &&
> +	    ((s64)sb->raid_disks - sb->delta_disks <=3D 0 ||
> +	     (s64)sb->raid_disks - sb->delta_disks > MD_SB_DISKS))
> +		goto abort;

[Severity: High]
Does subtracting sb->delta_disks without casting it to s32 break loading
any v0.91 array undergoing a shrinking reshape?

struct mdp_superblock_s declares delta_disks as __u32 even though it stores
a signed two's-complement delta (assigned to signed int mddev->delta_disks
in super_90_validate()).  Promoting __u32 sb->delta_disks to s64
zero-extends negative values to [2147483648, 4294967295], so
(s64)sb->raid_disks - sb->delta_disks is always negative when shrinking an
array and super_90_load() rejects the superblock with -EINVAL, while the
> MD_SB_DISKS check is unreachable.  Casting sb->delta_disks to s32 before
subtracting avoids the unsigned zero-extension.

[ ... ]

> @@ -5056,10 +5113,14 @@ metadata_store(struct mddev *mddev, const char *b=
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

[Severity: Low]
Can switching an array to v0.90 metadata in metadata_store() (or
md_set_array_info() when info->raid_disks =3D=3D 0) still leave the pre-res=
hape
disk count (mddev->raid_disks - mddev->delta_disks) above MD_SB_DISKS?

While an array is non-persistent and has no disks attached, writing a value
above MD_SB_DISKS to raid_disks_store(), setting reshape_position, and then
reducing raid_disks to at most MD_SB_DISKS records the original count in
mddev->raid_disks - mddev->delta_disks.  Switching to v0.90 metadata then
passes the mddev->raid_disks > MD_SB_DISKS check, causing super_90_sync()
to write a v0.91 superblock that super_90_load() rejects as invalid.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114040959.1800=
9-1-chandradhar.2003@gmail.com?part=3D1
