From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 19/34] md/raid5: move some more common code into
 handle_stripe
Date: Tue, 26 Jul 2011 11:59:23 +1000
Message-ID: <20110726115923.56f0f314@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.58479.stgit@notabene.brown>
	<87livqpssz.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87livqpssz.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011 18:29:16 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > The RAID6 version of this code is usable for RAID5 providing:
> >   - we test "conf->max_degraded" rather than "2" as appropriate
> >   - we make sure s->failed_num[1] is meaningful (and not '-1')
> >     when s->failed > 1
> >
> > The 'return 1' must become 'goto finish' in the new location.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Reviewed-by: Namhyung Kim <namhyung@gmail.com>
> 
> and nitpick below.
> 
> 

> > +	pr_debug("locked=%d uptodate=%d to_read=%d"
> > +	       " to_write=%d failed=%d failed_num=%d,%d\n",
> > +	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
> > +	       s.failed_num[0], s.failed_num[1]);
> > +	/* check if the array has lost >2 devices and, if so, some requests
> > +	 * might need to be failed
>         /* check if the array has lost more than max_degraded devices and,
>            if so, some requests might need to be failed
> 
> Thanks.
> 
> 

OK, I made that change - thanks.

NeilBrown

