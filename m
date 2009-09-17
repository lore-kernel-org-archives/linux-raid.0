From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Formatting Raid5 device as NTFS
Date: Thu, 17 Sep 2009 12:23:22 -0700
Message-ID: <f5d1f90a0909171223h684e5f65k405fa319ab6be8d9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello:

I have to bundle 4 disks as a Raid5 device, export it to iSCSI
initiators and format it as NTFS.

What is better:
- Format individual disks as NTFS and then bundle them as Raid5 device
and export to initiator PCs
- Or bundle the disks first as Raid5 dev, export them and then format
the /dev/md0 device as NTFS

I get "write-protected" errors when I do the second option. Does it
mean formatting of raid5 device is not allowed?
Does Raid5 inherit the NTFS properties of individual disks (first option)?

Thanks!
