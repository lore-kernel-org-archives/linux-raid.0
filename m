Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1CCC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 19 Oct 2022 21:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiJSVM6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Oct 2022 17:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiJSVM4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Oct 2022 17:12:56 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A15183E11
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 14:12:55 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so870013wmq.4
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 14:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bTMcwgLvxTXwMdVy4e7INV/GCva1XudNrNjAsIWduUg=;
        b=hWHJNrlmXH9yH2wHXtxqGeEEaTFOWMKJGZQ1sX/dejXgKmNYz+Tsu4m7oMiCpcICLm
         99bwhZCsIP0uDZL4qF4HVc42gSwyj/cogBera6WUYoePiHsQGo7/riEUVckUB5lhfvQ1
         kQmc6sd99yfU9yyLM2ayVYHeOWyU6iTgU6pKOqKhVq7otHQON1SJupbP6LX+n/GmhK3V
         FmrCcUY8pHcQnjXlQ+o2ynRslsEF61GzcCR6cmfElLO9C4gi6yil4jhECCiaYJZiBGke
         9oq6Ix/aAX0mwpfJnjwWhvxXB+RfBfvZX3PB2jQWJHi+JnBWAf16E4holjdvmGoBllQw
         ot6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bTMcwgLvxTXwMdVy4e7INV/GCva1XudNrNjAsIWduUg=;
        b=JTX1zwQfiE2u4FpxAviEhegH3GO0awYdK+0eCL6/br6ymBJWYZoP9yJR5kfZYSpn8t
         QPbiFcmeICp1NZUnppKfyLIPfdcgdTRc7vr729/nG8H01X9FmCoSzkEb3w0GrWqXfZH5
         2lwJty7X5FpS0uKUZPqr35z+QuFzyd+3bjaYIzs7kVoao5jqhc/BJcZloTWZ2YAqGYpV
         Qn1ulWmwqnVRxl9Nu1yXBd2TQ9t3SCmyS6nWcLjJ4oFGmn3uBZ1ssJWqfRZ/7J6Igfv4
         iSqvF3BqMdhVv3rVAHlPa2AWnOtwyUV+d0NyihK9P1O7VUtq1JASIfFPsT3KEZ0NBcEL
         zkBA==
X-Gm-Message-State: ACrzQf1W33A83tCG06Smp6cNIxuB5mqGv2JxoSvi5rnIJjdGW4qAdyXa
        GFKdWgDxRxzr1mMF0Fz6XjY8dfsW7Y2mhmhQXADiQQXX
X-Google-Smtp-Source: AMsMyM43l/UAexrtOWuZzbWBbjYCvDFg0hIvz3hpeDeBJxfI3uMuHYPOfuIzzBhKeOli5PkLCYVCOjzKva5Pp0k1pp0=
X-Received: by 2002:a05:600c:4f89:b0:3c2:f7a5:2162 with SMTP id
 n9-20020a05600c4f8900b003c2f7a52162mr7014078wmq.53.1666213973454; Wed, 19 Oct
 2022 14:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net>
In-Reply-To: <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net>
From:   Umang Agarwalla <umangagarwalla111@gmail.com>
Date:   Thu, 20 Oct 2022 02:42:20 +0530
Message-ID: <CAEQ-dADbUHSaZFrReJneQnxchK6GKp91epV4Cqb-7HLD6AFqHQ@mail.gmail.com>
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Reindl, All

Thanks for your reply. I do understand that. Could you please help me
understand how much hit can the write takes in such a scenario.
Any resources on how to benchmark this ?


On Thu, Oct 20, 2022 at 2:30 AM Reindl Harald <h.reindl@thelounge.net> wrote:
>
>
>
> Am 19.10.22 um 21:30 schrieb Umang Agarwalla:
> > Hello all,
> >
> > We run Linux RAID 10 in our production with 8 SAS HDDs 7200RPM.
> > We recently got to know from the application owners that the writes on
> > these machines get affected when there is one failed drive in this
> > RAID10 setup, but unfortunately we do not have much data around to
> > prove this and exactly replicate this in production.
> >
> > Wanted to know from the people of this mailing list if they have ever
> > come across any such issues.
> > Theoretically as per my understanding a RAID10 with even a failed
> > drive should be able to handle all the production traffic without any
> > issues. Please let me know if my understanding of this is correct or
> > not.
>
> "without any issue" is nonsense by common sense
