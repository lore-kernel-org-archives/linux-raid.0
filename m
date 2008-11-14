From: Andre Noll <maan@systemlinux.org>
Subject: Re: typo in raid[456] kernel code/no change based on type?
Date: Fri, 14 Nov 2008 13:19:42 +0100
Message-ID: <20081114121942.GN17966@skl-net.de>
References: <alpine.DEB.1.10.0811121855470.10512@p34.internal.lan> <alpine.DEB.1.10.0811121858300.10512@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kK1uqZGE6pgsGNyR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811121858300.10512@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:58, Justin Piszcz wrote:

> >md3 : active raid6 sdj1[10] sdc1[4] sdl1[8] sdk1[1] sdi1[9] sdh1[7]=20

[snip]

> >[ 6982.273208] RAID5 conf printout:
> >              ^^^^^

Please try the patch below which fixes this inconsistency.

Andre

commit 6c2f32376c59f08a893cd4736d92f000618dd88f
Author: Andre Noll <maan@systemlinux.org>
Date:   Fri Nov 14 13:31:56 2008 +0100

    Improve raid printout for raid levels 4 and 6.
   =20
    As noted by Justin Piszcz we currently log a "RAID5 conf printout:" mes=
sage
    also for raid4 and raid6 arrays. This trivial patch prints the correct =
raid
    level, adds KERN_INFO to all printk's in print_raid5_conf() and fixes a=
 minor
    coding style issue.
   =20
    Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a36a743..7920b26 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4343,24 +4343,24 @@ static void status(struct seq_file *seq, mddev_t *m=
ddev)
 #endif
 }
=20
-static void print_raid5_conf (raid5_conf_t *conf)
+static void print_raid5_conf(raid5_conf_t *conf)
 {
 	int i;
 	struct disk_info *tmp;
=20
-	printk("RAID5 conf printout:\n");
 	if (!conf) {
-		printk("(conf=3D=3DNULL)\n");
+		printk(KERN_INFO "RAID 4/5/6: (conf=3D=3DNULL)\n");
 		return;
 	}
-	printk(" --- rd:%d wd:%d\n", conf->raid_disks,
-		 conf->raid_disks - conf->mddev->degraded);
+	printk(KERN_INFO "RAID%d printout:\n", conf->level);
+	printk(KERN_INFO " --- rd:%d wd:%d\n", conf->raid_disks,
+		conf->raid_disks - conf->mddev->degraded);
=20
 	for (i =3D 0; i < conf->raid_disks; i++) {
 		char b[BDEVNAME_SIZE];
 		tmp =3D conf->disks + i;
 		if (tmp->rdev)
-		printk(" disk %d, o:%d, dev:%s\n",
+		printk(KERN_INFO " disk %d, o:%d, dev:%s\n",
 			i, !test_bit(Faulty, &tmp->rdev->flags),
 			bdevname(tmp->rdev->bdev,b));
 	}
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--kK1uqZGE6pgsGNyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJHWzdWto1QDEAkw8RAg1XAJ9Hzh4T0Wj8Uko482nXJib0Dx6AqQCfXveI
yZrKbZqc2td6tYVYpCAuGBc=
=B/SQ
-----END PGP SIGNATURE-----

--kK1uqZGE6pgsGNyR--
