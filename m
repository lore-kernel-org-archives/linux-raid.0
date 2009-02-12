From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 12:16:43 +0100
Message-ID: <20090212111643.GB13786@rap.rap.dk>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212081148.GD9439@rap.rap.dk> <4993E82D.1020309@fairbairn-family.com> <20090212094604.GA11981@rap.rap.dk> <1e30801732ac82156aef4d99517a92a3.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1e30801732ac82156aef4d99517a92a3.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Steve Fairbairn <steve@fairbairn-family.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2009 at 09:52:32PM +1100, NeilBrown wrote:
> On Thu, February 12, 2009 8:46 pm, Keld J=F8rn Simonsen wrote:
> > On Thu, Feb 12, 2009 at 09:13:17AM +0000, Steve Fairbairn wrote:
> >> Keld J=F8rn Simonsen wrote:
> >> >
> >> >I would rather have functionality to convert raid10 to raid5.
> >> >raid1 should be depreciated, as raid10,n2 for all purposes is the=
 same
> >> >but better implementation and performance, and raid10,f2 and raid=
10,o2
> >> >are even better.  Nobody should use raid1 anymore.
> >> >
> >> Complete ignorance of raid10 here, but is raid10,<anything> bootab=
le,
> >> like raid1 is?  I use raid1 on my root and boot partitions.
> >
> > AFAIK, raid10,n2 in default mode (superblock etc) is bootable, as i=
t
> > looks like two copies of a normal FS. I think this was even reporte=
d
> > on this list at some time.
> >
> > You are not the only one that does not know much about raid10. I th=
ink
> > most Linux administrators don't.  And other system adminstrators mo=
st
> > likely don't either.
> >
> > Maybe we should rename raid10 to raid1?
> >
> > Raid10 should just be an enhanced raid1. And I understand from Neil=
 that
> > raid10,o2 is mostly done because it is a standard raid1 layout. So =
it is
> > strange that it is not available with raid1 in Linux. And I also th=
ink
> > that the raid10,f2 layout is available from some HW raid controller=
s, as
> > their implementation of raid1. So all what is in raid10 is other pl=
aces
> > considered raid1 stuff.
> >
>=20
> The 'offset' layout came about to be able to support a DDF format
> which is called:
>=20
> 4.2.18 Integrated Offset Stripe Mirroring (PRL=3D11, RLQ=3D01)
>=20
> (4.2.18 is the section of the document
>  PRL is Primary Raid Level
>  RLQ is Rail Level Qualifier
> )
> There is also
>=20
> 4.2.17 Integrated Adjacent Stripe Mirroring (PRL=3D 11, RLQ=3D00)
>=20
> which is essentially the same as our n2 layout.
>=20
> You should see their
> 4.3.4 Spanned Secondary RAID Level (SRL=3D03)
>=20
> Though.  That would be really .. interesting to implement.
>=20
>=20
> You can down load the ddf spec at
>=20
> http://www.snia.org/tech_activities/standards/curr_standards/ddf/
>=20
> NeilBrown

I did look at the spec, and I could not find something that looked like
f2. I then sent them a mail suggesting standardizing raid10,f2 - some
months ago. No answer (yet...) Am I right that raid10,f2 is not
described in their spec? A bit odd. The idea behind raid10,f2 is quite
straightforward, and gives good results.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
