From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: mdadm 3.1.1: level change won't start
Date: Mon, 21 Dec 2009 23:18:55 +0000
Message-ID: <73e903670912211518u69c26584y6c250e67f5ba06ad@mail.gmail.com>
References: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
	<20091222095756.371c0ac4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222095756.371c0ac4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <nfbrown@novell.com>
List-Id: linux-raid.ids

On Mon, Dec 21, 2009 at 10:57 PM, Neil Brown <neilb@suse.de> wrote:
> On Mon, 21 Dec 2009 03:41:33 +0000
> Kristleifur Da=F0ason <kristleifur@gmail.com> wrote:
>
>> Hi all,
>>
>> I wish to convert my 3-drive RAID-5 array to a 6-drive RAID-6. I'm o=
n
>> Linux 2.6.32.2 and have mdadm version 3.1.1 with the 32-bit-array-si=
ze
>> patch from here: http://osdir.com/ml/linux-raid/2009-11/msg00534.htm=
l
>>
>> I have three live drives and three spares added to the array. When I
>> initialize the command, mdadm does the initial checks and aborts wit=
h
>> a "cannot set device shape" without doing anything to the array.
>>
>> Following are some md stats and growth command output:
>>
>> ___
>>
>> $ cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md_d1 : active raid5 sdd1[6](S) sdc1[5](S) sdb1[4](S) sdf1[1] sde1[0=
] sdl1[3]
>> =A0=A0=A0=A0=A0 2930078720 blocks super 1.1 level 5, 256k chunk, alg=
orithm 2 [3/3] [UUU]
>> =A0=A0=A0=A0=A0 bitmap: 1/350 pages [4KB], 2048KB chunk
>>
>> $ mdadm --detail --scan
>> ARRAY /dev/md/d1 metadata=3D1.01 spares=3D3 name=3Dmamma:d1
>> UUID=3Dda547022:042a6f68:d5fe251e:5e89f263
>>
>> $ mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
>> --backup-file=3D/root/backup.md1_to_r6
>> mdadm: metadata format 1.10 unknown, ignored.
>> mdadm: metadata format 1.10 unknown, ignored.
>> mdadm level of /dev/md_d1 changed to raid6
>> mdadm: Need to backup 1024K of critical section..
>> mdadm: Cannot set device shape for /dev/md_d1
>> mdadm: aborting level change
>> ___
>>
>>
>> Three questions -
>>
>> 1. What does the stuff about "metadata format 1.10 unknown" mean?
>> Notice the "super 1.1" vs. "metadata 1.01" vs. "metadata format 1.10=
"
>> disrepancy between mdsat, --detail and --grow output.
>
> The metadata format .. unknown means that your /etc/mdadm.conf contai=
ns
> something like
> =A0 =A0 =A0 metadata=3D1.10
>
>>
>> 2. Am I doing something wrong? :)
>
> Not obviously.
>
>>
>> 3. How can I get more info about what is causing the failure to
>> initialize the growth?
>
> Look in the kernel logs. =A0e.g.
> =A0 dmesg | tail -20
>
> immediately after the "mdadm --grow" attempt.
>
> I just tried the same thing and it worked for me.
>
> NeilBrown
>

Thank you very much for the reply. You were right, mdadm.conf indeed
contained metadata=3D1.10. I fixed it, updated the initramfs and
rebooted.

---

mdadm --detail --scan now gives:

 sudo mdadm --detail --scan
ARRAY /dev/md/d1 metadata=3D1.01 spares=3D3 name=3Dmamma:d1
UUID=3Dda547022:042a6f68:d5fe251e:5e89f263

---
 I tried the grow command again, and it aborts again. Could it be that
the device sizes are wrong? I thought I meticulously created exactly
identical partitions on each of the drives. The command output is:

 sudo mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
--backup-file=3D/root/backup.md1_to_r6
mdadm level of /dev/md_d1 changed to raid6
mdadm: Need to backup 1024K of critical section..
mdadm: Cannot set device shape for /dev/md_d1
mdadm: aborting level change

---

dmesg says:

[   96.482937] raid5: device sdl1 operational as raid disk 2
[   96.482940] raid5: device sdf1 operational as raid disk 1
[   96.482942] raid5: device sde1 operational as raid disk 0
[   96.483299] raid5: allocated 4282kB for md_d1
[   96.511577] 2: w=3D1 pa=3D0 pr=3D4 m=3D2 a=3D18 r=3D4 op1=3D0 op2=3D=
0
[   96.511581] 1: w=3D2 pa=3D0 pr=3D4 m=3D2 a=3D18 r=3D4 op1=3D0 op2=3D=
0
[   96.511583] 0: w=3D3 pa=3D0 pr=3D4 m=3D2 a=3D18 r=3D4 op1=3D0 op2=3D=
0
[   96.511585] raid5: raid level 6 set md_d1 active with 3 out of 4
devices, algorithm 18
[   96.511588] RAID5 conf printout:
[   96.511589]  --- rd:4 wd:3
[   96.511591]  disk 0, o:1, dev:sde1
[   96.511593]  disk 1, o:1, dev:sdf1
[   96.511595]  disk 2, o:1, dev:sdl1
[   96.671315] raid5: device sdl1 operational as raid disk 2
[   96.671318] raid5: device sdf1 operational as raid disk 1
[   96.671320] raid5: device sde1 operational as raid disk 0
[   96.671642] raid5: allocated 3230kB for md_d1
[   96.720331] 2: w=3D1 pa=3D0 pr=3D3 m=3D1 a=3D2 r=3D3 op1=3D0 op2=3D0
[   96.720334] 1: w=3D2 pa=3D0 pr=3D3 m=3D1 a=3D2 r=3D3 op1=3D0 op2=3D0
[   96.720336] 0: w=3D3 pa=3D0 pr=3D3 m=3D1 a=3D2 r=3D3 op1=3D0 op2=3D0
[   96.720338] raid5: raid level 5 set md_d1 active with 3 out of 3
devices, algorithm 2
[   96.720340] RAID5 conf printout:
[   96.720341]  --- rd:3 wd:3
[   96.720343]  disk 0, o:1, dev:sde1
[   96.720345]  disk 1, o:1, dev:sdf1
[   96.720346]  disk 2, o:1, dev:sdl1
[  100.202834] raid5: device sdl1 operational as raid disk 2
[  100.202837] raid5: device sdf1 operational as raid disk 1
[  100.202839] raid5: device sde1 operational as raid disk 0
[  100.203194] raid5: allocated 4282kB for md_d1
[  100.241576] 2: w=3D1 pa=3D0 pr=3D4 m=3D2 a=3D18 r=3D4 op1=3D0 op2=3D=
0
[  100.241579] 1: w=3D2 pa=3D0 pr=3D4 m=3D2 a=3D18 r=3D4 op1=3D0 op2=3D=
0
[  100.241582] 0: w=3D3 pa=3D0 pr=3D4 m=3D2 a=3D18 r=3D4 op1=3D0 op2=3D=
0
[  100.241584] raid5: raid level 6 set md_d1 active with 3 out of 4
devices, algorithm 18
[  100.241586] RAID5 conf printout:
[  100.241588]  --- rd:4 wd:3
[  100.241590]  disk 0, o:1, dev:sde1
[  100.241592]  disk 1, o:1, dev:sdf1
[  100.241593]  disk 2, o:1, dev:sdl1
[  100.401030] raid5: device sdl1 operational as raid disk 2
[  100.401033] raid5: device sdf1 operational as raid disk 1
[  100.401035] raid5: device sde1 operational as raid disk 0
[  100.401348] raid5: allocated 3230kB for md_d1
[  100.460458] 2: w=3D1 pa=3D0 pr=3D3 m=3D1 a=3D2 r=3D3 op1=3D0 op2=3D0
[  100.460461] 1: w=3D2 pa=3D0 pr=3D3 m=3D1 a=3D2 r=3D3 op1=3D0 op2=3D0
[  100.460463] 0: w=3D3 pa=3D0 pr=3D3 m=3D1 a=3D2 r=3D3 op1=3D0 op2=3D0
[  100.460466] raid5: raid level 5 set md_d1 active with 3 out of 3
devices, algorithm 2
[  100.460467] RAID5 conf printout:
[  100.460468]  --- rd:3 wd:3
[  100.460470]  disk 0, o:1, dev:sde1
[  100.460472]  disk 1, o:1, dev:sdf1
[  100.460474]  disk 2, o:1, dev:sdl1
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
