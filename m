From: "Mark A. O'Neil" <mark.a.oneil@Dartmouth.EDU>
Subject: Recovery of software RAID5 using FC6 rescue?
Date: Tue, 8 May 2007 13:24:47 -0400
Message-ID: <7EF2C690-263B-4437-BCE2-42762484CB5B@dartmouth.edu>
References: <Pine.LNX.4.64.0705080821350.16228@p34.internal.lan> <17984.29974.116526.922404@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17984.29974.116526.922404@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I hope this is the appropriate forum for this request if not please  
direct me to the correct one.

I have a system running FC6, 2.6.20-1.2925, software RAID5 and a  
power outage seems to have borked the file structure on the RAID.

Boot shows the following disks:
	sda #first disk in raid5: 250GB
	sdb #the boot disk: 80GB
	sdc #second disk in raid5: 250GB
	sdd #third disk in raid5: 250GB
	sde #fourth disk in raid5: 250GB
	
When I boot the system kernel panics with the following info displayed:
...
ata1.00: cd c8/00:08:e6:3e:13/00:00:00:00:00/e0 tag 0 cdb 0x0 data  
4096 in
exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA stat 0x25)
ata1.00: cd c8/00:08:e6:3e:13/00:00:00:00:00/e0 tag 0 cdb 0x0 data  
4096 in
EXT3-fs error (device sda3) ext_get_inode_loc: unable to read inode  
block
	-inode=8, block=1027
EXT3-fs: invalid journal inode
mount: error mounting /dev/root on /sysroot as ext3: invalid argument
setuproot: moving /dev failed: no such file or directory
setuproot: error mounting /proc:  no such file or directory
setuproot: error mounting /sys:  no such file or directory
switchroot: mount failed: no such file of directory
Kernel panic - not synching: attempted to kil init!

At which point the system locks as expected.

Another perhaps not related tidbit is when viewing sda1 using  (I  
think I did not write down the command) mdadm --misc --examine device  
I see (inpart) data describing the device in the array:

sda1 raid 4, total 4, active 4, working 4
and then a listing of disks sdc1, sdd1, sde1 all of which show

viewing the remaining disks in the list shows:
sdX1 raid 4, total 3, active 3, working 3

and then a listing of the disks with the first disk being shonw as  
removed.
It seems that the other disks do not have a reference to sda1? That  
in itself is perplexing to me but I vaguely recall seeing that before  
- it has been awhile since I set the system up.

Anyway, I think the ext3-fs error is less an issue with the software  
raid and more an issue that fsck could fix. My problem is how to non- 
destructively mount the raid from the rescue disk so that I can run  
fsck on the raid. I do not think mounting and running fsck on the  
individual disks is the correct solution.

Some straight forward instructions (or a pointer to some) on doing  
this from the rescue prompt would be most useful. I have been  
searching the last couple evenings and have yet to find something I  
completely understand. I have little experience with software raid  
and mdadm and while this is an excellent opportunity to learn a bit  
(and I am) I would like to successfully recover my data in a more  
timely fashion rather than mess it up beyond recovery as the result  
of a dolt interpretation of a man page. The applications and data  
itself is replaceable - just time consuming as in days rather than  
what I hope, with proper instruction, will amount to an evening or  
two worth of work to mount the RAID and run fsck.

I appreciate your time and any assistance you may be able to provide.  
If the above is not sufficient let me know and I will try and get at  
more info.

regards and thank you,

-m







