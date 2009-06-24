From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH/RFC] md: Push down data integrity code to personalities.
Date: Wed, 24 Jun 2009 15:25:07 +0200
Message-ID: <20090624132507.GD6403@skl-net.de>
References: <20090619141419.GB11504@skl-net.de> <yq11vpbv9ki.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EcSFpNr6Vcxykj4g"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq11vpbv9ki.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--EcSFpNr6Vcxykj4g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:49, Martin K. Petersen wrote:

> There was a slight conflict in latest md.h against current Linus.  You
> may want to respin.

Jup, but it's trivial to fix. Neil, do you want me to resend?

> I tested on a few different configurations adding and removing devices
> with and without integrity enabled.  Looks good on this end.
>=20
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks. Btw, below is a trivial patch that fixes two typos in
Documentation/block/data-integrity.txt. While reading the paragraph

	Layered block devices will need to pick a profile that's
	appropriate for all subdevices.  blk_integrity_compare()
	can help with that.  DM and MD linear, RAID0 and RAID1 are
	currently supported.  RAID4/5/6 will require extra work due
	to the application tag.

I was wondering why raid10 is not mentioned and whether someone is
currently working on data integrity support for raid levels 4/5/6.

Andre

commit 5fa2be272d578d9043bd0d9102ecb257cfba8fb8
Author: Andre Noll <maan@systemlinux.org>
Date:   Wed Jun 24 15:22:47 2009 +0200

    Trivial typo fixes in Documentation/block/data-integrity.txt.
   =20
    Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/Documentation/block/data-integrity.txt b/Documentation/block/d=
ata-integrity.txt
index e8ca040..2d735b0 100644
--- a/Documentation/block/data-integrity.txt
+++ b/Documentation/block/data-integrity.txt
@@ -50,7 +50,7 @@ encouraged them to allow separation of the data and integ=
rity metadata
 scatter-gather lists.
=20
 The controller will interleave the buffers on write and split them on
-read.  This means that the Linux can DMA the data buffers to and from
+read.  This means that Linux can DMA the data buffers to and from
 host memory without changes to the page cache.
=20
 Also, the 16-bit CRC checksum mandated by both the SCSI and SATA specs
@@ -66,7 +66,7 @@ software RAID5).
=20
 The IP checksum is weaker than the CRC in terms of detecting bit
 errors.  However, the strength is really in the separation of the data
-buffers and the integrity metadata.  These two distinct buffers much
+buffers and the integrity metadata.  These two distinct buffers must
 match up for an I/O to complete.
=20
 The separation of the data and integrity metadata buffers as well as
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--EcSFpNr6Vcxykj4g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKQikzWto1QDEAkw8RAr88AJ4hjpiMhSwDM87Nro6+XKEyoYuVAQCfa9ZA
DNALoyILkwXGwcmeW1KMjhA=
=NZiS
-----END PGP SIGNATURE-----

--EcSFpNr6Vcxykj4g--
