From: Federico <undicizeri@gmail.com>
Subject: Best way to re-format RAID1 disks
Date: Thu, 26 Mar 2009 12:10:35 +0100
Message-ID: <26c008d70903260410y22c8af1ocf00138a1ff6a2b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I've two disks in RAID1 formatted with reiserfs which, in my system,
has  amazingly poor performance... I want to switch to ext3 and in a
couple of kernel releases to upgrade to ext4.
This is my plan:

1 - Remove one disk from the array
2 - Format the removed disk with ext3 filesystem
3 - Copy all the data from the degradeted RAID to the newly ext3-formatted disk
4 - Create a new degradeted RAID1 with the ext3 disk
5 - Modify grub and reconfigure mdadm to boot in the ext3 RAID1 disk.
6 - Reboot.
7 - Reformat the reiserfs disk
8 - Add the formatted disk to the ext3 RAID and start to syncing.

Is there a more easy and failproof method?
I'm a bit scared to lose same (or all) of my data during the process...
Thank you for your help :P
