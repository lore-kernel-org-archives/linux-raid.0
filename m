From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 22:10:07 +0000
Message-ID: <20130131221007.GA1447@cthulhu.home.robinhill.me.uk>
References: <510A4AAE.6000009@evilazrael.de>
 <20130131113820.GA20536@cthulhu.home.robinhill.me.uk>
 <510A6E54.5050001@evilazrael.de>
 <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Christoph Nelles <evilazrael@evilazrael.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 31, 2013 at 10:46:17 -0700, Chris Murphy wrote:

>=20
> On Jan 31, 2013, at 6:15 AM, Christoph Nelles <evilazrael@evilazrael.de> =
wrote:
>=20
> > All drives are available again. And the seecond failed device reports
> > UREs. I will run badblocks on that device before continuing.
> > I attached the kernel logs of the first error and of the second error. I
> > hope i filtered them reasonably.
>=20
> This looks like a write error, resulting in md immediately booting the
> drive. There's little point in using this drive again.
>=20
> Jan 28 00:23:36 router kernel: Write(16): 8a 00 00 00 00 01 36 b2 55 50 0=
0 00 00 30 00 00
> Jan 28 00:23:36 router kernel: end_request: I/O error, dev sdg, sector 52=
12624208
>=20
It's definitely a write error, yes. If there's nothing further back in
the log (e.g. a read error that's caused a rewrite to take place) then
this would definitely warn against the drive, but could just be a
transient error (or a controller problem). If there is a read error
further back then I'd blame it on timeout issues, with the drive still
trying to complete the read operation while the kernel's timed out and
trying to send a write.

> What does smartctl -a return for this drive?
>=20
>=20
> > Exactly. I am running badblocks on that device. SMART reports one
> > "Pending Sector Count" :(
>=20
> I'm unclear on the efficacy of badblocks for testing. I'd use smartctl
> -t long and then -a to see if there are sector problems and at what
> LBA; and for removing bad blocks (force a remap) I'd use either dd
> zeros with e.g. bs=3D1M, or I'd use ATA Secure Erase which is faster.
>=20
I don't usually bother with read tests - as you say, they're not
terribly useful. If the data's useful then just use ddrescue to get what
you can, otherwise just write-test it. I usually do a full destructive
badblocks test (I've found cases where zeros write fine but other
patterns fail), followed by a long SMART test.

> If you use the badblocks map when formatting a drive, e.g. using
> mkfs.ext4 -c, then it would allow you to use this disk but not in
> RAID. On top of raid, md gets the write error before the file system
> does, and boots the drive out of the array. Or on read error attempts
> to correct it. And even as a standalone drive do you really want to
> use a drive that can't remap future bad sectors?
>=20
Not a chance I'd use it if it's actually failing to remap bad sectors,
no. Only had that with one drive so far though (out of several hundred),
most get failed out after getting more than a handful of remapped
sectors.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEK674ACgkQShxCyD40xBJ5BgCfQYephZeHEYXbE4DFv+FYkIZh
bC8An26NqwktWneofZiOm25Kr+OyllJA
=ry5W
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
