From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 1 of 2] Add interface to md driver for userspace
 monitoring of events.
Date: Tue, 7 Sep 2004 10:53:39 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16701.1683.847311.155379@cse.unsw.edu.au>
References: <20040903122034.15346.patches@notabene>
	<E1C33nX-00040i-9v@notabene.cse.unsw.edu.au>
	<20040903031920.11e31d3f.akpm@osdl.org>
	<16699.47090.307180.958993@cse.unsw.edu.au>
	<20040906140233.GB20941@lst.de>
	<16700.60002.246730.450275@cse.unsw.edu.au>
	<20040906160738.368c20f3.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Monday September 6
To: Andrew Morton <akpm@osdl.org>
Cc: hch@lst.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 6, akpm@osdl.org wrote:
> Neil Brown <neilb@cse.unsw.edu.au> wrote:
> >
> > > poll on procfs is defintily abuse, even in categories of the use procfs
> >  > every times.
> >  > 
> > 
> >  Oh well..  If you gain more from the patch not going in than I gain
> >  from it going in, so be it.
> 
> That's not the point.  Sure, the code works and is useful.  But it takes a
> crappy interface and makes it crappier.

I'm sorry, but I don't see the "crap".
I want a way to tell user-space "it is worth reading from this file
again" and "select" seems to be the most obvious interface to use for
that. 
It is true that the usage is not exactly the same as with normal file, but
things in '/proc' (or sysfs) simple are not normal files.

One man's fish is another man's poisson???

Why is sending a message over a netlink socket intrinsically better
than returning from a select?

Looking at the comment with the sysfs event layer, I see that it has
recently been trimmed down from sending a payload to sending a single
word in the context of a particular sysfs file.  This is starting to
look suspiciously like dnotify (or maybe inotify).

So why a new event layer.  Why not leverage dnotify concepts.

And back to the sysfs-events, what values can the "signal" word have?
Is it a state, or a change, or a request?  If I have a situation that
needs attention, do I say so once, or every tick, or every HZ.  How do
I know when there is a new listener?  How do I respond and say 'that
is dealt with'?  Can I send a matching signal down the netlink, or
would it have to be completely out-of-band?

I thought about this when I did the select-on-/proc/mdstat thing.
I don't think having the kernel say "what happened" is a good thing.
It is too easy to lose those messages, and it isn't clear what sort of
messages they should be.
It is much simpler and, I think, more reliable to have the kernel say
"something happened over here", and have the listener have a look to see
what of interest has changed.

Maybe I'm saying that dnotify/inotify/sysfs-events should be discarded
in favour of something that encompasses them all.  Whenever anything
happens to an object on which events have been requested, a message
with just the name of the object gets sent on some netlink socket.

(it would help if I could find some documentation on netlink.  Any
pointers?)

> 
> You know where we'd end up if we took that attitude all the time,
> yes?

Obviously you don't want to accept "crap".  But who can say where the
"crap" is?

Obviously we need a design authority, and equally obviously, that is
you and Linus at the moment.  Which is why I explicitly said I would
accept your decision.

> 
> Could we explore a medium-term plan to tidy all this up?

If  "all this" is poor design in user-kernel interfaces, then  you need
to say what is acceptable and what isn't, and set a flag day/version
when all the non-acceptable stuff will be removed.  Until you do that,
there will be mess.

If by "all this" you mean signalling changes in the state of md
devices, then I'm happy for you to reject the patch if you don't like
it.  Redhat can patch their kernels or drop it too as they choose.  I
can live without it.  Meanwhile I'll try to learn a bit more about
sysfs and netlink and see if I can come up with something that I am
happy with and that seems to fit the current preferred approach.

NeilBrown
