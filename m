Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B121EC433B4
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B354610A5
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhEGB2E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 21:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhEGB2D (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 21:28:03 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A37CC061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 18:27:03 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a4so11111388ejk.1
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 18:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dLXqSYJrzgim9laaN+/MDEXD2hoQoAxl2PA9kPPdWBM=;
        b=dVrrsgxH6kt+h1UvpPzorWQIwai7WXjOGU2eIfPL8BuMqFimcHKetKtVlyDGltg85D
         faQ7fZq0Q2e7P/Y2DDDWCUia7YNzFPvB5eGW1/KxspXvCu5/53Cyyh2LAHK/3bilao5s
         bfoQ2kF+zyxV1JmKUtKnmcOo2jAfTWsRF6wvtjSGBSZC24mAmqSEwHNTOhfcQVS65/ua
         uieOR4v+nWKbBxF/a1taTMPWMcqBl/n/r6J7UUlcdLWVN+NrqGBcNvSUGHG8b+EX4u1N
         Rb/2FzFd1X5mEakgSS7lQmZE3gavsMJ41QzT8tc1DCq9ia+c1DnPQAMkk7ipv/Mt6LhL
         Ghbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dLXqSYJrzgim9laaN+/MDEXD2hoQoAxl2PA9kPPdWBM=;
        b=J2ujmYzzPAMfGHP9z26/xCd8Pogj6K1XFc4n2zauklYYAOIvG477GTVYYYcWlE/CU9
         1jUo6AQT1Su+hVxXcbvKemT+oCV8O0sLLnOTr644TTelIPaTlNITP7ivDCZhhZ2AYJMC
         nkk+ZNqHGuyePAU4iWYkBoqPC0BNo7e8utUVKRFUz5KlLCWHge49A2iYCO+UN7x7GHjQ
         JGsFaZHtmKj8/laE1eHvc//+m7vsJrYaEzIvDwoaqpKw0paZxW1u5wZq8zATYWg8ijyC
         gdPhpYHRrHMIgnTEEPmjkwT8ttRJRXxylsrDzcLn/OUzqSmVHTqxBj68LR1FPFJYcGKs
         eEVw==
X-Gm-Message-State: AOAM533TUObbrfkUVIHM5T5E+Snheo2RYt+vYF3aMKLF9RZ9fmj6hBKM
        oHk8tWHGn2hbH4yxetKWxAc+TfcvhEaRBfAEiAA=
X-Google-Smtp-Source: ABdhPJwOIkrd5QpY5OSxeEHR6e7O6L3TTyMfmic/te7n/fvt8ns1ALwfBCP8uRM6smwk40IMhThWcDRM1wb1WkFGjq4=
X-Received: by 2002:a17:906:8a51:: with SMTP id gx17mr7274778ejc.549.1620350822210;
 Thu, 06 May 2021 18:27:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
In-Reply-To: <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
From:   d tbsky <tbskyd@gmail.com>
Date:   Fri, 7 May 2021 09:26:52 +0800
Message-ID: <CAC6SzHJbN1T=HUS1ANf1QLqh+KvHyUB6wgQPO0KZcWc_xQ3KEg@mail.gmail.com>
Subject: Re: raid10 redundancy
To:     Xiao Ni <xni@redhat.com>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Xiao Ni <xni@redhat.com>
> > It depends on which layout do you use and the copies you specify. There
> > is a detailed description in `man md 3`
>
> Thanks a lot for the hint. After studying the pattern I think n2 and
> o2 could survive if losing two correct disks with 4 or 5 disks. but f2
> will be dead. is my understanding correct?

it seems not correct. I check the pattern again. I found all
layout(n2,o2,f2) tend to put second copy to neighbor disk.

so if I link all disks as a circle ring, I will be safe if there are
no two disks nearby are dead.
in other words: if a disk is dead, but the two neighbor disks around
it are alive, then I will be safe.
hope this time the logic is correct....


.
