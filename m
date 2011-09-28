From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Creating an md with 3TB drives.
Date: Wed, 28 Sep 2011 10:05:19 +0200
Message-ID: <4E82D53F.3050409@yazzy.org>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys.


I have two 3TB drives and I want to set them up as RAID0.
The problem is I can't use all of the space on them.
I only get 4TB of the 6 in total.

What I tried was:
# parted /dev/sde
GNU Parted 2.3
Using /dev/sde
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted)  mklabel gpt
Warning: The existing disk label on /dev/sde will be destroyed and all 
data on this disk will be lost. Do you want
to continue?
Yes/No? yes
(parted) mkpart primary 0 -0
Warning: The resulting partition is not properly aligned for best 
performance.
Ignore/Cancel? ignore
(parted) print
Model: ATA Hitachi HDS72303 (scsi)
Disk /dev/sde: 3001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
  1      17.4kB  3001GB  3001GB               primary

(parted) quit

Then I used fdisk to change the partition type to Linux raid auto

Finally I ran
mdadm --create /dev/md2 --level=0 --raid-devices=2 /dev/sdd1 /dev/sde1

but mdadm -QD /dev/md2 shows 2TBs are gone.
Array Size : 4294964224 (4096.00 GiB 4398.04 GB)

What to do in this case? How can I a 6TB raid array ?




-- 

Marcin M. Jessa
