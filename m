From: Xiao Ni <xni@redhat.com>
Subject: Re: Stuck in md_write_start because MD_SB_CHANGE_PENDING can't be
 cleared
Date: Sat, 30 Sep 2017 17:44:53 +0800
Message-ID: <07f22731-4acb-dccf-12ba-ed4ce63c5537@redhat.com>
References: <546311999.4473128.1504339295016.JavaMail.zimbra@redhat.com>
 <877exfdx7x.fsf@notabene.neil.brown.name>
 <22698eb3-35f7-04e5-96e8-26470d892655@redhat.com>
 <b5856cb8-0ea6-7bf2-10a0-76dd69d04698@redhat.com>
 <87y3pvc9ha.fsf@notabene.neil.brown.name>
 <34fedde7-cef9-34ff-1403-9d097267eb55@redhat.com>
 <87k21ec4fn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k21ec4fn.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: shli@kernel.org
List-Id: linux-raid.ids



On 09/05/2017 09:36 AM, NeilBrown wrote:
> On Mon, Sep 04 2017, Xiao Ni wrote:
>
>>
>> In function handle_stripe:
>> 4697         if (s.handle_bad_blocks ||
>> 4698             test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
>> 4699                 set_bit(STRIPE_HANDLE, &sh->state);
>> 4700                 goto finish;
>> 4701         }
>>
>> Because MD_SB_CHANGE_PENDING is set, so the stripes can't be handled.
>>
> Right, of course.  I see what is happening now.
>
> - raid5d cannot complete stripes until the metadata is written
> - the metadata cannot be written until raid5d gets the mddev_lock
> - mddev_lock is held by the write to suspend_hi
> - the write to suspend_hi is waiting for raid5_quiesce
> - raid5_quiesce is waiting for some stripes to complete.
>
> We could declare that ->quiesce(, 1) cannot be called while holding the
> lock.
> We could possible allow it but only if md_update_sb() is called first,
> though that might still be racy.
>
> ->quiesce(, 1) is currently called from:
>   mddev_suspend
>   suspend_lo_store
>   suspend_hi_store
>   __md_stop_writes
>   mddev_detach
>   set_bitmap_file
>   update_array_info (when setting/removing internal bitmap)
>   md_do_sync
>
> and most of those are call with the lock held, or take the lock.
>
> Maybe we should *require* that mddev_lock is held when calling
> ->quiesce() and have ->quiesce() do the metadata update.
>
> Something like the following maybe.  Can you test it?
> Thanks,
> NeilBrown
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b01e458d31e9..999ccf08c5db 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5805,9 +5805,11 @@ void md_stop(struct mddev *mddev)
>   	/* stop the array and free an attached data structures.
>   	 * This is called from dm-raid
>   	 */
> +	mddev_lock_nointr(mddev);
>   	__md_stop(mddev);
>   	if (mddev->bio_set)
>   		bioset_free(mddev->bio_set);
> +	mddev_unlock(mddev);
>   }
>   
>   EXPORT_SYMBOL_GPL(md_stop);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0fc2748aaf95..cde5a82eb404 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4316,6 +4316,8 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
>   
>   			/* place all the copies on one channel */
>   			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
> +			WARN_ON(sh2->dev[dd_idx].page != sh2->dev[dd_idx].orig_page);
> +			WARN_ON(sh->dev[i].page != sh->dev[i].orig_page);
>   			tx = async_memcpy(sh2->dev[dd_idx].page,
>   					  sh->dev[i].page, 0, 0, STRIPE_SIZE,
>   					  &submit);
> @@ -8031,7 +8033,10 @@ static void raid5_quiesce(struct mddev *mddev, int state)
>   		wait_event_cmd(conf->wait_for_quiescent,
>   				    atomic_read(&conf->active_stripes) == 0 &&
>   				    atomic_read(&conf->active_aligned_reads) == 0,
> -				    unlock_all_device_hash_locks_irq(conf),
> +				    ({unlock_all_device_hash_locks_irq(conf);
> +					if (mddev->sb_flags)
> +						md_update_sb(mddev, 0);
> +				    }),
>   				    lock_all_device_hash_locks_irq(conf));
>   		conf->quiesce = 1;
>   		unlock_all_device_hash_locks_irq(conf);

Hi Neil

I read this patch again. But I don't know why it can't work.
It calls md_update_sb when it waits for active_stripes. It should
clear MD_SB_CHANGE_CLEAN and MD_SB_CHANGE_PENDING.

Could you explain this?

Best Regards
Xiao
