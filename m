From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Thu, 13 Sep 2012 08:25:23 -0500
Message-ID: <5051DEC3.9050703@hardwarefreak.com>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: GuoZhong Han <hanguozhong@meganovo.com>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/12/2012 10:21 PM, GuoZhong Han wrote:

>          This system has a 36 cores CPU, the frequency of each core is
> 1.2G. 

Obviously not an x86 CPU.  36 cores.  Must be a Tilera chip.

GuoZhong, be aware that high core count systems are a poor match for
Linux md/RAID levels 1/5/6/10.  These md/RAID drivers currently utilize
a single write thread, and thus can only use one CPU core at a time.

To begin to sufficiently scale these md array types across 36x 1.2GHz
cores you would need something like the following configurations, all
striped together or concatenated with md or LVM:

72x md/RAID1 mirror pairs
 36x 4 disk RAID10 arrays
 36x 4 disk RAID6 ararys
 36x 3 disk RAID5 arrays

Patches are currently being developed to increase the parallelism of
RAID1/5/6/10 but will likely not be ready for production kernels for
some time.   These patches will however still not allow scaling an
md/RAID driver across such a high core count.  You'll still need
multiple arrays to take advantage of 36 cores.  Thus, this 16 drive
storage appliance would have much better performance with a single/dual
core CPU with a 2-3GHz clock speed.

> The users can create a raid0, raid10
> and raid5 use the disks they designated.

This is a storage appliance.  Due to the market you're targeting, the
RAID level should be chosen by the manufacturer and not selectable by
the user.  Choice is normally a good thing.  But with this type of
product, allowing users the choice of array type will simply cause your
company may problems.  You will constantly field support issues about
actual performance not meeting expectations, etc.  And you don't want to
allow RAID5 under any circumstances for a storage appliance product.  In
this category, most users won't immediately replace failed drives, so
you need to "force" the extra protection of RAID6 or RAID10 upon the
customer.

If I were doing such a product, I'd immediately toss out the 36 core
logic platform and switch to a low power single/dual core x86 chip.  And
as much as I disdain parity RAID, for such an appliance I'd make RAID6
the factory default, not changeable by the user.  Since md/RAID doesn't
scale well across multicore CPUs, and because wide parity arrays yield
poor performance, I would make 2x 8 drive RAID6 arrays at the factory,
concatenate them with md/RAID linear, and format the linear device with
XFS.  Manually force a 64KB chunk size for the RAID6 arrays.  You don't
want the 512KB default in a storage appliance.  Specify stripe alignment
when formatting with XFS.  In this case, su=64K and sw=6.  See "man
mdadm" and "man mkfs.xfs".

>          1. The system must support parallel write more than 150
> files; the speed of each will reach to 1M/s. 

For highly parallel write workloads you definitely want XFS.

> If the array is full,
> wipe its data to re-write.

What do you mean by this?  Surely you don't mean to arbitrarily erase
user date to make room for more user data.

>          2. Necessarily parallel the ability to read multiple files.

Again, XFS best fits this requirement.

>          3. as much as possible to use the storage space

RAID6 is the best option here for space efficiency and resilience to
array failure.  RAID5 is asking for heartache, especially in an
appliance product, where users tend to neglect the box until it breaks
to the point of no longer working.

>          4. The system must have certain redundancy, when a disk
> failed, the users can use other disk instead of the failed disk.

That's what RAID is for, so you're on the right track. ;)

>          5. The system must support disk hot-swap

That up to your hardware design.  Lots of pre-built solution already on
the OEM market.

>          I have tested the performance for write of 4*2T raid5 and
> 8*2T raid5 of which the file system is ext4, the chuck size is 128K
> and the strip_cache_size is 2048. At the beginning, these two raid5s
> worked well. But there was a same problem, when the array was going to
> be full, the speeds of the write performance tend to slower, there
> were lots of data lost while parallel write 1M/s to 150 files.

You shouldn't have lost data doing this.  That suggests some other
problem.  EXT4 is not particularly adept at managing free space
fragmentation.  XFS will do much better here.  But even with XFS,
depending on the workload and the "aging" of the filesystem, even XFS
will will slow down considerably when the filesystem approaches ~95%
full.  This obviously depends a bit on drive size and total array size
as well.  5% of a 12TB filesystem is quite less than a 36TB filesystem,
600GB vs 1.8TB.  And the degradation depends on what types of files
you're writing and how many in parallel to your nearly full XFS.

>          As you said, the performance for write of 16*2T raid5 will be
> terrible, so what do you think that how many disks to be build to a
> raid5 will be more appropriate?

Again, do not use RAID5 for a storage appliance.  Use RAID6 instead, and
use multiple RAID6 arrays concatenated together.

>          I do not know whether I describe the requirement of the
> system accurately. I hope I can get your advice.

You described it well, except for the part about wipe data and rewrite
when array is full.

-- 
Stan

