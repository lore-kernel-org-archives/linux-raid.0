Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE41DEB64D9
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 02:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbjFPCPv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 22:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjFPCPt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 22:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA082966
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 19:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686881701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6xYSvD9QQZURxzdIVqsBRJfLtDMaMv5TbVaaTKE47g=;
        b=JFUwyxi5fHVRNfZv+K1+912qfDAmZVaFCcjFGPClaKQ6PsCzKMfdhBRXw6iHePxIesCbiP
        RXaC5yjEEeuvnyXUAr/BJRQCAdW88k6YFEOuW+1GfiOLaTs4Uq3UDNe/lICaEb2VAtd2LU
        T0k25DUzbB/wlaPppQrsk5yeQ0hYbA4=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-KEZMT644NESTu09rObVwkg-1; Thu, 15 Jun 2023 22:15:00 -0400
X-MC-Unique: KEZMT644NESTu09rObVwkg-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-39c8140b31fso307238b6e.0
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 19:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686881699; x=1689473699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o6xYSvD9QQZURxzdIVqsBRJfLtDMaMv5TbVaaTKE47g=;
        b=VWQuBQHQpjw089EAzIZGUyaPIBvYFSo0pElMgyvXs0f0vsx7e+CgS7OgpKHrPCpxJI
         79EStYa8K8+4YgG3SJ/QMiIAY4GjrkUxfSYOB98qcl6NN/hF1SQkSKp9KBBQaIZ88MhT
         PKwBfRBuO2G5uFGJrS20nkDOeQMznSyxUcEsYISjHvbPROdj3cEMierJcpbYZXZY9pGG
         PF1GYvbptSgppT6plL0G33IYaR0iHLyVa6581uw6j/RwI3u0hstgyaFrHYP4h4u9amSz
         oviMpP0PhhHOKECGa8raNgvaj5iY7czdpDfb12i+JYBG6R6YyrtanYZQWKwj9oIvIBs7
         0G3w==
X-Gm-Message-State: AC+VfDyqcDfbxG9pQ1ZETmyq0hwGyXjCIszumL4/wABkfBdWgrJPZcRD
        MCOTHDZ+yH0x+hgS1nTBwlWGC73K1p0QXWu0oHSArz7XhmgCWJn4u8SOjLgE5etnIOzoErFtseG
        i6t24oNc9WG7s8YDksqWQVSoQHiVqi1uKr9UNBekhkKzsawbGU+Y=
X-Received: by 2002:a05:6808:a1b:b0:39a:967d:347e with SMTP id n27-20020a0568080a1b00b0039a967d347emr831376oij.30.1686881699487;
        Thu, 15 Jun 2023 19:14:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6QSBkAxaid0l6V/rWfUc68X/E+zlHLQ6nRta1/pU6F0susenD5FMWbqb+rXVBpXwr/o3ZNnSitEVLW42yNyGM=
X-Received: by 2002:a05:6808:a1b:b0:39a:967d:347e with SMTP id
 n27-20020a0568080a1b00b0039a967d347emr831368oij.30.1686881699267; Thu, 15 Jun
 2023 19:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20231506112411@laper.mirepesht> <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
In-Reply-To: <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 16 Jun 2023 10:14:48 +0800
Message-ID: <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Ali Gholami Rudi <aligrudi@gmail.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 15, 2023 at 10:06=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2023/06/15 15:54, Ali Gholami Rudi =E5=86=99=E9=81=93:
> > Perf output:
> >
> > Samples: 1M of event 'cycles', Event count (approx.): 1158425235997
> >    Children      Self  Command  Shared Object           Symbol
> > +   97.98%     0.01%  fio      fio                     [.] fio_libaio_c=
ommit
> > +   97.95%     0.01%  fio      libaio.so.1.0.1         [.] io_submit
> > +   97.85%     0.01%  fio      [kernel.kallsyms]       [k] __x64_sys_io=
_submit
> > -   97.82%     0.01%  fio      [kernel.kallsyms]       [k] io_submit_on=
e
> >     - 97.81% io_submit_one
> >        - 54.62% aio_write
> >           - 54.60% blkdev_write_iter
> >              - 36.30% blk_finish_plug
> >                 - flush_plug_callbacks
> >                    - 36.29% raid1_unplug
> >                       - flush_bio_list
> >                          - 18.44% submit_bio_noacct
> >                             - 18.40% brd_submit_bio
> >                                - 18.13% raid1_end_write_request
> >                                   - 17.94% raid_end_bio_io
> >                                      - 17.82% __wake_up_common_lock
> >                                         + 17.79% _raw_spin_lock_irqsave
> >                          - 17.79% __wake_up_common_lock
> >                             + 17.76% _raw_spin_lock_irqsave
> >              + 18.29% __generic_file_write_iter
> >        - 43.12% aio_read
> >           - 43.07% blkdev_read_iter
> >              - generic_file_read_iter
> >                 - 43.04% blkdev_direct_IO
> >                    - 42.95% submit_bio_noacct
> >                       - 42.23% brd_submit_bio
> >                          - 41.91% raid1_end_read_request
> >                             - 41.70% raid_end_bio_io
> >                                - 41.43% __wake_up_common_lock
> >                                   + 41.36% _raw_spin_lock_irqsave
> >                       - 0.68% md_submit_bio
> >                            0.61% md_handle_request
> > +   94.90%     0.00%  fio      [kernel.kallsyms]       [k] __wake_up_co=
mmon_lock
> > +   94.86%     0.22%  fio      [kernel.kallsyms]       [k] _raw_spin_lo=
ck_irqsave
> > +   94.64%    94.64%  fio      [kernel.kallsyms]       [k] native_queue=
d_spin_lock_slowpath
> > +   79.63%     0.02%  fio      [kernel.kallsyms]       [k] submit_bio_n=
oacct
>
> This looks familiar... Perhaps can you try to test with raid10 with
> latest mainline kernel? I used to optimize spin_lock for raid10, and I
> don't do this for raid1 yet... I can try to do the same thing for raid1
> if it's valuable.

Hi Kuai

Which patch?

I have a try on raid10. The results are:

raid10
READ: bw=3D3711MiB/s (3892MB/s)
WRITE: bw=3D1590MiB/s (1667MB/s)

raid0
READ: bw=3D5610MiB/s (5882MB/s)
WRITE: bw=3D2405MiB/s (2521MB/s)

ram0
READ: bw=3D5468MiB/s (5734MB/s)
WRITE: bw=3D2343MiB/s (2457MB/s)

Because raid10 has a function like raid0. So I did a test on raid0
too. There is a performance gap between raid10 and ram disk too. The
strange thing is that raid0 doesn't have a big performance
improvement.

Regards
Xiao



>
> >
> >
> > FIO configuration file:
> >
> > [global]
> > name=3Drandom reads and writes
> > ioengine=3Dlibaio
> > direct=3D1
> > readwrite=3Drandrw
> > rwmixread=3D70
> > iodepth=3D64
> > buffered=3D0
> > #filename=3D/dev/ram0
> > filename=3D/dev/dm/test
> > size=3D1G
> > runtime=3D30
> > time_based
> > randrepeat=3D0
> > norandommap
> > refill_buffers
> > ramp_time=3D10
> > bs=3D4k
> > numjobs=3D400
>
> 400 is too aggressive, I think spin_lock from fast path is probably
> causing the problem, same as I met before for raid10...
>
> Thanks,
> Kuai
>
> > group_reporting=3D1
> > [job1]
> >
> > .
> >
>

