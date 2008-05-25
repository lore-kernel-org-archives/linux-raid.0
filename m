From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Marvell 88SX7042 [4 Port SATA PCI-Express x4] Support/Questions
Date: Sun, 25 May 2008 08:03:22 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805250757550.18572@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff has been working on this chipset/patching/etc:
http://forum.soft32.com/linux/PATCH-sata_mv-HighPoint-2310-support-88SX7042-ftopict338643.html

Manual/specs:
http://www.startech.com/Share/ProductSpecs/PDF/PEXSATA24E.pdf
http://www.rosewill.com/RosewillSoftware/UserManual%20for%20RC-218-WEB%20v1.0.pdf

Looks like there are a couple cards sporting this new chip at the moment, 
here is one:
http://www.newegg.com/Product/Product.aspx?Item=N82E16816132018

http://en.wikipedia.org/wiki/List_of_Marvell_Technology_Group_chipsets#88SXxxxx_SATA_Controllers_Chipsets
It also appears to be supported in the latest kernel.

If one bought enough of these, one could possibly achieve speeds in 
excess(!) of 1 gigabyte/second with enough drives and SW RAID in Linux.
Does anyone have such a card? I would be interested if it could sustain 
the maximum rate from each disk without any contention.

(with an old 965 chipset for example and a lot of 2-port PCI-e cards)
dd if=/dev/sda of=/dev/null bs=1M
dd if=/dev/sdb of=/dev/null bs=1M

The total read speed increases linearly with each additional disk.  Up to 
~700-800 megabytes per second with 12 disks (as reported by dstat) (or 
vmstat 1)..  Same with write (but slower, obviously)...

So my questions are:
1. Does anyone have one of these cards? (not the highpoint with the same 
chip) as that is a RAID card.
2. How 'experimental' is it?

Any other comments?

There are motherboards with multiple PCI-e x8 slots (5) if you look around 
hard enough, imagine 5 of these cards with 20 hard drives, you could have 
one very fast raid array..!

Justin.
