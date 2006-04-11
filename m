From: Anton Petrusevich <casus@casus.us>
Subject: mdadm does not want to create partitions
Date: Tue, 11 Apr 2006 23:10:19 +0200
Message-ID: <200604112310.19991.casus@casus.us>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I need help with RAID-0 array. I would not ask it here if I were able to find 
information what to do in my case. Ok, the problem. Our datacenter had a 
power failure and after that I am trying to bring up all services at one our 
server that uses partitioned RAID-0 array for Oracle tablespaces. I was 
partiotioned and fdisk sees it: 
# fdisk -l /dev/md1

Disk /dev/md1: 366.5 GB, 366555955200 bytes
2 heads, 4 sectors/track, 89491200 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/md1p1             1  15869142  63476566   83  Linux
/dev/md1p2      15869143  31738284  63476568   83  Linux
/dev/md1p3      31738285  47607426  63476568   83  Linux
/dev/md1p4      47607427  89491200 167535096    5  Extended
/dev/md1p5      47607427  63476568  63476566   83  Linux
/dev/md1p6      63476569  79345710  63476566   83  Linux
/dev/md1p7      79345711  80566414   4882814   83  Linux
/dev/md1p8      80566415  89491200  35699142   83  Linux

but, I have:

# mdadm -A /dev/md1 --auto=part8
mdadm: that --auto option not compatable with device named /dev/md1

It can be assembled only as non-partitioned, --auto=part or mdp do not work 
also. I need my partitions back, but I don't understand what I can do. The 
kernel is from RHEL-4 2.6.9-22.EL.roothugemem (custom build for RedHat 9). It 
was working before the power failure. 
-- 
Anton Petrusevich
