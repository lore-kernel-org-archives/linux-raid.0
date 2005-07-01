From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: A general Raid 5 question
Date: Fri, 01 Jul 2005 13:36:38 +0900
Message-ID: <42C4C856.50908@tequila.co.jp>
References: <5d96567b050622103157ada455@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3561AAEC4F2F4B39C6842E5D"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b050622103157ada455@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3561AAEC4F2F4B39C6842E5D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/23/2005 02:31 AM, Raz Ben-Jehuda(caro) wrote:
> If I pull the plug out from my machine while io is being generated. 
> Is there a chance that  i would loose the raid ( obviously i would
> loose some data).
> I am refering to raid with no backup battery unit or anything of that sort.
> 
> I tried to do it and the worst case was that the rebuilding was long (
> both in software raid and hardware raid -- 3ware ).
> 
> I would appreciate answers

I have several hardware raid5 and one sw raid5 and I never had any kind
of issues during my initial test. Although I haven't had a poweroutage
to the box (well you should have UPS in front anyway), I had two other
lockups (some netaltalk issues) but the raids stayed all very fine.

-- 
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TEQUILA\ Japan IT Group                                    ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp                                   ]

--------------enig3561AAEC4F2F4B39C6842E5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFCxMhYjBz/yQjBxz8RAqxiAJ9A2FLRRV6IghB8L/co3JzSnJQrWACeOfAt
TknmdBVz+ehI1fLvXYcWDkM=
=8kj+
-----END PGP SIGNATURE-----

--------------enig3561AAEC4F2F4B39C6842E5D--
