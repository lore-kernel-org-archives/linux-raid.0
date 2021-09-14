Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03098C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Sep 2021 07:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1DBD61355
	for <linux-raid@archiver.kernel.org>; Tue, 14 Sep 2021 07:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhINH6U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Sep 2021 03:58:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhINH6U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 14 Sep 2021 03:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631606222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kw4mlNBFYcsGQv4qTyj3NqH4rmqCEnAwXScHDg5rYWE=;
        b=TPFz2rcSznNC9zOdcwQBuGYTqMPqlfA2mNvW7Mvip+MLCWDITPlC5v5H5IDqP7Ux6KLWbn
        Kp0XxcEsA4U9aMHN6mJ/RxVHj/GA/hOzvrfkIuyjc8rrcZUWxeYnEhaF+gtXBr1jhkCevQ
        vS4HpKiTHL3X/iVL6KAJCXuAuAJb18I=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-79GHIYYLOCW-JJCHrL5T-A-1; Tue, 14 Sep 2021 03:57:01 -0400
X-MC-Unique: 79GHIYYLOCW-JJCHrL5T-A-1
Received: by mail-ed1-f69.google.com with SMTP id o18-20020a056402439200b003d2b11eb0a9so1633503edc.23
        for <linux-raid@vger.kernel.org>; Tue, 14 Sep 2021 00:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kw4mlNBFYcsGQv4qTyj3NqH4rmqCEnAwXScHDg5rYWE=;
        b=Bb5U6XcTecKYwBEWQzs3XcMLtbt9sVOAsDOsTIyyrDpxPw7OQ+5KeYogDDAiW77bd7
         bWDquBAu3QDg4Hu06uHHfrXXdmkj3lnEOK/MRclVEFjQGgc7LibeFm48QMDyejF4RPdu
         5zbA98G6Wq4X6egVz7+YP9qZFy21abqHzK/J+ZRchvbJ1CZ7FMRbqj8v00buNOnP7QKp
         g5/h08UzDM9sd9xrE0+TNgXAs+23w8+luIyS6+2Nlj1IDlT7InbEoeQnQ56+MKplCnV8
         0hWEy2O8GapN0JyFiYiL4KKJPzvbEmH37tKj2CBjsEWF51lZvdQI0+kQbYqyWDER/C/g
         hF/A==
X-Gm-Message-State: AOAM530pH97lYnFV856OPn0Ii9RxHBAy3O6HRRGSw69NZC8vkS6bljby
        zH5XiIMybMnijP58kx3UBPcHWJtap7oWIZ9GN7rCNyRksynBLOSYKPrzqEAL0hD4BBEyX3IBsHv
        QVA7bUwSDNfL5CdHoNyrnHW4e9G/0xt25rK8wvw==
X-Received: by 2002:a05:6402:40ce:: with SMTP id z14mr17774056edb.28.1631606220479;
        Tue, 14 Sep 2021 00:57:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtMcG1sOgYTczkH0WXGwbdOlLMi8XxPcgk+sexubwUx1GLU2mmiMU9XUaiy4piKVhgsgT4VJOnSHM+VCjGiMU=
X-Received: by 2002:a05:6402:40ce:: with SMTP id z14mr17774043edb.28.1631606220271;
 Tue, 14 Sep 2021 00:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <7461b27b-2a4b-fbbb-5cfd-8fab416cbc9f@suse.de> <CALTww29nZV4A1BM_ShrmL1ud4YZC2YTG8q4LvW8pfhZwb=MhVQ@mail.gmail.com>
 <75fdd0fe-154b-f8eb-9ac3-bb948b432e39@suse.de>
In-Reply-To: <75fdd0fe-154b-f8eb-9ac3-bb948b432e39@suse.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 14 Sep 2021 15:56:48 +0800
Message-ID: <CALTww28wGf=vCOsMC7reYOn03-V9v7iro-i7YoyUOUjiZyrU8g@mail.gmail.com>
Subject: Re: [PATCH] mdadm: split off shared library
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 14, 2021 at 3:26 PM Hannes Reinecke <hare@suse.de> wrote:
> Sure. Wasn't sure how you'd like to handle it; some prefer smaller
> patches, some prefer less patches overall ...

Sorry for not describing clearly. I want to say these patches are good
for me. It's better to
put the patches together. For example, patch03, patch04, patch10,
patch20 -> patch01,
patch02, patch03, patch04(The numbers are just examples, not real patch)

Regards
Xiao

