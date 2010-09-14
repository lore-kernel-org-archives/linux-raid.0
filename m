From: "Pol Hallen" <raid1@fuckaround.org>
Subject: [raid5] 3 disks, after tests 2 spares disks
Date: Tue, 14 Sep 2010 18:11:18 +0200 (CEST)
Message-ID: <1d42070e419e0e6b80b9f40f85d0946b.squirrel@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy all :-)

I've a pc-test raid5 using mdadm 2.6.7.2-3 (debian stable)

3 sata disks with raid5 (1 spare disk) = total 3 disks

Everything ok :-)

For purpose tests while raid5 had active I disconnected 2 disks.

Now I tried to assemble raid5 but I can't :-(

mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1

mdadm: /dev/md0 assembled from 1 drive and 2 spares - not enough to start
the array

because mdadm see 1 active device and 2 spare disks.
Why?

I need revert 1 spare device to active device but I don't understand how.

What I will to do?

For hours I looking for any solution but nothing..

Thanks

Pol

