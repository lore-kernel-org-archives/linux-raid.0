Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794584684;
	b=UN1ryp4o7evsqTp+erd3Q+uo8Ef+rdPe1oDPTKWxaRL1ZgdjYf1pU/N4KT2iN4meAAtT
	 JnYmrLllJ35WJ/UFQN4YenVg+qoXQb4LrJorfCcvqOYVenEDpDjsfuvz1Py3fd8+ZYY77
	 055zFRPDASgHgBHfhSkTJtajM3zU+/DQTtwIqd7q0P8wTCM1oC5FoEUENq+zkFqCfzg+4
	 moUToo2a81l+i4+OWpAuuNrWZw0a5kq3Ml2isZBDDogCv+IC5qhMV4ZzO777RiFsY6pER
	 KLJssxartgVg6O5QHrJrPqJnnQtOa9+QFBYgags2uAQ4G4FKsh2Kcg3fNgt9HtzR/Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794584684;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wXXZSWxCMYaAb1KG3bhzChj1dYTtnyAB6l2XEAAstMk=;
	b=HoKm1mFQvLbMw3gTBVOtlO9INgWeLvf0eS91xWxFEIHwHccnLh8ZiwgXEqFbHwTuOF1e
	 0hhHIM4OJ4BfTVcTIGp03//cI7l8+FG2PXF3xjkQVx79TcAjE0mklHbOiwyDWR1rOwRKf
	 xwq0kB8/Pb4hlLRYMO1VcJdPPK0/3mOHTsFm618qEh1NRCfAtO0kmxiKXhq4VrDa+YcHZ
	 la4TZqMPIc3dfn7nwIyGHlgYGqn2xM4xHW0Stgf1DH9YlBMJ8fjPvp1jmzizCKvuo0ebE
	 ImdiWg1jXhmjey/U6hxgNP9OnOgGFXD4sV3RGYvEuzcarZLbOdnh8EmjKnxm5djpVmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n6Mt8aoY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954F7606A887
	for <linux-raid@vger.kernel.org>; Fri, 13 Nov 2026 15:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n6Mt8aoY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0851F000C6;
	Fri, 13 Nov 2026 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794584684;
	bh=wXXZSWxCMYaAb1KG3bhzChj1dYTtnyAB6l2XEAAstMk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n6Mt8aoYTVB4SSvjbn6zSywcqLyBFzo7YioVxfDwKN/AO/asrS6ToQR82wmW3vDo8
	 dNmi0X6f5GvUW7+0VWqnzPaPommqviHYP0OoQG/yvQkCaeujvnJD1Gx99GNK+ZdAPd
	 vhGUJO47TwuU9x5lj+DbYuzrp9OHnEElTWHXZp/7qf0lMmSlywZIhOL5ZWhAo+EUdA
	 06PyPYE4e4T+AvTTcOhvZob9k/vhWoL+F/I+auCD8Y0Q4zXAxjriR3mpuXNfZJ1qWy
	 ZtA/6HfcvOqQwvgkSJTBKesKVfDlnMIuEwv6SIy7DaRLxXGakk35siqUYViLUnRWAU
	 bITahkLU5neQQ==
Message-ID: <sashiko-outbox-213112@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: enforce MD_SB_DISKS bounds across v0.90 superblock
 paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <20261113152311.13949-1-chandradhar.2003@gmail.com>
References: <20261113152311.13949-1-chandradhar.2003@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 15:44:43 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] md: super_90_sync() zeroes this_disk and leaves desc_nr at -1
  on skip
- [Medium] md: md_set_array_info() MD_SB_DISKS check bypassed when
  major_version !=3D 0
- [Medium] md: incomplete MD_SB_DISKS checks in sysfs and reshape
  configuration paths
- [Medium] md: early return in super_90_sync() leaves sb_size and
  sb_page uninitialized
- [Low] md: unsigned < 0 check in super_90_load() and code style issues
  in super_90_sync()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] md: out-of-bounds write in super_90_sync() and
  super_1_sync() [1]
--

commit 37ce5ab8e4435993a82dee25db9358c85f6fa1d3
Author: Chandradhar Kumar <chandradhar.2003@gmail.com>

md: enforce MD_SB_DISKS bounds across v0.90 superblock paths

This commit adds MD_SB_DISKS bounds checks across v0.90 superblock loading,
synchronization, sysfs configuration, and SET_ARRAY_INFO ioctl paths to
prevent out-of-bounds accesses on sb->disks[].

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..a72f98cdad549 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1407,7 +1407,9 @@ static int super_90_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor
>  		goto abort;
>  	}
> =20
> -	if (sb->raid_disks <=3D 0 || sb->raid_disks > MD_SB_DISKS)
> +	if (sb->raid_disks <=3D 0 || sb->raid_disks > MD_SB_DISKS ||
> +	    sb->this_disk.number < 0 ||
> +	    sb->this_disk.number >=3D MD_SB_DISKS)
>  		goto abort;
> =20
>  	if (md_csum_fold(calc_sb_csum(sb)) !=3D md_csum_fold(sb->sb_csum)) {

[Severity: Low]
In mdp_disk_t, number is __u32, so sb->this_disk.number < 0 is always false
and triggers a -Wtype-limits warning under W=3D1 builds.

Also, in super_90_sync() below, the new WARN_ON_ONCE() statement is placed
before the local variable declarations (int i; int active=3D0, ...), which
triggers -Wdeclaration-after-statement, and the new pr_warn() format string
for out-of-range desc_nr is missing a trailing newline.

> @@ -1621,6 +1623,10 @@ static void super_90_sync(struct mddev *mddev, str=
uct md_rdev *rdev)
>  	struct md_rdev *rdev2;
>  	int next_spare =3D mddev->raid_disks;
> =20
> +	if (WARN_ON_ONCE(mddev->raid_disks <=3D 0 ||
> +	    mddev->raid_disks > MD_SB_DISKS))
> +		return;
> +
>  	/* make rdev->sb match mddev data..
>  	 *
>  	 * 1/ zero out disks

[Severity: Medium]
Does returning early from super_90_sync() leave rdev->sb_size and
rdev->sb_page uninitialized while sync_sbs() still marks the superblock as
loaded?

sync_sbs() unconditionally sets rdev->sb_loaded =3D 1 after calling
sync_super(mddev, rdev):

drivers/md/md.c:sync_sbs() {
    ...
		} else {
			sync_super(mddev, rdev);
			rdev->sb_loaded =3D 1;
		}
    ...
}

When md_update_sb() subsequently calls md_write_metadata() for every rdev
with sb_loaded =3D=3D 1, it either submits a write bio with a zero-length
segment (if rdev->sb_size is still 0) or writes uninitialized or stale
sb_page contents to disk.

> @@ -1693,6 +1699,8 @@ static void super_90_sync(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  		int desc_nr;
>  		int is_active =3D test_bit(In_sync, &rdev2->flags);
> =20
> +		rdev2->desc_nr =3D -1;
> +
>  		if (rdev2->raid_disk >=3D 0 &&
>  		    sb->minor_version >=3D 91)
>  			/* we have nowhere to store the recovery_offset,
> @@ -1707,6 +1715,12 @@ static void super_90_sync(struct mddev *mddev, str=
uct md_rdev *rdev)
>  			desc_nr =3D rdev2->raid_disk;
>  		else
>  			desc_nr =3D next_spare++;
> +
> +		if (desc_nr < 0 || desc_nr >=3D MD_SB_DISKS) {
> +			pr_warn("md: %s: desc_nr %d out of range for rdev %pg, skipping",
> +				mdname(mddev), desc_nr, rdev2->bdev);
> +			continue;
> +		}
>  		rdev2->desc_nr =3D desc_nr;
>  		d =3D &sb->disks[rdev2->desc_nr];
>  		nr_disks++;
> @@ -1736,7 +1750,7 @@ static void super_90_sync(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  			d->state |=3D (1<<MD_DISK_FAILFAST);
>  	}
>  	/* now set the "removed" and "faulty" bits on any missing devices */
> -	for (i=3D0 ; i < mddev->raid_disks ; i++) {
> +	for (i =3D 0 ; i < mddev->raid_disks && i < MD_SB_DISKS; i++) {
>  		mdp_disk_t *d =3D &sb->disks[i];
>  		if (d->state =3D=3D 0 && d->number =3D=3D 0) {
>  			d->number =3D i;
> @@ -1752,7 +1766,10 @@ static void super_90_sync(struct mddev *mddev, str=
uct md_rdev *rdev)
>  	sb->failed_disks =3D failed;
>  	sb->spare_disks =3D spare;
> =20
> -	sb->this_disk =3D sb->disks[rdev->desc_nr];
> +	if (rdev->desc_nr >=3D 0 && rdev->desc_nr < MD_SB_DISKS)
> +		sb->this_disk =3D sb->disks[rdev->desc_nr];
> +	else
> +		memset(&sb->this_disk, 0, sizeof(sb->this_disk));
>  	sb->sb_csum =3D calc_sb_csum(sb);
>  }

[Severity: High]
Can zeroing sb->this_disk when rdev->desc_nr is -1 corrupt on-disk RAID
metadata and cause a skipped spare or faulty disk to impersonate disk 0?

super_90_sync() initializes next_spare =3D mddev->raid_disks and increments=
 it
for each non-active (faulty or spare) rdev, so even an array with at most
MD_SB_DISKS (27) total bound devices reaches desc_nr >=3D MD_SB_DISKS whene=
ver
raid_disks plus the number of faulty/spare devices exceeds 27 (for example,=
 a
27-disk array with one failed slot).  When that rdev is skipped, its
rdev->desc_nr is left at -1, and super_90_sync() zeroes sb->this_disk
(setting sb->this_disk.number =3D 0) with a valid checksum before md_update=
_sb()
writes that superblock to the skipped device.

On the next array assembly, super_90_load() sets rdev->desc_nr =3D
sb->this_disk.number (0) and super_90_validate() indexes sb->disks[0],
treating the skipped faulty or spare device as active in-sync slot 0.  In
addition, leaving rdev->desc_nr =3D=3D -1 on a bound rdev in memory causes
super_90_validate() to read sb->disks[-1] out of bounds if called on that
rdev.

> @@ -3374,6 +3391,10 @@ slot_store(struct md_rdev *rdev, const char *buf, =
size_t len)
>  		if (slot >=3D rdev->mddev->raid_disks &&
>  		    slot >=3D rdev->mddev->raid_disks + rdev->mddev->delta_disks)
>  			return -ENOSPC;
> +		if (rdev->mddev->persistent &&
> +		    rdev->mddev->major_version =3D=3D 0 &&
> +		    slot >=3D MD_SB_DISKS)
> +			return -ENOSPC;
>  		rdev->raid_disk =3D slot;
>  		/* assume it is working */
>  		clear_bit(Faulty, &rdev->flags);
> @@ -4462,8 +4483,14 @@ raid_disks_store(struct mddev *mddev, const char *=
buf, size_t len)
>  		mddev->delta_disks =3D n - olddisks;
>  		mddev->raid_disks =3D n;
>  		mddev->reshape_backwards =3D (mddev->delta_disks < 0);
> -	} else
> -		mddev->raid_disks =3D n;
> +	} else {
> +		if ((mddev->persistent && mddev->major_version =3D=3D 0 &&
> +		     n > MD_SB_DISKS) ||
> +		    (mddev->max_disks && n > mddev->max_disks))
> +			err =3D -EINVAL;
> +		else
> +			mddev->raid_disks =3D n;
> +	}
>  out_unlock:
>  	memalloc_noio_restore(noio_flags);
>  	mddev_unlock_and_resume(mddev);

[Severity: Medium]
Can userspace still configure a persistent v0.90 array with raid_disks >
MD_SB_DISKS or slot >=3D MD_SB_DISKS through other sysfs paths?

First, in raid_disks_store(), the new bounds check is only in the final else
branch; if mddev->reshape_position !=3D MaxSector on an inactive array, the
else-if branch still assigns mddev->raid_disks =3D n without checking
MD_SB_DISKS or mddev->max_disks.  Second, if userspace writes raid_disks (or
slot) before writing "0.90" to metadata_version, mddev->persistent is still=
 0
during raid_disks_store(), and metadata_store() then enables persistent v0.=
90
metadata without validating mddev->raid_disks <=3D MD_SB_DISKS or setting
mddev->max_disks =3D MD_SB_DISKS.  Because mddev->max_disks remains 0 for a
sysfs-configured v0.90 array, resizing an active array via
update_raid_disks() (and hot-adding a slot in the rdev->mddev->pers !=3D NU=
LL
branch of slot_store()) also misses the MD_SB_DISKS limit.

[Severity: Critical]
This problem wasn't introduced by this patch, but raid_disks_store() and
metadata_store() still allow an unvalidated raid_disks value [1] to
cause an out-of-bounds write in super_1_sync().

When an inactive array has mddev->max_disks =3D=3D 0 (such as a newly creat=
ed
array using v1.x metadata, or before metadata_store() sets the metadata
version), raid_disks_store() accepts an arbitrarily large n into
mddev->raid_disks.  When a device is bound, bind_rdev_to_array() assigns
rdev->desc_nr >=3D mddev->raid_disks, and super_1_sync() then uses
rdev->desc_nr + 1 as max_dev to write past the end of sb->dev_roles[] and
the allocated superblock page:

drivers/md/md.c:super_1_sync() {
    ...
	max_dev =3D 0;
	rdev_for_each(rdev2, mddev)
		if (rdev2->desc_nr+1 > max_dev)
			max_dev =3D rdev2->desc_nr+1;

	if (max_dev > le32_to_cpu(sb->max_dev))
		sb->max_dev =3D cpu_to_le32(max_dev);
	for (i=3D0; i<max_dev;i++)
		sb->dev_roles[i] =3D cpu_to_le16(MD_DISK_ROLE_SPARE);
    ...
}

> @@ -7951,6 +7978,15 @@ int md_set_array_info(struct mddev *mddev, struct =
mdu_array_info_s *info)
>  		mddev->ctime         =3D ktime_get_real_seconds();
>  		return 0;
>  	}
> +
> +	if (info->raid_disks < 0 ||
> +	    (!info->not_persistent && info->major_version =3D=3D 0 &&
> +	     info->raid_disks > MD_SB_DISKS)) {
> +		pr_warn("md: %s: invalid raid_disks %d for v0.90 superblock\n",
> +			mdname(mddev), info->raid_disks);
> +		return -EINVAL;
> +	}
> +
>  	mddev->major_version =3D MD_MAJOR_VERSION;
>  	mddev->minor_version =3D MD_MINOR_VERSION;
>  	mddev->patch_version =3D MD_PATCHLEVEL_VERSION;

[Severity: Medium]
Can a caller bypass this MD_SB_DISKS check by passing a non-zero
info->major_version when info->raid_disks !=3D 0?

Immediately after this check, md_set_array_info() unconditionally sets
mddev->major_version =3D MD_MAJOR_VERSION (0) and mddev->minor_version =3D
MD_MINOR_VERSION (90), ignoring info->major_version.  Passing
info->major_version !=3D 0 with info->not_persistent =3D=3D 0 and info->rai=
d_disks
> MD_SB_DISKS therefore skips the check and still configures a persistent
v0.90 array with mddev->raid_disks > MD_SB_DISKS.

[1] https://sashiko.dev/#/bug/linux-9f7b36a9-e962-4efb-bbdc-83b85f2d807a

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113152311.1394=
9-1-chandradhar.2003@gmail.com?part=3D1
