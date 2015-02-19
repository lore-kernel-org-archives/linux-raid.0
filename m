From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] [md] raid5: check faulty flag for array status during
 recovery.
Date: Fri, 20 Feb 2015 08:51:47 +1100
Message-ID: <20150220085147.03bb2247@notabene.brown>
References: <94BC57C5-6223-435B-96FD-7DA2F6B4E561@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/eR02ni6twka9t2_deW7n7_N"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <94BC57C5-6223-435B-96FD-7DA2F6B4E561@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org, eric.mei@seagate.com
List-Id: linux-raid.ids

--Sig_/eR02ni6twka9t2_deW7n7_N
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Jan 2015 15:24:24 -0700 Eric Mei <meijia@gmail.com> wrote:

> Hi Neil,
>=20
> In a MDRAID derived work we found and fixed a data corruption bug. We thi=
nk this also affect vanilla MDRAID, but we didn=E2=80=99t directly prove th=
at by constructing a test to show the corruption. Following is the theoreti=
cal analysis, please kindly review and see if I missed something.
>=20
> To rebuild a stripe, MD checks whether array will be optimal after rebuil=
d complete, if that=E2=80=99s true, we=E2=80=99ll mark the WIB bit to be cl=
eared, the purpose is to enable =E2=80=9Cincremental rebuild=E2=80=9D. The =
code section is like this:
>=20
> 	/* Need to check if array will still be degraded after recovery/resync
> 	 * We don't need to check the 'failed' flag as when that gets set,
> 	 * recovery aborts.
> 	 */
> 	for (i =3D 0; i < conf->raid_disks; i++)
> 		if (conf->disks[i].rdev =3D=3D NULL)
> 			still_degraded =3D 1;
>=20
> The problem is that only checking rdev =3D=3D NULL might not be enough. S=
uppose both 2 drives D0 and D1 failed and marked as Faulty; We immediately =
removed D0 from array, but because some lingering IO on D1, it remains in a=
rray with Faulty flags on. A new drive pulled in, rebuild against D0 starts=
. Now because no rdev is NULL, MD thinks array will be optimal. If some wri=
tes happened before rebuild reaches the region, their dirty bits in WIB wil=
l be cleared. When later add D1 back into array, we=E2=80=99ll skip rebuild=
ing those stripes, thus data corruption.
>=20
> The attached patch (against 3.18.0-rc6) is supposed to fix this issue.
>=20
> Thanks
> Eric
>=20

Hi Eric,
 sorry for the delay, and thanks for the reminder...

The issue you described could only affect RAID6 as it requires the array to
continue with two failed drives.

However in the RAID6 case I think you are correct - there is a chance of
corruption if there is a double failure and a delay in removing one device.

Your patch isn't quite safe as conf->disks[i].rdev can become NULL at any
moment, so it could become NULL between testing and de-referencing.
So I've modified it as follows.

Thanks,
NeilBrown



Author: Eric Mei <eric.mei@seagate.com>
Date:   Tue Jan 6 09:35:02 2015 -0800

    raid5: check faulty flag for array status during recovery.
   =20
    When we have more than 1 drive failure, it's possible we start
    rebuild one drive while leaving another faulty drive in array.
    To determine whether array will be optimal after building, current
    code only check whether a drive is missing, which could potentially
    lead to data corruption. This patch is to add checking Faulty flag.
   =20
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bc6d7595ad76..022a0d99e110 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5120,12 +5120,17 @@ static inline sector_t sync_request(struct mddev *m=
ddev, sector_t sector_nr, int
 		schedule_timeout_uninterruptible(1);
 	}
 	/* Need to check if array will still be degraded after recovery/resync
-	 * We don't need to check the 'failed' flag as when that gets set,
-	 * recovery aborts.
+	 * Note in case of > 1 drive failures it's possible we're rebuilding
+	 * one drive while leaving another faulty drive in array.
 	 */
-	for (i =3D 0; i < conf->raid_disks; i++)
-		if (conf->disks[i].rdev =3D=3D NULL)
+	rcu_read_lock();
+	for (i =3D 0; i < conf->raid_disks; i++) {
+		struct md_rdev *rdev =3D ACCESS_ONCE(conf->disks[i].rdev);
+
+		if (rdev =3D=3D NULL || test_bit(Faulty, &rdev->flags))
 			still_degraded =3D 1;
+	}
+	rcu_read_unlock();
=20
 	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
=20

--Sig_/eR02ni6twka9t2_deW7n7_N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOZa8znsnt1WYoG5AQLdVg/+PayV2IPMVO12Kx2De0DO5B8b3sOnsAwF
uH3hdYuz+8qFbO5wlHatus/5hGkWZflsaI36mI41M2mFWANraGxVdxV9hker1fhp
9/m1q+00vU/nkNRzgSuWjHhacCtwwHJcTWo6aCUqMf31CdYUe9Wzo7qcHj/NOwDu
PHFfWgZbKV7MdFKb/zQyXmpt305wjdeIVjxdDlOIwvxB9Js+HRvM2joGsERvHLSq
miOdgQHuj2YEFgxrJeT418uvVwkvAczloqzQh/HdwjMNghQxaK2Kc8NyEoZCsHSP
A+nxgj7kuwjQHB4XY7fIHCC0zy9zLvhGcHvKr9XJR9qz34LPliS3K4Oj4sGrmw6o
AC/RwE0lvZ4SkfgagvVnyRQ0yfTUw5Fl7mMpdCgz0p9sEH2LFfIYoj7czMg7pojk
B5rBB9woayQ/gzgvGIN/sS6sSbi2RJLojOGhNEWxWDP1tW9SpP4jqRbq6Os0mrys
bF6VLtJJG8vzom1QHpBlzVgix3nVv2QYGAi3y6Z3IZLip9kFu/r3lEubs4UtWqMB
yejNNqvaa3k6lp267EjWbiNK3vMidr95WKjTEvF/WQQ1uSC+eisS9DuI5YvmAldk
pVZhLM7ikPWl6XBGWL9VQLVnrFqWRjTdgwVB+jmv97uYoG6IiPvw0n4H4X3tszGC
fGkLhiJgl4c=
=qL1u
-----END PGP SIGNATURE-----

--Sig_/eR02ni6twka9t2_deW7n7_N--
