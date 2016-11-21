From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: linux raid wiki - backup files
Date: Mon, 21 Nov 2016 21:30:04 +0000
Message-ID: <980f8ae9-124e-e10c-afc2-97eef9e05b94@youngman.org.uk>
References: <583077D0.5070804@youngman.org.uk>
 <ffb47575-b655-924d-8626-07b9e48a6371@turmel.org>
 <5831B7B9.8090008@youngman.org.uk>
 <4febebb6-0442-cc5e-45d5-e041e21e2d95@turmel.org>
 <c3d16a30-b36e-3d26-f30a-441b236f7107@youngman.org.uk>
 <177d8cfb-f7ec-b0e4-040f-3cfb55f033cc@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <177d8cfb-f7ec-b0e4-040f-3cfb55f033cc@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>, neilb@suse.com
List-Id: linux-raid.ids



On 21/11/16 21:02, Phil Turmel wrote:
> On 11/21/2016 03:22 PM, Anthony Youngman wrote:
>> Having looked at the man page, this now seems obvious - the superblock
>> is at the end, so the data offset is 0. But for a 1.0 array, could we
>> create a data offset?
>>
>> (So, if we created a data offset, we could then move the superblock and
>> convert a 1.0 to 1.1 or 1.2? Okay, it can't do it now, but it looks to
>> me like it shouldn't be that hard ... ?)
>
> I suppose it would be possible, but defeats the purpose of having data
> offset == 0: making non-parity array contents directly readable outside
> the array.  Commonly used to raid boot partitions but still have grub
> able to read them directly.  Less of an issue today with grub2, I
> suppose (but I don't use bootloaders anymore, so I'm not a good resource
> for that).

Only works for mirrors ...

So basically, there's no point using 1.0 for any form of parity raid. In 
which case, if you convert a mirror to parity, it would be nice to be 
able to create said offset and move the superblock.
>
>>>> But if we have a data offset with v1.2, a reshape will use that space if
>>>> it can rather than needing a backup file?
>>>
>> I'm guessing that 1.0 and 1.1 defaulted to no data offset to speak of?
>> And if we (can) create a decent data offset, we can then use that in
>> exactly the same way as with v1.2?
>
> V1.1 and v1.2 are identical except for the superblock offset (one 4k
> block difference).  v1.1 reshapes just like v1.2.
>
Any reason for that difference? How big is the superblock? Did v1.1 fill 
most of the first 4K and just leave not much room with a default 4K data 
offset initially?

> Phil
>
Cheers,
Wol
