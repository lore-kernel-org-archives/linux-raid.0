Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AFEC433ED
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A4E611AD
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhEGBjE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 21:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhEGBjD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 21:39:03 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B83C061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 18:38:04 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l4so11092419ejc.10
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 18:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uNZZrqtyygmwnWCDvGTfaA/uvZhzlnvrj8WK2ToY924=;
        b=toPmdSaQK10XshvN6SoPbYTO5o8b5bZVdDmnyDxk4yBAERywQRmlFGSrczehB0bQoy
         WFgw8OfnV+qlic0Sz/6OiNq38E2gBVGalQoWQl4L6bo6DmSD0Alcem4z1Wg1mHAluQoY
         XdAlc62R3JGcxyQBdBGl5P6ycWxE3FAYOsTgshCwrFGPF3F3LnMP5p2Lt1jcmhLU2OBh
         McS38yKxJvZFQL9h28pDQbbXscRpBw/In/a7OgtFoA1be3iwD9EVxCVhf01W5Y7eWh1B
         vXc7ooWosavUdkV1uWmMfCyOogjE4FdfjEnXbqXPSZosLMWiozhh0+DirALkLt7+96K2
         grcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uNZZrqtyygmwnWCDvGTfaA/uvZhzlnvrj8WK2ToY924=;
        b=VfZ7PvnH86DglnBTVt9e3JPAEBNbVUNC95BYb8I5HufcU3nV8n0oo6bkg9ugmfCHjG
         VRJgmu/724fS+FJwIamqBe9V0b7C3MPlBTt33PpRfJ5w6WOjhYGYBSK1RgBOVq2ui8Sr
         bluby61dU3v0AewlD1w7mD5e/MzGwUy+GFWD0Jk8ho3Mkp40URZeKlmYLE0eo4U8draR
         L49okoMkcz+gh8xViX1ZoSvxpxk9dwx9kMihTRH/YFFQvgopQUy1blT7ft8oTudrfCyo
         0dGjzDCvwjnvgIu6mQFyMIi+hjPSrUgtdn5q5y7wda8bO7HL38LpsdtFsBq9CdgGYGtV
         Pigg==
X-Gm-Message-State: AOAM5338TY9ut6P3iyEXdHSGMoB8Ye3r1GXYGglp7kqO3l28W8MXMZ2Y
        K4IUW9a6EtK3fMMI2wUmqSb4WA9bL29QhqHf2stkKDAymiPQrg==
X-Google-Smtp-Source: ABdhPJz2LqS3v5fG28qRO1p5MD1Lrjr8w7UxE5kOKopbXUvY6OPUSIQSaNIhlM0IDaWTbUBb0sRNMV55ZwywF8B/zoo=
X-Received: by 2002:a17:906:19d4:: with SMTP id h20mr7589617ejd.369.1620351483092;
 Thu, 06 May 2021 18:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <24723.51054.790726.700995@cyme.ty.sabi.co.uk>
In-Reply-To: <24723.51054.790726.700995@cyme.ty.sabi.co.uk>
From:   d tbsky <tbskyd@gmail.com>
Date:   Fri, 7 May 2021 09:37:53 +0800
Message-ID: <CAC6SzHKi4Ods83AQTSz6dH87ttK8_HQ_z4Uq3iOVVc=sriBc_g@mail.gmail.com>
Subject: Re: raid10 redundancy
To:     Peter Grandi <pg@mdraid.list.sabi.co.uk>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Peter Grandi <pg@mdraid.list.sabi.co.uk>
> This looks like a "homework" question... There are a lot of
> pages on the WWW that explain that in summary and detail, and
> the shortest is: RAID10 only loses data if all devices that
> compose one of mirror set become impaired at the same block
> addresses.

 yes it is like a "homework" question. but there is not many
information for linux raid10.
like someone who test raid10,f2  and said it is fast, but others said
raid1 is faster with fio under multiple sessions.
so I always just use raid1 when I have only two disks.
this time I have a need that the two disk linux raid1 may need to grow
to 3 or 4 disks in the future. and I found:

1. raid1 can not reshape to raid 10
2. raid10,f2 can not reshape
3. someone report at the list that raid 10,o2 reshape is broken.

the above seems leave me the only option is raid10,n2
