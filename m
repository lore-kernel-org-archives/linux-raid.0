From: Terrence Martin <tmartin@physics.ucsd.edu>
Subject: Re: Best Practice for Raid1 Root
Date: Wed, 14 Jan 2004 16:59:56 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4005E60C.1040504@physics.ucsd.edu>
References: <4005D408.8060002@physics.ucsd.edu> <4005DE22.30604@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4005DE22.30604@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the detailed post. My primary concern is the complete 
failure case since even if there are block problems that cause a partial 
boot (and subsequent failure) a quick unplug of the disk will simulate 
the complete failure state. It is also fairly easy to document that. :)

I had not considered that grub would not be the better solution in this 
case and the older lilo would be the preferred.

While I have managed to grok some of the details of grub it is fairly 
complex. Your technique for lilo gives me a hint though on what I may 
have to do to get grub to work. Of course I have lilo to fall back on.

I do have a concern that moving forward lilo may disappear as an option 
from RH, but it is in RHAS3.0 so I guess I am good for a while.

Also thank you for the tip about swap. I had not considered placing swap 
on an md device to ensure reliability. I will do that as well.

Thanks again,

Terrence





Michael Tokarev wrote:
> Terrence Martin wrote:
> 
>> Hi,
>>
>> I wanted to post this question for a while.
>>
>> On several systems I have configured a root software raid setup with 
>> two IDE hard drives. The systems are always some version of redhat. 
>> Each disk has its own controller and is partitioned similar to the 
>> following, maybe with more partitions, but this is the minimum.
>>
>> hda1 fd   100M
>> hda2 swap 1024M
>> hda3 fd   10G
>>
>> hdc1 fd   100M
>> hdc2 swap 1024M
>> hdc3 fd   10G
>>
>> The Raid devices would be
>>
>> /dev/md0 mounted under /boot made of /dev/hda1 and /dev/hdc1
>> /dev/md1 mounted under / made of /dev/hda3 and /dev/hdc3
> 
> 
> You aren't using raid1 for swap, yes?
> Using two (or more) swap partitions in equivalent of raid0 array
> (listing all them in fstab with the same priority) looks like a
> rather common case, and indeed it works good (you're getting
> stripe speed this way)... until one disk crashes.  And in case
> of disk failure, your running system goes complete havoc,
> including possible filesystem corruption and very probable data
> corruption due to bad ("missing") parts of virtual memory.
> It happened to us recently - we where using 2-disk systems,
> mirroring everything but swap... it was not a nice lesson... ;)
>  From now on, I'm using raid1 for swap too.  Yes it is much
> slower than using several plain swap partitions, and less
> efficient too, but it is much more safe.
> 
>> The boot loader is grub and I want both /boot and / raided.
>>
>> In the event of a failure of hda I would like the system to switch to 
>> hdc. This works fine. However what I have had problems with is if the 
>> system reboots. If /dev/hda is unavailable I no longer have a disk 
>> with a boot sector set up correctly. Unless I have a floppy or CDROM 
>> with a boot loader the system will not come up.
>>
>> So my main question is what is the best practice to get a workable 
>> boot sector on /dev/hdc? How are other people making sure that their 
>> system remains bootable after a disk failure of the boot disk? Is it 
>> even possible with software raid and PC BIOS? Also when you replace 
>> /dev/hda how are you getting a valid boot sector on that disk?
> 
> 
> The answer really depends.  There's no boot program set out there (where
> boot program set is everything from BIOS to the OS boot loader) that is
> able to deal with every kind of first (boot) disk failure.  There are 2
> scenarios of disk failure: when your failed /dev/hda is dead completely,
> just like as it just unplugged, so BIOS and OS boot loader does not even
> see/recognize it (from my expirience this is the most common scenario,
> YMMV).  And second choice is when your boot disk is alive but have some
> bad/unreadable/whatever sectors that belongs to data used during boot
> sequence, so the disk is recognized but boot fails due to read errors.
> 
> It's easy to deal with first case (first disk dead completely).  I wasn't
> able to use grub in that case, but lilo works just fine.  For that, I
> use standard MBR on both /dev/hda and /dev/hdc (your case), and install
> lilo into /dev/md0 (install=/dev/md0 in lilo.conf), making corresponding
> /dev/hd[ac]1 bootable ("active") partitions.  This way, boot sector gets
> "mirrored" manually when installing the MBR, and lilo maps are mirrored
> by raid code.  Lilo uses 0x80 BIOS disk number for the boot map for all
> the disks that forms /dev/md0 (regardless of actual number of them) - it
> treats /dev/md0 array like a single disk.  This way, you may remove/fail
> first (or second or 3rd in multidisk config) disk and your system will
> boot from first disk available, provided your bios will skip missing
> disks and assign 0x80 number to first disk really present.  There's one
> limitation of this method: disk layout should be exactly the same on all
> disks (at least /dev/hd[ac]1 partition placement), or else lilo map will
> be invalid on some disks and valid on others.
> 
> But there's no good way to deal with second scenario.  Especially since
> the problem (failed read) may happen when reading partition table or MBR
> by BIOS - a piece of code you usually can't modify/control.  Provided MBR
> read correctly by BIOS, loaded into memory and first stage of lilo/whatever
> is executing, next steps depends on the OS boot loader (lilo, grub, ...).
> It *may* recognize/know about raid1 array it is booting from, and try other
> disks in case read from first disk fails.  But none of currently existing
> linux boot loaders does that as far as I know.
> 
> So to summarize: it seems like using lilo, installing it into raid array
> instead of MBR, and using standard MBR to boot the machine allows you to 
> deal
> with at least one disk failure scenario, while other scenario is 
> problematic
> in all cases....
> 
> /mjt
> 


