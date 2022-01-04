Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6858AC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  4 Jan 2022 23:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbiADXal (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:30:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234152AbiADXal (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Jan 2022 18:30:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641339039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDT78lxxyYpi6memYHgpx5yzuIgibQmZrcVkx8OKH/Q=;
        b=ZByfZ8Y+zdHiYoHP8xcro00Gw99v/nXjtIJQfdDjihHGilRprCVNcmo3SKnDFdVhD+Yvp0
        hPYja5QAhL4/0jgIr1XYkNyPiBlOu3IDS3xUdxUPsxsZetvhtt+2n/VtW4mwWrMmXB/SJ7
        2NEheF07PkIPR0FhMl2iLKaAll9GcQw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-YNFXEfzZObG47lHmv4CyfQ-1; Tue, 04 Jan 2022 18:30:37 -0500
X-MC-Unique: YNFXEfzZObG47lHmv4CyfQ-1
Received: by mail-pg1-f198.google.com with SMTP id u37-20020a632365000000b0033b4665d66cso20426442pgm.18
        for <linux-raid@vger.kernel.org>; Tue, 04 Jan 2022 15:30:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=jDT78lxxyYpi6memYHgpx5yzuIgibQmZrcVkx8OKH/Q=;
        b=MZlKeEE+DOPpr451QRP4W7tHEMPD22fkg7zeP3KqRygpd7YkSXpaRSvDck2LKa74QE
         hPV2BtHAjSfRYkjbhwiHk1OWzbn9M78+RLU0NprFAtEeLz8v4ZdzxLrHU0vBTe/CMkcB
         fBfGLAbAKXzFYNItAtEH0AbPVFiZ2RUol/1rOs/kuaV1sBcybQ2pPf1L68UqOBmnUCWt
         l4Nn8K3WUr9AvrZwF2P/9sUAIvjJe3wbAmed69yaWWgmDZ++nW9JXxbb2L1RGmXExSt5
         XepD2SXszWrczHa+oz7zaCymwzyx7hDX09p2XkhV01HvYyOOyI1YozJ9vAWZGN040EZv
         N5jw==
X-Gm-Message-State: AOAM5327EdmbJr9wxuxvOrGL3ACe5HFHqwBujXLc+XS2AmuLumTltrnK
        Asxfubj8Cyh/YY76oCbYvfvhZlwUAztjjx9LS7a/HdDAexigKjIeQzSN3dVF7VknQckRWJig0CK
        q2m/4TT42B/5pYqkO9OsbvA==
X-Received: by 2002:a17:90a:6d23:: with SMTP id z32mr851076pjj.144.1641339036883;
        Tue, 04 Jan 2022 15:30:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJys1vJ4lHVKFe0cHn3ZUz5tp3yxOQka6NdrypCweHYmxBQOW/kdoHDJektYhlsvc3r8LFZieg==
X-Received: by 2002:a17:90a:6d23:: with SMTP id z32mr851067pjj.144.1641339036651;
        Tue, 04 Jan 2022 15:30:36 -0800 (PST)
Received: from [10.72.12.249] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t126sm35249032pgc.61.2022.01.04.15.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 15:30:36 -0800 (PST)
Message-ID: <6bb93ce0-30e0-ff3b-9457-470496f7b1bc@redhat.com>
Date:   Wed, 5 Jan 2022 07:30:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 0/2] md: it panice after reshape from raid1 to raid5
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
References: <20211210093116.7847-1-xni@redhat.com>
In-Reply-To: <20211210093116.7847-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

Ping. Do I still change something else?

Regards

Xiao

在 2021/12/10 17:31, Xiao Ni 写道:
> Hi all
>
> After reshape from raid1 to raid5, it can panice when there are I/Os
>
> The steps can reproduce this:
> mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1
> mdadm --wait /dev/md0
> mkfs.xfs /dev/md0
> mdadm /dev/md0 --grow -l5
> mount /dev/md0 /mnt
>
> These two patches fix this problem.
>
> Xiao Ni (2):
>    Free r0conf memory when register integrity failed
>    Move alloc/free acct bioset in to personality
>
>   drivers/md/md.c    | 27 +++++++++++++++++----------
>   drivers/md/md.h    |  2 ++
>   drivers/md/raid0.c | 28 ++++++++++++++++++++++++----
>   drivers/md/raid5.c | 41 ++++++++++++++++++++++++++++++-----------
>   4 files changed, 73 insertions(+), 25 deletions(-)
>

