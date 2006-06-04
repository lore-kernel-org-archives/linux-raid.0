From: Andy Smith <andy@strugglers.net>
Subject: "command 0x25 timeout, stat 0x50 host_stat 0x1"
Date: Sun, 4 Jun 2006 00:05:45 +0000
Message-ID: <20060604000545.GT24455@strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yuedfix5hmtMJRO4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--yuedfix5hmtMJRO4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm building a system with 4 SATA ports based on Intel ICH7 and an
additional 2 ports on a Silicon Image 3112.  There are 6 Seagate
drives, all model number ST3320620AS.

Booting the system with a Knoppix 4 DVD (kernel version 2.6.12), I
went to set up the md arrays and got a syslog full of this:

ata2: command 0x25 timeout, stat 0x50 host_stat 0x2
ata1: command 0x25 timeout, stat 0x50 host_stat 0x1
ata1: command 0x25 timeout, stat 0x50 host_stat 0x1
ata1: command 0x25 timeout, stat 0x50 host_stat 0x2

as well as a painfully slow (~100K/sec) initial resync.

Googling about seems to show some problems related to Silicon Image
311x and Seagate drives, so I removed the Sil3112 and investigated
what happens with just the onboard ICH7 and 4 disks.  Unfortunately
I still get the same problems.

Has anyone ever come across this problem before and know where it
may lie, hardware or software?

Cheers,
Andy

--yuedfix5hmtMJRO4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEgiPZIJm2TL8VSQsRArtcAJ0TsNvPJHLY94Is1ztqbVKfmV4bwACgzT+x
5aTY/9SDZA6M5GkuXRpx6ss=
=CEZo
-----END PGP SIGNATURE-----

--yuedfix5hmtMJRO4--
