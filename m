From: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Subject: Re: Converting ext3 to RAID1 ...
Date: Wed, 2 Sep 2009 20:10:01 +0200
Message-ID: <b7b14cbb0909021110t5f38a12by16be5ca604c50b40@mail.gmail.com>
References: <b7b14cbb0908241424i50bdcf59p35a63e4496b108ca@mail.gmail.com>
	 <4A9E9CDE.1040308@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A9E9CDE.1040308@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings ...

2009/9/2 Bill Davidsen <davidsen@tmr.com>:
> Clinton Lee Taylor wrote:
>> http://www.issociate.de/board/post/498227/Ext3_convert_to_RAID1_....=
html
>>
>> Wanting to convert an already created and populated ext3 filesystem.
>>
>> I unmounted the filesystem, ran e2fsck -f /dev/sdb1 to check that th=
e
>> current filesystem had no errors.
>> Then ran mdadm --create /dev/md0 --level=3D1 -n 1 /dev/sdb1 --force =
to
>> create the RAID1 device, answered yes to the question.
>>
>
> Right here is where you invite problems.
 This just a warning or have you had problems doing this?

> You want to create the array using
> the new device or partition, and put a new filesystem on it.
 No, I want to convert an existing ext3 to RAID1 partition ...

> Read and
> understand the man page for mke2fs in the stride=3D and stripe-width=3D
> parameters, it shouldn't matter for raid-1 but would if you use raid-=
[56].
 How would striding effect RAID growing or shrinking? Does not the
striding just effect performance or is it a big problem? Would a RAID
defragger help?

> Then mount the array, copy the data to the array, verify it, and then
> unmount the old partition and add it.
 I know this is a tried, tested and accept procedure to
transfer/transform an existing ext3 partition to a RAID partition, but
this takes allot of data coping and requires double extra storage ...
What I'm trying to get right, is to create and test a procedure ( with
audience help and peer review ), to convert an ext3 partition to a
RAID1, maybe later other RAID, but this is a first step/test ...

>> Ran e2fsck -v /dev/md0 to check that the RAID1 device had no
>> filesystem corruption on it, which it did not.
>> Added a spared RAID device using mdadm --add /dev/md0 /dev/sdc1
>> Then grew the RAID1 device to two compents with mdadm --grow /dev/md=
0
>> --raid-disks=3D2 --backup-file=3D/root/raid1.backup.file
>
> I have an entry in my raid notes which says that's the wrong thing to=
 do,
> the array should be created with the correct number of members and on=
e left
> "missing" to be added later. My note says it should be done that way,=
 but
> not why it's better, but it says "per Neil" so I bet there is a reaso=
n. It
> does seem to work that way, I just did an adventure in file moving to=
 test
> it the hard way. I was doing a mix of raid-1, raid-10, and raid-5 arr=
ays
> moving from little drives (750GB) to larger ones.
 Okay, but now we have a big question, creating RAID MD with less
devices than they should have should only be done with "missing" or
forced with number of devices?  Could the really Neil stand up now?
;-)

>> Did another filesystem check once the RAID finished rebuilding and a=
ll
>> seemed fine.
>> Double checked that the data on the RAID was the same as the origina=
l
>> data by diffing the two, again all was fine.
>>
>> =A0Now is this just lucky or would this be an acceptable way to conv=
ert
>> an existing ext3 filesystem to RAID1?
>
> See above, given the resize you didn't mention it's okay, but forget =
the
> resize and you risk your data.
 Okay, so, you saying that I should make sure that I shrink the ext3
before try and convert, which is what was comment on before ... I only
edited out what I thought was not needed for the basic question of
converting, but, when I write up an article covering this, I will be
sure to detail that and explain that md metadata version 0.90 puts
it's metadata at the end of the device, which should be free, after
the shrink ...

Thanks for all the input
Mailed
LeeT
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
