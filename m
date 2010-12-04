From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Degraded Array
Date: Fri, 3 Dec 2010 22:47:32 -0600
Message-ID: <25.6D.07087.7E7C9FC4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTikd91t=aHK-CkV8TfqctA-np0YzDu79AtzAtZnK@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikd91t=aHK-CkV8TfqctA-np0YzDu79AtzAtZnK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: Majed B. [mailto:majedb@gmail.com]
> Sent: Friday, December 03, 2010 10:27 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Degraded Array
>=20
> You have a degraded array now with 1 disk down. If you proceed, more
> disks might pop out due to errors.

	Well, sort of.  A significant fraction of the data is now striped
across 12 + 0 drives, rather than 11 + 1.  There are no errors occurrin=
g on
the drives, although of course an unrecoverable error could happen at a=
ny
time.

> It's best to backup your data, run a check on the array, fix it then

	The data is backed up.  Except in extreme circumstances, I would
never start a re-shape without a current backup.

> run a check on the array, fix it then, try to resume the reshape.

The array is in good health, other than the two kicked drives.  I'm not=
 sure
I understand what you mean, though.  I'm asking about the two offline
drives.  Should I add the 13th back?  It still has substantially the sa=
me
data as the other 12 drives, discounting the amount that has been
re-written.  If so, how can I safely stop the array re-shape and re-add=
 the
drive?  (This is under mdadm 2.6.7.2.)

>=20
> On Sat, Dec 4, 2010 at 5:42 AM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
> >
> > Hello everyone.
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 I was just growing one of my RAID=
6 arrays from 13 to 14
> > members.=A0 The array growth had passed its critical stage and had =
been
> > growing for several minutes when the system came to a screeching ha=
lt.
> > It hit the big red switch, and when the system rebooted, the array

	I meant to type *I*, not *It*.

> > but two members are missing.=A0 One of the members is the new drive=
 and
> the
> > other is the 13th drive in the RAID set.=A0 Of course, the array ca=
n run
> well
> > enough with only 12 members, but it=92s definitely not the best sit=
uation,
> > especially since the re-shape will take another day and a half.=A0 =
Is it
> best
> > I go ahead and leave the array in its current state until the re-sh=
ape
> is
> > done, or should I go ahead and add back the two failed drives?
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>=20
>=20
>=20
> --
> =A0 =A0 =A0=A0 Majed B.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
