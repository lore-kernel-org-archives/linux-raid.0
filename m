From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Tue, 25 Jun 2013 09:54:22 +1000
Message-ID: <20130625095422.29d3079b@notabene.brown>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
	<20130619100803.03fde6d5@notabene.brown>
	<20130620161639.GA3033@lazy.lzy>
	<20130624170458.568dafcb@notabene.brown>
	<20130624171016.GA2237@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/E4cTcMawPiXv3HT_IiFQT_t"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130624171016.GA2237@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/E4cTcMawPiXv3HT_IiFQT_t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Jun 2013 19:10:17 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> On Mon, Jun 24, 2013 at 05:04:58PM +1000, NeilBrown wrote:
> [...]
> > > Hi Neil,
> > >=20
> > > BTW, what's your plan of including "raid6check"
> > > into a main release of "mdadm" package?
> > >=20
> > > Do you have "deadline" in mind?
> >=20
> > What exactly do you mean by that?
> > raid6check.c is already in the upstream git tree and was in mdadm-3.2.5.
>=20
> Hi Neil, I was under the impression you were
> holding back the patches from Robert (Buchholz).
>=20
> Probably I was wrong.

I don't remember holding back on any raid6check patches, but then I tend to
forget such things - usually after I've replied with why, but sometimes
before.

If there are patches that you (or anyone else) think should be in but aren'=
t,
please point them out to me.  I'll either apply them or explain why I don't
want to.

> =20
> > Do you mean when will it be included by distros?  That is really up to =
them.
> > I could get "make install" to install it I guess.
> > I haven't really thought about what would be required for that.
> >=20
> > I'll add it to my list of things to think about.
>=20
> Well, that could be some thinking for 3.3, couldn't it? :-)

It could indeed.

Thanks,
NeilBrown


>=20
> In any case, yes, it would be nice to force a bit
> the hand of the distros by installing "raid6check" too.
>=20
> Thanks,
>=20
> bye,
>=20
> pg
>=20
> > NeilBrown
> >=20
> > >=20
> > > Thanks,
> > >=20
> > > bye,
> > >=20
> >=20
>=20
>=20
>=20


--Sig_/E4cTcMawPiXv3HT_IiFQT_t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcjcLjnsnt1WYoG5AQKZCRAAiyqzssc2hbE+9bvzumt9Zbd4gGaND3br
s6Ie5npnH82bc0Kw4K2dqc9OSwo59pWuvLBMweL6Xj/Rh3f2hdn6mKkTz0aZkuzA
4BRNVhuaBjSExqX34RLtEj7EU2X8Zq0XpJ/xw+NOYPvF5yf6dhSCI7/lLFhAgPJ4
YFiXB5cX+HMWPsViYiDcgK/eUX9ND/0c6bAuzr0Nu8Dsu5WdEgBuaUSZY0+UAURe
eO0rqOUfgGJ+RHKnOb85244rv165NcGW5/Al93TRMKC92zPMPFDzUolrXwHkinR/
mcGQD+m8L4j697F7ufOLpWv1qA2JKKfvQCx2KIRXPn0CcqZQGwHF4I8sLVYbBSMn
p8+TASPxyifl4jWpO0rP3xSBftGU7+GSeWmc17airu9fRr2x8Z/pULFl/7GUG/va
RRWmrnN7yta9iV7ziDf2YpjmXx0xcdgYxEvcHUc1wV42OWvCWnAlU41Uk30amTBB
wB4URedCVynVqfWm0sc4APOZSZ23L7A7Z2dsDWAArbTl2K6LmqeF/Xy/hE+ZziR9
zwMRMXkjXQQp4YwKCLNjm+ePxkfae2dGB/XAqu0B9SwmTov9sVAcW4SlxP5zED1j
EwTEQ1JTlYwymf2QuxlzXyL0sCLm37rrswZbearuzRFyJ0Ayc7g3HRBPPq2MeT6u
Gep3st0jn30=
=X3zs
-----END PGP SIGNATURE-----

--Sig_/E4cTcMawPiXv3HT_IiFQT_t--
