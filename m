From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async  writes
Date: Tue, 04 May 2004 16:08:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4097F82E.60404@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com> <16528.49083.998593.199805@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16528.49083.998593.199805@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday March 31, Paul.Clements@SteelEye.com wrote:
>   and less that a month later I replied .... I've been busy and had
>   two weeks leave in there.  Sorry.

Ahh, I noticed you'd been absent from the mailing lists for a bit...

Anyway, thanks for taking the time to review this...

>>Create a bitmap file:
>>--------------------
>>
>># mdadm --create-bitmap=65536,3,580480 /tmp/bitmap --force
>>
> 
> 
> Maybe:
> mdadm --create-bitmap --chunksize=64 --delay=3 --size==580480
> ???
> while more verbose, it is also easier to remember and more in-keeping
> with the rest of mdadm's syntax.

OK...and it will probably change slightly if we're not doing bitmaps in 
files...more on that below...


>>1) an is_create flag was added to do_md_run to tell bitmap_create
>>whether we are creating or just assembling the array -- this is
>>necessary since 0.90 superblocks do not have a UUID until one is
>>generated randomly at array creation time, therefore, we must set the
>>bitmap UUID equal to this newly generated array UUID when the array is
>>created
> 
> 
> I think this is the wrong approach.  You are justifying a design error
> by reference to a previous design error.

I agree, I don't like it either, but there is no clean solution that I 
can think of...

> I think user-space should be completely responsible for creating the
> bitmap file including setting the UUID.

> Either
>   1/ add the bitmap after the array has been created.

We can't do this because the initial resync would have started.

> or
>   2/ Create the array in user-space and just get the kernel to
>     assemble it (this is what I will almost certainly do in mdadm
>     once I get around to supporting version 1 superblocks).

I'd gladly support version 1 superblocks, but currently the tools and 
kernel support for them is not complete.

So in order to have working code, right now, unfortunately, my hack is a 
necessary evil. If there's a cleaner way to make this work, I'm 
certainly open to suggestions.



>>3) code was added to mdadm to allow creation of arrays with
>>non-persistent superblocks (also, device size calculation with
>>non-persistent superblocks was fixed)
>>
>>4) a fix was made to the hot_remove code to allow a faulty device to be
>>removed
>>
>>5) various typo and minor bug fixes were also included in the patches
> 
> 
> 
> please, Please, PLEASE, keep separate patches separate.  It makes them
> much easier to review, and hence makes acceptance much more likely.

Yes, I should have cleaned the patch up a bit...sorry about that...

> In particular, your fix in 4 is, I think, wrong.  I agree that there
> is a problem here. I don't think your fix is correct.

Could you explain what's wrong with it? I'll be glad to alter the patch 
if there's a better way to fix this problem.


> 
> But, onto the patch.
> 
> 
> 1/ Why bitmap_alloc_page instead of just kmalloc?

That was part of Peter's original patch and I never bothered to change 
it. Admittedly, there probably is not a valid reason for having the 
cache. I'll remove it and just use kmalloc. If we find we need it later, 
it can be added back...

>    If every kernel subsystem kept it's own private cache of memory
>    in case of desperate need, then there would be a lot of memory
>    wastage.   Unless you have evidence that times when you need to
>    allocate a bitmap are frequently times when there is excessive
>    memory pressure, I think you should just trust kmalloc.
>    On the other hand, if you have reason to believe that the services
>    of kmalloc are substantially suboptimal for your needs, you should
>    explain why in a comment.
> 
>  2/There is a race in bitmap_checkpage.
>    I assume that the required postcondition is that (if the arguments
>    are valid) either bitmap->bp[page].hijacked or bitmap->bp[page].map
>    but not both.  If this is the case, then
> 
> +	if ((mappage = bitmap_alloc_page(bitmap)) == NULL) {
> +		PRINTK("%s: bitmap map page allocation failed, hijacking\n", 
> +			bmname(bitmap));
> +		/* failed - set the hijacked flag so that we can use the
> +		 * pointer as a counter */
> +		spin_lock_irqsave(&bitmap->lock, flags);
> +		bitmap->bp[page].hijacked = 1;
> +		goto out_unlock;
> +	}
> 
>    should become:
> 
> +	if ((mappage = bitmap_alloc_page(bitmap)) == NULL) {
> +		PRINTK("%s: bitmap map page allocation failed, hijacking\n", 
> +			bmname(bitmap));
> +		/* failed - set the hijacked flag so that we can use the
> +		 * pointer as a counter */
> +		spin_lock_irqsave(&bitmap->lock, flags);
> +		if (!bitmap->bp[page].map) bitmap->bp[page].hijacked = 1;
> +		goto out_unlock;
> +	}
> 
>    as someone else could have allocated a bitmap while we were trying
>    and failing.

Yes, I'll fix that.

> 
> 
>  3/ Your bmap_page / sync_page is very filesystem-specific.
> 
>    bmap_page sets page->private to a linked-list of buffers.
>    However page->private "belongs" to the address-space that the page
>    is in, which means the filesystem.

Yes, you're right.

>    I don't know if any filesystems use page->private for anything
>    other than a list of buffers, but they certainly could if they
>    wanted to, and if they did, this code would suddenly break.

XFS uses page->private differently...

> 
>    I think that if you have your heart set on being able to store the
>    bitmap in a file, that using a loop-back mount would be easiest.
>    But if you don't want to do that, at least use the correct
>    interface.  Referring to the code in loop.c would help.

We could not do the prepare_write/commit_write (as loop does) because of 
the current->journal_info limitation in jbd/ext3 (i.e., a single process 
cannot have two jbd transactions ongoing at a time, even though the two 
transactions are for different filesystems). In order to work around 
that limitation, we would have had to create a separate thread to do the 
bitmap writes, which is complex and probably too slow to be an 
acceptable solution.

I now agree with you that (due to the aforementioned limitations) bitmap 
files are not going to work. I think, at least for now, we'll go with a 
bitmap located on a device at a certain offset. So, for a bitmap located 
on the md partition itself, we specify an offset of sb_offset+4096. For 
a standalone bitmap device/partition (or loopback mount of a file, as 
you suggested) we give a 0 offset.


>    Another alternative would be to use the approach that swapfile uses.
>    i.e. create a list of extents using bmap information, and then do
>    direct IO to the device using this extent information.
>    swapfile chooses to ignore any extent that is less that a page.
>    You might not want to do that, but you wouldn't have to.
> 
> 
>   4/ I would avoid extending the file in the kernel.  It is too easy
>      to do that in user space.  Just require that the file is the
>      correct size.

OK. That's easy enough to change.


>   5/ I find it very confusing that you kmap a page, and then leave it
>      to some function that you call to kunmap the page (unmap_put_page
>      or sync_put_page).  It looks very unbalanced.  I would much
>      rather see the kunmap in the same function as the kmap.
> 
>   6/ It seems odd that bitmap_set_state calls unmap_put_page instead
>      of sync_put_page.  Surely you want to sync the superblock at this
>      point.  
>   7/ The existence of bitmap_get_state confuses me.  Why not store the
>      state in the bitmap structure in bitmap_read_sb??
> 
>   8/ calling md_force_spare(.., 1) to force a sync is definitely
>      wrong.  You appear to be assuming a raid1 array with exactly two
>      devices.  Can't you just set recovery_cp to 0, or maybe just set
>      a flag somewhere and test it in md_check_recovery??

This is code that was necessary in 2.4, where it was harder to trigger a 
resync. I think this can be cleaned up for 2.6.


>   9/ why don't you just pass "%s_bitmap" as the thread name to
>      md_register_thread ?  As far as I can tell, it would have exactly
>      the same effect as the current code without requiring a kmalloc.

OK


>   10/
> +static void bitmap_stop_daemon(struct bitmap *bitmap)
> +{
> +	mdk_thread_t *daemon;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bitmap->lock, flags);
> +	if (!bitmap->daemon) {
> +		spin_unlock_irqrestore(&bitmap->lock, flags);
> +		return;
> +	}
> +	daemon = bitmap->daemon;
> +	bitmap->daemon = NULL;
> +	spin_unlock_irqrestore(&bitmap->lock, flags);
> +	md_unregister_thread(daemon); /* destroy the thread */
> +}
> 
> would look better as:
> 
> +static void bitmap_stop_daemon(struct bitmap *bitmap)
> +{
> +	mdk_thread_t *daemon;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bitmap->lock, flags);
> +	daemon = bitmap->daemon;
> +	bitmap->daemon = NULL;
> +	spin_unlock_irqrestore(&bitmap->lock, flags);
> +	if (bitmap->daemon)
> +		md_unregister_thread(daemon); /* destroy the thread */
> +}

OK

>    
>    11/  md_update_sb needs to be called with the mddev locked, and I
>         think there are times when you call it without the lock.
>         I would prefer it if you left it 'static' and just set the
>         sb_dirty flag.  raid[156]d will the update date it soon
>         enough.

I think that will be OK, as long as it doesn't open up a window for 
things to get into an inconsistent state if there's a crash.


>    12/ The tests in hot_add_disk to see if the newly added device is
>        sufficiently up-to-date that the bitmap can be used to get it
>        the rest of the way up-to-date must be wrong as they don't
>        contain any reference to 'events'.
>        You presumably want to be able to fail/remove a drive and then
>        re-add it and not require a full resync.
>        For this to work, you need to record an event number when the
>        bitmap switches from "which blocks on active drives are not
>        in-sync" to "which blocks active drives have changed since a
>        drive failed", and when you incorporate a new device, only
>        allow it to be synced based on the bitmap if the event counter
>        is at least as new as the saved one (plus the checks you
>        currently have).

Yes, the current code assumes only two partitions, and thus does not do 
this extra checking. I'll look at adding that.


>     13/ The test
> +	} else if (atomic_read(&mddev->bitmap_file->f_count) > 2) {
>         in set_bitmap_file is half-hearted at best.
>         What you probably want is "deny_write_access".

I'll check that out.

>         Or just check that the file is owned by root and isn't world
> 	writable. 
> 
>         The check against the uuid in the header should be enough to
>         ensure that operator error doesn't result in the one file
>         being used for two arrays.
> 
>     14/ In md_do_sync, I think you should move "cond_reshed()" above 
> 
> @@ -3312,6 +3506,10 @@ static void md_do_sync(mddev_t *mddev)
>  			goto out;
>  		}
>  
> +		/* don't worry about speed limits unless we do I/O */
> +		if (!need_sync)
> +			continue;
> +
>  		/*
>  		 * this loop exits only if either when we are slower than
>  		 * the 'hard' speed limit, or the system was IO-idle for
> 
>         to make sure that mdX_sync doesn't steal too much time before
>         allowing a reschedule.

I'll look at doing this.


> 
> and the worst part about it is that the code doesn't support what I
> would think would be the most widely used and hence most useful case,
> and that is to store the bitmap in the 60K of space after the
> superblock.

As mentioned above, the next patch will support this configuration (as 
well as standalone bitmap devices/partitions).


Hopefully, the next patch will be more to your liking (and much smaller, 
too...)

--
Paul
