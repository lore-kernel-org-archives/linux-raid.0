Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC32AC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 01:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhLJBiI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 20:38:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229379AbhLJBiI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 20:38:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639100073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E/otGnN+tVzXPjFeG/D93obTBNbmjhyrX0drrnK2vPk=;
        b=FOHTJQKzKu0y8mgqf5brRzyBo2TKm0zg47mpye62UcL42UTTKool70euhtydDrAXUSJ7rK
        U0p0xN92SbWI0Oc9HYBhAim+BpZrqbVHV/rGzV7HTuunH4wkM500+h85ZedLEzSuPZfzcW
        0IkIITyCbFlSTShfNGR+0bF6HBJq+hw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-GKSXeOepPHuTEYkI9H_PHg-1; Thu, 09 Dec 2021 20:34:32 -0500
X-MC-Unique: GKSXeOepPHuTEYkI9H_PHg-1
Received: by mail-ed1-f72.google.com with SMTP id p4-20020aa7d304000000b003e7ef120a37so6800447edq.16
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 17:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E/otGnN+tVzXPjFeG/D93obTBNbmjhyrX0drrnK2vPk=;
        b=Ahca8T/KJC/i0EaAuiXJUBPPA0M3g35RAnkGYXvTho2NuMLJzQYPt8/GIB36Gf1Rj+
         9lqjEOe3GKuT+RVowmhjUBAwi2PHniO1OnmqYFL+RguqYJWV+LWxEDs7P6CSo0nhzyoq
         B0WRfGMNr/yde57GYU0VotwLjKmzp8wK0jP0heBPyb9EL5Xb2TNEmEZUjVoI9BwP8GFt
         qA3tQDD/52q/JKiFlYNriMIpQsbD58PXhavmnuqGAYPxdL313fW9xvP45Hmyc1VDOw+4
         BJ92gMDv7SP5bEgKaI25FKya+mkeFdv4nhZ5EGvhSKPd8UuFInas009N/vAkVEYt+Sc+
         G51g==
X-Gm-Message-State: AOAM5321CG/4NI72+b4Mv+CzAHEyH94MSbTSG+geCdh5DHxR+JQGEjqt
        X542Zxqhd+/wJ+Xyejmil6lIOJm1dLFhE6QDKIZatxGGxEL20NhnTf1XPEvHuPJjyIlJej5tYte
        hhxPdWluC9nwU2S21N3apWiXia3rfg3UZbrOwSg==
X-Received: by 2002:aa7:d8da:: with SMTP id k26mr34360116eds.406.1639100071367;
        Thu, 09 Dec 2021 17:34:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwtJcQN4Jko5qmmdoEg0v75bYxY9tgEKoe/76zmW3/Js/KRB0Sy1YuGqtoRlI+2qfIXcvGJVMc0cxQVOhp5L8I=
X-Received: by 2002:aa7:d8da:: with SMTP id k26mr34360101eds.406.1639100071204;
 Thu, 09 Dec 2021 17:34:31 -0800 (PST)
MIME-Version: 1.0
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com> <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
 <978b1c0a-2ba0-d736-8e3c-99a15997b7d5@linux.dev>
In-Reply-To: <978b1c0a-2ba0-d736-8e3c-99a15997b7d5@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 10 Dec 2021 09:34:20 +0800
Message-ID: <CALTww293ewiXD8s0b-sLbdFZgnxMZh=5e4Fj=WMB+ifoJcNP7g@mail.gmail.com>
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

Yes. It needs to check the return value and try to reback to the original
state. I planed to fix this in the following days not this patch. This patch
only fix the NULL reference problem after reshape.

In fact, no only we need to check pers->run in level_store, we also need
to check integrity during reshape. Now integrity only supports
raid0/raid1/raid10,
so it needs to do some jobs related with integrity (unregister/register)

I plan to fix these two problems in the next patches. Is it OK?

Regards
Xiao

