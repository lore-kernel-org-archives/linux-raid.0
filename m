From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Spare disk not becoming active
Date: Mon, 24 Dec 2012 09:03:04 -0600
Message-ID: <CAAMCDeeRx-6NeSZTn13USG+KkOFZ8EXD37voo0BqnJRHiuzMwA@mail.gmail.com>
References: <50BBEC7E.7080200@smartguide.com.au> <CAAMCDefzx+eDVRqqX0kDz-xD-inzTYChLi=BvmViaMej-3iXLA@mail.gmail.com>
 <50D8033E.9040006@smartguide.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50D8033E.9040006@smartguide.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Tudor Holton <tudor@smartguide.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 24, 2012 at 1:24 AM, Tudor Holton <tudor@smartguide.com.au> wrote:
> On 20/12/12 11:03, Roger Heflin wrote:
>>
>> On Sun, Dec 2, 2012 at 6:04 PM, Tudor Holton <tudor@smartguide.com.au>
>> wrote:
>>>
>>> Hallo,
>>>
>>> I'm having some trouble with an array I have that has become degraded.
>>>
>>> I have an array with this array state:
>>>
>>> md101 : active raid1 sdf1[0] sdb1[2](S)
>>>        1953511936 blocks [2/1] [U_]
>>>
>>>
>>> mdadm --detail says:
>>>
>>> /dev/md101:
>>>          Version : 0.90
>>>    Creation Time : Thu Jan 13 14:34:27 2011
>>>       Raid Level : raid1
>>>       Array Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>>    Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>>     Raid Devices : 2
>>>    Total Devices : 2
>>> Preferred Minor : 101
>>>      Persistence : Superblock is persistent
>>>
>>>      Update Time : Fri Nov 23 03:23:04 2012
>>>            State : clean, degraded
>>>   Active Devices : 1
>>> Working Devices : 2
>>>   Failed Devices : 0
>>>    Spare Devices : 1
>>>
>>>             UUID : 43e92a79:90295495:0a76e71e:56c99031 (local to host
>>> barney)
>>>           Events : 0.2127
>>>
>>>      Number   Major   Minor   RaidDevice State
>>>         0       8       81        0      active sync /dev/sdf1
>>>         1       0        0        1      removed
>>>
>>>         2       8       17        -      spare   /dev/sdb1
>>>
>>>
>>> If I attempt to force the spare to become active it begins to recover:
>>> $ sudo mdadm -S /dev/md101
>>> mdadm: stopped /dev/md101
>>> $ sudo mdadm --assemble --force --no-degraded /dev/md101 /dev/sdf1
>>> /dev/sdb1
>>> mdadm: /dev/md101 has been started with 1 drive (out of 2) and 1 spare.
>>> $ cat /proc/mdstat
>>> md101 : active raid1 sdf1[0] sdb1[2]
>>>        1953511936 blocks [2/1] [U_]
>>>        [>....................]  recovery =  0.0% (541440/1953511936)
>>> finish=420.8min speed=77348K/sec
>>>
>>> This runs for the allotted time but returns to the state of spare.
>>>
>>> Neither disk partition report errors:
>>> $ cat /sys/block/md101/md/dev-sdf1/errors
>>> 0
>>> $ cat /sys/block/md101/md/dev-sdb1/errors
>>> 0
>>>
>>> Are there mdadm logs to find out why this is not recovering properly?
>>> How
>>> otherwise do I debug this?
>>>
>>> Cheers,
>>> Tudor.
>>
>> Did you look in the various /var/log/messages (current and previous
>> ones) to see what it indicated happened the about the time it
>> completed?
>>
>> There is almost certainly something in there indicating what went wrong.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Thanks.  I watched the logs messages during the recovery.  During the last
> 0.1% (at 99.9%) messages like this appeared:
> Dec 24 18:20:32 barney kernel: [2796835.703313] sd 2:0:0:0: [sdf] Unhandled
> sense code
> Dec 24 18:20:32 barney kernel: [2796835.703316] sd 2:0:0:0: [sdf] Result:
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Dec 24 18:20:32 barney kernel: [2796835.703320] sd 2:0:0:0: [sdf] Sense Key
> : Medium Error [current] [descriptor]
> Dec 24 18:20:32 barney kernel: [2796835.703325] Descriptor sense data with
> sense descriptors (in hex):
> Dec 24 18:20:32 barney kernel: [2796835.703327]         72 03 11 04 00 00 00
> 0c 00 0a 80 00 00 00 00 00
> Dec 24 18:20:32 barney kernel: [2796835.703335]         e8 e0 5f 86
> Dec 24 18:20:32 barney kernel: [2796835.703339] sd 2:0:0:0: [sdf] Add.
> Sense: Unrecovered read error - auto reallocate failed
> Dec 24 18:20:32 barney kernel: [2796835.703345] sd 2:0:0:0: [sdf] CDB:
> Read(10): 28 00 e8 e0 5f 7f 00 00 08 00
> Dec 24 18:20:32 barney kernel: [2796835.703353] end_request: I/O error, dev
> sdf, sector 3907018630
> Dec 24 18:20:32 barney kernel: [2796835.703366] ata3: EH complete
> Dec 24 18:20:32 barney kernel: [2796835.703383] md/raid1:md101: sdf:
> unrecoverable I/O read error for block 3907018496
>
> Unfortunately, sdf is the active disk in this case.  So I guess my only
> option left is to create a new array and copy as much over as it will let
> me?

If you are lucky that may be an unused area of the fs and you may not lose
any data at all.    Worse case is you will probably lose a couple of
files, the way
to tell which you lost is when you read the files with the bad block
you will get an
io error.

I don't know if there is a better way, but the process you mentioned is probably
reasonable (build a new one and copy all of the data over), then add
the bad disk
back to the new mirror and it will build back in, since it is writing
it will write to
that block and either correct the error or the disk will relocate the
sector if the sector
is too bad.

One you have the array rebuild, make sure on the new array to do check
either 1x
per month or 1x per week (man md - see section on scrubbing), if you
were not doing
this before then a "sector" can slowly go bad and is never read so the
disk (if the
disk is not doing test reads) won't know the sector is going bad until
something
like a rebuild happens and that is too late, if the disk is forced to
read it or is scanning
itself then the disk will find and relocate (or rewrite) the sector
before it is completely bad.
