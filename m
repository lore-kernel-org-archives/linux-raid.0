From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: RAID5 problem
Date: Mon, 5 Dec 2005 21:26:45 -0500
Message-ID: <20051206022645.GA22413@jose.lug.udel.edu>
References: <4392FB7C.6080600@gmx.de> <17299.25606.806494.749914@cse.unsw.edu.au> <20051205014408.GA20602@jose.lug.udel.edu> <17299.43393.992231.121500@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17299.43393.992231.121500@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 05, 2005 at 01:44:17PM +1100, Neil Brown wrote:
> The text-messaging I don't like.  That is what the --program option if
> for.  If you don't want the very-basic email message, then write
> yourself a little script to do exactly what you want.

Heh - had I known about that feature it would've saved me the time it
took to write in C!

> The 'syslog' stuff looks fine : -y and --syslog.... though I wander if
> --syslog should be the default...

Maybe - I can't really imagine not enabling it.  But I didn't want to
wrap a policy change into a feature.

> I wish I could remember why I didn't do this at the start!  I have a
> strong feeling that it was more than just laziness, but I cannot
> remember what more :-(

Hmm - I've give this some thought.  The only bad thing I can think of
are the non-events that can potentially be logged when things don't
check for undefined configuration.

For example - is my other change to test for UnDef spare drives
incorrect in some way?  I'm not too sure since I'm not really familiar
with the code.

Ross
