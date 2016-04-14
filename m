From: Dag Nygren <dag@newtech.fi>
Subject: Re: RAID 1 not fixing up sector errors?
Date: Thu, 14 Apr 2016 17:43:08 +0300
Message-ID: <11976887.0JgMgHdD8h@dag.newtech.fi>
References: <29813347.d6oRyCVBGp@dag.newtech.fi> <20160414142219.GA4783@EIS.leimen.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160414142219.GA4783@EIS.leimen.priv>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 14 April 2016 16:22:19 you wrote:
> On Thu, Apr 14, 2016 at 04:03:59PM +0300, Dag Nygren wrote:

> You should replace such disks. RAID survival depends on healthy disks.

I know, but this is very secondary use, no I am really not worried about it.

> > But I was expecting the MD layer to try to fixup that sector
> > automatically by using the data from the other drive ??
> 
> That should happen if the read error is encountered by the md layer, 
> and the disk reports this error properly, and the other disk has data 
> and not a bad block at the same place...

That is what I expected. You can see the proper error from the disk in dmesg
and it is accessed otherwise there would be no dmesg error.

> However the drive may encounter bad sectors on its own, for example 
> early in the boot process before Software RAID is active, or when 
> running periodic self-tests or other internal monitoring of the drive.

Yep, but not the case here.
There is a real access and a real error in the log, but no rewrite...

Should the md layer report anything?

Is there a parameter that might be off?

Best
Dag
