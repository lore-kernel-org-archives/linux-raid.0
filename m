From: Michael Stumpf <mjstumpf@pobox.com>
Subject: resize2fs failing--how to resize my fs?
Date: Tue, 13 Dec 2005 10:00:25 -0600
Message-ID: <439EF019.7060800@pobox.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I get this from the latest stable resize2fs:

[root@foo parted]# resize2fs /dev/my_vol_grp/my_log_vol
resize2fs 1.38 (30-Jun-2005)
Resizing the filesystem on /dev/my_vol_grp/my_log_vol to 488390656 (4k) 
blocks.
Killed

Parted (again, latest stable) tells me the following:
Using /dev/mapper/my_vol_grp-my_log_vol
(parted) resize 1 0 100%                                                 
No Implementation: This ext2 file system has a rather strange layout!  
Parted can't resize this (yet).
(parted) 

Similar results from ext2resize/ext2online.  This is an ordinary ext3 
fs, living inside an LVM2 that has already been increased to accomodate 
(used all free extents)..  I've resized it down and up before, though it 
is possible I am resizing it larger than it has been before (1.8TB). 

Not sure what's up.  Any advice welcome; my research in this has me 
getting a bit nervous about lvm2 bugs causing loss of data.  While I 
want a single resilient (via raid 5) volume, I may be willing to ditch a 
whole layer of software (lvm2) to get some security. 




