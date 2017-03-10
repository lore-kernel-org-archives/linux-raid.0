From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3] md: move bitmap_destroy before __md_stop
Date: Thu, 9 Mar 2017 17:06:04 -0800
Message-ID: <20170310010604.lpyhnmnlcy5w3xmi@kernel.org>
References: <1488940292-8555-1-git-send-email-gqjiang@suse.com>
 <20170309182443.c3th4di2v3kct7eu@kernel.org>
 <87k27ygdj6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k27ygdj6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org, shli@fb.com
List-Id: linux-raid.ids

On Fri, Mar 10, 2017 at 11:51:09AM +1100, Neil Brown wrote:
> On Thu, Mar 09 2017, Shaohua Li wrote:
> 
> > On Wed, Mar 08, 2017 at 10:31:32AM +0800, Guoqing Jiang wrote:
> >> Since we have switched to sync way to handle METADATA_UPDATED
> >> msg for md-cluster, then process_metadata_update is depended
> >> on mddev->thread->wqueue.
> >> 
> >> With the new change, clustered raid could possible hang if
> >> array received a METADATA_UPDATED msg after array unregistered
> >> mddev->thread, so we need to stop clustered raid (bitmap_destroy
> >> 	 -> bitmap_free -> md_cluster_stop) earlier than unregister
> >> thread (mddev_detach -> md_unregister_thread).
> >> 
> >> And this change should be safe for non-clustered raid since
> >> all writes are stopped before the destroy. Also in md_run,
> >> we activate the personality (pers->run()) before activating
> >> the bitmap (bitmap_create()). So it is pleasingly symmetric
> >> to stop the bitmap (bitmap_destroy()) before stopping the
> >> personality (__md_stop() calls pers->free()).
> >> 
> >> But we don't want to break the codes for waiting behind IO as
> >> Shaohua mentioned, so move those codes from mddev_detach to
> >> bitmap_destroy. Since we already check bitmap at the beginning
> >> of bitmap_destroy, just wait for behind_writes to be zero if
> >> it existed.
> >> 
> >> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >> ---
> >> This version move waiting behind IO codes into bitmap_destroy
> >> so we can safely call bitmap_destroy before __md_stop now.
> >> 
> >>  drivers/md/bitmap.c |  9 +++++++++
> >>  drivers/md/md.c     | 13 ++-----------
> >>  2 files changed, 11 insertions(+), 11 deletions(-)
> >> 
> >> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> >> index b6fa55a3cff8..89a35bc092dd 100644
> >> --- a/drivers/md/bitmap.c
> >> +++ b/drivers/md/bitmap.c
> >> @@ -1771,6 +1771,15 @@ void bitmap_destroy(struct mddev *mddev)
> >>  	if (!bitmap) /* there was no bitmap */
> >>  		return;
> >>  
> >> +	/* wait for behind writes to complete */
> >> +	if (atomic_read(&bitmap->behind_writes) > 0) {
> >> +		printk(KERN_INFO "md:%s: behind writes in progress - waiting to stop.\n",
> >> +		       mdname(mddev));
> >> +		/* need to kick something here to make sure I/O goes? */
> >> +		wait_event(bitmap->behind_wait,
> >> +			   atomic_read(&bitmap->behind_writes) == 0);
> >> +	}
> >> +
> >>  	mutex_lock(&mddev->bitmap_info.mutex);
> >>  	spin_lock(&mddev->lock);
> >>  	mddev->bitmap = NULL; /* disconnect from the md device */
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 79a99a1c9ce7..b63ab4f33892 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -5534,15 +5534,6 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
> >>  
> >>  static void mddev_detach(struct mddev *mddev)
> >>  {
> >> -	struct bitmap *bitmap = mddev->bitmap;
> >> -	/* wait for behind writes to complete */
> >> -	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
> >> -		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
> >> -			 mdname(mddev));
> >> -		/* need to kick something here to make sure I/O goes? */
> >> -		wait_event(bitmap->behind_wait,
> >> -			   atomic_read(&bitmap->behind_writes) == 0);
> >> -	}
> >
> > I think it's ok to add this part into bitmap_destroy, as we need to call
> > bitmap_destroy before mddev_detach. Look at the usage of mddev_detach, at in
> > one place (level_store()), we wait for the IO without bitmap_destroy. I think
> > we should keep this part code in mddev_detach. Maybe create a small function,
> > let both mddev_detach and bitmap_destroy call it.
> 
> I don't think level_store() needs to explicitly wait for behind io.
> It calls mddev_suspend(), which calls the ->quiesce function in the
> personality, which is responsible for waiting for all pending IO,
> including behind.  raid1.c does this correctly.

Can you elaborate Where >quiesce waits for behind IO in raid1? It's not
obvious. It really should though.

Thanks,
Shaohua
