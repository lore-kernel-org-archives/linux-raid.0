Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8810CC433DB
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 09:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461FD206B5
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 09:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403748AbhAZJvZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jan 2021 04:51:25 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:36187 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390389AbhAZJvT (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 26 Jan 2021 04:51:19 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7C9DA20647904;
        Tue, 26 Jan 2021 10:50:25 +0100 (CET)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
 <77244d60-1c2d-330e-71e6-4907d4dd65fc@molgen.mpg.de>
 <7c5438c7-2324-cc50-db4d-512587cb0ec9@molgen.mpg.de>
 <b289ae15-ff82-b36e-4be4-a1c8bbdbacd7@cloud.ionos.com>
 <37c158cb-f527-34f5-2482-cae138bc8b07@molgen.mpg.de>
 <efb8d47b-ab9b-bdb9-ee2f-fb1be66343b1@molgen.mpg.de>
 <55e30408-ac63-965f-769f-18be5fd5885c@molgen.mpg.de>
 <d95aa962-9750-c27c-639a-2362bdb32f41@cloud.ionos.com>
 <30576384-682c-c021-ff16-bebed8251365@molgen.mpg.de>
 <cdc0b03c-db53-35bc-2f75-93bbca0363b5@molgen.mpg.de>
 <bc342de0-98d2-1733-39cd-cc1999777ff3@molgen.mpg.de>
 <c3390ab0-d038-f1c3-5544-67ae9c8408b1@cloud.ionos.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <a27c5a64-62bf-592c-e547-1e8e904e3c97@molgen.mpg.de>
Date:   Tue, 26 Jan 2021 10:50:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c3390ab0-d038-f1c3-5544-67ae9c8408b1@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Guoqing,

On 26.01.21 01:44, Guoqing Jiang wrote:
> Hi Donald,
> 
> On 1/25/21 22:32, Donald Buczek wrote:
>>
>>
>> On 25.01.21 09:54, Donald Buczek wrote:
>>> Dear Guoqing,
>>>
>>> a colleague of mine was able to produce the issue inside a vm and were able to find a procedure to run the vm into the issue within minutes (not unreliably after hours on a physical system as before). This of course helped to pinpoint the problem.
>>>
>>> My current theory of what is happening is:
>>>
>>> - MD_SB_CHANGE_CLEAN + MD_SB_CHANGE_PENDING are set by md_write_start() when file-system I/O wants to do a write and the array transitions from "clean" to "active". (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L8308)
>>>
>>> - Before raid5d gets to write the superblock (its busy processing active stripes because of the sync activity) , userspace wants to pause the check by `echo idle > /sys/block/mdX/md/sync_action`
>>>
>>> - action_store() takes the reconfig_mutex before trying to stop the sync thread. (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L4689) Dump of struct mddev of email 1/19/21 confirms reconf_mutex non-zero.
>>>
>>> - raid5d is running in its main loop. raid5d()->handle_active_stripes() returns a positive batch size ( https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/raid5.c#L6329 ) although raid5d()->handle_active_stripes()->handle_stripe() doesn't process any stripe because of MD_SB_CHANGE_PENDING. (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/raid5.c#L4729 ). This is the reason, raid5d is busy looping.
>>>
>>> - raid5d()->md_check_recovery() is called by the raid5d main loop. One of its duties is to write the superblock, if a change is pending. However to do so, it needs either MD_ALLOW_SB_UPDATE or must be able to take the reconfig_mutex. (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L8967 , https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L9006) Both is not true, so the superblock is not written and MD_SB_CHANGE_PENDING is not cleared.
>>>
>>> - (as discussed previously) the sync thread is waiting for the number of active stripes to go down and doesn't terminate. The userspace thread is waiting for the sync thread to terminate.
>>>
>>> Does this make sense?
> 
> Yes, exactly! That was my thought too, the scenario is twisted.
> 
> Then resync thread is blocked due to there are too many active stripes, because raid5d is in busy loop since SB_CHANGE_PENDING is set which means tactive stripes can't be decreased, and echo idle cmd can't make progress given resync thread is blocked while the cmd still hold reconfig_mutex which make raid5d in busy loop and can't clear SB_CHANGE_PENDING flag.
> 
> And raid5 could suffer from the same issue I think.
> 
>>>
>>> Just for reference, I add the procedure which triggers the issue on the vm (with /dev/md3 mounted on /mnt/raid_md3) and some debug output:
>>>
>>> ```
>>> #! /bin/bash
>>>
>>> (
>>>          while true; do
>>>                  echo "start check"
>>>                  echo check > /sys/block/md3/md/sync_action
>>>                  sleep 10
>>>                  echo "stop check"
>>>                  echo idle > /sys/block/md3/md/sync_action
>>>                  sleep 2
>>>          done
>>> ) &
>>>
>>> (
>>>          while true; do
>>>                  dd bs=1k count=$((5*1024*1024)) if=/dev/zero of=/mnt/raid_md3/bigfile status=none
>>>                  sync /mnt/raid_md3/bigfile
>>>                  rm /mnt/raid_md3/bigfile
>>>                  sleep .1
>>>          done
>>> ) &
>>>
>>> start="$(date +%s)"
>>> cd /sys/block/md3/md
>>> wp_count=0
>>> while true; do
>>>          array_state=$(cat array_state)
>>>          if [ "$array_state" = write-pending ]; then
>>>                  wp_count=$(($wp_count+1))
>>>          else
>>>                  wp_count=0
>>>          fi
>>>          echo $(($(date +%s)-$start)) $(cat sync_action) $(cat sync_completed) $array_state $(cat stripe_cache_active)
>>>          if [ $wp_count -ge 3 ]; then
>>>                  kill -- -$$
>>>                  exit
>>>          fi
>>>          sleep 1
>>> done
>>> ```
>>>
>>> The time, this needs to trigger the issue, varies from under a minute to one hour with 5 minute being typical. The output ends like this:
>>>
>>>      309 check 6283872 / 8378368 active-idle 4144
>>>      310 check 6283872 / 8378368 active 1702
>>>      311 check 6807528 / 8378368 active 4152
>>>      312 check 7331184 / 8378368 clean 3021
>>>      stop check
>>>      313 check 7331184 / 8378368 write-pending 3905
>>>      314 check 7331184 / 8378368 write-pending 3905
>>>      315 check 7331184 / 8378368 write-pending 3905
>>>      Terminated
>>>
>>> If I add
>>>
>>>      pr_debug("XXX batch_size %d release %d mdddev->sb_flags %lx\n", batch_size, released, mddev->sb_flags);
>>>
>>> in raid5d after the call to handle_active_stripes and enable the debug location after the deadlock occurred, I get
>>>
>>>      [ 3123.939143] [1223] raid5d:6332: XXX batch_size 8 release 0 mdddev->sb_flags 6
>>>      [ 3123.939156] [1223] raid5d:6332: XXX batch_size 8 release 0 mdddev->sb_flags 6
>>>      [ 3123.939170] [1223] raid5d:6332: XXX batch_size 8 release 0 mdddev->sb_flags 6
>>>      [ 3123.939184] [1223] raid5d:6332: XXX batch_size 8 release 0 mdddev->sb_flags 6
>>>
>>> If I add
>>>
>>>      pr_debug("XXX 1 %s:%d mddev->flags %08lx mddev->sb_flags %08lx\n", __FILE__, __LINE__, mddev->flags, mddev->sb_flags);
>>>
>>> at the head of md_check_recovery, I get:
>>>
>>>      [  789.555462] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>>      [  789.555477] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>>      [  789.555491] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>>      [  789.555505] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>>      [  789.555520] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>>
>>> More debug lines in md_check_recovery confirm the control flow ( `if (mddev_trylock(mddev))` block not taken )
>>>
> 
> That is great that you have a reproducer now!
> 
>>> What approach would you suggest to fix this?
>>
>> I naively tried the following patch and it seems to fix the problem. The test procedure didn't trigger the deadlock in 10 hours.
>>
>> D.
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 2d21c298ffa7..f40429843906 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4687,11 +4687,13 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>>               clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>           if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>>               mddev_lock(mddev) == 0) {
>> +            set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>>               flush_workqueue(md_misc_wq);
>>               if (mddev->sync_thread) {
>>                   set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>                   md_reap_sync_thread(mddev);
>>               }
>> +            clear_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>>               mddev_unlock(mddev);
>>           }
>>       } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> 
> Yes, it could break the deadlock issue, but I am not sure if it is the right way given we only set ALLOW_SB_UPDATE in suspend which makes sense since the io will be quiesced, but write idle action can't guarantee the  similar thing.

Thinking (and documenting) MD_ALLOW_SB_UPDATE as "the holder of reconfig_mutex promises not to make any changes which would exclude superblocks from being written" might make it easier to accept the usage.

> I prefer to make resync thread not wait forever here.
> 
> wait_event_lock_irq(
>      conf->wait_for_stripe,
>      !list_empty(conf->inactive_list + hash) &&
>      (atomic_read(&conf->active_stripes)
>      < (conf->max_nr_stripes * 3 / 4)
>      || !test_bit(R5_INACTIVE_BLOCKED,
>               &conf->cache_state)
>      *(conf->hash_locks + hash));
> 
> So, could you please try the attached?
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 4337ae0..378ce5c 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1931,7 +1931,7 @@ r5c_recovery_alloc_stripe(
>  {
>  	struct stripe_head *sh;
>  
> -	sh = raid5_get_active_stripe(conf, stripe_sect, 0, noblock, 0);
> +	sh = raid5_get_active_stripe(conf, stripe_sect, 0, 0, noblock, 0);
>  	if (!sh)
>  		return NULL;  /* no more stripe available */
>  
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8888973..33a2a22 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -700,10 +700,11 @@ static int has_failed(struct r5conf *conf)
>  }
>  
>  struct stripe_head *
> -raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
> +raid5_get_active_stripe(struct r5conf *conf, sector_t sector, int sync_req,
>  			int previous, int noblock, int noquiesce)
>  {
>  	struct stripe_head *sh;
> +	struct mddev *mddev = conf->mddev;
>  	int hash = stripe_hash_locks_hash(conf, sector);
>  	int inc_empty_inactive_list_flag;
>  
> @@ -738,8 +739,14 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
>  					(atomic_read(&conf->active_stripes)
>  					 < (conf->max_nr_stripes * 3 / 4)
>  					 || !test_bit(R5_INACTIVE_BLOCKED,
> -						      &conf->cache_state)),
> +						      &conf->cache_state)
> +					 || (test_bit(MD_RECOVERY_INTR,
> +						      &mddev->recovery)
> +					     && sync_req)),
>  					*(conf->hash_locks + hash));
> +				if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)
> +				    && sync_req)
> +					break;
>  				clear_bit(R5_INACTIVE_BLOCKED,
>  					  &conf->cache_state);
>  			} else {
> @@ -4527,7 +4534,7 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
>  			sector_t bn = raid5_compute_blocknr(sh, i, 1);
>  			sector_t s = raid5_compute_sector(conf, bn, 0,
>  							  &dd_idx, NULL);
> -			sh2 = raid5_get_active_stripe(conf, s, 0, 1, 1);
> +			sh2 = raid5_get_active_stripe(conf, s, 0, 0, 1, 1);
>  			if (sh2 == NULL)
>  				/* so far only the early blocks of this stripe
>  				 * have been requested.  When later blocks
> @@ -5164,7 +5171,7 @@ static void handle_stripe(struct stripe_head *sh)
>  	/* Finish reconstruct operations initiated by the expansion process */
>  	if (sh->reconstruct_state == reconstruct_state_result) {
>  		struct stripe_head *sh_src
> -			= raid5_get_active_stripe(conf, sh->sector, 1, 1, 1);
> +			= raid5_get_active_stripe(conf, sh->sector, 0, 1, 1, 1);
>  		if (sh_src && test_bit(STRIPE_EXPAND_SOURCE, &sh_src->state)) {
>  			/* sh cannot be written until sh_src has been read.
>  			 * so arrange for sh to be delayed a little
> @@ -5705,7 +5712,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>  		DEFINE_WAIT(w);
>  		int d;
>  	again:
> -		sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
> +		sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0, 0);
>  		prepare_to_wait(&conf->wait_for_overlap, &w,
>  				TASK_UNINTERRUPTIBLE);
>  		set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
> @@ -5861,7 +5868,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>  			(unsigned long long)new_sector,
>  			(unsigned long long)logical_sector);
>  
> -		sh = raid5_get_active_stripe(conf, new_sector, previous,
> +		sh = raid5_get_active_stripe(conf, new_sector, previous, 0,


Mistake here (fourth argument added instead of third)

>  				       (bi->bi_opf & REQ_RAHEAD), 0);
>  		if (sh) {
>  			if (unlikely(previous)) {
> @@ -6100,7 +6107,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
>  	for (i = 0; i < reshape_sectors; i += RAID5_STRIPE_SECTORS(conf)) {
>  		int j;
>  		int skipped_disk = 0;
> -		sh = raid5_get_active_stripe(conf, stripe_addr+i, 0, 0, 1);
> +		sh = raid5_get_active_stripe(conf, stripe_addr+i, 0, 0, 0, 1);
>  		set_bit(STRIPE_EXPANDING, &sh->state);
>  		atomic_inc(&conf->reshape_stripes);
>  		/* If any of this stripe is beyond the end of the old
> @@ -6149,7 +6156,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
>  	if (last_sector >= mddev->dev_sectors)
>  		last_sector = mddev->dev_sectors - 1;
>  	while (first_sector <= last_sector) {
> -		sh = raid5_get_active_stripe(conf, first_sector, 1, 0, 1);
> +		sh = raid5_get_active_stripe(conf, first_sector, 0, 1, 0, 1);
>  		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
>  		set_bit(STRIPE_HANDLE, &sh->state);
>  		raid5_release_stripe(sh);
> @@ -6269,9 +6276,14 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
>  
>  	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr, false);
>  
> -	sh = raid5_get_active_stripe(conf, sector_nr, 0, 1, 0);
> +	sh = raid5_get_active_stripe(conf, sector_nr, 1, 0, 1, 0);
>  	if (sh == NULL) {
> -		sh = raid5_get_active_stripe(conf, sector_nr, 0, 0, 0);
> +		sh = raid5_get_active_stripe(conf, sector_nr, 1, 0, 0, 0);
> +		if (!sh && test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> +			*skipped = 1;
> +			return 0;
> +		}
> +
>  		/* make sure we don't swamp the stripe cache if someone else
>  		 * is trying to get access
>  		 */
> @@ -6334,7 +6346,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio,
>  			/* already done this stripe */
>  			continue;
>  
> -		sh = raid5_get_active_stripe(conf, sector, 0, 1, 1);
> +		sh = raid5_get_active_stripe(conf, sector, 0, 0, 1, 1);
>  
>  		if (!sh) {
>  			/* failed to get a stripe - must wait */
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 5c05acf..d9eab46 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -806,7 +806,7 @@ extern sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
>  				     int previous, int *dd_idx,
>  				     struct stripe_head *sh);
>  extern struct stripe_head *
> -raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
> +raid5_get_active_stripe(struct r5conf *conf, sector_t sector, int sync_req,
>  			int previous, int noblock, int noquiesce);
>  extern int raid5_calc_degraded(struct r5conf *conf);
>  extern int r5c_journal_mode_set(struct mddev *mddev, int journal_mode);

Unfortunately, this patch did not fix the issue.

     root@sloth:~/linux# cat /proc/$(pgrep md3_resync)/stack
     [<0>] raid5_get_active_stripe+0x1e7/0x6b0
     [<0>] raid5_sync_request+0x2a7/0x3d0
     [<0>] md_do_sync.cold+0x3ee/0x97c
     [<0>] md_thread+0xab/0x160
     [<0>] kthread+0x11b/0x140
     [<0>] ret_from_fork+0x22/0x30

which is ( according to objdump -d -Sl drivers/md/raid5.o ) at https://elixir.bootlin.com/linux/v5.11-rc5/source/drivers/md/raid5.c#L735

Isn't it still the case that the superblocks are not written, therefore stripes are not processed, therefore number of active stripes are not decreasing? Who is expected to wake up conf->wait_for_stripe waiters?

Best
   Donald

> 
> Thanks,
> Guoqing

