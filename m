From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 10:53:05 +0100
Message-ID: <20090212095305.GB11981@rap.rap.dk>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212081148.GD9439@rap.rap.dk> <12039e3b9172d1a1347b8396cab59f11.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12039e3b9172d1a1347b8396cab59f11.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2009 at 08:21:12PM +1100, NeilBrown wrote:
> On Thu, February 12, 2009 7:11 pm, Keld J=F8rn Simonsen wrote:
> > On Thu, Feb 12, 2009 at 02:10:10PM +1100, NeilBrown wrote:
> >> Comments and testing very welcome.
> >
> > I would rather have functionality to convert raid10 to raid5.
> > raid1 should be depreciated, as raid10,n2 for all purposes is the s=
ame
> > but better implementation and performance, and raid10,f2 and raid10=
,o2
> > are even better.  Nobody should use raid1 anymore.
>=20
> That is a fairly simplistic view.

It was also formulated to provoke some thoughts.

> raid1 supports --write-mostly and --write-behind which raid10 is unli=
kely
> ever to support.

why?

Anyway would it not be possible that this functionality be implemented
for raid10,n2?

> Certainly in many cases raid10 is just as good or better than raid1
> though.
>=20
> Certainly a raid10->raid5 conversion for a 2-drive n2 configuration
> is trivial to arrange.  Other conversions are less likely to be suppo=
rted
> as they require significant non-trivial rearrangement of data.

Yes, possibly.


Some code to grow raid10 would also be desirable. Maybe it is some of
the same operations that need to be applied: getting the old data in,
have it restructured for the new format, in a safe way, and possibly
with the help of an extra disk, or possibly not. It sounds non-trivial
to me too.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
