From: Mark Knecht <markknecht@gmail.com>
Subject: Re: High mismatch count on root device - how to best handle?
Date: Tue, 26 Apr 2011 10:22:56 -0700
Message-ID: <BANLkTinS9=v+qHAyewRu19HgGr4iriwjkw@mail.gmail.com>
References: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>
	<BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 25, 2011 at 6:30 PM, Mark Knecht <markknecht@gmail.com> wro=
te:
> On Mon, Apr 25, 2011 at 3:32 PM, Mark Knecht <markknecht@gmail.com> w=
rote:
>> I did a drive check today, first time in months, and found I have a
>> high mismatch count on my RAID1 root device. What's the best way to
>> handle getting this cleaned up?
>>
>> 1) I'm running some smartctl tests as I write this.
>>
>> 2) Do I just do an
>>
>> echo repair
>>
>> to md126 or do I have to boot a rescue CD before I do that?
>>
>> If you need more info please let me know.
>>
>> Thanks,
>> Mark
>>
>> c2stable ~ # cat /sys/block/md3/md/mismatch_cnt
>> 0
>> c2stable ~ # cat /sys/block/md6/md/mismatch_cnt
>> 0
>> c2stable ~ # cat /sys/block/md7/md/mismatch_cnt
>> 0
>> c2stable ~ # cat /sys/block/md126/md/mismatch_cnt
>> 222336
>> c2stable ~ # df
>> Filesystem =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1K-blocks =C2=A0 =C2=A0=
 =C2=A0Used Available Use% Mounted on
>> /dev/md126 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A051612920 =C2=A02=
6159408 =C2=A022831712 =C2=A054% /
>> udev =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 10240 =C2=A0 =C2=A0 =C2=A0 432 =C2=A0 =C2=A0 =C2=A09808 =C2=A0 5=
% /dev
>> /dev/md7 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 389183252 1449791=
84 224434676 =C2=A040% /VirtualMachines
>> shm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A06151452 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 6151452 =C2=A0 0% /dev/=
shm
>> c2stable ~ # cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [r=
aid4]
>> md6 : active raid1 sdc6[2] sda6[0] sdb6[1]
>> =C2=A0 =C2=A0 =C2=A0247416933 blocks super 1.1 [3/3] [UUU]
>>
>> md7 : active raid6 sdc7[2] sda7[0] sdb7[1] sdd2[3] sde2[4]
>> =C2=A0 =C2=A0 =C2=A0395387904 blocks super 1.2 level 6, 16k chunk, a=
lgorithm 2 [5/5] [UUUUU]
>>
>> md3 : active raid6 sdc3[2] sda3[0] sdb3[1] sdd3[3] sde3[4]
>> =C2=A0 =C2=A0 =C2=A0157305168 blocks super 1.2 level 6, 16k chunk, a=
lgorithm 2 [5/5] [UUUUU]
>>
>> md126 : active raid1 sdc5[2] sda5[0] sdb5[1]
>> =C2=A0 =C2=A0 =C2=A052436032 blocks [3/3] [UUU]
>>
>> unused devices: <none>
>> c2stable ~ #
>>
>
> The smartctl tests that I ran (long) completed without error on all 5
> drives in the system:
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining
> LifeTime(hours) =C2=A0LBA_of_first_error
> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A02887 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A02046 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>
>
> So, if I understand correctly the next step I'd do would be something=
 like
>
> echo repair >/sys/block/md126/md/sync_action
>
> but I'm unclear about the need to do this when mdadm seems to think
> the RAID is clean:
>
> c2stable ~ # mdadm -D /dev/md126
> /dev/md126:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90
> =C2=A0Creation Time : Tue Apr 13 09:02:34 2010
> =C2=A0 =C2=A0 Raid Level : raid1
> =C2=A0 =C2=A0 Array Size : 52436032 (50.01 GiB 53.69 GB)
> =C2=A0Used Dev Size : 52436032 (50.01 GiB 53.69 GB)
> =C2=A0 Raid Devices : 3
> =C2=A0Total Devices : 3
> Preferred Minor : 126
> =C2=A0 =C2=A0Persistence : Superblock is persistent
>
> =C2=A0 =C2=A0Update Time : Mon Apr 25 18:29:39 2011
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 3
> Working Devices : 3
> =C2=A0Failed Devices : 0
> =C2=A0Spare Devices : 0
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : edb0ed65:6e87b20e:dc0d88ba:=
780ef6a3
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 0.248880
>
> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=
=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda5
> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 21=
 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdb5
> =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 37=
 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc5
> c2stable ~ #
>
> Thanks in advance.
>
> Cheers,
> Mark
>

OK, I don't know exactly what I'm looking for a problem here. I ran
the repair, then rebooted. Mismatch count was zero. It seemed the
repair had worked.

I then used the system for about 4 hours. After 4 hours I did another
check and found the mismatch count had increased.

What I need to get a handle on is:

1) Is this serious? (I assume yes)

2) How do I figure out which drive(s) of the 3 is having trouble?

3) If there is a specific drive, what is the process to swap it out?

Thanks,
Mark


c2stable ~ # cat /sys/block/md126/md/mismatch_cnt
0
c2stable ~ # echo check >/sys/block/md126/md/sync_action
c2stable ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md6 : active raid1 sdb6[1] sdc6[2] sda6[0]
      247416933 blocks super 1.1 [3/3] [UUU]

md7 : active raid6 sdb7[1] sdc7[2] sde2[4] sda7[0] sdd2[3]
      395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] =
[UUUUU]

md3 : active raid6 sdb3[1] sdc3[2] sda3[0] sdd3[3] sde3[4]
      157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] =
[UUUUU]

md126 : active raid1 sdc5[2] sdb5[1] sda5[0]
      52436032 blocks [3/3] [UUU]
      [>....................]  check =3D  1.1% (626560/52436032)
finish=3D11.0min speed=3D78320K/sec

unused devices: <none>
c2stable ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md6 : active raid1 sdb6[1] sdc6[2] sda6[0]
      247416933 blocks super 1.1 [3/3] [UUU]

md7 : active raid6 sdb7[1] sdc7[2] sde2[4] sda7[0] sdd2[3]
      395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] =
[UUUUU]

md3 : active raid6 sdb3[1] sdc3[2] sda3[0] sdd3[3] sde3[4]
      157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] =
[UUUUU]

md126 : active raid1 sdc5[2] sdb5[1] sda5[0]
      52436032 blocks [3/3] [UUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.........]  check =3D 59.6% (3=
1291776/52436032)
finish=3D5.5min speed=3D63887K/sec

unused devices: <none>
c2stable ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md6 : active raid1 sdb6[1] sdc6[2] sda6[0]
      247416933 blocks super 1.1 [3/3] [UUU]

md7 : active raid6 sdb7[1] sdc7[2] sde2[4] sda7[0] sdd2[3]
      395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5]
[UUUUU]

md3 : active raid6 sdb3[1] sdc3[2] sda3[0] sdd3[3] sde3[4]
      157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5]
[UUUUU]

md126 : active raid1 sdc5[2] sdb5[1] sda5[0]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
c2stable ~ # cat /sys/block/md126/md/mismatch_cnt
7424
c2stable ~ #
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
