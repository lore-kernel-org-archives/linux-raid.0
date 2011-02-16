From: NeilBrown <neilb@suse.de>
Subject: Re: reshape failure
Date: Thu, 17 Feb 2011 08:06:34 +1100
Message-ID: <20110217080634.510b017e@notabene.brown>
References: <AANLkTikniCc3NNxgf9tW8Gb4qvUM-UfCJDazYC6Th1jZ@mail.gmail.com>
	<20110217073247.2dbc9299@notabene.brown>
	<AANLkTin__CDHu4qxAJe2NACXBFdE7EV1kuFOMoG7-P-h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin__CDHu4qxAJe2NACXBFdE7EV1kuFOMoG7-P-h@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias McNulty <tobias@caktusgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 15:41:46 -0500 Tobias McNulty <tobias@caktusgroup.c=
om>
wrote:

> On Wed, Feb 16, 2011 at 3:32 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 16 Feb 2011 10:46:32 -0500 Tobias McNulty <tobias@caktusgro=
up.com>
> >> nas:~# mdadm --assemble /dev/md0 --backup-file=3Dmd0.backup /dev/s=
dc
> >> /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh
> >> mdadm: Failed to restore critical section for reshape, sorry.
> >>
> >> Is my data lost for good? =A0Is there anything else I can do?
> >
> > Try above command with --verbose.
> > If a message about "too-old timestamp" appears, run
> >
> > =A0export MDADM_GROW_ALLOW_OLD=3D1
> >
> > and run the command again.
> >
> > In either case, post the output.
>=20
> Wow - it looks like that might have done the trick:
>=20
> nas:~# mdadm --verbose --assemble /dev/md0 --backup-file=3Dmd0.backup
> /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdh is identified as a member of /dev/md0, slot 4.
> mdadm:/dev/md0 has an active reshape - checking if critical section
> needs to be restored
> mdadm: too-old timestamp on backup-metadata on md0.backup
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
> nas:~# export MDADM_GROW_ALLOW_OLD=3D1
> nas:~# mdadm --verbose --assemble /dev/md0 --backup-file=3Dmd0.backup
> /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdh is identified as a member of /dev/md0, slot 4.
> mdadm:/dev/md0 has an active reshape - checking if critical section
> needs to be restored
> mdadm: accepting backup with timestamp 1297624561 for array with
> timestamp 1297692473
> mdadm: restoring critical section
> mdadm: added /dev/sde to /dev/md0 as 1
> mdadm: added /dev/sdd to /dev/md0 as 2
> mdadm: added /dev/sdc to /dev/md0 as 3
> mdadm: added /dev/sdh to /dev/md0 as 4
> mdadm: added /dev/sdg to /dev/md0 as 5
> mdadm: added /dev/sdf to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 5 drives and 1 spare.

That is what I expected..

>=20
> Now I see this in /etc/mdstat:
>=20
> md0 : active raid6 sdf[0] sdg[5](S) sdh[4] sdc[3] sdd[2] sde[1]
>       5860543488 blocks super 0.91 level 6, 64k chunk, algorithm 2 [5=
/5] [UUUUU]
>       [=3D>...................]  reshape =3D  9.9% (193691648/1953514=
496)
> finish=3D97156886.4min speed=3D0K/sec
>=20
> Is the 0K/sec something I need to worry about?

Maybe.  If the stays at 0K/sec and the 9.9% stays at 9.9%, then yes.  I=
t is
something to worry about.

Is there an 'mdadm' running in the background?  Can you 'strace' it for=
 a few
seconds?

What does
   grep . /sys/block/md0/md/*
show?   Maybe do it twice, 1 minute apart.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
