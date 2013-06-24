From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Mon, 24 Jun 2013 17:04:58 +1000
Message-ID: <20130624170458.568dafcb@notabene.brown>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
	<20130619100803.03fde6d5@notabene.brown>
	<20130620161639.GA3033@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s/WLhPzcnCq=3kj6_XIPIDX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130620161639.GA3033@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/s/WLhPzcnCq=3kj6_XIPIDX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Jun 2013 18:16:39 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> On Wed, Jun 19, 2013 at 10:08:03AM +1000, NeilBrown wrote:
> > On Tue, 18 Jun 2013 11:09:10 +0200 Bernd Schubert
> > <bernd.schubert@itwm.fraunhofer.de> wrote:
> >=20
> > > Here are a few raid6check fixes. This series also includes a patch for
> > > Makefile to allow to build with optimizations. I only fixed raid6check
> > > to build with -O3, but I don't have time left today to fix mdadm=20
> > > (e.g. Grow.c:2237:41: error: =E2=80=98info2.data_offset=E2=80=99 may =
be used uninitialized in this function [-Werror=3Duninitialized])
> > >=20
> >=20
> > Thanks for mentioning that.  I've fix that problem.
> >=20
> > NeilBrown
> >=20
> >=20
> > > I wanted to send the memleak-fixes much earlier, but then
> > > I had been too busy. This patch is lightly tested, patches
> > > from today are only build-tested.
> >=20
>=20
> Hi Neil,
>=20
> BTW, what's your plan of including "raid6check"
> into a main release of "mdadm" package?
>=20
> Do you have "deadline" in mind?

What exactly do you mean by that?
raid6check.c is already in the upstream git tree and was in mdadm-3.2.5.

Do you mean when will it be included by distros?  That is really up to them.
I could get "make install" to install it I guess.
I haven't really thought about what would be required for that.

I'll add it to my list of things to think about.

NeilBrown

>=20
> Thanks,
>=20
> bye,
>=20


--Sig_/s/WLhPzcnCq=3kj6_XIPIDX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcfvmjnsnt1WYoG5AQKjbRAAhLPhdDoa2a8XM0f6b0A+5+7iJuTDGISc
JnMRbz12s7FFBCk8vVaTJOsAmBJD5i1wyAcvMFzdyMSwn2QfuuCs8XXKbV7M7PDw
3H0uy0W4XSykW/XQ8USszqomADp0HlJlrLYjKJ3PkaeFEuuy4EKNob7l8BhhGNgv
Dl3leHWf0VqPzZ/pSFfSyB5RwNeWDIDJS0Ln5gurfv/V/cP6h6DyasAHYph75Z+V
3y0vhHDABCRWAubed1CX0scP3rZYp6BETLm4tOGy1iDHRVDRfUNnIiJdyIBZcds0
U1uryweMiCg6mJtdT9QqH63ndDgJ0xDSd/a0POmc9oNFSHdLpOstdxmzlRdY5032
5LpxRUtHL5acm17ajuBkq62L+vw7ETL5R2oqZVPhcdCUy/3+nlo6HpAx0e+YL9cy
WJ47UWbuDyN0ehlD5Ayhh76K5Jo8qXqYCbIDF/EZbQI7NCdnf/PDWkrM+H1rgcGA
+/p4Zg5swG69ckFKJ1q0GO90N29o94tlTy32qXkRb5PysvqZ7ps57QxOwr5viBOP
7BWX0fRYeR/oD/d2jbAU/tdmSJyE17kP44lzaO/2632tYHU76qMfsBRNKESxXbxP
v88qNzp0jsGx4UoNG09a5DQyX8vTNdVoiIl183QxO5SLx8JhciUOfcTxlgZLHwOU
aiVu/euVJm0=
=h54t
-----END PGP SIGNATURE-----

--Sig_/s/WLhPzcnCq=3kj6_XIPIDX--
