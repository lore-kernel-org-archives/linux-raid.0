From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: Accidental grow before add
Date: Sun, 26 Sep 2010 05:54:39 -0400
Message-ID: <AANLkTimPPD6TfoX7GVbaNgQo1CPpjc7LLG-nWDz7=En=@mail.gmail.com>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
	<AANLkTi=3MEirXZs_Qv7nO7fvAKxvErnkvAiEe8fdxQA=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=3MEirXZs_Qv7nO7fvAKxvErnkvAiEe8fdxQA=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> I think I may have mucked up my array, but I'm hoping somebody can
>> give me a tip to retrieve the situation.
>>
>> I had just added a new disk to my system and partitioned it in
>> preparation for adding it to my RAID 6 array, growing it from 7
>> devices to 8. However, I jumped the gun (guess I'm more tired than I
>> thought) and ran the grow command before I added the new disk to the
>> array as a spare.
>>
>> In other words, I should have run:
>>
>> mdadm --add /dev/md0 /dev/md3p1
>> mdadm --grow /dev/md0 --raid-devices=3D8 --backup-file=3D/grow_md0.b=
ak
>>
>> but instead I just ran
>>
>> mdadm --grow /dev/md0 --raid-devices=3D8 --backup-file=3D/grow_md0.b=
ak
>>
>> I immediately checked /proc/mdstat and got the following output:
>>
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [r=
aid4]
>> md0 : active raid6 sdk1[0] md2p1[7] sde1[6] sdf1[5] md1p1[4] sdl1[3]=
 sdj1[1]
>> =A0 =A0 =A07324227840 blocks super 1.2 level 6, 256k chunk, algorith=
m 2
>> [8/7] [UUUUUUU_]
>> =A0 =A0 =A0[>....................] =A0reshape =3D =A00.0% (79600/146=
4845568)
>> finish=3D3066.3min speed=3D7960K/sec
>>
>> md3 : active raid0 sdb1[0] sdh1[1]
>> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>>
>> md2 : active raid0 sdc1[0] sdd1[1]
>> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>>
>> md1 : active raid0 sdi1[0] sdm1[1]
>> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>>
>> unused devices: <none>
>>
>> At this point I figured I was probably ok. It looked like it was
>> restructuring the array to expect 8 disks, and with only 7 it would
>> just end up being in a degraded state. So I figured I'd just cost
>> myself some time - one reshape to get to the degraded 8 disk state,
>> and another reshape to activate the new disk instead of just the one
>> reshape onto the new disk. I went ahead and added the new disk as a
>> spare, figuring the current reshape operation would ignore it until =
it
>> completed, and then the system would notice it was degraded with a
>> spare available and rebuild it.
>>
>> However, things have slowed to a crawl (relative to the time it
>> normally takes to regrow this array) so I'm afraid something has gon=
e
>> wrong. As you can see in the initial mdstat above, it started at
>> 7960K/sec - quite fast for a reshape on this array. But just a coupl=
e
>> minutes after that it had dropped down to only 667K. It worked its w=
ay
>> back up through 1801K to 10277K, which is about average for a reshap=
e
>> on this array. Not sure how long it stayed at that level, but now
>> (still only 10 or 15 minutes after the original mistake) it's plunge=
d
>> all the way down to 40K/s. It's been down at this level for several
>> minutes and still dropping slowly. This doesn't strike me as a good
>> sign for the health of the unusual regrow operation.
>>
>> Anybody have a theory on what could be causing the slowness? Does it
>> seem like a reasonable consequence to growing an array without a spa=
re
>> attached? I'm hoping that this particular growing mistake isn't
>> automatically fatal or mdadm would have warned me or asked for a
>> confirmation or something. Worst case scenario I'm hoping the array
>> survives even if I just have to live with this speed and wait for it
>> to finish - although at the current rate that would take over a
>> year... Dare I mount the array's partition to check on the contents,
>> or would that risk messing it up worse?
>>
>> Here's the latest /proc/mdstat:
>>
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [r=
aid4]
>> md0 : active raid6 md3p1[8](S) sdk1[0] md2p1[7] sde1[6] sdf1[5]
>> md1p1[4] sdl1[3] sdj1[1]
>> =A0 =A0 =A07324227840 blocks super 1.2 level 6, 256k chunk, algorith=
m 2
>> [8/7] [UUUUUUU_]
>> =A0 =A0 =A0[>....................] =A0reshape =3D =A00.1% (1862640/1=
464845568)
>> finish=3D628568.8min speed=3D38K/sec
>>
>> md3 : active raid0 sdb1[0] sdh1[1]
>> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>>
>> md2 : active raid0 sdc1[0] sdd1[1]
>> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>>
>> md1 : active raid0 sdi1[0] sdm1[1]
>> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>>
>> unused devices: <none>
>>
>> Mike
>>
>
> And now the speed has picked back up to the normal rate (for now), bu=
t
> for some reason it has marked one of the existing drives as failed.
> Especially weird since that "drive" is one of my RAID 0s, and its
> component disks look fine. Since I was already "missing" the drive I
> forgot to add, that leaves me with no more room for failures. I have
> no idea why mdadm has decided this other drive failed (the timing is
> awfully coincidental) but if whatever it is happens again I'm really
> in trouble. Here's the latest mdstat:
>
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md0 : active raid6 md3p1[8](S) sdk1[0] md2p1[7](F) sde1[6] sdf1[5]
> md1p1[4] sdl1[3] sdj1[1]
> =A0 =A0 =A07324227840 blocks super 1.2 level 6, 256k chunk, algorithm=
 2
> [8/6] [UUUUUU__]
> =A0 =A0 =A0[>....................] =A0reshape =3D =A03.1% (45582368/1=
464845568)
> finish=3D2251.5min speed=3D10505K/sec
>
> md3 : active raid0 sdb1[0] sdh1[1]
> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>
> md2 : active raid0 sdc1[0] sdd1[1]
> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>
> md1 : active raid0 sdi1[0] sdm1[1]
> =A0 =A0 =A01465141760 blocks super 1.2 128k chunks
>
> unused devices: <none>
>
> Mike
>

I've stopped /dev/md0 with "mdadm --stop /dev/md0" because I'm just
too worried about what might happen to the array if another component
mysteriously fails.

Most pressing question: if md2 reports all component drives healthy
and correct in mdstat, then why would md2's md2p1 partition suddenly
show up as a failed component of md0 (since it's obvious the
underlying hardware is ok)? And does a drive "failing" during a
reshape corrupt the reshape (in which case irreparable damage has
already been done)?

Assuming that my array isn't already destroyed, and assuming that this
mysterious failure without any hard drives failing doesn't crop up
again, is there any way to force the array to immediately start
incorporating spares introduced after the reshape began (both the new
drive and now the one that "failed")? Because right now I'm in the
position of needing to complete a multi-day reshape operation with no
safety net at all and that scares the hell out of me.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
