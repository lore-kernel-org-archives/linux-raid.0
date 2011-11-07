From: David Brown <david.brown@hesbynett.no>
Subject: Re: Special drives for Linux Raid?
Date: Mon, 07 Nov 2011 19:28:28 +0100
Message-ID: <j9980c$9qi$1@dough.gmane.org>
References: <4EB7DD23.9090907@agenda.si> <4EB7E1F8.7060803@meetinghouse.net> <j98s0f$a0f$1@dough.gmane.org> <CADc_k_se=GzaYfiWv0p49YP+xBfgBL7_JLCYYa8C0Dcm0T1XAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADc_k_se=GzaYfiWv0p49YP+xBfgBL7_JLCYYa8C0Dcm0T1XAA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/11 19:00, Beolach wrote:
> On Mon, Nov 7, 2011 at 07:57, David Brown<david@westcontrol.com>  wrote:
>> On 07/11/2011 14:49, Miles Fidelman wrote:
>>>
>>> Danilo Godec wrote:
>>>>
>>>> Some manufacturers make 'special' versions of drives for RAID (WD RE4,
>>>> Seagate SE, ...). Apparently the main difference is in error handling,
>>>> where normal 'desktop' drives try hard to recover an error (up to
>>>> several minutes) while RAID drives give up quickly (few seconds) so
>>>> that the RAID controller can take over.
>>>>
>>> not so much "special" as "different"
>>>
>>> the term to look for is "enterprise"
>>>
>>> you've identified the key distinction:
>>>
>>> - desktop drives assume that they have the only copy of your data, the
>>> on-board processor tries very hard to read and re-read until it returns
>>> your data ---- the result is that everything slows down
>>>
>>> - if you have a raid array, you want a failing disk to give up and
>>> return, very quickly, so that the data can be read from a different drive
>>>
>>> I learned this the hard way, when I had a server that just slowed way
>>> down to the point that it took 10 seconds or more to echo a keystroke.
>>> It took me a long time to figure out what was going on - and some rather
>>> painful false starts (trashed the o/s).
>>>
>>> One important thing I discovered: the md RAID driver does NOT consider a
>>> long time delay as a signal to fail a drive out of an array. It's a
>>> really good idea to run mdstat and keep an eye on your drives. If Raw
>>> Reed Error goes above 0, start paying attention.
>>>
>>
>> As far as I know (and I hope I'll be corrected quickly if I'm wrong), when a
>> drive fails to read from a sector, it will be considered a "failed" drive by
>> the raid controller or software raid, and kicked out of the array.  The
>> exception is the latest versions of md raid which support bad block lists.
>>
>
> I don't think that's quite correct - when a member drive of an MD RAID
> returns a read error, MD tries to re-write the sector using the
> redundancy from the other drives in the RAID.  It's only if a drive
> returns a *write* error that the drive is failed.
>

OK, thanks for correcting me here.

Do hardware raid cards typically do the same thing?

(I've only occasionally had disk failures in raid systems, and in every 
case the disk died totally, so I haven't tested this.)

