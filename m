Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B50C433ED
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 02:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E8D96141C
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 02:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbhDWChD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Apr 2021 22:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236080AbhDWChD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Apr 2021 22:37:03 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D330DC061574
        for <linux-raid@vger.kernel.org>; Thu, 22 Apr 2021 19:36:27 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y62so456568pfg.4
        for <linux-raid@vger.kernel.org>; Thu, 22 Apr 2021 19:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ekDaYesL/plH4cN6yFVYdk6vPFliuK46/yvcxvyFcKo=;
        b=NH3pN+cl3WMGqkdnkEvWnDpQYwLeYbr5yygSuJ3pNb5YPMvVz+HWkNkXNgbl3Drjl1
         XBVoIQsIEz8IcOt7ryrecQ+fGEs5AQw2HGUW8TzWXq7z3b+60h8nSQUbzXI5JqW/t+b+
         0QnxX6CZReB1oSuY79gjHZTRpAXW553Bsj0ae9BhBiw8XM46LJs6+UKnxsjk9B1/wdve
         p6DW9BcFFCBgJxuJsJijXSod1dJdtPf3CMa7mOyKXlZhuU4jEbRNuRdbKsqg8Cl4Bgbp
         ZvxFuaN0Wu4YBSUmHf3vcfCXVH6LhYMY1MNR1ytj/AKrnNisP6e1r1AtO2DMI+UDDFJH
         2GYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ekDaYesL/plH4cN6yFVYdk6vPFliuK46/yvcxvyFcKo=;
        b=BGA27E/T46zX3kBxRJ0BnoT0B+OgxjZg8XfXsEpDALv3D3dBarE2t5kymNVOUYyWWS
         t9YjXOGuDOWvq9sD3jAvH7C5aReL5yAJzEBgmjzfHOp238xVE0sS4q4G0C8p4qFcHuT5
         cnKCYYjGFcM3uE7Iv2Yk16l/STzUqHVlJBd46y1qOCwL35gj1a6clfK6Nn1jwvr+y7Lr
         SWMGH2tzoDWgfWpwD5BbvsBJytThfOWCCoFiJAgNNJwABsm0jJLGvwg97uUhqnpQbO2T
         rORMYgQAuHYPkuAKv8qGJk88QPtG+9G6DX+YxjcFqAqM5XsQVU3qNJNWCoSFxg6T77b0
         1BFw==
X-Gm-Message-State: AOAM530y+KDCzk9FDopj/o1L9Sj+AoSF4xyhgehGFbuHbbxOLT1MgUVr
        7d33ScjNThoobPiDZUQzIlrOfTiogHmAdilLihE=
X-Google-Smtp-Source: ABdhPJwX0lCz4JY4IBsfQusIXV+TaQh3RL05itgVsO58dgjFbVgg7acNgHsBO+TJXgMnRQFeAzZNCA==
X-Received: by 2002:a63:4403:: with SMTP id r3mr1717338pga.60.1619145387344;
        Thu, 22 Apr 2021 19:36:27 -0700 (PDT)
Received: from [10.6.0.126] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id f18sm3362764pfk.144.2021.04.22.19.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 19:36:26 -0700 (PDT)
Subject: Re: PROBLEM: double fault in md_end_io
To:     =?UTF-8?Q?Pawe=c5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>,
        song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <ddbacea2-13d9-28ca-7ba2-50b581ac658a@gmail.com>
Date:   Fri, 23 Apr 2021 10:36:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2021/4/10 上午5:40, Paweł Wiejacha wrote:
> Hello,
>
> Two of my machines constantly crash with a double fault like this:
>
> 1146  <0>[33685.629591] traps: PANIC: double fault, error_code: 0x0
> 1147  <4>[33685.629593] double fault: 0000 [#1] SMP NOPTI
> 1148  <4>[33685.629594] CPU: 10 PID: 2118287 Comm: kworker/10:0
> Tainted: P           OE     5.11.8-051108-generic #202103200636
> 1149  <4>[33685.629595] Hardware name: ASUSTeK COMPUTER INC. KRPG-U8
> Series/KRPG-U8 Series, BIOS 4201 09/25/2020
> 1150  <4>[33685.629595] Workqueue: xfs-conv/md12 xfs_end_io [xfs]
> 1151  <4>[33685.629596] RIP: 0010:__slab_free+0x23/0x340
> 1152  <4>[33685.629597] Code: 4c fe ff ff 0f 1f 00 0f 1f 44 00 00 55
> 48 89 e5 41 57 49 89 cf 41 56 49 89 fe 41 55 41 54 49 89 f4 53 48 83
> e4 f0 48 83 ec 70 <48> 89 54 24 28 0f 1f 44 00 00 41 8b 46 28 4d 8b 6c
> 24 20 49 8b 5c
> 1153  <4>[33685.629598] RSP: 0018:ffffa9bc00848fa0 EFLAGS: 00010086
> 1154  <4>[33685.629599] RAX: ffff94c04d8b10a0 RBX: ffff94437a34a880
> RCX: ffff94437a34a880
> 1155  <4>[33685.629599] RDX: ffff94437a34a880 RSI: ffffcec745e8d280
> RDI: ffff944300043b00
> 1156  <4>[33685.629599] RBP: ffffa9bc00849040 R08: 0000000000000001
> R09: ffffffff82a5d6de
> 1157  <4>[33685.629600] R10: 0000000000000001 R11: 000000009c109000
> R12: ffffcec745e8d280
> 1158  <4>[33685.629600] R13: ffff944300043b00 R14: ffff944300043b00
> R15: ffff94437a34a880
> 1159  <4>[33685.629601] FS:  0000000000000000(0000)
> GS:ffff94c04d880000(0000) knlGS:0000000000000000
> 1160  <4>[33685.629601] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 1161  <4>[33685.629602] CR2: ffffa9bc00848f98 CR3: 000000014d04e000
> CR4: 0000000000350ee0
> 1162  <4>[33685.629602] Call Trace:
> 1163  <4>[33685.629603]  <IRQ>
> 1164  <4>[33685.629603]  ? kfree+0x3bc/0x3e0
> 1165  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
> 1166  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
> 1167  <4>[33685.629604]  ? mempool_free+0x2f/0x80
> 1168  <4>[33685.629604]  ? md_end_io+0x4a/0x70
> 1169  <4>[33685.629604]  ? bio_endio+0xdc/0x130
> 1170  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
> 1171  <4>[33685.629605]  ? md_end_io+0x5c/0x70
> 1172  <4>[33685.629605]  ? bio_endio+0xdc/0x130
> 1173  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
> 1174  <4>[33685.629606]  ? md_end_io+0x5c/0x70
> 1175  <4>[33685.629606]  ? bio_endio+0xdc/0x130
> 1176  <4>[33685.629606]  ? bio_chain_endio+0x2d/0x40
> 1177  <4>[33685.629607]  ? md_end_io+0x5c/0x70
> ... repeated ...
> 1436  <4>[33685.629677]  ? bio_endio+0xdc/0x130
> 1437  <4>[33685.629677]  ? bio_chain_endio+0x2d/0x40
> 1438  <4>[33685.629677]  ? md_end_io+0x5c/0x70
> 1439  <4>[33685.629677]  ? bio_endio+0xdc/0x130
> 1440  <4>[33685.629678]  ? bio_chain_endio+0x2d/0x40
> 1441  <4>[33685.629678]  ? md_
> 1442  <4>[33685.629679] Lost 357 message(s)!
>
> This happens on:
> 5.11.8-051108-generic #202103200636 SMP Sat Mar 20 11:17:32 UTC 2021
> and on 5.8.0-44-generic #50~20.04.1-Ubuntu
> (https://changelogs.ubuntu.com/changelogs/pool/main/l/linux/linux_5.8.0-44.50/changelog)
> which contains backported
> https://github.com/torvalds/linux/commit/41d2d848e5c09209bdb57ff9c0ca34075e22783d
> ("md: improve io stats accounting").
> The 5.8.18-050818-generic #202011011237 SMP Sun Nov 1 12:40:15 UTC
> 2020 which does not contain above suspected change does not crash.
>
> If there's a better way/place to report this bug just let me know. If
> not, here are steps to reproduce:
>
> 1. Create a RAID 0 device using three Micron_9300_MTFDHAL7T6TDP disks.
> mdadm --create --verbose /dev/md12 --level=stripe --raid-devices=3
> /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
>
> 2. Setup xfs on it:
> mkfs.xfs /dev/md12 and mount it
>
> 3. Write to a file on this filesystem:
> while true; do rm -rf /mnt/md12/crash* ; for i in `seq 8`; do dd
> if=/dev/zero of=/mnt/md12/crash$i bs=32K count=50000000 & done; wait;
> done
> Wait for a crash (usually less than 20 min).
>
> I couldn't reproduce it with a single dd process (maybe I have to wait
> a little longer), but a single cat
> /very/large/file/on/cephfs/over100GbE > /mnt/md12/crash is enough for
> this double fault to occur.

I guess it is related with bio split, if raid0_make_request calls 
bio_chain for the split bio, then
it's bi_end_io is changed to bio_chain_endio. Could you try this?

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -489,7 +489,7 @@ static blk_qc_t md_submit_bio(struct bio *bio)
                 return BLK_QC_T_NONE;
         }

-       if (bio->bi_end_io != md_end_io) {
+       if (bio->bi_end_io != md_end_io && bio->bi_end_io != 
bio_chain_endio) {

If the above works, then we could miss the statistics of split bio from 
blk_queue_split which is
called before hijack bi_end_io, so we may need to move blk_queue_split 
after hijack bi_end_io.

Thanks,
Guoqing
