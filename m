From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: RAID1 root - troubles booting in degraded mode
Date: Wed, 30 Oct 2002 11:52:25 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D66703142F@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Massimiliano Masserelli <negro@interim.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Massimiliano

> If I disconnect /dev/hda before booting, the kernel tries to 
> initialize the array, can't access /dev/hda1 (no wonder), marks it as 
> faulty, then refuses to initialize the array, 
> dieing with a kernel panic, unable to mount root.

This look like you're initializing the array from an initrd using raidstart.

Reason why it's not working: raidstart is stupid. it just reads the first
device from raidtab and tries to read the raid superblock from there. if the
first device listed in raidtab doesn't work, raidstart can't start the array.

What to do about it:

a) you could compile raid into your kernel (not as modules), set the
partition type of the raid partitions to 0xfd and have the kernel
automatically initialize the raid array. This works even if device name and
or device order of the raid devices has changed.

or 

b) use Neil Browns mdadm instead of raidstart in the initrd - it's a
replacement for the older raidtools and doesn't have any problem when the
first device is down.

Bye, Martin


