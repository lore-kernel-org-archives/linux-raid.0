From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Mon, 9 May 2011 21:57:09 +0200
Message-ID: <20110509195708.GA26847@www2.open-std.org>
References: <20110506071752.GA22063@www2.open-std.org> <20110508181445.GB7629@maude.comedia.it> <4DC70A44.5050101@meetinghouse.net> <20110509034036.GA17111@www2.open-std.org> <20110509142426.564aae2c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110509142426.564aae2c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 09, 2011 at 02:24:26PM +1000, NeilBrown wrote:
> On Mon, 9 May 2011 05:40:36 +0200 Keld J=F8rn Simonsen <keld@keldix.c=
om> wrote:
>=20
> > On Sun, May 08, 2011 at 05:25:24PM -0400, Miles Fidelman wrote:
> > > Luca Berra wrote:
> > > >On Fri, May 06, 2011 at 09:17:52AM +0200, Keld J=F8rn Simonsen w=
rote:
> > > >>I would like linux MD raid10 functionality to be part of the Li=
nux MD
> > > >>RAID1 module, and be called raid1. This is in accordance with t=
he
> > > >then we need rename the current raid1 functionality to 'mirror'.=
 in
> > > >order to avoid further confusion.
> > > >besides, current raid10 does not support resizing, so the featur=
e
> > > >should be added before ditching 'mirror'
> > > >
> > >=20
> > > The current md RAID1 does exactly what RAID1 is supposed to do.
> >=20
> > I changed my mind a little.
> >=20
> > I think we should follow SNIA wrt. RAID1 - all that SNIA would say =
is
> > RAID1 we also should be able to do as RAID1 - that would include
> > raid10-offset which directly was implemented in the Linux kernel
> > because of the SNIA RAID1 specification. It should also include rai=
d10-far
> > in so far it is a raid1 type - say a raid10,f2 with only 2 disks.=20
>=20
> I think you misread SNIA-DDF.
>=20
> In DDF, arrays with a PRL (Primary RAID Level) of 1 can have an RLQ (=
RAID
> level qualifier) of 0 or 1.
> RLQ =3D 0  ->  RAID1 with 2 devices
> RLQ =3D 1  ->  RAID1 with 3 devices.
>=20
> DDF also devices a PRL of '11' which it calls "RAID-1E" (though this =
term
> only appears once in the DDFv1.2 spec)
>=20
> For PRL =3D 11  there are two options
>=20
> RLQ =3D 0 -> Integrated Adjacent Stripe Mirroring
> RLQ =3D 1 -> Integrated Offset Stripe Mirroring.
>=20
> These correspond to md/raid10 "near2" and "offset2".
>=20
> So DDF: RAID-1E  corresponds to md: RAID-10
>=20
> So an 'E' rather than a '0'.
>=20
> I would not be against allowing mdadm to accept "raid1e" as a synonym=
 for
> 'raid10', and mentioning the alternate name in the documentation woul=
d be
> entirely appropriate.

Yes, I would like that we cocument the correspondance to the SNIA DDF
standard, and do other descriptions as you stipulate.

> But RAID-1E is not RAID-1.  Nor is RAID-10.

I see.

By "Nor is RAID-10." you mean RAID-1+0 or linux md raid10?

What is the difference between RAID-1E and Linux MD raid10?
Linux MD raid10 has "far" layout?
Linux MD raid10 can have more than 2 copies?
More stuff?



> >=20
> > Then we should keep the raid10 stuff.
> >=20
> > > The md RAID10 is a very specific, and unique approach that has=20
> > > similarities to, but is distinct from, RAID1+0, RAID0+1, RAID5, a=
nd RAID6.
> >=20
> > Yes, Linux MD raid10 is a very distinct type. We should talk with S=
NIA to get it
> > recognized.
> >=20
> > > What say we leave the names alone.  Just beause one person is con=
fused is=20
> > > no reason to further confuse things.
> >=20
> > The confusion is not just one person. The confusion is unbelievable=
 common,=20
> > and has proven to be very hard to eliminate. If we align with the S=
NIA
> > standard, and further get the standard to align with us, then we sh=
ould
> > have a chance in say 5 years to have reduced the confusion consider=
ably.
>=20
> The world is full of confusion that is hard to eliminate.
>=20
> The problem here I think is simply people who do not educate themselv=
es,
> either because they cannot be bothered, or because they cannot easily=
 find
> the materials.
>=20
> The first is not really a fixable problem.
> The second we can address.  Improve the already-good wiki or add more=
 text to
> the man pages.  Have an aim that every general-information question c=
an be
> answered by simply posting a like or a passage from the man page.
>=20
> That would be really worthwhile.
>=20
> Changing names around is, I think, less valuable.

It is just that I have been around on other web pages for RAID, to
improve references to the linux-raid wiki and to correct errors in thei=
r
description of Linux RAID. Many - maybe most - people that write about
Linux RAID have a number of their details wrong.  That should be expert=
s
conveying their expert wisdom to knowledge-hungry users. An example:
http://wiki.linuxquestions.org/wiki/RAID#RAID-10
They claim you need 4 disks for MD raid10. Another example is the Germa=
n
wikipedia page on RAID - which was moderated and the moderator did not
accept my edits. This page does not describe Linux MD raid10.=20

I think naming matters. If we could call Linux MD raid10 for raid1e
I think much would be achieved in terms of eliminating
misunderstandings.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
