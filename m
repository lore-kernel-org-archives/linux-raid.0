Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEC9CCA47E
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 09:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiFFJhE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 05:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiFFJhD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 05:37:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 404EB1BF836
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 02:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654508207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lV6kcTnhGR556qyt4YTw59vD4ZcwnmqKPUhkQyzvMZc=;
        b=a+iyiNYm9wR4PA+F4YnCwOUBKDeXLFQbBWxmwJICs4dxvBKKVgDIKUeFBH6n9Iq19JHFvB
        T+79JvAERcowzNSy8LpMt4Ros+la7iqVecjUvC/0k8u0sCJaUalGSnbRKNhcT4nDDRh/eY
        24d3+be1oFh8GWXcyz6cMTIz5DhGsUU=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-ErheDWblNzW0AMNmGeiGjQ-1; Mon, 06 Jun 2022 05:36:44 -0400
X-MC-Unique: ErheDWblNzW0AMNmGeiGjQ-1
Received: by mail-ot1-f70.google.com with SMTP id f89-20020a9d2c62000000b0060be998f055so1968987otb.10
        for <linux-raid@vger.kernel.org>; Mon, 06 Jun 2022 02:36:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lV6kcTnhGR556qyt4YTw59vD4ZcwnmqKPUhkQyzvMZc=;
        b=IymlNSVJ5Jx9l52lYcviDZh/G2M6K8qHBlX4oRUpY3kMl0Jmx7MqUY+lZqNyiIFZaY
         eWMksV8OUQB7Nt8mB7rM7LCI1fWS2ELx5B0Wy0/p6/2hwyHHQ7e++cJREgpGFBYwOaMT
         tZ5CIPdJqNEGkCb0MP9te7K7EBIr3XhqlR/T3/LZRJrO7SFe7Uh5URS5dUezIyXdTR+o
         LNxYHBD0mA5rubL46YI/55tFcGjOTEzl4Jq9se01278HBHqu+bgIy1evJ7Cgn8yjR1ae
         S8pe2XE+g0cntXWc02a0MfkmWHH5HECNKA0TW05RBrC6O0hYSoyExjstapNJEw16geO5
         /WYA==
X-Gm-Message-State: AOAM530nxnW9YRFwONQGrKYcYpw4aOtM6X91aK4eeRqokvmMOBC9mRV5
        zB9s+tcebn6Df0VYlWoaknP60HbETLIE9RslDxtUgxUVTFdf6r/a5m+Xy/N+Tba5N/IBBqLqvVL
        Tgdik/dMzeshX0vS5hT5JHn9z7MtkRP1rV2nh4w==
X-Received: by 2002:a05:6870:a2d0:b0:d9:ae66:b8e2 with SMTP id w16-20020a056870a2d000b000d9ae66b8e2mr29715896oak.7.1654508203141;
        Mon, 06 Jun 2022 02:36:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuZspkvPeBnMfW02MeReoB0cJ8UMJPKtRBlWBoiBAJ8yRELnF4G3Lq72vC6gZ6nqKl1V1k7tJHaJOnqyqv0Ww=
X-Received: by 2002:a05:6870:a2d0:b0:d9:ae66:b8e2 with SMTP id
 w16-20020a056870a2d000b000d9ae66b8e2mr29715888oak.7.1654508202878; Mon, 06
 Jun 2022 02:36:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
 <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com> <04d66d44-dc18-55f7-b044-defcbcf88fe0@linux.dev>
 <CALTww2_f5727NmOQw2=jiqg7DKSyYvEEMqvW_d_9UU0XT6n=4Q@mail.gmail.com> <f2e7af8c-074a-fc07-58a8-616616c59b64@linux.dev>
In-Reply-To: <f2e7af8c-074a-fc07-58a8-616616c59b64@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 6 Jun 2022 17:36:31 +0800
Message-ID: <CALTww2-GtH7g5Z1-e73TOE_xDGvDF___LcUq-FO53yeHqoGYUQ@mail.gmail.com>
Subject: Re: [PATCH] md: only unlock mddev from action_store
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Logan Gunthorpe <logang@deltatee.com>, Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 6, 2022 at 5:00 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 6/6/22 4:39 PM, Xiao Ni wrote:
> > On Mon, Jun 6, 2022 at 11:08 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
> >>
> >>
> >>>> +    }
> >>> Maybe instead of the ugly boolean argument we could pull
> >>> md_unregister_thread() into all the callers and explicitly unlock in the
> >>> single call site that needs it?
> >> Sounds good, let me revert previous commit then pull it.
> >>
> > Hi all
> >
> > Now md_reap_sync_thread is called by __md_stop_writes, action_store
> > and md_check_recovery.
> > If we move md_unregister_thread out of md_reap_sync_thread and unlock
> > reconfig_mutex before
> > calling md_unregister_thread, it means we break the atomic action for
> > these three functions mentioned
> > above.
>
> No, only action_store need to be changed, other callers keep the original
> behavior.

Hi Guoqing

Thanks for pointing out this.

>
> >   Not sure if it can introduce other problems, especially for the
> > change of md_check_recovery.
> >
> > How about suspend I/O when changing the sync action? It should not
> > hurt the performance, because
> > it only interrupts the sync action and flush the in memory stripes.
> > For this way, it needs to revert
> > 7e6ba434cc60 (md: don't unregister sync_thread with reconfig_mutex
> > held) and changes like this:
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ce9d2845d3ac..af28cdeaf7e1 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4827,12 +4827,14 @@ action_store(struct mddev *mddev, const char
> > *page, size_t len)
> >                          clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >                  if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
> >                      mddev_lock(mddev) == 0) {
> > +                       mddev_suspend(mddev);
> >                          if (work_pending(&mddev->del_work))
> >                                  flush_workqueue(md_misc_wq);
> >                          if (mddev->sync_thread) {
> >                                  set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >                                  md_reap_sync_thread(mddev);
> >                          }
> > +                       mddev_resume(mddev);
> >                          mddev_unlock(mddev);
> >                  }
> >          } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>
> The action actually means sync action which are for internal IO instead
> of external IO, I suppose the semantic is different with above change.

The original problem should be i/o happen when interrupting the sync thread?
So the external i/o calls md_write_start and sets MD_SB_CHANGE_PENDING.
Then raid5d->md_check_recovery can't update superblock and handle internal
stripes. So the `echo idle` action is stuck.

>
> And there are lots of sync/locking actions in suspend path, I am not
> sure it will cause other locking issues, you may need to investigate it.

Yes, mddev_supsend needs those sync methods to keep the raid in a quiescent
state. First, it needs to get reconfig_mutex before calling mddev_supsend.
So it can avoid racing with all the actions that want to change the raid. Then
it waits mddev->active_io to 0 which means all submit bio processes stop
submitting io. Then it waits until all internal i/os finish by
pers->quiesce. Last it waits
until the superblock is updated.

From the logic, it looks safe. By the way, the patch 35bfc52187f
(md: allow metadata update while suspending) which introduces
MD_UPDATING_SB and MD_UPDATING_SB fixes the similar deadlock
problem. So in this problem, it looks like mddev_suspend is a good choice.

As you mentioned, it needs to consider and do tests more because of
the complex sync/locking actions.

Best Regards
Xiao

