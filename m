From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Wed, 1 Apr 2015 17:02:56 +1100
Message-ID: <20150401170256.5efebaae@notabene.brown>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
	<CAPcyv4jqb+OphP-1sy0dqMYG-uNK-CwtNDmOM4YeQU=MXH72Hw@mail.gmail.com>
	<20150401055309.GA726662@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//gDiWKryusA7ju=M64+zEht"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150401055309.GA726662@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, Kernel-team@fb.com
List-Id: linux-raid.ids

--Sig_//gDiWKryusA7ju=M64+zEht
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Mar 2015 22:53:21 -0700 Shaohua Li <shli@fb.com> wrote:

> On Tue, Mar 31, 2015 at 08:47:04PM -0700, Dan Williams wrote:
> > On Mon, Mar 30, 2015 at 3:25 PM, Shaohua Li <shli@fb.com> wrote:
> > > This is my attempt to fix raid5/6 write hole issue, it's not for merge
> > > yet, I post it out for comments. Any comments and suggestions are
> > > welcome!
> > >
> > > Thanks,
> > > Shaohua
> > >
> > > We expect a completed raid5/6 stack with reliability and high
> > > performance. Currently raid5/6 has 2 issues:
> > >
> > > 1. read-modify-write for small size IO. To fix this issue, a cache la=
yer
> > > above raid5/6 can be used to aggregate write to full stripe write.
> > > 2. write hole issue. A write log below raid5/6 can fix the issue.
> > >
> > > We plan to use a SSD to fix the two issues. Here we just fix the write
> > > hole issue.
> > >
> > > 1. We don't try to fix the issues together. A cache layer will do wri=
te
> > > acceleration. A log layer will fix write hole. The seperation will
> > > simplify things a lot.
> > >
> > > 2. Current assumption is flashcache/bcache will be used as the cache
> > > layer. If they don't work well, we can fix them or add a simple cache
> > > layer for raid write aggregation later. We also assume cache layer wi=
ll
> > > absorb write, so log doesn't worry about write latency.
> >=20
> > It seems neither bcache nor dm-cache are tackling the write-buffering
> > problem head on... they still seem to be concerned with some amount of
> > read caching which I can see as useful for file servers and
> > workstations, but not necessarily scale out storage.
> >=20
> > I'll try to set aside time to take a look at the patch this week.
>=20
> Thanks! The cache layer is definitely what I'll focus on next. bcache
> supports writeback, I guess we can add an option to skip read data from
> backing disks for read caching if it's possible. Another option is
> writting a simple caching just for raid 5/6 write aggregation. We can
> append all data to a log, and maintain an index in memory. At raid
> shutdown, we can flush all data to raid disks, the index doesn't need
> presistent in disk, which makes the caching fairly simple.

Surely if the index doesn't need to persist in disk, then the data doesn't
either, as without the index you cannot find the data...

NeilBrown

--Sig_//gDiWKryusA7ju=M64+zEht
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRuKEDnsnt1WYoG5AQIVKA/7BOKG6CuRqq81VXRugwq/jJ5RgcImwKcv
QQ1q3FVQQsiGMsAlZPz100P+CB44pi0Lzcptfk4zqKWpTrDNmOR03WvdG3ZSQG4M
wFegoFgrXbVuM6a25+l97FyyySRM1KhBrzgKqR69gjPPy71caaZhPCJ0145QmZkF
DpuFJrRtW2jePXyxoOdus0YYxEPY+He6822fq5R+NAn4PzYrpPVPqi7lah5QPfLO
GuBUM9K0bdIwZXK7LC5FYZBlb5bEEruqb7k71Z/6dM7O7Ampn8EzSkCXJAsYWiRo
PkvaW/F1wJly7LHXn4rBGdX8PF5/EvnB2llYzNrMdrMBjYdXv5jFwENG8rdFzaPd
Lu35LIXYLfVXHJhyK0rzPjnG1yovsyq1KkbyCuzeyeGUUvQEu2YXceAD/DYx6edf
ivQ0nASBFwSe9xLgupU0gqE0ERXItg6NGH7LvYkGkFXgj1JyPDlz2+8Y2a51tYOy
ekoniuxp7w7GK4c2RbqFLfN5An1liY//nNeZT2ko0hHM60t36XfRgRR5EmAQg07V
bbcj5yqk4My7KauzA9ILXcwU7CzuwN9dAiUR9Q5x3bTf3C63l4N0qldNHEcqbTL2
48BxPaKBGLowUpd2MWOXvqIWbvCkZpdvHV6uj5bzn3k+sqF2fsdwZS4ciw8TjQUF
rCJPsiriDsE=
=vGKk
-----END PGP SIGNATURE-----

--Sig_//gDiWKryusA7ju=M64+zEht--
