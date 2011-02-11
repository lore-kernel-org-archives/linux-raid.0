From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 array won't start
Date: Sat, 12 Feb 2011 08:32:24 +1100
Message-ID: <20110212083224.6b1c2cee@notabene.brown>
References: <AANLkTimLfJHc2waPkvjUXn=mewc37qkCd-r0GG4k=e-D@mail.gmail.com>
	<AANLkTi=dtMbuszU3x_hGduN-y5ATbgD0tgby_2mj4YsH@mail.gmail.com>
	<20110212074904.41e113ed@notabene.brown>
	<AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian <cjs703@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Feb 2011 16:13:53 -0500 Christian <cjs703@gmail.com> wrote:

> On Fri, Feb 11, 2011 at 3:49 PM, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 11 Feb 2011 11:48:41 -0500 Christian <cjs703@gmail.com> wro=
te:
> >
> >> Hello,
> >>
> >> I have a 10 disk RAID6 array.=A0 I had an issue with a molex conne=
ctor
> >> that caused drives to drop from a 5in3 SATA backplane.=A0 There wa=
sn't
> >> any activity occurring on the array during the time, so I think th=
e
> >> filesystem should be in tact.=A0 The issue now is the event counts=
 are
> >> out of sync, along with the state of each drive.
> >>
> >> # mdadm -A /dev/md1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdk1 /dev/s=
dl1
> >> /dev/sdm1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1
> >> mdadm: /dev/md1 assembled from 8 drives - not enough to start the
> >> array while not clean - consider --force.
> >>
> >> # cat /proc/mdstat
> >> Personalities : [raid6] [raid5] [raid4]
> >> md1 : inactive sdt1[1](S) sde1[9](S) sdl1[8](S) sdg1[7](S) sdf1[6]=
(S)
> >> sdk1[5](S) sdq1[4](S) sds1[3](S) sdr1[2](S) sdm1[0](S)
> >> =A0=A0=A0=A0=A0 19535134720 blocks
> >>
> >>
> >> # mdadm -Af /dev/md1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdk1 /dev/=
sdl1
> >> /dev/sdm1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1
> >> mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
> >
> > The array is already in a partially-assembled state.
> >
> > mdadm -S /dev/md1
> >
> > before trying to assemble again with -f.
> >
> > NeilBrown
>=20
> I should have probably included it but I did stop the array with -S
> before running -Af.

True.

Ok, being sure that the array is stopped first, try the "-Af" command a=
gain,
but an a -v.
Then post the results together with any kernel messages (dmesg | tail -=
50
maybe)

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
