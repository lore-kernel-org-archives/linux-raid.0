From: M K <maheshext3@yahoo.com>
Subject: raid on extended partitions
Date: Mon, 31 May 2004 16:30:28 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040531233028.45376.qmail@web61003.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello folks, I am using kernel version 2.4.18-ac3,
mdadm - v1.2.0 - 13 Mar 2003 and wanted to take a shot
at creating a RAID on an extended partition using
mdadm.
the commands used were (all drives were swapped off an
unmounted before running these, and I am running on a
motherboard with 4 IDE channels; the drives used were
/dev/hde and /dev/hdg):
Fdisk RESULT for hde (same on hdg as well):
   Device Boot    Start       End    Blocks   Id 
System
/dev/hde1             1      9052  72710158+  83 
Linux
/dev/hde2          9053     36473 220259182+   5 
Extended
/dev/hde5          9053     12877  30724281   fd 
Linux raid autodetect

Calling ioctl() to re-read partition table.
 hde: hde1 hde2 < hde5 >
 hde: hde1 hde2 < hde5 >
Syncing disks.

After that, When I tried to run:
mdadm --create --force /dev/md3 --raid-devices=2
--level=1 /dev/hde5 /dev/hdg5

I get:
mdadm: Cannot open /dev/hde5: No such file or
directory
mdadm: Cannot open /dev/hdg5: No such file or
directory
mdadm: create aborted

I am using mdadm - v1.2.0 - 13 Mar 2003
. 
Is there something I am doing wrong? Please advise -
Thanks a lot in advance!

Regards,
Mahesh


	
		
__________________________________
Do you Yahoo!?
Friends.  Fun.  Try the all-new Yahoo! Messenger.
http://messenger.yahoo.com/ 
