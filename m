Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180F5C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 00:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D546461157
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 00:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhDHAMw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Apr 2021 20:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhDHAMw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Apr 2021 20:12:52 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB15AC061760;
        Wed,  7 Apr 2021 17:12:41 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id u13so47451lje.0;
        Wed, 07 Apr 2021 17:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KAcjHGLsto88UrTpLpRBFeL9IPEKet+SfI2XYWyvT40=;
        b=EA33CSNEuu2VwzHlbwqxrx43n/de42qxIh5TZXQTQ08PM5Qqk1oZGWp4lwjZwb+Mrg
         PoQi1Gh421CpJLtRAzMNsYCT5Q1LZgugsdjhImwvdTLW4kTZxq1qLH4+6q8j1VPPZdfZ
         tyROBEOPK5+C32uMqS1Y6/0ORWM5dBh+Qe4UDl/0xBPfu6POf6WtC9CHfrJYbcv0iA+o
         9791ki7LqZegr/Cos0cet0sIm2CA6/cc6C973hSrBl1Y4uKM8lYtfHFWRA2XbenNG5NN
         UCqQTR+Gy1B1D3k1FDBBONSjsc7aup/hfZsFKGTJDly1wraZtIaIIeq01ifyXi64lBUh
         0DZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KAcjHGLsto88UrTpLpRBFeL9IPEKet+SfI2XYWyvT40=;
        b=i9PjaY1v6Gbo/ucwoypq+xFuDtCdsHdwgktPuI143hzQ0fB6WgbjAp9tuu4vy9fB7w
         dXdjixfzJtBxMIaKTAkIzaujZbB1PRZLOHpKH3PluuV00dMAlryqyYbmGFQ+QJU0UYEN
         3IgI7VdvjyFCoGZS9rjdUJtC3+w+279whHPbdKcCexqdZOI6n3HWQAPM3cNUgEKzN6JX
         jdJmBHk7jzEIo/nXrsn/j+YCG8w/5XXsOhp6WXBRCQhuxOAat9d4HTwdPNCDlK3AKRdt
         HolffigQ6s8X96YNLmLysIBCMefaqTp/uNGDqQLVMsq0lrzHM0N/N2DpqnYfzugHeLg/
         LjSw==
X-Gm-Message-State: AOAM533bxsSDdMeYDU/v+BGCv8ffwwfBF3a2If3n64degoNeQHmFupeV
        Saqhxs9LoKSrHjBMYxWWE7etChIzP2339SrRChH6tUW/EIM=
X-Google-Smtp-Source: ABdhPJxtkGTsJJQmX94lOzH+9Ybh47fLsGatv9S5ZYl//O1mKwSdqZOQMN0G1QkEnl0DTA8kGSVGMKbA0vICUeW/AJk=
X-Received: by 2002:a2e:921a:: with SMTP id k26mr3837432ljg.149.1617840760304;
 Wed, 07 Apr 2021 17:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <16ceff73-1257-fc3d-aade-43656c7216e7@molgen.mpg.de>
 <12e8f7f1-6655-9f0b-72b1-0908f229dcac@molgen.mpg.de> <b5eb567d-9866-8f0f-ea61-83ae97d4d21f@molgen.mpg.de>
 <CAAMCDedmGUcWY=9Nb36gXoo0+F82rhq=-6yKZ1xPf74Gj0mq7Q@mail.gmail.com> <e5d4dd39-7d75-77c6-abc8-8c701b9066fd@molgen.mpg.de>
In-Reply-To: <e5d4dd39-7d75-77c6-abc8-8c701b9066fd@molgen.mpg.de>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 7 Apr 2021 19:12:29 -0500
Message-ID: <CAAMCDecxjX5d20Ra7PVgsSM6xg3f2D5q=-x3eeFosfFfnbJxbg@mail.gmail.com>
Subject: Re: OT: Processor recommendation for RAID6
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, it+linux-raid@molgen.mpg.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I ran some tests on a 4 intel socket box with files in tmpfs (gold
6152 I think) and with the files interleaved 4way (I think) got the
same speeds you got on your intels (roughly) with defaults.

I also tested on my 6 core/4500u ryzen and got almost the same
speed(slightly slower) as on your large ryzen boxes with many numa
nodes, so it has to be effectively only using a single numa node and a
single cpu.

I did test my 4500u ryzen machine with fewer cores enabled,  1 core
got 18M, 2 cores got 23M, and 3 got 32M so it did not appear scale
past 3 cores.

I also testing on an ancient a8-5600k and was almost the same speed as
the ryzen.

From the calls there must be a lot of reading memory.   And I got the
same speed using shm, using tmpfs, using tmpfs+hugepages and using
files on a disk that should have been in file cache.
