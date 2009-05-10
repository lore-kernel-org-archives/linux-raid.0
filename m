From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: extending raid-5 ?
Date: Mon, 11 May 2009 01:00:18 +0200
Message-ID: <795999990.20090511010018@kaneda.iguw.tuwien.ac.at>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

I'm currently using a 4*750GB SATA RAID-5 under centos 5.2 (mdadm
v2.6.4, kernel 2.6.18-128.1.6.el5) which I need to exend by replacing
the 750GB disks with 1.5TB ones.

since the mainboard has only 4 SATA ports, I need to replace one disk
after the other. I came up with the following plan:

1) fail first disk
  mdadm /dev/md0 -f /dev/sda1

2) remove first disk
  mdadm /dev/md0 -r /dev/sda1

3) shutdown the server, unplug 750GB sda drive, plug in 1.5TB drive

4) create a linux raid autodetect partition on sda which covers the
whole 1.5TB

5) add new device to the raid5 and wait until resync has finished
  mdadm /dev/md0 -a /dev/sda1
  
... repeat steps 1 tp 5 for sdb to sdd

6) grow the raid
  mdadm --grow /dev/md0

7) resize the xfs filesystem
   xfs_growfs /md0-mount-point
   
is this the proper way to do it, are there any issues I should know
about ?

thnx in advance.

