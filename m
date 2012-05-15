From: NeilBrown <neilb@suse.de>
Subject: mdadm-3.2.5 coming soon :-(
Date: Tue, 15 May 2012 21:50:20 +1000
Message-ID: <20120515215020.76fd9c6f@notabene.brown>
References: <20120503142201.649766de@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l49K5y9BGmc6Qj77kmzg0Wy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120503142201.649766de@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Doug Ledford <dledford@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Dan Williams <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>, Clint Byrum <clint@ubuntu.com>
List-Id: linux-raid.ids

--Sig_/l49K5y9BGmc6Qj77kmzg0Wy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


It turns out that there is a nasty regression in 3.2.4.
--add is even more broken than it was before.  My testing
doesn't test new mdadm against arrays created with old mdadm, and
so missed it.  I should probably find a way to improve on that.

So 3.2.4 isn't really a good idea so I'll be releasing 3.2.5 on Friday.
I currently have 5 patches since 3.2.4.  So it'll be a small but
(hopefully) safe update.

If anyone knows of any other issues that have cropped up wit 3.2.4, please
let me know.

Thanks,
NeilBrown

--Sig_/l49K5y9BGmc6Qj77kmzg0Wy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7JC/Dnsnt1WYoG5AQI+OA/8DQmeb2KG5Xhqndv932qxqqKqQg0LI0H7
6tuXr3degoq4LPeitUdf653roZfnlth89lNIJ6h1PhSPFKTt5842SMnNUPTbNNbn
EkotxfEN9ng4byS25Wl3EiAFGs7jYaVFNKjyF6hEokIYi66rXJOq+5z+LcPNUVgx
2mAToAEZME3Qcb72TzRz4Bx2ZBQwZyvJyJiVAnuubHjVOtKchYd+aaxpq++P4cWL
jXPny9NR0RczKwD4Ftc1wUZatRZwmJU9CdK89KJbBTDbNYfU9cjLIbCGbri/YWgm
VQNY63ZVd+4a9c+dCvgdKNjsqWIiEWcSJDvT0qt+mFWI/zakvzs3sXewcZjwOZxv
Ies0Cn2ews46dTwmh94xb/rE7VVCCFtFVaEN6ESi08EjPSZ1OwdZ56A9a02MXl4D
Pzvp+PhPA4KQVV1tcyxZ7czy8jSFkvClBIuG4rmiOWgkKd8lTYP5PJCg229cGvXB
oXbDsT1ukJagOz44CtfArlMzKLVVj3CVXnEuihAYxjfA8ih8Z/irCiXLOaIRyjJd
fNOLRuC3zr4Rvys/p95nWtDg7e1usFQ0Vyja6I+BqS1opjbXxxVDB2sfQ09+UgoN
KSlxAilXf2Hr3rfu5bn2rnc88FHsOXWT/ZtEzyNw/mTRVGCHbInBRsFi6Ab0N3Ub
IdrftGSBCrg=
=8/4J
-----END PGP SIGNATURE-----

--Sig_/l49K5y9BGmc6Qj77kmzg0Wy--
