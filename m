From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Problem Syncing raid1
Date: Thu, 3 Apr 2014 20:58:10 +0100
Message-ID: <CADNH=7F7ANnWNGR4bs-gCN95xW_G5MrTQO13Xy2m5AYp6LicMQ@mail.gmail.com>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
	<CADNH=7EwjLirv+zdUKu-Hsrw1djLNpPoz=WSg4pJwUc0giRzOw@mail.gmail.com>
	<BAY177-W961648C4893E888EECA18C86D0@phx.gbl>
	<CAK_KU4bh3S+rwMmJt4_8pyrOYbiLn83BHYabF79c4M59UoW1TA@mail.gmail.com>
	<BAY177-W35793297D3F640EF11F48C86D0@phx.gbl>
	<BAY177-W48FA7C4D5A92389BFC0667C86C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY177-W48FA7C4D5A92389BFC0667C86C0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Schmitz <schnet@hotmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3 April 2014 20:54, Christian Schmitz <schnet@hotmail.com> wrote:
> Well i do
> dd if=3Dserver.img of=3D/dev/sde2
> where sde is the new disk for server data.
> dd was aborted saying input/output error.
> at 750mb ( 0.7G of 550G of partition)
> So as you say i do
> smartctl -t long /dev/sde2
> It takes 150 minutes.
> After that i do:
> dd if=3Dserver.img of=3D/dev/sde2
> Is running since 6 hours so seem solved 750mb error.
>
> I am starting  the smartctl -t long to all hard disk jejejeje.
>
> Best regards
> Christian
>
> be free, be linux
>
>
> ----------------------------------------
>> From: schnet@hotmail.com
>> To: linux-raid@vger.kernel.org
>> Subject: RE: Problem Syncing raid1
>> Date: Wed, 2 Apr 2014 22:18:10 +0000
>>
>> Thanks, i will run smartctl as soon i finish recover the server data=
=2E
>>
>> Tomorrow i will give news.
>>
>> Best regards.
>> Christian
>>
>>
>> be free, be linux
>>
>>
>> ----------------------------------------
>>> Date: Wed, 2 Apr 2014 18:08:31 -0400
>>> Subject: Re: Problem Syncing raid1
>>> From: sdvileskis@gmail.com
>>> To: schnet@hotmail.com
>>> CC: mathias.buren@gmail.com; linux-raid@vger.kernel.org
>>>
>>> The good news is your realloc_sector_cnt is 0.
>>>
>>> However, run:
>>> smartctl -t long /dev/sda
>>> smartctl -t long /dev/sdb
>>>
>>> if you haven't done it in a while
>>> It will tell the controller on the disk to check all the sectors an=
d remap any.
>>>
>>> It will generally take several hours to complete, but if SMART dete=
cts
>>> any bad sectors it will attempt to remap them. (The OS and badblock=
s
>>> won't know the difference)
>>> You can run the smart test while the disk is online/mounted without
>>> problems, but the more you lay off the disks, the faster it will ru=
n.
>>>
>>> On Wed, Apr 2, 2014 at 5:56 PM, Christian Schmitz <schnet@hotmail.c=
om> wrote:
>>>> The system freeze, i suspect that is a bad sector because is allwa=
ys in the same point of syncing.
>>>>
>>>> I do a low level format and all test to SDB, so the problem is in =
SDA.
>>>>
>>>> Like a deja vu my server was exactly the same problem, now i am do=
ing the ddrescue to server disk and found badblock. This reforce the ba=
dblock intuition.
>>>>
>>>> #smartctl -a /dev/sda
>>>> SMART overall-health self-assessment test result: PASSED
>>>> ID# ATTRIBUTE_NAME FLAG VALUE WORST THRESH TYPE UPDATED WHEN_FAILE=
D RAW_VALUE
>>>> 1 Raw_Read_Error_Rate 0x002f 200 193 051 Pre-fail Always - 25
>>>> 3 Spin_Up_Time 0x0027 201 196 021 Pre-fail Always - 916
>>>> 4 Start_Stop_Count 0x0032 099 099 000 Old_age Always - 1032
>>>> 5 Reallocated_Sector_Ct 0x0033 200 200 140 Pre-fail Always - 0
>>>>
>>>> I think that badblock was caused in power failure, so is a logical=
 badblock and not phisical badblock. But to lowlevel format, and run th=
e manufacturer tools i need sync the raid to ship the data to SDB disk.
>>>>
>>>> =C2=BFHow i can use badblock in a raid device?
>>>> badblock /dev/md0?
>>>> badblock /dev/sda2?
>>>> The raid hangup if badblock does something?
>>>>
>>>> Thanks for your answer.
>>>> Christian
>>>> be free, be linux
>>>>
>>>>
>>>> ----------------------------------------
>>>>> Date: Wed, 2 Apr 2014 22:36:49 +0100
>>>>> Subject: Re: Problem Syncing raid1
>>>>> From: mathias.buren@gmail.com
>>>>> To: schnet@hotmail.com
>>>>> CC: linux-raid@vger.kernel.org
>>>>>
>>>>> On 2 April 2014 21:56, Christian Schmitz <schnet@hotmail.com> wro=
te:
>>>>>> Hi everyone,
>>>>>> I have a linux with the following configuration:
>>>>>> /dev/md0 ( degraded mode) (/dev/sda2)
>>>>>>
>>>>>> /dev/md1 ( full mode) (/dev/sda3 /dev/sdb3)
>>>>>>
>>>>>> The problem is if i add /dev/sdb2 to /dev/md0 start the syncing,=
 but when reach 7% the system crash.
>>>>>> I am sure that the main problem is one ( or more) badblock into =
/dev/sda2.
>>>>>
>>>>> Crash? What does that mean? Kernel panic? Freeze? Reboot?
>>>>> How do you know sda2 (which is sda) has bad blocks? Does it tell =
you?
>>>>> Did you check the SMART data and run badblocks (non-destructivei =
f you
>>>>> want) on it?
>>>>>
>>>>>>
>>>>>> How i can do to syncing the disk?.
>>>>>> Obviously Is the first step to change the disk.
>>>>>
>>>>> If it's broken, sure.
>>>>>
>>>>>>
>>>>>> Best Regards
>>>>>> Christian
>>>>>>
>>>>>
>>>>>
>>>>> REgards,
>>>>> Mathias
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>                                           --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



(please don't top post)

IT appears you are jumping all over the place. Why don't you

a) smartctl -t long on all drives involved
b) Post the smartctl -a output of all drives
c) run badblocks in destructive or non-destructive mode (dd is not the
same, cut can give an indication) on the drives which aren't healthy
d) take it from there

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
