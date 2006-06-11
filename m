From: Andy Smith <andy@lug.org.uk>
Subject: Re: "command 0x25 timeout, stat 0x50 host_stat 0x1"
Date: Sun, 11 Jun 2006 15:09:15 +0000
Message-ID: <20060611150915.GL32471@strugglers.net>
References: <20060604000545.GT24455@strugglers.net> <44822BE7.4010905@ucolick.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWOmaDnDlrCGjNh4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44822BE7.4010905@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--pWOmaDnDlrCGjNh4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 03, 2006 at 05:40:07PM -0700, Patrik Jonsson wrote:
> Andy Smith wrote:
> > Booting the system with a Knoppix 4 DVD (kernel version 2.6.12), I
> > went to set up the md arrays and got a syslog full of this:
> >=20
> > ata2: command 0x25 timeout, stat 0x50 host_stat 0x2
> > ata1: command 0x25 timeout, stat 0x50 host_stat 0x1
> > ata1: command 0x25 timeout, stat 0x50 host_stat 0x1
> > ata1: command 0x25 timeout, stat 0x50 host_stat 0x2
> >=20
> > as well as a painfully slow (~100K/sec) initial resync.

[...]

> I shot in the dark, but cabling might be a culprit. I've had some issues
> with cables, both with the ridiculously unreliable SATA connectors
> coming out a little as well as with cables which must have been
> insufficiently shielded.

It actually seems to have been power related.  I'm using Icydock
SATA disk chassis which have two molex power connectors and one SATA
power connector for 3 drives.  I had thought that the differing
types made it an either/or situation, i.e. that it would be happy
with the two molex.  The "documentation" is what I would charitably
call terse.  Anyway after putting in the 3rd SATA power this problem
went away.

Cheers,
Andy

--pWOmaDnDlrCGjNh4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEjDIbIJm2TL8VSQsRAsj+AJ9WhC/sjX9lFXZTG6LhqqvjrCXRGwCgypNa
s6cK5TnT7yWswgPJX2aaURw=
=BYLy
-----END PGP SIGNATURE-----

--pWOmaDnDlrCGjNh4--
