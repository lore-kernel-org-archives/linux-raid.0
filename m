From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1 of 2] MD RAID10:  Improve redundancy for 'far' and
 'offset' algorithms
Date: Thu, 13 Dec 2012 12:23:59 +1100
Message-ID: <20121213122359.724138e2@notabene.brown>
References: <1355330705.26828.14.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0l/tl4vYdm=Zc_qFNTpaTt3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1355330705.26828.14.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids

--Sig_/0l/tl4vYdm=Zc_qFNTpaTt3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Dec 2012 10:45:05 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms
>=20
> The MD RAID10 'far' and 'offset' algorithms make copies of entire stripe
> widths - copying them to a different location on the same devices after
> shifting the stripe.  An example layout of each follows below:
>=20
> 	        "far" algorithm
> 	dev1 dev2 dev3 dev4 dev5 dev6
> 	=3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=
=3D=3D
> 	 A    B    C    D    E    F
> 	 G    H    I    J    K    L
> 	            ...
> 	 F    A    B    C    D    E  --> Copy of stripe0, but shifted by 1
> 	 L    G    H    I    J    K
> 	            ...
>=20
> 		"offset" algorithm
> 	dev1 dev2 dev3 dev4 dev5 dev6
> 	=3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=
=3D=3D
> 	 A    B    C    D    E    F
> 	 F    A    B    C    D    E  --> Copy of stripe0, but shifted by 1
> 	 G    H    I    J    K    L
> 	 L    G    H    I    J    K
> 	            ...
>=20
> Redundancy for these algorithms is gained by shifting the copied stripes
> a certain number of devices - in this case, 1.  This patch proposes the
> number of devices the copy be shifted by be changed from:
> 	device# + near_copies
> to
> 	device# + raid_disks/far_copies
>=20
> The above "far" algorithm example would now look like:
> 	        "far" algorithm
> 	dev1 dev2 dev3 dev4 dev5 dev6
> 	=3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=
=3D=3D
> 	 A    B    C    D    E    F
> 	 G    H    I    J    K    L
> 	            ...
> 	 D    E    F    A    B    C  --> Copy of stripe0, but shifted by 3
> 	 J    K    L    G    H    I
> 	            ...
>=20
> This has the affect of improving the redundancy of the array.  We can
> always sustain at least one failure, but sometimes more than one can
> be handled.  In the first examples, the pairs of devices that CANNOT fail
> together are:
> 	(1,2) (2,3) (3,4) (4,5) (5,6) (1, 6) [40% of possible pairs]
> In the example where the copies are instead shifted by 3, the pairs of
> devices that cannot fail together are:
> 	(1,4) (2,5) (3,6)                    [20% of possible pairs]
>=20
> Performing shifting in this way produces more redundancy and works especi=
ally
> well when the number of devices is a multiple of the number of copies.

Unfortunately it doesn't bring any benefit (I think) when the number of
devices is not a multiple of the number of copies.  And if we are going to
make a change, we should do the best we can.

An approach that has previously been suggested is to divide the devices up
into set which are ncopies in size or (for the last set) a little more and
and rotate within those sets.
So with 5 devices and two copies there are 2 sets, one of 2, one of 3.

  A  B  C  D  E
  B  A  D  E  C

The  only pairs where we cannot survive failure of both are pairs that are =
in
the same set.  This is as good as your scheme when raid_disks divides copie=
s,
but better when it doesn't.

So unless there is a good reason not to, I would rather we go with the sche=
me
that gives the best in all cases.


NeilBrown

--Sig_/0l/tl4vYdm=Zc_qFNTpaTt3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMkuLznsnt1WYoG5AQIfNA/+Nmf9psFdXxIgu8/xsLiv0VXp9zzh1ifp
C1okbufmH7KbHQZrKlyzM61A1ee+COj8FEsKbItCY6R6BnzRJhP4cne0hh2LC8PY
WxjCaZ5Lze2Yaemy7U7CS6iBUyfuKFVNzZO3edH6wySQJubMEqEqdLPmZ92l3NqX
CaBsUjSiihk5D2NcLCWku6zIhKLR0v7wEJl83U61U35tSC2bNkDYn5CbavMZcMOd
n6WquPgohIMP+H4ZLUe7JmtDOINhtbJIveiO/C2itxRSUHin3HjUwmBHYmU4XYk9
XRt7raE4pkJvgMB+iFPsXyrpLwGv1q9pctVwe6V8aTPvX3mGIphS+K0Ywt7Gukms
Y73RVK/StutnXyKutj1TjgHnePyjwflD7T6JX+pYw8UP6M+vkycDsqH422GDLunB
6lp1thGoBT2ZdJaQ61rWhxijfhPdixWcYSnDX5nRcjybMSS/yiImwByIXaDx9HCD
wnyuSvElEJ6Kpa+2ppYObuFc2Hawt1RdYSNDjthXsa7ttmEWtn1uJ0hWCAadf4FB
yQJ5dQuXTE4K4CUaDIvq3LdmsO/CPSH6fOKVTgh1cJI6sIT4TZBdmg/2oF197VlC
qE1XYFzUoTrLAoeALtmCFouQICBuoGsa/y6Erpk6wjcni94W/FazXw4j99SQowwr
SPLLVpVCgm0=
=jLMO
-----END PGP SIGNATURE-----

--Sig_/0l/tl4vYdm=Zc_qFNTpaTt3--
