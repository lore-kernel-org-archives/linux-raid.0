From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Fri, 7 Oct 2005 13:09:21 +1000
Message-ID: <17221.59105.846162.739316@cse.unsw.edu.au>
References: <20050920143346.GA5777@uio.no>
	<17200.9302.242957.23189@cse.unsw.edu.au>
	<20050920153622.GA14287@uio.no>
	<17202.55529.310871.877019@cse.unsw.edu.au>
	<20050924014412.GA19832@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steinar H. Gunderson on Saturday September 24
Sender: linux-raid-owner@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday September 24, sgunderson@bigfoot.com wrote:
> On Thu, Sep 22, 2005 at 06:16:41PM +0200, Neil Brown wrote:
> > 2/ Reserve the stripe_heads needed for a chunk-resize in make_request
> >    (where it is safe to block) rather than in handle_stripe.
> 
> See the attached patch for at least a partial implementation of this (on top
> of the last patch); it pre-allocates the write stripes, but not the read
> stripes. In other words, it still uses a temporary buffer, and it doesn't
> block requests against the to-be-expanded area.

That certainly looks like it is heading in the right direction.
Thanks.
However it is usually easier to read a whole patch - reading a patch
that removes bits of a previous patch, and depends on other bits of
it, requires holding too much in one's brain at once.  If you could
possibly send a complete patch against a recent release kernel, it
would make review a lot easier.
(In general, patches should be broken into the smallest usable pieces,
and no smaller.  I think the functionality you are currently writing
can not be usefully broken up, so just one patch is best).


> 
> There's also one extra fix I snuck in; before recomputing the parity for the
> written out blocks, I actually lock it. This shouldn't break anything, and
> AFAICS should be a good idea both in this and the previous
> implementation.

That probably shouldn't be needed, but certainly shouldn't hurt.  I'd
like to leave reviewing of the locking until the rest of the patch is
in good shape.

> 
> I'm unsure how much this actually buys us (there's a slight reduction in
> complexity, but I fear that will go up again once I implement it for read
> stripes as well),

I think it buys us a lot.  It means we can wait for stripes to become
free instead of spinning around hoping they will come free soon.

It's possible that you don't need to pre-allocate the read stripes
as well. 
sync_request just pre-allocated the write stripes, then allocates and
schedules the read-stripes.  Once all the read-stripes are full,
handle_stripe shuffles all the pages from 'read' to 'write' and
schedules the writes.


>                   and I seem to have created a somewhat nasty regression --
> if I do I/O against the volume while it's expanding, it causes a panic
> _somewhere_ in handle_stripe, which I'm having a hard time tracking down. (If
> you have a good way of actually mapping the offsets to C lines, let me know
> -- every approach I've tried seems to fail, and the disassembly even shows
> lots of nonsensical asm :-) )

I find disassembly works quite well.
You can even
   make drives/md/raid5.lst
which gives you a listing to read.

> 
> In short, I think getting the original patch more or less bug-free is a
> higher priority than this, although I do agree that it's a conceptually
> cleaner way. What I really need is external testing of this, and of course
> preferrably someone tracking down the bugs that are still left there... There
> might be something that's really obvious to you (like $,1r|(Bwhy on earth isn't he
> locking that there?$,1r}(B) that I've overlooked, simply because you know this code
> a _lot_ better than me :-)

What a patch really needs to improve confidence is review.  Testing is
good too of course, but code review will find bugs that testing may
not.  I'm personally not interested in testing it until it looks
right, as any structural changes needed will invalidate any testing.
Currently the patch looks mostly good, but there are a couple of
structural changes that I think it needs as I mentioned previously.
Once these are in place, I can review the code more closely and look
for races and other subtle semantic issues.
Then I'm happy to start testing.

I really want this functionality to get into mainline - and I hope we
can work together to make that happen.


NeilBrown
