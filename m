From: Curt <lightspd@gmail.com>
Subject: Re: hung grow
Date: Thu, 5 Oct 2017 21:25:22 -0400
Message-ID: <CADg2FGZ+u8ZLnGhBDY-947P9jQpB=jTnC73c5inOqMxCzdiWxA@mail.gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk> <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com> <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com> <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
 <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
 <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk> <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com>
 <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk> <d21f169e-0546-aa00-ce19-b6688ba74da6@turmel.org>
 <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just realized I forgot to do a reply all on this yesterday.  In case
anyone else in the group is interested. The ddrescue on the failed
drive is complete now.

Requested info pasted below, at least the info I got.

(Side note: Let's just go with stupidity)

Then depending on what your feedback is, theoretically I'll want to run

mdadm --assemble --force --update=revert-reshape /dev/md127 /dev/sda1
/dev/sdc1 /dev/sdd1 /dev/sdg1/ /dev/ddRescuePart

I appreciate all your help on this.

Cheers,
Curt

On Wed, Oct 4, 2017 at 5:53 PM, Phil Turmel <philip@turmel.org> wrote:
> Hi Curt,
>
> Let me endorse Wol's prescription, with a few comments:
>
> On 10/04/2017 05:08 PM, Anthony Youngman wrote:
>> On 04/10/17 21:01, Curt wrote:
>
> { Side note: what possessed you to do a grow operation? }
>
>>> I'll be doing a ddrescue on the drives tonight, but will wait till
>>> Phil or someone chimes in with my next steps after I do that.
>
> I haven't seen complete mdadm -E reports for all of these devices, nor
> mdadm -D for the array itself.  Please do so now.  If you have any of
> that from before the crash, please post that too.  Run mdadm -E on the
> two earliest failed drives.
>
Don't hate on me too bad.  I already know I made several very stupid
mistakes along the way.

Here's watch I got probably missing a few things that would be useful.
The array is currently stopped, so I can't get you the -D, but here's
what I got

Array Before Grow
/dev/md127:
           Version : 0.90
     Creation Time : Fri Jun 15 15:52:05 2012
        Raid Level : raid6
        Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
     Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
      Raid Devices : 7
     Total Devices : 7
   Preferred Minor : 127
       Persistence : Superblock is persistent

       Update Time : Tue Oct  3 21:13:32 2017
             State : clean, degraded, recovering
    Active Devices : 5
   Working Devices : 7
    Failed Devices : 0
     Spare Devices : 2

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : unknown

    Rebuild Status : 84% complete

              UUID : 714a612d:9bd35197:36c91ae3:c168144d
            Events : 0.11559596

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       49        1      active sync   /dev/sdd1
       2       8       33        2      active sync   /dev/sdc1
       3       8        1        3      active sync   /dev/sda1
       4       8       65        4      active sync   /dev/sde1
       8       8       16        5      spare rebuilding   /dev/sdb
       7       8       80        6      spare rebuilding   /dev/sdf


Array After Grow:
mdadm --detail /dev/md127
/dev/md127:
           Version : 0.91
     Creation Time : Fri Jun 15 15:52:05 2012
        Raid Level : raid6
        Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
     Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
      Raid Devices : 8
     Total Devices : 7
   Preferred Minor : 127
       Persistence : Superblock is persistent

       Update Time : Tue Oct  3 23:10:32 2017
             State : clean, FAILED, reshaping
    Active Devices : 5
   Working Devices : 7
    Failed Devices : 0
     Spare Devices : 2

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : unknown

    Reshape Status : 0% complete
     Delta Devices : 1, (7->8)

              UUID : 714a612d:9bd35197:36c91ae3:c168144d
            Events : 0.11559671

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       49        1      active sync   /dev/sdd1
       2       8       33        2      active sync   /dev/sdc1
       3       8        1        3      active sync   /dev/sda1
       4       8       65        4      active sync   /dev/sde1
       5       8       16        5      spare rebuilding   /dev/sdb
       6       8       80        6      spare rebuilding   /dev/sdf
       -       0        0        7      removed


Here's the few I have from before.  I really shouldn't have been doing
this at 4am.
****************
mdadm --examine /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 127

    Update Time : Tue Oct  3 22:38:22 2017
          State : clean
 Active Devices : 4
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 2
       Checksum : cdfbf074 - correct
         Events : 11559615

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8       80        7      spare   /dev/sdf

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
   7     7       8       80        7      spare   /dev/sdf
   8     8       8       16        8      spare   /dev/sdb

mdadm --examine /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 127

    Update Time : Tue Oct  3 22:38:22 2017
          State : clean
 Active Devices : 4
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 2
       Checksum : cdfbf023 - correct
         Events : 11559615

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8        1        3      active sync   /dev/sda1

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
   7     7       8       80        7      spare   /dev/sdf
   8     8       8       16        8      spare   /dev/sdb

Here's the 3 failed drives: NOTE: I only had one bay available, so
they all have the same drive letter

mdadm --examine /dev/sdz1
/dev/sdz1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 126

    Update Time : Mon Jul 11 16:54:15 2016
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ca7ec3b0 - correct
         Events : 3397832

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      65       97        1      active sync

   0     0      65      113        0      active sync
   1     1      65       97        1      active sync
   2     2      65       81        2      active sync
   3     3       0        0        3      faulty removed
   4     4      65       49        4      active sync
   5     5      65       33        5      active sync
   6     6      65       17        6      active sync

**********************THE ONE BELOW I'M DOING A DDRESCUE FROM******

mdadm --examine /dev/sdz1
/dev/sdz1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 127

    Update Time : Sat Sep  2 01:00:37 2017
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : cd217ebc - correct
         Events : 11559404

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       65        5      active sync   /dev/sde1

   0     0       8       81        0      active sync
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       17        2      active sync
   3     3      65      129        3      active sync   /dev/sdy1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8       65        5      active sync   /dev/sde1
   6     6       0        0        6      faulty removed



***************

mdadm --examine /dev/sdz1
/dev/sdz1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 127

    Update Time : Mon Nov  7 02:02:38 2016
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
       Checksum : cb1ec57d - correct
         Events : 3652739

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       97        6      active sync   /dev/sdg1

   0     0       8       81        0      active sync
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       17        2      active sync
   3     3      65      129        3      active sync   /dev/sdy1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       8       65        5      active sync   /dev/sde1
   6     6       8       97        6      active sync   /dev/sdg1

CURRENT EXAMINE
*************************
mdadm -E /dev/sd[acdeg]1
/dev/sda1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 11721023232 (11178.04 GiB 12002.33 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 127

  Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Oct  4 12:49:57 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : ce71a9cb - correct
         Events : 11559681

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8        1        3      active sync   /dev/sda1

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
   6     6       8       16        6      active   /dev/sdb
   7     7       0        0        7      faulty removed
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 11721023232 (11178.04 GiB 12002.33 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 127

  Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Oct  4 12:49:57 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : ce71a9e9 - correct
         Events : 11559681

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
   6     6       8       16        6      active   /dev/sdb
   7     7       0        0        7      faulty removed
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 11721023232 (11178.04 GiB 12002.33 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 127

  Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Oct  4 12:49:57 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : ce71a9f7 - correct
         Events : 11559681

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
   6     6       8       16        6      active   /dev/sdb
   7     7       0        0        7      faulty removed
/dev/sde1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 11721023232 (11178.04 GiB 12002.33 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 127

  Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Oct  4 12:49:57 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : ce71aa0d - correct
         Events : 11559681

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
   6     6       8       16        6      active   /dev/sdb
   7     7       0        0        7      faulty removed
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 11721023232 (11178.04 GiB 12002.33 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 127

  Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Oct  4 12:49:57 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : ce71aa25 - correct
         Events : 11559681

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       97        0      active sync   /dev/sdg1

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
   6     6       8       16        6      active   /dev/sdb
   7     7       0        0        7      faulty removed

/dev/sdb:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 714a612d:9bd35197:36c91ae3:c168144d
  Creation Time : Fri Jun 15 15:52:05 2012
     Raid Level : raid6
  Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
     Array Size : 11721023232 (11178.04 GiB 12002.33 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 127

  Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Oct  4 12:49:57 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : ce71a9dc - correct
         Events : 11559681

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       16        6      active   /dev/sdb

   0     0       8       97        0      active sync   /dev/sdg1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
   6     6       8       16        6      active   /dev/sdb
   7     7       0        0        7      faulty remove

> Post the uncut output inline here on the list, in plain text mode, with
> line wrap disabled, please.
>
>> If you've got enough to ddrescue all of those five original drives, then
>> that's absolutely great.
>>
>> Remember - if we can't get five original drives (or copies thereof) the
>> array is toast.
>>>
>>> lol, chalk one more up for FML. "SCT Error Recovery Control command
>>> not supported".  I'm guessing this is a real bad thing now?  I didn't
>>> buy these drives or org set it up.
>>>
>> I'm not sure whether this is good news or bad. Actually, it *could* be
>> great news for the rescue! It's bad news for raid though, if you don't
>> deal with it up front - I guess that wasn't done ...
>
> It is mixed news.  It is almost certainly the reason you've had drives
> bumped out of your arrays.  I suspect these drives all report *PASSED*
> from smartctl.  Which means that the drives really are good, just
> suffering from ordinary uncorrected errors.
>
> You'll certainly have to use the 180 second driver timeout work-around
> to get through this crisis.
>
> In the meantime, please run "smartctl -iA -l scterc" on each of your
> drives, including the failed ones, and post the uncut output here.
> { Include the device name with each }
>
Sorry I don't have it for the failed ones, I forgot to run in before I
started ddrescue, here's the current drives
# smartctl -iA -l scterc /dev/sda
smartctl 6.2 2017-02-27 r4394 [x86_64-linux-3.10.0-229.el7.x86_64] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST2000DM001-1ER164
Serial Number:    W4Z14ZNW
LU WWN Device Id: 5 000c50 07d29ef14
Firmware Version: CC25
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct  4 20:28:30 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   106   099   006    Pre-fail
Always       -       11140560
  3 Spin_Up_Time            0x0003   096   096   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       14
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   089   060   030    Pre-fail
Always       -       827856598
  9 Power_On_Hours          0x0032   079   079   000    Old_age
Always       -       18858
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       14
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0 0 0
189 High_Fly_Writes         0x003a   013   013   000    Old_age
Always       -       87
190 Airflow_Temperature_Cel 0x0022   071   063   045    Old_age
Always       -       29 (Min/Max 29/30)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       8
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       268
194 Temperature_Celsius     0x0022   029   040   000    Old_age
Always       -       29 (0 18 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       18841h+49m+16.895s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       84336821090
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       4832824497202

SCT Error Recovery Control command not supported

# smartctl -iA -l scterc /dev/sdb
smartctl 6.2 2017-02-27 r4394 [x86_64-linux-3.10.0-229.el7.x86_64] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST2000DM001-1ER164
Serial Number:    Z4Z3Y7XM
LU WWN Device Id: 5 000c50 087461756
Firmware Version: CC26
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct  4 20:28:44 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail
Always       -       157161144
  3 Spin_Up_Time            0x0003   096   096   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       15
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   086   060   030    Pre-fail
Always       -       409701090
  9 Power_On_Hours          0x0032   086   086   000    Old_age
Always       -       12274
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       15
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0 0 0
189 High_Fly_Writes         0x003a   092   092   000    Old_age
Always       -       8
190 Airflow_Temperature_Cel 0x0022   070   065   045    Old_age
Always       -       30 (Min/Max 28/33)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       10
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       142
194 Temperature_Celsius     0x0022   030   040   000    Old_age
Always       -       30 (0 21 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       12268h+22m+21.157s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       83831274067
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       124530518173

SCT Error Recovery Control command not supported

# smartctl -iA -l scterc /dev/sdc
smartctl 6.2 2017-02-27 r4394 [x86_64-linux-3.10.0-229.el7.x86_64] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Black
Device Model:     WDC WD2002FAEX-007BA0
Serial Number:    WD-WMAY04949787
LU WWN Device Id: 5 0014ee 25c3e0682
Firmware Version: 05.01D05
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct  4 20:28:46 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       2
  3 Spin_Up_Time            0x0027   253   253   021    Pre-fail
Always       -       8041
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       36
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   071   071   000    Old_age
Always       -       21337
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       35
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       27
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       8
194 Temperature_Celsius     0x0022   117   107   000    Old_age
Always       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SCT Error Recovery Control command not supported

# smartctl -iA -l scterc /dev/sdd
smartctl 6.2 2017-02-27 r4394 [x86_64-linux-3.10.0-229.el7.x86_64] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Black
Device Model:     WDC WD2002FAEX-007BA0
Serial Number:    WD-WMAY04912439
LU WWN Device Id: 5 0014ee 25c3f0960
Firmware Version: 05.01D05
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct  4 20:29:33 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       8
  3 Spin_Up_Time            0x0027   253   253   021    Pre-fail
Always       -       7950
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       36
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   071   071   000    Old_age
Always       -       21325
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       35
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       27
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       8
194 Temperature_Celsius     0x0022   116   106   000    Old_age
Always       -       36
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SCT Error Recovery Control command not supported

# smartctl -iA -l scterc /dev/sde
smartctl 6.2 2017-02-27 r4394 [x86_64-linux-3.10.0-229.el7.x86_64] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Black
Device Model:     WDC WD2002FAEX-007BA0
Serial Number:    WD-WMAY05040774
LU WWN Device Id: 5 0014ee 2b1938a22
Firmware Version: 05.01D05
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct  4 20:29:36 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   253   253   021    Pre-fail
Always       -       8083
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       36
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   071   071   000    Old_age
Always       -       21328
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       35
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       27
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       8
194 Temperature_Celsius     0x0022   116   108   000    Old_age
Always       -       36
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       2
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       2
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       2

SCT Error Recovery Control command not supported

#smartctl -iA -l scterc /dev/sdg
smartctl 6.2 2017-02-27 r4394 [x86_64-linux-3.10.0-229.el7.x86_64] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST2000DM001-1ER164
Serial Number:    ZA5029A8
LU WWN Device Id: 5 000c50 0874eb397
Firmware Version: CC26
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct  4 20:29:42 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   119   099   006    Pre-fail
Always       -       232755000
  3 Spin_Up_Time            0x0003   094   094   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       10
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   087   060   030    Pre-fail
Always       -       606406779
  9 Power_On_Hours          0x0032   086   086   000    Old_age
Always       -       13052
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       10
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0 0 0
189 High_Fly_Writes         0x003a   098   098   000    Old_age
Always       -       2
190 Airflow_Temperature_Cel 0x0022   069   060   045    Old_age
Always       -       31 (Min/Max 29/34)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       4
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       310
194 Temperature_Celsius     0x0022   031   040   000    Old_age
Always       -       31 (0 25 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       13039h+51m+52.726s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       33464557056
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       2634696436762

SCT Error Recovery Control command not supported


>> Go and read the wiki - the "When Things Go Wrogn" section. That will
>> hopefully help a lot and it explains the Error Recovery stuff (the
>> timeout mismatch page). Fix that problem and your dodgy drives will
>> probably dd without trouble at all.
>
> Let me emphasize this.  The timeout mismatch problem is so prevalent and
> your experience so common that I thought to myself "I bet this one is
> timeout mismatch" when I read your first mail.
>
>> Hopefully with all copied drives, but if you have to mix dd'd and
>> original drives you're probably okay, you should now be able to assemble
>> a working array with five drives by doing an
>
> As already noted, you definitely need to use ddrescue on the third
> drive that failed.  You may also need to ddrescue your four remaining
> good drives if they also have "Pending Sector" counts.
>
>> mdadm --assemble blah blah blah --update=revert-reshape
>>
>> That will put you back to a "5 drives out of 7" working array. The
>> problem with this is that it will be a degraded, linear array.
>
> This is the correct next step, after all required ddrescues.
>
>> I'm not sure whether a --display will list the failed drives - if it
>> does you can now --remove them. So you'll now have a working, 7-drive
>> array, with two drives missing.
>
> This is the time to grab any backups you need of critical content.  Do
> *not* write to the array at this point.  Get all your data off.
>
> Then:
>
>> Now --add in the two new drives. MAKE SURE you've read the section on
>> timeout mismatch and dealt with it! The rebuild/recovery will ALMOST
>> CERTAINLY FAIL if you don't! Also note that I am not sure about how
>> those drives will display while rebuilding - they may well display as
>> being spares during a rebuild.
>
> The timeout mismatch fixes won't help your case.  You have no redundancy
> left, so the kickout scenarios involved no longer apply.  They applied
> when your first two drives were kicked out.  When timeouts are not
> mismatched, MD raid *fixes* the occasional bad sector.
>
>> Lastly, MAKE SURE you set up a regular scrub. There's a distinct
>> possibility that this problem wouldn't have arisen (or would have been
>> found quicker) if a scrub had been in place. And if you can set up a
>> trigger that emails you the contents of /proc/mdstat every few days.
>> It's far too easy to miss a failed drive if you don't have something
>> shoving it in your face every few days.
>
> If you have a timeout mismatch problem, one's array will die much sooner
> with scrubs.  Because MD raid will fail to fix UREs, and it will find
> them right away.
>
> But again, get us the detailed reports, and we'll help make sure your
> commands are correct.
>
> Phil
