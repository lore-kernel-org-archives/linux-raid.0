From: Holger Mauermann <mauermann@gmail.com>
Subject: LVM on raid10,f2 performance issues
Date: Mon, 01 Dec 2008 01:00:32 +0100
Message-ID: <49332920.5010503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When I setup LVM on top of a 4 disk RAID 10 with f2 layout read/write
performance is really worse - it's far below single drive speed...

I did some testing with dd and hexdump and I noticed that after writing
a 128k file (with 64k "X" and 64k "Y") to the lvol the data on the raw
disks looks somewhat weird:

sda:  sdb:  sdc:  sdd:
----------------------
YYYY  ....  ....  XXXX
....  ....  ....  ....
XXXX  YYYY  ....  ....
....  ....  ....  ....

Any hints how to tune this? With LVM on a standard RAID 10 (n2) the data
appears as expected on the disks:

sda:  sdb:  sdc:  sdd:
----------------------
YYYY  YYYY  XXXX  XXXX
....  ....  ....  ....
....  ....  ....  ....
....  ....  ....  ....


