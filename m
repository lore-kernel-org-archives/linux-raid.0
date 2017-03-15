From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC PATCH] md/raid10: refactor some codes from
 raid10_write_request
Date: Wed, 15 Mar 2017 15:46:48 -0700
Message-ID: <20170315224648.g77w3nt23weycrhy@kernel.org>
References: <1489397039-3353-1-git-send-email-gqjiang@suse.com>
 <20170314164836.mekttgqcw4smsgsw@kernel.org>
 <58C8AED4.5020309@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <58C8AED4.5020309@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com
List-Id: linux-raid.ids

On Wed, Mar 15, 2017 at 11:02:44AM +0800, Guoqing Jiang wrote:
> 
> 
> On 03/15/2017 12:48 AM, Shaohua Li wrote:
> > On Mon, Mar 13, 2017 at 05:23:59PM +0800, Guoqing Jiang wrote:
> > > Previously, we clone both bio and repl_bio in raid10_write_request,
> > > then add the cloned bio to plug->pending or conf->pending_bio_list
> > > based on plug or not, and most of the logics are same for the two
> > > conditions.
> > > 
> > > So introduce handle_clonebio (a better name is welcome) for it, and
> > > use replacement parameter to distinguish the difference. No functional
> > > changes in the patch.
> > > 
> > > Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> > > ---
> > > Another reason for it is to improve the readability of code, but
> > > I didn't touch raid10 before so this is labeled as RFC.
> > > 
> > >   drivers/md/raid10.c | 172 ++++++++++++++++++++++------------------------------
> > >   1 file changed, 72 insertions(+), 100 deletions(-)
> > > 
> > > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > > index b1b1f982a722..02d8eff8d26e 100644
> > > --- a/drivers/md/raid10.c
> > > +++ b/drivers/md/raid10.c
> > > @@ -1188,18 +1188,81 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> > >   	return;
> > >   }
> > > -static void raid10_write_request(struct mddev *mddev, struct bio *bio,
> > > -				 struct r10bio *r10_bio)
> > > +static void handle_clonebio(struct mddev *mddev, struct r10bio *r10_bio,
> > > +			    struct bio *bio, int i, int replacement,
> > > +			    int max_sectors)
> > Maybe raid10_write_one_disk?
> 
> Thanks for review, I will use it unless a better name is found.
> 
> >   Please replace 'i' with a meaningful name and
> > change to 'boo' for replacement.
> 
> Ok, I would replace 'i' with 'n_copy', what is the meaning of 'boo'?
> IMO, replacement fits better here, thanks.

sorry, I mean 'bool'
 
> +		if (r10_bio->devs[i].bio)
> +			handle_clonebio(mddev, r10_bio, bio, i, 0, max_sectors);
> +		if (r10_bio->devs[i].repl_bio)
> +			handle_clonebio(mddev, r10_bio, bio, i, 1, max_sectors);
> 
> 
> 
> Regards,
> Guoqing
> 
> 
