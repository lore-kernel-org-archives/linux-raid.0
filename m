From: NeilBrown <neilb@suse.de>
Subject: Re: How to force rewrite of a smart detected bad block with raid5:
 checkarray?
Date: Wed, 19 Jan 2011 20:41:15 +1100
Message-ID: <20110119204115.0fe4b159@notabene.brown>
References: <20110119070419.GC31606@merlins.org>
	<alpine.DEB.1.10.1101190842170.13151@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1101190842170.13151@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 08:42:53 +0100 (CET) Mikael Abrahamsson
<swmike@swm.pp.se> wrote:

> On Tue, 18 Jan 2011, Marc MERLIN wrote:
> 
> > Does this actually do what I want? Try all the blocks on each drive and 
> > if one block is unreadable, it forces a rewrite on the bad drive using 
> > the n-1 other ones to recreate it?
> 
> You want to use the "repair" command. This has been discussed numerous 
> times and discussions regarding it can be found in the archives.
> 

No, he actually wants the 'check' command, though 'repair' would work too.

All you need to do is get md/raid5 to try reading the bad block.  Once it does
that it will get a read error and automagically try to correct it.

You could do the math, figure out where in the array the bad block is and use
e.g. dd to just read that block.  That could work, but if the block is a
parity block, then it probably won't.

'check'  (i.e. echo check > /sys/block/mdXX/md/sync_action) will cause
md/raid5 to read all blocks on all devices, thus auto-repairing any
unreadable blocks.

'repair' will also do that but if it find that the parity looks wrong, it
will try to correct the parity.  It is generally best to only use 'repair'
when you have good reason to believe that you need it.


If you were really keen, you could 
  cd /sys/block/mdXX/md
  echo 3907029168 > sync_min
  echo 3907029170 > sync_max
  echo check > sync_action

and it will just sync that stripe.
Though you need to adjust for any Data Offset if using 1.1 or 1.2 metadata,
and you might need to round both numbers of to the next page or maybe next
chunk, I'm not sure.

NeilBrown
