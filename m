From: "Thomas F. O'Connell" <tfo@sitening.com>
Subject: "md: could not lock unknown-block" error with two RAID1s, two disks
Date: Wed, 9 Nov 2005 09:55:22 -0600
Message-ID: <1C1E7B36-AA36-471B-A359-3510570502B9@sitening.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I set up a Debian sarge amd64 (2.6.8 kernel) installation on a two- 
disk Opteron machine with LVM on software RAID. The way I configured  
things was to have one RAID1 mount /boot and the other serve as a  
physical volume for LVM, which manages the rest of the filesystem,  
including /.

In order to test the robustness of the system and practice  
reconstructing the RAID, I powered down the machine, pulled a drive,  
and booted up again. Everything came up fine, and /proc/mdstat  
revealed that md0 and md1 each had a single disk.

I powered down again, added the disk, and powered up. Then I tried:

mdadm /dev/md0 -a /dev/sdb

The hot-add was successful, and /proc/mdstat revealed that /dev/md0  
now included two disks.

Then I tried:

mdadm /dev/md1 -a /dev/sdb

Here's what this yielded:

md: trying to hot-add unknown-block(8,16) to md0 ...
md: could not lock unknown-block(8,16).
md: error, md_import_device() returned -16
mdadm: hot add failed for /dev/sdb: Invalid argument

 From what I've read, this suggests that /dev/sdb is "busy", which  
sort of makes sense considering that it's already participating in a  
RAID1 on md0, but mdadm only supports commands affecting a single md.

I tried again with /dev/md1 first, thinking that LVM might be the  
issue, but I get the reverse of the problem, where /dev/sdb is hot- 
added successfully to /dev/md1 but cannot then be added to /dev/md0.

Is this expected behavior, or am I missing something?

--
Thomas F. O'Connell
Database Architecture and Programming
Co-Founder
Sitening, LLC

http://www.sitening.com/
110 30th Avenue North, Suite 6
Nashville, TN 37203-6320
615-469-5150
615-469-5151 (fax)

