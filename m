From: Blurg <blurg@gluipzak.nl>
Subject: Raid 1 visible as /dev/sda1 ?
Date: Sun, 16 Jun 2002 23:15:47 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.40.0206162315160.15814-100000@megalosaurus.recast.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, today I was busy investigating hardware RAID for my Dell poweredge
2500. As far as I can see I want the RAID 0+1 configuration:
( 4x 70GB)
Logical device set RAID 0 (2 striped disks) : SCSI ID 2 and SCSI ID 3.

this RAID 0 set will then be mirrored in a RAID 1 mirror set of 2 disks:

SCSI ID 1 and SCSI ID 2

   -------------------------	    ----------------------
   |	______   _______   |  RAID 1|  _______   _______ |
   |	| ID2 |  | ID3 |   |  ----> |  | ID0 |   | ID1 | |
   |	-------  -------   |	    |  -------   ------- |
   -------------------------	    ----------------------
              ^^^
	     RAID 0

I configured the RAID 0 set as bootable in the PERC 3 Dell tool

Then, I booted into the Debian setup, and checked with fdisk,

I have /dev/sdb1 : 140GB

but I also have a /dev/sda1 of 70GB, this is something I should not see, I
presume? Is there something wrong then? I thought the only thing Linux
should see is the RAID 0 striped set of 140GB?

Hoping I made my problem clear enough,

Jurgen

      	        http://geographiczoom.com
         -* Pictures from all over the world! *-




