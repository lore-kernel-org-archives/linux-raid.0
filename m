From: "John Stoffel" <john@stoffel.org>
Subject: Re: PCI ATA EIDE cards and kernel drivers
Date: Tue, 22 Apr 2008 11:11:46 -0400
Message-ID: <18446.50.8995.663510@sail.stoffel.home>
References: <alpine.LFD.1.10.0804220658410.31467@www.karsites.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804220658410.31467@www.karsites.net>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Roberts <keith@karsites.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Keith> I'm running Fedora 8, and having suffered a recent hard disk
Keith> failure, I want to set up a RAID1 array of two EIDE ATA 133
Keith> physical drives for my server. These will use the maximum
Keith> number of partitions allowed under Linux. 

Umm.. why?  Just make a single partition on each disk which spans the
entire disk, then use mdadm to mirror those two partitions.  Then use
LVM to create the Physical Volume (PV) on the RAID1 mirror, then
create your Logical Volumes (LVs) ontop of the PV.  You can create as
many LVs as you like.

Keith> I also want to use a seperate non-raid ATA drive for making
Keith> backups of important data from the RAID arrays. So in total I
Keith> would have my important data on three seperate physical drives.

Good plan.  Now automate it so you don't forget.  :]

Keith> I'm also making backups of my data to CD-R and DVD+R as well.

I find the cost of CD-R media and DVD+R, as well as the issues with
longevity, to be my biggest concerns.  For those types of media,
having a very robust and redundant easy to recover format would be
key.  Haven't seen it done yet, though it's been talked about.  An
Archive filesystem, not a general access one.  

Keith> I have the standard EIDE connectors on my Motherboard, which
Keith> will be used for the backup ATA drive, and the DVD RW optical
Keith> drive. All drives will use separate cables and work as master
Keith> drives. This applies to the RAID1 array drives as well.

Yup, this should work just fine.

Keith> **My Questions are:**

Keith> Do the PCI EIDE cards need to be supported with kernel drivers,
Keith> or can I put any PCI EIDE card in the machine and it will 'just
Keith> work'?

Keith> Obviously I don't want to buy the wrong PCI EIDE/ATA controller
Keith> card.

It all depends on which modules FC8 has already compiled, but I
suspect they have most of the standard ones already there.

I've personally got a HighPoint HPT302 rocket RAID IDE controller in
my system and it's worked well for quite a few years now.  But in this
day and age, why aren't you going SATA or have you already got the
drives you're going to be using? 

Keith> Can anyone recommend any PCI EIDE ATA controller cards that are
Keith> known to work under the latest versions of Linux please,
Keith> without me having to keep re-compiling the kernel to support
Keith> the PCI EIDE card?

Keith> I'm running kernel-2.6.24.4-64.fc8

REally, it's all up to the Fedora Core people which modules they
provide by default, so take a look in /lib/modules/... for what's
there.

I've also got a SIL3112 two/four port PCI Sata card and I've been
happy with that one as well.

Cheers,
John
