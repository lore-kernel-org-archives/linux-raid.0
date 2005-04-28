From: "miele\@inwind\.it" <miele@inwind.it>
Subject: Can you help me on Linux SW RAID?
Date: Thu, 28 Apr 2005 12:11:37 +0200
Message-ID: <IFNIZD$19CF4F5AC29109D5327F89A86EC57541@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jakob <jakob@unthought.net>, linux-raid <linux-raid@vger.kernel.org>, mingo <mingo@chiara.csoma.elte.hu>, bueso <bueso@vives.org>
List-Id: linux-raid.ids


Hi.

First of all my compliments for your job about Linux SW RAID HOWTO and relative mailing list.

I have a question for you .

I'm using 2 redhat nodes (Kernel version 2.4.21...) with a shared (SCSI) disk array,
and I want to use SW RAID1 features to store data in it.

So I followed the steps below on first node:
1) Using fdisk I Created a partition of type fd (Linux-raid-autodetect) on each devices (disks) of my future raid device /dev/md0. The partition takes entire space of disks.
2) Set properly /etc/raidtab to include my new raid device /dev/md0 (also using persistent-block to have autodetect at startup)
3) Created my raid device using mkraid (mkraid /dev/md0)
Then cause I want to use LVM too I...

4) Created a Physical Volume on my raid device /dev/md0 (pvcreate /dev/md0...)
5) Created the Volume Group containing PV created above
6) Created the Logical Volume on VG created above

Actually I've not yet created nothing on my LV (fs, raw device, ...) cause it's not my goal, but...

It's OK! On my first node all is functioning well.
I also rebooted my first node to see if autodetect is OK and ..It's OK! My raid device /dev/md0 correctly starts at boot.

Then I copied the /etc/raidtab of the first node into the second node and I've rebooted the second node.
Great!!!

All things are correctly autodetected and functioning also on the second node!!!
Raid device /dev/md0 is started and (with my surprise) LVM is already correctly set.. 
.. vgscan, lvscan and pvscan stated on both node produce the same output!!

All is wonderful but.. when all seems ok and my work seems to be finished..
..I'm having hard doubts on this RAID configuration and its stability.
I fear that RAID SW modules that runs on each of two Linux nodes, and works on the same data of the shared disk array, could produce conflicts, misalignments, or I don't know what other..


Can you give me a comment or suggests about RAID SW use i've made?



Thanks a lot in advance for your attention!!

Bye,
Andrea Miele





____________________________________________________________
6X velocizzare la tua navigazione a 56k? 6X Web Accelerator di Libero!
Scaricalo su INTERNET GRATIS 6X http://www.libero.it


