From: NeilBrown <neilb@suse.de>
Subject: Re: RAIS5 Rebuild Help - Possible Data Offset
Date: Mon, 31 Mar 2014 19:37:04 +1100
Message-ID: <20140331193704.609a7f1f@notabene.brown>
References: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
	<20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
	<CAFth78xfsaBLzg9TC=UkEoQiafpg-oVJyoxbYgWyrVHCyAuHew@mail.gmail.com>
	<20140331172953.3f37f6c2@notabene.brown>
	<CAFth78wtf5X0ycUuKCTV3QSvs4Uv8mvvZYH2Vqhwc2WwOqkHfg@mail.gmail.com>
	<20140331181227.69c4e583@notabene.brown>
	<CAFth78xfP7rEVJxWS=aL0zUPGSyDnmrPWcgE=XxjYSuWU4_zvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PGNYY69UNSweIjjkeGkSQHa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFth78xfP7rEVJxWS=aL0zUPGSyDnmrPWcgE=XxjYSuWU4_zvQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yorik <yoriks13@westnet.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PGNYY69UNSweIjjkeGkSQHa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Mar 2014 15:24:07 +0800 Yorik <yoriks13@westnet.com.au> wrote:

> Hi Neil
>=20
> Thanks for your quick reply. :) Output as follows. and yes I agree.
> sdf is strange, also some devices think the Array has different number
> of devices Active.. It all got quite muddled up at the time of
> failure.

So.....
sdf thinks
   Raid Devices : 6
others think
   Raid Devices : 8

So that's not going to work.
However if we just ignore sdf, then sdg and sdi thinkg

     Array UUID : a5cb0ced:fee37e80:bb291f1a:c5b2f600

while the rest think:

     Array UUID : e32ad2c6:5f99dd8f:2572c3a8:c485db00

So you have at most 5 device which think they are the same array,
which isn't enough for an 8-device RAID6.

It looks like you have tried to --create the array several times,
at

  Creation Time : Tue Feb  4 00:28:54 2014
  Creation Time : Tue Feb  4 00:33:56 2014
  Creation Time : Tue Feb  4 00:38:19 2014

to be precise.

Your only real chance is to find out the real geometry of the
array before all the problem happened, and create it properly...
It might be worth checking sda sdb and sdc (with out partitions)
as well as sdd1 sde1 sdf1 sdg1 sdi1 to see if there is anything there.

But if you have backups or some other way to regenerate the data ......

NeilBrown

--Sig_/PGNYY69UNSweIjjkeGkSQHa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUzkpMTnsnt1WYoG5AQKHaBAAv+KcAaWZglmx7oznqTAMKnsVTCAA8hqD
M1KdeYbWimMxwQ0+aXTCSc4xg2acuJvUlzABY5cC4YHsRGzH6YF7QuGfPLaYAdef
k+9jnQMWxpJaCABdejfz3JxyJ7HS+HeGYTn5QrBaXh2Q1PUDdAN/FcbTPwEKyyIQ
mjY81sosjn/AkZ8qD25ydryu8wU5A2O1AWZ7bNpwjjuOIFeTyUqL+75K2puxmNiI
0er4wF2F6nnjdnRx79KQCkPGsfHNNxWP/MAqTn7AxzPfU2pcPKhMiIqjaGBpkxGN
xH1OFD+P7a91qUjAn4xOfugvM9LACswrR9OLJBoJUk8pJRtaZ0qK499T3bs51o/L
Rr9lE3RSDgTKv9ZpgQyIURHsTL7Adyh7tiBBkUsAwQoSW+eNopVa1hEFd8wgAT5X
iY816DqDaJtFbFuBf4V4WtHnwUhPbmptGhQ9dbI1vX7yzzc3NeZJkKpnNIaQ3bMg
2PYscVfNNC7Tk+lCJM8nkRhnlO+7Nn/HDgGmehuLugJY8bPE50A7OolxlOGaKDB1
uOluC1eqEJoIcvdEGoVKixpjnW8cEx3taz6DcZVMIPqStecV+xO/ULq+74J4T5xV
OiE7gyTeEU4RoWSSrbj7kYUwBUWEajrqr2wvO7IO6k1ZXrghsWgWDgaVUplekXIf
/QPIAo11wNA=
=EBJl
-----END PGP SIGNATURE-----

--Sig_/PGNYY69UNSweIjjkeGkSQHa--
