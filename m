From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: recovering from a controller failure
Date: Sun, 30 May 2010 17:38:12 -0500
Message-ID: <F7.15.03062.2D8E20C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTim0Du0TYrTOQNajPG6IsDnj4aCvjZ3UJtZnweGW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim0Du0TYrTOQNajPG6IsDnj4aCvjZ3UJtZnweGW@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of CoolCold
> Sent: Sunday, May 30, 2010 8:18 AM
> To: Leslie Rhorer
> Cc: Kyler Laird; linux-raid@vger.kernel.org
> Subject: Re: recovering from a controller failure
>=20
> On Sun, May 30, 2010 at 7:33 AM, Leslie Rhorer <lrhorer@satx.rr.com>
> wrote:
> >> On Sun, May 30, 2010 at 09:50:26AM +1200, Richard wrote:
> >>
> >> > How about adding entries to your mdadm.conf file containing the =
UUID
> >> > of /dev/md0, eg:
> >> >
> >> > ARRAY /dev/md8 level=3Draid6 num-devices=3D16
> >> > UUID=3D38a06a50:ce3fc204:728edfb7:4f4cdd43
> >> >
> >> > note this should be all one line.
> >>
> >> I'll be happy to do that.
> >>
> >> > mdadm -D /dev/md0 should get you the UUID.
> >>
> >> =A0 =A0 =A0 root@00144ff2a334:/# mdadm -D /dev/md0
> >> =A0 =A0 =A0 mdadm: md device /dev/md0 does not appear to be active=
=2E
> >>
> >> So...how do I get the UUIDs? =A0I tried blkid and got this.
> >> =A0 =A0 =A0 http://lairds.us/temp/ucmeng_md/uuids
> >> Those UUIDs are far from unique.
> >
> > =A0 =A0 =A0 =A0After all your drives are visible, of course:
> >
> > `mdadm --examine /dev/sd* /dev/hd* > <filename>`
> > `more <filename>`
> >
> > Make note of the array UUID for each drive. =A0When done,
> >
> > `mdadm --assemble --assume-clean /dev/mdX /dev/<drive0> /dev/<drive=
1>
> > /dev/<drive2> ...etc`
> >
> > where <drive0>, <drive1>, etc are all members of the same array UUI=
D.
> >
> > =A0 =A0 =A0 =A0Mount the file system, and fsck it. =A0Once everythi=
ng is verified
> > good,
> >
> > `echo repair > /sys/block/mdX/md/sync_action`
> Taking in account "Events" fields are differing on disks from 1st &
> 2nd controller, interesting question for me - what will happen on thi=
s
> "repair" ?

	Note that should be --force, not --assume-clean.  The --assume-clean
switch would be used if you re-created the array, not just re-assembled=
 it.
Once the array is assembled, the repair function will re-establish the
redundancy within the array.  Any stripes whose data does not match the
calculated value required to produce the upper layer information are
re-written.

> And what this "Events" field really means? I didn't found description
> in man pages.

	I believe a number of things.  For one thing, it is used to keep
track of which version of data resides in each drive, whenever an array
event is encountered.  The value of the events counter in the members o=
f an
array should not be different by more than 1, or mdadm kicks the drive =
out
of the array.  I expect it may also be used during forced re-assembly a=
nd /
or during a resync of a RAID1 system to help determine which version of=
 a
stripe is correct.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
