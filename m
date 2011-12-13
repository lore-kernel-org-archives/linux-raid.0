From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Mount Linux Raid Array on new install
Date: Tue, 13 Dec 2011 20:49:15 +0000
Message-ID: <4EE7BA4B.7070709@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everyone,

I've got a pretty basic question and I hope someone can help me.

Currently, I have a server with 4 spindles. The 4 spindles (sda, sdb, 
sdc and sdd) have the follow MD RAID arrays on them:

RAID1 (all 4 disks) for host OS (/)
RAID1 (all 4 disks) for swap
RAID1 (all 4 disks) for /boot
RAID10 (all 4 disks) for LVM

I wish to move my host OS onto a USB flash disk, and use my metal 
spindles solely for the RAID10 LVM. Assuming I install a fresh copy of 
CentOS onto a USB stick, how would I go about re-mounting the RAID10 
array, without destroying any data? Obviously, I don't care about the 
swap or boot partitions. Also, the old host OS on the spindles would be 
handy to keep, however it wouldn't be the end of the world if I lost 
this. The important issue is to keep the data from the LVM array.

Any advice is appreciated

Thanks
