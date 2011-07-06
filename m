From: Werner Fischer <devlists@wefi.net>
Subject: Re: alignment of metadata 1.2 and mkfs.ext4
Date: Wed, 06 Jul 2011 10:35:13 +0200
Message-ID: <1309941313.2211.16.camel@werner-t410>
References: <1309936276.11661.8.camel@baal>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309936276.11661.8.camel@baal>
Sender: linux-raid-owner@vger.kernel.org
To: "Tyler J. Wagner" <tyler@tolaris.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

like Tyler I'm also asking me those questions.
Reason is that newer Solid-State Drives (like the Intel 320 Series) have
Flash-Chips with page size of 8KiB (the former SSDs have mostly 4KiB
pages). So in the best case, all data written to such an SSD should be
at least 8KiB aligned - which I think is not the case for MD-RAID with
metadata 1.2 superblocks - because of the "4K from the beginning of the
device":
https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#Sub-versions_of_the_version-1_superblock
When I understand the wiki page correctly, the metadata 1.2 superblock
has a size of 1024 Bytes (256 Bytes + 2 Bytes/device for a maximum of
384 devices), right?

When I simply put an Ext4 file system with a block size of 4KiB on the
RAID, there is no problem as there will always be two Ext4 blocks
residing in a single 8 KiB page of the SSD.

My questions:
1) But when I use LVM2 with a PE size of 4 MiB on top of a RAID, I will 
   not be perfectly aligned any more, right?
2) Are there any plans that e.g. the first 1MiB will be reserved for 
   metadata (like fdisk does when creating new partitions), so that 
   there won't be any alignment issues in the future?
     (btw: haven the metadata at the end of the device like in the 
     metadata format 0.90 or 1.0 would also not interfere the alignment 
     - is there a special reason why the metadata has been put to the 
     beginning of the device?)

best regards,
Werner

On Wed, 2011-07-06 at 08:11 +0100, Tyler J. Wagner wrote:
> Hi all (well, Neil, really),
> 
> The the following, Neil states that that is no issue with alignment of
> metadata 1.2 and mkfs.ext4 on 4K drives:
> 
> http://www.issociate.de/board/post/507176/filesystem_on_mdadm_raid_from_unpartioned_block_devices.html
> 
> Sorry to ask again, but I just want to clarify. Metadata 1.2 puts the
> data 4K from the start of the device/partition. Does mkfs put the start
> of the filesystem at 64K from the start? IE, will the following align,
> without any need for options?
> 
> (create partitions starting 2048 512-byte sectors from start = 1MB)
> mdadm --create /dev/md0 -v --raid-devices=4 --level=raid10
> --metadata=1.2 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> mkfs.ext4 /dev/md0
> 
> And, slightly off-topic, it's not necessary to define stride and stripe
> any longer?
> mkfs.ext4 -E stride=16,stripe-width=32 /dev/md0
> 
> Regards,
> Tyler
> 
> 

-- 
: Werner Fischer
: Technology Specialist
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki

