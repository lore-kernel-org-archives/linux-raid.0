From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Tue, 25 Dec 2007 14:06:41 -0500
Message-ID: <477154C1.6000503@tmr.com>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan> <20071219215948.GA7129@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071219215948.GA7129@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> On Wed Dec 19, 2007 at 09:50:16AM -0500, Justin Piszcz wrote:
>
>   
>> The (up to) 30% percent figure is mentioned here:
>> http://insights.oetiker.ch/linux/raidoptimization.html
>>
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
>>     
> This looks to be a normal disk - the partition offsets shouldn't be
> relevant here (barring any knowledge of the actual physical disk layout
> anyway, and block remapping may well make that rather irrelevant).
>   
The issue I'm thinking about is hardware sector size, which on modern 
drives may be larger than 512b and therefore entail a read-alter-rewrite 
(RAR) cycle when writing a 512b block. With larger writes, if the 
alignment is poor and the write size is some multiple of 512, it's 
possible to have an RAR at each end of the write. The only way to have a 
hope of controlling the alignment is to write a raw device or use a 
filesystem which can be configured to have blocks which are a multiple 
of the sector size and to do all i/o in block size starting each file on 
a block boundary. That may be possible with ext[234] set up properly.

Why this is important: the physical layout of the drive is useful, but 
for a large write the drive will have to make some number of steps from 
on cylinder to another. By carefully choosing the starting point, the 
best improvement will be to eliminate 2 track-to-track seek times, one 
at the start and one at the end. If the writes are small only one t2t 
saving is possible.

Now consider a RAR process. The drive is spinning typically at 7200 rpm, 
or 8.333 ms/rev. A read might take .5 rev on average, and a RAR will 
take 1.5 rev, because it takes a full revolution after the original data 
is read before the altered data can be rewritten. Larger sectors give 
more capacity, but reduced performance for write. And doing small writes 
can result in paying the RAR penalty on every write. So there may be a 
measurable benefit to getting that alignment right at the drive level.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


