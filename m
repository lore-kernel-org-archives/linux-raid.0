From: Andy Smith <andy@strugglers.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 00:30:06 +0000
Message-ID: <20050103003005.GG99565@caffreys.strugglers.net>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es> <20050102194240.GE99565@caffreys.strugglers.net> <5h1ma2-asq.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3KzC5IXcIj3OgFK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5h1ma2-asq.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--u3KzC5IXcIj3OgFK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 02, 2005 at 09:18:13PM +0100, Peter T. Breuer wrote:
> Stephen Tweedie wrote:
> > Umm, if soft raid is expected to have silent invisible corruptions in
> > normal use,
>=20
> It is, just as is all types of RAID.  This is a very strange thing for
> Stephen to say - I cannot believe that he is as naive as he makes
> himself out to be about RAID here and I don't know why he should say
> that (presuming that he really knows better).
>=20
> > then you shouldn't be using it, period.  That's got zero to
> > do with journaling.
>=20
> It implies that one should not be doing journalling on top of it.
>=20
> (The logic for why RAID corrupts silently is that errors accumulate at
> n times the normal rate per sector, but none of them are detected by
> RAID (no crc), and when a disk drops out then you get a good chance of
> picking up a corrupted copy instead of a good copy, because nobody
> has checked the copy meanwhiles to see if it matches the original).

I have no idea which of you to believe now. :(

I currently only have one system using software raid, and several of
my employer's machines using hardware raid, all of which have
various raid-1, -5 and -10 setups and all use only ext3.

Let's focus on the personal machine of mine for now since it uses
Linux software RAID and therefore on-topic here.  It has /boot on a
small RAID-1, and the rest of the system is on RAID-5 with an
additional RAID-0 just for temporary things.

There is nowhere that is not software RAID to put the journals, so
would you be recommending that I turn off journalling and basically
use it as ext2?

What I do know is that none of what you say is in the software raid
howto, and if you are right, it really should be.  Neither is it in
any ext3 documentation and there is no warning on any distribution
installer I have ever used (those that understand RAID and LVM and
are happy to set that up at install time with ext3).  Also everyone
that I have spoken to about this knows nothing about it, so what you
are saying, if correct, would seem to have far-reaching
implications.

--u3KzC5IXcIj3OgFK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (FreeBSD)

iD8DBQFB2JINIJm2TL8VSQsRAluiAKCZRaUwKCzhQV9imr8fmDBaysQ3owCfRJxW
yMbEDP29VOPekPzLDChD5xU=
=YZ5i
-----END PGP SIGNATURE-----

--u3KzC5IXcIj3OgFK--
