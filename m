Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6ACC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 13:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25A6864E0F
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 13:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhBQNvE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Feb 2021 08:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbhBQNvC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Feb 2021 08:51:02 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD196C061574
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 05:50:21 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id y123so6549649vsy.13
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 05:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=utR+26wrDdtVK1v+o+MDlTyYs+sn/ml9POoZk6jo3rY=;
        b=ZNUne80RuRb1K2Xm+cdBJuDW9ZFbN3WL0XUhLRzyqnPEdbJxEJAA1HWX+kYjASHY5H
         boBc3YobzBnk7F79gtSNiihCUC9wcymtK4wj8kX7vSp3HNXec6u9teP/H23PsX3/ir+x
         aglgbn6qTrwUWRmhNHu/IpwSSRpeqizEHKCZxpm9iHcIB7b/ShJh2zRTKQsF8IgRZvhx
         oX0SYTAZJOpQRyhu1TaWM5g1fmQljDVWxFN/7cYPr9lA2AmnC/0QbXh8yiboUHOhMAze
         nYLW68qHnay3pkZ1J5NqYnxKClW0PsGmnC6DSabP7HwL2SJVIvXTRttutFJEzmv4FJiY
         n86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=utR+26wrDdtVK1v+o+MDlTyYs+sn/ml9POoZk6jo3rY=;
        b=dNCYAimXxtnMxb74S4AIbC+inYY5oAN/O9aAQWAQR6/9oMJ58KV1tsK6Z2i/Mdws2H
         HF5omcbtZc/havUAGuI+e6fIqytbR2j3lgS/ldaW+91yjzoR/vcovEi5tRXUiRnRaYhP
         8tD/l46EsTDL7lvEoiOYJGcGBBvmcYONnL7YDxA35opkT4SqUs97vyNlaTqB4z/8Xm5x
         M9Ne1aigT3pHrybx5dbER+ihiiNGgPO4QAysUaNDYyaOHlvU9soHgOfKBjeGO9jjqc7L
         JCHczll6KFm8l+ya3iVX47+vh7O7eSlXa5BncRElIyhNG2w+QyEdHVY8aaWAXhEsqU9X
         1suw==
X-Gm-Message-State: AOAM5335YOd5FbtlySNlNs7OtXFIoB15XWD4Yx/YQIu4WgcgeS021vmk
        qd884DO+8UqviLJEw4KV1Hw1bqFao3V21iuDXM7jjIeaaQTbrA==
X-Google-Smtp-Source: ABdhPJw3QcVgZEDwGN0jEDkNVup1DSumitOka1RRhXcrr+vWxQmm/bky9cv1bDUwbg5JY8okcoFjuODruRzNWTOJQhM=
X-Received: by 2002:a67:8d47:: with SMTP id p68mr13508493vsd.11.1613569821125;
 Wed, 17 Feb 2021 05:50:21 -0800 (PST)
MIME-Version: 1.0
References: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
 <24620.56829.93946.65275@cyme.ty.sabi.co.uk>
In-Reply-To: <24620.56829.93946.65275@cyme.ty.sabi.co.uk>
From:   d tbsky <tbskyd@gmail.com>
Date:   Wed, 17 Feb 2021 21:50:09 +0800
Message-ID: <CAC6SzH+ai5jD8ZQi2f-vTYjBGWDshXJVVm+xM9KZ3OCjk5Sz4g@mail.gmail.com>
Subject: Re: use ssd as write-journal or lvm-cache?
To:     Peter Grandi <pg@mdraid.list.sabi.co.uk>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Peter Grandi <pg@mdraid.list.sabi.co.uk>
> Also, the MDRAID write journal is usually (and should be) a lot
> smaller than a whole flash SSD unit, so you can use a small part
> of a flash SSD for write journaling and most of it for caching.

I thought journal write-back mode should use large ssd space,like
bcache which will prevent random write at all cost.
but reading the document again, it said "The flush conditions could be
free in-kernel memory cache space is low".  since the memory won't be
too large compare to normal ssd disk, maybe a small optane ssd is best
for mdadm write-journal.
