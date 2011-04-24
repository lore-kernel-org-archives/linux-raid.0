From: Vernon Tonnesen <jdcpa@earthlink.net>
Subject: http://raid.wiki.kernel.org/ unreachable - need to "lend" clone of
 RAID1 HD to another machine
Date: Sat, 23 Apr 2011 21:51:16 -0400
Message-ID: <4DB38214.4080003@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been trying to get through without success for over an hour. Is the 
content there mirrored somewhere? Is there an alternate, preferably in FAQ 
format?

I have a pair of HDs partitioned with 14 identical partitions each, 7 of 
which on each make up 1 of 2 partitions making up 7 md devices. The seven md 
devices were originally configured through openSUSE installation's YaST2. I 
made a clone of the whole of one HD. This clone I want to attach to another 
machine simply to copy the files from one partition's EXT3 filesystem that is 
a component of md7 on the original machine.

Can I just mount that partition on the other machine RO as an ordinary EXT3 
partition to make the copies, or does that machine need to have a RAID 
"built" or "rebuilt" with mdadm  in order to mount that disks partition as a 
degraded array? Nothing shows up in /dev/mdstat booting with it plugged in, 
even after copying /etc/mdadm.conf from the original machine. I tried 
modprobe raid1, but that didn't seem to affect anything I can tell. Fdisk -l 
/dev/sdb shows me only what I expect, a bunch of 0x83 and 0xfd partitions, 
while fdisk -l produces none of the extra output I'm used to seeing on the 
system with the full RAID1 running.

Problem 2: Looking at the mdadm man page, I really don't understand the 
distinction between build and create, or what a persistent superblock is good 
for.

Help please!
-- 
The husband should fulfill his marital duty to
his wife, and likewise the wife to her husband.
			1 Corinthians 7:3 NIV
VT
