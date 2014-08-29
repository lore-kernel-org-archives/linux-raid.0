From: NeilBrown <neilb@suse.de>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Fri, 29 Aug 2014 14:35:28 +1000
Message-ID: <20140829143528.588cf640@notabene.brown>
References: <20140823163110.GE11855@bitfolk.com>
	<20140824130939.461501b4@notabene.brown>
	<20140824143944.GC19874@bitfolk.com>
	<20140825103234.GH11855@bitfolk.com>
	<20140825212614.5be558c9@notabene.brown>
	<20140825113402.GF19874@bitfolk.com>
	<20140829135312.5a6e78bc@notabene.brown>
	<20140829040231.GP19874@bitfolk.com>
	<20140829141812.17c35df7@notabene.brown>
	<20140829042618.GQ19874@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wZxCZG=udUaEbWA8Ln+39wY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140829042618.GQ19874@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wZxCZG=udUaEbWA8Ln+39wY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Aug 2014 04:26:18 +0000 Andy Smith <andy@strugglers.net> wrote:

> On Fri, Aug 29, 2014 at 02:18:12PM +1000, NeilBrown wrote:
> > Of course 'size' is in kilobytes, not sectors (which moron did that !??=
!?!)
> >=20
> > echo 309363696 > /sys/block/md2/md/dev-sda3/size
>=20
> Sorry, still no joy:
>=20
> # echo 309363696 > /sys/block/md2/md/dev-sda3/size
> # cat /sys/block/md2/md/dev-sda3/size
> 309363264

Try use "/bin/echo" so you get an error message.
Also try smaller numbers.  Can you write anything larger than what is alrea=
dy
there?  Increasing by 64 (match the 128 sectors that mdadm wants for
new_offset) should  be enough.

NeilBrown

--Sig_/wZxCZG=udUaEbWA8Ln+39wY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVAADEDnsnt1WYoG5AQJyAg/9Em0lbHq2/T532OOiWyT28PfqqvEjJ/z6
eQSxMu+AFOYBRgdbxukfunDC9mSCwjel5a9V2gAOlTCGjs3akt8RShVQJIqUB5/a
BakI3QHmt6X/90ImD2pxrEWTzfQEbmsiYdzGC/i0J1DuzPLiGwK26D5j6x6+Owhz
uPzlb7rAZlqNp418n9rjnZHScE4cZCdgw5PgjqapVcwOhBcVC+zpILm5HU55XFax
Q+AKFRBjFbPCy99AMgJtW6pfXrO3spN22+2Q2cm76DoRGz74zr8ULshxhCUDjTNr
GFl+m8QjdXJ0hSewrW1JX11BA3u5AmdnhVL6FCyE95frB1FzM8iXh/veDl1D+feb
EPfce3aZB7wE1Qlvavxibz6PqYFkX4fXwfDbkOaD/2v+xHzM+Md4BG317i5eXnng
xkpERZsrA97DR9yB7WpuDQk4/PSqx7w3xYhm6tdgwYJ0vnZ3xHdTLlYRlP+5kEbd
OaqBmiwoRCVscpYVcRqKb/++lnoFAjGGIvfu9taoKJq51iBoO1z4DcyVgyAAtZze
Sp+rfPy8a6deqoofalXrFC81a11+F5NZlAfa169PJywb2lUoSP1Jegn0h+gsTp4m
xRmSY8jaHpGck2kwpH+oqBOSjO8uU9UXvix4IvQsjQVXuPDt+eoMGNr/wUbol3aD
ZKp6IsUYnOA=
=Ux0a
-----END PGP SIGNATURE-----

--Sig_/wZxCZG=udUaEbWA8Ln+39wY--
