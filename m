From: NeilBrown <neilb@suse.de>
Subject: Re: recovering from raid5 corruption
Date: Mon, 30 Apr 2012 08:52:57 +1000
Message-ID: <20120430085257.65d19c20@notabene.brown>
References: <4F9DC2E5.1090509@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XXwT8kmD2v3+fHYtpw=RXiy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9DC2E5.1090509@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaya Potter <spotter@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XXwT8kmD2v3+fHYtpw=RXiy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 29 Apr 2012 18:38:29 -0400 Shaya Potter <spotter@gmail.com> wrote:

> somehow my raid5 got corrupted in the contexts of a main disk failure=20
> (which wasn't raid related).
>=20
> compounding this issue was that I had already had one disk in the raid5=20
> go bad and was in the process of getting it replaced.
>=20
> this raid array was 5 disks.
>=20
> What I mean by corrupted is that the superblock of 3 of the remaining 4=20
> devices seemed to have been wiped out (i.e. had a UUID of all 0s, though=
=20
> still enough that it knew it was part of an md device)
>=20
> now, the one whose superblock seems fine, places it at position disk 3=20
> (of 0-4) and the missing disk at disk 2.
>=20
> this would imply that there are only 6 permutations possible for the=20
> other 3 disks.   (even if that assumptions is wrong, there are only 120=20
> permutations possible, which I should easily be able to iterate over).
>=20
> further compounding this, is that there were 2 LVM logical disks on the=20
> physical raid device.
>=20
> I've tried being cute and trying all 6 permutations to force recreate=20
> the array, but lvm isn't picking up anything. (pvscan/lvscan/lvmdiskscan)
>=20
> The original raid had a version of 0.90.00 (created in 2008), while the=20
> new one has a version 1.20.
>=20
> have I ruined any chances of recovery by shooting in the dark with my=20
> cute attempts, am I SOL or is there a better/proper way I can try to=20
> recover this data?
>=20
> Luckily for me, I've been on a backup binge of late, but there still=20
> about 500-1TB of stuff that wasn't backed up.

You've written a new superblock 4K in to each device, where previously here
was something.   So you have probably corrupted something though we cannot
easily tell what.

Retry your experiment with --metadata=3D0.90.  Hopefully one of those
combinations will work better.  If it does, make a backup of the data you
want to keep, then I would suggest rebuilding the array from scratch.

NeilBrown

--Sig_/XXwT8kmD2v3+fHYtpw=RXiy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT53GSTnsnt1WYoG5AQJIdhAAnY8ISVShscY36x3l9Ov8Sm5sOFjGqSeC
0wDGrvhqFrQd0ritJrORbhjTZAV6BqkznHAQLcG57UN/72rEcxMkSnaLfxpRX+H4
wMVLhktNyuFMhXyMlGrgx4dcXh/AHX+mCxvx6Eb562tF7PY9BcKyiR2k672+mCeQ
pKpb8YO/WLwWj+A7BbU+T+O3ov66l3j3eotY/0dlRLt8boNkWQZrNSMwZ8CA5ejP
V2dH3cBQTcAwQsOvEth7khwUghk2VK0woorIn3OYx1UTCAlsO58KtwAl9r2PoTXc
7IVoKBzxlxUGMAD0DNetn658vnKoZMV8zFJqBmRaWGWiBV3WBhj/vmWin8ncSG2M
vgJCKEbfw0LHbrTrP5gFeK6xznLFJ8ZYSYFcswLC32q2DDNgpPeWC2bbjDeN40iY
Sv1MvwMblw0grhg1SgtiefC1Q3C/BGfE0zBd7mvJ9iN8I70/mqUQVnPfr18gPvLT
Tc84tQCyQb/Ft5O32EgQ9zBdooeosMM/t2Lw7z/YFwv6qZxNzg8uUjYigpumM/FW
bow244WIESGsFDtClc9VpgMqIPQcOAA6s8kQXbAZwZxfh/UOoJLnC9M7z3GukPWm
EDg9YmGsGk5AwoNif+6ntphcZ2gv/xCQ40JlVYjPxRYwnMEszRDDdrlvlOAazkvV
8qYaq/8J2MM=
=SK60
-----END PGP SIGNATURE-----

--Sig_/XXwT8kmD2v3+fHYtpw=RXiy--
