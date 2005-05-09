From: SainTiss <saintiss@gmx.net>
Subject: raid reconstruction woes
Date: Mon, 9 May 2005 20:21:33 +0200
Message-ID: <200505092021.35283.saintiss@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3625723.CyyNXXK2GP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart3625723.CyyNXXK2GP
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

I had a RAID-1 array set up, and one disk went bad. So I replaced it, but t=
hen=20
I did something I probably shouldn't have done: remove the UUID's of the ro=
ot=20
partitions (i.e. the partitions with the / filesystem on).

I then used knoppix as a bootdisk to execute the following command:

mdadm --create /dev/md1 --raid-devices=3D2 --level=3D1 /dev/sda2 /dev/sdb2

That worked, and the partitions synched.

However, booting into my main (debian sarge, kernel 2.6.8.1) system, it sai=
d=20
"/dev/sd[ab]2 has wrong uuid".

At first I didn't understand, since I had no mdadm.conf file, so I didn't s=
ee=20
how uuid information could be obtained other than from the partitions itsel=
f.

That led me to think it might be stored inside initrd, and indeed, mkinitrd=
=20
solved that error message.

However, the remaining problem is that, during boot, /dev/md1 is never=20
correctly set up:

=2D either I have root=3D/dev/sda2 in grub, and then it will start /dev/md1=
 with=20
only /dev/sdb2, claiming that /dev/sda2 can't be added because the device i=
s=20
busy.
=2D either I have root=3D/dev/sdb2 in grub, and then I have the same proble=
m,=20
except that this time /dev/sdb2 can't be added.
=2D either I have root=3D/dev/md1 in grub, and then it doesn't seem to find=
=20
an /sbin/init executable, so the boot process doesn't complete.

I'm guessing that the "busy" partition is busy because it's being specified=
 as=20
the root partition in grub. However, it would seem logical that /dev/md1=20
would be constructed *before* the root partition becomes active, no?

Anyway, is this a problem which can be solved?

Thanks in advance,

Hans

--nextPart3625723.CyyNXXK2GP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCf6ovXlnUYIbmLOQRAg5TAJ4s7nFxeGIN7zq8X041y50mP7Ug3ACeNQNd
nYXISwkIj/e+OpuSxFfdpkY=
=YQUJ
-----END PGP SIGNATURE-----

--nextPart3625723.CyyNXXK2GP--
