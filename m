From: Veljko <veljko3@gmail.com>
Subject: Re: Linear device of two arrays
Date: Wed, 12 Jul 2017 12:21:25 +0200
Message-ID: <1b1d6d77-c17b-ada0-9a04-c724d34c9c1d@gmail.com>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
 <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org>
 <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com>
 <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org>
 <87van15j9b.fsf@notabene.neil.brown.name>
 <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

On 07/10/2017 01:03 PM, Veljko wrote:
> On 07/10/2017 12:37 AM, NeilBrown wrote:
>> I wasn't clear to me that I needed to chime in..  and the complete lack
>> of details (not even an "mdadm --examine" output), meant I could only
>> answer in vague generalizations.
>> However, seeing you asked.
>> If you really want to have a 'linear' of 2 RAID10s, then
>> 0/ unmount the xfs filesystem
>> 1/ backup the last few megabytes of the device
>>     dd if=/dev/mdXX of=/safe/place/backup bs=1M skip=$BIGNUM
>> 2/ create a linear array of the two RAID10s, ensuring the
>>    metadata is v1.0, and the dataoffset is zero (should be default with
>>    1.0)
>>     mdadm -C /dev/mdZZ -l linear -n 2 -e 1.0 --data-offset=0 /dev/mdXX
>> /dev/mdYY
>> 3/ restore the saved data
>>     dd of=/dev/mdZZ if=/safe/place/backup bs=1M seek=$BIGNUM
>> 4/ grow the xfs filesystem
>> 5/ be happy.
>>
>> I cannot comment on the values of "few" and "$BUGNUM" without seeing
>> specifics.
>>
>> NeilBrown
>
> Thanks for your response, Neil!
>
> md0 is boot (raid1), md1 is root (raid10) and md2 is data (raid10) that
> I need to expand. Here are details:
>
>
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Mon Sep 10 14:45:11 2012
>      Raid Level : raid1
>      Array Size : 488128 (476.77 MiB 499.84 MB)
>   Used Dev Size : 488128 (476.77 MiB 499.84 MB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Jul  3 11:57:24 2017
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>            Name : backup1:0  (local to host backup1)
>            UUID : e5a17766:b4df544d:c2770d6e:214113ec
>          Events : 302
>
>     Number   Major   Minor   RaidDevice State
>        2       8       18        0      active sync   /dev/sdb2
>        3       8       34        1      active sync   /dev/sdc2
>
>
> # mdadm --detail /dev/md1
> /dev/md1:
>         Version : 1.2
>   Creation Time : Fri Sep 14 12:39:00 2012
>      Raid Level : raid10
>      Array Size : 97590272 (93.07 GiB 99.93 GB)
>   Used Dev Size : 48795136 (46.53 GiB 49.97 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Jul 10 12:30:46 2017
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : near=2
>      Chunk Size : 512K
>
>            Name : backup1:1  (local to host backup1)
>            UUID : 91560d5a:245bbc56:cc08b0ce:9c78fea1
>          Events : 1003350
>
>     Number   Major   Minor   RaidDevice State
>        4       8       19        0      active sync set-A   /dev/sdb3
>        6       8       35        1      active sync set-B   /dev/sdc3
>        7       8       50        2      active sync set-A   /dev/sdd2
>        5       8        2        3      active sync set-B   /dev/sda2
>
>
> # mdadm --detail /dev/md2
> /dev/md2:
>         Version : 1.2
>   Creation Time : Fri Sep 14 12:40:13 2012
>      Raid Level : raid10
>      Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
>   Used Dev Size : 2880815616 (2747.36 GiB 2949.96 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Jul 10 12:32:51 2017
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : near=2
>      Chunk Size : 512K
>
>            Name : backup1:2  (local to host backup1)
>            UUID : f6eeaa57:a55f36ff:6980a62a:d4781e44
>          Events : 2689040
>
>     Number   Major   Minor   RaidDevice State
>        4       8       20        0      active sync set-A   /dev/sdb4
>        6       8       36        1      active sync set-B   /dev/sdc4
>        7       8       51        2      active sync set-A   /dev/sdd3
>        5       8        3        3      active sync set-B   /dev/sda3
>
>
> And here is examine output for md2 partitions:
>
> # mdadm --examine /dev/sda3
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : f6eeaa57:a55f36ff:6980a62a:d4781e44
>            Name : backup1:2  (local to host backup1)
>   Creation Time : Fri Sep 14 12:40:13 2012
>      Raid Level : raid10
>    Raid Devices : 4
>
>  Avail Dev Size : 5762609152 (2747.83 GiB 2950.46 GB)
>      Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
>   Used Dev Size : 5761631232 (2747.36 GiB 2949.96 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262064 sectors, after=977920 sectors
>           State : clean
>     Device UUID : 92beeec2:7ff92b1d:473a9641:2a078b16
>
>     Update Time : Mon Jul 10 12:35:53 2017
>        Checksum : d1abfc30 - correct
>          Events : 2689040
>
>          Layout : near=2
>      Chunk Size : 512K
>
>    Device Role : Active device 3
>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
>
>
> # mdadm --examine /dev/sdb4
> /dev/sdb4:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : f6eeaa57:a55f36ff:6980a62a:d4781e44
>            Name : backup1:2  (local to host backup1)
>   Creation Time : Fri Sep 14 12:40:13 2012
>      Raid Level : raid10
>    Raid Devices : 4
>
>  Avail Dev Size : 5761632256 (2747.36 GiB 2949.96 GB)
>      Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
>   Used Dev Size : 5761631232 (2747.36 GiB 2949.96 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262064 sectors, after=1024 sectors
>           State : clean
>     Device UUID : 01e1cb21:01a011a9:85761911:9b4d437a
>
>     Update Time : Mon Jul 10 12:37:00 2017
>        Checksum : ef9b6012 - correct
>          Events : 2689040
>
>          Layout : near=2
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
>
>
>
> # mdadm --examine /dev/sdc4
> /dev/sdc4:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : f6eeaa57:a55f36ff:6980a62a:d4781e44
>            Name : backup1:2  (local to host backup1)
>   Creation Time : Fri Sep 14 12:40:13 2012
>      Raid Level : raid10
>    Raid Devices : 4
>
>  Avail Dev Size : 5761632256 (2747.36 GiB 2949.96 GB)
>      Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
>   Used Dev Size : 5761631232 (2747.36 GiB 2949.96 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262064 sectors, after=1024 sectors
>           State : clean
>     Device UUID : 1a2c966f:a78ffaf3:83cf37d4:135087b7
>
>     Update Time : Mon Jul 10 12:37:53 2017
>        Checksum : 88b0f680 - correct
>          Events : 2689040
>
>          Layout : near=2
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
>
>
>
>
> # mdadm --examine /dev/sdd3
> /dev/sdd3:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : f6eeaa57:a55f36ff:6980a62a:d4781e44
>            Name : backup1:2  (local to host backup1)
>   Creation Time : Fri Sep 14 12:40:13 2012
>      Raid Level : raid10
>    Raid Devices : 4
>
>  Avail Dev Size : 5762609152 (2747.83 GiB 2950.46 GB)
>      Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
>   Used Dev Size : 5761631232 (2747.36 GiB 2949.96 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262064 sectors, after=977920 sectors
>           State : clean
>     Device UUID : 52f92e76:15228eee:a20c1ee5:8d4a17d2
>
>     Update Time : Mon Jul 10 12:38:24 2017
>        Checksum : b56275df - correct
>          Events : 2689040
>
>          Layout : near=2
>      Chunk Size : 512K
>
>    Device Role : Active device 2
>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)


Do you know what would be the "few" and "$BIGNUM" values from the output 
above?

Since I need to expand md2 device, I guess `that I need to subtract 
"few" number of megabytes as ($few x 1024 x 1024) in bytes from array 
size of md2 (in my case 5761631232). Is this correct? $BIGNUM is the 
size of md2 array? How to know how many megabytes needs to be backed up?

Data offset is not zero on md2 partitions. Is that a dealbreaker?

Would it be than better to reshape the current RAID10 to increase the 
number of devices used from 4 to 8 (as advised by Roman)?

Regards,
Veljko

