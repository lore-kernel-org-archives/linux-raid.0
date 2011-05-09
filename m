From: NeilBrown <neilb@suse.de>
Subject: Re: wish for Linux MD mirrored raid types
Date: Mon, 9 May 2011 14:24:26 +1000
Message-ID: <20110509142426.564aae2c@notabene.brown>
References: <20110506071752.GA22063@www2.open-std.org>
	<20110508181445.GB7629@maude.comedia.it>
	<4DC70A44.5050101@meetinghouse.net>
	<20110509034036.GA17111@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110509034036.GA17111@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>
Cc: Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 May 2011 05:40:36 +0200 Keld J=F8rn Simonsen <keld@keldix.com=
> wrote:

> On Sun, May 08, 2011 at 05:25:24PM -0400, Miles Fidelman wrote:
> > Luca Berra wrote:
> > >On Fri, May 06, 2011 at 09:17:52AM +0200, Keld J=F8rn Simonsen wro=
te:
> > >>I would like linux MD raid10 functionality to be part of the Linu=
x MD
> > >>RAID1 module, and be called raid1. This is in accordance with the
> > >then we need rename the current raid1 functionality to 'mirror'. i=
n
> > >order to avoid further confusion.
> > >besides, current raid10 does not support resizing, so the feature
> > >should be added before ditching 'mirror'
> > >
> >=20
> > The current md RAID1 does exactly what RAID1 is supposed to do.
>=20
> I changed my mind a little.
>=20
> I think we should follow SNIA wrt. RAID1 - all that SNIA would say is
> RAID1 we also should be able to do as RAID1 - that would include
> raid10-offset which directly was implemented in the Linux kernel
> because of the SNIA RAID1 specification. It should also include raid1=
0-far
> in so far it is a raid1 type - say a raid10,f2 with only 2 disks.=20

I think you misread SNIA-DDF.

In DDF, arrays with a PRL (Primary RAID Level) of 1 can have an RLQ (RA=
ID
level qualifier) of 0 or 1.
RLQ =3D 0  ->  RAID1 with 2 devices
RLQ =3D 1  ->  RAID1 with 3 devices.

DDF also devices a PRL of '11' which it calls "RAID-1E" (though this te=
rm
only appears once in the DDFv1.2 spec)

=46or PRL =3D 11  there are two options

RLQ =3D 0 -> Integrated Adjacent Stripe Mirroring
RLQ =3D 1 -> Integrated Offset Stripe Mirroring.

These correspond to md/raid10 "near2" and "offset2".

So DDF: RAID-1E  corresponds to md: RAID-10

So an 'E' rather than a '0'.

I would not be against allowing mdadm to accept "raid1e" as a synonym f=
or
'raid10', and mentioning the alternate name in the documentation would =
be
entirely appropriate.

But RAID-1E is not RAID-1.  Nor is RAID-10.


>=20
> Then we should keep the raid10 stuff.
>=20
> > The md RAID10 is a very specific, and unique approach that has=20
> > similarities to, but is distinct from, RAID1+0, RAID0+1, RAID5, and=
 RAID6.
>=20
> Yes, Linux MD raid10 is a very distinct type. We should talk with SNI=
A to get it
> recognized.
>=20
> > What say we leave the names alone.  Just beause one person is confu=
sed is=20
> > no reason to further confuse things.
>=20
> The confusion is not just one person. The confusion is unbelievable c=
ommon,=20
> and has proven to be very hard to eliminate. If we align with the SNI=
A
> standard, and further get the standard to align with us, then we shou=
ld
> have a chance in say 5 years to have reduced the confusion considerab=
ly.

The world is full of confusion that is hard to eliminate.

The problem here I think is simply people who do not educate themselves=
,
either because they cannot be bothered, or because they cannot easily f=
ind
the materials.

The first is not really a fixable problem.
The second we can address.  Improve the already-good wiki or add more t=
ext to
the man pages.  Have an aim that every general-information question can=
 be
answered by simply posting a like or a passage from the man page.

That would be really worthwhile.

Changing names around is, I think, less valuable.

Thanks,
NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
