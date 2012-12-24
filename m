From: Tudor Holton <tudor@smartguide.com.au>
Subject: Re: Spare disk not becoming active
Date: Mon, 24 Dec 2012 18:24:46 +1100
Message-ID: <50D8033E.9040006@smartguide.com.au>
References: <50BBEC7E.7080200@smartguide.com.au> <CAAMCDefzx+eDVRqqX0kDz-xD-inzTYChLi=BvmViaMej-3iXLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDefzx+eDVRqqX0kDz-xD-inzTYChLi=BvmViaMej-3iXLA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/12/12 11:03, Roger Heflin wrote:
> On Sun, Dec 2, 2012 at 6:04 PM, Tudor Holton <tudor@smartguide.com.au> wrote:
>> Hallo,
>>
>> I'm having some trouble with an array I have that has become degraded.
>>
>> I have an array with this array state:
>>
>> md101 : active raid1 sdf1[0] sdb1[2](S)
>>        1953511936 blocks [2/1] [U_]
>>
>>
>> mdadm --detail says:
>>
>> /dev/md101:
>>          Version : 0.90
>>    Creation Time : Thu Jan 13 14:34:27 2011
>>       Raid Level : raid1
>>       Array Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>    Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>     Raid Devices : 2
>>    Total Devices : 2
>> Preferred Minor : 101
>>      Persistence : Superblock is persistent
>>
>>      Update Time : Fri Nov 23 03:23:04 2012
>>            State : clean, degraded
>>   Active Devices : 1
>> Working Devices : 2
>>   Failed Devices : 0
>>    Spare Devices : 1
>>
>>             UUID : 43e92a79:90295495:0a76e71e:56c99031 (local to host barney)
>>           Events : 0.2127
>>
>>      Number   Major   Minor   RaidDevice State
>>         0       8       81        0      active sync /dev/sdf1
>>         1       0        0        1      removed
>>
>>         2       8       17        -      spare   /dev/sdb1
>>
>>
>> If I attempt to force the spare to become active it begins to recover:
>> $ sudo mdadm -S /dev/md101
>> mdadm: stopped /dev/md101
>> $ sudo mdadm --assemble --force --no-degraded /dev/md101 /dev/sdf1 /dev/sdb1
>> mdadm: /dev/md101 has been started with 1 drive (out of 2) and 1 spare.
>> $ cat /proc/mdstat
>> md101 : active raid1 sdf1[0] sdb1[2]
>>        1953511936 blocks [2/1] [U_]
>>        [>....................]  recovery =  0.0% (541440/1953511936)
>> finish=420.8min speed=77348K/sec
>>
>> This runs for the allotted time but returns to the state of spare.
>>
>> Neither disk partition report errors:
>> $ cat /sys/block/md101/md/dev-sdf1/errors
>> 0
>> $ cat /sys/block/md101/md/dev-sdb1/errors
>> 0
>>
>> Are there mdadm logs to find out why this is not recovering properly?  How
>> otherwise do I debug this?
>>
>> Cheers,
>> Tudor.
> Did you look in the various /var/log/messages (current and previous
> ones) to see what it indicated happened the about the time it
> completed?
>
> There is almost certainly something in there indicating what went wrong.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks.  I watched the logs messages during the recovery.  During the 
last 0.1% (at 99.9%) messages like this appeared:
Dec 24 18:20:32 barney kernel: [2796835.703313] sd 2:0:0:0: [sdf] 
Unhandled sense code
Dec 24 18:20:32 barney kernel: [2796835.703316] sd 2:0:0:0: [sdf] 
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Dec 24 18:20:32 barney kernel: [2796835.703320] sd 2:0:0:0: [sdf] Sense 
Key : Medium Error [current] [descriptor]
Dec 24 18:20:32 barney kernel: [2796835.703325] Descriptor sense data 
with sense descriptors (in hex):
Dec 24 18:20:32 barney kernel: [2796835.703327]         72 03 11 04 00 
00 00 0c 00 0a 80 00 00 00 00 00
Dec 24 18:20:32 barney kernel: [2796835.703335]         e8 e0 5f 86
Dec 24 18:20:32 barney kernel: [2796835.703339] sd 2:0:0:0: [sdf] Add. 
Sense: Unrecovered read error - auto reallocate failed
Dec 24 18:20:32 barney kernel: [2796835.703345] sd 2:0:0:0: [sdf] CDB: 
Read(10): 28 00 e8 e0 5f 7f 00 00 08 00
Dec 24 18:20:32 barney kernel: [2796835.703353] end_request: I/O error, 
dev sdf, sector 3907018630
Dec 24 18:20:32 barney kernel: [2796835.703366] ata3: EH complete
Dec 24 18:20:32 barney kernel: [2796835.703383] md/raid1:md101: sdf: 
unrecoverable I/O read error for block 3907018496

Unfortunately, sdf is the active disk in this case.  So I guess my only 
option left is to create a new array and copy as much over as it will 
let me?

Cheers,
Tudor.
