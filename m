From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/6] Makefile: Allow the user to pass EXTRA_CFLAGS
Date: Mon, 24 Jun 2013 17:01:18 +1000
Message-ID: <20130624170118.2b2b1cad@notabene.brown>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
	<20130618090921.1161109.54531.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
	<20130619100730.0a0e5240@notabene.brown>
	<51C17E7F.3050504@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/54p+3yztUbE+CZlBn+3kpXW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51C17E7F.3050504@itwm.fraunhofer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: piergiorgio.sartor@nexgo.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/54p+3yztUbE+CZlBn+3kpXW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Jun 2013 11:48:47 +0200 Bernd Schubert
<bernd.schubert@itwm.fraunhofer.de> wrote:

> Hello Neil,
>=20
> On 06/19/2013 02:07 AM, NeilBrown wrote:
> > On Tue, 18 Jun 2013 11:09:21 +0200 Bernd Schubert
> > <bernd.schubert@itwm.fraunhofer.de> wrote:
> >
> >> Users might want to compile with optimization levels and
> >> CXFLAGS as suggested in the Makefile comment does not work.
> >
> > Doesn't it?  It works for me.
> >
> >     make CXFLAGS=3D-O3
> >
> > compiled with "-O3".
> >
> >
> > I haven't applied this patch (feel free to try to be more convincing) b=
ut has
> > applied all the others (after removing a little bit of trailing white s=
pace).
> >
>=20
>=20
> I'm sorry for the extra work with the white space. Next time I'm first=20
> going to run linux/scripts/checkpatch.pl
>=20
> Hmm, indeed
>=20
> make CXFLAGS=3D-O3
>=20
> works, but the other way around it does not:
>=20
> CXFLAGS=3D-O3 make
>=20
> I still wonder how it works, as Makefile sets "CXFLAGS =3D -ggdb".
> Anyway, whichever exception 'make' has for that, can we change it to
>=20
> -CXFLAGS =3D -ggdb
> +CXFLAGS ?=3D -ggdb
>=20
> which would make it work with either way CXFLAGS is specified.
>=20
>=20
> Thanks,
> Bernd


Sounds fair.  I've made that change.

NeilBrown

--Sig_/54p+3yztUbE+CZlBn+3kpXW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcfuvjnsnt1WYoG5AQIZkhAAiwO+8d7Svuqr64TpF/6ZfT+cz3xCmvKx
EMlXbOBDO/rnw9/pGSRfJYAroEwi3/axo14kIBXC904rV5LMmrfYf04KJj1eYeff
AGzqKv9fuvO4EiVvl9cDr6yC+prrIfc8K0RkRSI5OH+JAVBZHocqL8zONTwJugxs
RCJW+V8a7+ZL3Z7yrIMIS/0Fs0qz73cEiczwJlHYjP2smw2mqUlbPvdfRkxqa0gQ
gr8IBKAWQV0tv+DIJlA7lQw39mgtM3V76lm6g2sgjbWcUicCwC0R/GV6SOr+D9Zv
EFGjiUxNgdXhKw2Zg5tqd9qyJPmmi6jnANgEUMK1RPWXQtOSoValnKcntM2EGlEM
gueetziEmeAyyNPlLNFL/TT+zXOy5KUy66EUFCQ2iL24qVMqSv+rmGCPwXcvP5Wt
z++YfQlWRNVJTy/HVYybK3n2osvu7Od+7xC1w6IHm8vKoYmPRtyyxWireGcczYdv
HLhyqkMrkqUQVwoP70pz7N/OkpH/bauDCOYvGBsSTsMgOTT0yKZemSGudu//QtO6
Q4rQQLc05F5vzhBT+L9ItK+uNMPeu6UdxBL9XN3gOQ5i/ndb8FiDX24ZWsi5SFui
F7M5UjPmX2FHz1gI01/pTScKk/TVCndPlTVofp+APeVoz0FlxOpRUbcGwW6eGQWt
ncQotsp3rBk=
=4J11
-----END PGP SIGNATURE-----

--Sig_/54p+3yztUbE+CZlBn+3kpXW--
