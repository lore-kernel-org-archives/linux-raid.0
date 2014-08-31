From: NeilBrown <neilb@suse.de>
Subject: Re: Converting RAID5 to RAID0
Date: Mon, 1 Sep 2014 08:31:37 +1000
Message-ID: <20140901083137.4772c8c5@notabene.brown>
References: <loom.20140831T143354-68@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/oj=7q2VpKcml=Expl.WCAFX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20140831T143354-68@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Muratet <muratetm@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/oj=7q2VpKcml=Expl.WCAFX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 31 Aug 2014 12:43:26 +0000 (UTC) Mike Muratet <muratetm@gmail.com>
wrote:

> I am doing some experiments with mdadm to combine two 1TB disks into a RA=
ID
> array. I used fdisk to create the partitions and mdadm to create a two di=
sk
> RAID5 array. I would like to have more space and I can live without
> redundancy. I searched the man pages and boards for a way to do that and =
found:
>=20
> $ sudo mdadm /dev/md0 -f /dev/sdd
> mdadm: set /dev/sdd faulty in /dev/md0
> $ sudo mdadm /dev/md0 -r /dev/sdd
> mdadm: hot removed /dev/sdd from /dev/md0
> $ sudo echo raid0 > /sys/block/md0/md/level
>=20
> -bash: /sys/block/md0/md/level: Permission denied
>=20
> which was not the result I expected.
>=20
> Is it possible to convert RAID5 to RAID0?

Presumably you mean to convert a 2-device RAID5 to q 2-device RAID0, thus
doubling the amount of space.
  mdadm /dev/md0 --grow --level=3D0 --raid-disks=3D2

will tell you that you need a backup file, so
  mdadm /dev/md0 --grow --level=3D0 --raid-disks=3D2 --backup-file=3D/root/=
backup

will work... but will leave you with a degraded RAID4.  So just run that sa=
me
command again to finish the job.

NeilBrown



>=20
> There are no data on the disk. Is there a way to start over?
>=20
> Cheers
>=20
> Mike
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/oj=7q2VpKcml=Expl.WCAFX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVAOiSTnsnt1WYoG5AQJefxAAjOEmb8AuzBzY7kQYTrfSxaSA+uHd6wQU
6aJGlHmBUVuifi4GmGKHHhoCDkffNpYxb3ga99kHHYLtijzLomQLsOGSmRc9PQzI
5mEK8ZD1XiT0hbyNOHq+uwLKOh6bncRH15KWPviabqMCllKMIzYGF6hz36NlrBji
Rqhd1sCmjNBKHF5YL923ZvWo87ZBKpcgWUZosZzTM1Ae2I68N0PYisQYaxALV7MO
miFFt8l0ysjJ9COm7iyJ784HbGyg5CXBT813+n3xRRyYjhEPxbvuMA1ozQNikanH
c4Flo96zTCM1+myZ1p2Ov56OrGtKQzeWkenZPCoD467m7kfw1f954gm1HFeRg35i
uZ00cgrwmSWf8Ym+xS1JkxEWpZfn0hN6wrPQRUbykJD1sv69an1qw2/j80kSB7Li
eZM5Aj1+LW6DtWcd+1JiQlmcjybrpXs+o0h+u775moWFC/j4eHlOixv6PWG9PKrJ
M7urlt6zIdO6flMK6lWlhN6eVmI1XVjFodR4KeMyD9xNJqLw3EIDVN74BQsg4X5k
byBI+7RBzz8NYUfCx6SLeiBNoC3oEJ2EsayKGaci1pRnii6ROvwxeSlLymXXBfPm
IAWRixf7Uq3b+d0yge2Tv/n7+N3a+EqYmU3ISxGMWDZBEFMn2cx9AaqzApz8CCpL
HhmKDZplqJU=
=MXGZ
-----END PGP SIGNATURE-----

--Sig_/oj=7q2VpKcml=Expl.WCAFX--
