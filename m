Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CB9C433EF
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 15:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0EB9610C8
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 15:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbhIDP0F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Sep 2021 11:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhIDP0F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Sep 2021 11:26:05 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBDDC061575
        for <linux-raid@vger.kernel.org>; Sat,  4 Sep 2021 08:25:03 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id a93so4305064ybi.1
        for <linux-raid@vger.kernel.org>; Sat, 04 Sep 2021 08:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQasWPLYVrLEr5Fjp5tgVCGRaMXU6bHNE3sqnQMxBSw=;
        b=Yw++FNVTjKtqbQ2wYAHbZPcuMS/C3soA6gEDAK0KOqSZ0XAVO/MLQbdjgKP+GYJnHg
         yBkOOWRcAXm9iqT5V+705xOgY6XppvBnlJStcQen9BeorDTpmimx2uCNPoWVinBWp7km
         pa8H20cvuLYAJICk4PBmv7+plH0679HW15AfCofP4MHKdYeqUApagEwvBr47SU61WmRG
         UE1sOkxTLKHcY9Xz9JUknkmyKN3olgkUGr+Kl1C1BAk8HrySGMVGZDNQB4FdpuYpjeyQ
         jJPcF/bC0Pytz0s95sSwvCDvPVG9sxecBTxoHFEV9Uv5ICFFrB+6/3UT6E4rhqND0A9f
         RVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQasWPLYVrLEr5Fjp5tgVCGRaMXU6bHNE3sqnQMxBSw=;
        b=Lqnbx1Ijn1GL8vB/vEO4MsZuT29GeImz/nueo2uFTTyv3guDZ+jLdAQ4JcVI3B/L2u
         ZIgz77PZoDPQrlyPzCRDHJ9N6TcQggWxdS3cBn7GIZ0g44dSkxAMuV9meWFgLJfqmF0V
         DjoFhSMUky8RBlrhcMKhYzWZzad2ubw4Uira5CjCfgFQioyx7EQGqjXGu1IGP+t1lerl
         Kqr6KIzkVN6wupSA6mPdCIjhUVlIKmW88PzdFlGgfpbv7voOCxhMgvhl3VGsaRVNnOEg
         rI+J0DZbhiDFwAC99Ek00PErMnGfrPQbKXZ2tt/nJHS+dnINLBHTtjRvk4UbqmbX+WG7
         HiGg==
X-Gm-Message-State: AOAM532uZc7IkvMIJKRjCCHmGTzlgJaHbCLnD49iGFxmLH7TBAGjkdsM
        +WiH2mWbVZ6PucLNykqk7Q6CPBOesVZsr9lLx70=
X-Google-Smtp-Source: ABdhPJyQI/TxYNYyQTsQVojuHOnb7mFEH8qPZAXWQ99BU6cKCZTk9gDuA6Bit/wDWv8OEM6MaaBVy+p+McgpegzncxM=
X-Received: by 2002:a25:4f55:: with SMTP id d82mr5513634ybb.365.1630769102964;
 Sat, 04 Sep 2021 08:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
 <CAFDAVzmjGYsdgx0Yyn3n8NWVpAZQqmhBSneZY9fagV5PGTrgGw@mail.gmail.com>
 <CAPhsuW491s_6pEYRxHphgSAPVta=qPrsKXONvq03Xxv71BVx2g@mail.gmail.com> <CAPhsuW7R=8XyU5wU1-NT-Eo=Hir7gV_b7+_MB+bUFx3bEecbDw@mail.gmail.com>
In-Reply-To: <CAPhsuW7R=8XyU5wU1-NT-Eo=Hir7gV_b7+_MB+bUFx3bEecbDw@mail.gmail.com>
From:   Marcin Wanat <marcin.wanat@gmail.com>
Date:   Sat, 4 Sep 2021 17:24:51 +0200
Message-ID: <CAFDAVznS71BXW8Jxv6k9dXc2iR3ysX3iZRBww_rzA8WifBFxGg@mail.gmail.com>
Subject: Re: Slow initial resync in RAID6 with 36 SAS drives
To:     Song Liu <song@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03.09.2021 02:58, Song Liu wrote:
> On Tue, Aug 31, 2021 at 10:19 PM Song Liu <song@kernel.org> wrote:
>>
>> On Wed, Aug 25, 2021 at 3:06 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
>>>
>>> On Thu, Aug 19, 2021 at 11:28 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
>>>>
>>>> Sorry, this will be a long email with everything I find to be relevant.
>>>> I have a mdraid6 array with 36 hdd SAS drives each able to do
>>>>> 200MB/s, but I am unable to get more than 38MB/s resync speed on a
>>>> fast system (48cores/96GB ram) with no other load.
>>>
>>> I have done a bit more research on 24 NVMe drives server and found
>>> that resync speed bottleneck affect RAID6 with >16 drives:
>>
>> Sorry for the late response.
>>
>> This is interesting behavior. I don't really know why this is the case at the
>> moment. Let me try to reproduce this first.
>>
>> Thanks,
>> Song
>
> The issue is caused by blk_plug logic. Something like the following should
> fix it.
>
> Marcin, could you please give it a try?
>

Patch tested against the latest longterm kernel(as this is a
semi-production server) and 36 HDD raid6 and working fine.

Here are numbers. Without patch:

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid6 sdak1[23] sdag1[34] sdaj1[22] sdai1[21] sdah1[35]
sdal1[24] sdae1[20] sdaa1[29] sdx1[19] sdaf1[33] sdad1[32] sdac1[31]
sdab1[30] sdu1[14] sdz1[28] sdv1[18] sdw1[26] sdy1[27] sdt1[13]
sdq1[17] sdr1[25] sds1[12] sdp1[11] sdo1[9] sdm1[15] sdn1[16] sdl1[10]
sdk1[8] sda1[2] sdh1[6] sdc1[1] sdj1[7] sde1[3] sdb1[0] sdi1[4]
sdg1[5]
464838634496 blocks super 1.2 level 6, 512k chunk, algorithm 2 [36/36]
[UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
[>....................] check = 0.0% (651600/13671724544)
finish=5944.4min speed=38329K/sec
bitmap: 1/102 pages [4KB], 65536KB chunk

# iostat -dx 5
Linux 5.10.62 (large1) 09/04/2021 _x86_64_ (48 CPU)

Device r/s w/s rkB/s wkB/s rrqm/s wrqm/s %rrqm %wrqm r_await w_await
aqu-sz rareq-sz wareq-sz svctm %util
sdc 9998.40 1.40 41277.60 3.40 321.00 0.00 3.11 0.00 1.42 2.57 14.19
4.13 2.43 0.08 80.54
sdb 10154.80 1.40 41277.60 3.40 164.60 0.00 1.60 0.00 0.83 5.86 8.47
4.06 2.43 0.08 82.02
sdi 10182.80 1.40 41277.60 3.40 136.60 0.00 1.32 0.00 0.78 9.29 7.98
4.05 2.43 0.08 81.86
sdh 10002.00 1.40 41278.40 3.40 317.60 0.00 3.08 0.00 1.11 7.71 11.14
4.13 2.43 0.08 80.56
sde 9779.40 1.40 41278.40 3.40 540.20 0.00 5.23 0.00 2.10 2.43 20.50
4.22 2.43 0.08 80.10
sdj 9861.80 1.40 41277.60 3.40 457.60 0.00 4.43 0.00 1.72 15.14 16.98
4.19 2.43 0.08 81.36
sdg 10167.80 1.40 41277.60 3.40 151.60 0.00 1.47 0.00 0.95 3.43 9.68
4.06 2.43 0.08 80.06
[...]

With patch:
# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid6 sdak1[34] sdal1[35] sdaj1[33] sdah1[31] sdai1[32]
sdae1[28] sdag1[30] sdaf1[29] sdad1[27] sdac1[26] sdab1[25] sdaa1[17]
sdz1[16] sdy1[15] sdx1[10] sdv1[23] sds1[20] sdw1[24] sdq1[18]
sdr1[19] sdt1[21] sdu1[22] sdm1[11] sdp1[14] sdl1[9] sdn1[12] sdo1[13]
sdk1[8] sdh1[5] sdj1[7] sdc1[0] sdg1[4] sdf1[3] sde1[2] sdd1[1]
sdi1[6]
464838634496 blocks super 1.2 level 6, 512k chunk, algorithm 2 [36/36]
[UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
[>....................] check = 0.0% (488284/13671724544)
finish=2799.8min speed=81380K/sec
bitmap: 2/102 pages [8KB], 65536KB chunk

# iostat -dx 5
Linux 5.10.62 (large1) 09/04/2021 _x86_64_ (48 CPU)

Device r/s w/s rkB/s wkB/s rrqm/s wrqm/s %rrqm %wrqm r_await w_await
aqu-sz rareq-sz wareq-sz svctm %util
sdd 168.00 1.80 80596.80 4.40 19971.00 0.00 99.17 0.00 6.67 7.44 1.14
479.74 2.44 3.22 54.72
sdc 168.20 2.00 80598.40 6.00 19971.00 0.20 99.16 9.09 6.55 4.60 1.11
479.18 3.00 3.18 54.08
sde 168.20 2.00 80598.40 6.00 19964.60 0.20 99.16 9.09 6.69 4.90 1.14
479.18 3.00 3.22 54.80
sdg 168.00 1.80 80596.80 4.40 19964.20 0.00 99.17 0.00 6.66 3.11 1.13
479.74 2.44 3.25 55.20
sdf 168.00 1.80 80596.80 4.40 19964.20 0.00 99.17 0.00 6.62 3.11 1.12
479.74 2.44 3.23 54.84
sdk 168.20 1.80 80596.80 4.40 19963.80 0.00 99.16 0.00 6.82 3.56 1.16
479.17 2.44 3.33 56.58
sdi 168.00 1.80 80596.80 4.40 19964.00 0.00 99.17 0.00 6.67 3.00 1.13
479.74 2.44 3.29 55.78
sdj 168.00 1.80 80596.80 4.40 19963.80 0.00 99.17 0.00 6.75 3.33 1.14
479.74 2.44 3.31 56.14
sdh 168.00 1.80 80596.80 4.40 19962.60 0.00 99.17 0.00 6.72 3.33 1.14
479.74 2.44 3.29 55.86
[...]


With this patch iops dropped from ~10000 to 168 and rareq-sz increased
from 4 to 479. Resync speed increased from 38MB/s to 81MB/s.
These numbers were obtained using default kernel settings, but I am
pretty sure that I can now fine-tune it using
group_thread_cnt/stripe_cache_size to get even better numbers.

Thank you!


-- 
Marcin Wanat

On Fri, Sep 3, 2021 at 2:58 AM Song Liu <song@kernel.org> wrote:
>
> On Tue, Aug 31, 2021 at 10:19 PM Song Liu <song@kernel.org> wrote:
> >
> > On Wed, Aug 25, 2021 at 3:06 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
> > >
> > > On Thu, Aug 19, 2021 at 11:28 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
> > > >
> > > > Sorry, this will be a long email with everything I find to be relevant.
> > > > I have a mdraid6 array with 36 hdd SAS drives each able to do
> > > > >200MB/s, but I am unable to get more than 38MB/s resync speed on a
> > > > fast system (48cores/96GB ram) with no other load.
> > >
> > > I have done a bit more research on 24 NVMe drives server and found
> > > that resync speed bottleneck affect RAID6 with >16 drives:
> >
> > Sorry for the late response.
> >
> > This is interesting behavior. I don't really know why this is the case at the
> > moment. Let me try to reproduce this first.
> >
> > Thanks,
> > Song
>
> The issue is caused by blk_plug logic. Something like the following should
> fix it.
>
> Marcin, could you please give it a try?
>
> Thanks,
> Song
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2c4ac51e54eba..fdb945be85753 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2251,7 +2251,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
>                 else
>                         last = list_entry_rq(plug->mq_list.prev);
>
> -               if (request_count >= BLK_MAX_REQUEST_COUNT || (last &&
> +               if (request_count >= blk_plug_max_rq_count(plug) || (last &&
>                     blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
>                         blk_flush_plug_list(plug, false);
>                         trace_block_plug(q);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index b5c033cf5f26f..2e3c07e959c14 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1239,6 +1239,13 @@ extern void blk_start_plug(struct blk_plug *);
>  extern void blk_finish_plug(struct blk_plug *);
>  extern void blk_flush_plug_list(struct blk_plug *, bool);
>
> +static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
> +{
> +       if (plug->multiple_queues)
> +               return BLK_MAX_REQUEST_COUNT * 4;
> +       return BLK_MAX_REQUEST_COUNT;
> +}
> +
>  static inline void blk_flush_plug(struct task_struct *tsk)
>  {
>         struct blk_plug *plug = tsk->plug;
