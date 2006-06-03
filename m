From: Patrik Jonsson <patrik@ucolick.org>
Subject: Raid5 read error correction log
Date: Sat, 03 Jun 2006 16:26:09 -0700
Message-ID: <44821A91.8080007@ucolick.org>
References: <447FF458.6030802@frameandfocus.com> <17536.7877.532121.626175@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6E5402C740E8609A3BDF0B29"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17536.7877.532121.626175@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6E5402C740E8609A3BDF0B29
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey Neil,

It would sure be nice if the log contained any info about the error
correction that's been done rather than simply saying "read error
corrected", like which array chunk, device and sector was corrected. I'm
having a persistent pending sector on a drive, and when I do check or
repair, it says "read error corrected" many times, but I don't know
whether it's doing the same sector over and over or if there are just so
many of them...  I seem to remember reading something about this on the
list some time ago, is it already in the kernel? (I'm running 2.6.17-rc4
now).

Btw, when it does correct a read error, I assume it also tries to read
it again to verify that the correction worked?

thanks,

/Patrik


--------------enig6E5402C740E8609A3BDF0B29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEghqXT+KvsdUW5p8RApfmAJ9DOqHl3Cjj/fsD4WF7N2GAVx2RiACgpT9t
+z4TprvdL0Et0rSaU85YAIY=
=amci
-----END PGP SIGNATURE-----

--------------enig6E5402C740E8609A3BDF0B29--
