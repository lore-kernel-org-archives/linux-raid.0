From: Robert Steinmetz <rob@steinmetznet.com>
Subject: Hard Drive Partition Table shows partition larger than drive
Date: Sun, 26 Apr 2020 13:49:16 -0400
Message-ID: <6ee9392d-8867-f0b5-193e-17a516bb7e0e@steinmetznet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a drive that was pulled from a Ubuntu 18.04 raid 1 and set aside. 
I am trying to se what can be done with the drive.
I installed it is a external USB enclosure and connected it to a Ubuntu 
18.04 desktop,

The Drive is a 1 TB Toshiba drive but gparted and gnome-disks give 
really odd results.

Starting gparted from a terminal I get this message:
Code:

gparted
Unit -.mount does not exist, proceeding anyway.
======================
libparted : 3.2
======================
Can't have a partition outside the disk!

Gparted reports sdb as 931.51GiB but reports partition sdb1 as 7.25 TiB.
Gparted has the following warning:
Code:

Unable to detect file system! Possible reasons are:
- The file system is damaged
- The file system is unknown to GParted
- There is no file system available (unformatted)
- The device entry /dev/sdb1 is missing

boot and raid flags are set.
Obviously something is wrong.
I originally use the drive to replace another smaller drive in a Raid 1 
array and that array was created with mdadm and maybe lvm2.
Is there a reasonable way to see if the drive has anything usable in it?
