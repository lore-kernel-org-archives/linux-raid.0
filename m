From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: `pvmove stuck' in RH bugzilla
Date: Wed, 6 Jul 2011 14:38:14 +0300
Message-ID: <20110706113814.GA3215@swordfish.minsk.epam.com>
References: <20110706095310.GA3225@swordfish>
 <20110706112359.GF5448@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110706112359.GF5448@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, lvm-devel@redhat.com
List-Id: linux-raid.ids


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/06/11 12:23), Alasdair G Kergon wrote:
> On Wed, Jul 06, 2011 at 12:53:10PM +0300, Sergey Senozhatsky wrote:
> > I think we just trapped into the same trouble with pvmove as described =
in=20
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D602516
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D706036
> >=20
> > Alasdair, could you please point are those patches in vanilla kernel=20
> > (3.0-rc*) or linux-next, or some RH internal tree?=20
> > This is not critical, though I'd like to try out patches.
> =20
> This is a userspace bug not a kernel one.
> There is a workaround, which is to perform the pvmove one LV at a time
> using the --name option.  (For each LV, run pvmove -n <lvname>.)
>=20
> The patched code is in the upstream lvm2 repository:
>   git://sources.redhat.com/git/lvm2
>   http://sourceware.org/cgi-bin/cvsweb.cgi/LVM2/doc/?cvsroot=3Dlvm2
>   http://sourceware.org/lvm2/
>=20
> It was only last night that the code incorporating these changes passed
> our public testsuite for the first time, so I think it is still
> premature to be using this on production systems.  But this means I hope
> to be in a position to make the first development release containing a
> fix for the problems quite soon.  (I added assertions to catch other
> instances of the related problems - it was more than just pvmove
> affected.)
>=20

Thanks a lot for your reply.
We don't have a production machines here (just internal servers),
so I guess I could give it a try.


Best,
	Sergey

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk4USSYACgkQfKHnntdSXjTGbwP/RADyjDMsM2qcT172Dw1IXbZ5
jdfeNqIV4QIAgL4CjQhrCVU1UL9YBPsGZSvhDElr2hUXaQcIksq0bJJn1HaUeXt0
rCKp4G8I1Z+GIrqTAdtY2uOEmzwm5v/THhLfp0dsQGM9wnIHoCt5QywLUjY1+MR7
xBDBp1aNWwl13JNrOcA=
=XMEZ
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
