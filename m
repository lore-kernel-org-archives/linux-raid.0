From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Tue, 15 Mar 2005 09:54:52 +1100
Message-ID: <16950.5692.594941.130741@cse.unsw.edu.au>
References: <422F7621.8090602@steeleye.com>
	<16949.5768.392061.95882@cse.unsw.edu.au>
	<20050314094454.GK3858@marowsky-bree.de>
	<16949.26113.68948.938529@cse.unsw.edu.au>
	<20050314112403.GT3858@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Lars Marowsky-Bree on Monday March 14
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 14, lmb@suse.de wrote:
> On 2005-03-14T21:22:57, Neil Brown <neilb@cse.unsw.edu.au> wrote:
> 
> > > Hi there, just a question about how the bitmap stuff works with
> > > 1++-redundancy, say RAID1 with 2 mirrors, or RAID6.
> > I assume you mean RAID1 with 3 drives (there isn't really one main
> > drive and all the others are mirrors - all drives are nearly equal).
> 
> Yeah, that's what I meant.
> 
> (BTW, if they are all equal, how to you figure out where to sync
> from?

It arbitrarily chooses one.  It doesn't matter which.  The code
currently happens to choose the first, but this is not a significant choice.

> Isn't the "first" one also the first one to receive the writes, so
> unless it's somehow identified as bad, it's the one which will have the
> "best" data?)

Data is written to all drives in parallel (the request to the first
might be launched slightly before the second, but the difference is
insignificant compared to the time it takes for the write to
complete). 

There is no such thing as "best" data.
Consider the situation where you want to make a transactional update
to a file that requires writing two block.
If the system dies while writing the first, the "before" data is
better.  If it dies while writing the second, the "after" data is
better. 

> 
> > We haven't put any significant work into bitmap intent logging for
> > levels other than raid1, so some of the answer may be pure theory.
> 
> OK.
> 
> (Though in particular for raid5 with the expensive parity and raid6 with
> the even more expensive parity this seems desireable.)

Yes.  We will get there.  We just aren't there yet so I cannot say
with confidence how it will work.

> 
> I think each disk needs to have it's own bitmap in the long run. On
> start, we need to merge them.

I think any scheme that involved multiple bitmaps would be introducing
too much complexity.  Certainly your examples sound very far fetched
(as I think you admitted yourself).  But I always try to be open to
new ideas.

NeilBrown
