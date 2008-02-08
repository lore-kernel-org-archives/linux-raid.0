From: Neil Brown <neilb@suse.de>
Subject: Re: raid5: two writing algorithms
Date: Fri, 8 Feb 2008 12:51:39 +1100
Message-ID: <18347.46507.422011.243347@notabene.brown>
References: <20080207161337.GA6044@rap.rap.dk>
	<18347.26939.358283.172299@notabene.brown>
	<20080208011041.GD12985@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 8, keld@dkuug.dk wrote:
> On Fri, Feb 08, 2008 at 07:25:31AM +1100, Neil Brown wrote:
> > On Thursday February 7, keld@dkuug.dk wrote:
> 
> > > So I hereby give the idea for inspiration to kernel hackers.
> > 
> > and I hereby invite you to read the code ;-)
> 
> I did some reading.  Is there somewhere a description of it, especially
> the raid code, or are the comments and the code the best documentation?

No.  If a description was written (and various people have tried to
describe various parts) it would be out of date within a few months :-(

Look for "READ_MODIFY_WRITE" and "RECONSTRUCT_WRITE" .... no.  That
only applied to raid6 code now..
Look instead for the 'rcw' and 'rmw' counters, and then at
'handle_write_operations5'  which does different things based on the
'rcw' variable.

It used to be a lot clearer before we implemented xor-offload.  The
xor-offload stuff is good, but it does make the code more complex.


> 
> Do you say that this is already implemented?

Yes.

> 
> I am sorry if you think I am mailing too much on the list.

You aren't.

> But I happen to think it is fun.

Good.

> And I do try to give something back.

We'll look forward to that.

> 
> > Code reading is a good first step to being a
> > > 
> > > Yoyr kernel hacker wannabe
> >        ^^^^^^^^^^^^^
> > 
> > NeilBrown
> 
> Well, I do have a hack in mind, on the raid10,f2.
> I need to investigate some more, and possibly test out
> what really happens. But maybe the code already does what I want it to.
> You are possibly the one that knows the code best, so maybe you can tell
> me if raid10,f2 always does its reading in the first part of the disks?

Yes, I know the code best.

No, raid10,f2 doesn't always use the first part of the disk.  Getting
it to do that would be a fairly small change in 'read_balance' in
md/raid10.c.

I'm not at all convinced that the read balancing code in raid10 (or
raid1) really does the best thing.  So any improvements - backed up
with broad testing - would be most welcome.

NeilBrown
