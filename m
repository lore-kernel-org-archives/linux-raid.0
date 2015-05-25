From: NeilBrown <neilb@suse.de>
Subject: Re: Does --freeze-reshape only work during initrd boot phase?
Date: Mon, 25 May 2015 12:20:33 +1000
Message-ID: <20150525122033.5f943aa3@notabene.brown>
References: <2047702950.2945677.1432290136375.JavaMail.zimbra@redhat.com>
	<1625238601.2947919.1432290609781.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GJIrO/Jc43D1zfVZU+ZCvBl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1625238601.2947919.1432290609781.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GJIrO/Jc43D1zfVZU+ZCvBl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 May 2015 06:30:09 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

> Hi all
>=20
>    I'm trying to use --freeze-reshape, I search how to use it, there is j=
ust some=20
> explanation in man mdadm. And I see the main usage about this is during i=
nitrd boot phase.
> Does --freeze-reshape only work during initrd boot phase?

No it can be used at any time.
However it doesn't apply to all array types, and that isn't clear from the
documentation.

--freeze-reshape is only relevant for arrays which require a user-space
process to help with the reshape - specifically to make temporary backups of
portions of the array while they are being reshaped.
If --freeze-reshape is given, then when mdadm discovers that it needs to
start such a helper, it doesn't and just leaves reshape frozen.
If it never finds that a helper is needed, there is no value in freezing the
reshape.

I should probably improve the documentation.

NeilBrown

>=20
>    I tried this after the machine started. The steps are as follows:
> [root@intel-canoepass-02 tmp]# mdadm -CR /dev/md0 -l5 -n5 /dev/loop[0-4] =
--assume-clean
> mdadm: /dev/loop0 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DFri May 22 06:14:35 2015
> mdadm: /dev/loop1 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DFri May 22 06:14:35 2015
> mdadm: /dev/loop2 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DFri May 22 06:14:35 2015
> mdadm: /dev/loop3 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DFri May 22 06:14:35 2015
> mdadm: /dev/loop4 appears to be part of a raid array:
>        level=3Draid5 devices=3D5 ctime=3DFri May 22 06:14:35 2015
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> [root@intel-canoepass-02 tmp]# mdadm /dev/md0 -a /dev/loop5=20
> mdadm: added /dev/loop5
> [root@intel-canoepass-02 tmp]# mdadm -Es
> ARRAY /dev/md/0  metadata=3D1.2 UUID=3D24d3d007:8ec28d4e:edb482fe:db7cab7=
1 name=3D0
>    spares=3D1
> [root@intel-canoepass-02 tmp]# mdadm -Es > /etc/mdadm.conf=20
> [root@intel-canoepass-02 tmp]# mdadm --grow /dev/md0 --raid-devices 6
> [root@intel-canoepass-02 tmp]# cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid5 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
>       2043904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UU=
UUUU]
>       [=3D=3D=3D=3D>................]  reshape =3D 23.9% (122368/510976) =
finish=3D0.8min speed=3D7648K/sec
>      =20
> unused devices: <none>
> [root@intel-canoepass-02 tmp]# mdadm -S /dev/md0=20
> mdadm: stopped /dev/md0
> [root@intel-canoepass-02 tmp]# mdadm -As --freeze-reshape
> mdadm: /dev/md/0 has been started with 6 drives.
> [root@intel-canoepass-02 tmp]# cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid5 loop0[0] loop5[5] loop4[4] loop3[3] loop2[2] loop1[1]
>       2043904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UU=
UUUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D>...........]  reshape =3D 46.9% (24012=
8/510976) finish=3D0.1min speed=3D23808K/sec
>      =20
> unused devices: <none>
>=20
>    The reshape is not freeze. I think it should be freeze now, am I right=
? The reason I want to
> use this is that I want to use --grow --continue. I see --continue is use=
d when reshape is=20
> interrupted.=20
>=20
> Best Regards
> Xiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/GJIrO/Jc43D1zfVZU+ZCvBl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKG8Tnsnt1WYoG5AQKEmQ/+OtO7TVTFUrMSkMWjDKYh3dKDVopH5JJ3
X0vXr33qbQHaFIySBLGBMeoxq/KNG8ZhbOxigtOw1lM+CZiXPaDfTUsqeMQT/Oux
FNDqqCVzRcqRKQd5mFg6zsKS6ulcMBGRlibgHaOk1Q9xuqV/FUCMqzPdeSr6Ctxz
qpS/BFG1/fQgJoB3F0k3PuS6ADScyslVqjxse14XAMZF98EISSmFtlQOew9lZ7Km
cWl0qINksnDMIM2jfLdWjKttzTlKbCrKoMQZsodUOG7S10RwRel9Rqt64+zAzAz0
M6KmCmnJGfSgEe+GIYAqCCJjDvnVis4xeWc1J3wRinmBAQ3UwOqT5tEICl6xVUkd
p3K6bISIcNOAmJD8hEeoHnB3O8vZZCJZTDtF1+bz+TDSLLQ+JbtfSsQconJwlFvs
8U4fXbu8zCFVqzoGQZPOudT6bToDTl/sVs8Hk6fzuCD3gi/rhpjcBdoHvVWXk6+t
Cd6FjOsHmN5VSrknFnxPKoOfQ2+49x3LFWeCITOGtOTYpOLbIb1FlGQncf2n+iY/
tj+E3x3/dCa41WCOlWle58LJ0RPyxRnAhXeLYH63QigAt3AgRhPzEtZgUZPc0AsE
MPcRYsNHE1M3QN0sQWkHTIzq8L6RJKpKnMgyynEC76pEC13CvXrPwzwWZs32966N
Wwu8gkX6uko=
=Tn7S
-----END PGP SIGNATURE-----

--Sig_/GJIrO/Jc43D1zfVZU+ZCvBl--
