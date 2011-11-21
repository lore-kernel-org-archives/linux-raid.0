From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Question about raid 10 and raid 1+0 setup
Date: Mon, 21 Nov 2011 20:20:02 +0000 (GMT)
Message-ID: <alpine.LRH.2.02.1111212017400.25957@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I have a system with two separate controllers and each controller has
8 disk connected to it, so the disk are numbered as follows:

    controller 1   sd[abcdefgh]
    controller 2   sd[ijklmnop]

Now I would like to setup a raid 10 from 7 disk from each controller.
The first disk on each controller (sda and sdi) is used for some other
purpose. How does one set it up, so that if for example controller 1
fails, the array is still working? Does the following command achieve
what I want:

  mdadm -C /dev/md3 -l10 -n14 --metadata=1.1 --layout=n2 /dev/sd[bkcldmenfogphj]1

If yes, what happens for example if say disk sdc fails and is replaced
after one day? Will it keep the order so always one controller can
break.

I tried setting this up using Raid 1+0 as follows:

  First creating the Raid 1
    mdadm -C /dev/md3 -l1 -n2 --metadata=1.1 /dev/sd[bj]1
    mdadm -C /dev/md4 -l1 -n2 --metadata=1.1 /dev/sd[ck]1
    mdadm -C /dev/md5 -l1 -n2 --metadata=1.1 /dev/sd[dl]1
    mdadm -C /dev/md6 -l1 -n2 --metadata=1.1 /dev/sd[em]1
    mdadm -C /dev/md7 -l1 -n2 --metadata=1.1 /dev/sd[fn]1
    mdadm -C /dev/md8 -l1 -n2 --metadata=1.1 /dev/sd[go]1
    mdadm -C /dev/md9 -l1 -n2 --metadata=1.1 /dev/sd[hp]1

  Then comes the Raid 0
    mdadm -C /dev/md10 -l 0 -n 7 --metadata=1.1 /dev/md[3456789]

This works fine only that I do not manage to set this under
scientific linux 6.1 up so it comes up after a reboot. Only the
Raid 1's will be there after a reboot, not the Raid 0 on top.
Any idea what I am doing wrong?

Regards,
Holger
