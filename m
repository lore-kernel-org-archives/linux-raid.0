From: Phil Turmel <philip@turmel.org>
Subject: Re: Restoring a raid0 for data rescue
Date: Sun, 2 Aug 2020 22:55:37 -0400
Message-ID: <811f84cf-62e1-f8e0-b120-60f7369e3774@turmel.org>
References: <S1726630AbgHBR6v/20200802175851Z+2001@vger.kernel.org>
 <68c39e83-1155-0c8d-96a9-0418bdaf850d@gmx.de>
 <7437ab4d-9cd1-fe53-a17a-fc9e966ccd92@youngman.org.uk>
 <d8f9d16d-b6a2-77ba-bff2-a56c62dac5df@gmx.de>
 <057b0c58-3876-0f03-af33-86f3b266a18a@gmx.de>
 <4d48303b-b8f4-0749-cc6c-8d73ea77edb6@youngman.org.uk>
 <84492bfd-8a1b-6109-fb3f-a32ce25e740d@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84492bfd-8a1b-6109-fb3f-a32ce25e740d@gmx.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: tyranastrasz@gmx.de, antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 8/2/20 8:46 PM, tyranastrasz@gmx.de wrote:
> On 02.08.20 22:50, antlists wrote:

>>>> No, I have the disks in my pc.
>>>> The server can't boot the disks because Intel Storage says the raid has
>>>> a failure, because one of the disks has no raid information. But as I
>>>> read them both yesterday they had, now (see the last attachment) one of
>>>> them has none.
>>>> It makes no sense... I need the files
>>>>
>>>> Intel means "yeah make a new raid, with data loss" that's no option.
>>>>
>>>> Nara
>>>
>>>
>>> I tried something what was told here
>>> https://askubuntu.com/questions/69086/mdadm-superblock-recovery
>>>
>>> root@Nibler:~# mdadm --create /dev/md0 -v -f -l 0 -c 128 -n 2 /dev/sdd
>>> /dev/sdb
>>
>> OH SHIT !!!
>>
>> You didn't try booting with a rescue disk? That mistake could well cost
>> you the array :-( I'm out of my depth ...
>>
>> https://raid.wiki.kernel.org/index.php/Linux_Raid
>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>>
>> I've called in the heavy cavalry, and fortunately with 1.2 the damage
>> might not be too bad.
>>
>> Here's hoping,
>> Wol
> 
> What do you mean with 1.2?
> 
> Should I do?
> https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID
> 
> I wait for an answer so I do it not more complicated :/
> But is it not possible to merge both disks together into a virtual one,
> block by block?
> Our put the old superblock back?
> 
> I dunno what's the best solution.
> 
> Thanks
> Nara

Oy.  I don't mind being called a "big gun", but I've zero experience 
with IMSM / software raid combinations.  Not even a sparkler for you, sorry.

I avoid any form of "fakeraid" as too dangerous to play with.  I 
understand it is necessary if you wish to dual boot windows and linux on 
the same raid, but I don't do the former at all any more (no bare metal 
windows in my life for over a decade, now).

):

Phil
