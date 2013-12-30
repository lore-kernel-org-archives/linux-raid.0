From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is partition alignment needed for RAID partitions ?
Date: Mon, 30 Dec 2013 04:49:28 -0600
Message-ID: <52C14FB8.8080005@hardwarefreak.com>
References: <52C08E63.8020800@insync.za.net> <52C11929.3070600@hardwarefreak.com> <52C12F8B.6080507@insync.za.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C12F8B.6080507@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/30/2013 2:32 AM, Pieter De Wit wrote:
> Hi Stan,
> 
> Thanks for the long email (I didn't know about advance formatting for
> one) - please see my answers inline.
> 
> On 30/12/2013 19:56, Stan Hoeppner wrote:
>> On 12/29/2013 3:04 PM, Pieter De Wit wrote:
>>> <snip>
>>> So my question is, do I need to align the partitions for the raid
>>> devices ?
>> <snip>
>> Are these 2TB Advanced Format drives?  If so your partitions need to
>> align to 4KiB boundaries, otherwise you'll have RMW within each drive
>> which can cut your write throughput by 30-50%.
> Yes - these drives are, parted printed:
> 
> Model: ATA WDC WD20EARX-008 (scsi)
> Disk /dev/sdb: 3907029168s
> Sector size (logical/physical): 512B/4096B
> Partition Table: gpt
> 
> Number  Start       End          Size         File system  Name Flags
>  1      2048s       500000767s   499998720s raid
>  2      500000768s  3907028991s  3407028224s raid
> 
>> <snip>
> So given your comments then, the start of partition 1 is correct. The
> start of partition 2 is also correct (not sure if this is needed), but
> the size of partition 2 is incorrect, it should be 3406823424s ?

Size is incorrect in what way?  If your RAID0 chunk is 512KiB, then
3407028224 sectors is 3327176 chunks, evenly divisible, so this
partition is fully aligned.  Whether the capacity is correct is
something only you can determine.  Partition 2 is 1.587 TiB.

>> You're comparing apples to oranges to grapes below, and your description
>> lacks any level of technical detail.  How are we supposed to analyze
>> this?
>>
>>> These are desktop grade drives, but for the RAID0 device I saw quite low
>>> throughput (15meg/sec moving data to the NAS via gig connection). I just
>> "15meg/sec moving data" means what, a bulk file transfer from a local
>> filesystem to a remote filesystem?  What types of files?  Lots of small
>> ones?  Of course throughput will be low.  Is the local filesystem
>> fragmented?  Even slower.
> It's all done with pvmove, which moves 4meg chunks.

I'm not intending to be jerk, but this is a technical mailing list.  You
need to be precise so others understand EXACTLY what you're stating.
Your choice of words above suggests you -first- used NFS or CIFS and it
was slow at 15 'meg'/sec (please use MB or MiB appropriately).  "NAS" is
Network Attached Storage.  The two protocols nearly exclusively used to
communicate with a NAS device are NFS and CIFS.

What you typed may make perfect sense to YOU, but to your audience it is
thoroughly misleading.

>>> created a RAID1 device between /dev/sda and an iSCSI target on the NAS,
>>> and it synced at 48meg/sec, moving data at 30meg/sec - double that of
>>> the RAID0 device.
>> This is block device data movement.  There is no filesystem overhead, no
>> fragmentation causing excess seeks, and no NFS/CIFS overhead on either
>> end.  Of course it will be faster.
> It was all done with pvmove :)

-Second- you explicitly state here that you then created a RAID1 between
sda and an iSCSI target and achieved 3x the throughput, suggesting that
this is different than the case above.

Again, what you typed may make perfect sense to YOU, but to your
audience it is misleading, because you didn't clearly state the
configuration the first statement describes.

So all of this was done over iSCSI, correct?

Without further data I can only make a wild ass guess as to why the
RAID0 device was slower than the single disk during this -single
operation- you described that involves a network.  You didn't post
throughput numbers for the RAID0 doing a local operation so there's
nothing to compare to.  It could be due to a dozen different things.  A few?

1.  Concurrent disk access at the host
2.  Concurrent disk access/load at the NAS box
3.  One/both of the host EARX drives is flaky causing high latency
4.  Flaky GbE HBA or switch port
etc

Show your partition table for sdc.  Even if the partitions on it are not
aligned, reads shouldn't be adversely affected by it.  Show

$ mdadm --detail

for the RAID0 array.  md itself, especially in RAID0 personality, is
simply not going to be the -cause- of low performance.  The problem lay
somewhere else.  Given the track record of Western Digital's Green
series of drives I'm leaning toward that cause.  Post output from

$ smartctl -A /dev/sdb
$ smartctl -A /dev/sdc

>>> I would have expected the RAID0 device to easily get
>>> up to the 60meg/sec mark ?
>> As the source disk of a bulk file copy over NFS/CIFS?  As a point of
>> reference, I have a workstation that maxes 50MB/s FTP and only 24MB/s
>> CIFS to/from a server.  Both hosts have far in excess of 100MB/s disk
>> throughput.  The 50MB/s limitation is due to the cheap Realtek mobo NIC,
>> and the 24MB/s is a Samba limit.  I've spent dozens of hours attempting
>> to tweak Samba to greater throughput but it simply isn't capable on that
>> machine.
>>
>> Your throughput issues are with your network, not your RAID.  Learn and
>> use FIO to see what your RAID/disks can do.  For now a really simple
>> test is to time cat of a large file and pipe to /dev/null.  Divide the
>> file size by the elapsed time.  Or simply do a large read with dd.  This
>> will be much more informative than "moving data to a NAS", where your
>> throughput is network limited, not disk.
>>
> The system is using a server grade NIC, I will run a dd/network test
> shortly after the copy is done. (I am shifting all the data back to the
> NAS, incase I mucked up the partitions :) ), I do recall that this
> system was able to fill a gig pipe...

Now that you've made it clear the first scenario was over iSCSI same as
the 2nd scenario, and not NFS/CIFS, I doubt the TCP stack is the
problem.  Assume the network is fine for now and concentrate on the disk
drives in the host.  That's seems the most likely cause of the problem
at this point.

BTW, you didn't state the throughput of the RAID1 device on sdb/sdc.
The RAID0 device is on the same disks, yes?  RAID0 was 15 MB/s.  What
was the RAID1?

-- 
Stan
