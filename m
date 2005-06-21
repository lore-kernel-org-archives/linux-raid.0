From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: from raidtools2 to mdadm
Date: Tue, 21 Jun 2005 14:40:54 +0900
Message-ID: <42B7A866.1080802@tequila.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig96F0C6A37FCE0F04D64671A6"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig96F0C6A37FCE0F04D64671A6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

as debian changed their package from raidtools2 to mdadm and left us
users out in the cold (no mdadm.conf craeted, lsraid commands left in
crontab, etc), I am now a bit worried if the command

#> mdadm --detail --scan>> mdadm.conf

is enought to get the raid started the next time I have to reboot the box.

Until now I used only the raidtools (raidhotadd, lsraid, etc). Is there
somehwere a reference like what raidhotadd would be in mdadm command?

-- 
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TEQUILA\ Japan IT Group                                    ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp                                   ]

--------------enig96F0C6A37FCE0F04D64671A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFCt6hojBz/yQjBxz8RAtMfAKCSxalyWKSEgFP66mSyVYfibQKQ0gCgipSe
5xCrEeRjM0cj98n1Qd9mRd0=
=kex4
-----END PGP SIGNATURE-----

--------------enig96F0C6A37FCE0F04D64671A6--
