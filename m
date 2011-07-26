From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 14/34] md/raid5: move more code into common
 handle_stripe
Date: Tue, 26 Jul 2011 11:48:42 +1000
Message-ID: <20110726114842.7e941f22@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.59699.stgit@notabene.brown>
	<87r55idb4c.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r55idb4c.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011 16:32:03 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > The difference between the RAID5 and RAID6 code here is easily
> > resolved using conf->max_degraded.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Reviewed-by: Namhyung Kim <namhyung@gmail.com>
> 
> and a coding style issue.
> 

> > +	if (s.failed <= conf->max_degraded && !conf->mddev->ro)
> > +		for (i = 0; i < s.failed; i++) {
> > +			struct r5dev *dev = &sh->dev[s.failed_num[i]];
> > +			if (test_bit(R5_ReadError, &dev->flags)
> > +			    && !test_bit(R5_LOCKED, &dev->flags)
> > +			    && test_bit(R5_UPTODATE, &dev->flags)
> > +				) {
> 
> This line looks weird and should be combined to previous line.
> 
> And I slightly prefer that the logical operators are put on the
> same line with previous conditional, so that next one can be on
> the same column and more readable, but ...
> 

I agree that it is nice if they line up.  But I also think the "&&" is
important and want it to stand out.  In this case the '!' would stop them
from lining up very nicely, so I'll leave it as it is.

The thing I like about having ") {" on a separate line is that I can later
add a condition by just adding a line - it makes the patch easier to read.

Not a bit thing maybe and I don't always structure conditions like this, but
I think I'll leave it this time.

Thanks,
NeilBrown

