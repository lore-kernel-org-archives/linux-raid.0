Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28231C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 16:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241367AbhLIQ4u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 11:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbhLIQ4t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 11:56:49 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CB0C061746
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 08:53:16 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so7419501pja.1
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 08:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=NSzEs+Vry2enve4YPU36JraMXUbzfIr1IxGc+x37aM0=;
        b=GQT0ucrb48eudbKki8Y799/WAD/ds+rfkxq3VbMjh3TcPkHczMpOYwjcbMavMs5jka
         F62TAVKQe+8VMo+/d8Jm5dEJ1wmGQNViBeomuuGgZNSnzcqgNMvWjsoXRc/iEATbBCcG
         HslMqSZ4xb7kMfBkELjZs8S8X8Dx7YPQTKLzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NSzEs+Vry2enve4YPU36JraMXUbzfIr1IxGc+x37aM0=;
        b=JS+F4qrqDlhbhJch4/dOeoMgPgd5U70/0BY6xbp9IyOnxQS4wYLs5XsLgRweKbfB97
         RsGStNNf3QseoQvdnNdq2z/cyK5AubIPNPGOR8lYMRlqmcmC0k1Tt9iplnrMJ8a4amzV
         pCrB1papAJpcpvjRVe8X0WFVLI+KAzEvBT57gpXCMCut2L4LGzo17kZLDiTRjO+8diZC
         GtZN6gHAq/PCkpFK1/qdTQi3CMGTTVhiJ4Tm2/NBqgSvf5S/ZrEWwL4Erd8CtPSpw190
         0U+Q47V66uVCigRo/9EUI6y15cBFNIYi0RQEtRQPwmb92VEcu7cHAKtQ4fbHrvEsFL7l
         QRwA==
X-Gm-Message-State: AOAM5331w2He+lKAUS1R/kw+fFJbPmhp8y/q+2va0IY793Yh+Lo9k5bM
        v3xTHjRFnt3iaKGVQSRYGdClAw==
X-Google-Smtp-Source: ABdhPJyALqx5Mr5ewujBuk6VPw3eQg3R51/OF3SIbzDD61/ifqo6b0Ig1jtl1eFsBd/1E6nyzUcByQ==
X-Received: by 2002:a17:902:c7c4:b0:141:deb4:1b2f with SMTP id r4-20020a170902c7c400b00141deb41b2fmr68351832pla.44.1639068795635;
        Thu, 09 Dec 2021 08:53:15 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id q17sm259311pfu.117.2021.12.09.08.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 08:53:15 -0800 (PST)
Message-ID: <9fb2e648-9a6e-c4c0-4fe9-3e2a92ecd8d6@digitalocean.com>
Date:   Thu, 9 Dec 2021 09:53:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
 <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW7=r4AmCqG3M0hU=fps6a-Zu9KF_RnyNf815d=43wTv5A@mail.gmail.com>
 <f8c2a2bc-a885-8254-2b39-fc0c969ac70d@digitalocean.com>
 <CAPhsuW54EJOfAXrE-zVie561n+aF-+jvQz1152rqj=kU5Fk5ug@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW54EJOfAXrE-zVie561n+aF-+jvQz1152rqj=kU5Fk5ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 11/18/21 9:07 PM, Song Liu wrote:
> On Thu, Nov 11, 2021 at 10:09 PM Vishal Verma <vverma@digitalocean.com> wrote:
>> Yes, with raid10 the task hung happened when doing write IO using FIO where FIO just gets stuck  after like 30s or so and no I/O happens afterwards.
>> This was on a test nvme based raid10: (tried with both io_uring and aio, same issue)
>>
>> [ 1818.677686] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [ 1818.685512] task:fio             state:D stack:    0 pid:14314 ppid:     1 flags:0x00020004
>> [ 1818.685516] Call Trace:
>> [ 1818.685519]  __schedule+0x295/0x840
>> [ 1818.685525]  ? wbt_cleanup_cb+0x20/0x20
>> [ 1818.685528]  schedule+0x4e/0xb0
>> [ 1818.685529]  io_schedule+0x3f/0x70
>> [ 1818.685531]  rq_qos_wait+0xb9/0x130
>> [ 1818.685535]  ? sysv68_partition+0x280/0x280
>> [ 1818.685537]  ? wbt_cleanup_cb+0x20/0x20
>> [ 1818.685538]  wbt_wait+0x92/0xc0
>> [ 1818.685539]  __rq_qos_throttle+0x25/0x40
>> [ 1818.685541]  blk_mq_submit_bio+0xc6/0x5d0
>> [ 1818.685544]  ? submit_bio_checks+0x39e/0x5f0
>> [ 1818.685547]  __submit_bio+0x1bc/0x1d0
>> [ 1818.685549]  submit_bio_noacct+0x256/0x2a0
>> [ 1818.685550]  ? bio_associate_blkg+0x29/0x70
>> [ 1818.685553]  0xffffffffc028d38a
>> [ 1818.685555]  blk_flush_plug+0xc3/0x130
>> [ 1818.685558]  blk_finish_plug+0x26/0x40
>> [ 1818.685560]  blkdev_write_iter+0xf8/0x160
>> [ 1818.685561]  io_write+0x153/0x2e0
>> [ 1818.685564]  ? blk_mq_put_tags+0x1d/0x20
>> [ 1818.685566]  ? blk_mq_end_request_batch+0x295/0x2e0
>> [ 1818.685568]  ? sysvec_apic_timer_interrupt+0x46/0x80
>> [ 1818.685570]  io_issue_sqe+0x579/0x1990
>> [ 1818.685571]  ? io_req_prep+0x6a9/0xe60
>> [ 1818.685573]  ? __fget_files+0x56/0x80
>> [ 1818.685576]  ? fget+0x2a/0x30
>> [ 1818.685577]  io_submit_sqes+0x28c/0x930
>> [ 1818.685578]  ? __io_submit_flush_completions+0xdc/0x150
>> [ 1818.685580]  ? ctx_flush_and_put+0x4b/0x70
>> [ 1818.685581]  __x64_sys_io_uring_enter+0x1db/0x8e0
>> [ 1818.685583]  ? exit_to_user_mode_prepare+0x3e/0x1e0
>> [ 1818.685586]  ? exit_to_user_mode_prepare+0x3e/0x1e0
>> [ 1818.685588]  do_syscall_64+0x38/0x90
>> [ 1818.685591]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [ 1818.685593] RIP: 0033:0x7f8a41c1889d
>> [ 1818.685594] RSP: 002b:00007ffe390d5af8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>> [ 1818.685596] RAX: ffffffffffffffda RBX: 00007ffe390d5b20 RCX: 00007f8a41c1889d
>> [ 1818.685597] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000006
>> [ 1818.685597] RBP: 000055de073b6ef0 R08: 0000000000000000 R09: 0000000000000000
>> [ 1818.685598] R10: 0000000000000001 R11: 0000000000000246 R12: 00007f8a38400000
>> [ 1818.685599] R13: 0000000000000001 R14: 0000000000875bc1 R15: 0000000000000000
>>
>> For raid456, running into this as soon as I try to create a raid5 volume:
>>
>> [ 5338.620661] Buffer I/O error on dev md5, logical block 0, async page read
>> [ 5338.627457] Buffer I/O error on dev md5, logical block 0, async page read
>> [ 5338.634250] Buffer I/O error on dev md5, logical block 0, async page read
>> [ 5338.641043] Buffer I/O error on dev md5, logical block 0, async page read
>> [ 5338.647836] Buffer I/O error on dev md5, logical block 0, async page read
>> [ 5338.654632] Buffer I/O error on dev md5, logical block 0, async page read
>> [ 5338.661424] Dev md5: unable to read RDB block 0
>> [ 5338.665957] Buffer I/O error on dev md5, logical block 0, async page read
>> [ 5338.672746] Buffer I/O error on dev md5, logical block 0, async page read
>> [ 5338.679540] Buffer I/O error on dev md5, logical block 3, async page read
> I am sorry that I haven't got time to look into this, and I will be on
> vacation again from
> tomorrow. If you make progress, please share your finding and/or
> updated version.
> I will try to look into this after Thanksgiving.
>
> Song
>
> Hi Song,
> Did you get chance to look into this? It looks like I am bit stuck here. The other option I am thinking is if we just add a flag for enabling nowait and enable it by default for raid1?
>
> Thanks,
> Vishal
