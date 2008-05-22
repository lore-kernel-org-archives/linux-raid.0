From: Anders Johansson <ajh@bth.se>
Subject: Recreating undamaged RAID5
Date: Thu, 22 May 2008 23:59:26 +0200
Message-ID: <20080522215926.GA3783@bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a fully functioning raid5 array with 4 disks that will not start.
The following has happened:

1. I created the array with 3 disks and ran it for about two years.
2. I recently grew the array to 4 disks, no problem.
3. I upgraded to kernel 2.6.18.6 (Debian testing) mdadm v2.6.4.
4. After the upgrade, the array would not start /proc/mdstat marked
   the three original disks as removed and the recently added one as
   active.
5. I was stupid and assumed that re-add meant add without reconstruct
   and added the three missing disks.
6. The array is now still intact but will not start as the disks I
   re-added are marked as spares.

There seems to be two problems here:
The kernel upgrade did something?
How can I mark the spare disks as active without touching the data?


I did test create, but did not complete it. The output is:
mdadm --create /dev/md0 --level=5 --raid-devices=4 --layout=left-symmetric --chunk=64 --assume-clean /dev/sdc1 /dev/sda1 /dev/sdb1 /dev/sdd1
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Fri Mar  9 12:54:19 2007
mdadm: /dev/sda1 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Fri Mar  9 12:54:19 2007
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Fri Mar  9 12:54:19 2007
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Fri Mar  9 12:54:19 2007
Continue creating array? no
mdadm: create aborted.


Let me know if you need any additional information.

Thank you for your help,
//Anders
