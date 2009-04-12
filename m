From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Converting system to raid
Date: Sun, 12 Apr 2009 12:55:33 -0700
Message-ID: <000b01c9bba8$a5b08a40$0a00a8c0@vorg>
References: <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <f19d625d0904110729y30e8bc80m41fcd8f2c3298d49@mail.gmail.com> <007001c9bad6$2525c610$0a00a8c0@vorg> <001201c9bb09$3161e9d0$0a00a8c0@vorg> <20090412111107.GA19413@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While booted on the array I renamed device.map and ran:
sudo grub --no-floppy --device-map=/boot/grub/device.map

But the new map is the same:
(hd0) /dev/hda
(hd1) /dev/sda
(hd2) /dev/sdb

----- Original Message ----- 
From: "Robin Hill" <robin@robinhill.me.uk>
To: <linux-raid@vger.kernel.org>
Sent: Sunday, April 12, 2009 4:11 AM
Subject: Re: Converting system to raid

> Before when at the grub boot menu when booting with the ide moved
> below the sata drives, droping to command line for grub showed that
> the ide drive only moved down 1, not 2. It seemed to have:
>   hd0 = sda
>   hd1 = hda
>   hd2 = sdb
> 
> Now with the array booted, going to the grub command line and using
> auto complete for "root (hd0," it seems to be using the device map at
> this point which is no longer correct:
> (hd0) /dev/hda
> (hd1) /dev/sda
> (hd2) /dev/sdb
> 
> Note that in the other system, because linux was installed with only
> the ide and 1 sata drive, it doesn't even list the other two in it's
> device map. So what is the best/safest way to update/correct this to
> what ever it should be?
>
Just delete/rename the old device map file (/boot/grub/device.map) and
run grub again - it'll rescan the devices and create a new map file.
