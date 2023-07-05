Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682CEEB64DA
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jul 2023 08:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjGEICu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jul 2023 04:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjGEICp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jul 2023 04:02:45 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733F010FA
        for <linux-raid@vger.kernel.org>; Wed,  5 Jul 2023 01:02:44 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-992ca792065so676008966b.2
        for <linux-raid@vger.kernel.org>; Wed, 05 Jul 2023 01:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688544163; x=1691136163;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tV+VIFnqvMe+DyVfuwPj7rXnweeIw0H21M7rSFW1INI=;
        b=EKr/DCUfopM2I5RG1xpJE4OVC2dXWBOwwW+lKX4lc6Gu1G9PX6widW/Rhz4q7xyDYp
         KmkKv9YeSlTHmcrZGAcwXkDG6RwQl2cqHx1yNPhM0/tkvFy6eqFFkt7PBF9Urzw82L7/
         Iy6iZO0IpC2ZsEj4w+9wyK1lsBGZlbXXYo+aAv+gcRVOVywO55RvsvW4NY9c/xA2fIuu
         fC8Qt78L3z8FFyDBglV3kK2XA28Fo+Js1mGXoS96YRoc36HWGL6Bdk3/YgZChVoGAr3G
         WYHRmKCrlA1kZX7ZsuLMX/Bzeo0nV0hlBcVZDtOHhVftsf0wFUypTqgvpxXbXk+KqCvo
         5yjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688544163; x=1691136163;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tV+VIFnqvMe+DyVfuwPj7rXnweeIw0H21M7rSFW1INI=;
        b=g6Ug7G1+si43rqqh2uJADa3pc6Hfof3kHtf1QvwNcHhCLz9aEWusOzqh5QvS8zkXYC
         ZKybIJK5wVnLPERfEJVHA94ZG8/oKf+QI5vASKYA+Ke3J2jXzV/+L1tLRnjc8jjzZH19
         wshVzHqsBXHuYMay93E+PMquIZfEiLKNP9Gi6S6VdYBSe6UgOoQne/gwoKrJcVw1ehUM
         yAsj2POLAbty3UuMQ9o4D8ypK+K622LCYqPTeBgR15YXc+nIYYPL8iQ2Wleyp6z7+Vx4
         nKcwYyh2xVEg3kBC/owgNdGkwVEfyfoxMi0NS06x17FQdnBgqk29Af/TKW6P17iKricy
         kkoQ==
X-Gm-Message-State: ABy/qLaX3Y+eSiqfC4CzSyEX0EIrxCS3YhpIISyy4Ev3c6wMvvX/hSz5
        9nyLImg3XGJO1AnhrL/dYmU=
X-Google-Smtp-Source: ACHHUZ4QDvZnDR6nZdZoLqxKFtz04fd+HGW5NtrX8oPUvcbf0AUP3lGbwgh0Xt51A5jn/uhhIp+JYA==
X-Received: by 2002:a17:907:98c9:b0:98d:f6eb:3b03 with SMTP id kd9-20020a17090798c900b0098df6eb3b03mr10188242ejc.56.1688544162685;
        Wed, 05 Jul 2023 01:02:42 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.1.159])
        by smtp.gmail.com with ESMTPSA id l16-20020a1709065a9000b00988be3c1d87sm14261287ejq.116.2023.07.05.01.02.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jul 2023 01:02:42 -0700 (PDT)
Date:   Wed, 05 Jul 2023 11:29:54 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, Xiao Ni <xni@redhat.com>,
        <linux-raid@vger.kernel.org>, <song@kernel.org>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20230507112954@laper.mirepesht>
In-Reply-To: <a8d9e0e5-d0cc-bed5-8b65-fe9fcc4c7dc4@huawei.com>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
 <20231606115113@laper.mirepesht>
 <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
 <20231606122233@laper.mirepesht> <20231606152106@laper.mirepesht>
 <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
 <CALTww2-Wkvxo3C2OCFrG9Wr_7RynjxnBMtPwR4GppbArZYNzsQ@mail.gmail.com>
 <2311bff8-232c-916b-98b6-7543bd48ecfa@huaweicloud.com>
 <20230107144743@tare.nit>
        <a8d9e0e5-d0cc-bed5-8b65-fe9fcc4c7dc4@huawei.com>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Yu Kuai <yukuai3@huawei.com> wrote:
> > 
> > On md0 (40GB):
> > READ:  IOPS=1563K BW=6109MiB/s
> > WRITE: IOPS= 670K BW=2745MiB/s
> > 
> > On md3 (14TB):
> > READ:  IOPS=1177K BW=4599MiB/s
> > WRITE: IOPS= 505K BW=1972MiB/s
> > 
> > On md3 but disabling mdadm bitmap (mdadm --grow --bitmap=none /dev/md3):
> > READ:  IOPS=1351K BW=5278MiB/s
> > WRITE: IOPS= 579K BW=2261MiB/s
> 
> Currently, if bitmap is enabled, a bitmap level spinlock will be grabbed
> for each write, and sadly this will require a huge refactor to improve
> performance.

OK.

> > +   95.25%     0.00%  fio      [unknown]               [k] 0xffffffffffffffff
> > +   95.00%     0.00%  fio      fio                     [.] 0x000055e073fcd117
> > +   93.68%     0.13%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
> > +   93.54%     0.03%  fio      [kernel.kallsyms]       [k] do_syscall_64
> > +   92.38%     0.03%  fio      libc.so.6               [.] syscall
> > +   92.18%     0.00%  fio      fio                     [.] 0x000055e073fcaceb
> > +   92.18%     0.08%  fio      fio                     [.] td_io_queue
> > +   92.04%     0.02%  fio      fio                     [.] td_io_commit
> > +   91.76%     0.00%  fio      fio                     [.] 0x000055e073fefe5e
> > -   91.76%     0.05%  fio      libaio.so.1.0.2         [.] io_submit
> >     - 91.71% io_submit
> >        - 91.69% syscall
> >           - 91.58% entry_SYSCALL_64_after_hwframe
> >              - 91.55% do_syscall_64
> >                 - 91.06% __x64_sys_io_submit
> >                    - 90.93% io_submit_one
> >                       - 48.85% aio_write
> >                          - 48.77% ext4_file_write_iter
> >                             - 39.86% iomap_dio_rw
> >                                - 39.85% __iomap_dio_rw
> >                                   - 22.55% blk_finish_plug
> >                                      - 22.55% __blk_flush_plug
> >                                         - 21.67% raid10_unplug
> >                                            - 16.54% submit_bio_noacct_nocheck
> >                                               - 16.44% blk_mq_submit_bio
> >                                                  - 16.17% __rq_qos_throttle
> >                                                     - 16.01% wbt_wait
> 
> You can disable wbt to prevent overhead here.

Very good.  I will give it a try.  And thanks for your time.

Thanks,
Ali

