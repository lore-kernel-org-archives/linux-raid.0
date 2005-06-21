From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: from raidtools2 to mdadm
Date: Tue, 21 Jun 2005 15:32:42 +0900
Message-ID: <42B7B48A.4000402@tequila.co.jp>
References: <42B7A866.1080802@tequila.co.jp>	<17079.43900.652982.735401@cse.unsw.edu.au>	<42B7ACDA.1000605@tequila.co.jp> <17079.45804.485652.77989@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0CCF0A664370865A5575803F"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17079.45804.485652.77989@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0CCF0A664370865A5575803F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/21/2005 03:25 PM, Neil Brown wrote:

> No..
> The 'devices=' bits by themselves aren't enough, and are rarely
> wanted.
> If a device isn't listed in the DEVICES lines, then it won't be
> considered for use in an array.

okay

> The 'devices=' words are quite different.  They say "this is how you
> recognise a device that is in this array.  All the devices in it are
> on this list".
> This is reported by "mdadm --detail --scan" largely for interest.  It
> should rarely be included in mdadm.conf.  The very latest version ofn
> mdadm does not report them unless --verbose is given.

okay, then I have an old one, because mine gives it to me, thats why I
had it in my conf file.

thanks for all the help

-- 
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TEQUILA\ Japan IT Group                                    ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp                                   ]

--------------enig0CCF0A664370865A5575803F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFCt7SMjBz/yQjBxz8RAkPXAJwN9R/ScvdVwbhksj/rLMI38Lmx/ACgpVVB
xjak9JDRwOoSHD65pyIfUbI=
=BevH
-----END PGP SIGNATURE-----

--------------enig0CCF0A664370865A5575803F--
