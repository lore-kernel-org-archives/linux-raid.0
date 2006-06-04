From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: "command 0x25 timeout, stat 0x50 host_stat 0x1"
Date: Sat, 03 Jun 2006 17:40:07 -0700
Message-ID: <44822BE7.4010905@ucolick.org>
References: <20060604000545.GT24455@strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC8CD0286BD3D01DB07CB5CFF"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060604000545.GT24455@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC8CD0286BD3D01DB07CB5CFF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andy Smith wrote:
> Hi,
>=20
> I'm building a system with 4 SATA ports based on Intel ICH7 and an
> additional 2 ports on a Silicon Image 3112.  There are 6 Seagate
> drives, all model number ST3320620AS.
>=20
> Booting the system with a Knoppix 4 DVD (kernel version 2.6.12), I
> went to set up the md arrays and got a syslog full of this:
>=20
> ata2: command 0x25 timeout, stat 0x50 host_stat 0x2
> ata1: command 0x25 timeout, stat 0x50 host_stat 0x1
> ata1: command 0x25 timeout, stat 0x50 host_stat 0x1
> ata1: command 0x25 timeout, stat 0x50 host_stat 0x2
>=20
> as well as a painfully slow (~100K/sec) initial resync.
>=20
> Googling about seems to show some problems related to Silicon Image
> 311x and Seagate drives, so I removed the Sil3112 and investigated
> what happens with just the onboard ICH7 and 4 disks.  Unfortunately
> I still get the same problems.
>=20
> Has anyone ever come across this problem before and know where it
> may lie, hardware or software?

Hey,
I shot in the dark, but cabling might be a culprit. I've had some issues
with cables, both with the ridiculously unreliable SATA connectors
coming out a little as well as with cables which must have been
insufficiently shielded. They all resulted in some similar messages
about timeouts. One thing to try if these are 3.0gbs drives would be to
jumper them to 1.5 (if possible) and see if that makes a difference. Or
try another cable.

/Patrik



--------------enigC8CD0286BD3D01DB07CB5CFF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEgivnT+KvsdUW5p8RAjorAKCQM/eEvFrfoQBcEv96gheQzawCdQCff3B2
1DxUt8vfq/lEaoGubfcNsF4=
=M49L
-----END PGP SIGNATURE-----

--------------enigC8CD0286BD3D01DB07CB5CFF--
