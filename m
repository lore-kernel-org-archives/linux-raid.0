From: "Stephan Kessler" <root@warpy.yomeganet.biz>
Subject: Badblocks with RAID-1 on Root device - Will this work?
Date: Sun, 15 Feb 2004 12:30:30 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004601c3f3b7$1ebd8f10$4db0fea9@kessler.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List,

I got the following problem:

My Discs in my Web-Server with an RAID-1 SW Array starting to get
BadBlocks. I got 2 Raid devices /dev/md0 and /dev/md1.

/dev/md0 -> /dev/hda1 and /dev/hdc1 mounted as /
/dev/md1 -> /dev/hda2 and /dev/hdc2 mounted as swap

I aint got physical access to my machine because it is far away in a
computer center, or whatever it is called.... ;)

Now i want to mark the badblocks. I searched the Archives and found
that:
http://marc.theaimsgroup.com/?l=linux-raid&m=103505358006012&w=2

My Question is now:
Will this work with an "all the time" mounted /dev/md0 Partition. Ok i
think the removing of the Disc will work, and the badblock check too.
But can i add the Blocks which should be marked with e2fsck to a mounted
device?

If not, how can i fix the BadBlock Problem with just having ssh?

Thank you in advance for the help! And a nice Sunday of course ;)

Greetings from "Good old Germany",
Stephan

