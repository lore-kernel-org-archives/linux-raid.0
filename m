From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: Raid1 doesn't balance under high load [patch]
Date: Mon, 14 Jun 2004 13:30:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040614113037.GC13422@traveler.cistron.net>
References: <20040610113019.GA8660@cistron.nl> <16585.2632.321497.620210@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16585.2632.321497.620210@cse.unsw.edu.au> (from neilb@cse.unsw.edu.au on Fri, Jun 11, 2004 at 03:26:32 +0200)
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004.06.11 03:26, Neil Brown wrote:
> On Thursday June 10, miquels@cistron.nl wrote:
> > The problem is in raid1.c:read_balance().
> > 
> > Now if you write to the array, the array is marked not in sync by
> > md.c:md_write_start(). conf->next_resync is initialized to zero, so
> > that means read balancing doesn't work anymore.
> 
> Yes, you are right.  Thanks.
> Your patch is close, but not quite right (though it would be hard to
> cause it to actually fail).
> I think it patch is more correct.  I would appreciate it if you could
> confirm that it works for you.

It doesn't because of a small typo:

> diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
> --- ./drivers/md/raid1.c~current~	2004-06-11 11:20:34.000000000 +1000
> +++ ./drivers/md/raid1.c	2004-06-11 11:21:57.000000000 +1000
> @@ -375,7 +375,8 @@ static int read_balance(conf_t *conf, st
>  	 * device if no resync is going on, or below the resync window.
>  	 * We take the first readable disk when above the resync window.
>  	 */
> -	if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
> +	if (!conf->mddev->recovery_cp < MaxSector &&
> +	    (this_sector + sectors >= conf->next_resync)) {
>  		/* make sure that disk is operational */
>  		new_disk = 0;

I think that should read:


-	if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
+	if (conf->mddev->recovery_cp < MaxSector &&
+	    this_sector + sectors >= conf->next_resync) {

and then it works.

Mike.
