From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is partition alignment needed for RAID partitions ?
Date: Mon, 30 Dec 2013 00:56:41 -0600
Message-ID: <52C11929.3070600@hardwarefreak.com>
References: <52C08E63.8020800@insync.za.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C08E63.8020800@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/29/2013 3:04 PM, Pieter De Wit wrote:
> Hi List,
> 
> I am taking advantage of the holiday season by testing some NAS devices
> for work. This now allows me to rebuild my home storage.
> 
> My current setup is as follow:
> 
> /dev/sda 250 gig drive (/boot is mounted here since I had no other use
> for the drive)
> /dev/sdb 2TB drive
> /dev/sdc 2TB drive
> 
> /dev/sdb and sdc has two MD devices on them, a RAID1 and a RAID0 device.
> /dev/sdb and sdc was taken out of a MAC server, so the partition table
> is a mess, I want to rebuild them.
> 
> All of these house LVM PV's
> 
> The RAID1 device contains all my "critical" data ( root device, logs,
> photos etc) while the RAID0 device contains all data I have other
> sources for.
> 
> So my question is, do I need to align the partitions for the raid devices ?

You're asking a question without providing sufficient background
information, and in a manner which suggests the answers need to be
lengthy and in "teaching" mode instead of short and concise.  In other
words, I cannot provide a yes/no answer to your yes/no question.

Are these 2TB Advanced Format drives?  If so your partitions need to
align to 4KiB boundaries, otherwise you'll have RMW within each drive
which can cut your write throughput by 30-50%.  So it's a good habit to
always align to 4KiB regardless, as most new drives are Advanced Format.
 LBA sectors are 512B in length.  It's a good habit to start your first
partition at LBA sector 2048, which is the 1MiB boundary.  By adopting
this standard your first partition will be aligned whether the disk
drive is standard 512B/sec, 4096B/sec AF, or an SSD.

So your first partition starts at sector 2048.  You should size it, and
all subsequent partitions, such that it is evenly divisible by your
chunk size.  Your first array, a RAID1, has no chunk size so this is not
relevant.  However, you may as well follow the standard anyway for
consistency.  Your second array is a RAID0, and lets assume you'll use a
512KB chunk.  If you want two 930GiB (999GB) partitions on each disk
drive, resulting in a ~1TB RAID1 and ~2TB RAID0, then you'll want
something like this, using 512B sectors, if my math is correct:

		Start sector	End sector
/dev/sdb1	2048		1950355455
/dev/sdb2	1950355456	3900708863
/dev/sdc1	2048		1950355455
/dev/sdc2	1950355456	3900708863

Partition length is 1904642 chunks.  This is an aligned partition layout
and should work for your drives.  I intentionally undersized these
partitions a bit so we wouldn't spill over on a given drive model.  Not
all 2TB drives have exactly or over 2,000,000,000,000 bytes capacity.


You're comparing apples to oranges to grapes below, and your description
lacks any level of technical detail.  How are we supposed to analyze this?

> These are desktop grade drives, but for the RAID0 device I saw quite low
> throughput (15meg/sec moving data to the NAS via gig connection). I just

"15meg/sec moving data" means what, a bulk file transfer from a local
filesystem to a remote filesystem?  What types of files?  Lots of small
ones?  Of course throughput will be low.  Is the local filesystem
fragmented?  Even slower.

> created a RAID1 device between /dev/sda and an iSCSI target on the NAS,
> and it synced at 48meg/sec, moving data at 30meg/sec - double that of
> the RAID0 device. 

This is block device data movement.  There is no filesystem overhead, no
fragmentation causing excess seeks, and no NFS/CIFS overhead on either
end.  Of course it will be faster.

> I would have expected the RAID0 device to easily get
> up to the 60meg/sec mark ?

As the source disk of a bulk file copy over NFS/CIFS?  As a point of
reference, I have a workstation that maxes 50MB/s FTP and only 24MB/s
CIFS to/from a server.  Both hosts have far in excess of 100MB/s disk
throughput.  The 50MB/s limitation is due to the cheap Realtek mobo NIC,
and the 24MB/s is a Samba limit.  I've spent dozens of hours attempting
to tweak Samba to greater throughput but it simply isn't capable on that
machine.

Your throughput issues are with your network, not your RAID.  Learn and
use FIO to see what your RAID/disks can do.  For now a really simple
test is to time cat of a large file and pipe to /dev/null.  Divide the
file size by the elapsed time.  Or simply do a large read with dd.  This
will be much more informative than "moving data to a NAS", where your
throughput is network limited, not disk.

-- 
Stan
