From: NeilBrown <neilb@suse.de>
Subject: Re: [Question] Fail event during reshape raid5 -> raid6
Date: Wed, 4 Sep 2013 16:13:40 +1000
Message-ID: <20130904161340.64754a57@notabene.brown>
References: <52258DA0.4040704@validom.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PWHIXKSLk0fqNlrFx3J1YoP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52258DA0.4040704@validom.de>
Sender: linux-raid-owner@vger.kernel.org
To: Roland 'ValiDOM' Jungnickel <vali2013@validom.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PWHIXKSLk0fqNlrFx3J1YoP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Sep 2013 09:20:00 +0200 Roland 'ValiDOM' Jungnickel
<vali2013@validom.de> wrote:

> hi!
>=20
> I started reshaping a 3-device raid5 to a 4-device raid6. After some=20
> hours, I got a fail event on a harddrive which was already used in the=20
> raid5.
>=20
> There are two different raid-groups on these harddrives, a reshape of=20
> the second one has not yet started.
>=20
> What would you suggest?
> * stop the reshape, go back to raid5 and start rebuild to the new disk=20
> (how?)
> * just wait, hope and pray... ( there is no backup, I do not have=20
> harddrives to backup to as this is just to much...)
>=20
> md0 : active raid6 sdc2[0] sde2[4](F) sdb2[3] sdd2[1]
>        2858420224 blocks super 0.91 level 6, 64k chunk, algorithm 18=20
> [4/2] [UU__]
>        [=3D>...................]  reshape =3D  7.8% (112662528/1429210112=
)=20
> finish=3D4938.2min speed=3D4442K/sec
>=20
> md1 : active raid5 sdc1[0] sde1[2] sdb1[3](S) sdd1[1]
>        1048575744 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>=20
> (md1 not mounted, sde1 will fail once used/checked and the raid5 will=20
> automatically start rebuild on sdb1)
>=20

I would probably add the new good drive to the array (after some basic
testing to ensure that it really is good).  Then stop the array and restart
it.
I think it will recovery and reshape at the same time though that might
depend on what kernel you are using.
Testing with loop-back devices should be fairly easy to confirm what will
happen.

mdadm-3.3 (just released) can reverse a reshape for you.
   mdadm --assemble /dev/md0 --update=3Drevert-reshape /dev/sd[dbc]2
   --backup=3D/whatever

NeilBrown

--Sig_/PWHIXKSLk0fqNlrFx3J1YoP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUibPlDnsnt1WYoG5AQL4OA//fCFUCJ1aSCxhtJwgPE0+/d+V2EBll63w
EAavUtLDSZ3HIaM6snE8ZZCSuXsYb80F2VJ69xB5e32ENj8awH5J80ord7d3Gt9+
Hgy7ZBpczd5QrT9cjFnQk9gotX2Q+KO+PyOckBnkOt0aG0O90+kGE583rLxsTVq+
cK4jGVbDlVXMeuISa70J0PRSA51VFNLieUOi+sGRSC3t80KpTHkdDZ6QeEuldgyc
v9LpKC4H6RNIZDEmz+qYU4QLk3TfG5IhLFJ1kepmMSsaWF7wp8e+OIU8trNr4ado
y5avmjojkQP99dELUyFW+dMnha1lDGmWvK0OZO8MFXVgd7NdZfqxDVN6GoWjOsKm
zyXoRk6HEeSct+2Fc63Eg5ZqDjgDyy1K2ys6VNrJ/Kwadqz4V5lfhH4hlppbmNOO
8sxY73jnk138Pb7KQeRwkdy0HZOxXnsBW37DQ2lQgAG2gdCyoiIET6PIu0BsXsaJ
gJWCj9SyqlXkpXVRNmow8uddADE24+R3gA6a4S7ysu1hoaH8nh+o1x/QJrlFjB5A
Mwy+h4j3o9dL/kE2GYpmgy9soz/UsLdSdGiAz/YVRQ85Edpb4kktyLH1r7yU4nAG
jRKcQzUGnNrcWpltJ5TFoArJ9kcoW2YBfZJbrFynE5R9D/nkjYUt+JQ2hsimqmbN
35+gMxm79hc=
=/k1V
-----END PGP SIGNATURE-----

--Sig_/PWHIXKSLk0fqNlrFx3J1YoP--
