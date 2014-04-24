From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 1/3] md/isrt: base infrastructure and metadata
 loading
Date: Thu, 24 Apr 2014 17:24:50 +1000
Message-ID: <20140424172450.7ec9452b@notabene.brown>
References: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
	<20140424061849.3187.48229.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ShrjP+BSmVzgrBbEFGDQhgs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424061849.3187.48229.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

--Sig_/ShrjP+BSmVzgrBbEFGDQhgs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Apr 2014 23:18:49 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> Initial md / block boilerplate for the Intel (R) Smart Response
> Technology compatibility driver.  Supports reading the packed  metadata
> and parsing it into a cache lookup tree.
>=20
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

It would really help in reviewing this to have a glossary.

There are frames and segments and sectors and pages.

I hope sectors are 512 bytes and pages are PAGE_SIZE, which may or may not =
be
4096.

And there are 16 sectors per frame, so I guess space is allocated in the
cache in 8K aligned frames ??

There are 64 segments per page so if pages did happen to be 4096 bytes, that
makes 64 bytes per segment.  What are they?

There is a list somewhere of 32byte frame descriptors which is read into a
single vmalloced region (why? you keep page pointers, so why not read it in=
to
separate pages?)
How is this organised?  I might be able to work that out from the code, but
I'd rather not.

Please don't make me guess, I'm not good at it.

I guess it didn't help that diff out the header after the code.  I got bored
before I got there and didn't read all to words, so maybe some answers are =
in
there.  They don't really stand out though.


You've chosen '8' for the 'level' number.
As this is an array which doesn't have redundancy, I'd rather a number <=3D=
 0.
I think there are places where I assume >=3D1 has redundancy and understands
spares etc.

Should conf->count be a kref??? Just a thought, not a requirement.


NeilBrown


--Sig_/ShrjP+BSmVzgrBbEFGDQhgs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1i8Qznsnt1WYoG5AQIhuBAAgPjGQIy9bd9Pb4gOdAR84OqrDxx1uBLE
HYdZCLmCWRGQIpzrvFCprcYZVLcnCUM3U8y5jGIrj2dNk3H2sZZYgzaJ8TQrC/ki
iILHoZQHuBxYzLEH11YBA0vkgJ+KjF8IX2hAhBl9f+quhtSFeYayw2tRIVtS1vdY
F4aqJm/PNu6HWPmvHun+dwEw41TcqB5AewHo/9sQFvv2zOn8nKYM+AbEtCIy8Phn
k074tDYOZHP1Q58i7D+LCBSnb+uus02YQZ6NAXNxfN29P9NBDWUAFm48ryGlmX4M
QmbHygz0nouyjo9/lbqXDIO5vP5MOBjdjC0kcK43R2+oU92YLUosPCf+6jf43Ipy
HqTpkhiskql/WPjRTj4PlUNuOX1ex/QwEb4mt5xTSlXjXR5au3w7Nzcz8VThm038
tQZZKsw7NKn+tEO425GtPV9s3bGTrvld+/eS2qrc1p2rsg6NnvqhM5rwJuotJ9o7
VY0no3zeJEituE23rVKA+yeG+MlTquSCdDkdT/vOnPeiatpscVBC9glfSPvvKR7c
zK2tl5G37y27Ub8glqcQUUVw6EmedGKjZsnaGMXmwwbNjdKfE/piH2GYF2OvpQSH
zNB5mMF2RrOoGkc1XgbHROnsgnhRMzaUyxMvDe2mjOIhPPmRnnJiVm/BGkteRVYa
UMDOlouHPjA=
=8rJF
-----END PGP SIGNATURE-----

--Sig_/ShrjP+BSmVzgrBbEFGDQhgs--
