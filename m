From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Is partition alignment needed for RAID partitions ?
Date: Mon, 30 Dec 2013 21:32:11 +1300
Message-ID: <52C12F8B.6080507@insync.za.net>
References: <52C08E63.8020800@insync.za.net> <52C11929.3070600@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C11929.3070600@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Stan,

Thanks for the long email (I didn't know about advance formatting for 
one) - please see my answers inline.

On 30/12/2013 19:56, Stan Hoeppner wrote:
> On 12/29/2013 3:04 PM, Pieter De Wit wrote:
>> <snip>
>> So my question is, do I need to align the partitions for the raid devices ?
> <snip>
> Are these 2TB Advanced Format drives?  If so your partitions need to
> align to 4KiB boundaries, otherwise you'll have RMW within each drive
> which can cut your write throughput by 30-50%.
Yes - these drives are, parted printed:

Model: ATA WDC WD20EARX-008 (scsi)
Disk /dev/sdb: 3907029168s
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start       End          Size         File system  Name Flags
  1      2048s       500000767s   499998720s raid
  2      500000768s  3907028991s  3407028224s raid

> <snip>
So given your comments then, the start of partition 1 is correct. The 
start of partition 2 is also correct (not sure if this is needed), but 
the size of partition 2 is incorrect, it should be 3406823424s ?
>
> You're comparing apples to oranges to grapes below, and your description
> lacks any level of technical detail.  How are we supposed to analyze this?
>
>> These are desktop grade drives, but for the RAID0 device I saw quite low
>> throughput (15meg/sec moving data to the NAS via gig connection). I just
> "15meg/sec moving data" means what, a bulk file transfer from a local
> filesystem to a remote filesystem?  What types of files?  Lots of small
> ones?  Of course throughput will be low.  Is the local filesystem
> fragmented?  Even slower.
It's all done with pvmove, which moves 4meg chunks
>
>> created a RAID1 device between /dev/sda and an iSCSI target on the NAS,
>> and it synced at 48meg/sec, moving data at 30meg/sec - double that of
>> the RAID0 device.
> This is block device data movement.  There is no filesystem overhead, no
> fragmentation causing excess seeks, and no NFS/CIFS overhead on either
> end.  Of course it will be faster.
It was all done with pvmove :)
>
>> I would have expected the RAID0 device to easily get
>> up to the 60meg/sec mark ?
> As the source disk of a bulk file copy over NFS/CIFS?  As a point of
> reference, I have a workstation that maxes 50MB/s FTP and only 24MB/s
> CIFS to/from a server.  Both hosts have far in excess of 100MB/s disk
> throughput.  The 50MB/s limitation is due to the cheap Realtek mobo NIC,
> and the 24MB/s is a Samba limit.  I've spent dozens of hours attempting
> to tweak Samba to greater throughput but it simply isn't capable on that
> machine.
>
> Your throughput issues are with your network, not your RAID.  Learn and
> use FIO to see what your RAID/disks can do.  For now a really simple
> test is to time cat of a large file and pipe to /dev/null.  Divide the
> file size by the elapsed time.  Or simply do a large read with dd.  This
> will be much more informative than "moving data to a NAS", where your
> throughput is network limited, not disk.
>
The system is using a server grade NIC, I will run a dd/network test 
shortly after the copy is done. (I am shifting all the data back to the 
NAS, incase I mucked up the partitions :) ), I do recall that this 
system was able to fill a gig pipe...

Thanks,

Pieter
