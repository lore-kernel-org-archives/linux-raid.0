From: Xiao Ni <xni@redhat.com>
Subject: Re: Stuck in md_write_start because MD_SB_CHANGE_PENDING can't be
 cleared
Date: Tue, 5 Sep 2017 10:15:00 +0800
Message-ID: <3a5955de-e6a1-de83-b00b-1984f7125799@redhat.com>
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

Hi Neil

Thanks for the analysis. I need to thing for a while :)
I already added the patch and the test is running now. It usually needs 
more than 5
hours to reproduce this problem. I'll let it run more than 24 hours. 
I'll update the test
result later.

Regards
Xiao
