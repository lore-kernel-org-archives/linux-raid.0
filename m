From: daobang wang <wangdb1981@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sun, 1 Apr 2012 10:05:17 +0800
Message-ID: <CACwgYDNitxymtLT3SMw6m0_utqAzXPsOT5Y1CpwrjW1fN+xuqA@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
	<4F776492.4070600@hardwarefreak.com>
	<CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

There is another problem occurred, it seems that the file system was
damaged when the pressure is very high, it reported input/output error
when i typed ls or other command, and I tried to repair it with
xfs_repair /dev/vg00/lv0000, the xfs_repir alloc memory failed, we
have 4GB memory on the machine, and the logical volume was a little
more than 15TB, Could it be repair successfully if we have enough
memory?

Thank you very much!

Best Wishes,
Daobang Wang.

On 4/1/12, daobang wang <wangdb1981@gmail.com> wrote:
> Thanks to Mathias and stan, Here is the detail of the configuration.
>
> 1. RAID5 with 8 2TB ST32000644NS disks , i can extend to 16 disks.
> the RAID5 created with Chunk Size of 64K and left-symmetric
>
> 2. Volume Group on RAID5 with full capacity
>
> 3. Logical Volume on the Volume Group with full capacity
>
> 4. XFS filesystem created on the Logical Volume with option "-f -i
> size=3D512", and mount option is "-t xfs -o
> defaults,usrquota,grpquota,noatime,nodiratime,nobarrier,delaylog,logb=
size=3D262144",
>
> 5. The real application is 200 D1(2Mb/s) video streams write 500MB
> files on the XFS.
>
> This is the pressure testing, just verify the reliability of the
> system, we will not use it in real envrionment, 100 video streams
> writen is our goal. is there any clue for optimize the application?
>
> Thank you very much.
>
> Best Regards,
> Daobang Wang.
>
> On 4/1/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 3/31/2012 2:59 AM, Mathias Bur=E9n wrote:
>>> On 31 March 2012 02:22, daobang wang <wangdb1981@gmail.com> wrote:
>>>> Hi ALL,
>>>>
>>>>    How to adjust the xfs and raid parameters to improve the total
>>>> performance when RAID5 created by 8 disks works with xfs, and i wr=
ited
>>>> a test program, which started 100 threads to write big files, 500M=
B
>>>> per file, and delete it after writing finish. Thank you very much.
>>>>
>>>> Best Wishes,
>>>> Daobang Wang.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> Hi,
>>>
>>> See
>>> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesyste=
ms_for_.3Csomething.3E
>>> . Also see http://hep.kbfi.ee/index.php/IT/KernelTuning . For examp=
le,
>>> RAID5 with 8 harddrives and 64K stripe size:
>>>
>>> mkfs.xfs -d su=3D64k,sw=3D7 -l version=3D2,su=3D64k /dev/md0
>>
>> This is unnecessary.  mkfs.xfs creates w/stripe alignment automatica=
lly
>> when the target device is an md device.
>>
>>> Consider mounting the filesystem with logbufs=3D8,logbsize=3D256k
>>
>> This is unnecessary for two reasons:
>>
>> 1.  These are the default values in recent kernels
>> 2.  His workload is the opposite of "metadata heavy"
>>     logbufs and logbsize exist for metadata operations
>>     to the journal, they are in memory journal write buffers
>>
>> The OP's stated workload is 100 streaming writes of 500MB files.  Th=
is
>> is not anything close to a sane, real world workload.  Writing 100 x
>> 500MB files in parallel to 7 spindles is an exercise in stupidity, a=
nd
>> especially to a RAID5 array with only 7 spindles.  The OP is pushing
>> those drives to their seek limit of about 150 head seeks/sec without
>> actually writing much data, and *that* is what is ruining his
>> performance.  What *should* be a streaming write workload of large f=
iles
>> has been turned into a massively random IO pattern due mostly to the
>> unrealistic write thread count, and partly to disk striping and the =
way
>> XFS allocation groups are created on a striped array.
>>
>> Assuming these are 2TB drives, to get much closer to ideal write
>> performance, and make this more of a streaming workload, what the OP
>> should be doing is writing no more than 8 files in parallel to at le=
ast
>> 8 different directories with XFS sitting on an md linear array of 4 =
md
>> RAID1 devices, assuming he needs protection from drive failure *and*
>> parallel write performance:
>>
>> $ mdadm -C /dev/md0 -l 1 -n 2 /dev/sd[ab]
>> $ mdadm -C /dev/md1 -l 1 -n 2 /dev/sd[cd]
>> $ mdadm -C /dev/md2 -l 1 -n 2 /dev/sd[ef]
>> $ mdadm -C /dev/md3 -l 1 -n 2 /dev/sd[gh]
>> $ mdadm -C /dev/md4 -l linear -n 4 /dev/md[0-3]
>> $ mkfs.xfs -d agcount=3D8 /dev/md4
>>
>> and mount with the inode64 option in fstab so we get the inode64
>> allocator, which spreads the metadata across all of the AGs instead =
of
>> stuffing in all in the first AG and yields other benefits.
>>
>> This setup eliminates striping, tons of head seeks, and gets much cl=
oser
>> to pure streaming write performance.  Writing 8 files in parallel to=
 8
>> directories will cause XFS to put each file in a different allocatio=
n
>> group.  Since we created 8 AGs, this means we'll have 2 files being
>> written to each disk in parallel.  This reduces time wasted in head =
seek
>> latency by an order of magnitude and will dramatically increase disk
>> throughput in MB/s compared to the 100 files in parallel workload, w=
hich
>> again is simply stupid to do on this limited disk hardware.
>>
>> This 100 file parallel write workload needs about 6 times as many
>> spindles to be realistic, configured as a linear array of 24 RAID1
>> devices and formatted with 48 AGs.  This would give you ~4 write str=
eams
>> per drive, 2 per AG, or somewhere around 50% to 66% of the per drive
>> performance compared to the 8 drive 8 thread scenario I recommended
>> above.
>>
>> Final note:  It is simply not possible to optimize XFS nor mdraid to=
 get
>> you any better performance when writing 100 x 500MB files in paralle=
l.
>> The lack of sufficient spindles is the problem.
>>
>> --
>> Stan
>>
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
