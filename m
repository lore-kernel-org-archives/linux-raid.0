From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: safest way to swap in a new physical disk
Date: Wed, 15 Nov 2006 16:02:52 -0700
Message-ID: <1163631772.3742.55.camel@x1-6-00-0d-60-fd-e8-4c>
References: <6D7E98FD-D24F-402D-A7F0-63179FA3C49E@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IkHkpI790U47leOPO8j6"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6D7E98FD-D24F-402D-A7F0-63179FA3C49E@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Will Sheffler <willsheffler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-IkHkpI790U47leOPO8j6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Oops, I forgot to mention that the RAID should recover before you go on
to the next disk.  Thus, number five should read:

5.  Verify that the disk has rebuilt.
   mdadm -D /dev/md0
   cat /proc/mdstat
    Once it has completed syncing, then repeat with the second drive.

Forrest

--=-IkHkpI790U47leOPO8j6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBFW5ycaUnzBifbsNQRAkiRAJ98ObBBF5raK14Jm0hZS/HpdW/gDQCgkeoh
6zaJGGWKf1RP5odFEdiTiuI=
=fkJa
-----END PGP SIGNATURE-----

--=-IkHkpI790U47leOPO8j6--

