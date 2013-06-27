From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Thu, 27 Jun 2013 14:27:19 +1000
Message-ID: <20130627142719.5ffbf0ce@notabene.brown>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
	<20130619100803.03fde6d5@notabene.brown>
	<20130620161639.GA3033@lazy.lzy>
	<20130624170458.568dafcb@notabene.brown>
	<20130624171016.GA2237@lazy.lzy>
	<20130625095422.29d3079b@notabene.brown>
	<20130625164628.GA2261@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nt7gQNsN/A7kJPD6_lLfjcg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130625164628.GA2261@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org, Robert Buchholz <rbu@goodpoint.de>
List-Id: linux-raid.ids

--Sig_/nt7gQNsN/A7kJPD6_lLfjcg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Jun 2013 18:46:28 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> On Tue, Jun 25, 2013 at 09:54:22AM +1000, NeilBrown wrote:
> [...]
> > I don't remember holding back on any raid6check patches, but then I ten=
d to
> > forget such things - usually after I've replied with why, but sometimes
> > before.
> >=20
> > If there are patches that you (or anyone else) think should be in but a=
ren't,
> > please point them out to me.  I'll either apply them or explain why I d=
on't
> > want to.
>=20
> Hi Neil,
>=20
> no, you did not seem to have forgot anything.
> I quickly checked mdadm-3.3-rc1 source and it
> seems raid6check.c is up to date.
>=20
> > > > Do you mean when will it be included by distros?  That is really up=
 to them.
> > > > I could get "make install" to install it I guess.
> > > > I haven't really thought about what would be required for that.
> > > >=20
> > > > I'll add it to my list of things to think about.
> > >=20
> > > Well, that could be some thinking for 3.3, couldn't it? :-)
> >=20
> > It could indeed.
>=20
> Well, do not forget... :-)
>=20

I've just had a little look at raid6test - because some of the selftests we=
re
failing.

The default output is rather verbose.  Verbose output can be good, but not =
as
the default I think.

However, more importantly, it pays too much heed to the chunksize.

If the start of one chunk on drive X is bad, and the end of a corresponding
chunk on drive Y is bad, then it will complain that it cannot figure out the
problem.
It shouldn't do that.  It shouldn't even look at whole chunks at a time.

It should look at blocks.  Maybe 512bytes or 1K or 4K any of those would do.
Then for each block it should figure out if there is a problem, and maybe
auto-fix it.

Having two blocks on different drives being bad might be cause for extra
warnings, but it doesn't make any difference if they are in the same stripe
or in different stripes.

i.e. the chunksize should be used only as part of the calculation to work o=
ut
the layout at any particular place in the array.  It should not be used as a
unit for reading and writing data.

In anyone feels like addressing that issue, I would be very receptive to
patches :-)

NeilBrown

--Sig_/nt7gQNsN/A7kJPD6_lLfjcg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcu/Jznsnt1WYoG5AQK/oBAAlHE+t0D4xeceEBkmhQjydCp2J6y0UJKU
XbUUSIFeMuQOZ/ZpvMK73FY707PE4fjNTfgnkkJ3aTKIBarn6riQDEAj2IYPR6sD
Usr74QBXeh9gxvDJ1WvBRtwiX+pnk776IAX+ergQAIjlhvCYrgXLT+gXRSbWrABN
s/a+YybY8ATjnBuz4UCqtW/13luxseAzo0K7LmNBbqMDp96k3yhx5wl5IV+DNUrY
FEA6I5nmwFJ0wnHPTIdP8Cj9jKYp5/mP2cpKIirVQjPM5KmyrmfjN4nR+ainNMMg
1iouKqDPYBUay5WolnRWMwGDcqbaFGw++MYrT5UrE8vi3EEdG+NBwdaxNhxV70ef
9Zknagx4TLe4dVbxK19ERHIo5Dfm2Vsf3JHlwnSJt62p6BcNCtv6XUiXBTmAsW9w
NleGO8+ohZlThwDnDvMOBtn0eHADyzn95LWsAQBDI6eDTgb+FPKGNx5EKumc4eSs
AhceC0PJZtLuxVbzBAn+/uQH4oOlt8TvB4yOfOy05SytIDQdxQ91gQd4opO0IGKs
TGmSuBXfV0Zy+FzjsrqeM1ehA9PoVvSzbjLnmi1M51GMseevjBjohgTOhX6RWUP+
dpF4lJ02MzNPszYd5r0E0O9n1vMp/Ps+km4EldP/UqRCyrz+NIhyI4uQmb73gWHb
FVKHnGOQGro=
=EcII
-----END PGP SIGNATURE-----

--Sig_/nt7gQNsN/A7kJPD6_lLfjcg--
