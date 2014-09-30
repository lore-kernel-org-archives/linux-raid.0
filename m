From: BillStuff <billstuff2001@sbcglobal.net>
Subject: Re: Raid5 hang in 3.14.19
Date: Mon, 29 Sep 2014 23:19:51 -0500
Message-ID: <542A2F67.7060706@sbcglobal.net>
References: <5425E9D6.1050102@sbcglobal.net>	<20140929122533.3b91a543@notabene.brown>	<5428D863.7090409@sbcglobal.net>	<20140929140818.1086972e@notabene.brown>	<5428DFE1.9080600@sbcglobal.net> <20140930075950.1d1e3865@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140930075950.1d1e3865@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/29/2014 04:59 PM, NeilBrown wrote:
> On Sun, 28 Sep 2014 23:28:17 -0500 BillStuff <billstuff2001@sbcglobal.net>
> wrote:
>
>> On 09/28/2014 11:08 PM, NeilBrown wrote:
>>> On Sun, 28 Sep 2014 22:56:19 -0500 BillStuff <billstuff2001@sbcglobal.net>
>>> wrote:
>>>
>>>> On 09/28/2014 09:25 PM, NeilBrown wrote:
>>>>> On Fri, 26 Sep 2014 17:33:58 -0500 BillStuff <billstuff2001@sbcglobal.net>
>>>>> wrote:
>>>>>
>>>>>> Hi Neil,
>>>>>>
>>>>>> I found something that looks similar to the problem described in
>>>>>> "Re: seems like a deadlock in workqueue when md do a flush" from Sept 14th.
>>>>>>
>>>>>> It's on 3.14.19 with 7 recent patches for fixing raid1 recovery hangs.
>>>>>>
>>>>>> on this array:
>>>>>> md3 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
>>>>>>           104171200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>>>>>>           bitmap: 1/5 pages [4KB], 2048KB chunk
>>>>>>
>>>>>> I was running a test doing parallel kernel builds, read/write loops, and
>>>>>> disk add / remove / check loops,
>>>>>> on both this array and a raid1 array.
>>>>>>
>>>>>> I was trying to stress test your recent raid1 fixes, which went well,
>>>>>> but then after 5 days,
>>>>>> the raid5 array hung up with this in dmesg:
>>>>> I think this is different to the workqueue problem you mentioned, though as I
>>>>> don't know exactly what caused either I cannot be certain.
>>>>>
>>>>>     From the data you provided it looks like everything is waiting on
>>>>> get_active_stripe(), or on a process that is waiting on that.
>>>>> That seems pretty common whenever anything goes wrong in raid5 :-(
>>>>>
>>>>> The md3_raid5 task is listed as blocked, but not stack trace is given.
>>>>> If the machine is still in the state, then
>>>>>
>>>>>     cat /proc/1698/stack
>>>>>
>>>>> might be useful.
>>>>> (echo t > /proc/sysrq-trigger is always a good idea)
>>>> Might this help? I believe the array was doing a "check" when things
>>>> hung up.
>>> It looks like it was trying to start doing a 'check'.
>>> The 'resync' thread hadn't been started yet.
>>> What is 'kthreadd' doing?
>>> My guess is that it is in try_to_free_pages() waiting for writeout
>>> for some xfs file page onto the md array ... which won't progress until
>>> the thread gets started.
>>>
>>> That would suggest that we need an async way to start threads...
>>>
>>> Thanks,
>>> NeilBrown
>>>
>> I suspect your guess is correct:
> Thanks for the confirmation.
>
> I'm thinking of something like that.  Very basic suggestion suggests it
> instantly crash.
>
> If you were to apply this patch and run your test for a week or two,  that
> would increase my confidence (though of course testing doesn't prove the
> absence of bugs....)
>
> Thanks,
> NeilBrown

Got it running. I'll let you know if anything interesting happens.

Thanks,
Bill
>
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a79e51d15c2b..580d4b97696c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7770,6 +7770,33 @@ no_add:
>   	return spares;
>   }
>   
> +static void md_start_sync(struct work_struct *ws)
> +{
> +	struct mddev *mddev = container_of(ws, struct mddev, del_work);
> +
> +	mddev->sync_thread = md_register_thread(md_do_sync,
> +						mddev,
> +						"resync");
> +	if (!mddev->sync_thread) {
> +		printk(KERN_ERR "%s: could not start resync"
> +		       " thread...\n",
> +		       mdname(mddev));
> +		/* leave the spares where they are, it shouldn't hurt */
> +		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +		clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> +		clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> +		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> +		clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +		if (test_and_clear_bit(MD_RECOVERY_RECOVER,
> +				       &mddev->recovery))
> +			if (mddev->sysfs_action)
> +				sysfs_notify_dirent_safe(mddev->sysfs_action);
> +	} else
> +		md_wakeup_thread(mddev->sync_thread);
> +	sysfs_notify_dirent_safe(mddev->sysfs_action);
> +	md_new_event(mddev);
> +}
> +
>   /*
>    * This routine is regularly called by all per-raid-array threads to
>    * deal with generic issues like resync and super-block update.
> @@ -7823,6 +7850,7 @@ void md_check_recovery(struct mddev *mddev)
>   
>   	if (mddev_trylock(mddev)) {
>   		int spares = 0;
> +		bool sync_starting = false;
>   
>   		if (mddev->ro) {
>   			/* On a read-only array we can:
> @@ -7921,28 +7949,14 @@ void md_check_recovery(struct mddev *mddev)
>   				 */
>   				bitmap_write_all(mddev->bitmap);
>   			}
> -			mddev->sync_thread = md_register_thread(md_do_sync,
> -								mddev,
> -								"resync");
> -			if (!mddev->sync_thread) {
> -				printk(KERN_ERR "%s: could not start resync"
> -					" thread...\n",
> -					mdname(mddev));
> -				/* leave the spares where they are, it shouldn't hurt */
> -				clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> -				clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> -				clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> -				clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> -				clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> -			} else
> -				md_wakeup_thread(mddev->sync_thread);
> -			sysfs_notify_dirent_safe(mddev->sysfs_action);
> -			md_new_event(mddev);
> +			INIT_WORK(&mddev->del_work, md_start_sync);
> +			queue_work(md_misc_wq, &mddev->del_work);
> +			sync_starting = true;
>   		}
>   	unlock:
>   		wake_up(&mddev->sb_wait);
>   
> -		if (!mddev->sync_thread) {
> +		if (!mddev->sync_thread && !sync_starting) {
>   			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>   			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
>   					       &mddev->recovery))
>

