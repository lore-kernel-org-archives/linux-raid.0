From: Andy Smith <andy@lug.org.uk>
Subject: paralellism of device use in md
Date: Tue, 17 Jan 2006 12:09:27 +0000
Message-ID: <20060117120927.GU7017@strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qqF1XwZUdAkx0x+N"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--qqF1XwZUdAkx0x+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm wondering: how well does md currently make use of the fact there
are multiple devices in the different (non-parity) RAID levels for
optimising reading and writing?

For example, are *writes* to a 2 device RAID-0 approaching twice as
fast as to a single device?  If not, are they any faster at all?
Are reads from a 2 device RAID-1 twice as fast as from a single
device?  If there are benefits, how quickly do they degrade to
nothing as disks are added?

What does the picture look like for reads and writes to a 4 device
RAID-10?

Sorry if my subject line isn't clear, but I coudn't think of a
better way to put it.

Thanks,
Andy

--qqF1XwZUdAkx0x+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDzN53IJm2TL8VSQsRAgCPAKCW9f1SDORnLp9cmYlojntAgoiZTgCgiMq3
mEYPzLcdIqV1hVZxpQWJURU=
=Kxuf
-----END PGP SIGNATURE-----

--qqF1XwZUdAkx0x+N--
