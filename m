From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Tue, 18 Sep 2012 16:20:57 -0500
Message-ID: <5058E5B9.8020000@hardwarefreak.com>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com> <5051DEC3.9050703@hardwarefreak.com> <CACY-59eJvv98xz_E-0qO_MGF8M40AZ-bCeXOA6zscd+HZdsy+g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACY-59eJvv98xz_E-0qO_MGF8M40AZ-bCeXOA6zscd+HZdsy+g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: GuoZhong Han <hanguozhong@meganovo.com>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

I'm copying the XFS list as this discussion has migrated more toward
filesystem/workload tuning.

On 9/18/2012 4:35 AM, GuoZhong Han wrote:
> Hi Stan:
>         Thanks for your advice. In your last mail, you mentioned XFS
> file system. According to your suggestion, I changed the file system
> from raid5 (4*2T, chunksize: 128K, strip_catch_size:2048) to XFS. The=
n
> I did a write performance test on XFS.
> The test was as follows:
>         My program used 4 threads to do parallel writing to 30 files
> with 1MB/s writing speed on each file. Each thread was bound on a
> single core. The estimated total speed should be stable at 30MB/s. I
> recorded the total writing speed every second in the test. Compared
> with speed of ext4, when the array was going to be full, the
> performance of XFS has indeed increased. The time to create the XFS
> file system was much less than the cost of ext4. However, I found tha=
t
> the total speed wasn=92t steady. Although most of time the speed can
> reach to 30M/s, it fell to only about 10MB/s in rare cases. Writing t=
o
> 30 files in parallel was supposed to be easy. Why did this happen?

We'll need more details of your test program and the kernel version
you're using, as well as the directory/file layout used in testing.
Your fstab entry for the filesystem, as well as xfs_info output, are
also needed.

In general, this type of behavior is due to the disks not being able to
seek quickly enough to satisfy all requests, causing latency, and thus
the dip in bandwidth.  Writing 30 files in parallel to 3x SATA stripe
members is going to put a large seek load on the disks.  If one of your
tests adds some metadata writes to this workload, the extra writes to
the journal and directory inodes may be enough to saturate the head
actuators.  Additionally, write barriers are enabled by default, and so
flushing of the drive caches after journal writes may be playing a role
here as well.


> 2012/9/13 Stan Hoeppner <stan@hardwarefreak.com>:
>> On 9/12/2012 10:21 PM, GuoZhong Han wrote:
>>
>>>          This system has a 36 cores CPU, the frequency of each core=
 is
>>> 1.2G.
>>
>> Obviously not an x86 CPU.  36 cores.  Must be a Tilera chip.
>>
>> GuoZhong, be aware that high core count systems are a poor match for
>> Linux md/RAID levels 1/5/6/10.  These md/RAID drivers currently util=
ize
>> a single write thread, and thus can only use one CPU core at a time.
>>
>> To begin to sufficiently scale these md array types across 36x 1.2GH=
z
>> cores you would need something like the following configurations, al=
l
>> striped together or concatenated with md or LVM:
>>
>> 72x md/RAID1 mirror pairs
>>  36x 4 disk RAID10 arrays
>>  36x 4 disk RAID6 ararys
>>  36x 3 disk RAID5 arrays
>>
>> Patches are currently being developed to increase the parallelism of
>> RAID1/5/6/10 but will likely not be ready for production kernels for
>> some time.   These patches will however still not allow scaling an
>> md/RAID driver across such a high core count.  You'll still need
>> multiple arrays to take advantage of 36 cores.  Thus, this 16 drive
>> storage appliance would have much better performance with a single/d=
ual
>> core CPU with a 2-3GHz clock speed.
>>
>>> The users can create a raid0, raid10
>>> and raid5 use the disks they designated.
>>
>> This is a storage appliance.  Due to the market you're targeting, th=
e
>> RAID level should be chosen by the manufacturer and not selectable b=
y
>> the user.  Choice is normally a good thing.  But with this type of
>> product, allowing users the choice of array type will simply cause y=
our
>> company may problems.  You will constantly field support issues abou=
t
>> actual performance not meeting expectations, etc.  And you don't wan=
t to
>> allow RAID5 under any circumstances for a storage appliance product.=
  In
>> this category, most users won't immediately replace failed drives, s=
o
>> you need to "force" the extra protection of RAID6 or RAID10 upon the
>> customer.
>>
>> If I were doing such a product, I'd immediately toss out the 36 core
>> logic platform and switch to a low power single/dual core x86 chip. =
 And
>> as much as I disdain parity RAID, for such an appliance I'd make RAI=
D6
>> the factory default, not changeable by the user.  Since md/RAID does=
n't
>> scale well across multicore CPUs, and because wide parity arrays yie=
ld
>> poor performance, I would make 2x 8 drive RAID6 arrays at the factor=
y,
>> concatenate them with md/RAID linear, and format the linear device w=
ith
>> XFS.  Manually force a 64KB chunk size for the RAID6 arrays.  You do=
n't
>> want the 512KB default in a storage appliance.  Specify stripe align=
ment
>> when formatting with XFS.  In this case, su=3D64K and sw=3D6.  See "=
man
>> mdadm" and "man mkfs.xfs".
>>
>>>          1. The system must support parallel write more than 150
>>> files; the speed of each will reach to 1M/s.
>>
>> For highly parallel write workloads you definitely want XFS.
>>
>>> If the array is full,
>>> wipe its data to re-write.
>>
>> What do you mean by this?  Surely you don't mean to arbitrarily eras=
e
>> user date to make room for more user data.
>>
>>>          2. Necessarily parallel the ability to read multiple files=
=2E
>>
>> Again, XFS best fits this requirement.
>>
>>>          3. as much as possible to use the storage space
>>
>> RAID6 is the best option here for space efficiency and resilience to
>> array failure.  RAID5 is asking for heartache, especially in an
>> appliance product, where users tend to neglect the box until it brea=
ks
>> to the point of no longer working.
>>
>>>          4. The system must have certain redundancy, when a disk
>>> failed, the users can use other disk instead of the failed disk.
>>
>> That's what RAID is for, so you're on the right track. ;)
>>
>>>          5. The system must support disk hot-swap
>>
>> That up to your hardware design.  Lots of pre-built solution already=
 on
>> the OEM market.
>>
>>>          I have tested the performance for write of 4*2T raid5 and
>>> 8*2T raid5 of which the file system is ext4, the chuck size is 128K
>>> and the strip_cache_size is 2048. At the beginning, these two raid5=
s
>>> worked well. But there was a same problem, when the array was going=
 to
>>> be full, the speeds of the write performance tend to slower, there
>>> were lots of data lost while parallel write 1M/s to 150 files.
>>
>> You shouldn't have lost data doing this.  That suggests some other
>> problem.  EXT4 is not particularly adept at managing free space
>> fragmentation.  XFS will do much better here.  But even with XFS,
>> depending on the workload and the "aging" of the filesystem, even XF=
S
>> will will slow down considerably when the filesystem approaches ~95%
>> full.  This obviously depends a bit on drive size and total array si=
ze
>> as well.  5% of a 12TB filesystem is quite less than a 36TB filesyst=
em,
>> 600GB vs 1.8TB.  And the degradation depends on what types of files
>> you're writing and how many in parallel to your nearly full XFS.
>>
>>>          As you said, the performance for write of 16*2T raid5 will=
 be
>>> terrible, so what do you think that how many disks to be build to a
>>> raid5 will be more appropriate?
>>
>> Again, do not use RAID5 for a storage appliance.  Use RAID6 instead,=
 and
>> use multiple RAID6 arrays concatenated together.
>>
>>>          I do not know whether I describe the requirement of the
>>> system accurately. I hope I can get your advice.
>>
>> You described it well, except for the part about wipe data and rewri=
te
>> when array is full.
>>
>> --
>> Stan
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
