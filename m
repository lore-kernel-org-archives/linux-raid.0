Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CE6EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 06:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjFPGIQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 02:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjFPGIP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 02:08:15 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FE6B5
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 23:08:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-982ae93386aso43452966b.1
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 23:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686895692; x=1689487692;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e1eAt+x9LM9xXOUFv/Zi6YGasT3KMYOgJHBRKa5/ge0=;
        b=D/EsZN9n0waQcd9RGFqwpU6iKgzL9vZN0f8dXwZ7OVkWjBhrIiQO//uiMI8mNLVdr2
         FYi0BrCo5MjI3FQjPCBGeP7DlD4sdZOASbtxSMPoEKeg5zHCOggK2Q9w663EAfIjl/RR
         8SELJJgb/tr0idPe06dWDetAufKOu9YmIdJ8IH5TV6s/vBuw8zaxsY6rDOmrvKRIOLJJ
         d36E9vQFhWUWjv3aN34SE1XmIxTmgr5Uf0lAvdp/ryDJWW3CcYDdvbUtctErJAJR0cy5
         oH6GXE2AWF0b2CSdX9GWGRqCNLmiFT/W9elHzVkzQMzG8iXF2rsngUG8DWikT2iwiWkb
         PGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686895692; x=1689487692;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e1eAt+x9LM9xXOUFv/Zi6YGasT3KMYOgJHBRKa5/ge0=;
        b=JzzbrZY2hG4JV8yL1jBC6HCNWCeVe/ES7Pw7yeUanQAFTTJXdQGkeLzzaxhpCQF98X
         SWCv9j10vZNUNt9/xz9LqsSz+YIJho4Ha2iv3Ie2MZ/F8eNQA+8PxzT5OTlqTyDWXygI
         ZIR1wo1WW4yAYYyTYPW3PKNeGM4M/lDYpk8xEChnlGrOgQvDcWuneoLW1Cdq6/SgrL7a
         r/W90EpIjSeSt9A0RxMqf+Dw1kNFndZjejjQDm4HukkLyqnC9h8MnoyLnMx/d+kuIl6W
         1VmPagSDdnqA4Oo6JE/0nlF9MolovBW94EKBBYvHZ3QaX/M4YVuuWfkF5OX/NGP1idOG
         2DeQ==
X-Gm-Message-State: AC+VfDzqgukE4Ik4L4LstsdfS1/8snBdSXOX4oHeJBfuu6alqcEzqmnK
        G70zNjUNbqNglTEx6/gZStU=
X-Google-Smtp-Source: ACHHUZ4pg4ia/+IvwUEcB7ZoSxJtSUDVsLwjIhvPcR7PjAOra+I9/T79rFFDR3ncjDJTH26gHXRPVg==
X-Received: by 2002:a17:907:3187:b0:96f:c0b0:f137 with SMTP id xe7-20020a170907318700b0096fc0b0f137mr997941ejb.16.1686895691636;
        Thu, 15 Jun 2023 23:08:11 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id bt16-20020a170906b15000b00977cc21ddd8sm10415029ejb.54.2023.06.15.23.08.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Jun 2023 23:08:11 -0700 (PDT)
Date:   Fri, 16 Jun 2023 09:22:35 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231606092235@laper.mirepesht>
In-Reply-To: <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
References: <20231506112411@laper.mirepesht> <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
        <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On Thu, Jun 15, 2023 at 10:06 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
> > > FIO configuration file:
> > >
> > > [global]
> > > name=random reads and writes
> > > ioengine=libaio
> > > direct=1
> > > readwrite=randrw
> > > rwmixread=70
> > > iodepth=64
> > > buffered=0
> > > #filename=/dev/ram0
> > > filename=/dev/dm/test
> > > size=1G
> > > runtime=30
> > > time_based
> > > randrepeat=0
> > > norandommap
> > > refill_buffers
> > > ramp_time=10
> > > bs=4k
> > > numjobs=400
> >
> > 400 is too aggressive, I think spin_lock from fast path is probably
> > causing the problem, same as I met before for raid10...

In our workload, we run about this many KVM guests on one machine, and
when many of the VMs use their disks, we experienced almost the same
problem with raid1.

Thanks,
Ali

