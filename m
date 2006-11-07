From: David <lists@edeca.net>
Subject: Re: Checksums wrong on one disk of mirror
Date: Tue, 07 Nov 2006 14:10:13 +0000
Message-ID: <20061107141013.sbnftu8n4wgkgkw4@my.pengus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Neil Brown <neilb@suse.de>:
> On Tuesday November 7, lists@edeca.net wrote:
>> Booting into a live CD, mdadm -E /dev/sdaX shows that the checksum is
>> not what would be expected for sda1,2,3 but is fine for sda6. All of
>> the checksums on drive sdb are correct.
>
> I'm surprised it doesn't boot then.  How are the arrays being
> assembled? A more complete kernel log would help.

Neil,

Thanks for such a quick reply.  I will post the kernel logs if the  
below is not enough information.  The old dmesg should also still be  
on the partition.

>> The state is "clean" for all partitions, working 2, active 2 and
>> failed 0. The table for sdb1,2,3 shows that the first device has been
>> removed and is no longer an active mirror.
>>
>> What is the best way to proceed here? Can I somehow sync from the
>> second disk, which appears to have the correct checksums? Is there an
>> easy way to fix this that wont involve loosing the data?
>
> While booted from the live CD you should be able to
>   mdadm -AR /dev/md0 /dev/sdb1
>   mdadm /dev/md0 --add /dev/sda1

Fantastic, this works well for two of the partitions.  However the  
third has a bad sector (as reported by smartmontools) on the disk with  
the "good" superblock.  The disk cannot read the sector, so the  
syncing fails and starts over at 15.7% each time.

Is it safe to mount that partition outside of the md, find the file,  
remove it so that the disk can remap that sector (it is shown as  
Currently_Pending in SMART right now) then resync the array?  I guess  
this will cause problems and break the mirror.  Or is the correct way  
to remove the "bad" superblock drive from the array, mount the md,  
remove the file then resync the array?

If it is possible to do either of the above, how do I stop the  
recovery?  It now starts automatically at live CD boot, repeating from  
15.7% over and over.  My knowledge of the tools is bad but I tried the  
following:

# mdadm /dev/md0 --remove /dev/sda1
and
# mdadm -f /dev/md0 --remove /dev/sda1 (no idea if the -f even makes  
sense there)

> It is very odd that the checksums are all wrong though.  Kernel
> version? mdadm version? hardware architecture?

Kernel installed from Ubuntu 6.06 sources, 2.6.15.  Machine is a x86  
Dell with two identical Maxtor DiamondMax drives on an Intel 82801  
SATA controller.

mdadm is version 1.12.  Looking at the most recently available version  
this seems incredibly out of date, but seems to be the default  
installed in Ubuntu.  Even Debian stable seems to have 1.9.  I can bug  
this with them for an update if necessary.

Is it possible that a broken init script has tried to fsck an  
individual drive instead of the md?  /etc/fstab only uses /dev/md*  
references but I'll check other scripts when (if? :) I get the system  
back up and running.

Whilst the machine is not critical and is only a new install, I'd like  
to keep fighting rather than give in if possible.

Thanks,

David
