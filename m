From: "Pankaj Agarwal" <pankaj@pnpexports.com>
Subject: Help Root Raid
Date: Thu, 19 Aug 2004 08:47:27 +0530
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00ea01c4859b$12cac440$9a59023d@dreammachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I need your help regarding root raid. I have a root raid implemented server
and it not booting anymore. I tried to use that harddisc as secondary hard
disk to on of my other linux installation..so i can take a backup of files.
The other installation has raid precompiled....as in booting process it
checks for raid arays and at shutdown it gives messages regarding md
devices. however it doesn't show any dev in lsdev or /proc/mdstat. My
problem is when i try to mount it using "mount -t ext2 /dev/md0 /mnt/hdc1"
it gives me error as "wronf fs, bad option, bad superblock on
/dev/md0.........................(aren't you trying to mount a block device
on a logical device)". Kindly show me the way to mount the filesystem.

thanks and regards,

Pankaj Agarwal

