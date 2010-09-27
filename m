From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Accidental grow before add
Date: Mon, 27 Sep 2010 01:11:19 -0700 (PDT)
Message-ID: <193703.58642.qm@web51305.mail.re2.yahoo.com>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Mike Hartman <mike@hartmanipulation.com>
List-Id: linux-raid.ids

--- On Sun, 26/9/10, Mike Hartman <mike@hartmanipulation.com> wrote:

> From: Mike Hartman <mike@hartmanipulation.com>
> Subject: Accidental grow before add
> To: linux-raid@vger.kernel.org
> Date: Sunday, 26 September, 2010, 8:27
> I think I may have mucked up my
> array, but I'm hoping somebody can
> give me a tip to retrieve the situation.
>=20
> I had just added a new disk to my system and partitioned it
> in
> preparation for adding it to my RAID 6 array, growing it
> from 7
> devices to 8. However, I jumped the gun (guess I'm more
> tired than I
> thought) and ran the grow command before I added the new
> disk to the
> array as a spare.
>=20
> In other words, I should have run:
>=20
> mdadm --add /dev/md0 /dev/md3p1
> mdadm --grow /dev/md0 --raid-devices=3D8
> --backup-file=3D/grow_md0.bak
>=20
> but instead I just ran
>=20
> mdadm --grow /dev/md0 --raid-devices=3D8
> --backup-file=3D/grow_md0.bak
>=20
> I immediately checked /proc/mdstat and got the following
> output:
>=20
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6]
> [raid5] [raid4]
> md0 : active raid6 sdk1[0] md2p1[7] sde1[6] sdf1[5]
> md1p1[4] sdl1[3] sdj1[1]
> =A0 =A0 =A0 7324227840 blocks super 1.2 level 6,
> 256k chunk, algorithm 2
> [8/7] [UUUUUUU_]
> =A0 =A0 =A0 [>....................]=A0
> reshape =3D=A0 0.0% (79600/1464845568)
> finish=3D3066.3min speed=3D7960K/sec
>=20
> md3 : active raid0 sdb1[0] sdh1[1]
> =A0 =A0 =A0 1465141760 blocks super 1.2 128k
> chunks
>=20
> md2 : active raid0 sdc1[0] sdd1[1]
> =A0 =A0 =A0 1465141760 blocks super 1.2 128k
> chunks
>=20
> md1 : active raid0 sdi1[0] sdm1[1]
> =A0 =A0 =A0 1465141760 blocks super 1.2 128k
> chunks
>=20
> unused devices: <none>
>=20
> At this point I figured I was probably ok. It looked like
> it was
> restructuring the array to expect 8 disks, and with only 7
> it would
> just end up being in a degraded state. So I figured I'd
> just cost
> myself some time - one reshape to get to the degraded 8
> disk state,
> and another reshape to activate the new disk instead of
> just the one
> reshape onto the new disk. I went ahead and added the new
> disk as a
> spare, figuring the current reshape operation would ignore
> it until it
> completed, and then the system would notice it was degraded
> with a
> spare available and rebuild it.
>=20
> However, things have slowed to a crawl (relative to the
> time it
> normally takes to regrow this array) so I'm afraid
> something has gone
> wrong. As you can see in the initial mdstat above, it
> started at
> 7960K/sec - quite fast for a reshape on this array. But
> just a couple
> minutes after that it had dropped down to only 667K. It
> worked its way
> back up through 1801K to 10277K, which is about average for
> a reshape
> on this array. Not sure how long it stayed at that level,
> but now
> (still only 10 or 15 minutes after the original mistake)
> it's plunged
> all the way down to 40K/s. It's been down at this level for
> several
> minutes and still dropping slowly. This doesn't strike me
> as a good
> sign for the health of the unusual regrow operation.
>=20
> Anybody have a theory on what could be causing the
> slowness? Does it
> seem like a reasonable consequence to growing an array
> without a spare
> attached? I'm hoping that this particular growing mistake
> isn't
> automatically fatal or mdadm would have warned me or asked
> for a
> confirmation or something. Worst case scenario I'm hoping
> the array
> survives even if I just have to live with this speed and
> wait for it
> to finish - although at the current rate that would take
> over a
> year... Dare I mount the array's partition to check on the
> contents,
> or would that risk messing it up worse?
>=20
> Here's the latest /proc/mdstat:
>=20
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6]
> [raid5] [raid4]
> md0 : active raid6 md3p1[8](S) sdk1[0] md2p1[7] sde1[6]
> sdf1[5]
> md1p1[4] sdl1[3] sdj1[1]
> =A0 =A0 =A0 7324227840 blocks super 1.2 level 6,
> 256k chunk, algorithm 2
> [8/7] [UUUUUUU_]
> =A0 =A0 =A0 [>....................]=A0
> reshape =3D=A0 0.1% (1862640/1464845568)
> finish=3D628568.8min speed=3D38K/sec
>=20
> md3 : active raid0 sdb1[0] sdh1[1]
> =A0 =A0 =A0 1465141760 blocks super 1.2 128k
> chunks
>=20
> md2 : active raid0 sdc1[0] sdd1[1]
> =A0 =A0 =A0 1465141760 blocks super 1.2 128k
> chunks
>=20
> md1 : active raid0 sdi1[0] sdm1[1]
> =A0 =A0 =A0 1465141760 blocks super 1.2 128k
> chunks
>=20
> unused devices: <none>
>=20
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

I am more interested to know why it kicked off a reshape that would lea=
ve the array in a degraded state without a warning and needing a '--for=
ce' are you sure there wasn't capacity to 'grow' anyway?

Also, when i first ran my reshape it was incredibly slow from Raid5~6 t=
ho.. it literally took days.


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
