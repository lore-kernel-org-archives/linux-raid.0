From: Christopher White <linux@pulseforce.com>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 20:54:48 +0200
Message-ID: <4DCD7E78.6050000@pulseforce.com>
References: <4DCD4A83.8060202@pulseforce.com>	<4DCD6119.3080705@turmel.org>	<4DCD67EF.1070602@pulseforce.com>	<4DCD6B27.70402@pulseforce.com> <20110513234055.4307c536@natsu> <4DCD72AF.1070809@pulseforce.com> <4DCD75FE.8010703@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD75FE.8010703@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again Phil (and Roman). Thanks to your back-and-forth, the bug has 
now finally been completely narrowed down: It is a bug in (g)parted!

The issue is that (g)parted doesn't properly call the kernel API for 
re-scanning the device when you operate on md disks as compared to 
physical disks.

Your information (Phil) that (g)parted chokes on an assertion is good 
information for when I report this bug. It's not impossible that you 
must handle md-disks differently from physical disks and that (g)parted 
is not aware of that distinction, therefore choking on the partition 
table rescan API.

Either way, this is fantastic news, because it means it's not an md 
kernel bug, where waiting for a fix would have severely pushed back my 
current project. I'm glad it was simply (g)parted failing to tell the 
kernel to re-read the partition tables.

---

With this bug out of the way (I'll be reporting it to parted's mailing 
list now),one thing that's been bugging me during my hours of research 
is that the vast majority of users use either a single, large RAID array 
and virtually partition that with LVM, or alternatively breaking each 
disk into many small partitions and making multiple smaller arrays out 
of those partitions. Very few people seem to use md's built-in support 
for partitionable raid arrays.

This makes me a tiny bit wary to trust the stability of md's 
partitionable implementation, even though I suspect it is rock solid. I 
suspect the reason that most people don't use the feature is for 
legacy/habit reasons, since md used to support only a single partition, 
so there's avast amount of guides telling people to use LVM. Do any of 
you know anything about this and can advise on whether I should go for a 
single-partition MD array with LVM, or a partitionable MD array?

As far as performance goes, the CPU overhead of LVM is in the 1-5% range 
from what I've heard, and I have zero need for the other features LVM 
provides (snapshots, backups, online resizing, clusters of disks acting 
as one disk, etc), so it just feels completely overkill and worthless 
when all I need is a single, partitionable RAID array.

All I need is the ability to (in the future) add more disks to the 
array, grow the array, and then resize+move the partitions around using 
regular partitioning tools treating the RAID array as a single disk, and 
md's partitionable arrays support doing this since they act as a disk, 
where if you add more hard disks to your array; the available, 
unallocated space on that array simply grows and partitions on it can be 
expanded and relocated to take advantage of this. I don't need LVM for 
any of that, as long as md's implementation is stable.


Christopher

On 5/13/11 8:18 PM, Phil Turmel wrote:
> Hi Christopher,
>
> On 05/13/2011 02:04 PM, Christopher White wrote:
>> On 5/13/11 7:40 PM, Roman Mamedov wrote:
>>> On Fri, 13 May 2011 19:32:23 +0200
>>> Christopher White<linux@pulseforce.com>   wrote:
>>>
>>>> I forgot to mention that I've also tried "sudo fdisk /dev/md1" and
>>>> creating two partitions that way. It fails too.
>>>>
>>>> This leads me to conclude that /dev/md1 was never created in
>>>> partitionable mode and that the kernel refuses to create anything beyond
>>>> a single partition on it.
>>> Did you try running "blockdev --rereadpt /dev/md1"?
>>>
>> Hmm. Hmmmm. One more for good measure: Hmmmmmmm.
>>
>> That's weird! Here's the thing: Fdisk is *just* for creating the partitions, not formatting them, so for that one it makes sense that you must re-read the partition table before you have a partition device to execute "mkfs.XXX" on.
>>
>> However, Gparted on the other hand is BOTH for creating partition tables AND for executing the "make filesystem" commands (formatting). Therefore, Gparted is supposed to tell the kernel about partition table changes BEFORE trying to access the partitions it just created. Basically, Gparted goes: Blank disk, create partition table, create partitions, notify OS to re-scan the table, THEN access the new partition devices and format them. But instead, it skips the "notify OS" part when working with md-arrays!
>>
>> When you use Gparted on PHYSICAL hard disks, it properly creates the partition table and the OS is updated to immediately see the new partition devices, to allow them to be formatted.
> Indeed.  I suspect (g)parted is in fact requesting a rescan, but is being ignored.
>
> I just tried this on one of my servers, and parted (v2.3) choked on an assertion.  Hmm.
>
>> Therefore, what this has shown is that the necessary procedure in Gparted is:
>> * sudo gparted /dev/md1
>> * Create the partition table (gpt for instance)
>> * Create as many partitions as you need BUT SET THEIR TYPE TO "unformatted" (extremely important).
>> * Go back to a terminal and execute "sudo blockdev --rereadpt /dev/md1" to let the kernel see the new partition devices
>> * Now go back to the Gparted and format the partitions, or just do it the CLI way with mkfs.ext4 manually. Either way, it will now work.
>>
>> So how should we sum up this problem? Well, that depends. What is responsible for auto-discovering the new partitions when you use Gparted on a PHYSICAL disk (which works perfectly without manual re-scan commands)? 1) Is it Gparted telling the kernel to re-scan, or 2) is it the kernel that auto-watches physical disks for changes?
> Generally, udev does it.  But based on my little test, I suspect parted is at fault.  fdisk did just fine.
>
>> If 1), it means Gparted needs a bug fix to tell the kernel to re-scan the partition table for md-arrays when you re-partition them.
>> If 2), it means the kernel doesn't watch md-arrays for partition table changes, which debatably it should be doing.
> What is ignored or acted upon is decided by udev rules, as far as I know.  You might want to monitor udev events while running some of your tests (physical disk vs. MD).
>
>> Thoughts?
> Phil
