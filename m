From: NeilBrown <neilb@suse.de>
Subject: Re: Can't reshape raid0 to raid10
Date: Wed, 4 Feb 2015 17:39:21 +1100
Message-ID: <20150204173921.23df9d79@notabene.brown>
References: <1718053393.1731733.1419906625563.JavaMail.zimbra@redhat.com>
	<484995116.1735572.1419909221275.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4FYTFlpOlO1yQN0ylgJf1X6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484995116.1735572.1419909221275.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4FYTFlpOlO1yQN0ylgJf1X6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Dec 2014 22:13:41 -0500 (EST) Xiao Ni <xni@redhat.com> wrote:

> Hi Neil
>=20
>    When I try to reshape a raid0 to raid10, it'll fail like this:
>=20
> [root@dhcp-12-133 mdadm-3.3.2]# lsblk=20
> NAME                    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> sda                       8:0    0 111.8G  0 disk=20
> =E2=94=9C=E2=94=80sda1                    8:1    0  1000M  0 part /boot
> =E2=94=9C=E2=94=80sda2                    8:2    0  29.3G  0 part /
> =E2=94=9C=E2=94=80sda3                    8:3    0   512M  0 part [SWAP]
> =E2=94=9C=E2=94=80sda4                    8:4    0     1K  0 part=20
> =E2=94=9C=E2=94=80sda5                    8:5    0   102M  0 part=20
> =E2=94=94=E2=94=80sda6                    8:6    0  10.1G  0 part=20
>   =E2=94=94=E2=94=80VolGroup00-LogVol00 254:0    0   9.9G  0 lvm =20
> sdb                       8:16   0 111.8G  0 disk=20
> =E2=94=9C=E2=94=80sdb1                    8:17   0     2G  0 part=20
> =E2=94=94=E2=94=80sdb2                    8:18   0    10G  0 part=20
> sdc                       8:32   0 186.3G  0 disk=20
> =E2=94=9C=E2=94=80sdc1                    8:33   0     2G  0 part=20
> =E2=94=94=E2=94=80sdc2                    8:34   0    10G  0 part=20
> sdd                       8:48   0 111.8G  0 disk=20
> =E2=94=9C=E2=94=80sdd1                    8:49   0     2G  0 part=20
> =E2=94=94=E2=94=80sdd2                    8:50   0    10G  0 part=20
> [root@dhcp-12-133 mdadm-3.3.2]# mdadm -CR /dev/md0 -l0 -n3 /dev/sdb1 /dev=
/sdc1 /dev/sdd1=20
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> [root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l10 -a /dev/sdb2 /=
dev/sdc2 /dev/sdd2=20
> mdadm: level of /dev/md0 changed to raid10
> mdadm: add new device failed for /dev/sdb2 as 6: No space left on device
>=20
>   =20
>    But if I reshape the raid0 to raid5, reshape raid5 to raid0, then resh=
ape raid0 to raid10 use
> the same command it'll succeed.=20
>=20
> [root@dhcp-12-133 mdadm-3.3.2]# mdadm -CR /dev/md0 -l0 -n3 /dev/sdb1 /dev=
/sdc1 /dev/sdd1
> [root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l5
> [root@dhcp-12-133 mdadm-3.3.2]# cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4] [raid0] [raid10]=20
> md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]
>       6285312 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UU=
U_]
>      =20
> unused devices: <none>
>=20
> [root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l0
> [root@dhcp-12-133 mdadm-3.3.2]# cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4] [raid0] [raid10]=20
> md0 : active raid0 sdd1[2] sdc1[1] sdb1[0]
>       6285312 blocks super 1.2 512k chunks
>      =20
> unused devices: <none>
> [root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l10 -a /dev/sdb2 /=
dev/sdc2 /dev/sdd2=20
> mdadm: level of /dev/md0 changed to raid10
> mdadm: added /dev/sdb2
> mdadm: added /dev/sdc2
> mdadm: added /dev/sdd2
>=20
>     So I guess it's the problem add the disk to raid10 after the reshapin=
g. In the function
> super_1_validate, it'll set the  mddev->dev_sectors using the superblock =
read from disks.=20
> If it's raid0, the le64_to_cpu(sb-size) is 0. So when add disk to raid10 =
bind_rdev_to_array
> return -ENOSPC.
>=20
>     When create raid0, it doesn't write give the value to s->size. So the=
 sb-size is 0.
> I modify the code about Create.c. I'm not sure whether it's right to do s=
o. But it can resolve=20
> the problem.

Thanks for the report.

I think this need to be fixing in the md driver, when the reshape happens.

Something like the following.

NeilBrown

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d1203cddb024..b8d76b1fba64 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3872,7 +3872,7 @@ static int raid10_resize(struct mddev *mddev, sector_=
t sectors)
 	return 0;
 }
=20
-static void *raid10_takeover_raid0(struct mddev *mddev)
+static void *raid10_takeover_raid0(struct mddev *mddev, sector_t size, int=
 devs)
 {
 	struct md_rdev *rdev;
 	struct r10conf *conf;
@@ -3882,6 +3882,7 @@ static void *raid10_takeover_raid0(struct mddev *mdde=
v)
 		       mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
+	sector_div(size, devs);
=20
 	/* Set new parameters */
 	mddev->new_level =3D 10;
@@ -3892,12 +3893,15 @@ static void *raid10_takeover_raid0(struct mddev *md=
dev)
 	mddev->raid_disks *=3D 2;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp =3D MaxSector;
+	mddev->dev_sectors =3D size;
=20
 	conf =3D setup_conf(mddev);
 	if (!IS_ERR(conf)) {
 		rdev_for_each(rdev, mddev)
-			if (rdev->raid_disk >=3D 0)
+			if (rdev->raid_disk >=3D 0) {
 				rdev->new_raid_disk =3D rdev->raid_disk * 2;
+				rdev->sectors =3D size;
+			}
 		conf->barrier =3D 1;
 	}
=20
@@ -3920,7 +3924,9 @@ static void *raid10_takeover(struct mddev *mddev)
 			       mdname(mddev));
 			return ERR_PTR(-EINVAL);
 		}
-		return raid10_takeover_raid0(mddev);
+		return raid10_takeover_raid0(mddev,
+			raid0_conf->strip_zone->zone_end,
+			raid0_conf->strip_zone->nb_dev);
 	}
 	return ERR_PTR(-EINVAL);
 }

--Sig_/4FYTFlpOlO1yQN0ylgJf1X6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNG+mTnsnt1WYoG5AQJ+GQ/+OBdMILyorn6wxhNROXKl765ifTC7il/G
3nrutS6ngXcSvb3YG5Gdh9evr0+RY6wLLLRHFIY7y2JP192RGIwjMaWudp/FYly4
LiVByDHJgpAkEtwomzxmq8n4nP1MaEhOyEY8qFRDYgYz5eDrNRet3QEUurXgTJDe
72kXcpNDYmRlsz4fH745KxekfQdQ/+z4ps85albAncfaxtOcEJdDeQhBQxhYm4ct
gf9V/HMFm1nCtP2CYZPvCM4ExN5q0L9u8mrqaMi3iMdpJdZmkFRZzM2/+YDJczOC
e6aW78bUFxXYkQUGrz+ypCtAPd5mQOVG+hPu27A7ZDhQAeXXE0SaR94rkcZWNL9K
WcQHh1qEDgb2LSwZZ1J+MUnI+f6YUfNym0KNh28mQUqshT8i8kPM8hHWjOB8YQkt
yBEofo5UxVGqhdhyVgsGXq5NLB0Dwtay3VUUKByyKQu345XC5ZaAL9JDlQaY4vlf
hNmBaXsDaqZWisJ2+xw1g49dLjq9rFw7ryKpv0CpIu1yD7wxfsi/GMw/qTNEnk41
k+q172Yc2Q8xzuBNKT+s7d62ByfGjQq3wf5P3ThwvMoHh1F54J5NUTXn3TLtpR0Y
YgTMuBn4ySI9++BNmyu6PiYenxvK1DmheRDmvjFB88Jd+BXPoC2Zibzq4Xzw58tp
HRyoo57qwjI=
=9Ma/
-----END PGP SIGNATURE-----

--Sig_/4FYTFlpOlO1yQN0ylgJf1X6--
