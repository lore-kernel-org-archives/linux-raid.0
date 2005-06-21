From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: from raidtools2 to mdadm
Date: Tue, 21 Jun 2005 14:59:54 +0900
Message-ID: <42B7ACDA.1000605@tequila.co.jp>
References: <42B7A866.1080802@tequila.co.jp> <17079.43900.652982.735401@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC46C5B6A4EBF716C9D999B03"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17079.43900.652982.735401@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC46C5B6A4EBF716C9D999B03
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/21/2005 02:54 PM, Neil Brown wrote:

>>#> mdadm --detail --scan>> mdadm.conf
>>
>>is enought to get the raid started the next time I have to reboot
>>the box.
> 
> 
> 1/ remove the 'devices=' parts.  Then it should be ok, providing there
>    is a suitable DEVICES line at the top.

yeah I have a devices line on the top. If I don't have, I will need the
devices lines I guess.

> 2/ If you were depending on 'raidstart' to start your arrays before,
>    mdadm will definitely be more reliable (which is to say that it
>    should still work if you lose the first drive of your array...)

no, it should be now called via the mdadm start

> 3/ Best way to find out is to try it!

well :) not if you have production boxes with sw raid :D

>>Until now I used only the raidtools (raidhotadd, lsraid, etc). Is there
>>somehwere a reference like what raidhotadd would be in mdadm
>>command?
> 
> 
> Well, there is the man-page for mdadm.  An understanding is always
> better than a cheat-sheet...

yeah, I am crawling through the docs, and man pages to get a thinking of it.

> But raidhotadd /dev/mdX /dev/hdY  -> mdaddm /dev/mdX --add /dev/hdy
>     s/add/remove/
>     raidstop -> mdadm --stop
> 
> There is no real equivalent for mkraid. mdadm --create does the same
> thing in a very different way.

yeah, but I more often have to add/remove a device than I have to create
a new raid, so its fine :)


-- 
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TEQUILA\ Japan IT Group                                    ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp                                   ]

--------------enigC46C5B6A4EBF716C9D999B03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFCt6zcjBz/yQjBxz8RAl0WAKDdIYi0HOykE0e1QewQ/7i3rqDshwCggEsV
qcwPj6o23gb6iTNXQ2P7T7k=
=6xH8
-----END PGP SIGNATURE-----

--------------enigC46C5B6A4EBF716C9D999B03--
