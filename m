From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid1 doesn't balance under high load [patch]
Date: Tue, 15 Jun 2004 09:48:49 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16590.14689.510651.969354@cse.unsw.edu.au>
References: <20040610113019.GA8660@cistron.nl>
	<16585.2632.321497.620210@cse.unsw.edu.au>
	<20040614113037.GC13422@traveler.cistron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miquel van Smoorenburg on Monday June 14
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 14, miquels@cistron.nl wrote:
> On 2004.06.11 03:26, Neil Brown wrote:
> > On Thursday June 10, miquels@cistron.nl wrote:
> > > The problem is in raid1.c:read_balance().
> > > 
> > > Now if you write to the array, the array is marked not in sync by
> > > md.c:md_write_start(). conf->next_resync is initialized to zero, so
> > > that means read balancing doesn't work anymore.
> > 
> > Yes, you are right.  Thanks.
> > Your patch is close, but not quite right (though it would be hard to
> > cause it to actually fail).
> > I think it patch is more correct.  I would appreciate it if you could
> > confirm that it works for you.
> 
> It doesn't because of a small typo:
> 
> > diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
> > --- ./drivers/md/raid1.c~current~	2004-06-11 11:20:34.000000000 +1000
> > +++ ./drivers/md/raid1.c	2004-06-11 11:21:57.000000000 +1000
> > @@ -375,7 +375,8 @@ static int read_balance(conf_t *conf, st
> >  	 * device if no resync is going on, or below the resync window.
> >  	 * We take the first readable disk when above the resync window.
> >  	 */
> > -	if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
> > +	if (!conf->mddev->recovery_cp < MaxSector &&
> > +	    (this_sector + sectors >= conf->next_resync)) {
> >  		/* make sure that disk is operational */
> >  		new_disk = 0;
> 
> I think that should read:
> 
> 
> -	if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
> +	if (conf->mddev->recovery_cp < MaxSector &&
> +	    this_sector + sectors >= conf->next_resync) {
> 
> and then it works.

Yes.... thanks for the fix and thanks for testing it.  I appreciate
it.
I'll send the correct patch off to Andrew Morton.

NeilBrown
