From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 11:52:57 +1100
Message-ID: <20110217115257.28a8d174@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<20110216202939.GA2756@lazy.lzy>
	<20110217084826.77f4dbf1@notabene.brown>
	<4D5C6AAF.1040600@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C6AAF.1040600@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 19:24:15 -0500 Phil Turmel <philip@turmel.org> wrote:

> On 02/16/2011 04:48 PM, NeilBrown wrote:
> > On Wed, 16 Feb 2011 21:29:39 +0100 Piergiorgio Sartor
> >>
> >>> Better reporting of inconsistencies.
> >>> ------------------------------------
> >>>
> >>> When a 'check' finds a data inconsistency it would be useful if it
> >>> was reported.   That would allow a sysadmin to try to understand the
> >>> cause and possibly fix it.
> >>
> >> Could you, please, consider to add, for RAID-6, the
> >> capability to report also which device, potentially,
> >> has the problem? Thanks!
> > 
> > I would rather leave that to user-space.  If I report where the problem is, a
> > tool could directly read all the blocks in that stripe and perform any fancy
> > calculations you like.  I may even write that tool (but no promises).
> 
> Hmmm.  The existing "check" code, if it encounters a read error, will use
> available redundancy to recover that data and rewrite it on the spot.
> 
> Without a read error, or with multiple redundancy, the calculations to
> check consistency are performed and reported.  With all the data "hot", and half
> the calculation to pinpoint an inconsistency done, it seems a shame to have
> userspace redo it.
> 
> Are you adamantly opposed to the kernel doing this?  (For Raid6)  Code talks,
> of course, but I'd rather not start if I'm only going to be shot down.
> 

I like to think I remain open-minded to any compelling arguments.

However putting code into the kernel which *only* tells user-space something
that it could figure out for itself doesn't sound sensible - though it
depends a bit on how much code.

Also - as I understand it - the RAID6 code works on a byte-by-byte basis.
This the P and Q bytes are computed from the N data bytes, and collections of
these bytes form blocks.

The "which block is bad calculation" take the  data bytes and the P and Q
bytes and produces a new byte.  If that byte is < N, it means that just
changing data byte N can make P and Q consistent.  (if it is N, the the P
bytes is bad, if it is N+1 then the Q byte is bad).  If it is >N+1, then
... possibly multiple bytes are bad .. my knowledge gets hazy here.

So when you do the computation on all of the bytes in all of the blocks you
get a block full of answers.
If the answers are all the same - that tells you something fairly strong.
If they are a "all different" then that is also a fairly strong statement.
But what if most are the same, but a few are different?  How do you interpret
that?

The point I'm trying to get to is that the result of this RAID6 calculation
isn't a simple "that device is bad".  It is a block of data that needs to be
interpreted.

I'd rather have user-space do that interpretation, so it may as well do the
calculation too.

If you wanted to do it in the kernel, you would need to be very clear about
what information you provide, what it means exactly, and why it is sufficient.

NeilBrown
