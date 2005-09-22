From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Thu, 22 Sep 2005 18:16:41 +0200
Message-ID: <17202.55529.310871.877019@cse.unsw.edu.au>
References: <20050920143346.GA5777@uio.no>
	<17200.9302.242957.23189@cse.unsw.edu.au>
	<20050920153622.GA14287@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steinar H. Gunderson on Tuesday September 20
Sender: linux-raid-owner@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 20, sgunderson@bigfoot.com wrote:
> 
> > I'll try to have a read through your code over the next week or so and
> > give you more detailed feedback.
> 
> OK, thanks. :-) There's a lot of unneeded junk in the patch, BTW (some
> reindenting here and there that I don't know where is coming from, plus lots
> of temporary added printks), but I guess we can sort out the cleanness after
> a while. :-)

Yes, that reindenting is a problem as it makes the patch hard to read
-- it's hard to see which bits need to be checked and which don't.  If
you could remove them for the next version, it would help....

Can I make two suggestions for a start?

1/ in raid5_reshape, rather than allocate a separate set of
  stripe_heads, I think it would be good to re-size all of the stripes
  and the continue running with the new set of stripe_heads.
  This would involved repeatedly

     get_inactive_stripe
     allocate new stripe slightly bigger
     copy the pages across
     allocate the extra pages
     put it on a private list

  Repeat this until we have all the stripes.  This will temporarily
  stall the raid5 as the stripes will be exhausted.  
  As soon as you have them all, you release them again, and the raid
  will continue to work.  
  Avoiding the two lists of stripe_heads will remove a fair bit of
  code.

2/ Reserve the stripe_heads needed for a chunk-resize in make_request
   (where it is safe to block) rather than in handle_stripe.

   so make_request reserves all the stripes needed to read, and all
   needed to write (which may overlap for the first chunk) or 2,
   (store them in an array or list in ->conf) and arrange for
   handle_stripe to trigger the reads, and arrange that new write
   requests to any of these flags block.
   Once the reads are done, shuffle the pages (rather then memcpy,
   just fiddle with pointers), and cause write-out to commence.

Please let me know if that makes sense, or if you don't think it will
work, or if you just don't have the time....

Thanks,
NeilBrown
