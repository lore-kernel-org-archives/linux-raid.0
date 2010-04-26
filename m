From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Mon, 26 Apr 2010 14:52:57 +0200
Message-ID: <7a3e01cae53f$684122c0$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "MRK" <mrk@shiftmail.org>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, April 26, 2010 12:24 PM
Subject: Re: Suggestion needed for fixing RAID6


> On 04/25/2010 12:00 PM, Janos Haar wrote:
>>
>> ----- Original Message ----- From: "MRK" <mrk@shiftmail.org>
>> To: "Janos Haar" <janos.haar@netcenter.hu>
>> Cc: <linux-raid@vger.kernel.org>
>> Sent: Sunday, April 25, 2010 12:47 AM
>> Subject: Re: Suggestion needed for fixing RAID6
>>
>> Just a little note:
>>
>> The repair-sync action failed similar way too. :-(
>>
>>
>>> On 04/24/2010 09:36 PM, Janos Haar wrote:
>>>>
>>>> Ok, i am doing it.
>>>>
>>>> I think i have found some interesting, what is unexpected:
>>>> After 99.9% (and another 1800minute) the array is dropped the 
>>>> dm-snapshot structure!
>>>>
>>>> ...[CUT]...
>>>>
>>>> raid5:md3: read error not correctable (sector 2923767944 on dm-0).
>>>> raid5:md3: read error not correctable (sector 2923767952 on dm-0).
>>>> raid5:md3: read error not correctable (sector 2923767960 on dm-0).
>>>> raid5:md3: read error not correctable (sector 2923767968 on dm-0).
>>>> raid5:md3: read error not correctable (sector 2923767976 on dm-0).
>>>> raid5:md3: read error not correctable (sector 2923767984 on dm-0).
>>>> raid5:md3: read error not correctable (sector 2923767992 on dm-0).
>>>> raid5:md3: read error not correctable (sector 2923768000 on dm-0).
>>>>
>>>> ...[CUT]...
>>>>
>>
> 
> Remember this exact error message: "read error not correctable"
> 
>>
>>>
>>> This is strange because the write should have gone to the cow device. 
>>> Are you sure you did everything correctly with DM? Could you post 
>>> here how you created the dm-0 device?
>>
>> echo 0 $(blockdev --getsize /dev/sde4) \
>>        snapshot /dev/sde4 /dev/loop3 p 8 | \
>>        dmsetup create cow
>>
> 
> Seems correct to me...
> 
>> ]# losetup /dev/loop3
>> /dev/loop3: [0901]:55091517 (/snapshot.bin)
>>
> This line comes BEFORE the other one, right?
> 
>> /snapshot.bin is a sparse file with 2000G seeked size.
>> I have 3.6GB free space in / so the out of space is not an option. :-)
>>
>>
> [...]
>>
>>>
>>> We might ask to the DM people why it's not working maybe. Anyway 
>>> there is one good news, and it's that the read error apparently does 
>>> travel through the DM stack.
>>
>> For me, this looks like md's bug not dm's problem.
>> The "uncorrectable read error" means exactly the drive can't correct 
>> the damaged sector with ECC, and this is an unreadable sector. 
>> (pending in smart table)
>> The auto read reallocation failed not meas the sector is not 
>> re-allocatable by rewriting it!
>> The most of the drives doesn't do read-reallocation only 
>> write-reallocation.
>>
>> These drives wich does read reallocation, does it because the sector 
>> was hard to re-calculate (maybe needed more rotation, more 
>> repositioning, too much time) and moved automatically, BUT those 
>> sectors ARE NOT reported to the pc as read-error (UNC), so must NOT 
>> appear in the log...
>>
> 
> No the error message really comes from MD. Can you read C code? Go into 
> the kernel source and look this file:
> 
> linux_source_dir/drivers/md/raid5.c
> 
> (file raid5.c is also for raid6) search for "read error not correctable"
> 
> What you see there is the reason for failure. You see the line "if 
> (conf->mddev->degraded)" just above? I think your mistake was that you 
> did the DM COW trick only on the last device, or anyway one device only, 
> instead you should have done it on all 3 devices which were failing.
> 
> It did not work for you because at the moment you got the read error on 
> the last disk, two disks were already dropped from the array, the array 
> was doubly degraded, and it's not possible to correct a read error if 
> the array is degraded because you don't have enough parity information 
> to recover the data for that sector.

Oops, you are right!
It was my mistake.
Sorry, i will try it again, to support 2 drives with dm-cow.
I will try it.

Thanks again.

Janos


