From: antlists <antlists@youngman.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 21:05:25 +0100
Message-ID: <13d82398-337f-6dae-cfe8-5f23ae413c23@youngman.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <875ze23pfm.fsf@vps.thesusis.net>
 <f415cfb3-9612-d29d-17c1-d34405233519@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f415cfb3-9612-d29d-17c1-d34405233519@peter-speer.de>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/04/2020 20:00, Stefanie Leisestreichler wrote:
>>> I have read that - when using UEFI - the EFI-System-Partition (ESP) has
>>> to reside in a own native partition, not in a RAID nor LVM block device.
>>
>> Correct.

> This is exactly the point which I do not understand. So it is implicitly 
> saying that it makes no sense to raid the 2 EFI-System-Partitions (sda1 
> + sdb1), i.e. as /dev/md124, as GRUB can not write to a RAID device and 
> instead uses /dev/sda1 and no automatic sync will happen?
> 
> If that is true, I wonder how to setup a system using RAID 1 where you 
> can - frankly spoken - remove one or the other disk and boot it :-(

Because you haven't got to grips with how EFI boots a computer.

The CPU starts, jumps into the mobo rom, and then looks for an EFI 
partition on the disk. Because it understands VFAT, it then reads the 
EFI boot loader from the partition.

I don't quite get this myself, but this is where it gets confusing. EFI 
I think offers you a choice of bootloaders, which CAN include grub, 
which then offers you a choice of operating systems. But EFI can offer 
you a list of operating systems, too, which is why I said why did you 
want to use grub?

The whole point here is nothing to do with "grub can or can't write to a 
raid" - grub doesn't write to the disk! The point is that EFI is active 
BEFORE grub or linux even get a look-in. So if EFI writes to the efi 
partition, then that's before grub or linux even get a chance to do 
anything!

A lot of EFI is managed from the operating system. So if you do a v0.9 
or v1.0 raid-1, anything you do from within linux will be mirrored, and 
there's no problem. The problem is if anything modifies the efi 
partition outside of linux we have a problem. And because the whole 
point of efi is to be there before linux even starts, then it's 
*probable* that something will come along and do just that!

Cheers,
Wol
