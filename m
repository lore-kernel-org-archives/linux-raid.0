From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC] Generic Migration
Date: Tue, 7 Mar 2006 11:37:27 +1100
Message-ID: <17420.54727.866701.153409@cse.unsw.edu.au>
References: <fd8d0180603010459j316a8776j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francois Barre on Wednesday March 1
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday March 1, francois.barre@gmail.com wrote:
> Hi all,
> 
> I hope I won't bore you too much, but I had these ideas on my mind for
> a couple of days now, so I just wanted to share them to you.
> It is not a long document, so I guess it would take 10mins to read.
> Sorry for my sometimes obscure english, ya know, I did the best I could...
> 
> I do welcome any comments, critics, suggestions, ... especially
> because it's really a first draft here.
> 
> I of course would wish to implement what i'm speaking about, one day
> or another...

Thank you for your thoughts.

I'm not sure a generic reshape layer like the one you mention is
really needed - at least for the raid levels that you mention.

This is largely because a 2-disk raid1 is indistinguishable from a
2-disk raid5.  Both put identical data on both drives.

So to convert a raid1 to a raid5, you just switch the software being
used to the raid5 software, and then grow the array if that is what
you want.

In general, you can treat raid0, raid1, raid4, raid5 and raid6 very
similarly.  The only difference is how you layout each stripe, and
whether the two possible 'redundancy' blocks are included in each
stripe.

So an upsize migration from any of these level to any other could be
done within the raid6 code providing the raid6 code could cope with an
array where the Q block was not present (which is often the case in a
degraded array anyway).

So to perform an generic upsize migration, I would:
   switch to raid6 mode with appropriate layout
   perform the growth within raid6
   switch back to more appropriate module.

For stable migration you really to need to log to a separate device.
This would be slow, but not impossible.  It could be done with the
'grow' function in raid6 and so the above approach would still work.

For downsize migration, we simply need to run a 'grow' in reverse.  We
make use of the space that is about to be discard so that we don't
need any separate logging.  I suspect there is much less demand for
this than for upsize migration, so it might not eventuate.


The only complication comes with raid10.  raid10 has a very different
layout to the others and, while it would be possible, making raid6
understand it would be a lot more intrusive than make in understand
all the others.  It have no particular plans in this direction at the
moment.

NeilBrown
