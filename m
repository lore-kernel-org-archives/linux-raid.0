Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C23C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 16:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241801AbhLIRDS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 12:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241893AbhLIRC6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 12:02:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD07DC061353
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 08:59:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E55ECCE2736
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 16:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CEEC341CD
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639069161;
        bh=x0cChlZc8ylaix83JzriZfHctX0WqnNn+d8RY8f6miM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AWvhiIrsEHZKXPnhvg0rISrBiKU2kenghFrH2sVQmFTMn5JBfYq1LrTUMbxMQECuM
         kK5nwo7Pfe3c+xy/jYaV0fSjkUPMvy/r5RufI3oGOjU+tdtKRKeW8qdFCnDa0ADDbR
         BwkUGPMx1YrSVodIo4Nj9KAUw9gh6Am0P9wAFcM8u1aNY6Q6UsAYCR2NSKAYPdNOSu
         54KSNtyseCQjBpPlsCYnUepS8BS2G/bjVgkVmzU3lAgqxuFdt+VKJuwXEtCBH3pZou
         lqGk/iu3A+JTFIwm7Jow0tYUddazFAFVgTnfSxFZ6COwebcMDrC2vqP01D2yjbHK1z
         hkKoN8ow8n1DQ==
Received: by mail-yb1-f174.google.com with SMTP id d10so15204543ybe.3
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 08:59:21 -0800 (PST)
X-Gm-Message-State: AOAM5307+Hvm+KRu1cJry9gmuGtBsLbhQse6AW0cag6vYdkRIhZTqaIq
        ZRkAt+aixDF7a5r8WvIw2cu4ZDjKgxc+gJQTvXw=
X-Google-Smtp-Source: ABdhPJyhzwYSKkqB24yYHv6PhCsZ6rY4fJbj1jgYqz1o+xL/8GToWHAKwMNLlK5oYToDfq/K9vV7fGizAiDtjriI2aI=
X-Received: by 2002:a25:4d84:: with SMTP id a126mr7847997ybb.654.1639069160154;
 Thu, 09 Dec 2021 08:59:20 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW7=r4AmCqG3M0hU=fps6a-Zu9KF_RnyNf815d=43wTv5A@mail.gmail.com>
 <f8c2a2bc-a885-8254-2b39-fc0c969ac70d@digitalocean.com> <CAPhsuW54EJOfAXrE-zVie561n+aF-+jvQz1152rqj=kU5Fk5ug@mail.gmail.com>
 <9fb2e648-9a6e-c4c0-4fe9-3e2a92ecd8d6@digitalocean.com>
In-Reply-To: <9fb2e648-9a6e-c4c0-4fe9-3e2a92ecd8d6@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Dec 2021 08:59:09 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5cfy1+9YOT2620KycBN0juQN1ZKUewygqxK21BqQAyxg@mail.gmail.com>
Message-ID: <CAPhsuW5cfy1+9YOT2620KycBN0juQN1ZKUewygqxK21BqQAyxg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 9, 2021 at 8:53 AM Vishal Verma <vverma@digitalocean.com> wrote:
>
[...]
> >
> > Song
> >
> > Hi Song,
> > Did you get chance to look into this? It looks like I am bit stuck here. The other option I am thinking is if we just add a flag for enabling nowait and enable it by default for raid1?
> >

I am sorry for the delay. I will look into this and get back to you
early next week (or sooner).

Song
