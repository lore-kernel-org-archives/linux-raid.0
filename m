Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F738C7EE23
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 02:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjE3CZ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 22:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjE3CZz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 22:25:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE85B5
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685413516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uieFtjVfb+duqtQkCjKxvaxLp1SVaQ3BfgAhKOaOwUw=;
        b=LKMR9/ioTAL5YS42nEHLwyotHbaxjxDL2ot4l8wigRagBskQWSv7hakwdJ1k76SiD6zW3d
        RjtlhlQNrA3Hkd3nWJiHOCPqGwwE3zVfccVzAZ9trzheR5SnFQKjUFH395clTbAjbayQIP
        eijCeAU6oW90qIp6pRvjxlEkfV0LxRM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-jiR4JMtHOS-ya8PXSzcnVA-1; Mon, 29 May 2023 22:25:14 -0400
X-MC-Unique: jiR4JMtHOS-ya8PXSzcnVA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b04bc1f3cbso5753245ad.2
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685413514; x=1688005514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uieFtjVfb+duqtQkCjKxvaxLp1SVaQ3BfgAhKOaOwUw=;
        b=W0iWe01W4dzUt5Ct0s/f7n2JgOeol/qRcbeXhFr6mn+nf0Ai2ArwiR3oAVgwCIm/tb
         v/t+uHw9juvAAXdwmvfRXVqyAJZUziatvzbwCZdye85Ahy58dn5bVuyzysLyLSRtXtIW
         ZvtJlFD0TmgDQgkLsyc/HSman3C/fj9JU9MarDkKo84dNwYVgQaWZRnRjZQRzRzXy3Af
         GdBzoQqY/qjku2o7yYclJNVCF6nUIQUR+PuOcMvdlZdGFkFsks2QEX1BSQRTeNQa2q+V
         LHxPN18LLrhtopw/fNdfzl93s5bQTufj7S/Q2gI0LeXpIAn1Ep14dSLje2N66TK6L8aY
         fZ5Q==
X-Gm-Message-State: AC+VfDzk6F0fht3qiJtjDxBCd09s+2rOx8o6PxCXfRRGzJMmPpN5sS1W
        eUYizSa+nbeuv9HVCq69mPvF0ELx3im5TKM2nNVdN+MBA6AhtccDLXN2nmyR7H6CfZByIxaRtDg
        WR492J+7ujfDflt65KtveUveHwG5kn4GXlO2pjw==
X-Received: by 2002:a17:902:db0f:b0:1ac:750e:33ef with SMTP id m15-20020a170902db0f00b001ac750e33efmr1244688plx.3.1685413513817;
        Mon, 29 May 2023 19:25:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4UqEXLhWR0XVLbn5s+0CiAVVT1WPczmOGN7HHfw2C+mK4xiknHx8GbmvWSaat6sdbm5vHjWKW41bleWHiG04I=
X-Received: by 2002:a17:902:db0f:b0:1ac:750e:33ef with SMTP id
 m15-20020a170902db0f00b001ac750e33efmr1244669plx.3.1685413513489; Mon, 29 May
 2023 19:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230426082031.1299149-1-yukuai1@huaweicloud.com>
 <20230426082031.1299149-8-yukuai1@huaweicloud.com> <CALTww2-yTsHXNFgkAVu0v++HHahZCnvXEUv2qJqbvcGUhKanDw@mail.gmail.com>
 <5e9852fe-0d47-92fc-f6a9-16d028d09ad4@huaweicloud.com> <CALTww28ur_S0UpGQqq0TubSgkxGG7dicc1ZKrJ3Pno4CpSOWUw@mail.gmail.com>
 <25279079-2600-b0d3-5279-caaf6f664d71@huaweicloud.com> <CALTww2-PjJ74J61jYz032t8K5tszN1tnhEbcv5h+MJjkKuVq2A@mail.gmail.com>
 <c56e7e9c-90ca-29ca-2003-1a9a88d75fa6@huaweicloud.com> <CALTww2_JAmqU19Stb1UBVVL-w=ecRFt8WNZo+TmMJVD+O2RJqw@mail.gmail.com>
 <37fc3178-c812-ee5e-bd90-34f8e0816a3d@huaweicloud.com>
In-Reply-To: <37fc3178-c812-ee5e-bd90-34f8e0816a3d@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 30 May 2023 10:25:02 +0800
Message-ID: <CALTww28kXk8-1sdiDTCa7Qbu1Uh0hDtDTuPvswORWc+5h+BP4A@mail.gmail.com>
Subject: Re: [PATCH -next v2 7/7] md/raid1-10: limit the number of plugged bio
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, akpm@osdl.org, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 30, 2023 at 9:20=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/05/30 8:58, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, May 29, 2023 at 4:50=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2023/05/29 15:57, Xiao Ni =E5=86=99=E9=81=93:
> >>> On Mon, May 29, 2023 at 11:18=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud=
.com> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> =E5=9C=A8 2023/05/29 11:10, Xiao Ni =E5=86=99=E9=81=93:
> >>>>> On Mon, May 29, 2023 at 10:20=E2=80=AFAM Yu Kuai <yukuai1@huaweiclo=
ud.com> wrote:
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>> =E5=9C=A8 2023/05/29 10:08, Xiao Ni =E5=86=99=E9=81=93:
> >>>>>>> Hi Kuai
> >>>>>>>
> >>>>>>> There is a limitation of the memory in your test. But for most
> >>>>>>> situations, customers should not set this. Can this change introd=
uce a
> >>>>>>> performance regression against other situations?
> >>>>>>
> >>>>>> Noted that this limitation is just to triggered writeback as soon =
as
> >>>>>> possible in the test, and it's 100% sure real situations can trigg=
er
> >>>>>> dirty pages write back asynchronously and continue to produce new =
dirty
> >>>>>> pages.
> >>>>>
> >>>>> Hi
> >>>>>
> >>>>> I'm confused here. If we want to trigger write back quickly, it nee=
ds
> >>>>> to set these two values with a smaller number, rather than 0 and 60=
.
> >>>>> Right?
> >>>>
> >>>> 60 is not required, I'll remove this setting.
> >>>>
> >>>> 0 just means write back if there are any dirty pages.
> >>>
> >>> Hi Kuai
> >>>
> >>> Does 0 mean disabling write back? I tried to find the doc that
> >>> describes the meaning when setting dirty_background_ratio to 0, but I
> >>> didn't find it.
> >>> In https://www.kernel.org/doc/html/next/admin-guide/sysctl/vm.html it
> >>> doesn't describe this. But it says something like this
> >>>
> >>> Note:
> >>>     dirty_background_bytes is the counterpart of dirty_background_rat=
io. Only
> >>>     one of them may be specified at a time. When one sysctl is writte=
n it is
> >>>     immediately taken into account to evaluate the dirty memory limit=
s and the
> >>>     other appears as 0 when read.
> >>>
> >>> Maybe you can specify dirty_background_ratio to 1 if you want to
> >>> trigger write back ASAP.
> >>
> >> The purpose here is to trigger write back ASAP, I'm not an expert here=
,
> >> but based on test result, 0 obviously doesn't mean disable write back.
> >>
> >> Set dirty_background_bytes to a value, dirty_background_ratio will be
> >> set to 0 together, which means dirty_background_ratio is disabled.
> >> However, change dirty_background_ratio from default value to 0, will e=
nd
> >> up both dirty_background_ratio and dirty_background_bytes to be 0, and
> >> based on following related code, I think 0 just means write back if
> >> there are any dirty pages.
> >>
> >> domain_dirty_limits:
> >>    bg_bytes =3D dirty_background_bytes -> 0
> >>    bg_ratio =3D (dirty_background_ratio * PAGE_SIZE) / 100 -> 0
> >>
> >>    if (bg_bytes)
> >>           bg_thresh =3D DIV_ROUND_UP(bg_bytes, PAGE_SIZE);
> >>    else
> >>           bg_thresh =3D (bg_ratio * available_memory) / PAGE_SIZE; -> =
0
> >>
> >>    dtc->bg_thresh =3D bg_thresh; -> 0
> >>
> >> balance_dirty_pages
> >>    nr_reclaimable =3D global_node_page_state(NR_FILE_DIRTY);
> >>    if (!laptop_mode && nr_reclaimable > gdtc->bg_thresh &&
> >>         !writeback_in_progress(wb))
> >>      wb_start_background_writeback(wb); -> writeback ASAP
> >>
> >> Thanks,
> >> Kuai
> >
> > Hi Kuai
> >
> > I'm not an expert about this either. Thanks for all your patches, I
> > can study more things too. But I still have some questions.
> >
> > I did a test in my environment something like this:
> > modprobe brd rd_nr=3D4 rd_size=3D10485760
> > mdadm -CR /dev/md0 -l10 -n4 /dev/ram[0123] --assume-clean
> > echo 0 > /proc/sys/vm/dirty_background_ratio
> > fio -filename=3D/dev/md0 -ioengine=3Dlibaio -rw=3Dwrite -thread -bs=3D1=
k-8k
> > -numjobs=3D1 -iodepth=3D128 --runtime=3D10 -name=3Dxxx
> > It will cause OOM and the system hangs
>
> OOM means you trigger this problem... Plug hold lots of bios and cost
> lots of memory, it's not that write back is disabled, you can verify
> this by monitor md inflight, noted that don't use too much memory for
> ramdisk(rd_nr * rd_size) in the test so that OOM won't be triggered.
>
> Have you tried to test with this patchset?

Yes, I know I have reproduced this problem. I'll have the v3 patchest.
>
> >
> > modprobe brd rd_nr=3D4 rd_size=3D10485760
> > mdadm -CR /dev/md0 -l10 -n4 /dev/ram[0123] --assume-clean
> > echo 1 > /proc/sys/vm/dirty_background_ratio (THIS is the only differen=
t place)
> > fio -filename=3D/dev/md0 -ioengine=3Dlibaio -rw=3Dwrite -thread -bs=3D1=
k-8k
> > -numjobs=3D1 -iodepth=3D128 --runtime=3D10 -name=3Dxxx
> > It can finish successfully.  The value of dirty_background_ration is 1
> > here means it flushes ASAP
>
> This really doesn't mean flushes ASAP, our test report this problem in
> the real test that doesn't modify dirty_background_ratio. I guess
> somewhere triggers io_scheduler(), probably background thread think
> dirty pages doesn't match threshold, but I'm not sure for now.

Thanks for notifying me of this.

Regards
Xiao
>
> Thanks,
> Kuai
> >
> > So your method should be the opposite way as you designed. All the
> > memory can't be flushed in time, so it uses all memory very soon and
> > the memory runs out and the system hangs. The reason I'm looking at
> > the test is that do we really need this change. Because in the real
> > world, most customers don't disable write back. Anyway, it depends on
> > Song's decision and thanks for your patches again. I'll review V3 and
> > try to do some performance tests.
> >
> > Best Regards
> > Xiao
>

