From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 17:03:45 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712191703280.23302@p34.internal.lan>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
 <20071219215948.GA7129@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071219215948.GA7129@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids



On Wed, 19 Dec 2007, Robin Hill wrote:

> On Wed Dec 19, 2007 at 09:50:16AM -0500, Justin Piszcz wrote:
>
>> The (up to) 30% percent figure is mentioned here:
>> http://insights.oetiker.ch/linux/raidoptimization.html
>>
> That looks to be referring to partitioning a RAID device - this'll only
> apply to hardware RAID or partitionable software RAID, not to the normal
> use case.  When you're creating an array out of standard partitions then
> you know the array stripe size will align with the disks (there's no way
> it cannot), and you can set the filesystem stripe size to align as well
> (XFS will do this automatically).
>
> I've actually done tests on this with hardware RAID to try to find the
> correct partition offset, but wasn't able to see any difference (using
> bonnie++ and moving the partition start by one sector at a time).
>
>> # fdisk -l /dev/sdc
>>
>> Disk /dev/sdc: 150.0 GB, 150039945216 bytes
>> 255 heads, 63 sectors/track, 18241 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0x5667c24a
>>
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdc1               1       18241   146520801   fd  Linux raid
>> autodetect
>>
> This looks to be a normal disk - the partition offsets shouldn't be
> relevant here (barring any knowledge of the actual physical disk layout
> anyway, and block remapping may well make that rather irrelevant).
>
> That's my take on this one anyway.
>
> Cheers,
>        Robin
> --
>     ___
>    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>   / / )      | Little Jim says ....                            |
>  // !!       |      "He fallen in de water !!"                 |
>

Interesting, yes, I am using XFS as well, thanks for the response.
