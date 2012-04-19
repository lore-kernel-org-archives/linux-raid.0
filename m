From: NeilBrown <neilb@suse.de>
Subject: Re: non fs-data and gpt partitioned md
Date: Thu, 19 Apr 2012 11:36:41 +1000
Message-ID: <20120419113641.4e1ca5b1@notabene.brown>
References: <1334695210.6026.31.camel@hermes>
	<20120418181833.0581d8ba.kgunders@teamcool.net>
	<20120419103823.30ca2834@notabene.brown>
	<20120418190221.561b0df6.kgunders@teamcool.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=hIaws3C9H6jGGOzcdvdpMP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418190221.561b0df6.kgunders@teamcool.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ken Gunderson <kgunders@teamcool.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=hIaws3C9H6jGGOzcdvdpMP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 19:02:21 -0600 Ken Gunderson <kgunders@teamcool.net>
wrote:


> > Any reason for preferring one of 1.0 and 1.2 is out side of md.
> >=20
> > Maybe you want to be able to mount one half of a RAID1
> > independently.  You need 1.0 for that.  Maybe you want to ensure that
> > never happens.  Then 1.2 is better. Maybe your boot loaded only works
> > with one.  Then the choice is clear.
>=20
> Well, this only pertains to /boot partition, so there's nothing to stop
> one from mixing and matching, e.g. Syslinux using 1.0 metadata for
> RAID1 /boot and 1.2 metadata for RAID10 swap and root devices, no? Or
> is this not advisable?

That is all fine.

NeilBrown

--Sig_/=hIaws3C9H6jGGOzcdvdpMP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT49sKTnsnt1WYoG5AQK2+w/+K6VmrTsbeSsYybXW7wFjliCYszW5AZYW
6z8Cv4e1VDu/fDQuzPciiAoEy6639hRVYGabSpcbAIPpLz8xVNtY+uUBzOm0PeQp
3qymvixlNAnZC1Rm8y9IYTrZoa1lsZrfqxW6kxKw1AuHVT0eGjG2rZkaK8yIKXhT
Ri/Ql4+ylEgz77GQllYp55VYuOsHj/MkLo3oxror3kcCN0BWploQ7r+y9MsvpoA6
f9qTRIaTluWE0dChUKwNA2zH/D31X6sCZ8GyFSrlXnw3q3b7WF6/R3ZFUpRjXT3x
HmWojxHRDYpO1j2dFONvwIlooTyWn0nDMKbXVVGxGZSdYnj5W/RoKic95IUJQJOm
li6gc7mf/gIzqmWichbnzf87ONCUtdKywjIG68OISSK/V1EIuXQ6syPSjDGrXlKW
NABA8ByWnkji+FhMtzfRzHUIPkHiz2mTiqDR5CslVmIxxkQwjR9CPcQ10gffZ7B1
1CEkVazZ2+cADSvn9wrm+L4nT6PCtK53k+jeFH+VUaPOKSUWo1YS6dY927VpionE
fRbOfWVZeQ7v5det/1rf6KDS4YCDj99gvp+hPsRllys5AGhH3KgQpigDhDqpiTPV
zMoDZKDDTGyeiqO6ebxj3mso2mygzZvwhPIvgB2a9t74qcaKxdutt13ot0Ts576e
BzoRAq8Fba4=
=dlxt
-----END PGP SIGNATURE-----

--Sig_/=hIaws3C9H6jGGOzcdvdpMP--
