From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID Recovery
Date: Mon, 6 Mar 2017 15:10:52 -0500
Message-ID: <e4d9724d-ab52-aa79-c600-7b287c16a182@turmel.org>
References: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/06/2017 10:07 AM, Adam Goryachev wrote:
> Hi all,
> 
> I'm trying to assist a friend to recover their RAID array, it consists
> of 4 drives, most likely in RAID10. It was a linux based NAS (AFAIK). I
> would really appreciate any tips or suggestions...
> 
> First, the bad news:
> 
> mdadm --misc --detail /dev/sd[abcd]
> mdadm: /dev/sda does not appear to be an md device

For future reference:  --detail is only applicable to the /dev/md*
*array* device.  --examine is only applicable to *member* devices,
and is required for valid results when an array is not running.

> mdadm --misc --examine /dev/sd[abcd]
> /dev/sda:
>    MBR Magic : aa55
> /dev/sdb:
>    MBR Magic : aa55
> /dev/sdc:
>    MBR Magic : aa55
> /dev/sdd:
>    MBR Magic : aa55
> 
> This really doesn't look promising.... but the disks themselves look
> "healthy"... at least mostly.

As Reindl said, this by itself is no surprise.  The NAS has to boot off
of *something*, so partitions for /boot, /swap, /, and /data, or some
combination, is common for such small systems.

The first partition is likely raid1 across all devices for /boot.
After that, all bets are off.

> Looking at the content of the drives, it might be possible that all four
> drives were in RAID1 ... at least, I can find identical data on all four
> of the drives:
> 
> Running this command for each drive:
> 
> strings /dev/sdd |cat -n |less
> 
> looking for some "text", and I find what looks like a log file snipped
> which is identical across all four drives. Thats 25 lines of output,
> that exists on the same output line number, matching across all 4
> drives. So perhaps I have a 4 drive RAID1, which I guess should make it
> easier to recover from.

Probably just a 4x raid1 mirror for the root partition.

> Disks are /dev/sda /dev/sdb /dev/sdc /dev/sdd, all identical
> "partitions" that don't seem to exist, but there is a MBR partition table
> 
> gdisk -l /dev/sda
> GPT fdisk (gdisk) version 1.0.1
> 
> Partition table scan:
>   MBR: MBR only
>   BSD: not present
>   APM: not present
>   GPT: not present
> 
> 
> ***************************************************************
> Found invalid GPT and valid MBR; converting MBR to GPT format
> in memory.
> ***************************************************************
> 
> Disk /dev/sda: 1953525168 sectors, 931.5 GiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): 145F71F0-4D0B-4941-9F9E-2C5301BF518F
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 1953525134
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 1953525101 sectors (931.5 GiB)

This is worrisome.  Please repost the complete output of fdisk -l
and gdisk -l for all of these devices.  But....

> The first two drives look like this (lots of read errors), the second
> two look perfectly clean...

Please remove the drives from the NAS box and connect to a known good
system.  Your smartctl reports include neither re-allocated sectors
nor pending relocations, which would be expected if there are many
read errors.  That means the read errors are likely due to controller,
cables, or power supply problems.

Note, timeout mismatch *does not* apply to sda, but you trimmed
too much to tell for the other devices.  Please submit complete output
from smartctl -iA -l scterc /dev/sdX for each of these devices.

Do the fdisk & gdisk reports from the known good system, and also,
if you can find any partitions, run --examine on each from the same
system.  Keep the --examine reports with the corresponding smartctl
report.

Phil
