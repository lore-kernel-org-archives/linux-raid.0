From: "NeilBrown" <neilb@suse.de>
Subject: Re: Timeout until degrade of RAID5 array
Date: Mon, 8 Jun 2009 08:57:35 +1000 (EST)
Message-ID: <030bb036ec3b807247ac049d82b1c9bd.squirrel@neil.brown.name>
References: <200906072119.22807.gabriel_ambuehl@buz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200906072119.22807.gabriel_ambuehl@buz.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Gabriel Ambuehl <gabriel_ambuehl@buz.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, June 8, 2009 5:19 am, Gabriel Ambuehl wrote:
> Dear List
> Apologies if this is a FAQ but googling for an hour did not yield much of
> a
> result.
>
> My situation:
> I have a NAS running 4 WD greenpower drives in RAID5. This works all nice
> and
> dandy, but since I do not actually need the NAS 90% of the time, I figured
> I
> would allow the drives to spin down to save on both power, noise and heat
> budget.
>
> This works most of the times, but I've seen a few cases by now where one
> drive
> was kicked out of the array upon wake up. My assumption is the drive took
> a
> little too long to wake up and hence hit some form of a time out
> especially
> because I could easily rebuild the array with the same drive.
>
> So Is there any way to increase the time that md would wait until removing
> a
> drive from an array?

No - this is not a function of md at all.

You should be asking "is there some way to get the SCSI/SATA/whatever
controller to wait a bit longer before failing an IO request?"
And that questions should, of course, be directed to developers
of the driver for whatever sort of disk controller you have.

Good luck.

NeilBrown


