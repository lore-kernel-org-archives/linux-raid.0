From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Mirror recovery?
Date: Fri, 21 Jun 2002 12:43:03 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15634.37559.635719.855683@notabene.cse.unsw.edu.au>
References: <20020620140112.GA26939@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ross Vandegrift on Thursday June 20
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 20, ross@willow.seitz.com wrote:
> Hello all,
> 
> 	Lost a drive in my box last night - woke up to it locked
> completely solid.  So I reset the machine, it started to come back up
> and remirror the drives.  I set about trying to figure out why it locked
> (the terminal had blanked overnight of course, and wouldn't unblank so
> I missed the probable standard failure messages).  Then the box locked
> hard again, right as I heard one of my IDE drives make some terrible
> noises.

Don't you hate that noise...

> 
> 	So I rebooted, and ran the manufacturer's disk test, sure enough
> it's headed south.  Once I've got a replacement drive, will I be able to
> get the data on my raid partition back?  I don't think I've ever had a
> failure happen on a RAID1 array during resync.  Once on RAID5, and that
> was a disaster....

You shouldn't have any problems getting your data back.  Indeed you
should be able to get it even before the new drives arrive, that is
what RAID is about.

My (biased) guess is that the machine locked up because the IDE driver
was not coping elegantly with the drive failure. 
I think it would be nice if the raid system could tell the device "if
you get an error, don't retry too hard, I'm happy to cope".

NeilBrown
