Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA0DC48BDF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 01:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 147D1611C0
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 01:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhFUBMe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 20 Jun 2021 21:12:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229872AbhFUBMd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 20 Jun 2021 21:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624237820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oH8Gsw4T/Zm7KIiVoTSdYH7xuahw16N8b2Z9381U6u8=;
        b=QH+FSiw/X0pdiycwEvHDtFGNV7V5/UG9qKh1h6jDgtxS1kGSM4PrpPtNFFpSEkUXCUFqbg
        /mob2jfJEzX672R70mKb+xCf2NSESx9hAHamDYLMzb6lBooXdesuDJBZb8WmZQE4vZmVuV
        b9pB8Jrn5AyrX86vho0cJL5fK6QerNM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-Tq6BFFXWNkOncqV51eG4Xg-1; Sun, 20 Jun 2021 21:10:18 -0400
X-MC-Unique: Tq6BFFXWNkOncqV51eG4Xg-1
Received: by mail-ed1-f72.google.com with SMTP id v12-20020aa7dbcc0000b029038fc8e57037so7125537edt.0
        for <linux-raid@vger.kernel.org>; Sun, 20 Jun 2021 18:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oH8Gsw4T/Zm7KIiVoTSdYH7xuahw16N8b2Z9381U6u8=;
        b=IJ1o8NlN/WbsKGO3CIn0RYabREjJNWKoBKcc/oZ2d4k4m+DziszZeGbY5q2dtuxMVB
         H31JZLH50zzNf7XzbL8b8Eu+TJqLal9+Ih372L9n5jp6x7yBozFRuqqUvlq3ElaDYAky
         anglF+T8raGaRoPqrS0nc5Yer3EDXrcDanx/TvK59Qx2DjgNE+QBq70kJSaQ/VJoj0gM
         NZG+FcUPur7yCwE7AmSJ9Nr11dhEBkVULjlXcBt+CHdZgoao5WsE3kkgU8lKnlnNijKI
         LlzuaIu0sU8jj0LW/cY1bTcNeCb3PKyP5fUOzyz+Y1+LJWaCQSTZnGHruGnI/AFCvj7k
         4gpw==
X-Gm-Message-State: AOAM530jrqKSpKdIdfp+Oc8SShOspiPNC5sGbfuB94W1IKxT5yh3oTOe
        +I48oFV2YNpZmav41Q7DLTFIPN8MEhTSoyBHyrtuCkDzpVP2wS6QiSMmLsDA6AEjxOeolLZ24r7
        bGLB2GLVfy2wuXQnMd8praBV923PTEuuXOiH0+g==
X-Received: by 2002:a05:6402:34c6:: with SMTP id w6mr18563983edc.174.1624237817171;
        Sun, 20 Jun 2021 18:10:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDN82L7q2621OEXK0BSGb4kYUgshMgah8UwY+6u0at63mGUuqWz9mq8CtQgAHzKKKczGuYyNGO76CKojQFfEk=
X-Received: by 2002:a05:6402:34c6:: with SMTP id w6mr18563971edc.174.1624237816980;
 Sun, 20 Jun 2021 18:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <1622596639-3767-1-git-send-email-xni@redhat.com>
In-Reply-To: <1622596639-3767-1-git-send-email-xni@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 21 Jun 2021 09:10:04 +0800
Message-ID: <CALTww2_0cf2ubWq+H3hB0G57cCJ+QONdob7DcYHcZytuBTwX1A@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/super1: It needs to specify int32 for bitmap_offset
To:     jes@trained-monkey.org
Cc:     Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes

Ping, is the patch ok for you to merge it

Regards
Xiao

On Wed, Jun 2, 2021 at 9:17 AM Xiao Ni <xni@redhat.com> wrote:
>
> For super1.0 bitmap offset is -16. So it needs to use int type for bitmap offset.
>
> Fixes: 1fe2e1007310 (mdadm/bitmap: locate bitmap calcuate bitmap position wrongly)
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  super1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/super1.c b/super1.c
> index c05e623..a12a5bc 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2631,7 +2631,7 @@ static int locate_bitmap1(struct supertype *st, int fd, int node_num)
>         else
>                 ret = -1;
>
> -       offset = __le64_to_cpu(sb->super_offset) + __le32_to_cpu(sb->bitmap_offset);
> +       offset = __le64_to_cpu(sb->super_offset) + (int32_t)__le32_to_cpu(sb->bitmap_offset);
>         if (node_num) {
>                 bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
>                 bm_sectors_per_node = calc_bitmap_size(bms, 4096) >> 9;
> --
> 2.7.5
>

