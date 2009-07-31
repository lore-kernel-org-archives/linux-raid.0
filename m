From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Fri, 31 Jul 2009 20:10:41 +0200
Message-ID: <20090731181041.GA11756@rap.rap.dk>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com> <20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk> <72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com> <20090731175455.GA11463@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090731175455.GA11463@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 31, 2009 at 07:54:55PM +0200, Keld J=F8rn Simonsen wrote:
> On Thu, Jul 30, 2009 at 01:11:20PM -0700, David Rees wrote:
> > 2009/7/30 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> > > I think raid10,f2 only degrades 10-20 % while raid1 can degrade a=
s much
> > > as 50 %. For writing it is about the same, given that you use a f=
ile
> > > system on top of the raid.
> >=20
>=20
> > Random/small reads far: Up to 100% faster
>=20
> Actually a bit more, due to that far only uses the fastest half of th=
e
> disks. One test shows 132 % faster, which is consistent with theory.
>=20
> > Random/small reads near: Up to 100% faster
>=20
> One test shows 156 % faster.

I meant 56 % faster.

So one test (done by myself) shows far to be 132 % faster than single
disk, and near to be 56 % faster. Given the behaviour of near and far I
believe the tests to be representative of the near/far performance for
random reading.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
