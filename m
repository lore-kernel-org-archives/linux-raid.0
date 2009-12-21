From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: mdadm 3.1.1: level change won't start
Date: Sun, 20 Dec 2009 23:25:42 -0800
Message-ID: <4877c76c0912202325w4f6ee05bqd8a9fbb82c6b9eb2@mail.gmail.com>
References: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
	 <4877c76c0912202010v4a4d6afdl97e3a1324c1b0569@mail.gmail.com>
	 <73e903670912202039y1a38df60qdbfbb8623c3f8856@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670912202039y1a38df60qdbfbb8623c3f8856@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Dec 20, 2009 at 8:39 PM, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
> On Mon, Dec 21, 2009 at 4:10 AM, Michael Evans <mjevans1983@gmail.com=
> wrote:
>> On Sun, Dec 20, 2009 at 7:41 PM, Kristleifur Da=F0ason
>> <kristleifur@gmail.com> wrote:
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
>>>
>>> 2. Am I doing something wrong? :)
>>>
>>> 3. How can I get more info about what is causing the failure to
>>> initialize the growth?
>>>
>>> Thanks!
>>>
>>> -- Kristleifur
>>>
>>>
>>> (P.s., I'm cc-ing this directly to Neil Brown as the maintainer of
>>> mdadm. I hope that isn't rude of me.)
>>> --
>>
>>
>> I thought there were three metadata variants for 1.x: 1.0 1.1 and 1.=
2
>> =A0Maybe the extra 1 or 0 at the end refers to a reshape in progress=
?
>>
>
> Thanks for the reply. FWIW, I intended the array to have metadata
> format 1.1 when I created it. I've noticed these "1.01" messages
> before, so I believe it's not due to the reshape. However, I'm
> thinking the funny metadata might be interfering with the reshape
> somehow.
>
> Hmm ...
>

This is odd; cat /proc/mdstat shows 1.0 and 1.1 for my metadata
formats; however using --detail --scan  I _DO_ see 1.00 and 1.01 on my
system.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
