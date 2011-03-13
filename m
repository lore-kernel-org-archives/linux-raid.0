From: mtice <mjtice@gmail.com>
Subject: Re: Removed two drives (still valid and working) from raid-5 and need to add them back in.
Date: Sat, 12 Mar 2011 20:38:03 -0700
Message-ID: <05223FC6-A8D4-4A5D-9CF4-27998B9ADD3F@gmail.com>
References: <837074B9-F2A5-471B-BAD1-6A92249095FB@gmail.com> <31419C89-14D6-405F-B838-C7E040C8FA43@gmail.com> <4D7C3968.700@turmel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D7C3968.700@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil, thanks for the reply.

On Mar 12, 2011, at 8:26 PM, Phil Turmel wrote:

> Hi Matt,
> 
> On 03/12/2011 08:01 PM, mtice wrote:
>> 
>>> I have a 4 disk raid 5 array on my Ubuntu 10.10 box. They are /dev/sd[c,d,e,f]. Smartctl started notifying me that /dev/sde had some bad sectors and the number of errors was increasing each day. To mitigate this I decided to buy a new drive and replace it.
>>> 
>>> I failed /dev/sde via mdadm:
>>> 
>>> mdadm --manage /dev/md0 --fail /dev/sde
>>> mdadm --manage /dev/md0 --remove
>>> 
>>> I pulled the drive from the enclosure . . . and found it was the wrong drive (should have been the next drive down . . .). I quickly pushed the drive back in and found that the system renamed the device (/dev/sdh).  
>>> I then tried to add that drive back in (this time with the different dev name):
>>> 
>>> mdadm --manage /dev/md0 --re-add /dev/sdh
>>> (I don't have the output of --detail for this step.)
>>> 
>>> I rebooted and the original dev name returned (/dev/sdd).
>>> 
>>> The problem is now I have two drives in my raid 5 which of course won't start: 
>>> 
>>> mdadm -As /dev/md0
>>> mdadm: /dev/md0 assembled from 2 drives and 2 spares - not enough to start the array.
>>> 
>>> 
>>> Although, I can get it running with:
>>> dadm --incremental --run --scan
>>> 
>>> So my question is how can I add these two still-valid spares back into my array?
>>> 
>>> Here is the output of mdadm --detail /dev/md0:
>>> 
>>> /dev/md0:
>>>       Version : 00.90
>>> Creation Time : Thu May 27 15:35:56 2010
>>>    Raid Level : raid5
>>> Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>>>  Raid Devices : 4
>>> Total Devices : 4
>>> Preferred Minor : 0
>>>   Persistence : Superblock is persistent
>>> 
>>>   Update Time : Fri Mar 11 15:53:35 2011
>>>         State : active, degraded, Not Started
>>> Active Devices : 2
>>> Working Devices : 4
>>> Failed Devices : 0
>>> Spare Devices : 2
>>> 
>>>        Layout : left-symmetric
>>>    Chunk Size : 64K
>>> 
>>>          UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
>>>        Events : 0.43200
>>> 
>>>   Number   Major   Minor   RaidDevice State
>>>      0       8       80        0      active sync   /dev/sdf
>>>      1       0        0        1      removed
>>>      2       0        0        2      removed
>>>      3       8       32        3      active sync   /dev/sdc
>>> 
>>>      4       8       64        -      spare   /dev/sde
>>>      5       8       48        -      spare   /dev/sdd
>>> 
>>> 
>>> I appreciate any help.
>>> 
>>> Matt
>> 
>> I did find one older thread with a similar problem.  The thread was titled "
>> RAID 5 re-add of removed drive? (failed drive replacement)"
>> 
>> The point that seemed to make the most sense is:
>> 
>> AFAIK, the only solution at this stage is to recreate the array.
>> 
>> You need to use the "--assume-clean" flag (or replace one of the drives 
>> with "missing"), along with _exactly_ the same parameters & drive order 
>> as when you originally created the array (you should be able to get most 
>> of this from mdadm -D). This will rewrite the RAID metadata, but leave 
>> the filesystem untouched.
>> 
>> The question I have is how do I know what order to put the drives in?  And is this really the route I need to take?
> 
> If you can avoid --create, do.  Please report "mdadm -E /dev/sd[cdef]" so we can see all of the component drive's self-knowledge.
> 
> The order for --create will be the numerical order of the "RaidDevice" column.  We know from the above what sdc and sdf are, but we need tell sdd and sde apart.
> 
> Before trying to --create, I suggest trying --assemble --force.  It's much less likely to do something bad.
> 
> You might find my "lsdrv" script useful to see the serial numbers of these drives, so you won't confuse them in the future.  I've attached the most recent version for your convenience.
> 
> Phil
> 
> 
> <lsdrv.txt>


Here is the output of mdadm -E /dev/sd[cdef] 

/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
  Creation Time : Thu May 27 15:35:56 2010
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Mar 11 15:53:35 2011
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 2
       Checksum : 3d3b86 - correct
         Events : 43200

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       32        3      active sync   /dev/sdc

   0     0       8       80        0      active sync   /dev/sdf
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       32        3      active sync   /dev/sdc
   4     4       8       64        4      spare   /dev/sde
   5     5       8      112        5      spare
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
  Creation Time : Thu May 27 15:35:56 2010
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Mar 11 15:53:35 2011
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 2
       Checksum : 3d3bd4 - correct
         Events : 43200

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      112        5      spare

   0     0       8       80        0      active sync   /dev/sdf
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       32        3      active sync   /dev/sdc
   4     4       8       64        4      spare   /dev/sde
   5     5       8      112        5      spare
/dev/sde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
  Creation Time : Thu May 27 15:35:56 2010
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Mar 11 15:53:35 2011
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 2
       Checksum : 3d3ba2 - correct
         Events : 43200

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       64        4      spare   /dev/sde

   0     0       8       80        0      active sync   /dev/sdf
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       32        3      active sync   /dev/sdc
   4     4       8       64        4      spare   /dev/sde
   5     5       8      112        5      spare
/dev/sdf:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
  Creation Time : Thu May 27 15:35:56 2010
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Mar 11 15:53:35 2011
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 2
       Checksum : 3d3bb0 - correct
         Events : 43200

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       80        0      active sync   /dev/sdf

   0     0       8       80        0      active sync   /dev/sdf
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       32        3      active sync   /dev/sdc
   4     4       8       64        4      spare   /dev/sde
   5     5       8      112        5      spare


I ran mdadm --assemble --force /dev/md0 but it erred with:

mdadm: device /dev/md0 already active - cannot assemble it


