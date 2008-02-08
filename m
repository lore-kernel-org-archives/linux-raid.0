From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: Any inexpensive hardware recommendations for PCI interface cards?
Date: Fri, 8 Feb 2008 11:21:01 -0000
Message-ID: <11ae01c86a44$aff357a0$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi All,

I currently have a couple of IT8212 PCI ATA RAID (1, 0 ot 1+0) cards
which Linux RAID doesn't seem to like too well.  Initially I tried
creating an array out of 4 disks on the 4 primaries over the 2 cards.
Although this seemed to work, the access performance was impossibly low
and I never actually got to the point of leaving it for a week to build
the array.

Since then, I have striped 2 of the drives (just primaries again and
known to be good drives) on a single card using the cards own striping
capability.  This striped drive, I've that added to my RAID 5 array as a
500GB single disk.

The grow into this disk worked fine as did the resize2fs.  As soon as I
tried to copy data onto the array, the system marked the  disk as
faulty.  Now currently I'm running a degraded array anyway as I'm
waiting for the replacement of the drive that failed with bad sectors
when I initially started the grow. So I had to use assemble --force to
get the md device back online.  I've not mounted it since. (I know it's
wise not to use the drive while it's degraded, but if I can get the data
off of a 320GB HD, then I can stripe that with another disk on the other
ITE card, and add in a spare to the array).

Can anyone see any issues with what I'm trying to do?
Are there any known issues with IT8212 cards (They worked as straight
disks on linux fine)?
Is anyone using an array with disks on PCI interface cards?
Is there an issue with mixing motherboard interfaces and PCI card based
ones?
Does anyone recommend any inexpensive (probably SATA-II) PCI interface
cards?

The motherboard has run out of sensible interfaces (I'm not using both
primary and secondary in an array on IDE), but I'd still like the
capacity to grow my array further.

Thanks again for the help.

Steve.

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.19.21/1265 - Release Date:
07/02/2008 11:17
 

