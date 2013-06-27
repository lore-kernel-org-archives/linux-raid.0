From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Fri, 28 Jun 2013 07:12:50 +1000
Message-ID: <20130628071250.78db1f9b@notabene.brown>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
	<20130619100803.03fde6d5@notabene.brown>
	<20130620161639.GA3033@lazy.lzy>
	<20130624170458.568dafcb@notabene.brown>
	<20130624171016.GA2237@lazy.lzy>
	<20130625095422.29d3079b@notabene.brown>
	<20130625164628.GA2261@lazy.lzy>
	<20130627142719.5ffbf0ce@notabene.brown>
	<20130627204900.GA2240@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NcFnbfBUzRx2ty9Szj/OY9z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130627204900.GA2240@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org, Robert Buchholz <rbu@goodpoint.de>
List-Id: linux-raid.ids

--Sig_/NcFnbfBUzRx2ty9Szj/OY9z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Jun 2013 22:49:00 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> On Thu, Jun 27, 2013 at 02:27:19PM +1000, NeilBrown wrote:
> [...]
> > I've just had a little look at raid6test - because some of the selftest=
s were
> > failing.
> >=20
> > The default output is rather verbose.  Verbose output can be good, but =
not as
> > the default I think.
> >=20
> > However, more importantly, it pays too much heed to the chunksize.
> >=20
> > If the start of one chunk on drive X is bad, and the end of a correspon=
ding
> > chunk on drive Y is bad, then it will complain that it cannot figure ou=
t the
> > problem.
> > It shouldn't do that.  It shouldn't even look at whole chunks at a time.
> >=20
> > It should look at blocks.  Maybe 512bytes or 1K or 4K any of those woul=
d do.
> > Then for each block it should figure out if there is a problem, and may=
be
> > auto-fix it.
>=20
> Hi Neil,
>=20
> thanks for the feedback.
>=20
> I checked "mdadm" man page and it states that the chunk
> size is always a multiple of 4K (and a power of 2).
> I assume this is correct, so I would suggest 4K as
> block size. Also because of SSD and many HDD which
> are already 4K.
>=20
> What do you think?
>=20
> Does it seem reasonable to you?

Yes, using 4K blocks is perfectly reasonable.

>=20
> "raid6check" is processing and collecting statistics
> "per byte", I assume it should not need a big architectural
> change in order to fit 4K.
>=20
> About the verbosity, I know, this was already discussed.
> My idea was to reduce it, once the other code stabilize.

Fair enough.  I was thinking in the context of making raid6check part of the
default install.  I wouldn't want to do that until it was more "user
friendly".  I also wouldn't want to do it until he code had stabilized.  So
your idea fits perfectly.

Thanks,
NeilBrown


--Sig_/NcFnbfBUzRx2ty9Szj/OY9z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcyq0jnsnt1WYoG5AQKPsw/+JCtylDOiV/ooA7TKDW1y1rvgMF2GpWX9
WjllsvhCYxj6ntZK+ee3hpc2BI4KrzU81CQ8W3FSiNDRPL8nvBhvQBw5D2h+fUL9
PUDdZGX6WSIFJx8hdCaYNnnizzZCCWMi4Wznb6yM7hGQot9EIRZHnbIKFB2QFeE9
eAIUXKS+H1pFK3XJGUGj5rd130R6H45QOXEwrxCj55eppsq/osqj7yJKHnEhw+yP
ozlLPhYozKI4N9Hb0vYtFH3JLFmVjdEX5QPFYxemV2ZT9pyV9ehNYFvV+DC2XWzH
No3wEVU52M4LKeCxjLj8QICG3m6Nqste+wIyfhlTlwUGAmD0YOG0SwO9qozNspst
hlkObqjgydZvofi0v+ASeErNdLuNMd+3P4R7D7vvaPyLeNzQ47fdOwsNaiYDjvqI
09ru13KUB9ImXtemLOrz+1qt2IgKV4Hg3WqMwOEtpeFkgLLfd4LkA7yB7uMr2Uic
O4H9HN51Al72hjHjVK7576MNmv3wMQcxu+w255ZBqz1bO6DDgYzTQuDRxqEnWoSM
pSQOEHFnyJjjbnUFVOdzlytr+4b0KL/Ew/ZZrSY82xccExQrNiqJmbgWSzNkzA6O
s8oc4eZms4DVMifaOnD6T9cHOmTmlOyHNVjHNreBQr0R3ayTg4+XnwgCa/GrqPbQ
B5YK8fv2N/o=
=m3dG
-----END PGP SIGNATURE-----

--Sig_/NcFnbfBUzRx2ty9Szj/OY9z--
