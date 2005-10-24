From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Mon, 24 Oct 2005 10:37:47 +1000
Message-ID: <17244.11483.895073.914651@cse.unsw.edu.au>
References: <20050920143346.GA5777@uio.no>
	<17200.9302.242957.23189@cse.unsw.edu.au>
	<20050920153622.GA14287@uio.no>
	<17202.55529.310871.877019@cse.unsw.edu.au>
	<20050924014412.GA19832@uio.no>
	<17221.59105.846162.739316@cse.unsw.edu.au>
	<20051014194621.GA31390@uio.no>
	<17234.55921.769147.227160@cse.unsw.edu.au>
	<20051019231830.GA18894@samfundet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steinar H. Gunderson on Thursday October 20
Sender: linux-raid-owner@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 20, sgunderson@bigfoot.com wrote:
> On Mon, Oct 17, 2005 at 08:55:45AM +1000, Neil Brown wrote:
> > I'll have a close look at all the code sometime today and get back to
> > you with any comments.
> 
> Any progress?
> 

Ok, I've had another fairly detailed look..
I'd like to suggest another simplification (at least, I think it's a
simplification, let me know what you think).

While working on expanding one section, you currently gave a bunch of
stripe_heads (expand_stripes) sitting idle, waiting for all the reads
to complete, and you also have a collection of pages (expand_buffer)
to copy the data into when it is read.
I think you can combine these two, so that the expand_stripes are less
idle (i.e. their buffer space gets used) and so that expand_buffer
isn't needed.

I would first include the "sh->disks" value in the 'key' used to look
stripe_heads up in the hash table.  That way you could easily have 
'old' stripes and 'new' stripes possibly for overlapping regions
living in the hash table at the same time.

I would change sync_request to work in units of chunk_size rather than
STRIPE_SECTORS, as I think that makes it a bit easier too
(sync_request can schedule as much sync activity as it like - it just
has to return the correct number of sectors).

So what sync_request would do would be:
 1/ get_active_stripe a collection of stripes with sh->disks being the
   new size, and flag all of them as being in an expand, and set the
   sh->count to be the number of blocks that need to be loaded into
   the stripe.  Also set STRIPE_HANDLE so as soon as the count reaches
   0, the stripe will be handled. (Actually, you probably wouldn't use
   get_active_stripe, you would use get_free_stripe, and then init_stripe).
 2/ advance 'expand_progress' to the end of this set of stripes
 3/ get_active_stripe all of the stripes (with old size in sh->disks)
    that need to be read to fill in the new set of stripes, and flag
    them so that handle_stripe will read all the blocks.
  
make_request will now find the new-sized stripes when looking for
blocks in this area of the array.  It will not find the old stripes, so
we know that no new IO requests will be added to old stripes in this
region of the array.
If make_request finds a stripe that is flagged as being in an expand,
then it should block until the expand moves onward
(wait_for_expand_progress).

In handle_stripe, if we get a stripe that
  - was flagged for reading prior to expand and
  - has all the required blocks read in and
  - has no pending IO requests in the region of the current expand
then
  - transfer (either memcpy or pointer fiddling) the data into the
    stripes that are waiting for the data, and decrement the ->count
    for those stripes by the number of blocks that were transferred.

When handle stripe gets a stripe that is flagged for expanding, then it
knows that all the data has been transferred in, and it updates the
parity block and schedules a write.

I think that with that change in place, I'll be happy with the
structure and will then start a closer review of the fine detail and
help you find the corruption bug (if it still exists).

Thanks for your continuing efforts.

NeilBrown
