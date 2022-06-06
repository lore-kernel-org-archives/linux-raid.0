Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13D3C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 08:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiFFIkP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 04:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbiFFIjf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 04:39:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAB5A344E9
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 01:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654504766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uiq7pIh9MXD/woODXhQ8nOCsKJbuQvRsmi9PtCjRWOw=;
        b=DOjRSJBGGbgE9jdxNtL5PnG8CvvcFM8+F9lcIVRmfEf8zzCJa5NrXAC6n3yA6oGsSvf5Rr
        tuynqYGkV2IzOGeIl43DvBTbU6TmHlpsaTKy8HYUPw7Qb6DwPnObQG4fqrB7OcqQyLTh/N
        9AS2zRUjc7U3edUxNEvvHDO/pzuCLBs=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-FYJSYaRLP-ihWX2iD1okgA-1; Mon, 06 Jun 2022 04:39:15 -0400
X-MC-Unique: FYJSYaRLP-ihWX2iD1okgA-1
Received: by mail-oo1-f72.google.com with SMTP id n129-20020a4a4087000000b0041b543739dcso1598101ooa.9
        for <linux-raid@vger.kernel.org>; Mon, 06 Jun 2022 01:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uiq7pIh9MXD/woODXhQ8nOCsKJbuQvRsmi9PtCjRWOw=;
        b=zMAyhjt38bJ1EZwy/gknZjl5uAR22BxZYOapzdwLw3Z8cqkXKsI7htQpk+O+539AVN
         1s8CZnySX8QVNG/kdtkx9SseGE8iLlS7Jh/Gnl0JBBtkHO/d1GANs5ZVm7vFmA8hmLa5
         1ckGwKbBoCrMsiP3XTSr8Lu72/ffHqnjTXoljmmyvJbnpB1CwoZLx4HeTeLbiLlz6RY8
         J9LrpMBQBcEzDLou+s7GyYqOlq6MdMLg3L1L/PpyNT4+cvSxO1n7qDYUCXkwSrY9sv5V
         AaRCBoTQfjbPKPjrrwnxC819iclzl4/R/97QjjFsONXTkG6LlhnqwmJtV6lba5fGXpFO
         L5EQ==
X-Gm-Message-State: AOAM532IAuAIpQDikHW+OxHEY9LvPRJ5W1cxqq4Vfvi3Vi3djm8R9nhR
        yuXoYOv3d6rJ6KXTnvZ6cHnwCpmSlcljwuJaPW0gLIuh3hzdrfDXkrQ8sEjcngCihveF561XAAx
        BhUF8RBe25/eCuEftsV6IBOtYm/5Qd/NkmKxJxA==
X-Received: by 2002:a05:6830:1294:b0:60b:a3c:4eb1 with SMTP id z20-20020a056830129400b0060b0a3c4eb1mr9519054otp.114.1654504755222;
        Mon, 06 Jun 2022 01:39:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMYenFIb7t1T26HwIeBeLdYr6GyDpL+z5AhRwU6XFC8sTKnH0CBuG6Th2P0jLIIHDq0iMxlljj5aEV4zJRIwM=
X-Received: by 2002:a05:6830:1294:b0:60b:a3c:4eb1 with SMTP id
 z20-20020a056830129400b0060b0a3c4eb1mr9519041otp.114.1654504754884; Mon, 06
 Jun 2022 01:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
 <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com> <04d66d44-dc18-55f7-b044-defcbcf88fe0@linux.dev>
In-Reply-To: <04d66d44-dc18-55f7-b044-defcbcf88fe0@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 6 Jun 2022 16:39:03 +0800
Message-ID: <CALTww2_f5727NmOQw2=jiqg7DKSyYvEEMqvW_d_9UU0XT6n=4Q@mail.gmail.com>
Subject: Re: [PATCH] md: only unlock mddev from action_store
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Logan Gunthorpe <logang@deltatee.com>, Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 6, 2022 at 11:08 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> >> +    }
> > Maybe instead of the ugly boolean argument we could pull
> > md_unregister_thread() into all the callers and explicitly unlock in the
> > single call site that needs it?
>
> Sounds good, let me revert previous commit then pull it.
>

Hi all

Now md_reap_sync_thread is called by __md_stop_writes, action_store
and md_check_recovery.
If we move md_unregister_thread out of md_reap_sync_thread and unlock
reconfig_mutex before
calling md_unregister_thread, it means we break the atomic action for
these three functions mentioned
above. Not sure if it can introduce other problems, especially for the
change of md_check_recovery.

How about suspend I/O when changing the sync action? It should not
hurt the performance, because
it only interrupts the sync action and flush the in memory stripes.
For this way, it needs to revert
7e6ba434cc60 (md: don't unregister sync_thread with reconfig_mutex
held) and changes like this:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce9d2845d3ac..af28cdeaf7e1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4827,12 +4827,14 @@ action_store(struct mddev *mddev, const char
*page, size_t len)
                        clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
                if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
                    mddev_lock(mddev) == 0) {
+                       mddev_suspend(mddev);
                        if (work_pending(&mddev->del_work))
                                flush_workqueue(md_misc_wq);
                        if (mddev->sync_thread) {
                                set_bit(MD_RECOVERY_INTR, &mddev->recovery);
                                md_reap_sync_thread(mddev);
                        }
+                       mddev_resume(mddev);
                        mddev_unlock(mddev);
                }
        } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))

mddev_suspend can stop the I/O and the superblock can be updated too. Because
MD_ALLOW_SB_UPDATE is set. So raid5d can go on handling stripes.

Best Regards
Xiao

