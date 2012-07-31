From: NeilBrown <neilb@suse.de>
Subject: Re: Version 3.2.5 and ddf issues (bugreport)
Date: Tue, 31 Jul 2012 16:11:15 +1000
Message-ID: <20120731161115.46b96f90@notabene.brown>
References: <4D8A4780.2030401@gmail.com>
	<20110324090837.689c5a0e@notabene.brown>
	<5013D0FE.3020906@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SG0qlNasSAwicZLtWWQI9Kl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5013D0FE.3020906@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SG0qlNasSAwicZLtWWQI9Kl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Jul 2012 13:46:06 +0200 Albert Pauw <albert.pauw@gmail.com> wrot=
e:

> Hi Neil,
>=20
> After a hiatus of 1.5 year (busy with all sorts) I am back and tried the=
=20
> ddf code to see how things improved.

Thanks!

>=20
> I build a VM Centos 6.3 system with 6 extra 1GB disks for testing.
> I found several issues in the standard installed 3.2.3 version of mdadm=20
> relating to ddf, but installed the
> 3.2.5 version in order to work with recent code.
>=20
> However, while version 3.2.3 is able to create a ddf container with=20
> raidsets in it, I found a problem with the 3.2.5 version.
>=20
> After initially creating the container:
>=20
> mdadm -C /dev/md127 -e ddf -l container /dev/sd[b-g]
>=20
> which worked, I created a raid (1 or 5 it doesn't matter in this case)=20
> in it:
>=20
> mdadm -C /dev/md0 -l raid5 -n 3 /dev/md127
>=20
> However, it stays on resync=3DPENDING and readonly, and doesn't get build.
>=20
> So I tried to set it to readwrite:
>=20
> mdadm --readwrite  /dev/md0
>=20
> Unfortunately, it stays on readonly and doesn't get build.
>=20
> As said before, this did work in 3.2.3.
>=20
> Are you already on this problem?

It sounds like a problem with 'mdmon'.  mdmon needs to be running before the
array can become read-write.  mdadm should start mdmon automatically but
maybe it isn't.  Maybe it cannot find mdmon?

could you check if mdadm is running?  If it isn't run
   mdmon /dev/md127 &
and see if it starts working.

>=20
> Kind regards,
>=20
> Albert
>=20
> P.S. My idea was, because the ddf code is not that much used, to create=20
> a test/validate script for ddf.
>=20
There is one 'ddf' test in my test suite and I think it is working.  I'm
happy to add more tests if you suggest or write some.

NeilBrown


--Sig_/SG0qlNasSAwicZLtWWQI9Kl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBd3Aznsnt1WYoG5AQKLcA/+Il4yl08CTux5IelmsnoxgS67aNCZQfwe
+gqML1XCOqWDObg0NWOmQJZtrLR5QkFwJkecobnZUtREpHJfDXEvoa/jeZntkLjD
HRbslCHYkaPQoGGM/qGSTr3TG66JTPS55Mi+2qy3KJaW8DFuPOc82EWqOmVff40w
Z+umHmauXgCzy+vsdAN9EjpPFtAOh2WfT2pE4CIrg5F/R4RK/eieMNBf/7b8SI/O
UJBwacmKaMgqu1CNvBRO/GLWNk2rdL/1yamORXXBEOwa2JkdJKz0nQ3KKAwVnY9S
F3vL0e/OXeda6nN8nI8g93WJTRlPfoWdu34QlsF149bjt75ZvNKf4RHX5tGPg+pR
74QajbwkI0AI7wfSpdmI9I+BeYg68ZjxE6lSrmKR+yiXZfWHcRg11AV2DSwM7GrB
miGWaR4VwAjNLYowV514NIv4YupMAc3WJBtehel8oSnl203AXt9fmxrvpljCIkTt
DJHVSIQHdSk84vg/JtsvPoSmqZMpIcs4LfTHv5YjZ/2R9Rd5PGa6FCkjXOVmzJD2
rdtNPhloccwaWaMDoVBpO0H5SJLFQnTy3AX/GYOG1KzT/cs8nmrlqzlClnP0gyWf
0BbHfz+mIkQhpkcC4PS4Lp8Fup8kbF1puJQsbvymDNMkIX8ee8hd5PwsyTzJ4Ggo
iurskRS+lqs=
=/3/6
-----END PGP SIGNATURE-----

--Sig_/SG0qlNasSAwicZLtWWQI9Kl--
