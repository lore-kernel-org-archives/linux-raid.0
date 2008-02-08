From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid5: two writing algorithms
Date: Fri, 8 Feb 2008 11:25:43 +0100
Message-ID: <20080208102543.GB26040@rap.rap.dk>
References: <20080207161337.GA6044@rap.rap.dk> <18347.26939.358283.172299@notabene.brown> <20080208011041.GD12985@rap.rap.dk> <18347.46507.422011.243347@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18347.46507.422011.243347@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 08, 2008 at 12:51:39PM +1100, Neil Brown wrote:
> On Friday February 8, keld@dkuug.dk wrote:
> > On Fri, Feb 08, 2008 at 07:25:31AM +1100, Neil Brown wrote:
> > > On Thursday February 7, keld@dkuug.dk wrote:
> > 
> > > > So I hereby give the idea for inspiration to kernel hackers.
> > > 
> > > and I hereby invite you to read the code ;-)
> > 
> > I did some reading.  Is there somewhere a description of it, especially
> > the raid code, or are the comments and the code the best documentation?
> 
> No.  If a description was written (and various people have tried to
> describe various parts) it would be out of date within a few months :-(

OK, I was under the impression that some of the code did not change
much. Eg. you said that there had not been any work on optimizing
raid10 for performance since the 2.6.12 kernel I was using. And then at
least the raid5 code, the last copyright notice right in the top is 
Copyright (C) 2002, 2003 H. Peter Anvin. That is 5 years ago. 
And your name is not on it. So I did not look that much into that code,
thinking nothing had been done there for ages. Maybe you could add your
name on it, that would only be fair. The same comment goes for other
modules (for which it is relevant).

> Look for "READ_MODIFY_WRITE" and "RECONSTRUCT_WRITE" .... no.  That
> only applied to raid6 code now..
> Look instead for the 'rcw' and 'rmw' counters, and then at
> 'handle_write_operations5'  which does different things based on the
> 'rcw' variable.
> 
> It used to be a lot clearer before we implemented xor-offload.  The
> xor-offload stuff is good, but it does make the code more complex.

OK, I think it is fairly well documented here, I can at least follow the
logic, and then I think it is a good approach to have the flow
description/strategy included directly in the code. Given there are many
changes to the code, different files for code and description could
easily mix up the alignment of code and documentation badly.

> 
> 
> > 
> > Do you say that this is already implemented?
> 
> Yes.

That is very good!


Do you konw if other implementations of this, eg. commercial controller
code, have this facility? If not, we could list this as an advantage of 
linux raid. Anyway it would be implicit in performance documentation.
I do plan to write up something on performance, soonish. The howto
is hopelessly outdated.

IMHO such code should make the performance of raid5 random writes not
that bad. Better than the reputation that raid5 is hopelessly slow for
database writing. I think raid5 would be less than double as slow as
raid1 for random writing.

> > Well, I do have a hack in mind, on the raid10,f2.
> > I need to investigate some more, and possibly test out
> > what really happens. But maybe the code already does what I want it to.
> > You are possibly the one that knows the code best, so maybe you can tell
> > me if raid10,f2 always does its reading in the first part of the disks?
> 
> Yes, I know the code best.
> 
> No, raid10,f2 doesn't always use the first part of the disk.  Getting
> it to do that would be a fairly small change in 'read_balance' in
> md/raid10.c.
> 
> I'm not at all convinced that the read balancing code in raid10 (or
> raid1) really does the best thing.  So any improvements - backed up
> with broad testing - would be most welcome.

I think I know where to do my proposed changes, and how it could be done.
So maybe in a not too distant future I will have done my first kernel
hack!

Best regards
keld
