From: Clive Messer <clive@vacuumtube.org.uk>
Subject: Re: RAID-5 recovery
Date: Mon, 4 Sep 2006 00:51:41 +0100
Message-ID: <200609040051.41271.clive@vacuumtube.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday 03 September 2006 14:11, you wrote:
> On Sun, 3 Sep 2006, Clive Messer wrote:
> > This leads me to a question. I understand from reading the linux-raid
> > archives that the current behaviour when rebuilding with a single
> > badblock on another disk is for that disk to also be kicked from the
> > array. For some time I have considered buying a 3ware 9500 card and
> > using that instead of my current ICH6 and md solution. Can anyone tell
> > me what would happen in the same scenario with a 3ware card. ie. would
> > that transparently handle a RAID-5 disk failure and rebuild, with a
> > badblock on another disk? Or would I have even less chance of getting my
> > data back?
>
> I only have experience with the 7500 series card and it does the
> following if you run it in 3ware RAID5 mode:
>
> If there is a read error (bad block) on a disk and the array is not
> degraded, it will recalculate the content of the block from the other
> disks and write the bad block, causing the drive to re-allocate. It
> will log that it did this.
>
> If the array is degraded as per your description, it will default to the
> same behaviour linux kernel does for sw-raid, ie stop rebuilding if it
> encounters a read error.
> If on the other hand you do want it to ignore the read error, you can tell
> it to do so.

Mikael,

Thankyou for the information.
Does anyone have a preference for cards other than 3ware if purchasing
a 'hardware' raid card? From what have read the 3ware cards are very well
regarded and the driver is open source.

Also, while I'm here, I need to purchase 6 low/mid end, non-rackmount servers
for work. Can run any version of Linux on them and will probably choose
a 'free' version. I have been looking at the Dell Poweredge 1800's with sata
drives. Can anyone tell me if the supplied 'CERC 6 SATA RAID CONTROLLER 6
CHANNELS' is well supported on Linux and if it is hardware or software raid?
Has anyone been running these with the md driver - any issues?

Regards

Clive
--
Clive Messer <clive@vacuumtube.org.uk>

-- 
VGER BF report: U 0.493795
