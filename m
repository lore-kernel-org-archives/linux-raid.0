From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape is stuck
Date: Thu, 28 May 2015 08:59:58 +1000
Message-ID: <20150528085958.0f95e323@notabene.brown>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
	<1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com>
	<20150525135001.43d1083a@notabene.brown>
	<427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>
	<20150527100253.221ab553@notabene.brown>
	<20150527111004.5f136f23@notabene.brown>
	<2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com>
	<20150527213449.6e017deb@notabene.brown>
	<476656362.5105083.1432728264276.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/vpRuKSnoWdKl01pOuToYcv2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476656362.5105083.1432728264276.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vpRuKSnoWdKl01pOuToYcv2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 May 2015 08:04:24 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

>=20
>=20
> ----- Original Message -----
> > From: "NeilBrown" <neilb@suse.de>
> > To: "Xiao Ni" <xni@redhat.com>
> > Cc: linux-raid@vger.kernel.org
> > Sent: Wednesday, May 27, 2015 7:34:49 PM
> > Subject: Re: raid5 reshape is stuck
> >=20
> > On Wed, 27 May 2015 07:28:04 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> >=20
> >=20
> > > [root@intel-waimeabay-hedt-01 mdadm]# cat
> > > /usr/lib/systemd/system/mdadm-grow-continue\@.service
> > > #  This file is part of mdadm.
> > > #
> > > #  mdadm is free software; you can redistribute it and/or modify it
> > > #  under the terms of the GNU General Public License as published by
> > > #  the Free Software Foundation; either version 2 of the License, or
> > > #  (at your option) any later version.
> > >=20
> > > [Unit]
> > > Description=3DManage MD Reshape on /dev/%I
> > > DefaultDependencies=3Dno
> > >=20
> > > [Service]
> > > ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I
> > > --backup-file=3D/root/tmp0
> >=20
> > Please remove the ---backup-file=3D/root/tmp0 for further testing.  The=
 patch I
> > provided should make that unnecessary.
> >=20
> > > StandardInput=3Dnull
> > > StandardOutput=3Dnull
> > > StandardError=3Dnull
> >=20
> > Could you try removing these - that might allow error messages to appea=
r.
> > I wonder why I included them - they shouldn't be needed.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
>=20
> [root@intel-waimeabay-hedt-01 mdadm]# mdadm -CR /dev/md0 -l5 -n4 /dev/loo=
p[0-3] --assume-clean
> mdadm: /dev/loop0 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DWed May 27 02:45:08 2015
> mdadm: /dev/loop1 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DWed May 27 02:45:08 2015
> mdadm: /dev/loop2 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DWed May 27 02:45:08 2015
> mdadm: /dev/loop3 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DWed May 27 02:45:08 2015
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> [root@intel-waimeabay-hedt-01 mdadm]# mdadm /dev/md0 -a /dev/loop4=20
> mdadm: added /dev/loop4
> [root@intel-waimeabay-hedt-01 mdadm]# mdadm --grow /dev/md0 --raid-device=
s=3D5
> mdadm: Need to backup 6144K of critical section..
> [root@intel-waimeabay-hedt-01 mdadm]# cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
>       1532928 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UU=
UUU]
>       [>....................]  reshape =3D  0.0% (0/510976) finish=3D532.=
2min speed=3D0K/sec
>      =20
> unused devices: <none>
> [root@intel-waimeabay-hedt-01 mdadm]# cat /usr/lib/systemd/system/mdadm-g=
row-continue\@.service=20
> #  This file is part of mdadm.
> #
> #  mdadm is free software; you can redistribute it and/or modify it
> #  under the terms of the GNU General Public License as published by
> #  the Free Software Foundation; either version 2 of the License, or
> #  (at your option) any later version.
>=20
> [Unit]
> Description=3DManage MD Reshape on /dev/%I
> DefaultDependencies=3Dno
>=20
> [Service]
> ExecStart=3D/usr/sbin/mdadm --grow --continue /dev/%I=20
> #StandardInput=3Dnull
> #StandardOutput=3Dnull
> #StandardError=3Dnull
> KillMode=3Dnone
>=20
>=20
> The problem still exist. And there are messages in /var/log/messages
>=20
> May 27 08:03:29 intel-waimeabay-hedt-01 systemd: mdadm-grow-continue@md0.=
service: main process exited, code=3Dexited, status=3D1/FAILURE
> May 27 08:03:29 intel-waimeabay-hedt-01 systemd: Unit mdadm-grow-continue=
@md0.service entered failed state.
>=20

Does
  systemctl status -l mdadm-grow-continue@md0.service

report anything different.  That was the result I expected from removing the
Standard*=3Dnull lines.

I assume the new mdadm is installed in /usr/sbin/mdadm.

Thanks,
NeilBrown

--Sig_/vpRuKSnoWdKl01pOuToYcv2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWZMbjnsnt1WYoG5AQK6jg//TFKSQ8dZWZIEcbbyfimUzxsek5QdS6Lv
Jxns+BQ70wuBbEh1/mrrySoe9lsXwhLgqEPObrOdC8CXR4aQwEbd0lAQbFpUnYlJ
QL00/crOWYuXZlGaGcyvT+JQqAGT4xxG7xPmvqkNC+DG/fjPxudPuH3ywJGFhKdY
WywZ+zg9IqbW1nWd6faWMnW2PzV+EHrTJkISJl4Z1tWCxeASfPawzQYTwNtTekEN
eThYQFh49dBZVJaX+tRLXg8chescG61arKrk5Z2jAKsBP5uUw5Vz+7dUgopaAuwO
U/jKqY9fWqRHa60eu1U1vMe7Q4Nqd+PW5/TK2kRqh7D/RlI99EcErw5xtseDBZhM
61JO8QXj2cTPgO2thBKkYXgJ5ooN8PX4tf1GlsRFP1yF2yrmifn9PFNmZbPydtla
jvuMWHimQywDv7ulxDa7yPdp7FtbzrqACEKGeX8+dGVl175eZoBqp2UYdkhHl7+k
rHN5Fxhk80dWGIdWSBtU8Uv6JVL5WsRE8FX/A7zp9NIxpxrcGC5qHRhb6JRj8uEQ
G4jzXkmdYH50GEMFiZ8G17vtvZPJKZGNB4j5TP6rphctYR45oo+mMF0CKVnOatBC
G8IScAvar3oTKvL+Xw0JiNG1OVQQpAG9pqrHXFeFPL9gOOlgWR5CyYCa/901W/K4
YMNxeBqWO/I=
=YgQW
-----END PGP SIGNATURE-----

--Sig_/vpRuKSnoWdKl01pOuToYcv2--
