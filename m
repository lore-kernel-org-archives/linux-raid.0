From: Carlos Mennens <carloswill@gmail.com>
Subject: RAID1 On 3 Drives
Date: Sat, 13 Mar 2010 16:06:38 -0500
Message-ID: <d80f793f1003131306i1eb1d839w5552e048001e6193@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was told by my distributions Wiki page that Grub doesn't support
RAID 5 or RAID 6 so I would need to create a volume with three disks
and set the level to RAID 1:

# mdadm --create /dev/md1 --level=1 --raid-devices=3 /dev/sda1
/dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1

Is this possible to mirror three identical drive partitions? I was
talking to some co-workers and was told that I could only pair two
drives on RAID 1.

Can anyone please help me understand this?
