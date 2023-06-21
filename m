Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DD3EB64DC
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jun 2023 08:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjFUIGq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Jun 2023 04:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjFUIGo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Jun 2023 04:06:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5A01710
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 01:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687334754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SmpiQrW/36L5XtxJ67zoG5/pz2I7z9TMHF7I9YHTLT0=;
        b=T8U3v9D0NMSujlPv2YBjHLX3Z4e3b7gl5o+rQlskWdQA93/xRBVi5Cw4BsguG8bBqmC5ha
        ksMD5JDPVHF6d6NL5439KZHMm4IegGJSSMlu6N7oFLp7uWwkRFFNaR21VKxL52kFW/VG1x
        L9vROqfJ60I2IKFA0CxWYVHIcVwo7Gs=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-dz7wd2NhOsul3io2BGFObQ-1; Wed, 21 Jun 2023 04:05:53 -0400
X-MC-Unique: dz7wd2NhOsul3io2BGFObQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-25e7fe2fb9bso2605965a91.3
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 01:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687334752; x=1689926752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmpiQrW/36L5XtxJ67zoG5/pz2I7z9TMHF7I9YHTLT0=;
        b=lGhd3Bcirb06Jeg0w/y6EGSuEo4kvmKTfmU9PpwvwQlJFuV/WZnqbD29eHrW/90XAQ
         GiaE5PsbzabzzgOrKvH3qpWYEu/5DJbeDkLWdUbl4IIL4m8YzWyXUeFVqCLl5akPdVTE
         qSHWCGFrHU4z3tpf3J9dBfSNUjOdIPzZ+ZwpOFtPMlsbjPEo6QkD77pEA5vED25nCTsF
         YLRgozLfQE+u2lpGA+JN/k+r1Q7V7FrvqdKPp9PPrwY9ZpPat4UAKLJCerJaJ6OqgZ5u
         YCy5VirXDLhy3DZhG+0kdePRJYzZQ+ySFnhPzv3K43FxUXn+nAk5vmAd41wummmp6h2U
         RveA==
X-Gm-Message-State: AC+VfDwbzGkuKjRcdUw1zDYdCQNydB+0zF2sGuGmnfyI4zambcYZnbBN
        R+OMViFcqTYMmyCCuWhTxSBofd34Xwk9LQGFh7xHaCzjuQzplkGL0wFy35rhpryDRu7Hrlm1TVE
        wOt6fk26rxAStZB8MAYmmekCgsFG8fBUK+t1abQ==
X-Received: by 2002:a17:90b:3714:b0:261:688:fd91 with SMTP id mg20-20020a17090b371400b002610688fd91mr58389pjb.8.1687334751995;
        Wed, 21 Jun 2023 01:05:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5l9++WNyHb+kK2VjV9yo1dqDGOwYCEafJqgK6WmdqH7cSQYAa3VZPHTzQjsbi8cvckD8oN0ynxd7VmJ9emLSs=
X-Received: by 2002:a17:90b:3714:b0:261:688:fd91 with SMTP id
 mg20-20020a17090b371400b002610688fd91mr58381pjb.8.1687334751700; Wed, 21 Jun
 2023 01:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20231506112411@laper.mirepesht> <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com> <20231606115113@laper.mirepesht>
 <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com> <20231606122233@laper.mirepesht>
 <20231606152106@laper.mirepesht> <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
In-Reply-To: <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 21 Jun 2023 16:05:40 +0800
Message-ID: <CALTww2-Wkvxo3C2OCFrG9Wr_7RynjxnBMtPwR4GppbArZYNzsQ@mail.gmail.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Ali Gholami Rudi <aligrudi@gmail.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jun 16, 2023 at 8:27=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/06/16 19:51, Ali Gholami Rudi =E5=86=99=E9=81=93:
> >
>
> Thanks for testing!
>
> > Perf's output:
> >
> > +   93.79%     0.09%  fio      [kernel.kallsyms]       [k] entry_SYSCAL=
L_64_after_hwframe
> > +   92.89%     0.05%  fio      [kernel.kallsyms]       [k] do_syscall_6=
4
> > +   86.59%     0.07%  fio      [kernel.kallsyms]       [k] __x64_sys_io=
_submit
> > -   85.61%     0.10%  fio      [kernel.kallsyms]       [k] io_submit_on=
e
> >     - 85.51% io_submit_one
> >        - 47.98% aio_read
> >           - 46.18% blkdev_read_iter
> >              - 44.90% __blkdev_direct_IO_async
> >                 - 41.68% submit_bio_noacct_nocheck
> >                    - 41.50% __submit_bio
> >                       - 18.76% md_handle_request
> >                          - 18.71% raid10_make_request
> >                             - 18.54% raid10_read_request
> >                                  16.54% read_balance
>
> There is not any spin_lock in fast path anymore. Now, looks like
> main cost is raid10 io path now(read_balance looks worth
> investigation, 16.54% is too much), and for a real device with ms
> io latency, I think latency in io path may not matter.

Hi Kuai

Cool. And I noticed you mentioned 'fast path' in many places. What's
the meaning of 'fast path'? Does it mean the path that i/os are
submitting?

Regards
Xiao

