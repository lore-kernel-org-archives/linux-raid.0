From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: What is the status of SW-Raid in 2.5.x
Date: Mon, 29 Jul 2002 10:20:24 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0207291008200.29640-100000@talentix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

What's the status of SW-Raid in the 2.5.x kernel? I did try it with
2.5.29 and it does seem to boot fine, however when booting 2.4.19-rc1
it always whant's to resink and then sometimes fails because
it kicks out one or more drives telling me they are bad. Using
only 2.4.19-rc1 everything is ok and I can reboot as much as I want.

My setup is raid1 as root and /home is a raid5 spread over 6 disks
(4 scsci and 2 ide's) and there is also a raid0 partition for playing.
There are also three swap raid1 partitions. System has two CPU's.

Holger

