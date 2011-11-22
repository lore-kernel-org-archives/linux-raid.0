From: NeilBrown <neilb@suse.de>
Subject: Re: Disk identity crisis on RAID10 recovery (3.1.0)
Date: Wed, 23 Nov 2011 07:00:39 +1100
Message-ID: <20111123070039.707de7cd@notabene.brown>
References: <4ECB7649.6080505@dentonet.pl>
	<20111122221522.3f525fc6@notabene.brown>
	<4ECB940C.6010707@dentonet.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6T91o0R7.icvBZwidn_ZO_h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ECB940C.6010707@dentonet.pl>
Sender: linux-raid-owner@vger.kernel.org
To: krzepecki@dentonet.pl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6T91o0R7.icvBZwidn_ZO_h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 13:22:36 +0100 Konrad Rzepecki <krzepecki@dentonet.pl>
wrote:

> W dniu 22.11.2011 12:15, NeilBrown pisze:
> > You can probably get your data back... but really you should have=20
> > asked for
> > help as soon as strange things started happening!
>=20
> Possibly, but I don't like to bother others when I don't need to. And in=
=20
> the beginning
> I didn't connect this behavior whit kernel but with some hardware disk=20
> issues.
>=20
> Moreover reporting bugs on list is hmm... inconvenient. Please, back=20
> Bugzilla
> online ASAP.

Personally, I *much* prefer email.   I do normally respond to things on
bugzilla (When bugzilla is working) but I don't like to.

>=20
> > If you have all important data backed up then just upgrade to 3.1.2=20
> > and make
> > the array again  from scratch.
>=20
> Probably this is best way...
>=20
> > If you want to try to recover the array please report that output of=20
> > "mdadm
> > --examine" on all of the devices.
>=20
> ...but I paste output of this commands below. If some of system survive,=
=20
> I can
> make it up faster. Of course, if it isn't to complicated or take too much=
 of
> your time to describe it.

As you've managed to get it going on a previous kernel I won't spend any ti=
me
on this.

Glad you have a satisfactory resolution (and sorry than 3.1 is broken :-( )

NeilBrown



--Sig_/6T91o0R7.icvBZwidn_ZO_h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsv/Zznsnt1WYoG5AQJKUg/5ARDVKgADOVjyTP3MCRjAwtxvSoaF+XUD
5ZC4ioctyav2HO0aACIpETiXBKnbWDNNKr7/47sEEmxirJKnq6N5NyDCFKPCgrYd
UhPG8FEVBKfnCnI796iWERUEFEOW6rbt8Q+oJjZfcyjo9I0+xIoOa3HUWN4Ez5kX
lxHIIxxpaKHm/zTWiX+Odkpwz9ff0LpXsJmeTaw282j6llOXAM43K3QTQJQQztjV
QKazwQtqnTKcdlCHpUtI9GPzMo28rR+3rwdW0kpgxDxOWXya2ZkxVJrKskXq1CXD
xjeaqIUJ+DSoDkQ63UFjb2Keyf00SEpvlO8OnXJndc45AQ2qx4zRcsG0xnimZEhg
Ul+ei+tqH+c/0mlATOkTOF4C5WntwKX/qQ5w1PCLWPdMqXb3Hst3XnicnxlhI841
mKCtta5WtOQ2sALMEnrnKx6l0k9dIs2D0bLG3OQUJuwzFRRyFk7doO4EAlInNxUU
cujHBkapJko32cg2X/JmY0GKMAS3hIxrYW85tInFyG6t1O9p5ggxXOOBwPWUOoU9
VNwu++REUoZ2r7KnuAL+uDuz1mjfIVpgbyzO2+vgia04IjZ1Py2/CDmJqw+370KZ
YdOfQ6TG/RGxTtMpU8U6SAW6CFr1vWFjutKUKCGOD80y1ogPR0E2jmdigxH3ExdC
95gqKiGG++U=
=bPLr
-----END PGP SIGNATURE-----

--Sig_/6T91o0R7.icvBZwidn_ZO_h--
