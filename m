From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: HD with different cluster size
Date: Fri, 13 May 2005 17:09:03 +0900
Message-ID: <4284609F.1000501@tequila.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFA11FFBF4725A3914BAD686B"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFA11FFBF4725A3914BAD686B
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

I have a raid5, one disk went bad, so I got a replacement one. Sadly
this SW raid is created out of externel HDs (IDE in a box, then via
SCSI). So the new one has a slightly different HD inside with a slitly
smaller in cluster size.

Now my question is. Is there a way to resize all the other HDs "live" ?
I doubt that. I would need to re-create the whole raid so all the other
partitions are slightly smaller? It might be better to just get a bigger
HD and then create a smaller partition inside I think.

-- 
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TEQUILA\ Japan IT Group                                    ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp                                   ]

--------------enigFA11FFBF4725A3914BAD686B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFChGCgjBz/yQjBxz8RAsokAKCpZlVVEcevE27vC+h/wpcWpQ76ugCeMeJS
azk7h7Mye4+nArRiWW6LQ34=
=Bn1u
-----END PGP SIGNATURE-----

--------------enigFA11FFBF4725A3914BAD686B--
