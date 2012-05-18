From: NeilBrown <neilb@suse.de>
Subject: Re: Creating a 3-disk RAID6 array
Date: Fri, 18 May 2012 17:57:00 +1000
Message-ID: <20120518175700.61337765@notabene.brown>
References: <4FB4534A.5070608@volatilevoid.net>
	<20120517113817.7faf9c1e@notabene.brown>
	<4FB4FAA9.7000100@hesbynett.no>
	<4FB50573.6020604@anonymous.org.uk>
	<4FB5FAA7.4090401@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N6KUhbJhPuuQmNg_TZQy.Lc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB5FAA7.4090401@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, David Brown <david.brown@hesbynett.no>, Oliver Martin <oliver@volatilevoid.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/N6KUhbJhPuuQmNg_TZQy.Lc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 May 2012 00:30:47 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 05/17/2012 07:04 AM, John Robinson wrote:
> > On 17/05/2012 14:18, David Brown wrote:
> > [...]
> >> Theoretically, a 3-disk RAID6 is like a 2-disk RAID5 or a 1-disk RAID1=
 -
> > [...]
> >> I can't think of any good reason for it /not/ to support 3-disk
> >> RAID6, as there is nothing in the algorithms to hinder it.
> >=20
> > I've a vague recollection of Peter Anvin saying the implementation is
> > optimised in such a way that it won't work.
> >=20
>=20
> Yes, it would have required introducing some odd special cases.  A
> 3-disk RAID-6 is bitwise identical to a 3-disk RAID-1, so if Neil wants
> to he could add "instant reshaping" support in mdadm (add a disk to a
> 3-disk RAID-1 turning it into a 4-disk RAID-6; and similar for 2-disk
> RAID-1 into 3-disk RAID-5.)
>=20
> 	-hpa
>=20

Converting a 2-disk RAID-1 to a 3-disk RAID-5 is not instant.
You first convert a 2-disk RAID-1 to a 2-disk RAID-5.  Then you re-stripe t=
he
RAID-5 to have 3-disks.  During this restripe, part of the array looks like=
 a
2-disk RAID-5, and part looks like a 3-disk RAID-4.

To convert some sort of RAID1 to RAID6 we would need to be able to support a
3-disk RAID-6, if only for a relatively short time.

Possibly we could special case the parity-generation code to just copy the
data block when data-disks=3D=3D1.  That sound easy enough...
But the raid456 module needs to understand this
3-way-RAID1-pretending-to-be-RAID6, we cannot use the raid1 module to do it.

NeilBrown

--Sig_/N6KUhbJhPuuQmNg_TZQy.Lc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7YAzDnsnt1WYoG5AQJNJhAArSslZ+4T9UJLJC5jrCZqps1AETdPzocw
/yH9CbQqAacb4Ilfhq4Ia86izR1UyvLJeq2r+Ku6sFuXYuJnv7slVqJqvI9JOyDX
zcdeZsd9JuH+gol6yK7qNVB3KvyyIbdLYXk70mN+WyVmJKWVvBMMGu1lok9fuo4F
DiLMmYpF2rhqU0xUDan5g9UY5WA5Rkt/bpUy84FhvYXcJrKWdKGwBa580+h8qtgX
eBk1MpjPEApQsBS6eCTONcLEVGxVXnwE8CZXM6+qxDYMKYVlJto5CIC00lXMntVc
sCgD8nsAz+XLbuWdxXlwQ0oX9qwPhtti3A2mkJSezC7xgK/+oCHSIP/u8ixYGRa2
6WAFnY4dGATUvuNqrqKPT1H3AflHhxGJhZl6OwpeUCa7pcV95z+9ISD0v2JuSxkQ
on1whTlLj5ezbspuuBP+dllCf7SlqLHnfKzMlAJmnGZMdWOqOLieOPyOZ3mfNq/W
hIW4z0Yu9rPJu2WMdx3KsTiUZpIKDYhOpfBtvZnnJtUuc7GF02gOl8zlqbXQpq49
VBZY0Loe+s91VPDcqu8tkl+vmkWOc1wSbunmxiqw++0asblnfMBFP6G7+XCV4HzS
WqcWH9MEdXTJA3OLvpmOfnO+aQ5PXmb3GxLEwnnxIU4X/Jkzx/A7vM8/0CK9uT/m
s2Erg37SjOY=
=tj+k
-----END PGP SIGNATURE-----

--Sig_/N6KUhbJhPuuQmNg_TZQy.Lc--
