From: NeilBrown <neilb@suse.de>
Subject: Re: change '%' to condition
Date: Thu, 12 Sep 2013 15:39:19 +1000
Message-ID: <20130912153919.26831641@notabene.brown>
References: <1373890837-3475-1-git-send-email-Jes.Sorensen@redhat.com>
	<1373890837-3475-67-git-send-email-Jes.Sorensen@redhat.com>
	<alpine.LRH.2.02.1307151445220.23929@file01.intranet.prod.int.rdu2.redhat.com>
	<wrfjfvvely2a.fsf@redhat.com>
	<alpine.LRH.2.02.1307201112210.2761@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oKuSZpvS_llRwl_64qQQA9n"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1307201112210.2761@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, rhkernel-list@redhat.com
List-Id: linux-raid.ids

--Sig_/oKuSZpvS_llRwl_64qQQA9n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 19:18:57 -0400 (EDT) Mikulas Patocka
<mpatocka@redhat.com> wrote:

> Hi
>=20
> I think you should revert the patch=20
> 4c0ca26bd260dddf3b9781758cb5e2df3f74d4a3 that did this change:
>=20
>                 for (f =3D 1; f < geo->far_copies; f++) {
>                         d +=3D geo->near_copies;
> -                       if (d >=3D geo->raid_disks)
> -                               d -=3D geo->raid_disks;
> +                       d %=3D geo->raid_disks;
>                         s +=3D geo->stride;
>                         r10bio->devs[slot].devnum =3D d;
>                         r10bio->devs[slot].addr =3D s;
>=20
>=20
> On most processors, the divide and modulo operations are slower than a=20
> possibly misprediteced branch or conditional move instruction.
>=20
> So, replacing a condition with modulo doesn't make sense.
>=20
> A benchmark on AMD K10 shows that mispredicted branch is 8.7 times faster=
=20
> than a divide operation:
>=20
>         for (i =3D 0; i < 10000000; i++) {
>                 q++;
>                 if (q >=3D 8)
>                         q -=3D 8;
>         }
> - 11607us (it compiles to cmov and runs at a rate of 3 ticks per=20
> iteration)
>=20
>         for (i =3D 0; i < 10000000; i++) {
>                 q++;
>                 q %=3D max;
>         }
> - 101241us (26 ticks per iteration)
>=20
>=20
> Mikulas

I can't seem to get excited about this sort of micro optimisation.

If someone were to send me a nice patch with a good description and a couple
of acked-by:s from relevant people I would probably apply it.  But otherwise
I just wouldn't care.

Thanks,
NeilBrown

--Sig_/oKuSZpvS_llRwl_64qQQA9n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFThznsnt1WYoG5AQLtOQ/9Frpwh6AV6n9g2AKnFndgg1kuCKzktG3G
qmsJko9UNhubtnxyZRVTIGa3oSUViFpcqGPzOAH30cVggYlVOuM+WG1l/6T8pm5f
OrdwYZwT7v7tLt4gLl/R6eSFpO9c3hBM7t/hnDOa0sMXxFAzCWR4gnz+Yagm97jp
JQcXtpFyV39nNFnS8uT0y6Ixqb5oJWUPC/sQUIJLru3vaTHSezuKcTzrmHFpig8I
XIJBy9+8va5OE46wmK/cMzaoiQad9Gx1fx7+nPBEw3NqHAziFWKFtxDXdN/VdQFZ
lsUu7nv9niSyvAXsK96kkL9tX6jcvi3EQ9REbH8FMNhwZTX19kfEEnRptKXegx/Y
OFChj7BWI50pzbO0jzH3gucKlUyigxNC4PxV+fM6faL1xTQusK7TJscz4BzpugSr
RGMmQIYIuIlSkfXLVWS5PLfbokP928cCZ6/kuNuMETpwT724Yw/ufSmsq2dnfnmP
STO7zmDcTbHapKLSdmZLDrRqhbz9RGw2oUnHRPyxV0WgpfLvL782ZZH4Kvi85FLy
uSC/QYhvuWGScg0nZI5MqQ7LsLQbDxc3+uhsiiJWVyaWL7L/kRtmfOJTvIHMoEYm
j8y0uPducJMF1yhUx1b1kLLJpzBCIw3PbUiqLfVVd32vbSc8mI4Xfodk5sorBEP6
S38rCxPo/w4=
=N2H6
-----END PGP SIGNATURE-----

--Sig_/oKuSZpvS_llRwl_64qQQA9n--
