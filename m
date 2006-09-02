From: Josh Litherland <josh@temp123.org>
Subject: Superblock checksum problems
Date: Sat, 02 Sep 2006 18:36:50 -0400
Message-ID: <1157236610.8070.7.camel@localhost>
Reply-To: josh@temp123.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Attempting to build a new raid5 md array across 4 hard drives.  At the
exact moment that the drive finishes rebuilding, the superblock checksum
changes to an invalid value.  During the rebuild, mdadm -E for the 4
drives shows:

       Checksum : 70c0863a - correct
       Checksum : 70c0864c - correct
       Checksum : 70c0865e - correct
       Checksum : 70c08670 - correct

The instant it finishes:

       Checksum : 70c0bc47 - expected 70c0bc27
       Checksum : 70c0bc59 - expected 70c0bc39
       Checksum : 70c0bc6b - expected 70c0bc4b
       Checksum : 70c0bc7d - expected 70c0bc5d

Kernel is 2.6.17.11.

Controller is 4-port silicon image:

0000:00:08.0 RAID bus controller: Silicon Image, Inc. SiI 3114
[SATALink/SATARaid] Serial ATA Controller (rev 02)

Drives are seagate 250G sata ST3250824AS

-- 
Josh Litherland (josh@temp123.org)



-- 
VGER BF report: U 0.669701
