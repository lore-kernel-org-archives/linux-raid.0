From: "NeilBrown" <neilb@suse.de>
Subject: Re: Can md/mdadm deal with non-standard size of internal bitmap?
Date: Wed, 16 Sep 2009 07:08:18 +1000 (EST)
Message-ID: <a3e5286cc1c820e87ed6383246394545.squirrel@neil.brown.name>
References: <slrnhacnu6.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
    <1253036371.9142.1.camel@lgelinas>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253036371.9142.1.camel@lgelinas>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-Michel Gelinas <coradiant.kernel@gmail.com>
Cc: Mario 'BitKoenig' Holbe <mario.holbe@tu-ilmenau.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, September 16, 2009 3:39 am, Louis-Michel Gelinas wrote:
> Mario, Did you get a [private] answer to this?
>
> Seems interesting. Any reason to dismiss without a reply?
>
> Neil, did this pass under your radar?
>

with 1.x metdata there is no "standard size" for bitmaps.
The metadata records the offset from the superblock of the
bitmap, the offset from the start of the device of the data
and the size of the data area.  You can reserve as much as you
like for bitmap.

mdadm chooses an amount of space to reserve based roughly on the
size of the device.
It doesn't take into about the chunksize and alignment and so push the
data region to the very end of the device as suggested, though that
would not be particularly hard to do I suspect.

NeilBrown


> thanks
>
>
> On Tue, 2009-09-08 at 15:44 +0200, Mario 'BitKoenig' Holbe wrote:
>> Hello (most likely Hello Neil :)),
>>
>> are md and mdadm able to deal correctly with internal bitmaps of
>> non-standard size, i.e. a 132k internal bitmap?
>>
>> As far as I can see from the code it should be possible. v1 superblocks
>> store the offset and size of data, bitmap superblocks store the bitmap
>> chunk size, which, in turn, is used to determine the number of blocks to
>> read as bitmap data.
>> Modifying mdadm to set up a non-standard bitmap size would also be easy:
>> change choose_bm_space(), recompile, create array, done. This would just
>> increase sb->data_offset or decrease sb->data_size a little.
>>
>> However, I'm not sure, if really everything in md and mdadm is able to
>> deal with such a "non-standard" superblock and what would happen on
>> subsequent operations like mdadm --grow using an unpatched mdadm?
>>
>>
>> The reason for me to ask is:
>>
>> When using a chunking RAID level ([0456], 10), there is usually some
>> space cut at the end of component devices which remains unusable because
>> it is too small to contain a chunk. For example, by using unpartitioned
>> 1.5T = 1465138584k component devices and v1.1 superblocks there is a
>> space cut of 20k with 32k-256k chunk size (even 276k with 512k chunks).
>>
>> When using internal bitmaps, depending on the device size more or less
>> of the available bitmap space is really used. For example, the internal
>> bitmap of a 3*1.5T RAID gets 8192KB chunks and uses 536550 bits out of
>> the 1048576 available (if my calculations are correct :)) - 51%.
>>
>> If it would be possible to add some of the space cut from RAID chunking
>> to the internal bitmap, one could optimize the bitmap chunk size. In the
>> above example, by adding 4k to the internal bitmap the bitmap chunk size
>> could be decreased to 4096KB and 1073100 of the then 1081344 available
>> bits would be used - 99%.
>>
>> Of course, this is not always possible, i.e. a 4*1.5T RAID has a bitmap
>> usage/available ratio of 68% - the 20k space cut wouldn't be enough here
>> to optimize it.
>>
>> I'm not sure if it's worth the effort to automate such optimizations,
>> but being able to do them manually at least would be great.
>>
>>
>> regards
>>    Mario
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

