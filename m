From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: mdadm 3.1.1: level change won't start
Date: Tue, 22 Dec 2009 18:35:27 +0000
Message-ID: <73e903670912221035te413d76uc6b3bd9788f7ba5e@mail.gmail.com>
References: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
	<20091222095756.371c0ac4@notabene.brown> <73e903670912211518u69c26584y6c250e67f5ba06ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670912211518u69c26584y6c250e67f5ba06ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <nfbrown@novell.com>
List-Id: linux-raid.ids

On Mon, Dec 21, 2009 at 11:18 PM, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
> On Mon, Dec 21, 2009 at 10:57 PM, Neil Brown <neilb@suse.de> wrote:
>> On Mon, 21 Dec 2009 03:41:33 +0000
>> Kristleifur Da=F0ason <kristleifur@gmail.com> wrote:
>>
>>> Hi all,
>>>
>>> I wish to convert my 3-drive RAID-5 array to a 6-drive RAID-6. I'm =
on
>>> Linux 2.6.32.2 and have mdadm version 3.1.1 with the 32-bit-array-s=
ize
>>> patch from here: http://osdir.com/ml/linux-raid/2009-11/msg00534.ht=
ml
>>>
>>> I have three live drives and three spares added to the array. When =
I
>>> initialize the command, mdadm does the initial checks and aborts wi=
th
>>> a "cannot set device shape" without doing anything to the array.
>>>
>>> Following are some md stats and growth command output:
>>>
>>> ___
>>>
>>> $ cat /proc/mdstat
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
]
>>> [raid4] [raid10]
>>> md_d1 : active raid5 sdd1[6](S) sdc1[5](S) sdb1[4](S) sdf1[1] sde1[=
0] sdl1[3]
>>> =A0=A0=A0=A0=A0 2930078720 blocks super 1.1 level 5, 256k chunk, al=
gorithm 2 [3/3] [UUU]
>>> =A0=A0=A0=A0=A0 bitmap: 1/350 pages [4KB], 2048KB chunk
>>>
>>> $ mdadm --detail --scan
>>> ARRAY /dev/md/d1 metadata=3D1.01 spares=3D3 name=3Dmamma:d1
>>> UUID=3Dda547022:042a6f68:d5fe251e:5e89f263
>>>
>>> $ mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
>>> --backup-file=3D/root/backup.md1_to_r6
>>> mdadm: metadata format 1.10 unknown, ignored.
>>> mdadm: metadata format 1.10 unknown, ignored.
>>> mdadm level of /dev/md_d1 changed to raid6
>>> mdadm: Need to backup 1024K of critical section..
>>> mdadm: Cannot set device shape for /dev/md_d1
>>> mdadm: aborting level change
>>> ___
>>>
>>>
>>> Three questions -
>>>
>>> 1. What does the stuff about "metadata format 1.10 unknown" mean?
>>> Notice the "super 1.1" vs. "metadata 1.01" vs. "metadata format 1.1=
0"
>>> disrepancy between mdsat, --detail and --grow output.
>>
>> The metadata format .. unknown means that your /etc/mdadm.conf conta=
ins
>> something like
>> =A0 =A0 =A0 metadata=3D1.10
>>
>>>
>>> 2. Am I doing something wrong? :)
>>
>> Not obviously.
>>
>>>
>>> 3. How can I get more info about what is causing the failure to
>>> initialize the growth?
>>
>> Look in the kernel logs. =A0e.g.
>> =A0 dmesg | tail -20
>>
>> immediately after the "mdadm --grow" attempt.
>>
>> I just tried the same thing and it worked for me.
>>
>> NeilBrown
>>
>
> Thank you very much for the reply. You were right, mdadm.conf indeed
> contained metadata=3D1.10. I fixed it, updated the initramfs and
> rebooted.
>
> ---
>
> mdadm --detail --scan now gives:
>
> =A0sudo mdadm --detail --scan
> ARRAY /dev/md/d1 metadata=3D1.01 spares=3D3 name=3Dmamma:d1
> UUID=3Dda547022:042a6f68:d5fe251e:5e89f263
>
> ---
> =A0I tried the grow command again, and it aborts again. Could it be t=
hat
> the device sizes are wrong? I thought I meticulously created exactly
> identical partitions on each of the drives. The command output is:
>
> =A0sudo mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
> --backup-file=3D/root/backup.md1_to_r6
> mdadm level of /dev/md_d1 changed to raid6
> mdadm: Need to backup 1024K of critical section..
> mdadm: Cannot set device shape for /dev/md_d1
> mdadm: aborting level change
>
> ---

I figured it out - I just needed to disable the write-intent bitmap by
doing "mdadm --grow --bitmap=3Dnone /dev/md_d1". Then the reshape was
startable and is going quite well.

I'm seeing resync speeds of around 30-40 MB/second during the
reshape/relevel. I'm running on 1.5TB SATA drives. Is this speed OK?

Thanks everybody for the help and suggestions!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
