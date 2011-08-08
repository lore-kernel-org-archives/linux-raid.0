From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 check found different events, how should I proceed?
Date: Tue, 9 Aug 2011 08:57:04 +1000
Message-ID: <20110809085704.24060e8d@notabene.brown>
References: <CADNH=7Eiqx0wCFypxqy-DSKWmr62L83MpP+V8XzjMEWJ3NE0yw@mail.gmail.com>
	<CADNH=7FBkx5HgWKiEzL_sNZvbjjTMbS23wOYXyrmPETCRbVwOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FBkx5HgWKiEzL_sNZvbjjTMbS23wOYXyrmPETCRbVwOw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 6 Aug 2011 17:02:48 +0100 Mathias Bur=E9n <mathias.buren@gmail.=
com>
wrote:

> On 6 August 2011 14:23, Mathias Bur=E9n <mathias.buren@gmail.com> wro=
te:
> > My RAID6 is currently degraded with one HDD (panic mail on the list=
),
> > and my weekly cron job kicked in doing the RAID6 check action. This=
 is
> > the result:
> >
> > DEV =A0 =A0 EVENTS =A0REALL =A0 PEND =A0 =A0UNCORR =A0CRC =A0 =A0 R=
AW =A0 =A0 ZONE =A0 =A0END
> > sdb1 =A0 =A06239487 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
> > sdc1 =A0 =A06239487 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
> > sdd1 =A0 =A06239487 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
> > sde1 =A0 =A06239487 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
> > sdf1 =A0 =A06239490 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 49 =A0 =A0 =A0=
 =A0 =A0 =A0 =A06
> > sdg1 =A0 =A06239491 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
> > sdh1 =A0 =A0(missing, on RMA trip)
> >
> (snip)
> > * Should I run a repair?
> > * Chould I run a check again, to see if the event count changes?
> > * Is it likely I've 2 more bad harddrives that will die soon?
> > * Is it wise to run another smartctl -t long on all devices?
> >
> > Thanks,
> > Mathias
> >
>=20
> A followup;
>=20
> I ran smartctl -t long on all devices, and they all passed, SMART is
> fine. The number of events is also the same for all HDDs now:
>=20
> DEV	EVENTS	REALL	PEND	UNCORR	CRC	RAW	ZONE	END
> sdb1	6244415	0	0	0	2	0	0=09
> sdc1	6244415	0	0	0	0	0	0=09
> sdd1	6244415	0	0	0	0	0	0=09
> sde1	6244415	0	0	0	0	0	0=09
> sdf1	6244415	0	0	0	0	49	6=09
> sdg1	6244415	0	0	0	0	0	0=09
> sdh1							=09
>=20
> This is without me running repair or anything like that.

The thing that you did which produced the change was that you let time =
pass.

Presumably there was a time delay (maybe small) between extracting the
'events' number from sde1 and sdf1, then sdf1 and sdg1.  During these t=
imes
the events on all devices in the array was updated.  This implies some =
thread
was writing, but possibly not writing very heavily.

When you sampled them all the second time and got the same number there=
 were
presumably no writes happening, so the event numbers didn't change.

When there are occasional writes the array oscillates between  'clean' =
and
'active' and each change updates the 'events' number.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
