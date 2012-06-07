From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 with two drive sizes question
Date: Wed, 06 Jun 2012 19:39:39 -0500
Message-ID: <4FCFF84B.8030705@hardwarefreak.com>
References: <4FCE4199.7030705@gmx.net> <20120605233953.2086cc4c@natsu> <4FCE60F3.4040606@gmx.net> <20120606015950.585d5454@natsu> <4FCE6DCD.7030207@hardwarefreak.com> <20120606101627.5cf8ecbc@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120606101627.5cf8ecbc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: "Joachim Otahal (privat)" <Jou@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/5/2012 11:16 PM, Roman Mamedov wrote:
> On Tue, 05 Jun 2012 15:36:29 -0500
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>>> Except this would not make any sense even as a thought experiment. You don't
>>> want a configuration where two or more areas of the same physical disk need to
>>> be accessed in parallel for any read or write to the volume. And it's pretty
>>> easy to avoid that.
>>
>> You make a good point but your backing argument is incorrect:  XFS by
>> design, by default, writes to 4 equal sized regions of a disk in parallel.
> 
> I said: "...need to be accessed in parallel for any read or write".
> 
> With XFS you mean allocation groups, however I don't think that if you write
> any large file sequentially to XFS, it will always cause drive's head to jump
> around between four areas because the file is written "in parallel", striped
> to four different locations, which is the main problem that we're trying to
> avoid.

It depends on which allocator you use.  Inode32, the default allocator,
can cause a sufficiently large file's blocks to be rotored across all
AGs in parallel.  Inode64 writes one file to one AG.

> XFS allocation groups are each a bit like an independent filesystem, 

This analogy may be somewhat relevant to the Inoe64 allocator, which
stores directory metadata for a file in the same AG where the file is
stored.  But it definitely does not describe the Inode32 allocator
behavior, which stores all metadata in the first 1TB of the FS, and all
file extents above 1TB.  Dependent on the total FS size, obviously.  I
described the maximal design case here where the FS is hard limited to 16TB.

> to allow
> for some CPU- and RAM-access-level parallelization. 

The focus of the concurrency mechanisms in XFS have always been on
maximizing disk array performance and flexibility with very large disk
counts and large numbers of concurrent accesses.  Much of the parallel
CPU/mem locality efficiency is a side effect of this, not the main
target of the efforts, though there have been some of these.

> However spinning devices
> and even SSDs can't really read or write quickly enough "in parallel", so
> parallel access to different areas of the same device is used in XFS not for
> *any read or write*, but only in those cases where that can be beneficial for
> performance 

I just reread that 4 times.  If I'm correctly reading what you stated,
then you are absolutely not correct.  Please read about XFS allocation
group design:

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Allocation_Groups.html

and behavior of the allocators:

http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/xfs-allocators.html

> -- and even then, likely managed carefully either by XFS or by

XFS is completely unaware of actuator placement or any such parameters
internal to a block device.  It operates above the block layer.  It is
after all a filesystem.

> lower level of I/O schedulers to minimize head movements.

The Linux elevators aren't going to be able to minimize actuator
movement to much degree in this scenario, if/when there is concurrent
full stripe write access in all md arrays on the drives.  This problem
will likely be further exacerbated if XFS is the filesystem used on each
array.  By default mkfs.xfs creates 16 AGs if the underlying device is a
striped md array.  Thus...

If you have 4 drives and 4 md RAID 10 arrays across 4 partitions on the
drives, then format each with mkfs.xfs defaults, you end up with 64 AGs
in 4 XFS filesystems.  With the default Inode32 allocator, you could end
up with 4 concurrent file writes causing 64 actuator seeks per disk.
With average 7.2k SATA drives this takes about 0.43 seconds to write 64
sectors, 32KB, to each drive, almost half a second for each 128KB
written to all arrays concurrently, 1 second to write 256KB across 4
disks.  If you used a single md RAID 10 array, you cut your seek load by
a factor of 4.

Now, there are ways to manually tweak such a setup to reduce the number
of AGs and thus seeks, but this is only one of multiple reasons not use
to multiple striped md arrays on the same set of disks, which was/is my
original argument.

-- 
Stan
