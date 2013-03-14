From: Joel Young <jdy@cryregarder.com>
Subject: Re: RAID 0 of Two RAID 5s Stays Up When Component RAID fails
Date: Thu, 14 Mar 2013 22:13:46 +0000 (UTC)
Message-ID: <loom.20130314T215046-573@post.gmane.org>
References: <loom.20130314T022616-853@post.gmane.org> <loom.20130314T050243-974@post.gmane.org> <3CD9214B-FAE8-4DA5-BDBC-7A5FEB5AEC4B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Murphy <lists <at> colorremedies.com> writes:

> 
> 
> On Mar 13, 2013, at 10:03 PM, Joel Young <jdy <at> cryregarder.com> wrote:

> > mdadm /dev/md0 --fail /dev/loop1
> > mdadm /dev/md0 --fail /dev/loop2
> 
> In this case md0 is failed. And thus md2 is failed.
> 

Yes md2 is broken, but it isn't failed according to:

[root@quickstep delme_images]# mdadm --detail /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Wed Mar 13 18:25:17 2013
     Raid Level : raid0
     Array Size : 406528 (397.07 MiB 416.28 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Wed Mar 13 18:25:17 2013
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 512K

           Name : quickstep:2  (local to host quickstep)
           UUID : ca94a237:d63c25be:ff64fe0f:a41be44c
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       9        1        0      active sync   /dev/md0
       1       9        3        1      active sync   /dev/md1

In /var/log/messages I get a bunch of buffer I/O errors on the device and
a warning in drivers/md/raid5.c get_active_stripe+0x683/0x7a0 [raid456]()

Shouldn't md2 have automatically failed?  Shouldn't writes immediately
error out instead of pretending to complete?

Joel


