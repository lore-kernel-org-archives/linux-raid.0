From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: Mirror recovery?
Date: Thu, 20 Jun 2002 22:56:47 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020621025647.GA943@willow.seitz.com>
References: <20020620140112.GA26939@willow.seitz.com> <15634.37559.635719.855683@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15634.37559.635719.855683@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > 	So I rebooted, and ran the manufacturer's disk test, sure enough
> > it's headed south.  Once I've got a replacement drive, will I be able to
> > get the data on my raid partition back?  I don't think I've ever had a
> > failure happen on a RAID1 array during resync.  Once on RAID5, and that
> > was a disaster....
> 
> You shouldn't have any problems getting your data back.  Indeed you
> should be able to get it even before the new drives arrive, that is
> what RAID is about.

Ok, I wasn't sure if the second failure during reconstruction was
disastrous for RAID1.  Looks like it's not - my boss lent me a disk to
use until my RMA'ed Deathstar comes in, and as soon as I hot added a new
partition, reconstruction started with all my data.

Somedays when the simple things go right it's enough to make your day
::-)

> My (biased) guess is that the machine locked up because the IDE driver
> was not coping elegantly with the drive failure. 
> I think it would be nice if the raid system could tell the device "if
> you get an error, don't retry too hard, I'm happy to cope".

Hardly a biased opinion.  I've seen more than my share of IDE disk
failures at work - it's always the IDE driver that falls over first.  

Ross Vandegrift
ross@willow.seitz.com
