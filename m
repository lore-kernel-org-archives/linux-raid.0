Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF0EC433B4
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 071B7610F7
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhEGBNR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 21:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhEGBNR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 21:13:17 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53433C061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 18:12:17 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id l7so8268065edb.1
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 18:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHA/oYYLqTpDNnqYHNHKCCcJNGLVoRL3Vp/NbjEBw6w=;
        b=cxesg0hgh/dntcfo7eriiuW/2Aj78hVMgcE+I1hfQdzB2QLUUDoEMY1SEOa5PEpi2y
         6W6UBqB7UyKz1AkIYmyekjzG2yDTS+qdGGFrOVjbii7J+g5s7989PTnpq2vk42nKhj7i
         BG9etjysHDh/m9kWdiq5SoDhLJ6YU26KCVXIo928Dhnu+ahSNlkWkJwoOLGsewS/42mx
         FXMMTAPd3UhFL6spM1XBi9XoAAZSEBsrTMbI3/YZRQZAcxjI47kYg+vICxifMvRcHDfH
         8rtHw4/ovLwDu4nCgGL8WcDtShfWLHPVKPcdnsRxhOaOJVIPhfBt2aYNZgJuxRhFFuNe
         cr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHA/oYYLqTpDNnqYHNHKCCcJNGLVoRL3Vp/NbjEBw6w=;
        b=fx5kPDPbPC0v9QidfUBo9GgUsXV+eYzCtEM5BuXo1Oejl3XWGjwBzKKGfLnlMFQXJ7
         ryupUEOqVeckdSjTXu06tt3IIdRcAmSNRZ61sc+ZCH5/s/lCkF0roAB4xLTNBZ5VzatR
         HZQryWCovG0Bit+BXXRXa7uPjRQB0QU3HL0c74ubZ8kKoF57dwOgJrqH/bxn0ncG32t+
         5vZZsHp9M4ODegcOoFqSzl6WNKVMzOF29m2RmuPmrAKr6kDQUipm4T9dUPCtIszJuatE
         Ry9z9L66pMmslYf0MVG3ZC1CmsH2GU151o4XOlNQHYfttPlwik5rSooZhQvF8jrxmiJ5
         EkbA==
X-Gm-Message-State: AOAM5326kOOQ03pYp9RBV8WsJkJyar9rK6CiB7nJf4Kac0ejFf4Dbu27
        zjGadI91uNi7Ce1vfWBjB26RbxVH5EOfK1PKz1vXDV3XbK8=
X-Google-Smtp-Source: ABdhPJyqTo0BloB/Qz0iCIE/AHUHtFoxenxzY8+SMsBUuqjEHM1QC8JBOS1VyC9YODG4cuAN6HPUTfaX1BEec5S4cbo=
X-Received: by 2002:a05:6402:3594:: with SMTP id y20mr8307651edc.226.1620349936066;
 Thu, 06 May 2021 18:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <AD8C004B-FE83-4ABD-B58A-1F7F8683CD1F@websitemanagers.com.au>
In-Reply-To: <AD8C004B-FE83-4ABD-B58A-1F7F8683CD1F@websitemanagers.com.au>
From:   d tbsky <tbskyd@gmail.com>
Date:   Fri, 7 May 2021 09:12:06 +0800
Message-ID: <CAC6SzHKH62XwudewxtOUyNQYi9QSFar=dZ64fz9HiEW1eZh47g@mail.gmail.com>
Subject: Re: raid10 redundancy
To:     Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Adam Goryachev <mailinglists@websitemanagers.com.au>
>
> I guess it depends on your definition of raid 10... In my experience it means one or more raid 1 arrays combine with raid 0, so if each raid 1 arrays had 2 members, then it is either 2, 4, 6, etc for the total number of drives.

indeed. What I want to use is linux raid10 which can be used on
2,3,4,5, etc of disk drives. so it is unlike hardware raid 10.
