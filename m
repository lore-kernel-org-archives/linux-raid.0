From: NeilBrown <neilb@suse.de>
Subject: Re: dmesg deluge: RAID1 conf printout
Date: Fri, 27 Apr 2012 11:30:51 +1000
Message-ID: <20120427113051.06aa7db7@notabene.brown>
References: <4F92BC43.3010603@computer.org>
	<20120422070041.7e4b95e7@notabene.brown>
	<4F943E07.8040206@computer.org>
	<20120423094853.15683cd6@notabene.brown>
	<4F94FE59.20307@computer.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vYgpldnoz7EFYbb5aCrYdOt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F94FE59.20307@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/vYgpldnoz7EFYbb5aCrYdOt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Apr 2012 09:01:45 +0200 Jan Ceuleers <jan.ceuleers@computer.org>
wrote:

> NeilBrown wrote:
> > The following should fix it.
>=20
> Neil,
>=20
> Since I had not been running a self-compiled kernel when I reported=20
> this, I first reproduced the issue on vanilla 3.3.0: git clone, git=20
> checkout, build (using the Ubuntu config file for 3.3.0), install, boot.
>=20
> The spares were not being added to either RAID 1 set, and the logs were=20
> not being flooded. The behaviour however began immediately when I added=20
> the spares manually.
>=20
> I then built a kernel with your patch on top, and upon booting the=20
> spares were being added automatically, and the logs are not being=20
> spammed. The problem therefore indeed appears to be solved.

Thanks for confirming.

>=20
> Tested-by: Jan Ceuleers <jan.ceuleers@computer.org>

I had meant to add this when I submitted the patch, but other things pushed
it from my mind.
It is appreciated though.

Thanks,
NeilBrown



>=20
> Thanks, Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/vYgpldnoz7EFYbb5aCrYdOt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5n2yznsnt1WYoG5AQIFRg/9HB8BReFiykSM9GMg45i6W5lAzJhdc91F
JusamtuemMXqAaNa+ruJYVaZUhB5fmM8VcAwRHK6nX8Aup5bNJdPvhTMMdyEcisB
uc2DpzTZcTngdXqGyaas4fMOxM4DfbZpBya1g1JAZ5yyXqgh04vrfarreNgApoT0
ADY5XdqG6ZlhqDpL5BIUGkVjQRs1B/8gicyVRGH7zKAxREFj74ichY4VJHcKeO5G
HLLlqnI3hIIuzQ7LXTqCPcr6lHe3EVuTU2NAnin7yG+i4f9frl3k3Vw5vQktc+Dg
hQY5/ky4o++Rcf2LuRAHMR+P708C7aRlIgf1K4I0/LZVG6CO2Ftpes5G159ScRsr
kaoHVbz/i3f4UAjc8qF0/v6+aHwRHMqjNLS8TRhx/8d8bf9NpEjY5e5em2GdwnPy
brbjCCDI6za0hO6Fp5HiTK1ZWmPJlwvxMBEwM/33E80bjYkNbP5aiIdKzm6KhcZM
6ogNWMnW33/90BpM+o3to2gGsSybcuAufkkdoUX+YwVDR7X5A79JCFtiQFfxk096
SutCwUadhu64FLBdnQ56qKi4W6tIegX5XWxRl6DoX2KItHOu5aGxu2Reze/huIbV
KKrxUMgnnM345hkCBV9ygrhjdfPNQabpVGkCDvN2Hxt7Jnj3qemDbRRHK7r8EclU
7Jgb4iBfqEY=
=eVh7
-----END PGP SIGNATURE-----

--Sig_/vYgpldnoz7EFYbb5aCrYdOt--
