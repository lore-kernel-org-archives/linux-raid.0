From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: dmraid - where is the raid done?
Date: Mon, 27 Oct 2008 11:07:42 -0400
Message-ID: <1225120062.20830.34.camel@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+VfiYMGtneFjuNjfg/tO"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-+VfiYMGtneFjuNjfg/tO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Somebody had suggested this list for this question:

I understand that dmraid is just some kind of interface to the
_software_ raid that is provided on a number of SATA interface cards
such as the Promise and Adaptec cards.

Reading http://ata.wiki.kernel.org/index.php/SATA_RAID_FAQ I get the
message loud and clear that this is not real hardware RAID but rather
it's done in the BIOS on the card.

The message there seems to be, if you are going to do it in software
anyway, why not just skip the IO card RAID and just use MD?

The one reason I could think of for using the BIOS provided RAID would
be to reduce the data needing to traverse the PCI bus.  With host-raid
(i.e. MD) every write to disk needs to actually be written over the PCI
bus twice, once for each disk, right?

But do the BIOS RAID cards out there only need the write command and
data once and they do the work of writing it to the two disks on-board
the IO card?

IIUC, when you have a BIOS RAID configured, even though there are two
disks, the operating system only sees one.  This would seem to support
the theory that the write only goes to the controller once and it takes
care of the mirroring, but I will defer to your experience.

Thanx,
b.

--=-+VfiYMGtneFjuNjfg/tO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkF2T4ACgkQl3EQlGLyuXB52gCg1v31KDXnC3xHovwhj5kZ/4gi
j7gAniXNwxzjpfgVXW79LkGb3Wi1LQFF
=j9mv
-----END PGP SIGNATURE-----

--=-+VfiYMGtneFjuNjfg/tO--

