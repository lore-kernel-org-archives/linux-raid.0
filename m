From: "Jon Robertson" <jonrobertson@sbcglobal.net>
Subject: RAID-5 and Chunk Size, What Filesystem to Use?
Date: Sun, 30 Mar 2003 21:36:31 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <b68cso$ogh$1@main.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been reading the Jakob Oostergard article...and it's amazing how easy
this can be, however I may have been typing too fast....

I have 3 SCSI that are 36GB each and I created my raidtab to look like the
following:

raid-level                     5
chunk-size                   128
persistent-superblock   1
parity-algorithm            left-symmetric
nr-raid-disks                3
device                          /dev/sda
raid-disk                    0
device                          /dev/sda
raid-disk                    1
device                          /dev/sdb
raid-disk                    2
device                          /dev/sdc

my question is (are)
1. is 128 ok for the chunk size?
2. if it's not ok, do I just stop the raid-device and re-do my raidtab file
and then re-do my mkraid /dev/md0 command?
3. what filesystem do you recommend?   All I'm using this server for is file
sharing with SAMBA...

thanks in advance....



