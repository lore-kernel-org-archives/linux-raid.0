From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: double read in raid1
Date: Wed, 25 Aug 2004 12:32:50 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16683.64082.542823.562247@cse.unsw.edu.au>
References: <200408242051.i7OKpeq10271@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Tuesday August 24
To: ptb@it.uc3m.es
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday August 24, ptb@it.uc3m.es wrote:
> In raid1 one could read from both (or more drives) and discard all read
> returns except the first.  This should be fractionally faster than
> reading from one drive alone in most circumstances.
> 
> However, one can also split the reads so that if say 128 requests are
> queued, then the lowest 64 are read from one drive and the highest 64
> from another.  With luck, that would amount to doubling the read rate,
> as there would be little overlap on what is read from the two drives,
> and requests are issued asyncronously.
> 
> Curiously, that is about what the current code does (by accident, and
> slightly wrongly), but it stops doing it in exactly the circumstances
> when it would do good - during a linear set of contiguous reads.  In
> that case one should issue 50% of each batch of requests given to the
> request function to one drive, and the other 50% as far away as possible
> to the other drive. The current code does no switch half way through
> each batch of requests (where it would do good), but instead after
> counting through exactly 128 requests, which is a pretty random point 
> in a batch.
> 
> If the reads come from all over the shop, then one still gains from
> doing half on one drive and half on the other, so long as one does
> both halves at the same time and one arranges that the readaheads
> do not overlap the reads from the other drives (it's easier to say
> that they don't when reads are a contiguous linear sequence, which is
> why I said that that's the case when one should be sharing reads
> between two drives).

Sounds like "plugging" might be the thing to do.

When a read request arrives, just stick it on a queue, counting
   the number of sectors.
When an "unplug" call is made:
    Sort the queue
    Submit half the sectors to one drive, and the other half
     to the other drive.

Further refinements:
  Not "half" but "1/N" if there are "N" drives.
  Keep track of number of outstanding reads per drive, and
  submit fewer requests to busier drives.

Does that sound like what you want?

NeilBrown
