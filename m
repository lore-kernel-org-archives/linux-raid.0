From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] md: fix a build warning
Date: Wed, 10 Jun 2015 19:36:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1506101935390.5463@hadrien>
References: <1433949658-8455-1-git-send-email-firogm@gmail.com> <557874B9.9010500@bfs.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-5436621-1433957803=:5463"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <557874B9.9010500@bfs.de>
Sender: linux-raid-owner@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: Firo Yang <firogm@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-5436621-1433957803=:5463
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Wed, 10 Jun 2015, walter harms wrote:

>
>
> Am 10.06.2015 17:20, schrieb Firo Yang:
> > Warning like this:
> >
> > drivers/md/md.c: In function ‘update_array_info’:
> > drivers/md/md.c:6394:26: warning: logical not is only applied
> > to the left hand side of comparison [-Wlogical-not-parentheses]
> >       !mddev->persistent  != info->not_persistent||
> >
> > I fix it by enclosing !mddev->persistent with parentheses
> >
> > By the way, I also fixed a line over 80 characters warning outputed
> > by ./scripts/checkpatch.pl
> >
> > Signed-off-by: Firo Yang <firogm@gmail.com>
> > ---
> >  drivers/md/md.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index dd85be9..b420d82 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6391,9 +6391,10 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
> >  	    mddev->ctime         != info->ctime         ||
> >  	    mddev->level         != info->level         ||
> >  /*	    mddev->layout        != info->layout        || */
> > -	    !mddev->persistent	 != info->not_persistent||
> > +	    (!mddev->persistent) != info->not_persistent ||
>
>
> this looks odd,
> would it be possible the check for == instead (and drop the !) ?
> and it someone care for readability: It would be helpful to
> make some more ifs here.

The original issue looks like a false positive.  If all of the other cases
have no parentheses on the left and use !=, isn't it better to leave the
code as is?

julia

>
> re,
>  wh
>
> >  	    mddev->chunk_sectors != info->chunk_size >> 9 ||
> > -	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT to change */
> > +	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT
> > +		to change */
> >  	    ((state^info->state) & 0xfffffe00)
> >  		)
> >  		return -EINVAL;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--8323329-5436621-1433957803=:5463--
