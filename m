From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: raidreconf aborted after being almost done
Date: Thu, 10 Mar 2005 11:31:53 +0100
Message-ID: <42302219.6090605@weisshuhn.de>
References: <1110443099.4230045b50735@www.rothert.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig829E85A5ACBA70E5F781ECA3"
In-Reply-To: <1110443099.4230045b50735@www.rothert.de>
Sender: linux-raid-owner@vger.kernel.org
To: yejj8xgg@rothert.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig829E85A5ACBA70E5F781ECA3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

yejj8xgg@rothert.de wrote:
> After searching the web I believe this is due to different disk sizes. Because I
> use different disks (vendor and type) having different geometries it is not
> possible to have partitions of exact the same size. They match as good as
> possible but some always have different amounts of blocks.

AFAIK the size of a block differs between disks with an unequal number 
of heads. I had this problem with some identical drives. (some with 16 
heads and some with 255)
It is possible to set these parameters with fdisk and have drives with 
equal geometry or (in case of different models) with comparible geometry 
which allows to have partitions of exactly the same size.

fdisk --help doesn't mention this possibility but ists manpage does:

Run fdisk with
fdisk -b <sectorsize> -C <cyls> -H <heads> -S <sects> device
and alter the partition table. Then exit with writing.
After that your disk has a new geometry.

Greetings,
Frank

--------------enig829E85A5ACBA70E5F781ECA3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFCMCIex6tzaD9P7mkRAi6NAJ92ww24wWMhYzFl7XWdePE+LL6WSwCeKkDW
diQxLkFtlhnN0irQmjU6PrI=
=pq0x
-----END PGP SIGNATURE-----

--------------enig829E85A5ACBA70E5F781ECA3--
