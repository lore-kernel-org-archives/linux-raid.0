From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Wed, 5 Aug 2009 09:44:38 +0200
Message-ID: <20090805074438.GB23696@rap.rap.dk>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com> <20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk> <72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com> <20090731175455.GA11463@rap.rap.dk> <72dbd3150907311310s2ccfc379u2c23fe724007b9bb@mail.gmail.com> <20090801130043.GA24915@rap.rap.dk> <72dbd3150908010813n3aed3804s3a0c0265cb2c2c6d@mail.gmail.com> <20090801175734.GB27831@rap.rap.dk> <72dbd3150908041521q1d71994cl25159d5ec3e7f326@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <72dbd3150908041521q1d71994cl25159d5ec3e7f326@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 04, 2009 at 03:21:28PM -0700, David Rees wrote:
> 2009/8/1 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> > On Sat, Aug 01, 2009 at 08:13:45AM -0700, David Rees wrote:
> >> No - you're getting 120 MB/s from one disk and 80MB/s from another=
=2E
> >> How that would add up to 230MB/s defies logic...
> >
> > Why only 80 MB/ when reading? reading from both disks with raid10,f=
2 are done at the
> > beginning of both disks, thus getting about 115 MB/s from both of t=
hem.
> >
> > reading in raid10,f2 is restricted to the faster half of the disk, =
by
> > design.
> >
> > It is different when writing. there both halves, fast and slow, are
> > used.
>=20
> As I mentioned earlier, I was having a hard time visualizing the data
> layout.  So here's a simple diagram that shows near/far layout and wh=
y
> Keld was right - with a far layout, reads can be isolated to the fast
> half of the disk.
>=20
> It also shows how sequential writes (or any other write that spans
> multiple chunks) force the drives to seek half way across the disk fo=
r
> each write.
>=20
> Near layout, 4 disks, 2 copies:
> a b c d
> 0 0 1 1
> 2 2 3 3
> 4 4 5 5
> 6 6 7 7
>=20
> Far layout, 4 disks, 2 copies
> a b c d
> 0 1 2 3
> 4 5 6 7
> 7 0 1 2
> 3 4 5 6

No, it is rather:

=46ar layout, 4 disks, 2 copies
a b c d
0 1 2 3
4 5 6 7
1 0 3 2
5 4 7 6

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
