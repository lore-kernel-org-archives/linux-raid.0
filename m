From: "Majed B." <majedb@gmail.com>
Subject: Re: I am an idiot.
Date: Thu, 4 Mar 2010 15:25:42 +0300
Message-ID: <70ed7c3e1003040425k7051a253va4f88e9e9c7af127@mail.gmail.com>
References: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
	<4B8FA12E.9000606@anonymous.org.uk> <68c4f7e31003040422u60b75b89id2042a34643424fa@mail.gmail.com>
	<68c4f7e31003040423x570bb7c8oef8b837009082e2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c4f7e31003040423x570bb7c8oef8b837009082e2c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Boag-Munroe <boagenator@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Though I may not be able to help, but I'm sure you'd get much better
support & help if you choose a proper subject summarizing the problem.

If possible, I suggest you clone each disk to another disk before
proceeding just in case something goes further wrong.

Maybe the array you recreated was with the wrong chunksize of 512
instead of your desired 256?

On Thu, Mar 4, 2010 at 3:23 PM, Alex Boag-Munroe <boagenator@gmail.com>=
 wrote:
> On 4 March 2010 12:22, Alex Boag-Munroe <boagenator@gmail.com> wrote:
>> On 4 March 2010 12:01, John Robinson <john.robinson@anonymous.org.uk=
> wrote:
>>> On 04/03/2010 11:30, Alex Boag-Munroe wrote:
>>>>
>>>> Hi guys...
>>>>
>>>> Yes I am an idiot. =C2=A0I was changing the chunk size of my RAID5=
 array
>>>> last night from 64kb to 256kb and left it running overnight. =C2=A0=
During
>>>> the night we had a power outage.
>>>>
>>>> This is where the idiot part comes in. =C2=A0The backup file is on=
 a
>>>> filesystem that's part of the RAID5 array, so obviously I am unabl=
e to
>>>> start it. =C2=A0I completely forgot the filesystem I specified for
>>>> --backup-file was part of the same array.
>>>>
>>>> Once you're all done pointing and laughing, can you let me know if=
 I
>>>> am totally screwed? =C2=A0I've a lot of data here that I -really- =
don't
>>>> want to lose...
>>>>
>>>> Please help..
>>>>
>>>> Idiot.
>>>>
>>>> --
>>>> Alex Boag-Munroe
>>>>
>>>> Lack of planning on your part does not constitute an emergency on =
mine.
>>>
>>> OK, I was done pointing and laughing, until I saw your signature. D=
id you
>>> choose that on purpose or did Gmail pick it for you?
>>>
>>> I'm afraid I can't help with your problem, except to say that I've =
a feeling
>>> you ought to be able to manually restart the half-reshaped array wi=
thout the
>>> backup file, so the worst case ought to be that you might lose one =
backup
>>> file's worth of data. However, kernel and mdadm versions together w=
ith
>>> output of `mdadm --detail` of your md device and `mdadm --examine` =
of its
>>> constituent devices will help those more knowledgeable than me tell=
 you what
>>> to do next. If you're lucky the boss, Neil Brown, will help but I i=
magine
>>> he's asleep right now since he lives in Australia and it's the midd=
le of the
>>> night there.
>>>
>>> Best of luck,
>>>
>>> John.
>>>
>>
>> Hi John, thanks so much for your reply.
>>
>> That is my signature and I stand by it, hence the whole "me idiot" a=
nd
>> not DEMANDING I get help etc.
>>
>> mdadm is version 3.1.1. =C2=A0New developments. =C2=A0I found a post=
 on the
>> internet where Neil recommended to someone to recreate the array
>> without erasing it. =C2=A0Which I have done, mdadm starts the array =
and
>> mdadm -D shows that almost a terabyte of space is in use.
>>
>> However, mdadm -D also shows a chunk size of 512k, which is neither
>> the 64k original chunk nor the 512k I asked for.
>>
>> Kernel version is gentoo-sources-2.6.33.
>>
>> Output of mdadm --examine for /dev/sda5 through /dev/sdd5:
>>
>> /dev/sda5:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90.00
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 17862986:014cb4c0:ffe6e849=
:786ed339 (local to host ncc-1701-e)
>> =C2=A0Creation Time : Thu Mar =C2=A04 13:10:24 2010
>> =C2=A0 =C2=A0 Raid Level : raid5
>> =C2=A0Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
>> =C2=A0 =C2=A0 Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
>> =C2=A0 Raid Devices : 4
>> =C2=A0Total Devices : 4
>> Preferred Minor : 1
>>
>> =C2=A0 =C2=A0Update Time : Thu Mar =C2=A04 13:10:29 2010
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>> =C2=A0Active Devices : 4
>> Working Devices : 4
>> =C2=A0Failed Devices : 0
>> =C2=A0Spare Devices : 0
>> =C2=A0 =C2=A0 =C2=A0 Checksum : b951290 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 3
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>> =C2=A0 =C2=A0 Chunk Size : 512K
>>
>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevi=
ce State
>> this =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=
=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda5
>>
>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda5
>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 21 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdb5
>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 37 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc5
>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 53 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd5
>> /dev/sdb5:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90.00
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 17862986:014cb4c0:ffe6e849=
:786ed339 (local to host ncc-1701-e)
>> =C2=A0Creation Time : Thu Mar =C2=A04 13:10:24 2010
>> =C2=A0 =C2=A0 Raid Level : raid5
>> =C2=A0Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
>> =C2=A0 =C2=A0 Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
>> =C2=A0 Raid Devices : 4
>> =C2=A0Total Devices : 4
>> Preferred Minor : 1
>>
>> =C2=A0 =C2=A0Update Time : Thu Mar =C2=A04 13:10:29 2010
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>> =C2=A0Active Devices : 4
>> Working Devices : 4
>> =C2=A0Failed Devices : 0
>> =C2=A0Spare Devices : 0
>> =C2=A0 =C2=A0 =C2=A0 Checksum : b9512a2 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 3
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>> =C2=A0 =C2=A0 Chunk Size : 512K
>>
>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevi=
ce State
>> this =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 21 =
=C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /de=
v/sdb5
>>
>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda5
>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 21 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdb5
>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 37 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc5
>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 53 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd5
>> /dev/sdc5:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90.00
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 17862986:014cb4c0:ffe6e849=
:786ed339 (local to host ncc-1701-e)
>> =C2=A0Creation Time : Thu Mar =C2=A04 13:10:24 2010
>> =C2=A0 =C2=A0 Raid Level : raid5
>> =C2=A0Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
>> =C2=A0 =C2=A0 Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
>> =C2=A0 Raid Devices : 4
>> =C2=A0Total Devices : 4
>> Preferred Minor : 1
>>
>> =C2=A0 =C2=A0Update Time : Thu Mar =C2=A04 13:10:29 2010
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>> =C2=A0Active Devices : 4
>> Working Devices : 4
>> =C2=A0Failed Devices : 0
>> =C2=A0Spare Devices : 0
>> =C2=A0 =C2=A0 =C2=A0 Checksum : b9512b4 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 3
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>> =C2=A0 =C2=A0 Chunk Size : 512K
>>
>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevi=
ce State
>> this =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 37 =
=C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /de=
v/sdc5
>>
>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda5
>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 21 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdb5
>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 37 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc5
>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 53 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd5
>> /dev/sdd5:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90.00
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 17862986:014cb4c0:ffe6e849=
:786ed339 (local to host ncc-1701-e)
>> =C2=A0Creation Time : Thu Mar =C2=A04 13:10:24 2010
>> =C2=A0 =C2=A0 Raid Level : raid5
>> =C2=A0Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
>> =C2=A0 =C2=A0 Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
>> =C2=A0 Raid Devices : 4
>> =C2=A0Total Devices : 4
>> Preferred Minor : 1
>>
>> =C2=A0 =C2=A0Update Time : Thu Mar =C2=A04 13:10:29 2010
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>> =C2=A0Active Devices : 4
>> Working Devices : 4
>> =C2=A0Failed Devices : 0
>> =C2=A0Spare Devices : 0
>> =C2=A0 =C2=A0 =C2=A0 Checksum : b9512c6 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 3
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>> =C2=A0 =C2=A0 Chunk Size : 512K
>>
>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevi=
ce State
>> this =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 53 =
=C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /de=
v/sdd5
>>
>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda5
>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 21 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdb5
>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 37 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc5
>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 53 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd5
>>
>> Booting with autodetecting raid, states that there's no valid 0.9 su=
perblock.
>>
>> --
>> Alex Boag-Munroe
>>
>> Lack of planning on your part does not constitute an emergency on mi=
ne.
>>
>
> Oops. Where I said "it isn't the 512k chunk I asked for" I meant 256k=
 chunk.
>
> Thanks again
>
> --
> Alex Boag-Munroe
>
> Lack of planning on your part does not constitute an emergency on min=
e.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
