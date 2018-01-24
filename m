From: Liwei <xieliwei@gmail.com>
Subject: Re: Recovering Partial Data From Re-Added Drive
Date: Wed, 24 Jan 2018 15:34:31 +0800
Message-ID: <CAPE0SYy8VWazr9SDVqr7tpV7oRxG23Dgpkmp-96wOa2=E0EoNQ@mail.gmail.com>
References: <CAPE0SYx2Pf=hVe46NVLqTC3g9WQd1MckceS818bWzeNYdOVkNQ@mail.gmail.com>
 <20180123224610.GA8114@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180123224610.GA8114@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Apologies, sent with the wrong mail client, resend.

Hi Andreas,
Replies inline...

On 24 January 2018 at 06:46, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Wed, Jan 24, 2018 at 01:16:43AM +0800, Liwei wrote:
>> I have a RAID6 running degraded (12 out of 13 drives).
> [...]
>> thus I decided not to order a replacement for the drive that died.
>
> A gamble that kicked you straight into Murphy's lawnmower.
>

Indeed and I've learnt my lesson!

>> I imaged the drive with pending sectors
>
> Do you have the ddrescue log/map to go with that?
> If you did not use ddrescue - what did you use exactly?

Yes, ddrescue, and I did use a log.

>
> If you know what the bad sectors were you can try fill those gaps
> with data from the other drives if it wasn't synced over.

That's what I'm hoping to do.

>
> If you still have the drive and sectors still bad, you can produce
> the map belatedly by copying it again... if you wiped it and
> sectors were reallocated, no such luck.
>
>> When that didn't work out, I absent-mindedly decided to re-add the
>> drive that glitched out and the raid started to re-sync things.
> [...]
>> I think it only managed to sync the initial few GBs before I stopped it.
>
> Do we know where the bad sectors were located,
> and where the metadata btrfs needs is located?

Yes, ddrescue produced the bad sector list, and the btrfs superblock
has the starting byte number where it is expecting to read the root
tree. Using both information, my guess is that I need at least 27 of
those sectors, towards the end of the drive. Pretty sure they're still
there.

>
> If either is at the start of the device, then it's probably gone.
>
>> I realised what I should have done
>
> Add a drive the moment it was degraded. (not order and wait to ship.
> go out yourself and buy one same day. pilfer one if you must.)

Sigh, we were about 2 days away from the migration completing... I
thought. A hard lesson learned.

>
> Also replace drives before degraded if SMART shows it has a bad sector.
> And run regular selftests for SMART to be able to test for those.
>
> And once you're in a data recovery situation, stop writing altogether.
> That means no assemble, no add, no fsck, no mount, nothing.
> Create copies or use snapshots/overlays.
>
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

Thanks for the link!

>
> As long as you use only the overlays, you can experiment without worry,
> unless there is still faulty hardware that should be replaced first.
> Don't use overlays on drives that are about to go bad. ddrescue those.
>
>> But now that I have re-added the drive, can I still do something similar,
>> maybe manually?
>
> You can try that (with overlays).
>
> Also, it's possible for the device role to have changed when you added it,
> as you had two free slots and adding would make it pick one of them...
>
> If you have old examine info or system logs, it would be good to verify
> that first, if role changed, you'd have a role conflict within a single
> drive and no matter what you do with it, it won't be right anymore.

I've checked the history mdadm sends to my email, and it seems like
the re-added drive did not change roles.

However, how do I get mdadm to accept the re-added drive without
trying to sync? Right now, every time I reassemble the raid using the
re-added drive, it refuses to start because there are insufficient
devices (the re-syncing/re-added drive is not counted as active). Do I
have to manually edit the drive metadata? If so, what do I need to be
careful of?

>
> In the end there is no surefire way to fix this, you just have to trial
> and error and it comes down to luck whether you'll be able to make btrfs
> happy again.
>
> Good luck,
> Andreas Klauer
