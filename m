From: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>
Subject: QNAP 8 port RAID5 md0 recovery of missing MBR and md superblocks
Date: Thu, 6 Feb 2014 11:16:21 +0000
Message-ID: <A2EC67620EC7424F9EC3DD49243E9060466DC09B@AUDIINSX0328.audi.vwg>
References: <52CBF747.7020505@epos-cat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52CBF747.7020505@epos-cat.de>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>
List-Id: linux-raid.ids

Hi all

As my thread from the 7.1.2014 didn't bring any hint or any reply or way out, I tried to figure out which might get me started again:

As five disks show no md superblock and four didn't see a partition layout (to contain a superblock) I'd like to (re)create a fitting partition and then (re)create a new md superblock info on all disks.

A) should I use parted (manual) or testdisk (export/import)? As I could read the structure from any of the three working disks as all should be the same.

B) my first try would be to (temper with md ...) create a plain 1:1 system like before
"mdadm --create --assume-clean /dev/md0 --level=5 --raid-devices=8 /dev/sd{a,c,d,e,f,g,h}3 missing"
(as the sdb was spilled out some weeks before, so outdated)

When this doesn't work I'd try 

"mdadm --create --assume-clean /dev/md0 --level=5 --raid-devices=8 /dev/sd{a,b,c,d,e,f,g,h}3"
to gather at least the week old layout & data

C) "fsck.ext4 /dev/md0" on the array afterwards

D) "mdadm --detail --scan --verbose > /etc/mdadm.conf"
[which is a missing function in the QNAP md implantation]

Cheers
Michael Samer


