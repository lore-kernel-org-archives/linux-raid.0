From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 13:09:40 -0500
Message-ID: <200411121809.iACI9kN01098@www.watkins-home.com>
References: <4194A9E9.70003@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4194A9E9.70003@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Greaves' <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NO!!!!!

Bad plan, but almost correct.
If you "--add" a disk, md would think it is a new disk.  And none of the
existing data would be used.  The array would not start anyway.  But if you
use the instructions below, you should get your array back to normal.

+ Stop array:
+ "mdadm /dev/md0 -S"
* insert new drive as /dev/sdd1
+ I have never used dd rescue, so verify its usage.
+ copy failed disk to new disk:
+ "ddrescue if=/dev/sda1 of=/dev/sdd1"
+ physically swap /dev/sda and /dev/sdd, now sda is the new disk
+ start the array:
+ "mdadm --assemble --force /dev/sda1 /dev/sdb1 /dev/sdc1" /dev/hdb1"
verify this, all working disks should be listed.

At this point your array should be up with 1 disk missing.
Your disk with the bad block should be /dev/sdd1, if so, add it to the
array.  Or wait for the new drive and add it.

+ "mdadm /dev/md0 --add /dev/sdd1"

It is normal for a disk to get some bad blocks over time.  Md does not
handle bad blocks very well, just fails the drive.  Since disk drive can
re-locate bad blocks, when you get one, just remove the drive and add it
back.  Or test the disk first with dd.

Assume /dev/sdd is the bad disk:

Test write to the disk to correct bad blocks (you should get no errors):
dd if=/dev/zero of=/dev/sdd bs=1024k

Test read from the disk (you should get no errors):
dd if=/dev/sdd of=/dev/null bs=1024k

If the above gave no errors, then add the disk to the array.

Remove the failed disk from the array:
mdadm /dev/md0 -r /dev/sdd1

Add the repaired disk back to the array:
mdadm /dev/md0 -a /dev/sdd1

I hope this helps!

Guy



-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
Sent: Friday, November 12, 2004 7:18 AM
To: linux-raid@vger.kernel.org
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA

David Greaves wrote:

> So my RAID5 has 2 dead drives and is toasted :(
> I had a few smaller disks on another machine which I lvm'ed together 
> to do a backup - but I could only fit about a quarter of my data 
> there. I'd *really* like not to have lost all this stuff.
>
> However I do now have a 'good' drive.
> Can I dd the newly dead drive (bear in mind it probably only has a bad 
> block or two) onto the new drive and come back up in degraded mode?
>
I've had a think and this is my plan.... comments appreciated.

Currently:
/dev/md0:
        Version : 00.90.01
  Creation Time : Sat Jun  5 18:13:04 2004
     Raid Level : raid5
     Array Size : 980446208 (935.03 GiB 1003.98 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Nov 12 09:46:53 2004
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       0        0       -1      removed
       1       8       33        1      active sync   /dev/sdc1
       2       8       17        2      active sync   /dev/sdb1
       3       0        0       -1      removed
       4       3       65        4      active sync   /dev/hdb1
       5       8        1       -1      faulty   /dev/sda1
           UUID : 19779db7:1b41c34b:f70aa853:062c9fe5
         Events : 0.4443578

so, the plan in order to try and extract data:
* insert new drive as /dev/sdd1
* dd if=/dev/sda1 of=/dev/sdd1
* mdadm /dev/md0 --remove /dev/sda1
* physically swap /dev/sda and /dev/sdd so /dev/sdd
* mdadm /dev/md0 --add /dev/sda1
* fsck filesystem and expect to lose files where there were bad blocks
* wait for new drive (special delivery - tomorrow morning)
* insert new drive as /dev/sdd
* mdadm /dev/md0 --add /dev/sdd1

or am I wasting my time?

David
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

