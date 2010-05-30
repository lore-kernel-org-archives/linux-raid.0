From: "Keith ." <lukano@gmail.com>
Subject: Re: Shrink mdadm RAID5 from 6 disks to 5?
Date: Sun, 30 May 2010 16:54:48 -0600
Message-ID: <AANLkTilzFUQAEw7wuTjm2J1vx5CXVbcG9Ws-cVt2fefZ@mail.gmail.com>
References: <AANLkTimSxarJKmCxfOkJZJJULplm0z1pbVKyQpCG6nEw@mail.gmail.com>
	<20100521073433.75a59a99@notabene.brown>
	<AANLkTimn5ieodsVPsZY022b7VAnfFNARyb3sQn2LMp7u@mail.gmail.com>
	<20100521083241.43755d02@notabene.brown>
	<AANLkTikQcA98OzjFn93X8ChJanHMLTIdrvrIEMQAU4lA@mail.gmail.com>
	<AANLkTilJqmd9jwNSdlBxA4G07bB7RLB6XR0AwqFhe5uk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilJqmd9jwNSdlBxA4G07bB7RLB6XR0AwqFhe5uk@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

attaching my last two responses to the mailing list as I forgot to
include it on CC's.

On Sun, May 30, 2010 at 4:51 PM, Keith . <lukano@gmail.com> wrote:
> and for posterity, adding relevant syslog entries. =A0The capacity
> change noted towards the end may be the root of the problem, due to
> the steps I took to reach where I am - as mentioned in my previous
> email.
>
> [ 3132.556397] md: raid5 personality registered for level 5
> [ 3132.556399] md: raid4 personality registered for level 4
> [ 3132.556557] raid5: device sdc1 operational as raid disk 0
> [ 3132.556560] raid5: device sdd1 operational as raid disk 5
> [ 3132.556563] raid5: device sde1 operational as raid disk 4
> [ 3132.556566] raid5: device sdf1 operational as raid disk 2
> [ 3132.556568] raid5: device sdb1 operational as raid disk 1
> [ 3132.557254] raid5: allocated 6386kB for md127
> [ 3132.557301] 0: w=3D1 pa=3D0 pr=3D6 m=3D1 a=3D2 r=3D6 op1=3D0 op2=3D=
0
> [ 3132.557305] 5: w=3D2 pa=3D0 pr=3D6 m=3D1 a=3D2 r=3D6 op1=3D0 op2=3D=
0
> [ 3132.557308] 4: w=3D3 pa=3D0 pr=3D6 m=3D1 a=3D2 r=3D6 op1=3D0 op2=3D=
0
> [ 3132.557311] 2: w=3D4 pa=3D0 pr=3D6 m=3D1 a=3D2 r=3D6 op1=3D0 op2=3D=
0
> [ 3132.557315] 1: w=3D5 pa=3D0 pr=3D6 m=3D1 a=3D2 r=3D6 op1=3D0 op2=3D=
0
> [ 3132.557318] raid5: raid level 5 set md127 active with 5 out of 6
> devices, algorithm 2
> [ 3132.557321] RAID5 conf printout:
> [ 3132.557323] =A0--- rd:6 wd:5
> [ 3132.557326] =A0disk 0, o:1, dev:sdc1
> [ 3132.557328] =A0disk 1, o:1, dev:sdb1
> [ 3132.557331] =A0disk 2, o:1, dev:sdf1
> [ 3132.557333] =A0disk 4, o:1, dev:sde1
> [ 3132.557336] =A0disk 5, o:1, dev:sdd1
> [ 3132.557377] md127: detected capacity change from 0 to 750149599232=
0
> [ 3132.557590] =A0md127: unknown partition table
> [187074.092745] REISERFS (device dm-0): found reiserfs format "3.6"
> with standard journal
> [187074.092796] REISERFS (device dm-0): using ordered data mode
> [187074.120739] REISERFS (device dm-0): journal params: device dm-0,
> size 8192, journal first block 18, max trans len 1024, max batch 900,
> max commit age 30, max trans age 30
> [187074.121360] REISERFS (device dm-0): checking transaction log (dm-=
0)
> [187074.322428] REISERFS (device dm-0): Using r5 hash to sort names
> [360791.852592] md127: detected capacity change from 7501495992320 to
> 6001010237440
> [360829.233219] =A0md127: unknown partition table
>
>
> On Sun, May 30, 2010 at 4:46 PM, Keith . <lukano@gmail.com> wrote:
>> Sorry for the late followup on this.
>>
>> I am still struggling with the shrink, the following is not giving m=
e
>> any useable results for array-size suggestion from mdadm.
>>
>> mdadm -v --grow /dev/md127 --array-size=3D does not give me any erro=
r or
>> results, nor a syslog entry with the array-size value.
>>
>> I'm wondering if the complications I'm seeing are related to my
>> situation. =A0I'm going to reiterate it again, as I don't think I wa=
s
>> clear originally;
>>
>> - I had a 6 disk RAID6 array (1.5tb disks).
>> - One of the drive failed, and due to my poor luck with 1.5's - I
>> decided to 'shrink it from a degraded RAID6 array (running 5 of 6
>> disks) to a stable and undegraded RAID5.
>> - I was able to convert it from RAID6 to RAID5, and am now left with=
 a
>> degraded RAID5 array (6 disks, 5 active).
>> - The actual available space should not change, as in the end there =
4x
>> drives + the one parity for RAID5.
>>
>> Correct? =A0Am I complicating things somewhere, or forgetting some v=
ital logic?
>>
>> And as requested, /proc/mdstat is as follows;
>>
>> Personalities : [raid6] [raid5] [raid4]
>> md127 : active raid5 sdc1[0] sdd1[5] sde1[4] sdf1[2] sdb1[1]
>> 5860361560 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUU_UU]
>>
>> Thanks again for your help Neil.
>>
>> - Keith
>>
>>
>> On Thu, May 20, 2010 at 4:32 PM, Neil Brown <neilb@suse.de> wrote:
>>> On Thu, 20 May 2010 15:42:23 -0600
>>> "Keith ." <lukano@gmail.com> wrote:
>>>
>>>> Thanks for the quick reply Neil,
>>>>
>>>> I tried the suggested syntax, excluding the array-size in order to
>>>> have mdadm give me the value - but it did not. =A0I also tried gra=
bbing
>>>> the current array size from df, but I got an error about being una=
ble
>>>> to change array size in the same operation.
>>>>
>>>> So just to confirm I'm understanding you correctly ; =A0mdadm -G
>>>> /dev/md127 --raid-devices 5 --backup=3D/root/backup =A0- should ge=
nerate
>>>> an error that provides the array-size value?
>>>
>>> Yes.
>>> Actually, you do probably need to change the size first:
>>>
>>> =A0mdadm --grow /dev/md127 --array-size=3Dxxxxx
>>> then once you are sure you haven't lost you data, change the number=
 of
>>> devices.
>>>
>>> It might help if you ran the commands with "-v" and reported all th=
e
>>> messages generated, and any kernel log messages.
>>> And maybe
>>> =A0cat /proc/mdstat
>>>
>>> just to give us some more context..
>>> Maybe you have a write-intent-bitmap attached to the array. =A0You =
cannot
>>> reshape an array with one of those attached.
>>>
>>> NeilBron
>>>
>>>
>>>>
>>>> On Thu, May 20, 2010 at 3:34 PM, Neil Brown <neilb@suse.de> wrote:
>>>> > On Thu, 20 May 2010 07:45:23 -0600
>>>> > "Keith ." <lukano@gmail.com> wrote:
>>>> >
>>>> >> Does mdadm 3.1.x not support shrinking the number of disks in a=
 RAID5 array?
>>>> >>
>>>> >> I have successfully converted my 6x1.5tb RAID6 array to a 6x1.5=
tb
>>>> >> RAID5 array. =A0The issue that I now face is that one of those =
6 drives
>>>> >> is failed / removed, and as a result - the new RAID5 array is d=
own
>>>> >> it's parity drive.
>>>> >>
>>>> >> I knew I was short a disk when I started the process, but I was=
 under
>>>> >> the assumption that mdadm now supported shrinking of RAID5/6 ar=
rays.
>>>> >> Am I mistaken, or can anyone throw some suggestions at me so I =
can
>>>> >> give it a try?
>>>> >
>>>> > It should work.
>>>> >
>>>> > =A0mdadm -G /dev/mdX --raid-devices 5 --array-size=3DXXXXX
>>>> > =A0--backup=3D/root/backup-file
>>>> >
>>>> > If you don't give the 'array-size' value mdadm will tell you wha=
t it has to
>>>> > be. =A0You need to be sure that all your data is already within =
that space.
>>>> >
>>>> > NeilBrown
>>>> >
>>>
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
