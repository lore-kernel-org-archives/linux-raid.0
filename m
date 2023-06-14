Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D0FEB64D9
	for <linux-raid@archiver.kernel.org>; Wed, 14 Jun 2023 07:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243451AbjFNHYL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243325AbjFNHX1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Jun 2023 03:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7C72D5F
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 00:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686727255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Cv1JzRA0ITaFwqMsVLtSdeb5FcnnDYorlxptC0NsHg=;
        b=EjuY04NHRWoyaFWd4ReJSsXq7MZ9fn/q15GBL+s9WKqaD7B0qveFp+2NyNsX1MMTG1qrFV
        9583DOACwZ6bgYuVNSU0CAkJ4hQa/PwyjpcYhvdIhK06DjlJldJaKVXnJBEBL4B7evn0Ga
        zDUUX70vHlQhUxtjLVgHom9Ol7F3E+o=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-ttOukrZmOFK6yc6zNtTljw-1; Wed, 14 Jun 2023 03:20:53 -0400
X-MC-Unique: ttOukrZmOFK6yc6zNtTljw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-53f44c2566dso3079631a12.2
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 00:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727252; x=1689319252;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Cv1JzRA0ITaFwqMsVLtSdeb5FcnnDYorlxptC0NsHg=;
        b=Jdo8J6W7paOC3056Ac7H3RHwkceU0Fjt7WqDr6Chs+CFiaDxUB/mSpoZD5qX4MELTf
         OrnH2VhP78kNGZ9MMv6+BFJ9o9x+gYowJ9Xdc2oKQngGWXKJrrLyqdlo1QrRLl/JpnQ5
         2XQOHtc0HLQaRs4+/7uK1EmWiPrTe7yfhpe8eoQTH+CQqTUzIKZ2HNjDvH8RTCzK0j+j
         zqWn5UOlWGSXggxhZe6iUHF9v7eKiqfV8aJ5GfiS2wL2I6oMCU3hq3r06eBJdrVweNx/
         5VTsA65HOZM/8XMnMlwpZsqBDO/4hSjVZTF6+SUPBxkBqbRkQzFvusPAUMxFaYt3CnGo
         +WKw==
X-Gm-Message-State: AC+VfDyP6vy8k6APPv+C9nNymrP8QQyoW0a6WQlv5eND7BIRR9foADH4
        lv8NpadfhN7DXWf0FfvKm8r+6f8MziMFHTJjsGp4NN6+CkfyTzkWM9UjNeFlB7SbvMzTpVDJkxV
        OP4MFirCCpTyejgnIMpZ9IA==
X-Received: by 2002:a17:903:2347:b0:1b1:99c9:8ce1 with SMTP id c7-20020a170903234700b001b199c98ce1mr11789018plh.51.1686727252669;
        Wed, 14 Jun 2023 00:20:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5GCfs2iEd+UlGYv0S1z3ZGoD/fIDkPq52+kCuyNgIKUbm8u8+z+d39yf6mgV5s26EGgf7Cfw==
X-Received: by 2002:a17:903:2347:b0:1b1:99c9:8ce1 with SMTP id c7-20020a170903234700b001b199c98ce1mr11789010plh.51.1686727252401;
        Wed, 14 Jun 2023 00:20:52 -0700 (PDT)
Received: from [10.72.13.126] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w16-20020a170902a71000b001b061dcdb6bsm11447933plq.28.2023.06.14.00.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 00:20:52 -0700 (PDT)
Message-ID: <79c170e2-35d9-5671-7b3d-377750c140bb@redhat.com>
Date:   Wed, 14 Jun 2023 15:20:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH -next v2 5/6] md: wake up 'resync_wait' at last in
 md_reap_sync_thread()
To:     Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
        agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-6-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-6-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


在 2023/5/29 下午9:20, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> md_reap_sync_thread() is just replaced with wait_event(resync_wait, ...)
> from action_store(), just make sure action_store() will still wait for
> everything to be done in md_reap_sync_thread().
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7912de0e4d12..f90226e6ddf8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9531,7 +9531,6 @@ void md_reap_sync_thread(struct mddev *mddev)
>   	if (mddev_is_clustered(mddev) && is_reshaped
>   				      && !test_bit(MD_CLOSING, &mddev->flags))
>   		md_cluster_ops->update_size(mddev, old_dev_sectors);
> -	wake_up(&resync_wait);
>   	/* flag recovery needed just to double check */
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	sysfs_notify_dirent_safe(mddev->sysfs_completed);
> @@ -9539,6 +9538,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>   	md_new_event();
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
> +	wake_up(&resync_wait);
>   }
>   EXPORT_SYMBOL(md_reap_sync_thread);
>   


Reviewd-by: Xiao Ni <xni@redhat.com>

