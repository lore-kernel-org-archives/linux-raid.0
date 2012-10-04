From: NeilBrown <neilb@suse.de>
Subject: Re: raid repair checkpoint enhancement
Date: Fri, 5 Oct 2012 07:05:24 +1000
Message-ID: <20121005070524.51d92d14@notabene.brown>
References: <A389B1DB577EF14DAA0CB1D40CF2EF5F016DF575A6@MX45A.corp.emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Fu8D0UUna64P7zfcvrkQXbE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A389B1DB577EF14DAA0CB1D40CF2EF5F016DF575A6@MX45A.corp.emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Ryan, MichaelS (ENG Redmond)" <michaels.ryan@emc.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Fu8D0UUna64P7zfcvrkQXbE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Oct 2012 13:26:35 -0400 "Ryan, MichaelS (ENG Redmond)"
<michaels.ryan@emc.com> wrote:

>=20
> Hi all.
>=20
> If a device reboots during a raid repair operation ("echo repair > /sys/b=
lock/md0/md/sync_action"), the raid repair is interrupted and not restarted=
. For devices that are shutdown nightly, this could prevent a raid repair f=
rom ever getting to the far reaches of the array.  I'd like to see an enhan=
cement that would checkpoint the raid repair operation on shutdown similar =
to how a sync operation is checkpointed.  Preferably, the raid repair would=
 be restarted automatically on the next boot at the checkpoint location.  A=
lternatively it could require user input to restart the operation at either=
 the checkpoint location, or at the beginning.
>=20
> Any thoughts on this enhancement?

You can do this yourself with some scripting.
Before you shut down, record the first number in
    /sys/block/mdXX/md/sync_completed
When on reboot, write that number to=20
    /sys/block/mdXX/md/sync_min
before writing 'repair' to 'sync_action'.

NeilBrown

--Sig_/Fu8D0UUna64P7zfcvrkQXbE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUG36FDnsnt1WYoG5AQKXpQ/+OWMLFP+Bgi8gCppSE20g6Dpn8pT7Kbg8
osp2uu1ygEHyZNpiRRkkd/KkfCnEDHJar+i2d4eFT/HhbL4NbuMaZYb6HghLmltK
NygFjMgHvwNeic2niTsBULbvnLPShW6jhaRlQpnJpwob/ECh0pY0ezBeMEJDpDLB
Tys6uLtZ9gaxWTgJ4uOyoxUo0ENK7kLHSxUHCvXA5pL/ntfd4cQf4k5vqzdHBwQg
APxrKKPcYhk2vQBELmcgU61KE7uOG3snVfASU1p2yyTdg3ixjjVTryjjQJ1v/otC
dKywWhWEeFB58CBjFjKWGqyPBvtK2yi8C1bUuZyc+xubYJlY7SmAj6CBkmeMeEkg
jQwrWnTvPoZUukL/R/kwJaJnVranpuTYV7JqRkqyG+yrLK3dUqSHSVQPyMJjdzo8
9axYFXDRSeyttxbWDUpwK5UmNSFWgTatKn+WuwAqCnoji0PSpA2JZCZjaWCi0MA1
qHww6mVUGd6qlw8wHdykb8LR0PIGSPxMV2cruZ9dMYCeuVb7/BWa/K06OkkJMGZT
VRLkTyeV90BpkQa2/SuhKnJUd2K9E7VYJerZ/qngdlWzPAV3VbCGS7YwA8G4ycni
eqHWFXZ2AmhxikfCJxGIXmqla8hslaxewUZsvsWuZo7ak/8aZOcD+gl/EfaTB6oB
rcHaFUKqrIM=
=I/et
-----END PGP SIGNATURE-----

--Sig_/Fu8D0UUna64P7zfcvrkQXbE--
