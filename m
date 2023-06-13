Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82B6EB64D0
	for <linux-raid@archiver.kernel.org>; Tue, 13 Jun 2023 14:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241125AbjFMOoF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Jun 2023 10:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbjFMOoE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Jun 2023 10:44:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B0172B
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 07:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686667404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCAk+GrfYv2LlZeL9R4DyIt9sUEULTjaibnxzpvOXzU=;
        b=UrSyi06Ro7IWOqWp9UL7C/Y9Bm/8nLjtV/Q+j8sct40eVtfLWm+OKAWhtiVmd/TVe6+1al
        J/zYY9rAV2kusCEVIPNqLN2dBZI6Nmiyxzoo+P0D+29M0fhs+pLocEYX+9aoDNOrIJrreo
        FiJagTqxcTiUBqLj7wIq6mk2OhSYMzo=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-nANRJOdUMLmbFzbeUmN8Zg-1; Tue, 13 Jun 2023 10:43:23 -0400
X-MC-Unique: nANRJOdUMLmbFzbeUmN8Zg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-25c07cb3d93so961270a91.1
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 07:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686667401; x=1689259401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qCAk+GrfYv2LlZeL9R4DyIt9sUEULTjaibnxzpvOXzU=;
        b=j8PT1vdw/1E+LVBq+mZf9LMVpU8mmydnvqDPwYPPfOSbJdIe/pHAeZdRT7IrvX5xEJ
         0+zZlLgsRe/HL6wbF3CitqX81zIqZQwsddsrHe09AjdCygyi/dPAeVF2jXbwu0BeMeEr
         poP5hyW7cN2pUhBU0mx/Dj5vb2im1xeHRHYX9Z3fvGsAGD01xxfyx6dJ/HhqsXIizNbp
         mMdmSrj7fAowbkCDqveO0hXbwsd+Z3cmtBhqHIMQvc/0xyqEYnzysRTedibHWLKiyjxT
         lGn9G05d+/9IcLF6ut8Ops/4S32FBqc7o8M23OfzIbA01GiOMsYZ1bBhEZs82gempzLr
         atHg==
X-Gm-Message-State: AC+VfDxN16uG3MKFRkvADpH0YJdkPSXSGdmtWX87UaPtrDfeVIj6tOsq
        DwP3YGhAJDExdmEm/WPGZRRtfoxZepQ8C+VNPeWlgNoRtSe7Wvgp3Qe2iUBr/x9xtFDyFz2Ik4I
        VWiOyL9gCTZ7VoWBmL/8RCQ==
X-Received: by 2002:a17:90b:364c:b0:25b:e311:14b9 with SMTP id nh12-20020a17090b364c00b0025be31114b9mr5583547pjb.29.1686667401474;
        Tue, 13 Jun 2023 07:43:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7pzDK/dX7LQKc/Z1gmMKhXdFjH/ZJbgm6TymQSc9JNchoVhSaDhMC+a+dsmHcntgyeQR8+DA==
X-Received: by 2002:a17:90b:364c:b0:25b:e311:14b9 with SMTP id nh12-20020a17090b364c00b0025be31114b9mr5583529pjb.29.1686667401155;
        Tue, 13 Jun 2023 07:43:21 -0700 (PDT)
Received: from [10.72.13.126] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s23-20020a17090a1c1700b0025be4c602d5sm4095009pjs.38.2023.06.13.07.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 07:43:20 -0700 (PDT)
Message-ID: <c96f2604-e1ef-c3ad-9d15-5e0efa5f222b@redhat.com>
Date:   Tue, 13 Jun 2023 22:43:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [dm-devel] [PATCH -next v2 3/6] md: add a mutex to synchronize
 idle and frozen in action_store()
To:     Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
        agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org
Cc:     yi.zhang@huawei.com, yangerkun@huawei.com,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        yukuai3@huawei.com
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-4-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-4-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


在 2023/5/29 下午9:20, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> Currently, for idle and frozen, action_store will hold 'reconfig_mutex'
> and call md_reap_sync_thread() to stop sync thread, however, this will
> cause deadlock (explained in the next patch). In order to fix the
> problem, following patch will release 'reconfig_mutex' and wait on
> 'resync_wait', like md_set_readonly() and do_md_stop() does.
>
> Consider that action_store() will set/clear 'MD_RECOVERY_FROZEN'
> unconditionally, which might cause unexpected problems, for example,
> frozen just set 'MD_RECOVERY_FROZEN' and is still in progress, while
> 'idle' clear 'MD_RECOVERY_FROZEN' and new sync thread is started, which
> might starve in progress frozen. A mutex is added to synchronize idle
> and frozen from action_store().
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 5 +++++
>   drivers/md/md.h | 3 +++
>   2 files changed, 8 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 23e8e7eae062..63a993b52cd7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -644,6 +644,7 @@ void mddev_init(struct mddev *mddev)
>   	mutex_init(&mddev->open_mutex);
>   	mutex_init(&mddev->reconfig_mutex);
>   	mutex_init(&mddev->delete_mutex);
> +	mutex_init(&mddev->sync_mutex);
>   	mutex_init(&mddev->bitmap_info.mutex);
>   	INIT_LIST_HEAD(&mddev->disks);
>   	INIT_LIST_HEAD(&mddev->all_mddevs);
> @@ -4785,14 +4786,18 @@ static void stop_sync_thread(struct mddev *mddev)
>   
>   static void idle_sync_thread(struct mddev *mddev)
>   {
> +	mutex_lock(&mddev->sync_mutex);
>   	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   	stop_sync_thread(mddev);
> +	mutex_unlock(&mddev->sync_mutex);
>   }
>   
>   static void frozen_sync_thread(struct mddev *mddev)
>   {
> +	mutex_init(&mddev->delete_mutex);


typo error? It should be mutex_lock(&mddev->sync_mutex); ?

Regards

Xiao

>   	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   	stop_sync_thread(mddev);
> +	mutex_unlock(&mddev->sync_mutex);
>   }
>   
>   static ssize_t
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index bfd2306bc750..2fa903de5bd0 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -537,6 +537,9 @@ struct mddev {
>   	/* Protect the deleting list */
>   	struct mutex			delete_mutex;
>   
> +	/* Used to synchronize idle and frozen for action_store() */
> +	struct mutex			sync_mutex;
> +
>   	bool	has_superblocks:1;
>   	bool	fail_last_dev:1;
>   	bool	serialize_policy:1;

