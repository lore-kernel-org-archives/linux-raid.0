From: "Rob ." <ensoftrob@hotmail.com>
Subject: Need to get rid of failed devices in RAID5 after moving drive to new interface
Date: Tue, 07 Mar 2006 02:47:48 -0600
Message-ID: <BAY105-F2822CBFEB359481776D8FEB5EE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

The RAID5 I set up originally had 2 PATA drives and 2 SATA drives.  I 
recently purchased 2 more SATA drives, so I wanted to swap out the PATA ones 
one at a time.  In my infinite wisdom I did the following:

1. Shutdown.
2. Physically removed the PATA drive (/dev/hdb, with partition /dev/hdb5).
3. Installed the SATA drive.
4. Booted up; saw a message that a device had failed but there were no 
spares to rebuild.
5. Partitioned the new drive.
6. mdadm --add /dev/md5 /dev/sdc5 (added the new drive).

As you can see, the new SATA drive was added as /dev/sdc.  My reasoning for 
removing hdb5 outright rather than marking it failed was that I hoped it 
would be easier to reinsert hdb5 and rebuild the array if something bad 
happened (say, if sda failed) while the array was rebuilding.

Since RAID5 works as you would expect, it rebuilt md5 without any problems 
as soon as I added /dev/sdc5 to the RAID.  However, if I type this command:

mdadm --detail /dev/md5

...I see the following output (note Total Devices: 5 and Failed Devices:1):

-------------------------------------------------------------------------------------------------
/dev/md5:
        Version : 00.90.00
  Creation Time : Mon Sep  5 16:47:04 2005
     Raid Level : raid5
     Array Size : 146512320 (139.73 GiB 150.03 GB)
    Device Size : 48837440 (46.58 GiB 50.01 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 5
    Persistence : Superblock is persistent

    Update Time : Tue Mar  7 01:30:33 2006
          State : dirty, no-errors
Active Devices : 4
Working Devices : 4
Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8        5        0      active sync   /dev/sda5
       1       8       21        1      active sync   /dev/sdb5
       2       8       37        2      active sync   /dev/sdc5
       3      22       69        3      active sync   /dev/hdd5
           UUID : 811eb962:7ab90bd2:585e740e:fe7a507b
         Events : 0.42
-------------------------------------------------------------------------------------------------

Everything seems to be happy and functioning, but it's really bugging me 
that I can't get rid of the failed device.  At first I thought it was 
because my /etc/mdadm.conf was out-of-date.  However, I replaced instances 
of /dev/hdb* with /dev/sdc* in the /etc/mdadm.conf.

I noticed someone else has also had this problem but didn't have a solution 
(scroll to the very bottom):
http://www.digitalmapping.sk.ca/Networks/ExpandingRAID.htm

Doing mdadm --remove /dev/md5 /dev/hdb5 won't work any more, because 
/dev/hdb5 doesn't exist any more, and even if it did, by now I would 
consider hdb invalid or corrupt because new data has been written to the 
RAID.

So, friends, how do you suggest I get rid of that faulty device so I can 
clear my conscience?

-Rob

_________________________________________________________________
Don’t just search. Find. Check out the new MSN Search! 
http://search.msn.click-url.com/go/onm00200636ave/direct/01/

