From: NeilBrown <neilb@suse.de>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Fri, 29 Aug 2014 14:18:12 +1000
Message-ID: <20140829141812.17c35df7@notabene.brown>
References: <20140823163110.GE11855@bitfolk.com>
	<20140824130939.461501b4@notabene.brown>
	<20140824143944.GC19874@bitfolk.com>
	<20140825103234.GH11855@bitfolk.com>
	<20140825212614.5be558c9@notabene.brown>
	<20140825113402.GF19874@bitfolk.com>
	<20140829135312.5a6e78bc@notabene.brown>
	<20140829040231.GP19874@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wJ/tdu.VKjut5mXq4K6PzTc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140829040231.GP19874@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wJ/tdu.VKjut5mXq4K6PzTc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Aug 2014 04:02:31 +0000 Andy Smith <andy@strugglers.net> wrote:

> Hi Neil,
>=20
> On Fri, Aug 29, 2014 at 01:53:12PM +1000, NeilBrown wrote:
> > You need to
> >   echo 618727392 > /sys/block/md2/md/dev-sda3/size
> > and same for the other devices.
> >=20
> > I looks like I need to get mdadm to be more clever when it gets -E2BIG.
> > Can you check that the above works?
>=20
> Unfortunately it seems I cannot change that size:
>=20
> # echo 618727392 > /sys/block/md2/md/dev-sda3/size
> # cat /sys/block/md2/md/dev-sda3/size
> 309363264
>=20

Of course 'size' is in kilobytes, not sectors (which moron did that !??!?!)

echo 309363696 > /sys/block/md2/md/dev-sda3/size

NeilBrown

--Sig_/wJ/tdu.VKjut5mXq4K6PzTc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU///BDnsnt1WYoG5AQKTBA//afDhAP0I3VUerK55hhjWK3zWe7e+3aoM
c0lgfO5euA1qJPBHfUDIyV0r8UPTCn/1ttfyMMiwiH71sWsWY1z3vz0LGEAh4i+6
hL/0I218eCy4l9EMCsBdJTRP1oIN2nSUxOvticICjToYrsCsvMCjHHYxyUf1uBx2
xThDP2CTSDYHxbJCMk7L5Q/lmBPJ4HGfML9anMzDJZOKJ9SqEWPdMHVWNPq+1iKN
KTss6PuPcfOGb94aLvmhYbTpY89yZ1Q+GsXjrXXoBrcvKlBGjlAg8yBPGil7n3h8
h2G30Z7n79XO05mJ23Oi6IsiD5fXVUWGUBJxnZUHsZN3oSfew+llGJGi9AluW/Rg
/fuD5hrPwuq57vctl4lG26P139R52ehmfnu1+ctFJuUDr3RGcJRfREvEzM31J10e
VUNxd1J8gxP7EfEK6NnyH0bkmLjS5MlHdFOOvMUvKhYnqZ09tDGsh1VBZOH8KMYu
XNNi6JMKXa1F9rkSA45UWD+eiAHgz2S1JiIUmoNc8jeTLiI/j5rmGgXS3XG5TZd6
Q0Fde3NrQlOnygpOtvJCqzlr+Gl7IElL8SiPavp2LoSdCpOHxKK4OFHILKCfkcrl
gf850dLKT8Glr7Yn4ascDrq9fGueCRK4jif0OZ8RhPszSYOAPiCCkvVHohB80254
WOqaFQHbomQ=
=rjho
-----END PGP SIGNATURE-----

--Sig_/wJ/tdu.VKjut5mXq4K6PzTc--
