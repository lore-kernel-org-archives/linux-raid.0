From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Mon, 9 May 2011 05:40:36 +0200
Message-ID: <20110509034036.GA17111@www2.open-std.org>
References: <20110506071752.GA22063@www2.open-std.org> <20110508181445.GB7629@maude.comedia.it> <4DC70A44.5050101@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DC70A44.5050101@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 08, 2011 at 05:25:24PM -0400, Miles Fidelman wrote:
> Luca Berra wrote:
> >On Fri, May 06, 2011 at 09:17:52AM +0200, Keld J=F8rn Simonsen wrote=
:
> >>I would like linux MD raid10 functionality to be part of the Linux =
MD
> >>RAID1 module, and be called raid1. This is in accordance with the
> >then we need rename the current raid1 functionality to 'mirror'. in
> >order to avoid further confusion.
> >besides, current raid10 does not support resizing, so the feature
> >should be added before ditching 'mirror'
> >
>=20
> The current md RAID1 does exactly what RAID1 is supposed to do.

I changed my mind a little.

I think we should follow SNIA wrt. RAID1 - all that SNIA would say is
RAID1 we also should be able to do as RAID1 - that would include
raid10-offset which directly was implemented in the Linux kernel
because of the SNIA RAID1 specification. It should also include raid10-=
far
in so far it is a raid1 type - say a raid10,f2 with only 2 disks.=20

Then we should keep the raid10 stuff.

> The md RAID10 is a very specific, and unique approach that has=20
> similarities to, but is distinct from, RAID1+0, RAID0+1, RAID5, and R=
AID6.

Yes, Linux MD raid10 is a very distinct type. We should talk with SNIA =
to get it
recognized.

> What say we leave the names alone.  Just beause one person is confuse=
d is=20
> no reason to further confuse things.

The confusion is not just one person. The confusion is unbelievable com=
mon,=20
and has proven to be very hard to eliminate. If we align with the SNIA
standard, and further get the standard to align with us, then we should
have a chance in say 5 years to have reduced the confusion considerably=
=2E

Best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
