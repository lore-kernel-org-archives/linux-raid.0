From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 write performance
Date: Sat, 19 Nov 2005 16:54:03 +1100
Message-ID: <17278.48635.585763.580503@cse.unsw.edu.au>
References: <200511190440.jAJ4efw15919@www.watkins-home.com>
	<437EB0A6.8040807@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Hardy on Friday November 18
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: Guy <bugzilla@watkins-home.com>, 'Dan Stromberg' <strombrg@dcs.nac.uci.edu>, =?ISO-8859-2?Q?=27Jure_?= =?ISO-8859-2?Q?Pe=E8ar=27?= <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 18, mhardy@h3c.com wrote:
> 
> So, I continue to believe silent corruption is mythical. I'm still open
> to good explanation it's not though.
> 

Silent corruption is not mythical, though it is probably talked about
more than it actually happens (but then as it is silent, I cannot be
certain :-).

Silent corruption can happen only if an unclean degraded array is
started. 
md will not start an unclean degraded (raid 4/5/6) array (though I'm
going to add a module parameter to allow it) and mdadm will only start
such an array if given --force (in which case it modifies to appear
clean so md will start it).

If your array is not degraded, or you always shut down cleanly, there
is no opportunity for raid5-level corruption (of course, the drives may
choose to corrupt things silently themselves...).

Note that an unclean degraded start doesn't imply corruption - you
could be in this situation and not have any corruption at all.  But it
does allow it.  It must as 'unclean' means you cannot trust the
parity, and 'degraded' means that you have to.

There are two solutions to this silent corruption problem (other than
'ignore it and hope it doesn't bite' which is a fair widely used
solution, and I haven't seen any bite marks myself).

One is journalling, as has been mentioned.  This could be done to a
mirrored pair, or to a ECC NVRAM card (the latter being probably the
best, though also most expensive).  You would write each data block as
it becomes available, and each parity block just before commencing a
write to the raid5.  Obviously you also keep track of what you have
written.
I have toyed with the idea of implementing this, but I think demand is
sufficiently low that it isn't worth it.

The other is to use a filesystem that allows the problem to be avoided
by making sure that the only blocks that can be corrupted are dead
blocks.
This could be done with a copy-on-write filesystem that knows about the
raid5 geometry, and only ever writes to a stripe when no other blocks
on the stripe contain live data.
I've been working on a filesystem which does just this, and hope to
have it available in a year or two (it is a back-ground 'hobby'
project). 

I know that ZFS is a copy-on-write filesystem.  It is entirely
possible that it can do the right thing for raid5.

And as an addendum, md/raid5 never reports a block as complete to the
filesystem until the device drives have reported the data block and
the parity block as being safe.  i.e. It has a write-through cache,
not a write-behind cache.

NeilBrown
