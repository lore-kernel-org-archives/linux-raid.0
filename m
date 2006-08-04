From: Neil Brown <neilb@suse.de>
Subject: Re: [BUG] raid1: barrier retry does not work correctly with write-behind
Date: Fri, 4 Aug 2006 11:47:29 +1000
Message-ID: <17618.42801.411938.763485@cse.unsw.edu.au>
References: <44D219C6.3090505@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Thursday August 3
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 3, paul.clements@steeleye.com wrote:
> 
> 
> The r1_bio->master_bio may already have had end_io() called and been 
> freed by the time we bio_clone() it. This results in an invalid bio 
> being sent down to one (or more) of the raid1 components. In my testing, 
> the original 4K barrier write ended up being a zero length write when it 
> was retried.

Oh bother...

> 
> Solution:
> --------
> Can we just bio_alloc instead of cloning? I think we have all the sector 
> and offset data in the r1_bio. We could then bio_add_page() the pages 
> into the new bio, possibly? Or could we just use the original bio that 
> failed, being careful to clean up fields (I think we used to do this but 
> Neil changed the behavior because of some problems).

Yes we did.  I don't remember exactly what the problem was, but there
are lots of fields in a bio, and the rules about which ones can be
modified by drives are not terribly clear.

Let's see...
 The drive can modify:

   bi_io_vec->bv_offset		end_that_request_first
   bi_io_vec->bv_len		end_that_request_first

   bi_sector			raid0/make_request
   bi_bdev			raid0/make_request
   bi_idx			end_that_request_first
   bi_size

 But not (I hope)
   bi_io_vec->bv_page
   bi_rw
   bi_vcnt
   bi_max_vecs
   bi_end_io
   bi_private

 And these can easily be reset or zeroed

   bi_next
   bi_phys_segments
   bi_hw_segments
   bi_hw_front_size
   bi_hw_back_size

   bi_flags ???


sector, bdev, size are all remembered in r1_bio.
That leaves bi_idx and an array od len/offset pairs that we need
to preserve.

So I guess the first step is to change alloc_behind_pages to
return a new 'struct bio_vec' array rather than just a list of pages,
and we should keep that array attached to the raid1_bio.

Sound reasonable?

NeilBrown

