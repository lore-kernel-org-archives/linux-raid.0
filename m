From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: auto start raid0 with no superblock?
Date: Tue, 4 Aug 2009 14:44:52 -0600
Message-ID: <200908041444.52747.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm testing out accessing a "Windows DynamicDisk Raid0" array under linux, and 
for the most part it works very well. My only problem is mdadm will not auto 
start the array even when I have it setup in mdadm.conf (mdadm is told to auto 
start all arrays found there). Basically I have to manually run "mdadm --build 
/dev/md0 --chunk=64 --level=raid0 --raid-devices=4 /dev/sdc1 /dev/sdd1 
/dev/sde1 /dev/sdf1" then "mount /mnt/winraid" when I want to access the 
filesystem (using ntfs-3g if anyone was wondering).

All I get from mdadm/syslog is this:
Aug  4 02:43:10 natasha kernel: [    7.862373] md: md0 stopped.                                                                                                                           
Aug  4 02:43:18 natasha mdadm[3597]: DeviceDisappeared event detected on md 
device /dev/md0

The reason I'm trying to use non persistent superblocks is I'm assuming trying 
to save them will damage the windows DynamicDisk metadata in some way.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
