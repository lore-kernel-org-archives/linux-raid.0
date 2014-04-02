From: Christian Schmitz <schnet@hotmail.com>
Subject: RE: Problem Syncing raid1
Date: Wed, 2 Apr 2014 22:18:10 +0000
Message-ID: <BAY177-W35793297D3F640EF11F48C86D0@phx.gbl>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>,<CADNH=7EwjLirv+zdUKu-Hsrw1djLNpPoz=WSg4pJwUc0giRzOw@mail.gmail.com>,<BAY177-W961648C4893E888EECA18C86D0@phx.gbl>,<CAK_KU4bh3S+rwMmJt4_8pyrOYbiLn83BHYabF79c4M59UoW1TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4bh3S+rwMmJt4_8pyrOYbiLn83BHYabF79c4M59UoW1TA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks, i will run smartctl as soon i finish recover the server data.

Tomorrow i will give news.

Best regards.
Christian


be free, be linux


----------------------------------------
> Date: Wed, 2 Apr 2014 18:08:31 -0400
> Subject: Re: Problem Syncing raid1
> From: sdvileskis@gmail.com
> To: schnet@hotmail.com
> CC: mathias.buren@gmail.com; linux-raid@vger.kernel.org
>
> The good news is your realloc_sector_cnt is 0.
>
> However, run:
> smartctl -t long /dev/sda
> smartctl -t long /dev/sdb
>
> if you haven't done it in a while
> It will tell the controller on the disk to check all the sectors and =
remap any.
>
> It will generally take several hours to complete, but if SMART detect=
s
> any bad sectors it will attempt to remap them. (The OS and badblocks
> won't know the difference)
> You can run the smart test while the disk is online/mounted without
> problems, but the more you lay off the disks, the faster it will run.
>
> On Wed, Apr 2, 2014 at 5:56 PM, Christian Schmitz <schnet@hotmail.com=
> wrote:
>> The system freeze, i suspect that is a bad sector because is allways=
 in the same point of syncing.
>>
>> I do a low level format and all test to SDB, so the problem is in SD=
A.
>>
>> Like a deja vu my server was exactly the same problem, now i am doin=
g the ddrescue to server disk and found badblock. This reforce the badb=
lock intuition.
>>
>> #smartctl -a /dev/sda
>> SMART overall-health self-assessment test result: PASSED
>> ID# ATTRIBUTE_NAME FLAG VALUE WORST THRESH TYPE UPDATED WHEN_FAILED =
RAW_VALUE
>> 1 Raw_Read_Error_Rate 0x002f 200 193 051 Pre-fail Always - 25
>> 3 Spin_Up_Time 0x0027 201 196 021 Pre-fail Always - 916
>> 4 Start_Stop_Count 0x0032 099 099 000 Old_age Always - 1032
>> 5 Reallocated_Sector_Ct 0x0033 200 200 140 Pre-fail Always - 0
>>
>> I think that badblock was caused in power failure, so is a logical b=
adblock and not phisical badblock. But to lowlevel format, and run the =
manufacturer tools i need sync the raid to ship the data to SDB disk.
>>
>> =BFHow i can use badblock in a raid device?
>> badblock /dev/md0?
>> badblock /dev/sda2?
>> The raid hangup if badblock does something?
>>
>> Thanks for your answer.
>> Christian
>> be free, be linux
>>
>>
>> ----------------------------------------
>>> Date: Wed, 2 Apr 2014 22:36:49 +0100
>>> Subject: Re: Problem Syncing raid1
>>> From: mathias.buren@gmail.com
>>> To: schnet@hotmail.com
>>> CC: linux-raid@vger.kernel.org
>>>
>>> On 2 April 2014 21:56, Christian Schmitz <schnet@hotmail.com> wrote=
:
>>>> Hi everyone,
>>>> I have a linux with the following configuration:
>>>> /dev/md0 ( degraded mode) (/dev/sda2)
>>>>
>>>> /dev/md1 ( full mode) (/dev/sda3 /dev/sdb3)
>>>>
>>>> The problem is if i add /dev/sdb2 to /dev/md0 start the syncing, b=
ut when reach 7% the system crash.
>>>> I am sure that the main problem is one ( or more) badblock into /d=
ev/sda2.
>>>
>>> Crash? What does that mean? Kernel panic? Freeze? Reboot?
>>> How do you know sda2 (which is sda) has bad blocks? Does it tell yo=
u?
>>> Did you check the SMART data and run badblocks (non-destructivei f =
you
>>> want) on it?
>>>
>>>>
>>>> How i can do to syncing the disk?.
>>>> Obviously Is the first step to change the disk.
>>>
>>> If it's broken, sure.
>>>
>>>>
>>>> Best Regards
>>>> Christian
>>>>
>>>
>>>
>>> REgards,
>>> Mathias
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
