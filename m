From: Doug Ledford <dledford@redhat.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Thu, 01 Nov 2007 15:20:39 -0400
Message-ID: <1193944839.10336.686.camel@firewall.xsintricity.com>
References: <20071030210721.386ca2fa@absurd>
	 <1193781699.10336.585.camel@firewall.xsintricity.com>
	 <472A0D7A.4040807@zytor.com>
	 <1193941858.10336.659.camel@firewall.xsintricity.com>
	 <20071101200419.0cdbb396@absurd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/zZnslNPogTjsGMwppCa"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071101200419.0cdbb396@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-/zZnslNPogTjsGMwppCa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-01 at 20:04 +0100, Janek Kozicki wrote:
> Doug Ledford said:     (by the date of Thu, 01 Nov 2007 14:30:58 -0400)
>=20
> > So, what I said is true, the MBR will search on the disk it is being ru=
n
> > from for the files it needs: 0x80.
>=20
> my motherboard allows to pick a boot device if I press F11 during
> boot. Do you mean, that no matter which HDD I will choose it will
> have 0x80 number?

All the motherboard BIOS drive mapping things I've seen will do exactly
that.  In order to boot from say drive sda when hda is present, they map
BIOS device 0x80 to sda instead of hda.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-/zZnslNPogTjsGMwppCa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHKicHTzP9PM7pjw8RAlSqAJ9tbMSIQl1OqgSsW8GMSse1y7kYXACfVH0H
EglCUwdURg0aSfCgAFUCENY=
=Ziey
-----END PGP SIGNATURE-----

--=-/zZnslNPogTjsGMwppCa--

