From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Tue, 08 Jun 2004 16:53:15 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C6273B.2060200@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com> <16528.49083.998593.199805@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16528.49083.998593.199805@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

Neil,

Here's the latest patch...it supports bitmaps in files as well as block 
devices (disks or partitions), contrary to what I had stated in my 
previous e-mail. I've tried to address all the issues you've pointed 
out, and generally cleaned up and fixed the patch some more...details 
below...

Patches available at:

bitmap patch for 2.6.6:
   http://dsl2.external.hp.com/~jejb/md_bitmap/md_bitmap_2_32_2_6_6.diff

mdadm patch against v1.6.0:
   http://dsl2.external.hp.com/~jejb/md_bitmap/mdadm_1_6_0-bitmap.diff

(the normal parisc-linux.org URLs are not working right now, for some 
reason...)

Thanks again,
Paul


Neil Brown wrote:
> On Wednesday March 31, Paul.Clements@SteelEye.com wrote:
>   and less that a month later I replied .... I've been busy and had
>   two weeks leave in there.  Sorry.
> 
> 
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

OK, this is done. I reused the existing --chunk, --delay, and --size 
options. The bitmap "file" can be either a file (e.g., /tmp/my_bitmap) 
or a block device (e.g., /dev/sdd10).



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
> I think user-space should be completely responsible for creating the
> bitmap file including setting the UUID.
> Either
>   1/ add the bitmap after the array has been created.
> or
>   2/ Create the array in user-space and just get the kernel to
>     assemble it (this is what I will almost certainly do in mdadm
>     once I get around to supporting version 1 superblocks).

I could not find another way to make this work with the existing code, 
so this remains as is.



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

I've removed all the other bug fixes, spelling corrections, etc.



> In particular, your fix in 4 is, I think, wrong.  I agree that there
> is a problem here. I don't think your fix is correct.
> 
> But, onto the patch.
> 
> 
> 1/ Why bitmap_alloc_page instead of just kmalloc?
>    If every kernel subsystem kept it's own private cache of memory
>    in case of desperate need, then there would be a lot of memory
>    wastage.   Unless you have evidence that times when you need to
>    allocate a bitmap are frequently times when there is excessive
>    memory pressure, I think you should just trust kmalloc.
>    On the other hand, if you have reason to believe that the services
>    of kmalloc are substantially suboptimal for your needs, you should
>    explain why in a comment.

This has been changed to simply kmalloc/kfree.


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

This has been fixed.



>  3/ Your bmap_page / sync_page is very filesystem-specific.
> 
>    bmap_page sets page->private to a linked-list of buffers.
>    However page->private "belongs" to the address-space that the page
>    is in, which means the filesystem.
>    I don't know if any filesystems use page->private for anything
>    other than a list of buffers, but they certainly could if they
>    wanted to, and if they did, this code would suddenly break.
> 
>    I think that if you have your heart set on being able to store the
>    bitmap in a file, that using a loop-back mount would be easiest.
>    But if you don't want to do that, at least use the correct
>    interface.  Referring to the code in loop.c would help.

I've basically rewritten the bitmap file read/write code to be exactly 
like loop.c. This includes the current limitation of needing an extra 
write thread in which to perform the bitmap file writes (again, due to 
the jbd current->journal_info problem).


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

The file will no longer be extended in the kernel.


>   5/ I find it very confusing that you kmap a page, and then leave it
>      to some function that you call to kunmap the page (unmap_put_page
>      or sync_put_page).  It looks very unbalanced.  I would much
>      rather see the kunmap in the same function as the kmap.

This has been cleaned up and simplified.


>   6/ It seems odd that bitmap_set_state calls unmap_put_page instead
>      of sync_put_page.  Surely you want to sync the superblock at this
>      point.

There's now an explicit bitmap_update_sb where needed.


>   7/ The existence of bitmap_get_state confuses me.  Why not store the
>      state in the bitmap structure in bitmap_read_sb??

bitmap_get_state is gone...the state now gets recorded in bitmap->flags 
and read from there


>   8/ calling md_force_spare(.., 1) to force a sync is definitely
>      wrong.  You appear to be assuming a raid1 array with exactly two
>      devices.  Can't you just set recovery_cp to 0, or maybe just set
>      a flag somewhere and test it in md_check_recovery??

This has been updated to the 2.6 style of kicking off recovery (setting 
MD_RECOVERY_NEEDED and waking up the recovery thread).


>   9/ why don't you just pass "%s_bitmap" as the thread name to
>      md_register_thread ?  As far as I can tell, it would have exactly
>      the same effect as the current code without requiring a kmalloc.

Right, fixed.

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

OK, changed.


>    11/  md_update_sb needs to be called with the mddev locked, and I
>         think there are times when you call it without the lock.
>         I would prefer it if you left it 'static' and just set the
>         sb_dirty flag.  raid[156]d will the update date it soon
>         enough.

Agreed. Actually, since the bitmap state is no longer in the md 
superblock, this is completely unneeded and has been removed.


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

Right. The extra check and event fields in the superblock have been added.

>     13/ The test
> +	} else if (atomic_read(&mddev->bitmap_file->f_count) > 2) {
>         in set_bitmap_file is half-hearted at best.
>         What you probably want is "deny_write_access".

I now use a slightly modified version of deny_write_access...


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

Done.


> and the worst part about it is that the code doesn't support what I
> would think would be the most widely used and hence most useful case,
> and that is to store the bitmap in the 60K of space after the
> superblock.

Unfortunately, this type of setup performs rather abysmally (generally, 
about a 5-10x slowdown in write performance). If you think about what is 
happening to the disk head, it becomes clear why. In fact, having the 
intent log anywhere on the same physical media as the array components 
gives very bad performance. For this reason, I have not taken extra 
steps to support this configuration. If anyone is curious, this type of 
setup can be tested using device mapper (but not loop, because loop does 
not have the correct sync semantics) to map that area of the disk as a 
separate device and use it as a bitmap.


> If you had implemented that first, then you could have avoided all the
> mucking about with files, which seems to be a problematic area, and
> probably had working and accepted code by now.  Then adding support
> for separate files could have been layered on top.
> That would have meant that each piece of submitted code was
> substantially smaller and hence easier to review.
> 
> 
> Anyway, enough for now.  I'll try to review your next patch with a
> little less delay, but it is a substantial effort, and that makes it
> easy to put off.
> 
> 
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

