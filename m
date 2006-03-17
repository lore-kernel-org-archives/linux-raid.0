From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 007 of 13] md: Core of raid5 resize process
Date: Fri, 17 Mar 2006 18:10:04 +1100
Message-ID: <17434.24780.264743.119634@cse.unsw.edu.au>
References: <20060317154017.15880.patches@notabene>
	<1060317044755.16096@suse.de>
	<20060316220322.0cfa80bf.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday March 16
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 16, akpm@osdl.org wrote:
> NeilBrown <neilb@suse.de> wrote:
> >
> > @@ -4539,7 +4543,9 @@ static void md_do_sync(mddev_t *mddev)
> >   		 */
> >   		max_sectors = mddev->resync_max_sectors;
> >   		mddev->resync_mismatches = 0;
> >  -	} else
> >  +	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> >  +		max_sectors = mddev->size << 1;
> >  +	else
> >   		/* recovery follows the physical size of devices */
> >   		max_sectors = mddev->size << 1;
> >   
> 
> This change is a no-op.   Intentional?

Uhmm... sort of.
A later patch adds stuff to the later branch but not the middle one.
This comes from creating a patch to fix a bug, then merging it back
into the wrong original patch...

NeilBrown
