From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 18:44:22 +0100
Message-ID: <20090212174422.GA20703@rap.rap.dk>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212081148.GD9439@rap.rap.dk> <12039e3b9172d1a1347b8396cab59f11.squirrel@neil.brown.name> <20090212095305.GB11981@rap.rap.dk> <780b8d5e33de8ec127222529e84f6026.squirrel@neil.brown.name> <7a329d910902120728u146e7cddk6e7d990668c16345@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7a329d910902120728u146e7cddk6e7d990668c16345@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wil Reichert <wil.reichert@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2009 at 07:28:59AM -0800, Wil Reichert wrote:
> On Thu, Feb 12, 2009 at 2:45 AM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, February 12, 2009 8:53 pm, Keld J=F8rn Simonsen wrote:
> >> On Thu, Feb 12, 2009 at 08:21:12PM +1100, NeilBrown wrote:
> >>> On Thu, February 12, 2009 7:11 pm, Keld J=F8rn Simonsen wrote:
> >>> > On Thu, Feb 12, 2009 at 02:10:10PM +1100, NeilBrown wrote:
> >>> >> Comments and testing very welcome.
> >>> >
> >>> > I would rather have functionality to convert raid10 to raid5.
> >>> > raid1 should be depreciated, as raid10,n2 for all purposes is t=
he same
> >>> > but better implementation and performance, and raid10,f2 and ra=
id10,o2
> >>> > are even better.  Nobody should use raid1 anymore.
> >>>
> >>> That is a fairly simplistic view.
> >>
> >> It was also formulated to provoke some thoughts.
> >>
> >>> raid1 supports --write-mostly and --write-behind which raid10 is
> >>> unlikely
> >>> ever to support.
> >>
> >> why?
> >>
> >> Anyway would it not be possible that this functionality be impleme=
nted
> >> for raid10,n2?
> >
> > It would be possible, but it might not be sensible.
> >
> > write-mostly and write-behind only really make sense when you have =
the
> > clear distinction between drives that raid1 gives you.
> > These options don't make sense for raid10 in general.  Only in very=
 specific
> > layouts.
> > If you like, raid1 is an implementation of a specific raid10 layout=
,
> > where it makes sense to add some extra functionality.
> >
> >>
> >> Some code to grow raid10 would also be desirable. Maybe it is some=
 of
> >> the same operations that need to be applied: getting the old data =
in,
> >> have it restructured for the new format, in a safe way, and possib=
ly
> >> with the help of an extra disk, or possibly not. It sounds non-tri=
vial
> >> to me too.
> >
> > What particular growth scenarios are you interested it?
> > Just adding a drive and restriping onto that?  i.e keep that
> > same nominal layout but increase 'raid-disks'?
> >
> > That would be quite similar to the raid5 grow operation so it shoul=
dn't
> > be too hard to achieve.
> > A 'grow' which changed the layout (e.g. near to far) would be a lot
> > harder.
>=20
> I'd previously seen the wikipedia article regarding Linux RAID10 and
> its mention of the 3 disk case.  Out of academic curiousity, how does
> the 2 disk RAID10 work?  Is it just a matter of have 2 identical
> volumes and reading subsequent stripes from the alteranate drives?  O=
r
> is the algorithm more complicated?

There are 3 different layouts for raid10: near, far and offset.
Basically raid10 with 2 disks works as RAID 1 - and "near" and linux
raid1 is almost equivalent. far and offset has somewhat different
placements of blocks on the disks, which should lead to faster operatio=
n
for some common tasks.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
