From: NeilBrown <neilb@suse.de>
Subject: Re: Problem with patch: "reject a re-add request that cannot be
 honoured" (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Thu, 7 Jun 2012 20:26:28 +1000
Message-ID: <20120607202628.40ee4062@notabene.brown>
References: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iTVjsb2upsnijjmrB6sWd3F"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/iTVjsb2upsnijjmrB6sWd3F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Jun 2012 19:09:25 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> it looks like we are hitting an issue with this patch.
> Kernel is stock ubuntu-precise (3.2.0-23 36), mdadm is v3.2.3. (We are
> aware that this version of mdadm has an issue of unaligned writes, so
> we backported the fix to it into this version).
>=20
> We are testing the following simple scenario:
> # 2-way raid1 with a missing drive
> # a fresh drive (no superblock) is added (not re-added) to the raid,
> and the raid happily starts rebuilding it
> # at some point in time, this drive fails, so rebuild aborts, drive is
> kicked out.
> # later the drive recovers and "mdadm remove & re-add" is attempted
> # re-add fails

Hmm.. I guess we should drop the "In_sync" test and just keep the "raid_dis=
k"
part of the test?

>=20
> Some debugging suggests the following:
>=20
> - The superblock of the drive to be re-added looks like this:
>=20
>  Avail Dev Size : 10483712 (5.00 GiB 5.37 GB)
>      Array Size : 10483688 (5.00 GiB 5.37 GB)
>   Used Dev Size : 10483688 (5.00 GiB 5.37 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
> Recovery Offset : 100096 sectors
>           State : clean
>   Resync Offset : N/A sectors
>     Device UUID : d9114d02:76153894:87aaf09d:c55da9be
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Jun  6 18:36:55 2012
>        Checksum : 94468c9d - correct
>          Events : 192
>    Device Role : Active device 1
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> So the drive has a valid recovery offset (MD_FEATURE_RECOVERY_OFFSET
> set) and a valid role.
>=20
> - The "re-add" path of mdadm performs calls getinfo_super1(), which perfo=
rms:
> role =3D __le16_to_cpu(sb->dev_roles[__le32_to_cpu(sb->dev_number)]);
> ...
> info->disk.state =3D 6; /* active and in sync */
> info->disk.raid_disk =3D role;
>=20
> So at this point, MD_DISK_ACTIVE and MD_DISK_SYNC are set.
>=20
> - mdadm issues ADD_NEW_DISK, which arrives to add_new_disk() in the kernel
> - the kernel performs:
> if (!mddev->persistent) {
> ... // not relevant to our case
> } else
> 	super_types[mddev->major_version].
> 		validate_super(mddev, rdev);
>=20
> - validate_super() performs:
> 	if ((le32_to_cpu(sb->feature_map) &
> 	     MD_FEATURE_RECOVERY_OFFSET))
> 		rdev->recovery_offset =3D le64_to_cpu(sb->recovery_offset);
> 	else
> 		set_bit(In_sync, &rdev->flags);
> 	rdev->raid_disk =3D role;
>=20
> So In_sync flag is not set, because we have a recovery offset.
>=20
> - Then the code introduced by the patch does:
> 	if ((info->state & (1<<MD_DISK_SYNC)) &&
> 	    (!test_bit(In_sync, &rdev->flags) ||
> 	     rdev->raid_disk !=3D info->raid_disk)) {
> 		/* This was a hot-add request, but events doesn't
> 		 * match, so reject it.
> 		 */
> 		export_rdev(rdev);
> 		return -EINVAL;
> 	}
>=20
> So the first part of "OR" succeeds and we abort.
>=20
> An observation: this problem only happens with a fresh drive
> apparently. If drive that was already In_sync fails and then is
> re-added, kernel does not update its superblock until recovery
> completes. So its superblock has no valid recovery_offset, and this
> problem doesn't happen. The code that skips updating the superblock
> was added as part of this email thread:
> http://www.spinics.net/lists/raid/msg36275.html. However, I did not
> dig deeper why the superblock gets updated in my case. But the
> scenario above repros easily.
>=20
> Q1: Can you confirm that my analysis is correct?

Looks about  right.

> Q2: Is this an expected behavior? I would assume that no, because the
> same case for a failed drive (not a fresh drive) works fine

It is a case that I hadn't really thought about (re-adding a drive that was
partially recovered), so in a sense, no behaviour is expected :-)
I agree it isn't desirable behaviour.

> Q3: How would you recommend to handle this?

1/ Change the coded added by the commit to remove the
      !test_bit(In_sync, &rdev->flags) ||
  section.
2/ Possibly backport mdadm commit 0a999759b54f94fd63ac0
  This will allow --add to work in more cases.  I'm not sure if you
  are hitting this issue or not.

Please let me know how '1' goes and I'll get that fix upstream.

Thanks,
NeilBrown


>=20
> Thanks!
> Alex.


--Sig_/iTVjsb2upsnijjmrB6sWd3F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9CB1Dnsnt1WYoG5AQJd4hAAkyDWe0QL7ub+01IlmslgO8nvIN8T2pvI
XqMx8OhLZVzZ37s+9vRXFu7sZynIt/cFfJ6ntPm/Rha5K9z4NdkL9rXHVsOQt3sd
e2ub4y5BgJRNH43UmwKPSghPnWUjAH7AucsxYx5+N3eRSpDwxYKcbnUpA2ZbrjmE
qGwY19Vjb8Zfwh2KOyUjPehn2pcEudnWTWUCMgBiRbzEMjhDPYP1krd74V17Eqbb
dBBVU+YCSjSXh8Bh5eIATZcKyK6YGp/seQ+4pc3/4iGW2QWOP4gztiX/CauuID9C
Dj72gU32q5XK4V9LyIDDaKod/uA7adI1GkpYMh+CXYaZwjK2LAjZ+z3tHpKvfp/8
DuiujDTrq9qOd4iA0GklKavZqAwODW+h80ehRF39M1UMYMtAgXYHE4+LtOJNv5PN
ae17R4X3T+K5Pwvql5f7lUXSwWPs1iyrC1nNst5ntQW7q61w8VvkiFxG6mFVXrV1
Z+si9aOTBnms2e/2hWwOyCYt9dkyFyCHLduK67+zRYkpaaITM7mGQmpEknoLKxzf
k0+5lpIeVOMjm43PI83QLbhqCsC5y1hMeIdGmrJAjiyfJP3/SWBVkyZHtXGoIb56
kZWhAqYiXX2tcq1ixIpUGX0CJtwfKEHCWw/mOHinPmd5wKByr8WQE6f+LtoveO3E
FaJXT+U1uu8=
=BReQ
-----END PGP SIGNATURE-----

--Sig_/iTVjsb2upsnijjmrB6sWd3F--
