Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9AFC433E0
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 05:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59E6E22273
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 05:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbhAZFLK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729358AbhAZBg5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jan 2021 20:36:57 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB07C06121C
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 16:44:39 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id o20so9430314pfu.0
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 16:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=JLsx2L2mSV0OI5IXzT5lJD4w9AzsejCJ+52IlMaTO9c=;
        b=F0AZig+5OEwman0KskucivmzrumfaVNX01p7tBHZudvTohCZ72w1jlBvWO800V1yoc
         xrYLRJ47+XNOFsPKMZIfxlrFQpW3PPKD3tEpjuLlXLPLoqNyprHFxirVvWfnoqjnaMIS
         gzWl5GSXWR241Ye3jJII+7YI4wruYGY30QiHOR91r/4t6ggMEoOocxHhJdK5quXQx5qZ
         5FkzXxhYL+KXoxFxZAbV1OnlAr/jiYVJPdJtivacznNZGEeENOMcQwLtFqMKOKnhiYcx
         WkzGpM+bdCNLjTbf37LV0Gsf8ZPPBvfkHUdAznzEBvRb+/FDxw0OLH4kwXecmn+uO3UQ
         LHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=JLsx2L2mSV0OI5IXzT5lJD4w9AzsejCJ+52IlMaTO9c=;
        b=H9AttFCL3DO4/LpgHIhwyKuykMNXWTbl3Mjq2GGVGztiieeBD1eaBj5fFD+955h3Py
         R+EH5n825i7N6Q0sLVBPqe+KH0PEXfGtWJrRxuLCVA1WDJ1N/v53ilBs4SpH+IaZo4u/
         Gp+vvISFMftLQwfTJpfl/mKVjWhMBtkdArSDtTQv/PnAGEnj+xjynkmNkv+3ngVeGfQV
         IW7jwPwDPRS1HHIxyBeCjJCaaGUJmXyEX6zEoAlWt0gMPOdxnNkV+se2N/TpFFdPVpbB
         fLwA2h14eHrz9xncWLVGGZPNjBVSU+e0oec5856ABAAQpJ2/8vgjdHNuoUDzccgh3so/
         xRsg==
X-Gm-Message-State: AOAM531NWhG4v/nSZ+9rWMudGBVsCwvvTIIP5kJIKt6SUwN15j+Oxr1E
        4uymn6r7nDpUsyuYMX0kdxfemA==
X-Google-Smtp-Source: ABdhPJxC99fxevHjI5o3jfLontJWngdCbkSzNODg5p7VQKnfc+rvrgE6aW/BY888cknIcTSBOIyyWA==
X-Received: by 2002:a63:fe13:: with SMTP id p19mr3108179pgh.119.1611621876742;
        Mon, 25 Jan 2021 16:44:36 -0800 (PST)
Received: from [10.8.1.5] ([185.125.207.232])
        by smtp.gmail.com with ESMTPSA id 11sm17631611pgz.22.2021.01.25.16.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 16:44:35 -0800 (PST)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org,
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
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <c3390ab0-d038-f1c3-5544-67ae9c8408b1@cloud.ionos.com>
Date:   Tue, 26 Jan 2021 01:44:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bc342de0-98d2-1733-39cd-cc1999777ff3@molgen.mpg.de>
Content-Type: multipart/mixed;
 boundary="------------93515907419EC43A70E50E97"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------93515907419EC43A70E50E97
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Donald,

On 1/25/21 22:32, Donald Buczek wrote:
> 
> 
> On 25.01.21 09:54, Donald Buczek wrote:
>> Dear Guoqing,
>>
>> a colleague of mine was able to produce the issue inside a vm and were 
>> able to find a procedure to run the vm into the issue within minutes 
>> (not unreliably after hours on a physical system as before). This of 
>> course helped to pinpoint the problem.
>>
>> My current theory of what is happening is:
>>
>> - MD_SB_CHANGE_CLEAN + MD_SB_CHANGE_PENDING are set by 
>> md_write_start() when file-system I/O wants to do a write and the 
>> array transitions from "clean" to "active". 
>> (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L8308)
>>
>> - Before raid5d gets to write the superblock (its busy processing 
>> active stripes because of the sync activity) , userspace wants to 
>> pause the check by `echo idle > /sys/block/mdX/md/sync_action`
>>
>> - action_store() takes the reconfig_mutex before trying to stop the 
>> sync thread. 
>> (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L4689) Dump 
>> of struct mddev of email 1/19/21 confirms reconf_mutex non-zero.
>>
>> - raid5d is running in its main loop. 
>> raid5d()->handle_active_stripes() returns a positive batch size ( 
>> https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/raid5.c#L6329 
>> ) although raid5d()->handle_active_stripes()->handle_stripe() doesn't 
>> process any stripe because of MD_SB_CHANGE_PENDING. 
>> (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/raid5.c#L4729 
>> ). This is the reason, raid5d is busy looping.
>>
>> - raid5d()->md_check_recovery() is called by the raid5d main loop. One 
>> of its duties is to write the superblock, if a change is pending. 
>> However to do so, it needs either MD_ALLOW_SB_UPDATE or must be able 
>> to take the reconfig_mutex. 
>> (https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L8967 
>> , 
>> https://elixir.bootlin.com/linux/v5.4.57/source/drivers/md/md.c#L9006) 
>> Both is not true, so the superblock is not written and 
>> MD_SB_CHANGE_PENDING is not cleared.
>>
>> - (as discussed previously) the sync thread is waiting for the number 
>> of active stripes to go down and doesn't terminate. The userspace 
>> thread is waiting for the sync thread to terminate.
>>
>> Does this make sense?

Yes, exactly! That was my thought too, the scenario is twisted.

Then resync thread is blocked due to there are too many active stripes, 
because raid5d is in busy loop since SB_CHANGE_PENDING is set which 
means tactive stripes can't be decreased, and echo idle cmd can't make 
progress given resync thread is blocked while the cmd still hold 
reconfig_mutex which make raid5d in busy loop and can't clear 
SB_CHANGE_PENDING flag.

And raid5 could suffer from the same issue I think.

>>
>> Just for reference, I add the procedure which triggers the issue on 
>> the vm (with /dev/md3 mounted on /mnt/raid_md3) and some debug output:
>>
>> ```
>> #! /bin/bash
>>
>> (
>>          while true; do
>>                  echo "start check"
>>                  echo check > /sys/block/md3/md/sync_action
>>                  sleep 10
>>                  echo "stop check"
>>                  echo idle > /sys/block/md3/md/sync_action
>>                  sleep 2
>>          done
>> ) &
>>
>> (
>>          while true; do
>>                  dd bs=1k count=$((5*1024*1024)) if=/dev/zero 
>> of=/mnt/raid_md3/bigfile status=none
>>                  sync /mnt/raid_md3/bigfile
>>                  rm /mnt/raid_md3/bigfile
>>                  sleep .1
>>          done
>> ) &
>>
>> start="$(date +%s)"
>> cd /sys/block/md3/md
>> wp_count=0
>> while true; do
>>          array_state=$(cat array_state)
>>          if [ "$array_state" = write-pending ]; then
>>                  wp_count=$(($wp_count+1))
>>          else
>>                  wp_count=0
>>          fi
>>          echo $(($(date +%s)-$start)) $(cat sync_action) $(cat 
>> sync_completed) $array_state $(cat stripe_cache_active)
>>          if [ $wp_count -ge 3 ]; then
>>                  kill -- -$$
>>                  exit
>>          fi
>>          sleep 1
>> done
>> ```
>>
>> The time, this needs to trigger the issue, varies from under a minute 
>> to one hour with 5 minute being typical. The output ends like this:
>>
>>      309 check 6283872 / 8378368 active-idle 4144
>>      310 check 6283872 / 8378368 active 1702
>>      311 check 6807528 / 8378368 active 4152
>>      312 check 7331184 / 8378368 clean 3021
>>      stop check
>>      313 check 7331184 / 8378368 write-pending 3905
>>      314 check 7331184 / 8378368 write-pending 3905
>>      315 check 7331184 / 8378368 write-pending 3905
>>      Terminated
>>
>> If I add
>>
>>      pr_debug("XXX batch_size %d release %d mdddev->sb_flags %lx\n", 
>> batch_size, released, mddev->sb_flags);
>>
>> in raid5d after the call to handle_active_stripes and enable the debug 
>> location after the deadlock occurred, I get
>>
>>      [ 3123.939143] [1223] raid5d:6332: XXX batch_size 8 release 0 
>> mdddev->sb_flags 6
>>      [ 3123.939156] [1223] raid5d:6332: XXX batch_size 8 release 0 
>> mdddev->sb_flags 6
>>      [ 3123.939170] [1223] raid5d:6332: XXX batch_size 8 release 0 
>> mdddev->sb_flags 6
>>      [ 3123.939184] [1223] raid5d:6332: XXX batch_size 8 release 0 
>> mdddev->sb_flags 6
>>
>> If I add
>>
>>      pr_debug("XXX 1 %s:%d mddev->flags %08lx mddev->sb_flags 
>> %08lx\n", __FILE__, __LINE__, mddev->flags, mddev->sb_flags);
>>
>> at the head of md_check_recovery, I get:
>>
>>      [  789.555462] [1191] md_check_recovery:8970: XXX 1 
>> drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>      [  789.555477] [1191] md_check_recovery:8970: XXX 1 
>> drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>      [  789.555491] [1191] md_check_recovery:8970: XXX 1 
>> drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>      [  789.555505] [1191] md_check_recovery:8970: XXX 1 
>> drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>      [  789.555520] [1191] md_check_recovery:8970: XXX 1 
>> drivers/md/md.c:8970 mddev->flags 00000000 mddev->sb_flags 00000006
>>
>> More debug lines in md_check_recovery confirm the control flow ( `if 
>> (mddev_trylock(mddev))` block not taken )
>>

That is great that you have a reproducer now!

>> What approach would you suggest to fix this?
> 
> I naively tried the following patch and it seems to fix the problem. The 
> test procedure didn't trigger the deadlock in 10 hours.
> 
> D.
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2d21c298ffa7..f40429843906 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4687,11 +4687,13 @@ action_store(struct mddev *mddev, const char 
> *page, size_t len)
>               clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>           if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>               mddev_lock(mddev) == 0) {
> +            set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>               flush_workqueue(md_misc_wq);
>               if (mddev->sync_thread) {
>                   set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>                   md_reap_sync_thread(mddev);
>               }
> +            clear_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>               mddev_unlock(mddev);
>           }
>       } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))

Yes, it could break the deadlock issue, but I am not sure if it is the 
right way given we only set ALLOW_SB_UPDATE in suspend which makes sense 
since the io will be quiesced, but write idle action can't guarantee the 
  similar thing. I prefer to make resync thread not wait forever here.

wait_event_lock_irq(
	conf->wait_for_stripe,
	!list_empty(conf->inactive_list + hash) && 

	(atomic_read(&conf->active_stripes)
	< (conf->max_nr_stripes * 3 / 4)
	|| !test_bit(R5_INACTIVE_BLOCKED,
		     &conf->cache_state)
	*(conf->hash_locks + hash));

So, could you please try the attached?

Thanks,
Guoqing

--------------93515907419EC43A70E50E97
Content-Type: text/plain; charset=UTF-8;
 name="raid5-proposal"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="raid5-proposal"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDUtY2FjaGUuYyBiL2RyaXZlcnMvbWQvcmFp
ZDUtY2FjaGUuYwppbmRleCA0MzM3YWUwLi4zNzhjZTVjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L21kL3JhaWQ1LWNhY2hlLmMKKysrIGIvZHJpdmVycy9tZC9yYWlkNS1jYWNoZS5jCkBAIC0x
OTMxLDcgKzE5MzEsNyBAQCByNWNfcmVjb3ZlcnlfYWxsb2Nfc3RyaXBlKAogewogCXN0cnVj
dCBzdHJpcGVfaGVhZCAqc2g7CiAKLQlzaCA9IHJhaWQ1X2dldF9hY3RpdmVfc3RyaXBlKGNv
bmYsIHN0cmlwZV9zZWN0LCAwLCBub2Jsb2NrLCAwKTsKKwlzaCA9IHJhaWQ1X2dldF9hY3Rp
dmVfc3RyaXBlKGNvbmYsIHN0cmlwZV9zZWN0LCAwLCAwLCBub2Jsb2NrLCAwKTsKIAlpZiAo
IXNoKQogCQlyZXR1cm4gTlVMTDsgIC8qIG5vIG1vcmUgc3RyaXBlIGF2YWlsYWJsZSAqLwog
CmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQ1LmMgYi9kcml2ZXJzL21kL3JhaWQ1LmMK
aW5kZXggODg4ODk3My4uMzNhMmEyMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9yYWlkNS5j
CisrKyBiL2RyaXZlcnMvbWQvcmFpZDUuYwpAQCAtNzAwLDEwICs3MDAsMTEgQEAgc3RhdGlj
IGludCBoYXNfZmFpbGVkKHN0cnVjdCByNWNvbmYgKmNvbmYpCiB9CiAKIHN0cnVjdCBzdHJp
cGVfaGVhZCAqCi1yYWlkNV9nZXRfYWN0aXZlX3N0cmlwZShzdHJ1Y3QgcjVjb25mICpjb25m
LCBzZWN0b3JfdCBzZWN0b3IsCityYWlkNV9nZXRfYWN0aXZlX3N0cmlwZShzdHJ1Y3QgcjVj
b25mICpjb25mLCBzZWN0b3JfdCBzZWN0b3IsIGludCBzeW5jX3JlcSwKIAkJCWludCBwcmV2
aW91cywgaW50IG5vYmxvY2ssIGludCBub3F1aWVzY2UpCiB7CiAJc3RydWN0IHN0cmlwZV9o
ZWFkICpzaDsKKwlzdHJ1Y3QgbWRkZXYgKm1kZGV2ID0gY29uZi0+bWRkZXY7CiAJaW50IGhh
c2ggPSBzdHJpcGVfaGFzaF9sb2Nrc19oYXNoKGNvbmYsIHNlY3Rvcik7CiAJaW50IGluY19l
bXB0eV9pbmFjdGl2ZV9saXN0X2ZsYWc7CiAKQEAgLTczOCw4ICs3MzksMTQgQEAgcmFpZDVf
Z2V0X2FjdGl2ZV9zdHJpcGUoc3RydWN0IHI1Y29uZiAqY29uZiwgc2VjdG9yX3Qgc2VjdG9y
LAogCQkJCQkoYXRvbWljX3JlYWQoJmNvbmYtPmFjdGl2ZV9zdHJpcGVzKQogCQkJCQkgPCAo
Y29uZi0+bWF4X25yX3N0cmlwZXMgKiAzIC8gNCkKIAkJCQkJIHx8ICF0ZXN0X2JpdChSNV9J
TkFDVElWRV9CTE9DS0VELAotCQkJCQkJICAgICAgJmNvbmYtPmNhY2hlX3N0YXRlKSksCisJ
CQkJCQkgICAgICAmY29uZi0+Y2FjaGVfc3RhdGUpCisJCQkJCSB8fCAodGVzdF9iaXQoTURf
UkVDT1ZFUllfSU5UUiwKKwkJCQkJCSAgICAgICZtZGRldi0+cmVjb3ZlcnkpCisJCQkJCSAg
ICAgJiYgc3luY19yZXEpKSwKIAkJCQkJKihjb25mLT5oYXNoX2xvY2tzICsgaGFzaCkpOwor
CQkJCWlmICh0ZXN0X2JpdChNRF9SRUNPVkVSWV9JTlRSLCAmbWRkZXYtPnJlY292ZXJ5KQor
CQkJCSAgICAmJiBzeW5jX3JlcSkKKwkJCQkJYnJlYWs7CiAJCQkJY2xlYXJfYml0KFI1X0lO
QUNUSVZFX0JMT0NLRUQsCiAJCQkJCSAgJmNvbmYtPmNhY2hlX3N0YXRlKTsKIAkJCX0gZWxz
ZSB7CkBAIC00NTI3LDcgKzQ1MzQsNyBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfc3RyaXBlX2V4
cGFuc2lvbihzdHJ1Y3QgcjVjb25mICpjb25mLCBzdHJ1Y3Qgc3RyaXBlX2hlYWQgKnNoKQog
CQkJc2VjdG9yX3QgYm4gPSByYWlkNV9jb21wdXRlX2Jsb2NrbnIoc2gsIGksIDEpOwogCQkJ
c2VjdG9yX3QgcyA9IHJhaWQ1X2NvbXB1dGVfc2VjdG9yKGNvbmYsIGJuLCAwLAogCQkJCQkJ
CSAgJmRkX2lkeCwgTlVMTCk7Ci0JCQlzaDIgPSByYWlkNV9nZXRfYWN0aXZlX3N0cmlwZShj
b25mLCBzLCAwLCAxLCAxKTsKKwkJCXNoMiA9IHJhaWQ1X2dldF9hY3RpdmVfc3RyaXBlKGNv
bmYsIHMsIDAsIDAsIDEsIDEpOwogCQkJaWYgKHNoMiA9PSBOVUxMKQogCQkJCS8qIHNvIGZh
ciBvbmx5IHRoZSBlYXJseSBibG9ja3Mgb2YgdGhpcyBzdHJpcGUKIAkJCQkgKiBoYXZlIGJl
ZW4gcmVxdWVzdGVkLiAgV2hlbiBsYXRlciBibG9ja3MKQEAgLTUxNjQsNyArNTE3MSw3IEBA
IHN0YXRpYyB2b2lkIGhhbmRsZV9zdHJpcGUoc3RydWN0IHN0cmlwZV9oZWFkICpzaCkKIAkv
KiBGaW5pc2ggcmVjb25zdHJ1Y3Qgb3BlcmF0aW9ucyBpbml0aWF0ZWQgYnkgdGhlIGV4cGFu
c2lvbiBwcm9jZXNzICovCiAJaWYgKHNoLT5yZWNvbnN0cnVjdF9zdGF0ZSA9PSByZWNvbnN0
cnVjdF9zdGF0ZV9yZXN1bHQpIHsKIAkJc3RydWN0IHN0cmlwZV9oZWFkICpzaF9zcmMKLQkJ
CT0gcmFpZDVfZ2V0X2FjdGl2ZV9zdHJpcGUoY29uZiwgc2gtPnNlY3RvciwgMSwgMSwgMSk7
CisJCQk9IHJhaWQ1X2dldF9hY3RpdmVfc3RyaXBlKGNvbmYsIHNoLT5zZWN0b3IsIDAsIDEs
IDEsIDEpOwogCQlpZiAoc2hfc3JjICYmIHRlc3RfYml0KFNUUklQRV9FWFBBTkRfU09VUkNF
LCAmc2hfc3JjLT5zdGF0ZSkpIHsKIAkJCS8qIHNoIGNhbm5vdCBiZSB3cml0dGVuIHVudGls
IHNoX3NyYyBoYXMgYmVlbiByZWFkLgogCQkJICogc28gYXJyYW5nZSBmb3Igc2ggdG8gYmUg
ZGVsYXllZCBhIGxpdHRsZQpAQCAtNTcwNSw3ICs1NzEyLDcgQEAgc3RhdGljIHZvaWQgbWFr
ZV9kaXNjYXJkX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0IGJpbyAqYmkp
CiAJCURFRklORV9XQUlUKHcpOwogCQlpbnQgZDsKIAlhZ2FpbjoKLQkJc2ggPSByYWlkNV9n
ZXRfYWN0aXZlX3N0cmlwZShjb25mLCBsb2dpY2FsX3NlY3RvciwgMCwgMCwgMCk7CisJCXNo
ID0gcmFpZDVfZ2V0X2FjdGl2ZV9zdHJpcGUoY29uZiwgbG9naWNhbF9zZWN0b3IsIDAsIDAs
IDAsIDApOwogCQlwcmVwYXJlX3RvX3dhaXQoJmNvbmYtPndhaXRfZm9yX292ZXJsYXAsICZ3
LAogCQkJCVRBU0tfVU5JTlRFUlJVUFRJQkxFKTsKIAkJc2V0X2JpdChSNV9PdmVybGFwLCAm
c2gtPmRldltzaC0+cGRfaWR4XS5mbGFncyk7CkBAIC01ODYxLDcgKzU4NjgsNyBAQCBzdGF0
aWMgYm9vbCByYWlkNV9tYWtlX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0
IGJpbyAqIGJpKQogCQkJKHVuc2lnbmVkIGxvbmcgbG9uZyluZXdfc2VjdG9yLAogCQkJKHVu
c2lnbmVkIGxvbmcgbG9uZylsb2dpY2FsX3NlY3Rvcik7CiAKLQkJc2ggPSByYWlkNV9nZXRf
YWN0aXZlX3N0cmlwZShjb25mLCBuZXdfc2VjdG9yLCBwcmV2aW91cywKKwkJc2ggPSByYWlk
NV9nZXRfYWN0aXZlX3N0cmlwZShjb25mLCBuZXdfc2VjdG9yLCBwcmV2aW91cywgMCwKIAkJ
CQkgICAgICAgKGJpLT5iaV9vcGYgJiBSRVFfUkFIRUFEKSwgMCk7CiAJCWlmIChzaCkgewog
CQkJaWYgKHVubGlrZWx5KHByZXZpb3VzKSkgewpAQCAtNjEwMCw3ICs2MTA3LDcgQEAgc3Rh
dGljIHNlY3Rvcl90IHJlc2hhcGVfcmVxdWVzdChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzZWN0
b3JfdCBzZWN0b3JfbnIsIGludCAqc2sKIAlmb3IgKGkgPSAwOyBpIDwgcmVzaGFwZV9zZWN0
b3JzOyBpICs9IFJBSUQ1X1NUUklQRV9TRUNUT1JTKGNvbmYpKSB7CiAJCWludCBqOwogCQlp
bnQgc2tpcHBlZF9kaXNrID0gMDsKLQkJc2ggPSByYWlkNV9nZXRfYWN0aXZlX3N0cmlwZShj
b25mLCBzdHJpcGVfYWRkcitpLCAwLCAwLCAxKTsKKwkJc2ggPSByYWlkNV9nZXRfYWN0aXZl
X3N0cmlwZShjb25mLCBzdHJpcGVfYWRkcitpLCAwLCAwLCAwLCAxKTsKIAkJc2V0X2JpdChT
VFJJUEVfRVhQQU5ESU5HLCAmc2gtPnN0YXRlKTsKIAkJYXRvbWljX2luYygmY29uZi0+cmVz
aGFwZV9zdHJpcGVzKTsKIAkJLyogSWYgYW55IG9mIHRoaXMgc3RyaXBlIGlzIGJleW9uZCB0
aGUgZW5kIG9mIHRoZSBvbGQKQEAgLTYxNDksNyArNjE1Niw3IEBAIHN0YXRpYyBzZWN0b3Jf
dCByZXNoYXBlX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc2VjdG9yX3Qgc2VjdG9y
X25yLCBpbnQgKnNrCiAJaWYgKGxhc3Rfc2VjdG9yID49IG1kZGV2LT5kZXZfc2VjdG9ycykK
IAkJbGFzdF9zZWN0b3IgPSBtZGRldi0+ZGV2X3NlY3RvcnMgLSAxOwogCXdoaWxlIChmaXJz
dF9zZWN0b3IgPD0gbGFzdF9zZWN0b3IpIHsKLQkJc2ggPSByYWlkNV9nZXRfYWN0aXZlX3N0
cmlwZShjb25mLCBmaXJzdF9zZWN0b3IsIDEsIDAsIDEpOworCQlzaCA9IHJhaWQ1X2dldF9h
Y3RpdmVfc3RyaXBlKGNvbmYsIGZpcnN0X3NlY3RvciwgMCwgMSwgMCwgMSk7CiAJCXNldF9i
aXQoU1RSSVBFX0VYUEFORF9TT1VSQ0UsICZzaC0+c3RhdGUpOwogCQlzZXRfYml0KFNUUklQ
RV9IQU5ETEUsICZzaC0+c3RhdGUpOwogCQlyYWlkNV9yZWxlYXNlX3N0cmlwZShzaCk7CkBA
IC02MjY5LDkgKzYyNzYsMTQgQEAgc3RhdGljIGlubGluZSBzZWN0b3JfdCByYWlkNV9zeW5j
X3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc2VjdG9yX3Qgc2VjdG9yX24KIAogCW1k
X2JpdG1hcF9jb25kX2VuZF9zeW5jKG1kZGV2LT5iaXRtYXAsIHNlY3Rvcl9uciwgZmFsc2Up
OwogCi0Jc2ggPSByYWlkNV9nZXRfYWN0aXZlX3N0cmlwZShjb25mLCBzZWN0b3JfbnIsIDAs
IDEsIDApOworCXNoID0gcmFpZDVfZ2V0X2FjdGl2ZV9zdHJpcGUoY29uZiwgc2VjdG9yX25y
LCAxLCAwLCAxLCAwKTsKIAlpZiAoc2ggPT0gTlVMTCkgewotCQlzaCA9IHJhaWQ1X2dldF9h
Y3RpdmVfc3RyaXBlKGNvbmYsIHNlY3Rvcl9uciwgMCwgMCwgMCk7CisJCXNoID0gcmFpZDVf
Z2V0X2FjdGl2ZV9zdHJpcGUoY29uZiwgc2VjdG9yX25yLCAxLCAwLCAwLCAwKTsKKwkJaWYg
KCFzaCAmJiB0ZXN0X2JpdChNRF9SRUNPVkVSWV9JTlRSLCAmbWRkZXYtPnJlY292ZXJ5KSkg
eworCQkJKnNraXBwZWQgPSAxOworCQkJcmV0dXJuIDA7CisJCX0KKwogCQkvKiBtYWtlIHN1
cmUgd2UgZG9uJ3Qgc3dhbXAgdGhlIHN0cmlwZSBjYWNoZSBpZiBzb21lb25lIGVsc2UKIAkJ
ICogaXMgdHJ5aW5nIHRvIGdldCBhY2Nlc3MKIAkJICovCkBAIC02MzM0LDcgKzYzNDYsNyBA
QCBzdGF0aWMgaW50ICByZXRyeV9hbGlnbmVkX3JlYWQoc3RydWN0IHI1Y29uZiAqY29uZiwg
c3RydWN0IGJpbyAqcmFpZF9iaW8sCiAJCQkvKiBhbHJlYWR5IGRvbmUgdGhpcyBzdHJpcGUg
Ki8KIAkJCWNvbnRpbnVlOwogCi0JCXNoID0gcmFpZDVfZ2V0X2FjdGl2ZV9zdHJpcGUoY29u
Ziwgc2VjdG9yLCAwLCAxLCAxKTsKKwkJc2ggPSByYWlkNV9nZXRfYWN0aXZlX3N0cmlwZShj
b25mLCBzZWN0b3IsIDAsIDAsIDEsIDEpOwogCiAJCWlmICghc2gpIHsKIAkJCS8qIGZhaWxl
ZCB0byBnZXQgYSBzdHJpcGUgLSBtdXN0IHdhaXQgKi8KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bWQvcmFpZDUuaCBiL2RyaXZlcnMvbWQvcmFpZDUuaAppbmRleCA1YzA1YWNmLi5kOWVhYjQ2
IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL3JhaWQ1LmgKKysrIGIvZHJpdmVycy9tZC9yYWlk
NS5oCkBAIC04MDYsNyArODA2LDcgQEAgZXh0ZXJuIHNlY3Rvcl90IHJhaWQ1X2NvbXB1dGVf
c2VjdG9yKHN0cnVjdCByNWNvbmYgKmNvbmYsIHNlY3Rvcl90IHJfc2VjdG9yLAogCQkJCSAg
ICAgaW50IHByZXZpb3VzLCBpbnQgKmRkX2lkeCwKIAkJCQkgICAgIHN0cnVjdCBzdHJpcGVf
aGVhZCAqc2gpOwogZXh0ZXJuIHN0cnVjdCBzdHJpcGVfaGVhZCAqCi1yYWlkNV9nZXRfYWN0
aXZlX3N0cmlwZShzdHJ1Y3QgcjVjb25mICpjb25mLCBzZWN0b3JfdCBzZWN0b3IsCityYWlk
NV9nZXRfYWN0aXZlX3N0cmlwZShzdHJ1Y3QgcjVjb25mICpjb25mLCBzZWN0b3JfdCBzZWN0
b3IsIGludCBzeW5jX3JlcSwKIAkJCWludCBwcmV2aW91cywgaW50IG5vYmxvY2ssIGludCBu
b3F1aWVzY2UpOwogZXh0ZXJuIGludCByYWlkNV9jYWxjX2RlZ3JhZGVkKHN0cnVjdCByNWNv
bmYgKmNvbmYpOwogZXh0ZXJuIGludCByNWNfam91cm5hbF9tb2RlX3NldChzdHJ1Y3QgbWRk
ZXYgKm1kZGV2LCBpbnQgam91cm5hbF9tb2RlKTsK
--------------93515907419EC43A70E50E97--
