From: "Bradley D. Thornton" <website.is@www.NorthTech.US>
Subject: Help with /etc/raidtab
Date: Tue, 8 Jul 2003 14:52:20 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <befehe$k5a$1@main.gmane.org>
Reply-To: "Bradley D. Thornton" <gmane@tallship.net>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been looking around for example /etc/raidtabs and only seem to find
ones that look like this:

raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size     4
        persistent-superblock 1
        device          /dev/sda1
        raid-disk       0
        device          /dev/sdb1
        raid-disk       1
My question is, considering that I have multiple partitions that I want to
array and I also want to boot from my RAID 1 array, can I just do this?
        device          /dev/sda
        raid-disk       0
        device          /dev/sdb
        raid-disk       1
or do I need to do this?
        device          /dev/sda1
        raid-disk       0        device          /dev/sda3        raid-disk
0        device          /dev/sda5        raid-disk       0        device
/dev/sda6        raid-disk       0        device          /dev/sdb1
        raid-disk       1        device          /dev/sdb3        raid-disk
1        device          /dev/sdb5        raid-disk       1        device
/dev/sdb6        raid-disk       1Any assistance would be greatly
appreciated.
---Outgoing mail is certified Virus Free.Checked by AVG anti-virus system
(http://www.grisoft.com).Version: 6.0.449 / Virus Database: 251 - Release
Date: 01/27/03



