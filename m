Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A560BC433DB
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 23:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634AA227BF
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 23:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732557AbhAYXH2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jan 2021 18:07:28 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:46823 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732772AbhAYVdU (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 25 Jan 2021 16:33:20 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id F165920647907;
        Mon, 25 Jan 2021 22:32:30 +0100 (CET)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
From:   Donald Buczek <buczek@molgen.mpg.de>
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
Message-ID: <bc342de0-98d2-1733-39cd-cc1999777ff3@molgen.mpg.de>
Date:   Mon, 25 Jan 2021 22:32:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cdc0b03c-db53-35bc-2f75-93bbca0363b5@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 25.01.21 09:54, Donald Buczek wrote:
> Dear Guoqing,
> 
> a colleague of mine was able to produce the issue inside a vm and were able to find a procedure to run the vm into the issue within minutes (not unreliably after hours on a physical system as before). This of course helped to pinpoint the problem.
> 
> My current theory of what is happening is:
> 
> - MD_SB_CHANGE_CLEAN + MD_SB_CHANGE_PENDING are set by md_write_start() when file-system I/O wants to do a write and the array transitions from "clean" to "active". (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L8308)
> 
> - Before raid5d gets to write the superblock (its busy processing active stripes because of the sync activity) , userspace wants to pause the check by `echo idle > /sys/block/mdX/md/sync_action`
> 
> - action_store() takes the reconfig_mutex before trying to stop the sync thread. (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L4689) Dump of struct mddev of email 1/19/21 confirms reconf_mutex non-zero.
> 
> - raid5d is running in its main loop. raid5d()->handle_active_stripes() returns a positive batch size ( https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/raid5.c#L6329 ) although raid5d()->handle_active_stripes()->handle_stripe() doesn't process any stripe because of MD_SB_CHANGE_PENDING. (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/raid5.c#L4729 ). This is the reason, raid5d is busy looping.
> 
> - raid5d()->md_check_recovery() is called by the raid5d main loop. One of its duties is to write the superblock, if a change is pending. However to do so, it needs either MD_ALLOW_SB_UPDATE or must be able to take the reconfig_mutex. (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L8967 , https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L9006) Both is not true, so the superblock is not written and MD_SB_CHANGE_PENDING is not cleared.
> 
> - (as discussed previously) the sync thread is waiting for the number of active stripes to go down and doesn't terminate. The userspace thread is waiting for the sync thread to terminate.
> 
> Does this make sense?
> 
> Just for reference, I add the procedure which triggers the issue on the vm (with /dev/md3 mounted on /mnt/raid_md3) and some debug output:
> 
> ```
> #! /bin/bash
> 
> (
>          while true; do
>                  echo "start check"
>                  echo check > /sys/block/md3/md/sync_action
>                  sleep 10
>                  echo "stop check"
>                  echo idle > /sys/block/md3/md/sync_action
>                  sleep 2
>          done
> ) &
> 
> (
>          while true; do
>                  dd bs=1k count=$((5*1024*1024)) if=/dev/zero of=/mnt/raid_md3/bigfile status=none
>                  sync /mnt/raid_md3/bigfile
>                  rm /mnt/raid_md3/bigfile
>                  sleep .1
>          done
> ) &
> 
> start="$(date +%s)"
> cd /sys/block/md3/md
> wp_count=0
> while true; do
>          array_state=$(cat array_state)
>          if [ "$array_state" = write-pending ]; then
>                  wp_count=$(($wp_count+1))
>          else
>                  wp_count=0
>          fi
>          echo $(($(date +%s)-$start)) $(cat sync_action) $(cat sync_completed) $array_state $(cat stripe_cache_active)
>          if [ $wp_count -ge 3 ]; then
>                  kill -- -$$
>                  exit
>          fi
>          sleep 1
> done
> ```
> 
> The time, this needs to trigger the issue, varies from under a minute to one hour with 5 minute being typical. The output ends like this:
> 
>      309 check 6283872 / 8378368 active-idle 4144
>      310 check 6283872 / 8378368 active 1702
>      311 check 6807528 / 8378368 active 4152
>      312 check 7331184 / 8378368 clean 3021
>      stop check
>      313 check 7331184 / 8378368 write-pending 3905
>      314 check 7331184 / 8378368 write-pending 3905
>      315 check 7331184 / 8378368 write-pending 3905
>      Terminated
> 
> If I add
> 
>      pr_debug("XXX batch_size %d release %d mdddev->sb_flags %lx\n", batch_size, released, mddev->sb_flags);
> 
> in raid5d after the call to handle_active_stripes and enable the debug location after the deadlock occurred, I get
> 
>      [ 3123.939143] [1223] raid5d:6332: XXX batch_size 8 release 0 mdddev->sb_flags 6
>      [ 3123.939156] [1223] raid5d:6332: XXX batch_size 8 release 0 mdddev->sb_flags 6
>      [ 3123.939170] [1223] raid5d:6332: XXX batch_size 8 release 0 mdddev->sb_flags 6
>      [ 3123.939184] [1223] raid5d:6332: XXX batch_size 8 release 0 mdddev->sb_flags 6
> 
> If I add
> 
>      pr_debug("XXX 1 %s:%d mddev->flags %08lx mddev->sb_flags %08lx\n", __FILE__, __LINE__, mddev->flags, mddev->sb_flags);
> 
> at the head of md_check_recovery, I get:
> 
>      [  789.555462] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>      [  789.555477] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>      [  789.555491] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>      [  789.555505] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>      [  789.555520] [1191] md_check_recovery:8970: XXX 1 drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
> 
> More debug lines in md_check_recovery confirm the control flow ( `if (mddev_trylock(mddev))` block not taken )
> 
> What approach would you suggest to fix this?

I naively tried the following patch and it seems to fix the problem. The test procedure didn't trigger the deadlock in 10 hours.

D.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2d21c298ffa7..f40429843906 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4687,11 +4687,13 @@ action_store(struct mddev *mddev, const char *page, size_t len)
  			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
  		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
  		    mddev_lock(mddev) == 0) {
+			set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
  			flush_workqueue(md_misc_wq);
  			if (mddev->sync_thread) {
  				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
  				md_reap_sync_thread(mddev);
  			}
+			clear_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
  			mddev_unlock(mddev);
  		}
  	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-- 
2.30.0
