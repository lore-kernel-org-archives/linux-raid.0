From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 06:47:18 +0200
Message-ID: <20080716044718.GA7626@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <1216180685.5633.364.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1216180685.5633.364.camel@sam.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 16, 2008 at 01:58:05PM +1000, Ben Martin wrote:
> On Tue, 2008-07-15 at 18:39 +0200, Keld J=F8rn Simonsen wrote:
> > On Wed, Jul 16, 2008 at 12:06:09AM +1000, Ben Martin wrote:
>=20
> One interesting question about the r10 layouts, if f2/o2 perform bett=
er
> than n2 why is the default for creation still n2? Just like mkfs.xfs
> determining the raid chunk and stripe size for you (assuming you don'=
t
> use LVM to circumvent this, gah!), shouldn't mdadm select the "fastes=
t"
> --layout as the default for RAID-10?

Perhaps. I think Neil first implemented "near", and more or less at the=
 same
time "far" - but to him the main thing was "near". This was 2.6.9. Then
in 2.6.18 he implemented "offset".  In the early days the
characteristics of each layout were not well known. It is only in the
last year or so I have seen benchmarks with n2, f2 and o2.

> >=20
> > It would be interesting if you could enhance your article with benc=
hmarks
> > on raid10, f2 and o2 layouts. I think they would outperform HW raid=
, at
> > least on input. And I would like to see how they perform on outout =
and
> > rewrite, with ext3 and xfs. We do have some tests, but many of them=
 are
> > without a file system layer.
>=20
> This will probably be the target of a new article at some point which
> just focuses on R10.

Sounds good!

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
