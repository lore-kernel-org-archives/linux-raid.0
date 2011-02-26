From: NeilBrown <neilb@suse.de>
Subject: Re: OK, Now this is really weird
Date: Sun, 27 Feb 2011 08:34:33 +1100
Message-ID: <20110227083433.69b3d99a@notabene.brown>
References: <20110226003611.tjp3cxisu880co88-xnmenx@webmail.spamcop.net>
	<C2.5D.05134.F02E86D4@cdptpa-omtalb.mail.rr.com>
	<AANLkTim_cF9nnXMz2pJfewFqW68p1b0gKoKbtjRa6wqE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_cF9nnXMz2pJfewFqW68p1b0gKoKbtjRa6wqE@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>
Cc: lrhorer@satx.rr.com, Jeff Woods <jeff@jeffwoods.us>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 26 Feb 2011 11:35:11 +0000 Mathias Bur=E9n <mathias.buren@gmail=
=2Ecom>
wrote:

> On 26 February 2011 11:20, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> >> owner@vger.kernel.org] On Behalf Of Jeff Woods
> >> Sent: Saturday, February 26, 2011 1:36 AM
> >> To: lrhorer@satx.rr.com
> >> Cc: 'Linux RAID'
> >> Subject: Re: OK, Now this is really weird
> >>
> >> Quoting Leslie Rhorer <lrhorer@satx.rr.com>:
> >> > =A0 =A0 I have a pair of drives each of whose 3 partitions are m=
embers of a
> >> > set of 3 RAID arrays. =A0One of the two drives had a flaky power
> >> connection
> >> > which I thought I had fixed, but I guess not, because the drive =
was
> >> taken
> >> > offline again on Tuesday. =A0The significant issue, however, is =
that both
> >> > times the drive failed, mdadm behaved really oddly. =A0The first=
 time I
> >> > thought it might just be some odd anomaly, but the second time i=
t did
> >> > precisely the same thing. =A0Both times, when the drive was de-r=
egistered
> >> by
> >> > udev, the first two arrays properly responded to the failure, bu=
t the
> >> third
> >> > array did not. =A0Here is the layout:
> >>
> >> [snip lots of technical details]
> >>
> >> > =A0 =A0 So what gives? =A0/dev/sdk3 no longer even exists, so wh=
y hasn't it
> >> > been failed and removed on /dev /md3 like it has on /dev/md1 and
> >> /dev/md2?
> >>
> >> Is it possible there has been no I/O request for /dev/md3 since
> >> /dev/sdk failed?
> >
> > =A0 =A0 =A0 =A0Well, I thought about that. =A0It's swap space, so I=
 suppose it's
> > possible. =A0I would have thought, however, that mdadm would fail a=
 missing
> > member whether there is any I/O or not.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
> I thought so as well. But how will mdadm know is the device is faulty=
,
> unless the device is generating errors? (which usually only happens o=
n
> read and/or write)

With very recent mdadm the command

   mdadm -If sdXX

will find any md array that has /dev/sdXX as a member and will fail and
remove it.
Note the device name is 'sdxx', not '/dev/something'.  This is because =
that
at the time you want to do this, udev has probably removed all trace
from /dev so you need to use the name mentioned in /proc/mdstat
or /sys/block/mdXX/md/dev-$DEVNAME

You can set up a udev rule to run mdadm like this automatically when a =
device
is hot-unplugged.
something like

 SUBSYSTEM=3D=3D"block", ACTION=3D=3D"remove", RUN+=3D"/sbin/mdadm -If =
$name --path $env{ID_PATH}"

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
