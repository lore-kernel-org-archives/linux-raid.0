From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Mon, 9 Dec 2002 09:35:06 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15859.51482.570635.122591@notabene.cse.unsw.edu.au>
References: <20021120234743.GF29881@marowsky-bree.de>
	<3DDC2A6F.2030307@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steven Dake on Wednesday November 20
To: Steven Dake <sdake@mvista.com>
Cc: Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


( sorrt for the delay in replying, I had a week off, and then a week
catching up...)

On Wednesday November 20, sdake@mvista.com wrote:
> The only application where having a RAID volume shareable between two 
> hosts is useful is for a clustering filesystem (GFS comes to mind). 
>  Since RAID is an important need for GFS (if a disk node fails, you 
> don't want ot loose the entire filesystem as you would on GFS) this 
> possibility may be worth exploring.
> 
> Since GFS isn't GPL at this point and OpenGFS needs alot of work, I've 
> not spent the time looking at it.
> 
> Neil have you thought about sharing an active volume between two hosts 
> and what sort of support would be needed in the superblock?
> 

I think that the only way shared access could work is if different
hosts controlled different slices of the device.  The hosts would have
to some-how negotiate and record who was managing which bit.  It is
quite appropriate that this information be stored on the raid array,
and quite possibly in a superblock.  But I think that this is a
sufficiently major departure from how md/raid normally works that I
would want it to go in a secondary superblock.
There is 60K free at the end of each device on an MD array.  Whoever
was implementing this scheme could just have a flag in the main
superblock to say "there is a secondary superblock" and then read the
info about who owns what from somewhere in that extra 60K

So in short, I think the metadata needed for this sort of thing is
sufficiently large and sufficiently unknown that I wouldn't make any
allowance for it in the primary superblock.

Does that sound reasonable?

NeilBrown
