From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: RAID 5 disk format for Promise SuperTrak Sx6000 (Linux)
Date: Sun, 26 May 2002 10:01:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A1A5A3BBFEB3D24E8D84F91AFC8452E3046A68@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: ewitness - Ben Fowler <bfowler@ewitness.co.uk>, linux-raid@vger.kernel.org
Cc: ewitness - David Pearce <dp@ewitness.co.uk>
List-Id: linux-raid.ids

Hi Ben,

> I know that I need help because of the five disks making up the array
> no fewer than three are recognised as 'free', that is, not part
> of the array. I suspect that the data on these disks is fine, and
> that the problem was a transient failure on one of the disks, followed
> by a catastrophe. If I knew how, I would 'force' the controller to
> use and resync those disks.

Welcome to the club - I went through EXACTLY the same scenario only last weekend, with my Promise SX6000. the actual solution is very simple:

you can tell the promise controller to recreate the raid - meta information without touching the data on the disks. BTW, this will only work if you didn't change the sequence of disks on the controller since creating the array (swapping disk1 and disk2 for example).

reboot the system, go into the SX6000 Bios Setup.

* Check the parameters of the existing array (stripe size, GB boundry)
* Delete the existing array
* create a new array using all disks and set the "INIT ARRAY" parameter to OFF!!
* Save changes, reboot.

If the sequence of disks is OK, the data will still be completely there and you can backup/save the data off the array. Since parity data is probably incorrect at this satate, you'll need to rebuild the parity information to get back to a redundant system that can continue working if a disk fails. I've used the (Windows) remote management utility to do this, don't know if there'S something similar available for linux.

Bye, Martin.

PS: Being afraid to loose data, I an image copy of all the disks on the promise controller before trying this.. of cours this is only possible if you've got enogh spare harddsiks available; just hook them up to onboard IDE and copy using dd if=/dev/hda of=/dev/hdc ...

