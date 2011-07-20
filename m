From: Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: Re: data corruption after rebuild
Date: Wed, 20 Jul 2011 10:20:55 +0200
Message-ID: <5631626.tuTAQthxQb@bloomfield>
References: <2073005.NH8LALaxuD@bloomfield> <20110720162431.5df90f32@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110720162431.5df90f32@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 20 of July 2011 16:24:31 you wrote:
> My suggestion would be to remove the drive you recently added and then see
> if the data is still corrupted.  It may not help but is probably worth a
> try.

tried that, did not help, probably due to the finished rebuild that "repaired" 
all the parity data

> There was a bug prior to 2.6.32 where RAID6 could sometimes write the wrong
> data when recovering to a spare.  It would only happen if you were accessing
> that data at the same time as it was recovery it, and if you were unlucky.

I was accessing some data (read-mostly), but now the largest undamaged file on 
the filesystem has just under 3MB - that looks a bit suspicious, as the stripe-
width is 6x 512K = 3M

> BTW the monthly scans that you do are primarily for finding sleeping bad
> blocks - blocks that you cannot read.  They do check for inconsistencies in
> the parity but only report them, it doesn't correct them.  This is because
> automatically correcting can cause more problems than it solves.
> 
> When the monthly check reported inconsistencies you "should" have confirmed
> that all the drives seem to be functioning correctly and then run a 'repair'
> pass to fix the parity blocks up.
> 
> As you didn't that bad parity would have created bad data when you
> recovered.

see the last part, at this point I would be perfectly OK with 72 damaged 
blocks, as per the last scan (or even a few hundred, for that matter)


PS: forgot to include maillist

