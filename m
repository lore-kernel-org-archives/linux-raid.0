From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 13/34] md/raid5: Move code for finishing a
 reconstruction into handle_stripe.
Date: Tue, 26 Jul 2011 11:44:17 +1000
Message-ID: <20110726114417.1a9720b8@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.17250.stgit@notabene.brown>
	<87vcuudc6h.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vcuudc6h.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011 16:09:10 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > Prior to commit ab69ae12ceef7 the code in handle_stripe5 and
> > handle_stripe6 to "Finish reconstruct operations initiated by the
> > expansion process" was identical.
> > That commit added an identical stanza of code to each function, but in
> > different places.  That was careless.
> >
> > The raid5 code was correct, so move that out into handle_stripe and
> > remove raid6 version.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Reviewed-by: Namhyung Kim <namhyung@gmail.com>
> 
> and nitpick below..
> 
> 

> >  static void handle_stripe(struct stripe_head *sh)
> >  {
> >  	struct stripe_head_state s;
> > +	int done;
> >  	raid5_conf_t *conf = sh->raid_conf;
> > +	int i;
> 
> Can be declared in a line.
> 

True.... There are differing opinions on whether that is a good idea or not.
I tend to like to keep each variable in it's own declaration, though closely
related variables might get put together.
I have moved 'int i' up one line so the addition is in just one place, but
I've kept it separate from 'done'.

> > +	/* Finish reconstruct operations initiated by the expansion process */
> > +	if (sh->reconstruct_state == reconstruct_state_result) {
> > +		struct stripe_head *sh2
> > +			= get_active_stripe(conf, sh->sector, 1, 1, 1);
> 
> Wouldn't it be better to use more descriptive name rather than sh2,
> something like sh_prev, sh_src or whatever?

good point.  'sh_src' it is.

Thanks,
NeilBrown

