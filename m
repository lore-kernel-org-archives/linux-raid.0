From: "Chris Chabot" <chabotc@xs4all.nl>
Subject: Bad block on IDE drive causes it to be kicked out of the array
Date: Mon, 8 Jul 2002 05:51:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001f01c22632$ad349580$0200a8c0@gandalf>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have two raid 5 arrays here on IDE drives (each consiting out of 4 IDE
disks).

The first drive in the second array has 6 bad sectors / bad blocks on it,
and during reconstruction after creating the array these bad blocks are
found, and the disk is kicked out of the array (and the initial background
resync is terminated).

The rest of the disk is just fine, and its had these bad blocks since who
knows how long without any problems

is there any way to create the array, and just mark these blocks bad in the
file system, as you would with a 'normal' drive?

Any info is greatly apreciated,

(ps, i did find some emails on the list about the same problem w/ scsi
drives, but low level formatting the drive and causing the blocks to be
relocated by the scsi hardware solved the problem there.. unfortunatly that
dont work for my IDE drives ;-/)

    -- Chris


