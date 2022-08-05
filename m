Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6118DC00140
	for <linux-raid@archiver.kernel.org>; Fri,  5 Aug 2022 18:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbiHESqU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Aug 2022 14:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiHESqU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 Aug 2022 14:46:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AA44B7F8
        for <linux-raid@vger.kernel.org>; Fri,  5 Aug 2022 11:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659725178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=33psrDbLQcz80OXZGf4m0xuRZp3k1qHgg5uYxePgt0c=;
        b=VJbcVufGJpmSN3TiLGA5fuEWQPooM2Jnq19+EXxYf6D8Gc+AvhpWlk89rMxvdE/EXsoHjp
        mxPFX11forsDOeKt5tvxeq9erwC/iwCAEnTiQfIOVGlnwxMzAvtPNRmiKsSG7g2jNeOqxg
        xIsEDmlOL82kXJgCXAZhScjEwf+5yeQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-uCIOLX-ZMlSruJ6E3ad2Qw-1; Fri, 05 Aug 2022 14:46:16 -0400
X-MC-Unique: uCIOLX-ZMlSruJ6E3ad2Qw-1
Received: by mail-qt1-f197.google.com with SMTP id c27-20020ac84e1b000000b00342e8e0b160so937972qtw.9
        for <linux-raid@vger.kernel.org>; Fri, 05 Aug 2022 11:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=33psrDbLQcz80OXZGf4m0xuRZp3k1qHgg5uYxePgt0c=;
        b=68xfd37qzXYkb41ppLyMfBTL9rID+rZ3jXdyCHlrzE6vSpLxV9QozdbyXbsGKMbU4m
         rLFmlmEipwyg5GMZnGBOuP0bcR37dbsSE+GomGJV9LtKtX6b8s/Y42PUxaPODQyK62/m
         IMA1ny8X9wSwNe3A8e4OjAMDh3rekHBQZng3nV87wpIBHzsPNMq5jAs8Q4liEWRLM+V3
         1ECqbMUZmgxDIGEqHvJYaBjtdWOmU3J1I8i/LCOd6NyppMcC0aaKc77vbXqzwgzAigAu
         uvIogSWM8ueqbkD8uQZtXy8rpNHHmTFBpW2kSmdqwwG4NxHkGYcCRrwLOAdkgDlejRHq
         COaQ==
X-Gm-Message-State: ACgBeo3lkAbrzNIyOp6545AhzemjzllvcQgIDFt169XGxmxHuvQVdVad
        3tP4R6rwNBg5lqIWxZuzIZRTnhedrJKcoxsCVH7itpFFsyqLSfpmlSnQrnUT6Jjo3aR76AcRY3U
        rEngfK8nGDi9Wdk5iZ59l96ssXBRz3w3EZeuhow==
X-Received: by 2002:a05:622a:38e:b0:342:e878:5575 with SMTP id j14-20020a05622a038e00b00342e8785575mr2297805qtx.291.1659725176326;
        Fri, 05 Aug 2022 11:46:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7fBNQ+Y3xaqg/jBOnAnfn9sNwc8YQkUbHfhAw7ji8tGjCI2a5JmH0qrOh3T2RbwX+z2Tay3NEmvvnZGC9KljI=
X-Received: by 2002:a05:622a:38e:b0:342:e878:5575 with SMTP id
 j14-20020a05622a038e00b00342e8785575mr2297787qtx.291.1659725176118; Fri, 05
 Aug 2022 11:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220725203835.860277-1-aahringo@redhat.com> <20220725203835.860277-4-aahringo@redhat.com>
In-Reply-To: <20220725203835.860277-4-aahringo@redhat.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 5 Aug 2022 14:46:05 -0400
Message-ID: <CAK-6q+hRU2EUPQVt3jpnRXZc_iQ8NBHDtxyR=z7DpEBrHUdF0w@mail.gmail.com>
Subject: Re: [PATCH dlm/next 3/5] fs: dlm: trace user space callbacks
To:     David Teigland <teigland@redhat.com>
Cc:     cluster-devel <cluster-devel@redhat.com>, song@kernel.org,
        mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On Mon, Jul 25, 2022 at 4:38 PM Alexander Aring <aahringo@redhat.com> wrote:
...
> --- a/include/trace/events/dlm.h
> +++ b/include/trace/events/dlm.h
> @@ -92,9 +92,10 @@ TRACE_EVENT(dlm_lock_start,
>  TRACE_EVENT(dlm_lock_end,
>
>         TP_PROTO(struct dlm_ls *ls, struct dlm_lkb *lkb, void *name,
> -                unsigned int namelen, int mode, __u32 flags, int error),
> +                unsigned int namelen, int mode, __u32 flags, int error,
> +                bool kernel_lock),
>
> -       TP_ARGS(ls, lkb, name, namelen, mode, flags, error),
> +       TP_ARGS(ls, lkb, name, namelen, mode, flags, error, kernel_lock),
>
>         TP_STRUCT__entry(
>                 __field(__u32, ls_id)
> @@ -122,14 +123,16 @@ TRACE_EVENT(dlm_lock_end,
>                         memcpy(__get_dynamic_array(res_name), name,
>                                __get_dynamic_array_len(res_name));
>
> -               /* return value will be zeroed in those cases by dlm_lock()
> -                * we do it here again to not introduce more overhead if
> -                * trace isn't running and error reflects the return value.
> -                */
> -               if (error == -EAGAIN || error == -EDEADLK)
> -                       __entry->error = 0;
> -               else
> -                       __entry->error = error;
> +               if (kernel_lock) {
> +                       /* return value will be zeroed in those cases by dlm_lock()
> +                        * we do it here again to not introduce more overhead if
> +                        * trace isn't running and error reflects the return value.
> +                        */
> +                       if (error == -EAGAIN || error == -EDEADLK)
> +                               __entry->error = 0;
> +                       else
> +                               __entry->error = error;

I need to investigate why my user space block calls drop all weird
error numbers... We need to assign this value for user space locks as
well. I will remove the else branch and move the handling above to all
other field assignments and if it's kernel lock there is a special
handling which is different on kernel locks only... this handling is
still required.

- Alex

