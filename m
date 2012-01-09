From: NeilBrown <neilb@suse.de>
Subject: Re: raid 1 bug with write-mostly and administrative failed disk
Date: Mon, 9 Jan 2012 12:34:03 +1100
Message-ID: <20120109123403.1286fd36@notabene.brown>
References: <20120105213023.GB3692@telegraafnet.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WdTNIi=Cu5H0+ISRDKoe7eC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120105213023.GB3692@telegraafnet.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WdTNIi=Cu5H0+ISRDKoe7eC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jan 2012 22:30:23 +0100 Art -kwaak- van Breemen
<ard@telegraafnet.nl> wrote:

> Hi,
>=20
> Please Cc: me too as I am trying to subscribe to the list.
>=20
> Anyway: I found a small bug in raid1, with write-behind and
> write-mostly, occuring at least on 3.1.4 and 3.2 .
>=20
> This is the test setup:
> mdadm --stop /dev/md5
> mdadm --zero-superblock /dev/sda8
> mdadm --zero-superblock /dev/sdb8
> mdadm --create -l 1 -n 2 --metadata=3D0.90 --bitmap=3Dinternal --bitmap-c=
hunk=3D1024 --write-behind=3D2048 /dev/md5 /dev/sdb8 -W /dev/sda8
> (wait until finished)
> mdadm --fail /dev/md5 /dev/sdb8
> # And this to trigger the bug:
> dd if=3D/dev/md5 of=3D/dev/null bs=3D10k count=3D1
>=20

Thanks for the excellent bug report.

I never tested write-behind :-(

Please confirm that this patch fixes it for you.

NeilBrown


diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc24f0c..a368db2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -531,8 +531,17 @@ static int read_balance(struct r1conf *conf, struct r1=
bio *r1_bio, int *max_sect
 		if (test_bit(WriteMostly, &rdev->flags)) {
 			/* Don't balance among write-mostly, just
 			 * use the first as a last resort */
-			if (best_disk < 0)
+			if (best_disk < 0) {
+				if (is_badblock(rdev, this_sector, sectors,
+						&first_bad, &bad_sectors)) {
+					if (first_bad < this_sector)
+						/* Cannot use this */
+						continue;
+					best_good_sectors =3D first_bad - this_sector;
+				} else
+					best_good_sectors =3D sectors;
 				best_disk =3D disk;
+			}
 			continue;
 		}
 		/* This is a reasonable device to use.  It might

--Sig_/WdTNIi=Cu5H0+ISRDKoe7eC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwpECznsnt1WYoG5AQJx5BAArMFHu4+GRh5rzmGUYOXRnvKQkvAecWeY
bi3i1ZZd20g0FdS/rqocoQYb4uLiKCDGTteYlN1M/EI/XiXr7JuBqt7s0RzxxCrs
aP+EGh7BAOpy81+Gcmlk+jvXCyiBgedXWW6jgDqzUc6wcBWbAE8lO1ZbG99j5CZw
Sq8PUhCVmfE7+nszPz4Cb/xcu7yP2uTGrWIawfzArXuqXJNdIgG870XN0OdM5yhy
SV/Vjt4qa7MlT1x0mlWHfeIRVzTI0IGGlx8zfCBdxM3IaN7N65B321knTObzvr7c
y6zBHCIbAMfypda3+NcIHNx2Ejjxrf8N4RUoW6CRDR7VI4fTP2Qxy/KMPkjrDvZm
jxDkLFSIbrHqTJeXOK1o8Um8R8hycpP6Q8oHsqwi4a9/HAsJGt0HVfHZDTQvB3Q1
eApiQ/alYM6tuTXR/yg+0a0SXGkhLjfprVxLFu5CatkMSitJYh+yeOSmOxTVsDpK
CpxhUgUkWIAB1fbbALO3SqVtqoE45xmB4kM34Vl1XEfEldgcJooDUoWGtoggQm82
p5qVWRYD7F2nG1i6CRO2lLFYWUEUAM87A1soRQYlh3nF8+yluu3uA1VhpXxLlLvL
u+WOsilFu37IlO/6QJuBeSmnx1+y9jfAS2ZUR4Qsu3kDD5MfUEnodpxkE5+R6J0m
wXJLkiA8eRk=
=4eB7
-----END PGP SIGNATURE-----

--Sig_/WdTNIi=Cu5H0+ISRDKoe7eC--
