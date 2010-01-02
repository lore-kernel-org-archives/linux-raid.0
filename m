From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: RAID5 broke during reshape...
Date: Sun, 03 Jan 2010 00:18:05 +0100
Message-ID: <1262474286.10047.51.camel@michal-laptop.sawicz.net>
References: <1262451347.10047.14.camel@michal-laptop.sawicz.net>
	 <70ed7c3e1001020933x7ac028a5n42af404eb5e23e30@mail.gmail.com>
	 <1262454630.10047.23.camel@michal-laptop.sawicz.net>
	 <70ed7c3e1001021001g7e7a17b6ufb431ddfd563eae6@mail.gmail.com>
	 <1262456799.10047.33.camel@michal-laptop.sawicz.net>
	 <70ed7c3e1001021036l73f6194ek8b553bd08f9893d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HQD7xvJwUuZEfA4DXGOc"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1001021036l73f6194ek8b553bd08f9893d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-HQD7xvJwUuZEfA4DXGOc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-02, sob o godzinie 21:36 +0300, Majed B. pisze:
> From the error mdadm reported, the array's been converted to a 5-disk
> one and it's trying to assemble it with 2 disks only which won't work.

Of course. Is there a way to force-assemble an array with an arbitrary
sequence of devices? Also, according to mdadm -E on the disks, the array
wasn't actually grown to 5 devices:

> Raid Devices : 4

Also, the size of the array:

> Array Size : 5860558848 (2794.53 GiB 3000.61 GB)

suggests the array is actually still a 4-disk one, so 3 working disks
should constitute a degraded array. I understand that while the array
was being reshaped, data was moved onto the 4th disk, too, so all the 4
devices will be needed to recover. Why was sdf marked as a spare and
kicked out, I can't understand.

> I faced interruption during a grow process before, and re-issuing the
> grow command worked for me, but I suggest you run all the tests
> possible now and wait till more people reply to your email.=20

sdh reported one unreadable sector. That suggests everything else should
be possible to recover, right?

BTW, bad sectors, as bad as they are, usually don't mean the disk
failing completely, wouldn't it be better for the array to shut down
with a huge warning that it will fail if this disk gets more errors
instead of breaking the array if there're no spares available?

Also, does the mentioned smartd polling/testing reduce the probability
of the array failing? If the sectors are marked bad, the controller will
simply redirect requests to them, right? So the disk wouldn't be marked
as failed, but smartd will report problems early?

--=20
Regards
Micha=C5=82 (Saviq) Sawicz

--=-HQD7xvJwUuZEfA4DXGOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAks/1C0ACgkQzQlUjpZYlbfiTwCgrkjOEog9PMy204Gj3+KeMWqn
MfoAoJZhsg5mN9V5V8gBPyinP9mgkfvF
=u1uI
-----END PGP SIGNATURE-----

--=-HQD7xvJwUuZEfA4DXGOc--

