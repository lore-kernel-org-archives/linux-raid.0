From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Sun, 8 Oct 2017 10:19:42 +0100
Message-ID: <b07a6092-9127-8a7b-a889-858df80ce803@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <4ebf4f1c-34af-2b7d-20b3-77dd49086d94@shenkin.org>
 <59D90F15.1040203@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59D90F15.1040203@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Wol; that's *2* mistakes I've made; ugh.  /boot is on RAID1.  I
have no RAID0's in the machine.

These 3TB seagates are old ones, and were sitting in their original
boxes for a few years unused.  3 others have already died, and one
during a rebuild, causing tons of grief.  So, random or not, this one is
going in the trash.  Seagate should refund me, but they never will.

Thanks,
Allie

On 10/7/2017 6:29 PM, Wols Lists wrote:
> On 07/10/17 11:05, Alexander Shenkin wrote:
>> Thanks Carsten,
>>
>> I was mistaken, it's a RAID1, not RAID0.  I have /boot mounted on a
>> RAID0, and / mounted on RAID5.  They both split across 4 drives.
> 
> How big is each partition that makes up /boot? If that's raid0, surely
> that's not wise? A single disk failure will render the machine
> unbootable. Surely that should be raid1, so you can boot off any disk.
>>
>> Appreciate the advice - i'll just keep it running until the drive
>> arrives tomorrow...
> 
> I'd keep it running ...
>>
>> Thanks,
>> Allie
>>
>> On 10/7/2017 9:21 AM, Carsten Aulbert wrote:
>>> Hi
>>>
> 
>>>
>>> Given this is "only" a single sector error I would keep it running as
>>> long as you can physically install the new drive and only then take it
>>> offline.
>>>
>>> At least theoretically, it may be possible to force the rewrite of this
>>> sector and use the spare sectors of the disk, but I'm not 100% sure if a
>>> simple md check would already trigger it - usually you need to write
>>> "new" data to defective sectors to force the drive's firmware to use the
>>> spare sectors.
>>>
> How serious is a "pending sector"? I think doing a scrub will fix it.
> 
> If it's not serious I'd look at using the extra drive to convert it to
> raid6. I doubt the infamous 3TB drives were a "bad batch", but given the
> press they got I would have expected Seagate to fix the problem. If
> these drives are newer than the ones that got the bad press, they might
> be fine.
> 
> There's always the argument "do you ditch a disk on the first error, or
> do you wait until it's definitely dying". But iirc a "pending sector" is
> just one of those things that happens every now and then. If this goes
> away with a scrub, and you don't get a batch of new ones, then the drive
> is probably fine (until the next *random* problem shows up).
> 
> Cheers,
> Wol
> 
