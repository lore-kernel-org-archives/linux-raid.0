From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 12:17:45 +0000
Message-ID: <4194A9E9.70003@dgreaves.com>
References: <41948B65.3090504@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41948B65.3090504@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
