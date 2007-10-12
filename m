From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Expose the degraded status of an assembled array
	through sysfs
Date: Fri, 12 Oct 2007 12:20:44 +1000
Message-ID: <18190.55804.547483.730045@notabene.brown>
References: <20070910165114.GA2597@teal.hq.k1024.org>
	<20071010063111.GA32313@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Iustin Pop on Wednesday October 10
Sender: linux-raid-owner@vger.kernel.org
To: Iustin Pop <iusty@k1024.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 10, iusty@k1024.org wrote:
> On Mon, Sep 10, 2007 at 06:51:14PM +0200, Iustin Pop wrote:
> > The 'degraded' attribute is useful to quickly determine if the array is
> > degraded, instead of parsing 'mdadm -D' output or relying on the other
> > techniques (number of working devices against number of defined devices, etc.).
> > The md code already keeps track of this attribute, so it's useful to export it.
> > 
> > Signed-off-by: Iustin Pop <iusty@k1024.org>
> > ---
> > Note: I sent this back in January and it people agreed it was a good
> > idea.  However, it has not been picked up. So here I resend it again.
> 
> Ping? Neil, could you spare a few moments to look at this? (and sorry for
> bothering you)

Yeh.... thanks for your patience.  September was not a good time for
getting my attention.

Yes, I think this is both sensible and useful.

I might just change......

> > @@ -2842,6 +2842,12 @@ sync_max_store(mddev_t *mddev, const char *buf, size_t len)
> >  static struct md_sysfs_entry md_sync_max =
> >  __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
> >  
> > +static ssize_t
> > +degraded_show(mddev_t *mddev, char *page)
> > +{
> > +	return sprintf(page, "%i\n", mddev->degraded);
> > +}

... the %i to a %d though.   At first I thought it was a typo, but
then checked the man page and discovered that %d and %i both mean the
same thing (so why support them both I wonder).

Thanks,
NeilBrown
