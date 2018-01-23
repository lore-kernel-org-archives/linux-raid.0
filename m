From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recovering Partial Data From Re-Added Drive
Date: Tue, 23 Jan 2018 23:46:10 +0100
Message-ID: <20180123224610.GA8114@metamorpher.de>
References: <CAPE0SYx2Pf=hVe46NVLqTC3g9WQd1MckceS818bWzeNYdOVkNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPE0SYx2Pf=hVe46NVLqTC3g9WQd1MckceS818bWzeNYdOVkNQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liwei <xieliwei@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 24, 2018 at 01:16:43AM +0800, Liwei wrote:
> I have a RAID6 running degraded (12 out of 13 drives).
[...]
> thus I decided not to order a replacement for the drive that died.

A gamble that kicked you straight into Murphy's lawnmower.

> I imaged the drive with pending sectors

Do you have the ddrescue log/map to go with that?
If you did not use ddrescue - what did you use exactly?

If you know what the bad sectors were you can try fill those gaps 
with data from the other drives if it wasn't synced over.

If you still have the drive and sectors still bad, you can produce 
the map belatedly by copying it again... if you wiped it and 
sectors were reallocated, no such luck.

> When that didn't work out, I absent-mindedly decided to re-add the
> drive that glitched out and the raid started to re-sync things.
[...]
> I think it only managed to sync the initial few GBs before I stopped it.

Do we know where the bad sectors were located, 
and where the metadata btrfs needs is located?

If either is at the start of the device, then it's probably gone.

> I realised what I should have done

Add a drive the moment it was degraded. (not order and wait to ship. 
go out yourself and buy one same day. pilfer one if you must.)

Also replace drives before degraded if SMART shows it has a bad sector. 
And run regular selftests for SMART to be able to test for those.

And once you're in a data recovery situation, stop writing altogether.
That means no assemble, no add, no fsck, no mount, nothing.
Create copies or use snapshots/overlays.

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

As long as you use only the overlays, you can experiment without worry, 
unless there is still faulty hardware that should be replaced first.
Don't use overlays on drives that are about to go bad. ddrescue those.

> But now that I have re-added the drive, can I still do something similar,
> maybe manually?

You can try that (with overlays).

Also, it's possible for the device role to have changed when you added it, 
as you had two free slots and adding would make it pick one of them...

If you have old examine info or system logs, it would be good to verify 
that first, if role changed, you'd have a role conflict within a single 
drive and no matter what you do with it, it won't be right anymore.

In the end there is no surefire way to fix this, you just have to trial 
and error and it comes down to luck whether you'll be able to make btrfs 
happy again.

Good luck,
Andreas Klauer
