From: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Mon, 3 Oct 2005 10:33:09 -0600
Message-ID: <7f55de720510030933k26608cfsda63326a8438e35d@mail.gmail.com>
References: <dhje16$tmq$1@sea.gmane.org> <433F63BB.3020008@nighthawkrad.net>
Reply-To: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <433F63BB.3020008@nighthawkrad.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: Robin Bowes <robin-lists@robinbowes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/1/05, Christopher Smith <csmith@nighthawkrad.net> wrote:
> I use a combination of Linux's software RAID + LVM for a flexible,
> expandable data store.  I buy disks in sets of four, with a four-port
> disk controller and a 4-drive, cooled chassis of some sort (lately, the
> Coolermaster 4-in-3 part).
>
> I RAID5 the drives together and glue multiple sets of 4 drives together
> into a single usable chunk using LVM.

Sounds pretty cool.  I've used software RAID but never LVM, let me see
if I understand your setup:

At the lowest level, you have 4-disk controller cards, each connected
to a set of 4 disks.  Each set of 4 has a software RAID-5.  All the
RAID-5 arrays are used as LVM physical volumes.  These PVs are part of
a single volume group, from which you make logical volumes as needed.

When you want more disk, you buy 4 big modern disks (and a 4x
controller if needed), RAID-5 them, extend the VG onto them, and
extend the LV(s) on the VG.  Then I guess you have to unmount the
filesystem(s) on the LV(s), resize them, and remount them.

If you get low on room in the case or it gets too hot or noisy, you
have to free up an old, small RAID array.  You unmount, resize, and
remount the filesystem(s), reduce the LV(s) and the VG, and then
you're free to pull the old RAID array from the case.


> Apart from the actual hardware installations and removals, the various
> reconfigurations have been quite smoothe and painless, with LVM allowing
> easy migration of data to/from RAID devices, division of space, etc.
> I've had 3 disk failures, none of which have resulted in any data loss.
>   The "data store" has been moved across 3 very different physical
> machines and 3 different Linux installations (Redhat 9 -> RHEL3 -> FC4).

Your data survives one disk per PV croaking, but two disks out on any
one PV causes complete data loss, assuming you use the stripe mapping.

You use SATA, which does not support SMART yet, right?  So you get no
warning of pending drive failures yet.

None the less, sounds like a nice flexible setup.


--
Sebastian Kuzminsky
