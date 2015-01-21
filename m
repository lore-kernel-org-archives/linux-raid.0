From: Scott Tablett <scott.tablett@netgis.com>
Subject: Expanding partitions -> missing md on kernel load
Date: Tue, 20 Jan 2015 23:40:28 -0500
Message-ID: <54BF2DBC.5000809@netgis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Migrated two drive RAID 1 array (1.2 metadata) to larger drives (larger 
gpt partitions)

Followed steps on https://raid.wiki.kernel.org/index.php/Growing

Before using mdadm --grow, the system reliably booted for months, 
automatically discovering, mounting md.

Noticed one of next two steps involved fsck.  I understand fsck should 
be performed on unmounted filesytem.  So, changed to runlevel 1 with 
init 1 and unmount md.

Ran mdadm --grow --size=max on unmounted md.  Command exited normally.  
Ran fsck and resize2fs.  Commands exited normally. Mounted md and 
verified file system contents.

Did same steps for another md and restarted services with CTL+D. Noticed 
resync taking place using Disk Utility.  After resync completed, NFS 
service froze, so decided to test reboot.

The two Expanded md (/var and /home) are no longer automatically 
assembled by kernel.  The md can be assembled by using mdadm --assemble.

Is there a way to get the two Expanded md to auto assemble again?

Tried using mdadm --create with one drive, but could not mount md (error 
message).  Guessing it needs formatting after --create?
