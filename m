From: Vernon Tonnesen <jdcpa@earthlink.net>
Subject: http://raid.wiki.kernel.org/ unreachable - need to mount HD clone
 of a RAID1 HD in other system to copy some files
Date: Sat, 23 Apr 2011 22:27:50 -0400
Message-ID: <4DB38AA6.4070802@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

http://raid.wiki.kernel.org/ has been "loading" in my browser for around 2 
hours. Reloading doesn't help. Does it have some kind of mirror elsewhere, 
preferably in FAQ form.

I installed openSUSE to a pair of HDs identically pre-partitioned to 14 each, 
7 of which on each were paired to make 7 md devices 0-6 by YaST2 during 
installation.

I made a whole disk clone of one of those 2 HDs while booted to a Knoppix CD. 
I want to use the clone temporarily in another system just to copy off some 
files.

I can't make heads or tails out of where to start. Fdisk -l /dev/sdb with the 
clone attached to the extra system produces the expected output of 14 0x83 & 
0xFD partitions, while simply fdisk -l fails to produce the usual extra 
output on the original machine running the full RAID1 assortment.

Can the partition containing the files I want be mounted RO as an ordinary 
EXT3 partition to make the copies? If not, where do I start? /proc/mdstat has 
no devices listed, even after rebooting with a copy of /etc/mdadm.conf from 
the original system. modprobe raid1 didn't accomplish anything that I can 
tell beyond being loaded in RAM. mdadm monitor doesn't really give useful 
clues. The man page doesn't say enough about mdadm build or create to 
understand the distinction and whether or which I might need, nor the 
significance of persistent superblocks that may or may not be needed.

Please help!
-- 
The husband should fulfill his marital duty to
his wife, and likewise the wife to her husband.
			1 Corinthians 7:3 NIV
VT
