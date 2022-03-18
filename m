Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F251C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 15:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbiCRPga (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 11:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbiCRPgR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 11:36:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122B3135097
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 08:34:56 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qa43so17664142ejc.12
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 08:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=knigga.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P422U4zjbpv4D0Cd4ar4wqz4CEnFfRxN2Uy/inuGwT4=;
        b=RHh1sABJ+PTXgRYyId+duF2QSQmnOZkXQpVA5KJlqQFzKYT7u7ktG9iq8lImx8LXIS
         EfUOepIGmRn8ARBhr5MNhx7XTllrX4KkbOOWeGnFE0J7YvNUw1pgmdKWR0iXqUHlH358
         Ro5F3ezSYPceGtjvwWBde9HqgFtSt+xYycPH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P422U4zjbpv4D0Cd4ar4wqz4CEnFfRxN2Uy/inuGwT4=;
        b=ynnq04N4h7YCagH3HcuKsdKje0i0nAqjkBxIPWfL6HeoP5VMbD6IEJaKCTRj88YTog
         ijC4s7nQtfPxliFOAK+RfvFh4hj3H9cAFeJn5PbHwgAR2ajHtvayb/LhO1RYhpInZYc4
         FgVFjIL0ZWWU8J93PxeielrmLDQK5Q+TNZx3eenZpc6CHihFpHeSI/kZxalZM+Q/b8Ry
         cOIEmM1wdAVEzIQipL3S4iW6aot3UUn4KjI0vcau90Vu9OYen58J1J4uR67fP8I0P/hL
         wf0yNxPLkQ48XOjkC/cAiEIAIM0Xb7TqGZZbsIqF6lYla6OOvuX+DEsVYopZRT7e848X
         15gw==
X-Gm-Message-State: AOAM532jHCzE3XtLoa6nzGgu6H0irYN/uxvYAV6dHhGk8uRmOKMpt4+x
        oaraA0NLQfBYgljXJa2k+AxAgRcTxaUD67eRUczoWZnI01xYeg==
X-Google-Smtp-Source: ABdhPJzoaozPIEa5U4igG7Q9Ghl1lz3lXP6lKBM6eiGK8bpQ7c6BzPfLCj6ftz8KQ4MptXfAdBET/02X377dt5iZDxk=
X-Received: by 2002:a17:907:d04:b0:6db:56be:ef8 with SMTP id
 gn4-20020a1709070d0400b006db56be0ef8mr9926408ejc.188.1647617694553; Fri, 18
 Mar 2022 08:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAKhSdW1zghNFqn2qemMZ7FJpiBcbAd0BcYifHmcM8WWPnai-=g@mail.gmail.com>
 <20220314115809.00007ac1@linux.intel.com> <CAKhSdW3v-e6N8GA2Sq=qurACA9S1f5Bsf9pSq6oL1YH4aSR+=g@mail.gmail.com>
 <20220315143338.00000394@linux.intel.com>
In-Reply-To: <20220315143338.00000394@linux.intel.com>
From:   Kristoffer Knigga <kris@knigga.com>
Date:   Fri, 18 Mar 2022 10:34:18 -0500
Message-ID: <CAKhSdW1PMF=S2V4RCC4ojLb97W3xiVnZG450XLazMhrLpW+L4w@mail.gmail.com>
Subject: Re: mdadm is unable to see Alder Lake IMSM array
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I can't take the challenge at this moment, but I won't block adding such feature in upstream. I can give some suggestions and help with review.

Thanks for the information and your help shedding light on my issue!
