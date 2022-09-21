Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1350FC32771
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 12:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiIUMQ1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 08:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIUMQ0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 08:16:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A58AF46
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 05:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663762584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lRz/z/AXpEruTQsHU4EAQEPc0Y+Waw+jrJW7+kWECyI=;
        b=HC1WaawmTydvuc2LUpWkM8stA646rPW9rVnWDrInzSOEHFSiILBF18jfAL1GdizbpJQK/u
        ATYiFKN3pCjg/fZXJm+VhXq52z3jAgSGoFIvFDX3jQGZPePiTamidNb9XxlYWvBvFDOQrg
        c6o/b/+e4R6BXmQK9oHEDomgVU9bwx0=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-BcDY1178NGmvlKBHDDtQuQ-1; Wed, 21 Sep 2022 08:16:23 -0400
X-MC-Unique: BcDY1178NGmvlKBHDDtQuQ-1
Received: by mail-pg1-f199.google.com with SMTP id h19-20020a63e153000000b00434dfee8dbaso3362388pgk.18
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 05:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lRz/z/AXpEruTQsHU4EAQEPc0Y+Waw+jrJW7+kWECyI=;
        b=jhiEu4C+kvX8L1mCJuPVJt6214+dzl+1elV+hs/HW0G20t6MCrWupV+o1r8R2r+kb5
         AD3iizRpAvHzrkmKxqBdj3eK9Wn4P4NNX24K2YOUsk2JLlr1hd/yZfpz6lRbFBEP3VUC
         g8ZEYEPBtHQymqpz0r7l9m2/Qn3jA+jMvVX16oKUUjSmIKNHXLflSH2A+GzMp7YbUAkx
         n4A6epk2h6HdHuatAnOnw6fFWfTfheUrlO2yn5TYWSUhtc6dEZ5StuDvVMg6n3SokaJC
         YvrxCWzWcS/iswVy1EKezb8hGxzfsx88QZZYRCehyavYMUM4eM6okr2Ck9b9lKwOABnU
         nNFA==
X-Gm-Message-State: ACrzQf2ZtIvOmyMSD7xRoS4BdjU28Zs/24heXNEuNOg8p0HgQy8LY4Qf
        6wPuxRF/3Vm0KSXHxgxGQfhyVycU0xDNv1uXfdaLTwJ9vFb4htJbGsXzVyhZIDVvm1ejaoFYELM
        yd+s1TrBYRfx2Lw3lmGR3zMjsgO5RY5xfo1OFnw==
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id b12-20020a056a00114c00b005282c7a6302mr28503660pfm.37.1663762582639;
        Wed, 21 Sep 2022 05:16:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5r/ijjU2c5rOZiLzk/NojDFwRsD3xgDKZQeggVJqltBvK5luALhPFt8HfhxhdtEdOtWZNDc8CkV8CGgvipPTc=
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id
 b12-20020a056a00114c00b005282c7a6302mr28503640pfm.37.1663762582408; Wed, 21
 Sep 2022 05:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220721121152.4180-1-colyli@suse.de> <20220721121152.4180-2-colyli@suse.de>
In-Reply-To: <20220721121152.4180-2-colyli@suse.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 21 Sep 2022 20:16:11 +0800
Message-ID: <CALTww2_raNwb3j9evCWi4LD3FqBpW9+hugKw9-OEU+0LG25DBA@mail.gmail.com>
Subject: Re: [PATCH v6 1/7] badblocks: add more helper structure and routines
 in badblocks.h
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-raid <linux-raid@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>,
        Vishal L Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 21, 2022 at 8:12 PM Coly Li <colyli@suse.de> wrote:
>
> This patch adds the following helper structure and routines into
> badblocks.h,
> - struct badblocks_context
>   This structure is used in improved badblocks code for bad table
>   iteration.
> - BB_END()
>   The macro to calculate end LBA of a bad range record from bad
>   table.
> - badblocks_full() and badblocks_empty()
>   The inline routines to check whether bad table is full or empty.
> - set_changed() and clear_changed()
>   The inline routines to set and clear 'changed' tag from struct
>   badblocks.
>
> These new helper structure and routines can help to make the code more
> clear, they will be used in the improved badblocks code in following
> patches.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> Cc: Xiao Ni <xni@redhat.com>
> ---
>  include/linux/badblocks.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
> index 2426276b9bd3..670f2dae692f 100644
> --- a/include/linux/badblocks.h
> +++ b/include/linux/badblocks.h
> @@ -15,6 +15,7 @@
>  #define BB_OFFSET(x)   (((x) & BB_OFFSET_MASK) >> 9)
>  #define BB_LEN(x)      (((x) & BB_LEN_MASK) + 1)
>  #define BB_ACK(x)      (!!((x) & BB_ACK_MASK))
> +#define BB_END(x)      (BB_OFFSET(x) + BB_LEN(x))
>  #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
>
>  /* Bad block numbers are stored sorted in a single page.
> @@ -41,6 +42,12 @@ struct badblocks {
>         sector_t size;          /* in sectors */
>  };
>
> +struct badblocks_context {
> +       sector_t        start;
> +       sector_t        len;
> +       int             ack;
> +};
> +
>  int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>                    sector_t *first_bad, int *bad_sectors);
>  int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> @@ -63,4 +70,27 @@ static inline void devm_exit_badblocks(struct device *dev, struct badblocks *bb)
>         }
>         badblocks_exit(bb);
>  }
> +
> +static inline int badblocks_full(struct badblocks *bb)
> +{
> +       return (bb->count >= MAX_BADBLOCKS);
> +}
> +
> +static inline int badblocks_empty(struct badblocks *bb)
> +{
> +       return (bb->count == 0);
> +}
> +
> +static inline void set_changed(struct badblocks *bb)
> +{
> +       if (bb->changed != 1)
> +               bb->changed = 1;
> +}
> +
> +static inline void clear_changed(struct badblocks *bb)
> +{
> +       if (bb->changed != 0)
> +               bb->changed = 0;
> +}
> +
>  #endif
> --
> 2.35.3
>

Reviewed-by: Xiao Ni <xni@redhat.com>

