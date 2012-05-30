From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Tests for add/remove of internal bitmaps
Date: Wed, 30 May 2012 10:47:42 +1000
Message-ID: <20120530104742.750db09b@notabene.brown>
References: <1338304199-6047-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d/TyG=TRJYFVFn+ywU6e.Nn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338304199-6047-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/d/TyG=TRJYFVFn+ywU6e.Nn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 May 2012 17:09:57 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> Sometime ago Neil fixed a bug where the kernel would OOPS when adding
> a bitmap to an existing array and using it immediately. We hit this
> more recently in RHEL so I figured I better write a proper testcase
> for it.
>=20
> The second patch is checking that removing bitmaps also works, though
> I didn't have a specific case triggered by that. I just added them for
> completeness.
>=20
> I added the patches to the 05 prefix as that is where the other bitmap
> related test cases were. Feel free to reassign them if you like.
>=20
> Cheers,
> Jes

Thanks!  Applied (With a couple of trailing spaces removed :-)

(and the --no-error fix applied too)

NeilBrown

> =20
>=20
> Jes Sorensen (2):
>   New tests testing the addition of bitmaps
>   New tests testing removal of internal bitmaps
>=20
>  tests/05r1-add-internalbitmap        |   20 ++++++++++++++++++++
>  tests/05r1-add-internalbitmap-v1a    |   20 ++++++++++++++++++++
>  tests/05r1-add-internalbitmap-v1b    |   20 ++++++++++++++++++++
>  tests/05r1-add-internalbitmap-v1c    |   20 ++++++++++++++++++++
>  tests/05r1-remove-internalbitmap     |   18 ++++++++++++++++++
>  tests/05r1-remove-internalbitmap-v1a |   18 ++++++++++++++++++
>  tests/05r1-remove-internalbitmap-v1b |   18 ++++++++++++++++++
>  tests/05r1-remove-internalbitmap-v1c |   18 ++++++++++++++++++
>  8 files changed, 152 insertions(+)
>  create mode 100644 tests/05r1-add-internalbitmap
>  create mode 100644 tests/05r1-add-internalbitmap-v1a
>  create mode 100644 tests/05r1-add-internalbitmap-v1b
>  create mode 100644 tests/05r1-add-internalbitmap-v1c
>  create mode 100644 tests/05r1-remove-internalbitmap
>  create mode 100644 tests/05r1-remove-internalbitmap-v1a
>  create mode 100644 tests/05r1-remove-internalbitmap-v1b
>  create mode 100644 tests/05r1-remove-internalbitmap-v1c
>=20


--Sig_/d/TyG=TRJYFVFn+ywU6e.Nn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8VuLjnsnt1WYoG5AQKCvA//Yg+dVGm8Al8B7GPFEiQKlFls2qu6qVO2
PG0ZBL8+IIgtXv9rtG2j4D8u/bT9GiIj8k4eWMmHlKMTFnug5dYwxoRwCA3Wk29X
wC8P8eJI9W3ReOzyuoveDr+J1fmEJA0WFdL6Je2mT+o3ChIE5S3wL2Gsul4/kwDd
GSTMqkcStUZEp0XH3cTMq9NG/uqNAzhBcher2ONr5qRK7oROXDVqRhElOGhmGBYs
mKHOro0XiHHj3xafrKiA5U8OWkf4ClR3ZZPVxc5kT8gcZpiKXiiGGR1VcYCkrWDZ
ciwO7nurTu6v3bPMgrWq9vkIR+DSNlqG2v8EleyokQWGfXc4NQGhqgbyAJLsgfDQ
0zRAqyFHwhr66Y3XDTFXDPO7fXVnwFdy3Vbzvf9T9twJ9p/wywUF3+A8xtJTUgpH
52eeRPxOzdgM4tvLoOx8OPv/lz8LWn2zXpxekQBKneVHMQUQGcDD3ExdixmgBIru
Z/F+TamApkTftMGrgDacFJGSsLEJNfB0LHaOith0zvNObY+UPWw/qEf56XI3gKru
UPyUPJFrG/+G1UbVwVINFq0GUZZ7YjvrnrDWFkWNmpgfaRLbvdb+9Id+kxLgPmek
v3bx/l/FDXCnDspczkmlVkV3TQrps0ZdcKRKkdlPlGixXAJwjL0z086FUZpyupai
CYjPQHDYvS8=
=c1kt
-----END PGP SIGNATURE-----

--Sig_/d/TyG=TRJYFVFn+ywU6e.Nn--
