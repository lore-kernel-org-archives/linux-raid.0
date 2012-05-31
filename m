From: NeilBrown <neilb@suse.de>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Thu, 31 May 2012 15:42:56 +1000
Message-ID: <20120531154256.6eb567c7@notabene.brown>
References: <4FBA0047.5050208@profitbricks.com>
	<20120522092817.1b5946b8@notabene.brown>
	<4FBF7CAD.7000307@profitbricks.com>
	<20120528140505.6eb49b26@notabene.brown>
	<4FC49733.9050905@profitbricks.com>
	<20120529202559.6aa7fd49@notabene.brown>
	<4FC61A94.3050605@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iLxks1Kcss4i7zBQpI.rYuT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC61A94.3050605@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iLxks1Kcss4i7zBQpI.rYuT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 May 2012 15:03:16 +0200 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> On 29/05/12 12:25, NeilBrown wrote:
> > On Tue, 29 May 2012 11:30:27 +0200 Sebastian Riemer
> > <sebastian.riemer@profitbricks.com> wrote:
> >> Now, I've updated mdadm to version 3.2.5 and it works like you've
> >> described it. Thanks for your help! But the buffered IO is what matter=
s.
> >> 4k isn't enough there. Please inform me about changes which increase t=
he
> >> size in buffered IO. I'll have a look at this, too.
> >=20
> > I don't know.  I'd have to dive into the code and look around and put a=
 few
> > printks in to see what is happening.
>=20
> Now, I've configured a storage server with real HDDs for testing the
> cached IO with kernel 3.4. Here direct IO always doesn't work
> (Input/Output error with dd/fio). And cached IO is totally slow. My
> RAID0 devices are md100 and md200. The RAID1 on top is the md300.
>=20
> The md100 is reported as "faulty spare" and this has hit the following a
> kernel bug.
>=20
> This is the debug output:
>=20
> md/raid0:md100: make_request bug: can't convert block across chunks or
> bigger than 512k 541312 320
> md/raid0:md200: make_request bug: can't convert block across chunks or
> bigger than 512k 541312 320
> md/raid1:md300: Disk failure on md100, disabling device.
> md/raid1:md300: Operation continuing on 1 devices.
> RAID1 conf printout:
> --- wd:1 rd:2
> disk 0, wo:1, o:0, dev:md100
> disk 1, wo:0, o:1, dev:md200
> RAID1 conf printout:
> --- wd:1 rd:2
> disk 1, wo:0, o:1, dev:md200
> md/raid0:md200: make_request bug: can't convert block across chunks or
> bigger than 512k 2704000 320
>=20
> The chunk size of 320 KiB comes from max_sectors_kb of the LSI HW RAID
> controller where the drives are passed through as single drive RAID0
> logical devices. I guess this is a problem for MD RAID0 underneath the
> RAID1, because this doesn't fit as a multiple of the 512 KiB stripe size.

Hmmm... that's bad.  Looks like I have a bug .... yes I do.  Patch below
fixes it.  If you could test and confirm I would appreciated it.

As for the cached writes being always 4K - are you writing through a
filesystem or directly to /dev/md300??

If the former it is a bug in that filesystem.
If the later, it is a bug in fs/block_dev.c
In particular, fs/block_dev.c uses "generic_writepages" for the
"writepages" method rather than "mpage_writepages" (or a wrapper which
calls it with appropriate args).

'generic_writepages' simply calls ->writepage on each dirty page.
mpage_writepages (used e.g. by ext2) collects multiple pages into
a single bio.

The elevator at the device level should still collect these 1-page bios into
larger requests, but I guess that has higher CPU overhead.

thanks for the report.

NeilBrown

=46rom dd47a247ae226896205f753ad246cd40141aadf1 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 31 May 2012 15:39:11 +1000
Subject: [PATCH] md: raid1/raid10: fix problem with merge_bvec_fn

The new merge_bvec_fn which calls the corresponding function
in subsidiary devices requires that mddev->merge_check_needed
be set if any child has a merge_bvec_fn.

However were were only setting that when a device was hot-added,
not when a device was present from the start.

This bug was introduced in 3.4 so patch is suitable for 3.4.y
kernels.

Cc: stable@vger.kernel.org
Reported-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 15dd59b..d7e9577 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2548,6 +2548,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	err =3D -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	rdev_for_each(rdev, mddev) {
+		struct request_queue *q;
 		int disk_idx =3D rdev->raid_disk;
 		if (disk_idx >=3D mddev->raid_disks
 		    || disk_idx < 0)
@@ -2560,6 +2561,9 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		if (disk->rdev)
 			goto abort;
 		disk->rdev =3D rdev;
+		q =3D bdev_get_queue(rdev->bdev);
+		if (q->merge_bvec_fn)
+			mddev->merge_check_needed =3D 1;
=20
 		disk->head_position =3D 0;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3f91c2e..d037adb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3311,7 +3311,7 @@ static int run(struct mddev *mddev)
 				 (conf->raid_disks / conf->near_copies));
=20
 	rdev_for_each(rdev, mddev) {
-
+		struct request_queue *q;
 		disk_idx =3D rdev->raid_disk;
 		if (disk_idx >=3D conf->raid_disks
 		    || disk_idx < 0)
@@ -3327,6 +3327,9 @@ static int run(struct mddev *mddev)
 				goto out_free_conf;
 			disk->rdev =3D rdev;
 		}
+		q =3D bdev_get_queue(rdev->bdev);
+		if (q->merge_bvec_fn)
+			mddev->merge_check_needed =3D 1;
=20
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);

--Sig_/iLxks1Kcss4i7zBQpI.rYuT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8cE4Dnsnt1WYoG5AQJPEw/9FddbR7vOFX3oYAVnrCnOcxvIAazIujJt
hvM5CbMn8ACNWHeyRaWWp/uGpKaj55twT32xFbJi+XLrfVPOOBLyFlgYWVWiDMpp
z/ro9zRPACLwHQiI5ivIGQJ3qOihb6tqvqMwR3F3ZQQQHLfHHgJyYdcqG6Q/81WK
yhLyi616i4Lp1qMh/Cj4ygQ5l5xQXjaLMm48m75VWYO/ninrni9OUJMVsBdkFR85
UUfGv8bHyjqxFxVHjvUhABhZwjK6zCGjuHm68T9grcEZrF8HuUNC1l0+TKv3PyII
xeUo52BFdBAplDj4mWIaQx2Xr0Bxe8iHOlDVzYxekZkcyJuebc0ZR0SnFSQBCHtQ
/ehYmGBsvYJFCVoTr6pkV+CGGBUUo1GP0+8Ls+l3JY6Yd6OYAJS2ipKmJ038Zj+v
sSQHKRJkwDnnGojSEuRBCBlJqt4J5Rju5D3rWpzRZPVUELZ8CvihiFNTTt/x9SjT
fHpNTOoroFttOGRxoO+F8fwue9rPdP6LG54G1ZXaj/taWt077TuO6xKvHqsRypew
t7CdM1VkFU42r1gMOSrsRWk0PqGhVrmU5/1rdyBCH0WEd3bqGw3xEr5uVQjy3buX
xJNk0jF8AcZeVqjbXDUqY+W5JsIBD3B7V6BcQLJZz1KR+DdjfgCyYzaZ2Xw/9Idq
lOSZW7PsyEo=
=hSGc
-----END PGP SIGNATURE-----

--Sig_/iLxks1Kcss4i7zBQpI.rYuT--
