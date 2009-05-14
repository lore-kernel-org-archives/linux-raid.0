From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: resync duration ?
Date: Thu, 14 May 2009 08:58:40 -0500
Message-ID: <20090514135840.GB8862@atlantis.cc.ndsu.NoDak.edu>
References: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2009 at 03:06:47PM +0200, Rainer Fuegenstein wrote:
> Hi guys,
>=20
> I'm a but confused about the duration of a raid5 resync:
>=20
> - occasionally, my server with 4*750 gb sata raid5 crashed (because of
> problems with the power supply); after rebooting it took about 10 to 12
> hours to resync the raid5 (guess it just re-created some parity
> information or however it works internally, but didn't have to copy
> any data)
>=20
> - right now I replaced one 750GB disk with a 1.5TB disk, but now
> resyncing (according to /proc/mdstat) it is supposed to take only 160
> minutes ?! although it needs top copy data to a blank disk ?

Just a guess...but your problem might be an artifact of a bug
that has been recently fixed.  Neil sent out mail on 2009-05-04
with the fix I'm thinking about.  Here is an excerpt from his
mail:

Subject: [md PATCH 4/7] md: tidy up status_resync to handle
large arrays.

Two problems in status_resync.
1. It still used Kilobytes as the basic block unit, while most
   code now uses sectors uniformly.
2. It doesn't allow for the possibility that max_sectors exceeds
   the range of "unsigned long".

So
 - change "max_blocks" to "max_sectors", and store sector numbers
   in there and in 'resync'
 - Make 'rt' a 'sector_t' so it can temporarily hold the number
   of remaining sectors.
 - use sector_div rather than normal division.
 - change the magic '100' used to preserve precision to '32'.
   + making it a power of 2 makes division easier
   + it doesn't need to be as large as it was chosen when we
   averaged speed over the entire run.  Now we average speed over the
   last 30 seconds or so.

> is this normal or should I be worried, especially before I pull out
> the next 750GB disk and replace it with the next 1.5TB disk ?

If your sync only takes 160 minutes...then I'd start to poke
around.  If its finishing time is reasonable considering the
array size, then I'd continue with the migration.
=20
> tnx in advance.

Bryan

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFKDCOQlSl3SAlkhEcRAj+UAJ9hFxdVly979QW156AeZx6XWM1NMwCdEI+E
l+Et2E+3HpwMv8idt8geURI=
=7C/L
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
