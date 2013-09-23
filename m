From: P Agenbag <internet@mweb.co.za>
Subject: Re: RAID5+spare volume gone - mdadm sees RAID1 only?
Date: Mon, 23 Sep 2013 07:15:26 +0200
Message-ID: <CAFjqtwhbSAmXKSjFkmL+f342uJWPQdWbdXCNu7s5B03X=F0wdg@mail.gmail.com>
References: <CAFjqtwhDa03Yi2kaWAVCVpYPxPmF3omwAw2KW4cmKfQerXFwug@mail.gmail.com>
	<523F6512.2050007@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523F6512.2050007@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil

Below, please find the output of the mdadm --examine on the 4 drive's
second partitions. Apologies for omitting that in the first e-mail.

Appreciate your help.

Regards



/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7cdbaa07:ebe66d1b:e9ffe775:cc34485e
  Creation Time : Wed Sep 19 18:30:28 2012
     Raid Level : raid5
  Used Dev Size : 485762944 (463.26 GiB 497.42 GB)
     Array Size : 1457288832 (1389.78 GiB 1492.26 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Tue Apr 25 08:11:59 2000
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 6e7a32c7 - correct
         Events : 140493

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       50        3      active sync   /dev/sdd2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7cdbaa07:ebe66d1b:e9ffe775:cc34485e
  Creation Time : Wed Sep 19 18:30:28 2012
     Raid Level : raid5
  Used Dev Size : 485762944 (463.26 GiB 497.42 GB)
     Array Size : 1457288832 (1389.78 GiB 1492.26 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Tue Apr 25 08:11:59 2000
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 6e7a3291 - correct
         Events : 140493

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7cdbaa07:ebe66d1b:e9ffe775:cc34485e
  Creation Time : Wed Sep 19 18:30:28 2012
     Raid Level : raid5
  Used Dev Size : 485762944 (463.26 GiB 497.42 GB)
     Array Size : 1457288832 (1389.78 GiB 1492.26 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Tue Apr 25 08:11:59 2000
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 6e7a32b5 - correct
         Events : 140493

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7cdbaa07:ebe66d1b:e9ffe775:cc34485e
  Creation Time : Wed Sep 19 18:30:28 2012
     Raid Level : raid5
  Used Dev Size : 485762944 (463.26 GiB 497.42 GB)
     Array Size : 1457288832 (1389.78 GiB 1492.26 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Tue Apr 25 11:16:28 2000
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 6e7a5e3b - correct
         Events : 140520

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       0        0        0      removed
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed

On Sun, Sep 22, 2013 at 11:45 PM, Phil Turmel <philip@turmel.org> wrote:
> On 09/22/2013 02:02 PM, P Agenbag wrote:
>> Hi List
>>
>> I have a D-Link DNS345 NAS which I configured as RAID5 + spare with 4x
>> 500GB Seagate SATA drives.
>>
>> I suspect a power surge caused the NAS to suddenly lose the volume.
>>
>> All 4 drives checked out OK when doing a SMART test on the NAS itself.
>> I proceeded to build all 4 drives into a CentOS server, but was unable
>> to mount the RAID5 - error is always "not enough drives".
>>
>> I followed some advise in archives, and did some mdadm -- examines,
>> and echo them below - what I don't understand is why the --examine
>> picks them up as RAID1.
>>
>> Is there anything I can do to re-build this array?
>
> The "mdadm --examine" info you gave is clearly for the NAS boot
> volume--it is only 1/2 GB--and would be expected to be raid1.
>
> Please take a closer look at your partition tables....
>
> Share them here if you can't get further, and include "mdadm --examine"
> from all other partitions that have raid superblocks.
>
> Phil
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
