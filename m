From: "Leandro Tracchia" <ltracchia@gmail.com>
Subject: metadata format 00.90 unknown, ignored
Date: Thu, 6 Nov 2008 13:51:49 -0500
Message-ID: <837a927a0811061051heb9081fr51217068eede302e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i'm not sure exactly what i did wrong and i wouldn't mind starting
over only i'm not sure how.

i created a raid level 1 array using 2 disks.

mdadm --create /dev/md0 --level=1 --raid-devices=2   /dev/sda   /dev/sdc

then i realized i was supposed to partition these hard drives before
creating the array.

so i stopped the array after creation was complete,

mdadm --stop /dev/md0

and partitioned the hard drives for linux raid auto 'fd'. i only put
one partition on each hard drive.

then i tried to assemble the array like this:

mdadm --assemble /dev/md0 /dev/sda1 /dev/sdc1

but i get these errors:

mdadm: metadata format 00.90 unknown, ignored.
mdadm: cannot open device /dev/sda1: No such file or directory
mdadm: /dev/sda1 has no superblock - assembly aborted

i'm not sure what to do from here... can someone help??
