Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE6BC4332F
	for <linux-raid@archiver.kernel.org>; Mon,  7 Feb 2022 15:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiBGPjZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Feb 2022 10:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345400AbiBGPcv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Feb 2022 10:32:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8BBC0401CC
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 07:32:50 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k17so11444094plk.0
        for <linux-raid@vger.kernel.org>; Mon, 07 Feb 2022 07:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=ZvWZy9mE27MNgxwLhTNfU4mtxy4kULxtW8tVXPOu4T0=;
        b=KHJtydIE7hcZQm/PsqLHwWqhg32yd1WpA9XfrQETv0Z91fwQJBw3uPloGpZkTHLQbZ
         Z/6R9K/hSbNM3O66+9kpmVVrSsx2R2iwdLe6BvzUseNlCVJn6aXT3Z0/JAIPYTWuB+rZ
         G0BDL2dgoSa6qhjTud+CNAUK6YTw7SeRlyFM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZvWZy9mE27MNgxwLhTNfU4mtxy4kULxtW8tVXPOu4T0=;
        b=gxpgr26dDMLu2J6XO7130AiCH/6v9mzS9OedIP+sI5Zons2YrP4TdtBsY80CTC6D5S
         QiC7B7y2uuiAcE0psJ/uhUridWaSl1Dx4POfLY33rRwpih7gXAaBoPNKaWHqWKk56J4D
         VbGaOg31svOlCstHXhEsjA7T7/Uh/OYkUVeBGd3a8xTfih1bMKQDSbJhDU5buIgg21I1
         uRKagnje+sflAp4rO3qQYLHgDAsJcZMg0AVXVHTww2fspIwJwu5wuLW7TPrfjSqkMoqb
         B49M5hHmFH3yx73Sp2LDl6s+emvwoi2La8oIp+xNVmFg0Cl1dw1wAXib9iODIchAgsR8
         d/6Q==
X-Gm-Message-State: AOAM533q9lPz87I/wPHLIzecBwHhxbI6KdMrti5teR5YP2JkxN2g7FaZ
        WyYQ8b0PgxLT32EhAbRiiP1M0rJzlGLEbw==
X-Google-Smtp-Source: ABdhPJzL43Hvhuf8izRAtyg79L9voYCrmSguxjINSNKY6H8Z38LCQfA0Lm/O9QC08lHKzBZrKGK5fw==
X-Received: by 2002:a17:902:cec5:: with SMTP id d5mr10870476plg.115.1644247969704;
        Mon, 07 Feb 2022 07:32:49 -0800 (PST)
Received: from [192.168.1.4] (ip72-201-141-123.ph.ph.cox.net. [72.201.141.123])
        by smtp.gmail.com with ESMTPSA id a12sm8439987pfv.18.2022.02.07.07.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 07:32:48 -0800 (PST)
Message-ID: <070c5cef-e6e8-204e-f89c-d00405852849@digitalocean.com>
Date:   Mon, 7 Feb 2022 08:32:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH] md: raid456 improve discard performance
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
References: <20220203051546.12337-1-vverma@digitalocean.com>
 <f536866d-d565-a06b-8da1-4bd7a0f4de53@digitalocean.com>
 <CALTww2_ch90DfuEs=U_Epd6=YrPhYR_J3B6E-3B8zBV1Tf3MYg@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CALTww2_ch90DfuEs=U_Epd6=YrPhYR_J3B6E-3B8zBV1Tf3MYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 2/7/22 12:24 AM, Xiao Ni wrote:
> Hi Vishal
>
> Thanks for this. The thought of sending discard bio to member disk
> directly should be
> good. As you said, raid456 is more complicated with raid0/raid10. It
> needs to think about
> more things. First, it needs to avoid conflict with resync I/O. I
> don't read the codes below.
> The format is not right. There is no proper tab in the beginning of
> each line of code.
Thanks!
Yeah somehow the formatting for messed up. Sorry about that. Just sent 
it again.
> And what's your specific question you want to talk about?
Right, so I was struggling to debug the stabilty issue. It is working 
when creating a raid6
array and mkfs.ext4 it with discard. But, as soon as I issue fstrim to 
it, fstrim is hanging which
is pointing to probably some chunk mis-alignment issue. Thats where 
would like help with
reviewing the code and see if I am calculating the discard region and 
start/end correctly.
>
> Regards
> Xiao
>
> On Thu, Feb 3, 2022 at 1:28 PM Vishal Verma <vverma@digitalocean.com> wrote:
>> Hello,
>>
>> I would like to get your feedback on the following patch for improving
>> raid456 discard performance. This seem to improve discard performance
>> for raid456 quite significantly (just like raid10 discard optimization did).
>> Unfortunately, this patch is not in stable form right now. I do not have
>> very good understanding of raid456 code and would really love to get
>> your guys feedback.
>>
>>
>> I basically tried to incorporate raid0's optimzed discard code logic
>> into raid456 make_discard fn, but I am sure I am missing some things
>> as the raid456 layout is very different than that of raid0 or 10.
>> Would appreciate the feedback.
>>
>>
>> This patch improves discard performance with raid456 by sending
>> discard bio directly to the underlying disk just like how raid0/10
>> handle discard request. Currently, the discard request for raid456
>> gets sent to the disks on a per stripe basis which involves lots of
>> bio split/merge and makes it pretty slow performant vs. sending
>> the requests directly to the disks. This patch is intended to issue
>> discard request in the the similar way with patch
>> 29efc390b (md/md0: optimize raid0 discard handling).
>>
>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>> ---
>> drivers/md/raid5.c | 184 ++++++++++++++++++++++++---------------------
>> 1 file changed, 99 insertions(+), 85 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 7c119208a214..2d57cf105471 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5681,93 +5681,108 @@ static void release_stripe_plug(struct mddev
>> *mddev,
>> static void make_discard_request(struct mddev *mddev, struct bio *bi)
>> {
>> - struct r5conf *conf = mddev->private;
>> - sector_t logical_sector, last_sector;
>> - struct stripe_head *sh;
>> - int stripe_sectors;
>> -
>> - /* We need to handle this when io_uring supports discard/trim */
>> - if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
>> + struct r5conf *conf = mddev->private;
>> + sector_t bio_start, bio_end;
>> + unsigned int start_disk_index, end_disk_index;
>> + sector_t start_disk_offset, end_disk_offset;
>> + sector_t first_stripe_index, last_stripe_index;
>> + sector_t split_size;
>> + struct bio *split;
>> + unsigned int remainder;
>> + int d;
>> + int stripe_sectors;
>> +
>> + /* We need to handle this when io_uring supports discard/trim */
>> + if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
>> + return;
>> +
>> + if (mddev->reshape_position != MaxSector)
>> + /* Skip discard while reshape is happening */
>> + return;
>> +
>> + stripe_sectors = conf->chunk_sectors *
>> + (conf->raid_disks - conf->max_degraded);
>> +
>> + if (bio_sectors(bi) < stripe_sectors * 2)
>> return;
>> - if (mddev->reshape_position != MaxSector)
>> - /* Skip discard while reshape is happening */
>> - return;
>> -
>> - logical_sector = bi->bi_iter.bi_sector &
>> ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
>> - last_sector = bio_end_sector(bi);
>> -
>> - bi->bi_next = NULL;
>> -
>> - stripe_sectors = conf->chunk_sectors *
>> - (conf->raid_disks - conf->max_degraded);
>> - logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
>> - stripe_sectors);
>> - sector_div(last_sector, stripe_sectors);
>> -
>> - logical_sector *= conf->chunk_sectors;
>> - last_sector *= conf->chunk_sectors;
>> -
>> - for (; logical_sector < last_sector;
>> - logical_sector += RAID5_STRIPE_SECTORS(conf)) {
>> - DEFINE_WAIT(w);
>> - int d;
>> - again:
>> - sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
>> - prepare_to_wait(&conf->wait_for_overlap, &w,
>> - TASK_UNINTERRUPTIBLE);
>> - set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
>> - if (test_bit(STRIPE_SYNCING, &sh->state)) {
>> - raid5_release_stripe(sh);
>> - schedule();
>> - goto again;
>> - }
>> - clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
>> - spin_lock_irq(&sh->stripe_lock);
>> - for (d = 0; d < conf->raid_disks; d++) {
>> - if (d == sh->pd_idx || d == sh->qd_idx)
>> - continue;
>> - if (sh->dev[d].towrite || sh->dev[d].toread) {
>> - set_bit(R5_Overlap, &sh->dev[d].flags);
>> - spin_unlock_irq(&sh->stripe_lock);
>> - raid5_release_stripe(sh);
>> - schedule();
>> - goto again;
>> - }
>> - }
>> - set_bit(STRIPE_DISCARD, &sh->state);
>> - finish_wait(&conf->wait_for_overlap, &w);
>> - sh->overwrite_disks = 0;
>> - for (d = 0; d < conf->raid_disks; d++) {
>> - if (d == sh->pd_idx || d == sh->qd_idx)
>> - continue;
>> - sh->dev[d].towrite = bi;
>> - set_bit(R5_OVERWRITE, &sh->dev[d].flags);
>> - bio_inc_remaining(bi);
>> - md_write_inc(mddev, bi);
>> - sh->overwrite_disks++;
>> - }
>> - spin_unlock_irq(&sh->stripe_lock);
>> - if (conf->mddev->bitmap) {
>> - for (d = 0;
>> - d < conf->raid_disks - conf->max_degraded;
>> - d++)
>> - md_bitmap_startwrite(mddev->bitmap,
>> - sh->sector,
>> - RAID5_STRIPE_SECTORS(conf),
>> - 0);
>> - sh->bm_seq = conf->seq_flush + 1;
>> - set_bit(STRIPE_BIT_DELAY, &sh->state);
>> - }
>> -
>> - set_bit(STRIPE_HANDLE, &sh->state);
>> - clear_bit(STRIPE_DELAYED, &sh->state);
>> - if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>> - atomic_inc(&conf->preread_active_stripes);
>> - release_stripe_plug(mddev, sh);
>> - }
>> -
>> - bio_endio(bi);
>> + bio_start = bi->bi_iter.bi_sector &
>> ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
>> + bio_end = bio_end_sector(bi);
>> +
>> + /*
>> + * Keep bio aligned with strip size.
>> + */
>> + div_u64_rem(bio_start, stripe_sectors, &remainder);
>> + if (remainder) {
>> + split_size = stripe_sectors - remainder;
>> + split = bio_split(bi, split_size, GFP_NOIO, &conf->bio_split);
>> + bio_chain(split, bi);
>> + /* Resend the fist split part */
>> + submit_bio_noacct(split);
>> + }
>> + div_u64_rem(bio_end-bio_start, stripe_sectors, &remainder);
>> + if (remainder) {
>> + split_size = bio_sectors(bi) - remainder;
>> + split = bio_split(bi, split_size, GFP_NOIO, &conf->bio_split);
>> + bio_chain(split, bi);
>> + /* Resend the second split part */
>> + submit_bio_noacct(bi);
>> + bi = split;
>> + }
>> +
>> + bio_start = bi->bi_iter.bi_sector &
>> ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
>> + bio_end = bio_end_sector(bi);
>> +
>> + bi->bi_next = NULL;
>> +
>> + first_stripe_index = bio_start;
>> + sector_div(first_stripe_index, stripe_sectors);
>> +
>> + last_stripe_index = bio_end;
>> + sector_div(last_stripe_index, stripe_sectors);
>> +
>> + start_disk_index = (int)(bio_start - first_stripe_index *
>> stripe_sectors) /
>> + conf->chunk_sectors;
>> + start_disk_offset = ((int)(bio_start - first_stripe_index *
>> stripe_sectors) %
>> + conf->chunk_sectors) +
>> + first_stripe_index * conf->chunk_sectors;
>> + end_disk_index = (int)(bio_end - last_stripe_index * stripe_sectors) /
>> + conf->chunk_sectors;
>> + end_disk_offset = ((int)(bio_end - last_stripe_index * stripe_sectors) %
>> + conf->chunk_sectors) +
>> + last_stripe_index * conf->chunk_sectors;
>> +
>> + for (d = 0; d < conf->raid_disks; d++) {
>> + sector_t dev_start, dev_end;
>> + struct md_rdev *rdev = READ_ONCE(conf->disks[d].rdev);
>> +
>> + dev_start = bio_start;
>> + dev_end = bio_end;
>> +
>> + if (d < start_disk_index)
>> + dev_start = (first_stripe_index + 1) *
>> + conf->chunk_sectors;
>> + else if (d > start_disk_index)
>> + dev_start = first_stripe_index * conf->chunk_sectors;
>> + else
>> + dev_start = start_disk_offset;
>> +
>> + if (d < end_disk_index)
>> + dev_end = (last_stripe_index + 1) * conf->chunk_sectors;
>> + else if (d > end_disk_index)
>> + dev_end = last_stripe_index * conf->chunk_sectors;
>> + else
>> + dev_end = end_disk_offset;
>> +
>> + if (dev_end <= dev_start)
>> + continue;
>> +
>> + md_submit_discard_bio(mddev, rdev, bi,
>> + dev_start + rdev->data_offset,
>> + dev_end - dev_start);
>> + }
>> +
>> + bio_endio(bi);
>> }
>> static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>>
>> --
>> 2.17.1
>>
