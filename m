From: Yves Glodt <yg@mind.lu>
Subject: Some raid1 questions
Date: Sun, 1 Feb 2004 14:38:01 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402011438.01880.yg@mind.lu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have my home partition on a raid1 device, and there is an ext3 
filesystem on it. Some more information:

fstab:
----------------
/dev/hdc1 / ext3 defaults,noatime,nodiratime
/dev/md0 /home ext3 defaults,noatime,nodiratime,data=writeback

raidtab:
---------------
raiddev                 /dev/md0
raid-level              1
persistent-superblock   1
nr-raid-disks           2
nr-spare-disks          0
device                  /dev/hda2
raid-disk               0
device                  /dev/hdc2
raid-disk               1


Recently I had some freezes (due to nvidia...?), and everytime I had to 
make a hard reset.

Everytime then the raid resynced completely which took about 1.5 hours.
One time I lost some kde settings when this happened.
The filesystem did not complain about an unclean shutdown, it seems it 
did not see on bootup that the last shutdown was unclean.

Now to my questions:
Is this the normal behaviour?
Shouldn't the filesystem take care of that?
What is the point of having a journaling filesystem on a mirror?
Is there anything I can change to have the filesystem handle unclean 
shutdowns?

TIA,
Yves


-- 
Linux 2.4.24 #5 Mon Jan 5 19:38:06 CET 2004 i686
 14:25:55 up  4:14,  1 user,  load average: 0.43, 0.40, 0.32

