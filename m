From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md - 2 of 10 - Don't allow raid5 rebuild to swamp raid5
 stripe cache
Date: Fri, 16 Jan 2004 12:43:38 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16391.16842.560527.897653@notabene.cse.unsw.edu.au>
References: <E1AhIe9-0002U2-00@notabene>
	<20040115173317.3a356afc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday January 15
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 15, akpm@osdl.org wrote:
> NeilBrown <neilb@cse.unsw.edu.au> wrote:
> >
> > +	if (sh == NULL) {
> > +		sh = get_active_stripe(conf, sector_nr, pd_idx, 0);
> > +		/* make sure we don't swamp the stripe cache if someone else
> > +		 * is trying to get access 
> > +		 */
> > +		yield();
> > +	}
> 
> In 2.6, yield() has utterly awful behaviour when there are a lot of other
> runnable tasks.
> 
> Have you tested this when the kernel is busy doing other stuff, like a
> `make -j2' or a few busywait loops?  You might find that rebuild simply
> stops.
> 

No I haven't, and I'm not near my test box today, so it would be
awkward. 

No other patches are dependant on that one so you can just leave it
out if you like.

I just want to wait until every other runnable process has had a
turn.  Maybe cond_resched() would be better??  I try some things out.

NeilBrown

