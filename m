Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209E5C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 01:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhLJByv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 20:54:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235446AbhLJByv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 20:54:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639101076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mSZW0WF/LLqOiV6GHC9ZVfEaAoKy8ZbqKd2xNElsFaM=;
        b=E5I7pgL6pFy5sRpTieAQghvvwkgtJE8nAaeCRYzxQnD3BlL4dXFSHo0w+Vpme+V/QtZVeA
        gPcd8aym+KvETKnQjrWn8fXk9ukxwQCteZ52sPby0TT02Umk18lRqTw1XTCEZeRsWdoqOh
        UCNWrkYpzXtyC0eHdXsTOjBxUjWkgIs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-6SCEn2xvPtqBJF7niUgnlw-1; Thu, 09 Dec 2021 20:51:15 -0500
X-MC-Unique: 6SCEn2xvPtqBJF7niUgnlw-1
Received: by mail-ed1-f70.google.com with SMTP id t9-20020aa7d709000000b003e83403a5cbso6872528edq.19
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 17:51:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mSZW0WF/LLqOiV6GHC9ZVfEaAoKy8ZbqKd2xNElsFaM=;
        b=x98nAel5kkHB3vu9whb7kzUZNheHYiZtDS3ojLgTIwNtrdtFOBU4JL4RQbuC89o2Wr
         7zvLANMQfpse+/0NYoRAZvvkhpbhuD3RfT/gRbFSN1YMH58qboKVYXFumPzta63uYu2y
         z4FSPB0XOfoEdLPyyeJvAjyrdnfFdG4ZH23TP8tajq/YiX/Ag8dk6u4FLSwOHWOpz/Ns
         YgTZyoS5Ur3LwAqiSJCrQyWKziW/o2CmjxKfTS3mCzSkhoxxWBqJ7/kfR+96Nny2u4Xv
         vxiWATsTrupo5dXhaFzT8G1wnpgBOFJaZrj7alqr2Oh1Mb9Ow5cHF1OHbyp3994cN1pn
         C/EA==
X-Gm-Message-State: AOAM5316cVJKQeaZ8YwacEHLRsS+yBB2tDMbqXF8laeTjsPyf0fKwq1J
        IoYxjuWOrqKeUMhfIkkNqaXdzQLF+nkeBavsr6q+z/E/Wo7eQ2CcmVjjPI4CNRI2cTHzLIinDXR
        VNxErmzQT0Zp2HhZTIa+is47cu/Aj0fsYvnRptg==
X-Received: by 2002:a17:906:9bf9:: with SMTP id de57mr20730752ejc.439.1639101074435;
        Thu, 09 Dec 2021 17:51:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywkJ0nocGAS+AHkuedGLdCKYqABXmzz+c5EjyKTxMylfv1NA19UVnaD+a2n7UXn3Hp3m+9ipTDQ15nymfez+s=
X-Received: by 2002:a17:906:9bf9:: with SMTP id de57mr20730733ejc.439.1639101074224;
 Thu, 09 Dec 2021 17:51:14 -0800 (PST)
MIME-Version: 1.0
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com> <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
 <978b1c0a-2ba0-d736-8e3c-99a15997b7d5@linux.dev>
In-Reply-To: <978b1c0a-2ba0-d736-8e3c-99a15997b7d5@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 10 Dec 2021 09:51:03 +0800
Message-ID: <CALTww2-8zhibAwYS9b_D28HZAh4KfQ_x3iWMOJa_=CtZyZA4Mg@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity failed
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Song Liu <song@kernel.org>, Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Dec 10, 2021 at 9:22 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 12/10/21 2:02 AM, Song Liu wrote:
> > On Wed, Dec 8, 2021 at 9:55 PM Xiao Ni<xni@redhat.com>  wrote:
> >> It doesn't free memory when register integrity failed. And move
> >> free conf codes into a single function.
> >>
> >> Signed-off-by: Xiao Ni<xni@redhat.com>
> >> ---
> >>   drivers/md/raid0.c | 18 +++++++++++++++---
> >>   1 file changed, 15 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> >> index 62c8b6adac70..3fa47df1c60e 100644
> >> --- a/drivers/md/raid0.c
> >> +++ b/drivers/md/raid0.c
> >> @@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
> >>          return array_sectors;
> >>   }
> >>
> >> +static void free_conf(struct r0conf *conf);
> >>   static void raid0_free(struct mddev *mddev, void *priv);
> >>
> >>   static int raid0_run(struct mddev *mddev)
> >> @@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
> >>          dump_zones(mddev);
> >>
> >>          ret = md_integrity_register(mddev);
> >> +       if (ret)
> >> +               goto free;
> >>
> >>          return ret;
> >> +
> >> +free:
> >> +       free_conf(conf);
> > Can we just use raid0_free() here? Also, after freeing conf,
> > we should set mddev->private to NULL.
>
> Agree, like what raid1_run did. And we might need to check the
> return value of pers->run in level_store as well.

Hi Guoqing

By the way, you agree with using raid1_run here? I just replied to
Song in an email.
Could you have a look at it? I explained why I wrote a new function
free_conf here.

