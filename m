From: NeilBrown <neilb@suse.de>
Subject: Re: Hot-replace for RAID5
Date: Mon, 21 May 2012 20:12:11 +1000
Message-ID: <20120521201211.6f269444@notabene.brown>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<4FB43977.8020607@volatilevoid.net>
	<20120518134555.3a9ce08b@notabene.brown>
	<4FBA10E3.7080202@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vl6z8wnyVLdWxHF4r/MXaVU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBA10E3.7080202@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Oliver Martin <oliver@volatilevoid.net>, patrik@dsl.sk, David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vl6z8wnyVLdWxHF4r/MXaVU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2012 11:54:43 +0200 Asdo <asdo@shiftmail.org> wrote:

> On 05/18/12 05:45, NeilBrown wrote:
> > On Thu, 17 May 2012 01:34:15 +0200 Oliver Martin<oliver@volatilevoid.ne=
t>
> > wrote:
> >
> >> Hi Neil,
> >>
> >> Am 11.05.2012 02:50, schrieb NeilBrown:
> >>> Doing an in-place reshape with the new 3.3 code should work, though w=
ith a
> >>> softer "should" than above.  We will only know that it is "stable" wh=
en enough
> >>> people (such as yourself) try it and report success.  If anything doe=
s go
> >>> wrong I would of course help you to put the array back together but I=
 can
> >>> never guarantee no data loss.  You wouldn't be the first to test the =
code on
> >>> live data, but you would be the second that I have heard of.
> >> I guess I'll be taking 2nd place then. I just used it on three live
> >> raid6 arrays, and it worked perfectly.
> > 3 arrays - so you are 2nd, 3rd, and 4th :-)
>=20
> Good to know that when all is good, hot-replace works.
>=20
> I wonder if all "error paths" were considered and implemented (and maybe=
=20
> even tested, but we users could help with testing if we understand the=20
> intended behaviour), i.e.

I hope I considered them...  but I do miss things sometimes :-)

>=20
> what happens when the disk being hot-replaced shows read errors in=20
> locations previously unknown to the bad-block list: does it
> - immediately fall back to fail+rebuild or
> - first tries a recompute + rewrite of the sector, then if rewrite fails=
=20
> it falls back to fail+rebuild

This one if no bad-blocks list is configured.

> - first tries a recompute + rewrite of the sector, then if rewrite fails=
=20
> it adds the block to bad block list, then if the list is out-of-space it=
=20
> falls back to fail+rebuild

This one if a bad-blocks list is configured
> ?
>=20
> What happens if the destination of the hot-replace has *one* write=20
> error? And *lots* of write errors?

If the hot-replace destination has any write errors it is failed and removed
from the array.  Better the devil you know ....

>=20
> What happens if one hot-replace hits a sector for which both the disk=20
> being replaced and another one have an entry in the bad block list, and=20
> so there is not enough parity information to recompute? Does it proceed=20
> anyway marking the corresponding sector in the bad-block-list for the=20
> destination device (=3Dnonvalid strip), or it fails the hot-replace, or w=
hat?

If a bad-block list is configured for the target device, a bad block is
recorded there, else the device is failed.

>=20
> (this is actually more about bad block lists)
> What happens if a *different* disk shows back sectors due to concomitant=
=20
> reads (simultaneous but not caused by hot-replace):
> - first recomputes and rewrites, then if rewrite fails it is added to=20
> bad block list, then if list is full it gets failed? Or can another=20
> hot-replace get started when already one is running?

The handling of bad blocks is independent of any hot-replace activity.
So if some other device gets a read error we try to recover as normal.
If the results in an error which would trigger a hot-replace, then at the
next opportunity when no resync/recovery/reshape/replace is running, and a
spare is available, a hot-replace will start.

Hope that clarifies the situation.

Thanks,
NeilBrown



>=20
> Thank you


--Sig_/vl6z8wnyVLdWxHF4r/MXaVU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7oU+znsnt1WYoG5AQJpKhAArKA8PBzTkhkASEWsPyQ2IhIs6fuT0Lkq
jG+Xekvxt6h+PdTFp8vdidNWPi1CXYzO08dhVnESBfig5XQoFmHWz+N5DQHsnFju
wKDRqBO+RnBNUlyYmPK2vX8Lmzb1qTUEP8p+mWX8cYAlwIvfl2gvVzNJbqYfBZox
8xsC2Y+m1myfney2MAtfg1RwkzovPxHASX5xJOyjsTdV4rbG+3C2alxsW9CTHyHE
aY04KH7tVEXkfh8e4XQ3UHlEkhvV/7S5luhU4itE85ZjPR5CHOFD2yJveOAQsnuL
EUgwQTwSK8+MDAGLvZ4R0jlaFLA70FE1m7ETuvxcpRDGJ1mmjvtdYxF4LBd8kD6D
iTI5BciQUN5qUAFV6cBMH1Fs+514w1NxR3lga+Hl0LHpNV+/JkgMqgoeAKVIdjRN
XLra4S8GZ+Pma12qRkaRZlFHs7dG0A1V0wcYUMiU5Oin6WSBgfDQ8NbAlsjvzXql
5+o68jYl7Pux0261cbqtpxsKmODmtUoqlEhcA6VLZw/CIOYKNeNXych30ba1FqV3
z62pQqT4s+22q7gwOBpCjdFdGxMu177bwLLRsPrpYjhk8xbsBbN9bbWfm89PhnwU
dK0NdaIouOtYU8h0QKPhzGrJ5hn9BKHWrF6cAGYxzPHAMxFCXSqyv0WY6wFJeKoK
NLkIdS0eTJI=
=3beO
-----END PGP SIGNATURE-----

--Sig_/vl6z8wnyVLdWxHF4r/MXaVU--
