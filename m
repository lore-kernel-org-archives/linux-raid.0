From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: RAID 1 not fixing up sector errors?
Date: Thu, 14 Apr 2016 16:22:19 +0200
Message-ID: <20160414142219.GA4783@EIS.leimen.priv>
References: <29813347.d6oRyCVBGp@dag.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <29813347.d6oRyCVBGp@dag.newtech.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Dag Nygren <dag@newtech.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 14, 2016 at 04:03:59PM +0300, Dag Nygren wrote:
> Anyway I do get those occasional "Pending Reallocate" with
> the appropriate corresponding
> Unrecovered read error - auto reallocate failed
> in the log.

You should replace such disks. RAID survival depends on healthy disks.
 
> But I was expecting the MD layer to try to fixup that sector
> automatically by using the data from the other drive ??

That should happen if the read error is encountered by the md layer, 
and the disk reports this error properly, and the other disk has data 
and not a bad block at the same place...

However the drive may encounter bad sectors on its own, for example 
early in the boot process before Software RAID is active, or when 
running periodic self-tests or other internal monitoring of the drive.

In such cases the software raid won't know about it.

But you should replace such disks anyhow.

Regards
Andreas Klauer
