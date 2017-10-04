From: NeilBrown <neilb@suse.com>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Wed, 04 Oct 2017 11:49:00 +1100
Message-ID: <87lgkr3fgj.fsf@notabene.neil.brown.name>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org> <871sn78pzt.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se> <874ls0s7un.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 01 2017, Mikael Abrahamsson wrote:

> On Mon, 18 Sep 2017, NeilBrown wrote:
>
>> Anyway, thanks for the example of a real problem related to this.  It=20
>> does make it easier to think about.
>
> Btw, if someone does --zero-superblock or dd /dev/zero to to a component=
=20
> device that is active, what happens when mdadm --stop /dev/mdX is run?=20
> Does it write out the complete superblock again?

=2D-zero-superblock won't work on a device that is currently part of an
array.  dd /dev/zero will.
When the array is stopped the metadata will be written if the array is
not read-only and is not clean.
So for 'linear' and 'raid0' it is never written.  For others it probably
is but may not be.
I'm not sure that forcing a write makes sense.  A dd could corrupt lots
of stuff, and just saving the metadata is not a big win.

I've been playing with some code, and this patch makes it impossible to
write to a device which is in-use by md.
Well... not exactly.  If a partition is in-use by md, the whole device
can still be written to.  But the partition itself cannot.
Also if metadata is managed by user-space, writes are still allowed.
To fix that, we would need to capture each write request and validate
the sector range.  Not impossible, but ugly.

Also, by itself, this patch breaks the use of raid6check on an active
array.  We could fix that by enabling writes whenever a region is
suspended.

Still... maybe it is a starting point for thinking about the problem.

NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ff1bbf6c90e..7c469cd9febc 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2264,6 +2264,7 @@ static int lock_rdev(struct md_rdev *rdev, dev_t dev,=
 int shared)
 		pr_warn("md: could not open %s.\n", __bdevname(dev, b));
 		return PTR_ERR(bdev);
 	}
+	bdev->bd_holder_only_writes =3D !shared;
 	rdev->bdev =3D bdev;
 	return err;
 }
@@ -2272,6 +2273,7 @@ static void unlock_rdev(struct md_rdev *rdev)
 {
 	struct block_device *bdev =3D rdev->bdev;
 	rdev->bdev =3D NULL;
+	bdev->bd_holder_only_writes =3D 0;
 	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
=20
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 93d088ffc05c..673b71bac731 100644
=2D-- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1816,10 +1816,14 @@ void blkdev_put(struct block_device *bdev, fmode_t =
mode)
 		WARN_ON_ONCE(--bdev->bd_contains->bd_holders < 0);
=20
 		/* bd_contains might point to self, check in a separate step */
=2D		if ((bdev_free =3D !bdev->bd_holders))
+		if ((bdev_free =3D !bdev->bd_holders)) {
+			bdev->bd_holder_only_writes =3D 0;
 			bdev->bd_holder =3D NULL;
=2D		if (!bdev->bd_contains->bd_holders)
+		}
+		if (!bdev->bd_contains->bd_holders) {
+			bdev->bd_contains->bd_holder_only_writes =3D 0;
 			bdev->bd_contains->bd_holder =3D NULL;
+		}
=20
 		spin_unlock(&bdev_lock);
=20
@@ -1884,8 +1888,13 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct=
 iov_iter *from)
 	loff_t size =3D i_size_read(bd_inode);
 	struct blk_plug plug;
 	ssize_t ret;
+	struct block_device *bdev =3D I_BDEV(bd_inode);
=20
=2D	if (bdev_read_only(I_BDEV(bd_inode)))
+	if (bdev_read_only(bdev))
+		return -EPERM;
+	if (bdev->bd_holder !=3D NULL &&
+	    bdev->bd_holder_only_writes &&
+	    bdev->bd_holder !=3D file)
 		return -EPERM;
=20
 	if (!iov_iter_count(from))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 339e73742e73..79e3a2822867 100644
=2D-- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -424,6 +424,7 @@ struct block_device {
 	void *			bd_holder;
 	int			bd_holders;
 	bool			bd_write_holder;
+	bool			bd_holder_only_writes;
 #ifdef CONFIG_SYSFS
 	struct list_head	bd_holder_disks;
 #endif

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnUL/4ACgkQOeye3VZi
gbkz2g/8D9GHANtdtRGfVeRt+m0Gn2lujSxnBaTwXWS6Jj5h74N4D7PU2rmwumDo
EF/tRxUBXET7xV2LWmMsIvyTIHtvFWNJRT26J54oKijh6OLO+C8nURgmiHELJvQl
apFDwfDdHgkdj5xwzO3jRmsRTIzFP7ILiXivQ5C3LpNP+cklX9rHKKJnwAUvosFJ
58J0kxjjRx+n8FnmAYUklDGd31XTcudu9VeLk5qUOm9nDAgoMj7SuD3Qyv3YLAJM
yR1f8JlzJ/0zQxcm5VzNUqbGyL84VME8oZltWRDREc3zqvKHgQkN1Fz7eDzUmy0F
LL4ZhoCNM5Nj1I1NowjRC4c2A14LWryrNplDvHsRFCo8LSSD/W+BonmK9vj8NPUD
ij2jVALgwUdpKZDidtFIIEknri6zQHbJ2Zdv7q1uwLqrKi46FD/9o/IIT9Xakl9I
ytB6Iw85oQCKrl9IXdGSycM4Ap+B5KMGnopGeCzDcHTNAV8eK1ZR7PQYVFpyn7yt
8fUK6qxLgQaFI5dKo5cr5X1oEyoPkbh4qjA8GEUAkKTxkUwnl4NoPe/sXJ41Nqcg
9POlj/KcSoJukGKZI5AK5pShxf7Sg/NWBPNmVGm0WhrLI7WoyPR76c+wECwUVgSi
KHozjpkI/cQN4g+keCypL4b/5Sy3j2PDKlJJ2lhMCqoHk513eSQ=
=GK8l
-----END PGP SIGNATURE-----
--=-=-=--
