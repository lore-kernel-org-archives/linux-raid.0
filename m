Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5832EB64D7
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jun 2023 08:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjFUI71 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Jun 2023 04:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjFUI67 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Jun 2023 04:58:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFC226A2
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 01:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687337768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIW9wSCbs9qZr3XvUeQESLZXuIlh9VhVB1GBvIHMkIM=;
        b=T4beZQmJHe9R7O6abRgVKkgd0SY3C7698yDLM8pH3yAMyDvYYoPOFMA/KuU+UWArARNOY2
        h2ZN6aRTNcIIHd3huu3RPNomS9mzs34QFzk+cg0obGxOsZzyukW35Ef+YTVGErFg8+ygB8
        ShO3eA18FsxWc07yCrdeIMTtfmYHoKA=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-gw2HIkHnMxOwn0duL-k3ig-1; Wed, 21 Jun 2023 04:56:06 -0400
X-MC-Unique: gw2HIkHnMxOwn0duL-k3ig-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-39ecef7a101so2830405b6e.2
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 01:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687337765; x=1689929765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIW9wSCbs9qZr3XvUeQESLZXuIlh9VhVB1GBvIHMkIM=;
        b=OTQIC4OEonaX3hchv6/+GnunLJQ6TlF2V9U8IPZRSIjZ4oiy34ZJNBv6SrXXJXHPhr
         cDTcNfJbyczPzCLTDtN98G+tBDoVQPfJTpyxbA/2A8x92d9De38tBm6k/lqcTYbm+jpN
         tIxQhBvV8oP37nrL7evHEbITpx7b7AGrc/brAOGD95xJmHcn9US7eb4duV5VAyfP7t70
         Hrqrhz2Th1CbrfbHEnU5Uhj7smYQUGBQdU/LdYVSw/H3W96ExfFEurXAJ5GPxg6vRhHj
         utpbRWGiHleJI//F/j/NsHfErjjBykLEeqSbhdT7+1ts+PNgImnwnPEm68tYirR0TNrx
         V97Q==
X-Gm-Message-State: AC+VfDzZc/zc3bgw4ynwh8X5xHh3v0gnPKm+mZWUPHZq1B17H85SGgEL
        qGBOk7fd5g0lN4L/B2H8lL5OdPXd1Mjwsys39VZ0g4edS0DWEcsL76GiH3eurtIt8IZkMtldYfQ
        0j6jVpaXHTs2t8RA29HBq4mGR9W724jXdEYU5tg==
X-Received: by 2002:a05:6808:9a1:b0:39e:cc6b:62d4 with SMTP id e1-20020a05680809a100b0039ecc6b62d4mr7621446oig.49.1687337765740;
        Wed, 21 Jun 2023 01:56:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4NJRmwAekMA2ikxEJO2WJ8IWK4016DIQM4Nw7dmTzty0sQuZXJ4u6HZ+co9a+Z0ZK8rbbdMAzqUo+ALFOpJrY=
X-Received: by 2002:a05:6808:9a1:b0:39e:cc6b:62d4 with SMTP id
 e1-20020a05680809a100b0039ecc6b62d4mr7621436oig.49.1687337765504; Wed, 21 Jun
 2023 01:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20231506112411@laper.mirepesht> <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com> <20231606115113@laper.mirepesht>
 <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com> <20231606122233@laper.mirepesht>
 <20231606152106@laper.mirepesht> <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
 <CALTww2-Wkvxo3C2OCFrG9Wr_7RynjxnBMtPwR4GppbArZYNzsQ@mail.gmail.com> <2311bff8-232c-916b-98b6-7543bd48ecfa@huaweicloud.com>
In-Reply-To: <2311bff8-232c-916b-98b6-7543bd48ecfa@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 21 Jun 2023 16:55:54 +0800
Message-ID: <CALTww2_1Wf4h-ZJZ5GRiE_Ae8YjQwv1iXp47NA-X_88J4YGDoA@mail.gmail.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Ali Gholami Rudi <aligrudi@gmail.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 21, 2023 at 4:27=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/06/21 16:05, Xiao Ni =E5=86=99=E9=81=93:
> > On Fri, Jun 16, 2023 at 8:27=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2023/06/16 19:51, Ali Gholami Rudi =E5=86=99=E9=81=93:
> >>>
> >>
> >> Thanks for testing!
> >>
> >>> Perf's output:
> >>>
> >>> +   93.79%     0.09%  fio      [kernel.kallsyms]       [k] entry_SYSC=
ALL_64_after_hwframe
> >>> +   92.89%     0.05%  fio      [kernel.kallsyms]       [k] do_syscall=
_64
> >>> +   86.59%     0.07%  fio      [kernel.kallsyms]       [k] __x64_sys_=
io_submit
> >>> -   85.61%     0.10%  fio      [kernel.kallsyms]       [k] io_submit_=
one
> >>>      - 85.51% io_submit_one
> >>>         - 47.98% aio_read
> >>>            - 46.18% blkdev_read_iter
> >>>               - 44.90% __blkdev_direct_IO_async
> >>>                  - 41.68% submit_bio_noacct_nocheck
> >>>                     - 41.50% __submit_bio
> >>>                        - 18.76% md_handle_request
> >>>                           - 18.71% raid10_make_request
> >>>                              - 18.54% raid10_read_request
> >>>                                   16.54% read_balance
> >>
> >> There is not any spin_lock in fast path anymore. Now, looks like
> >> main cost is raid10 io path now(read_balance looks worth
> >> investigation, 16.54% is too much), and for a real device with ms
> >> io latency, I think latency in io path may not matter.
> >
> > Hi Kuai
> >
> > Cool. And I noticed you mentioned 'fast path' in many places. What's
> > the meaning of 'fast path'? Does it mean the path that i/os are
> > submitting?
>
> Yes, and fast path means the case all resources is available and io can
> be submitted to device without blocking.
>
> There should be no spin_lock or atomic ops in fast path, otherwise io
> performance will be affected.
>
> Thanks,
> Kuai

I c. Thanks for the explanation.

Regards
Xiao

