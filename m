From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid5: degraded after reboot
Date: Fri, 12 Oct 2007 20:32:24 +0200
Message-ID: <20071012183224.GG21133@skl-net.de>
References: <cccedfc60710120838nd2bb38pf57f03faa803b6c6@mail.gmail.com> <20071012154755.GE21133@skl-net.de> <cccedfc60710120908m24724867had038d9729d16efe@mail.gmail.com> <20071012161809.GF21133@skl-net.de> <cccedfc60710121005n5290822g3bf463e653405b99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4eRLI4hEmsdu6Npr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60710121005n5290822g3bf463e653405b99@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--4eRLI4hEmsdu6Npr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:05, Jon Nelson wrote:

> Can mdadm be told to use non-fresh devices?

Sure. --force does the trick.

> What about sdb4: I can understand rewinding an event count (sorta),
> but what does this mean:
>=20
> mdadm: forcing event count in /dev/sdb4(1) from 327615 upto 327626

Well, it means the event counter was advanced forward by 11 events. I'm
not sure under which circumstances this message is printed though.
Clearly, after a successful resync the event counter of the added disk
is adjusted to match the value of the rest of the array. AFAIK, also
assembling an array using --force would cause such an adjustment.

> Since the array is degraded, there are 11 "events" missing from sdb4
> (presumably sdc4 had them). Since sda4 is not part of the array, the
> events can't be complete, can they?

There's no such thing as a "complete event". An event for example
happens, when the array gets assembled, or if the superblock changes
due to the user adding bitmap support. The event counter is simply
a number which is written to each device of a raid array and which
is increased whenever an event occurs.  Note that changes to the
underlying file system do not cause events, so the data on the disk
may change completely although the event counter stays the same.

Normally all devices contain the same count. But if you, for example,
yank out a drive and assemble the array without that drive, the number
on that drive isn't increased, obviously. If you plug in again the
drive later and try to assemble the array, that drive has a lower
event count than all other drives, i.e. it's non-fresh. Since any
number of changes might have happened during the time the array was
degraded the data on the non-fresh drive can not be trusted, which
means it must not be used when assembling the array. So the drive is
kicked and a full sync is necessary.

>   Why jump *ahead* on events
> instead of rewinding?

That wouln't buy you anything. No good idea.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--4eRLI4hEmsdu6Npr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHD724Wto1QDEAkw8RAqL8AJ9IVu5ngygEDOrCmGtnU1zXea2U4gCeP46t
0kTQ7DLZV8mJedtGbWvmcAM=
=YGIU
-----END PGP SIGNATURE-----

--4eRLI4hEmsdu6Npr--
