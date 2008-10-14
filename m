From: thomas62186218@aol.com
Subject: Potential mdadm 2.6.7 bug: Cannot grow linear arrays with superblock v1.0,
 1.1, or 1.2
Date: Tue, 14 Oct 2008 12:28:30 -0400
Message-ID: <8CAFC3107449F0E-C80-C20@mblk-d47.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have come across what is a potential bug in mdadm 2.6.7. (unless I am 
missing something)

Environment:
Ubuntu Linux 8.0.4 64-bit (Hardy)
Intel dual socket quad-core server with 16GB RAM
10 SATA II 500GB hard drives
mdadm v2.6.7

Test 1: Attempt to grow linear md device with v1.0 superblock with 
additional hard drive. Failed.

root@localhost:/usr/local/apache2/htdocs# mdadm --grow /dev/md6 --add 
/dev/sdd1
mdadm: internal error - sb_offset is wrong
Aborted

Test 2: Attempt to grow linear md device with v1.0 superblock with 
another linear md device with 1.0 superblock. Failed.

root@localhost:/usr/local/apache2/htdocs# mdadm --grow /dev/md6 --add 
/dev/md5
mdadm: internal error - sb_offset is wrong
Aborted

Test 3: Attempt to grow linear md device with default 0.9 superblock 
with additional hard drive. Success.

root@localhost:/usr/local/apache2/htdocs# mdadm -C -f -R /dev/md7 -l 
linear -n 2 /dev/sdb1 /dev/sdc1
mdadm: array /dev/md7 started.
root@localhost:/usr/local/apache2/htdocs# mdadm --grow /dev/md7 --add 
/dev/sdd1
root@localhost:/usr/local/apache2/htdocs# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md7 : active linear sdd1[2] sdc1[1] sdb1[0]
      1025436608 blocks 64k rounding

unused devices: <none>


I would appreciate any thoughts on this. I definitely want to use the 
more modern superblock version but I also need the ability to grow 
linear md's.

Also, any plans on enabling "reshaping" or growth for RAID 0 and RAID 
10 md's?

Thanks!
-Thomas
