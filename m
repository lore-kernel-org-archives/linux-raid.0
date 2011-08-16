From: Asdo <asdo@shiftmail.org>
Subject: First raid1 sector gets zeroed at first reboot
Date: Tue, 16 Aug 2011 19:42:14 +0200
Message-ID: <4E4AABF6.2070800@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all
sometimes I put grub on the first sector of a MD raid1 device, which is 
on disk partition and not on the whole disk.
(there is another bootloader in the MBR which chainloads this one, and 
that's not the problem)

Sometimes, and I'm not yet able to reproduce it reliably, that sector 
gets zeroed at first reboot.

So the first reboot after installation of the OS + grub indeed succeeds, 
but the next reboot fails. After the first reboot the first sector of 
such MD device gets zeroed, so at the second reboot the bootloader is 
missing. At that point I have to boot with a live-cd again and reinstall 
Grub in there to be able to boot again.

I totally confirm that the sector is nonzero before the first reboot, 
and is zero after the second reboot. Not sure when exactly it gets 
zeroed but it's between those two points in time. I suspect it becomes 
zero at the first reassemble of the MD device.

After the second reboot the problem won't ever happen again on that 
RAID. And if it hasn't happened by that time it won't ever happen again 
on that RAID.
I'm thinking at a bug in some RAID initialization procedure which is 
being delayed at the first reassemble of the device... does this ring 
any bell?

The last time it happened to me (that's yesterday) it was with a 
degraded raid-1 (it was created with a missing device) with metadata=1.0 
. I absolutely confirm that dd'ing the first 512bytes sector from the MD 
device and dd'ing the first sector from the underlying partition both 
resulted in a (identical) nonzero sector before the first reboot. After 
the second reboot both were zero.
Also please note that since it was a degraded raid-1, this excludes a 
resync problem, because there couldn't possibly have been any resync.

Also, the filesystem itself appears intact, so this is a "bug" affecting 
only the very beginning of a MD device.

Anyone knows what's happening?

With reboot I mean: "reboot -h now". And that's a real reboot from the 
bios, no kexec.
I use Ubuntu, and it has been doing this I'd say at least with kernels 
2.6.32 <---> 2.6.38 . Maybe it has always done this.
Happened on various recent Intel CPUs 64bit computers, various HDD 
controllers, and various brands of drives which btw had physical 
512bytes sectors.

