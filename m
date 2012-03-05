From: John Adams <john.adams@avid.com>
Subject: Re: What are these reads in what should be simply a full-stripe
 write?
Date: Mon, 5 Mar 2012 16:29:03 +0000
Message-ID: <042AD485-2698-4FBF-BF1C-00546C94EE20@avid.com>
References: <FC0D60DF-6357-495C-B10A-1C727AAFCBE3@avid.com>
 <4F4D5FE9.7090301@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4D5FE9.7090301@fastmail.fm>
Content-Language: en-US
Content-ID: <1AE112639BBE7D4799FA300392C28070@avid.com>
Sender: linux-raid-owner@vger.kernel.org
To: linbloke <linbloke@fastmail.fm>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you for commenting.  Here is the info you requested.

mdadm - v3.2.2 - 17th June 2011
Linux jadams-sbb 2.6.32-131.12.1.hulk.avidnl.1.x86_64.debug #2 SMP Thu Feb 16 11:32:09 EST 2012 x86_64 x86_64 x86_64 GNU/Linux
/dev/md0:
        Version : 1.2
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
     Array Size : 838860800 (800.00 GiB 858.99 GB)
  Used Dev Size : 104857600 (100.00 GiB 107.37 GB)
   Raid Devices : 10
  Total Devices : 10
    Persistence : Superblock is persistent

    Update Time : Mon Mar  5 12:35:11 2012
          State : clean 
 Active Devices : 10
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : jadams-sbb:0  (local to host jadams-sbb)
           UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
         Events : 62

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi
       8       8      144        8      active sync   /dev/sdj
       9       8      160        9      active sync   /dev/sdk
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 26854371:b12034ac:d4119d00:5d1b8f1a

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : c3dfa790 - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 04d4a4aa:dd376906:c3e479a0:cfbae1bb

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : 98a57ffd - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 67d2b514:3fd5f360:73222322:97888b7b

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : 9e94273a - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 81c96b5b:2a944dd0:fb069b36:b1fb4660

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : 4dd734e3 - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4741b8b0:2e0e0c73:bc4ff323:5f653d70

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : 4330d91d - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 4
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4ff9f259:2781af76:b427d4c4:af50651a

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : 3b17c767 - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 5
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3c04b3f7:df628911:b47e2dec:a9eabecd

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : 4e64a508 - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 6
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 13c8ac51:5fd71796:7b385c45:8c31990e

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : c6f5de08 - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 7
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9be300f7:97329a54:3c86ec36:9dedd667

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : 759a5e9c - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)
/dev/sdk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3ac47570:b9b222e0:8e09eb62:4071de0a
           Name : jadams-sbb:0  (local to host jadams-sbb)
  Creation Time : Fri Feb 17 19:39:25 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 1677721600 (800.00 GiB 858.99 GB)
  Used Dev Size : 209715200 (100.00 GiB 107.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ada0d14e:ad9c3d6b:4ba27221:fe6ea679

    Update Time : Mon Mar  5 12:35:42 2012
       Checksum : e0642334 - correct
         Events : 62

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 9
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)



On Feb 28, 2012, at 6:14 PM, linbloke wrote:

> 
> On 29/02/12 5:47 AM, John Adams wrote:
>> For some years I've been working on some niche filesystems which serve
>> workflows involving lots of video.  Lately, I have had occasion to
>> investigate the behavior of md as a possible raid solution (2.6.32
>> kernel).
>> 
>> As part of that, we looked at some fio based loads in the buffered and
>> O_DIRECT cases and noticed some reading that we didn't understand when
>> using O_DIRECT.  We were led to this comparision by incorrect
>> information from a vendor. (We were trying to repro some reported
>> performance and were initially told that O_DIRECT had been used).
>> 
>> We are aware of the problems discussed concerning O_DIRECT.  As fs
>> guys, we're accustomed to worrying about copies and such, so it wasn't
>> immediately obvious to us that O_DIRECT would be a mistake in our
>> case.  This is essentially an embedded system with a single process
>> owning a group of disks with no filesystem.  There is no possibility
>> of a race with another process.
>> 
>> Anyway, I am curious about this reading behavior and I would grateful for any
>> comments.
>> 
>> I tried writing single stripes under both scenarios.  To give the
>> barest possible summary. I used a dd command like this with
>> oflag=direct omitted or not.  This was driven from a script that
>> sets up some blktrace and ftrace things, waits an appropriate time in
>> the buffered case etc.
>> 
>> dd oflag=direct if=/dev/zero of=/dev/md0 seek=0 bs=1M count=1
>> 
>> 8+2 128k strip
>> 
>> [physical disk completions via blkparse]
>> 
>> Buffered:
>> 
>>  Reads Completed:        2,        5KiB  Writes Completed:        4,      258KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        2,        8KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        6,       24KiB  Writes Completed:        4,      258KiB
>> 
>> Direct Example 1:
>> 
>>  Reads Completed:        2,        5KiB  Writes Completed:       20,      258KiB
>>  Reads Completed:        9,       36KiB  Writes Completed:       14,      130KiB
>>  Reads Completed:       32,      128KiB  Writes Completed:       14,      130KiB
>>  Reads Completed:        1,        4KiB  Writes Completed:       16,      130KiB
>>  Reads Completed:       32,      128KiB  Writes Completed:       12,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        8,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        8,      130KiB
>>  Reads Completed:        0,        0KiB  Writes Completed:        8,      130KiB
>>  Reads Completed:        2,        8KiB  Writes Completed:        8,      130KiB
>>  Reads Completed:        6,       24KiB  Writes Completed:       19,      258KiB
>> 
>> Direct Example 2:
>> 
>>  Reads Completed:        4,      133KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:       11,      164KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:       34,      256KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        2,      132KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:       33,      256KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        3,      136KiB  Writes Completed:        3,      130KiB
>>  Reads Completed:        7,      152KiB  Writes Completed:        3,      130KiB
>> 
>> 
>> I was able to gain a little bit of insight through blktrace and
>> ftrace.  Our initial assumption was that maybe things were being
>> broken up differently such that md thought it needed to do a rmv.
>> 
>> But as I dug into the blktrace output, that did not seem to be the
>> case (reads are coming after what is obviously the strip write).  I
>> used ftrace to show me the path down to md_make_request in the
>> O_DIRECT and buffered cases.  This showed me some calls refering to
>> read_ahead in the direct case.
>> 
>>            <...>-14859 [001] 510340.525310: md_make_request
>>            <...>-14859 [001] 510340.525311:<stack trace>
>>  =>  generic_make_request
>>  =>  submit_bio
>>  =>  submit_bh
>>  =>  block_read_full_page
>>  =>  blkdev_readpage
>>  =>  __do_page_cache_readahead
>>  =>  force_page_cache_readahead
>>  =>  page_cache_sync_readahead
>> 
>> So is this read ahead I'm observing?  Why does it occur only in the
>> direct case?
>> 
>> I noticed that blktrace sometime identifies what I assume to be the
>> instigator of the io.  So I can sometimes see dd or md_raid6 there.
>> As in [dd] or [md0_raid6]:
>> 
>>  8,16   1      115     0.042000000  2910  D   W 2256 + 48 [md0_raid6]
>> 
>> These unexplained reads either mention blkid or [0] or [(null)].
>> 
>> It isn't clear to me whether the unexpected read behavior is due to a
>> tuning problem in the O_DIRECT case or simply the way things work.
>> 
>> Thank you for any comments.--
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> G'day John,
> 
> You need to give us more detail about your md raid setup. Beside a reference to md_raid6, there is no other details about your array.
> How about sending:
> 
> mdadm -V
> uname -a
> mdadm -Dvv /dev/mdarray
> mdadm -Evv /dev/arraycomponentdevices - for all of them
> 
> 
> Good luck in the hunt,
> J
> 
> 
> 

