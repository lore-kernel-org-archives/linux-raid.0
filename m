Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B26C433B4
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 09:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B5E61157
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 09:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhEFJ6b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 05:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhEFJ63 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 05:58:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF7AC061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 02:57:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id t4so7450216ejo.0
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 02:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s3c8ts/Y8MyxKMOUDa2u8BfyvnchBXo3B8pkZP55ZFo=;
        b=d4IjYv0+e0jwV11YToZ9/hrqsdSSK+BqLrvU6rqh3+H6eEuQjCosyZos/bWzGCC/Qz
         21tR9KVk7ytNKiAhCF5k1nSdf5RPOgG/c0F59Qe5tc3BXhjCIBcp3glSlUK8D/3Q5T8Z
         IXXI4lRHJwQc0fmxzgdacl8tzrPxFq8LVbaoYtY3vAXLM6ouddvlPlsL7K7Bj9a4hcZZ
         I0W+G8olxD0BlwIfnF6jBWTS3TiTyXXjHJnqtZvkGkc+0ErWuoJFH8onMMyZFaYpMVCv
         M0mDg8xnMtNOeZRimK2ebWXQpuwBmFdbA0sss5pzeT2Ix6XfwJ5+ymzWbvZB5qgfwL3k
         AQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3c8ts/Y8MyxKMOUDa2u8BfyvnchBXo3B8pkZP55ZFo=;
        b=boMlJNtGoWmsjMkRvmqdMbJXPvpkkR25Nt9UajVYTwPGxtfUdVjDHMJfZLfF37Id6G
         emZ0a0aY1tTb2ND88PeqJMIE7BNDkAIXA6m9daELbbHWGsXp4aYgntcaRME9LSXaVKBt
         AyXJNjUXWmsyaZNvb9I6JUqGCjGXzD1nu6FJlOQBtPdRxit7MlrCxT/gSjov8M2nmLuP
         ezFhzFxW4ay2QKsSnZlBkq3RXNXXVurDJYluWaUKWeY2IavEWTxRCZkcqR/0soTdrly2
         F3jsWxOHmenjK7L7fo53MwaGPLeXDI85s1mjFoGqmpDU9vra0JLJcyMdr48lrLlYBXP9
         FtsA==
X-Gm-Message-State: AOAM532n/7xr/8y9OtdZ/ero2ye0R2qP9DzRnZlnsg4kLLIqXgx+ze7v
        HliGpjDUtm2bw3gYdggSG56O1E5CvU+6fAMrByCWktC9Z9qYYw==
X-Google-Smtp-Source: ABdhPJxHGwWYoDRQmwh3tcWDhuaFz5251/iwgIMHZ5iZdEfH/d1T9mSZR6OGY5zwzerRW98TNcScQBA/+4Pm6vJzkBw=
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr3538298ejb.239.1620295047853;
 Thu, 06 May 2021 02:57:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
In-Reply-To: <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
From:   d tbsky <tbskyd@gmail.com>
Date:   Thu, 6 May 2021 17:57:17 +0800
Message-ID: <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
Subject: Re: raid10 redundancy
To:     Xiao Ni <xni@redhat.com>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Xiao Ni <xni@redhat.com>
>
> Hi
>
> It depends on which layout do you use and the copies you specify. There
> is a detailed description in `man md 3`

Thanks a lot for the hint. After studying the pattern I think n2 and
o2 could survive if losing two correct disks with 4 or 5 disks. but f2
will be dead. is my understanding correct?

will n2 and o2 be promised with the same pattern even if I grow the
disk numbers, like 3->4, or 4->5?

if losing two disks will madam find out the raid can be rebuilded safely or not?

I should try this myself, but I hope I can get  some knowledge before trying...

Thanks again for any help.
