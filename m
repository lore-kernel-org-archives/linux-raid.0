From: "Oscar I. del Rey" <nacho@rlc01.sertecnet.com>
Subject: Recovery Raid 5 from other server
Date: Mon, 08 Mar 2004 16:00:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <404C8A78.5060607@rlc01.sertecnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  Hi list

I have a raid 5 with 4 scsi disks.
This raid was on other server and I would like to mount it on a new 
server without lost dat, if it is possible
Before it was configured as:
-----------------/etc/raidtab--------------------
raiddev /dev/md0
    raid-level                5
    nr-raid-disks             4
    nr-spare-disks            0
    persistent-superblock     1
    chunk-size                4
    device                    /dev/sda1
    raid-disk                 0
    device                    /dev/sdb1
    raid-disk                 1
    device                    /dev/sdc1
    raid-disk                 2
    device                    /dev/sdd1
    raid-disk                 3
------------------------------------------------
Now, I make another /etc/raidtab on the new server as:
-----------------/etc/raidtab--------------------
raiddev /dev/md1
    raid-level                5
    nr-raid-disks             4
    nr-spare-disks            0
    persistent-superblock     1
    chunk-size                4
    device                    /dev/sda1
    raid-disk                 0
    device                    /dev/sdb1
    raid-disk                 1
    device                    /dev/sdc1
    raid-disk                 2
    device                    /dev/sdd1
    raid-disk                 3
------------------------------------------------
but it can't start.

I have tested the disks with   --> mdadm -E /dev/sda1 , mdadm -E 
/dev/sdb1, mdadm -E /dev/sdc1, mdadm -E /dev/sdd1 and all the results are ok
I think the problem is that I use /dev/md1 instead of /dev/md0, but for 
several reasons I can't use /dev/md0 to do it.
Then, are there any solution to mount this raid without lost data?

Thanks in advance


