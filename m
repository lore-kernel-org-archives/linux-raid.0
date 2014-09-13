From: martin f krafft <madduck@madduck.net>
Subject: Speeding up reading with RAID1 and --write-mostly
Date: Sat, 13 Sep 2014 08:01:43 +0200
Message-ID: <20140913060143.GA15849@fishbowl.rw.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

my laptop still has a rotational disk, and also a MMC reader, which
I never use. Having seen some SSD laptops do things blazingly fast,
I wondered if I couldn't use the MMC to help.

Assuming there is a MMC fast enough out there, how about creating
a RAID1 across MMC and parts of the rotational disk, with the
rotational disk flagged --write-mostly? This RAID would then hold
the system, while the data would sit on the rotational disk.

The theory here is that writing is going to be expensive either way,
but most of system use is reading anyway.

Does this sound like an idea worth pursuing? I am asking because
I don't really want to experiment using this laptop, which is
currently my only machine. Have you done this? Have you any
thoughts? Or is this just a bad idea?

I would appreciate CCs on replies.

--=20
@martinkrafft | http://madduck.net/ | http://two.sentenc.es/
=20
"without a god, life is only a matter of opinion."
                                                    -- douglas adams
=20
spamtraps: madduck.bogus@madduck.net

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQLvBAEBCgDZBQJUE93EwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xNLh
D/40pI35o1mXpgiDp0AN5bJh3PC8mjSR2NQpGuQ5paIv8DXAud7nEXeEOAliHQp/
UfKvTMXsJY0XqxZrqiKT3jY9QDuSuIP9p8dPwgS6WOlkp4q+rucsct09hXbgK8o9
pKBevVsVpYOZ1Pcs453eeP/tZQK5i1b+XDzE2nEgGETPy3L6bq4UBoDgkoUxSjz8
+5RQr9Qvw0zwJPDTIYWIHBgfTu+bNhxrweze/rWY5bTovNSlhlOEQlbDK2CuRvg8
1Q4zYvdhmO6QCETwcsFQjrb1RakQ7VXfz5elWm4grVGCGYe9XvPNlravkRFoq+yU
huKKTMhaAjdn95kfrIAWJyMUOjLjjPDDK/5tspyzPAR3evi1hBshZ42/prvXTpix
oy8sxx5s6ixLJl4JJSRvouxphdKF/yb+MfDWCdYcrG2I6FjlAIhIZhdWwxAYwUfd
lPPTSvQcC8JZetzWGquAjxXyG5j0RmAXlwuN1aM/Ft8ovNgGzirnRkOatA9N3aDQ
66wkSpKX2LeSWnRFmJmnUe/wzrOhnpvudDq1BjbkvoGYoqu/U+wXhXoydMua1V6+
LM4kA+faciv/jPVfUijnJRiKK1fEF3oDrw6Uh/VY6AlDJSVv5+7eOuB9CT2sLVKf
Qp7Vhi/N8KXCUQsa03lqJasnoW4P0b1UF0oLUQISKFsPQg==
=trda
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--

