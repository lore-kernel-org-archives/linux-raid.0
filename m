Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99514C001DE
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jul 2023 14:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbjGaOGs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbjGaOG1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Jul 2023 10:06:27 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB711986
        for <linux-raid@vger.kernel.org>; Mon, 31 Jul 2023 07:02:18 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d9443c01a7336-1bbdc05a93bso26878835ad.0
        for <linux-raid@vger.kernel.org>; Mon, 31 Jul 2023 07:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1690812138; x=1691416938;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DiBou5vLsb2flqzlwH9WqMl1tco7x4ou6o9H0RHBgqM=;
        b=V7hZe26dRUDuz6LOflyh8tvburgueA319NDg5zyn8KJ7Y8NPP0b4Zv+jPb4MqHC0dE
         GouFmpysWNeUp4j/byX+BSJzZGNxmgMAhzQwzDWFxPFLYB+U9goxEioVFfoTftwvrgYO
         VgRGNAIYbg2skgajhCEk9a75UkqNiW/cQOEnhkkOQwfGGkTLxBrfOAMgMqzXbYWOtvue
         /lsr1MYnnOOiA16hTYrmdE8UPvUMdgK0W7IMYU7sqolDOvvXvpNwASHxnyhHle4N3/pW
         5oUhrLKymsPzbJYVXazrh1s9jxlbCnjLdIGdxuod71FBZR965g0/eY6sOANpcUK6CEAz
         mvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690812138; x=1691416938;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DiBou5vLsb2flqzlwH9WqMl1tco7x4ou6o9H0RHBgqM=;
        b=SivBs5FusoPQ4M6bsFoz0c0676icd06zKv1VP3yKNkH362fimVqjLs/bPy7ZQS4eZE
         XBY50jL04HB6jiymFSdXPgO9IqmtU+7Hxm6tpeQsiJW0MAZZPSZPlviBYarp+BpniP7g
         ala1CKGXhxvuCKDMYz12kGCEkdYFJx8crqeom7vu7lsHBW4C5PeeJsk5kBaW3dE6EoYm
         o30pwwwQ4wdXvy4YC20+1SdmmDFfPfxClbj4VGL1pVxPcGVwYN0PgEgiP2XjYyc72FYg
         /R0nasFdNvsP9AfNE+0j9lWkwJ0Hy7o1ucPnLT8qf0QM3w0vSl8fSh1g4qBUxIqV/VGj
         IV0Q==
X-Gm-Message-State: ABy/qLb/BYv6EXsV4Qt74r8BEXle4il8h/fNOb9ebau1F6uQVd/VQ7ak
        gOFQ4njx1/nYk7RkxVXNuhP03PmrxuLocF7urCXX7piaA6XGqQ==
X-Google-Smtp-Source: APBJJlHqUtvJZzw3I/1WCVyWyciM4xrDGsVgRhiFIBH/a6frT0tSmqrTkYm8sbcQ2ieu0decxhhxuw==
X-Received: by 2002:a17:902:d2d1:b0:1bb:a55d:c6e7 with SMTP id n17-20020a170902d2d100b001bba55dc6e7mr11344402plc.55.1690812137696;
        Mon, 31 Jul 2023 07:02:17 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id li11-20020a170903294b00b001b89f6550d1sm8617835plb.16.2023.07.31.07.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:02:17 -0700 (PDT)
Date:   Mon, 31 Jul 2023 22:02:13 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org
Subject: Re: [PATCH v3 1/3] md/raid1: freeze array more strictly when reshape
Message-ID: <dxzuor2h2rkkzlkmbvgxcipvumsy7xlitxpnmgj4lcm3rclcuv@thwglgsryebj>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-2-xueshi.hu@smartx.com>
 <a3a45aa9-a54c-51ee-8a80-b663a418dc29@huaweicloud.com>
 <c42b56ef-9652-ed41-b675-e972a88e930d@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c42b56ef-9652-ed41-b675-e972a88e930d@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 20, 2023 at 09:37:38AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/20 9:36, Yu Kuai 写道:
> > Hi,
> > 
> > 在 2023/07/19 15:09, Xueshi Hu 写道:
> > > When an IO error happens, reschedule_retry() will increase
> > > r1conf::nr_queued, which makes freeze_array() unblocked. However, before
> > > all r1bio in the memory pool are released, the memory pool should not be
> > > modified. Introduce freeze_array_totally() to solve the problem. Compared
> > > to freeze_array(), it's more strict because any in-flight io needs to
> > > complete including queued io.
> > > 
> > > Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> > > ---
> > >   drivers/md/raid1.c | 35 +++++++++++++++++++++++++++++++++--
> > >   1 file changed, 33 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > > index dd25832eb045..5605c9680818 100644
> > > --- a/drivers/md/raid1.c
> > > +++ b/drivers/md/raid1.c
> > > @@ -1072,7 +1072,7 @@ static void freeze_array(struct r1conf *conf,
> > > int extra)
> > >       /* Stop sync I/O and normal I/O and wait for everything to
> > >        * go quiet.
> > >        * This is called in two situations:
> > > -     * 1) management command handlers (reshape, remove disk, quiesce).
> > > +     * 1) management command handlers (remove disk, quiesce).
> > >        * 2) one normal I/O request failed.
> > >        * After array_frozen is set to 1, new sync IO will be blocked at
> > > @@ -1111,6 +1111,37 @@ static void unfreeze_array(struct r1conf *conf)
> > >       wake_up(&conf->wait_barrier);
> > >   }
> > > +/* conf->resync_lock should be held */
> > > +static int get_pending(struct r1conf *conf)
> > > +{
> > > +    int idx, ret;
> > > +
> > > +    ret = atomic_read(&conf->nr_sync_pending);
> > > +    for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
> > > +        ret += atomic_read(&conf->nr_pending[idx]);
> > > +
> > > +    return ret;
> > > +}
> > > +
> > > +static void freeze_array_totally(struct r1conf *conf)
> > > +{
> > > +    /*
> > > +     * freeze_array_totally() is almost the same with
> > > freeze_array() except
> > > +     * it requires there's no queued io. Raid1's reshape will
> > > destroy the
> > > +     * old mempool and change r1conf::raid_disks, which are
> > > necessary when
> > > +     * freeing the queued io.
> > > +     */
> > > +    spin_lock_irq(&conf->resync_lock);
> > > +    conf->array_frozen = 1;
> > > +    raid1_log(conf->mddev, "freeze totally");
> > > +    wait_event_lock_irq_cmd(
> > > +            conf->wait_barrier,
> > > +            get_pending(conf) == 0,
> > > +            conf->resync_lock,
> > > +            md_wakeup_thread(conf->mddev->thread));
> > > +    spin_unlock_irq(&conf->resync_lock);
> > > +}
> > > +
> > >   static void alloc_behind_master_bio(struct r1bio *r1_bio,
> > >                          struct bio *bio)
> > >   {
> > > @@ -3296,7 +3327,7 @@ static int raid1_reshape(struct mddev *mddev)
> > >           return -ENOMEM;
> > >       }
> > > -    freeze_array(conf, 0);
> > > +    freeze_array_totally(conf);
> > 
> > I think this is wrong, raid1_reshape() can't be called with
> Sorry about thi typo, I mean raid1_reshape() can be called with ...
You're right, this is indeed a deadlock.

I am wondering whether this approach is viable

	if (unlikely(atomic_read(conf->nr_queued))) {
		kfree(newpoolinfo);
		mempool_exit(&newpool);
		unfreeze_array(conf);

		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
		md_wakeup_thread(mddev->thread);
		return -EBUSY;
	}

Thanks,
Hu

> 
> Thanks,
> Kuai
> > 'reconfig_mutex' grabbed, and this will deadlock because failed io need
> > this lock to be handled by daemon thread.(see details in [1]).
> > 
> > Be aware that never hold 'reconfig_mutex' to wait for io.
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=c4fe7edfc73f750574ef0ec3eee8c2de95324463
> > 
> > >       /* ok, everything is stopped */
> > >       oldpool = conf->r1bio_pool;
> > > 
> > 
> > .
> > 
> 
