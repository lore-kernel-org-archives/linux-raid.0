From: Sebastian Henschel <shensche@xtops.de>
Subject: Re: compile errors in 2.6.8.1 in drivers/md/*
Date: Fri, 27 Aug 2004 14:59:34 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040827125934.GA5331@fuchi>
References: <20040827093634.GA4853@fuchi> <200408270639.47900.kevcorry@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200408270639.47900.kevcorry@us.ibm.com>
To: Kevin Corry <kevcorry@us.ibm.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-raid.ids


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hello kevin...

* Kevin Corry <kevcorry@us.ibm.com> [2004-08-27 14:51 +0200]:
> On Friday 27 August 2004 04:36, Sebastian Henschel wrote:
> >
> > hopefully i am right here... i just compiled a kernel 2.6.8.1 and two
> > similar errors occurred:
> >
> > drivers/md/dm-raid.c:1241 - the workqueue creation misses an argument. i
> > have set the flag to 0.
> > drivers/md/kcopyd.c:612 - the singlethread workqueue creation misses an
> > argument. i have set the flag to 0.
> >
> > the kernel compiles now, but i do not if it really is a fix. since the
> > machine this kernel was compiled on, does not make use of a software
> > raid, i cannot test it.
>=20
> Are you building a stock 2.6.8.1 kernel? Could it be -mm or one of the ot=
her=20
> common extra patchsets? I don't see any compile warnings or errors anywhe=
re=20
> in the drivers/md/ directory when I build my kernel, which is mostly a st=
ock=20
> 2.6.8.1 with a few extra DM patches.=20

oops... you hit me here. when i read your post, a memory was crawling back
into my mind. i already had this workqueue issue some months ago at
another place. it happens due to SWSUSP2 modifying
include/linux/workqueue.h so that the creation functions get one more
argument. so SWSUSP2 should patch the two aforementioned files and not
the linux-raid team.

sorry for the fuzz,
 sebastian
--=20
::: .O.
::: ..O
::: OOO
::: lynx -source http://www.kodeaffe.de/shensche.pub | gpg --import

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBLzA2reHfL3pi+bQRAsZJAJ9fISei8Nf9u3+WO34aZF+nv8yrYwCdHUFA
QrHppNrtQEJM23AExyrXndk=
=PKjn
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
