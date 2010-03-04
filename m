From: Alex Boag-Munroe <boagenator@gmail.com>
Subject: Re: I am an idiot.
Date: Thu, 4 Mar 2010 12:23:57 +0000
Message-ID: <68c4f7e31003040423x570bb7c8oef8b837009082e2c@mail.gmail.com>
References: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
	 <4B8FA12E.9000606@anonymous.org.uk>
	 <68c4f7e31003040422u60b75b89id2042a34643424fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c4f7e31003040422u60b75b89id2042a34643424fa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4 March 2010 12:22, Alex Boag-Munroe <boagenator@gmail.com> wrote:
> On 4 March 2010 12:01, John Robinson <john.robinson@anonymous.org.uk>=
 wrote:
>> On 04/03/2010 11:30, Alex Boag-Munroe wrote:
>>>
>>> Hi guys...
>>>
>>> Yes I am an idiot. =A0I was changing the chunk size of my RAID5 arr=
ay
>>> last night from 64kb to 256kb and left it running overnight. =A0Dur=
ing
>>> the night we had a power outage.
>>>
>>> This is where the idiot part comes in. =A0The backup file is on a
>>> filesystem that's part of the RAID5 array, so obviously I am unable=
 to
>>> start it. =A0I completely forgot the filesystem I specified for
>>> --backup-file was part of the same array.
>>>
>>> Once you're all done pointing and laughing, can you let me know if =
I
>>> am totally screwed? =A0I've a lot of data here that I -really- don'=
t
>>> want to lose...
>>>
>>> Please help..
>>>
>>> Idiot.
>>>
>>> --
>>> Alex Boag-Munroe
>>>
>>> Lack of planning on your part does not constitute an emergency on m=
ine.
>>
>> OK, I was done pointing and laughing, until I saw your signature. Di=
d you
>> choose that on purpose or did Gmail pick it for you?
>>
>> I'm afraid I can't help with your problem, except to say that I've a=
 feeling
>> you ought to be able to manually restart the half-reshaped array wit=
hout the
>> backup file, so the worst case ought to be that you might lose one b=
ackup
>> file's worth of data. However, kernel and mdadm versions together wi=
th
>> output of `mdadm --detail` of your md device and `mdadm --examine` o=
f its
>> constituent devices will help those more knowledgeable than me tell =
you what
>> to do next. If you're lucky the boss, Neil Brown, will help but I im=
agine
>> he's asleep right now since he lives in Australia and it's the middl=
e of the
>> night there.
>>
>> Best of luck,
>>
>> John.
>>
>
> Hi John, thanks so much for your reply.
>
> That is my signature and I stand by it, hence the whole "me idiot" an=
d
> not DEMANDING I get help etc.
>
> mdadm is version 3.1.1. =A0New developments. =A0I found a post on the
> internet where Neil recommended to someone to recreate the array
> without erasing it. =A0Which I have done, mdadm starts the array and
> mdadm -D shows that almost a terabyte of space is in use.
>
> However, mdadm -D also shows a chunk size of 512k, which is neither
> the 64k original chunk nor the 512k I asked for.
>
> Kernel version is gentoo-sources-2.6.33.
>
> Output of mdadm --examine for /dev/sda5 through /dev/sdd5:
>
> /dev/sda5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : 17862986:014cb4c0:ffe6e849:786ed339 (local=
 to host ncc-1701-e)
> =A0Creation Time : Thu Mar =A04 13:10:24 2010
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
> =A0 =A0 Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 4
> Preferred Minor : 1
>
> =A0 =A0Update Time : Thu Mar =A04 13:10:29 2010
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 4
> =A0Failed Devices : 0
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : b951290 - correct
> =A0 =A0 =A0 =A0 Events : 3
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda5
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda5
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 21 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdb5
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 37 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc5
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 53 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd5
> /dev/sdb5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : 17862986:014cb4c0:ffe6e849:786ed339 (local=
 to host ncc-1701-e)
> =A0Creation Time : Thu Mar =A04 13:10:24 2010
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
> =A0 =A0 Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 4
> Preferred Minor : 1
>
> =A0 =A0Update Time : Thu Mar =A04 13:10:29 2010
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 4
> =A0Failed Devices : 0
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : b9512a2 - correct
> =A0 =A0 =A0 =A0 Events : 3
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 21 =A0 =A0 =A0 =A01 =A0 =A0 =
=A0active sync =A0 /dev/sdb5
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda5
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 21 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdb5
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 37 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc5
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 53 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd5
> /dev/sdc5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : 17862986:014cb4c0:ffe6e849:786ed339 (local=
 to host ncc-1701-e)
> =A0Creation Time : Thu Mar =A04 13:10:24 2010
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
> =A0 =A0 Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 4
> Preferred Minor : 1
>
> =A0 =A0Update Time : Thu Mar =A04 13:10:29 2010
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 4
> =A0Failed Devices : 0
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : b9512b4 - correct
> =A0 =A0 =A0 =A0 Events : 3
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 37 =A0 =A0 =A0 =A02 =A0 =A0 =
=A0active sync =A0 /dev/sdc5
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda5
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 21 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdb5
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 37 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc5
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 53 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd5
> /dev/sdd5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : 17862986:014cb4c0:ffe6e849:786ed339 (local=
 to host ncc-1701-e)
> =A0Creation Time : Thu Mar =A04 13:10:24 2010
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
> =A0 =A0 Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 4
> Preferred Minor : 1
>
> =A0 =A0Update Time : Thu Mar =A04 13:10:29 2010
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 4
> =A0Failed Devices : 0
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : b9512c6 - correct
> =A0 =A0 =A0 =A0 Events : 3
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 53 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0active sync =A0 /dev/sdd5
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda5
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 21 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdb5
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 37 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc5
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 53 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd5
>
> Booting with autodetecting raid, states that there's no valid 0.9 sup=
erblock.
>
> --
> Alex Boag-Munroe
>
> Lack of planning on your part does not constitute an emergency on min=
e.
>

Oops. Where I said "it isn't the 512k chunk I asked for" I meant 256k c=
hunk.

Thanks again

--=20
Alex Boag-Munroe

Lack of planning on your part does not constitute an emergency on mine.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
