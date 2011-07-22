From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 10/34] md/raid5: unify stripe_head_state and r6_state
Date: Fri, 22 Jul 2011 15:15:06 +1000
Message-ID: <20110722151506.54c66e82@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.40355.stgit@notabene.brown>
	<878vrqex7i.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878vrqex7i.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011 13:49:37 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

 
> > @@ -2964,7 +2964,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
> >  			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
> >  			for (j = 0; j < conf->raid_disks; j++)
> >  				if (j != sh2->pd_idx &&
> > -				    (!r6s || j != sh2->qd_idx) &&
> > +				    (r6s || j != sh2->qd_idx) &&
> 
> Why is this changed?
> 

No good reason that I can think of ... so must be a bug.  I'll fix it.

In the current code, r6s is always NULL! which is also a bug.
When you get to

   md/raid5: Move code for finishing a reconstruction into handle_stripe.

You'll find that the call which passed 's' in was changed to pass 'NULL' in
when merging the RAID5 and RAID6 code.  I'll fix that too.

Thanks,
NeilBrown

