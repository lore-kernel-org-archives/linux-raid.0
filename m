From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 002 of 2] md: Improve the is_mddev_idle test
Date: Thu, 10 May 2007 19:46:38 +1000
Message-ID: <17986.59902.831796.721280@notabene.brown>
References: <20070510161940.20204.patches@notabene>
	<1070510062231.20403@suse.de>
	<20070510003304.c5fc35d2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday May 10
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 10, akpm@linux-foundation.org wrote:
> On Thu, 10 May 2007 16:22:31 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > The test currently looks for any (non-fuzz) difference, either
> > positive or negative.  This clearly is not needed.  Any non-sync
> > activity will cause the total sectors to grow faster than the sync_io
> > count (never slower) so we only need to look for a positive differences.
> > 
> > ...
> >
> > --- .prev/drivers/md/md.c	2007-05-10 15:51:54.000000000 +1000
> > +++ ./drivers/md/md.c	2007-05-10 16:05:10.000000000 +1000
> > @@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
> >  		 *
> >  		 * Note: the following is an unsigned comparison.
> >  		 */
> > -		if ((curr_events - rdev->last_events + 4096) > 8192) {
> > +		if ((long)curr_events - (long)rdev->last_events > 4096) {
> >  			rdev->last_events = curr_events;
> >  			idle = 0;
> 
> In which case would unsigned counters be more appropriate?

I guess.....

It is really the comparison that I want to be signed, I don't much
care about the counted - they are expected to wrap (though they might
not).
So maybe I really want

     if ((signed long)(curr_events - rdev->last_events) > 4096) {

to make it clear...
But people expect number to be signed by default, so that probably
isn't necessary.

Yeah, I'll make them signed one day.

Thanks,
NeilBrown
