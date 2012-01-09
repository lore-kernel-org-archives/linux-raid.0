From: NeilBrown <neilb@suse.de>
Subject: Re: polling mdX/md/degraded in sysfs
Date: Mon, 9 Jan 2012 11:44:33 +1100
Message-ID: <20120109114433.6cf3c47a@notabene.brown>
References: <CAC9iW=taiG0=JOXcrEDOWKoHswEAp1uRTP2UP=4MepBXNf2Lrg@mail.gmail.com>
	<CAGRgLy5CsmEU_-GnvXH3ffqK4Wnj7V6a_-TWnhA3ysbo2HKGqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=Ydl/YNZX6.dyw9kL77I.++"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5CsmEU_-GnvXH3ffqK4Wnj7V6a_-TWnhA3ysbo2HKGqQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: Mikhail Balabin <mbalabin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=Ydl/YNZX6.dyw9kL77I.++
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Jan 2012 11:06:59 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi,
> well, at least according to 2.6.38-8 kernel code, this attribute is
> notified in 3 cases:
> # When the array is started (e.g., via RUN_ARRAY ioctl)
> # When "reshape" is initiated via sysfs
> # When a spare is activated after successful completion of
> resync/recover/check/replair
>=20

Hmm... it really should notify when a disk fails.

Mikhail: could you please test if this patch makes it work better for you?

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c1c562..33aa06f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7383,6 +7383,7 @@ static int remove_and_add_spares(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	int spares =3D 0;
+	int removed =3D 0;
=20
 	mddev->curr_resync_completed =3D 0;
=20
@@ -7396,8 +7397,13 @@ static int remove_and_add_spares(struct mddev *mddev)
 				    mddev, rdev) =3D=3D 0) {
 				sysfs_unlink_rdev(mddev, rdev);
 				rdev->raid_disk =3D -1;
+				removed++;
 			}
 		}
+	if (removed)
+		sysfs_notify(&mddev->kobj, NULL,
+			     "degraded");
+
=20
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		if (rdev->raid_disk >=3D 0 &&

--Sig_/=Ydl/YNZX6.dyw9kL77I.++
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwo4cTnsnt1WYoG5AQJxmxAAlsRPIAWyjRJ8veOCLaIIA6SDwXEB/54q
WNV75N2q/0ZJpjcteCzkgXOWRp5BHlP1f8LJrHcRVJhDQ6qK37wXggCinAo0EASz
dyiJl+ysahjNSqk2tVQTEBuuVx7UUUfXqyMk5NMQGAAzMPxA1vdYGhDQZQnvnUG/
3tKgtcatXAyioRjztjIBpXjj1cxGMEuYdA8NOpbby2M3Q1IwqdOy36Fbbu/KEqz2
NFaNPA+W8OnfYD2aNfyVPmrcBBkuKARSbkQjufYrh0370PTDQwlrnTQrSTG3ka1q
IZgL0PHNhJTH+jfRA++hW4hPCATZUVXXy8DOd9QKvl2JVkXMWbENhPis+9106fVq
tE5WvIe5izvFjvIjnnVYhPEPoJIBJz2W0lRIHX7lmKemtkLk10RTxcIJQ3kPg8oy
WIL9tFp3gJ1Rb3IaXSoyLhdGuK/xymxhRxkICpj6IWdZyxzPgidtF2Sx9dKX55Hb
kQBekuuNWpcY7dqkzWigNS+mbb//5BTT6zdoasFDEFkpwaXZMqjITPwhO74Uqloi
fvT82BiaxEYb7qvT6qQf+n3BjmKHuZdqErK4w+RMi4tr0P9ZyIneBBBcyVwIRi8l
NZCegsUNcKR9069AWaI6wdFUV73V2r3LxNMmzv10fTDlM5JsAwlI6/xmnpwtPZo5
ErF3rEVwLd4=
=P9Vf
-----END PGP SIGNATURE-----

--Sig_/=Ydl/YNZX6.dyw9kL77I.++--
