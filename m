From: "stephan sperber" <quinte17@gmx.de>
Subject: create a partial raid5
Date: Thu, 9 Feb 2006 12:40:44 +0100 (MET)
Message-ID: <15869.1139485244@www090.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

Is it possible to create a Radi5 with only 2 disks? (I know that Raid5 
needs 3 to be really redundant)

With a Raid1 I can do things like:
mdadm -C /dev/md0 --force --raid-devices=1 /dev/hdb2
mkreiserfs /dev/md0

copy files from an older drive to the raid, get the old drive out and put 
the new disk for the raid in.
then
mdadm -G /dev/md0 --raid-disks=2
mdadm -a /dev/md0 /dev/hdc2

and the raid1 is now a real raid1 (after sync)

It would be great to have something similar for raid5:
mdadm -C /dev/md0 --force --raid-devices=2 /dev/hdb2 /dev/hdc2
mdadm -G /dev/md0 --raid-disks=3
mdadm -a /dev/md0 /dev/hda2

or
mdadm -C /dev/md0 --force --fail=/dev/hda2 --raid-devices=3 /dev/hdb2 /
dev/hdc2
mdadm -a /dev/md0 /dev/hda2

i know that this is possible with raidtools and /etc/raidtab.

is this possible with the recent version of mdadm or is it a planned 
feature (or not planned)?

thanks in advance
stephan



-- 
Telefonieren Sie schon oder sparen Sie noch?
NEU: GMX Phone_Flat http://www.gmx.net/de/go/telefonie
