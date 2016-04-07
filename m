From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: raid1 recoverable after system crash?
Date: Thu, 07 Apr 2016 12:11:37 -0400
Message-ID: <1460045497.27740.157.camel@interlinx.bc.ca>
References: <1460033086.27740.145.camel@interlinx.bc.ca>
	 <20160407180004.53615913@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3g2d6EkhZYrNsRs8aVt/"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160407180004.53615913@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-3g2d6EkhZYrNsRs8aVt/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-04-07 at 18:00 +0500, Roman Mamedov wrote:
>=C2=A0
> You do not have a write intent bitmap at md0, so re-add will not
> work.

Ahhh. =C2=A0OK.

>  Seems
> like you should --add it now,

Tried that. =C2=A0It started off and got this far:

# cat /proc/mdstat=C2=A0
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4=
] [raid10]=C2=A0
md0 : active raid1 md1[2](F) sdd[0]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01953514496 blocks [2/1] [U_]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D>....]=C2=A0=C2=A0recovery =3D 82.0% (1602507648/1953514496) fi=
nish=3D42613.2min speed=3D137K/sec

before hitting this:

2016 Apr=C2=A0=C2=A07 12:01:00 linux [16583.606363] md/raid1:md0: Disk fail=
ure on md1, disabling device.
2016 Apr=C2=A0=C2=A07 12:01:00 linux [16583.606366] md/raid1:md0: Operation=
 continuing on 1 devices.
2016 Apr=C2=A0=C2=A07 12:01:00 linux FailSpare event detected on md device =
/dev/md0, component device /dev/md1
2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.907982] BUG: unable to handle k=
ernel paging request at 0000000099b899b8
2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] IP: [<ffffffffa0019227>=
] call_bio_endio+0x37/0xb0 [raid1]
2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] Oops: 0000 [#1] SMP
2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] Stack:
2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] Call Trace:
2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] Code: 4c 89 65 e0 4c 89=
 6d e8 4c 89 75 f0 4c 89 7d f8 66 66 66 66 90 4c 8b 67 28 48 8b 47 20 41 bf=
 01 00 00 00 48 89 fb 41 8b 54 24 2c <4c> 8b 28 85 d2 75 42 48 8b 43 18 a8 =
01 75 07 3e 41 80 64 24 18
2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] RIP=C2=A0=C2=A0[<ffffff=
ffa0019227>] call_bio_endio+0x37/0xb0 [raid1]
2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] CR2: 0000000099b899b8

And it seems to be stuck there now.

dmesg contents at http://www.interlinx.bc.ca/~brian/raid-dmesg.txt

>  then after it rebuilds use --grow to add a
> bitmap, so that in the future you could use -re-add.

Cool. =C2=A0Will do, when this finally gets fixed.

> As to why the situation occured in the first place, you should ensure
> that md1
> assembles before md0.

Yeah. =C2=A0Just noticed as of this incident that the order in mdadm.conf i=
s
wrong. =C2=A0:-(

Cheers,
b.

--=-3g2d6EkhZYrNsRs8aVt/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAABAgAGBQJXBoa5AAoJENrB0DQWy8igPRgH/3FIwRRf8M3I5YCDJGDsSDE2
Bby0+BIA5EauQPZmcL/Ai2KMClse5nVbf9SM/46d67yJQmduzx2N2cg0xFJSqIpB
Zv3ltU7WFBEU3pwpwnEji6Qy6uebDGgdizIX8Qza7j4lYtlRKu98wo1bZv31TDwF
ciWOFb2WqUlhsoTSgJQaNW3H8hssv3EpyXZMDbOKbXrTMoiS4/ZO16ZyldyFfWTZ
KKO1NsTPz/bQGpEpneaB5F6koRGqsHNcwEMSZ9i7cfyxLXZbgVUATzLTNjSU2ONB
z6/tbyTmiGnh5K2lLIDUF0RGd9fVa2ic8pVhJiD9V360XesA7i68rcchg2HXRgg=
=HlvE
-----END PGP SIGNATURE-----

--=-3g2d6EkhZYrNsRs8aVt/--


