From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Can't boot from /dev/md0 (RAID-1)
Date: Sun, 30 Jun 2002 15:37:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200206301537.44139.roy@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I hope this is not OT - didn't find any LILO mailing list. after trying 
virtually everything - can anyone help me with a tip?


Running 2.4.19-pre10-ac2, RedHat 7.3 (LILO version 21.4-4), I have root on 
/dev/md0 on RAID-1 on /dev/hda1 and /dev/hdb1. I've tried the howto at 
http://www.tldp.org/HOWTO/mini/Boot+Root+Raid+LILO-3.html#ss3.1, but it still 
doesn't help me. lilo just tells me "L 99 99 99 99 ..." some half a page, and 
then stops.I'm trying. All the time it prints this, it seems to be searching 
the floppy for some reason.


The lilo.conf suggested by the above HOWTO, is this


# lilo.conf.hda - primary ide master
disk=/dev/md0
bios=0x80
sectors=63
heads=16
cylinders=39770
partition=/dev/md1
start=63
boot=/dev/hda
map=/boot/map
install=/boot/boot.b


image=/boot/bzImage
        root=/dev/md0
        read-only
        label=LinuxRaid


sector/head/cylinder is corrected to the actual data reported from 'fdisk 
-ul'. 


When trying to set. boot=/dev/hdm (which is the first drive on the on-board 
chipset), lilo installs, and I get LI instead of L 99 99 ... Same result with 
LBA32.


I also have another box with Linux, running SuSE 7.2 (LILO version 21.7-5) 
with RAID-1 on two drives. Here everything works fine


thanks for all help


roy

-- 
Roy Sigurd Karlsbakk, Datavaktmester

Computers are like air conditioners.
They stop working when you open Windows.

