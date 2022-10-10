Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814DCC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 10 Oct 2022 08:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiJJIN4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Oct 2022 04:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiJJINy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Oct 2022 04:13:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184365245B
        for <linux-raid@vger.kernel.org>; Mon, 10 Oct 2022 01:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665389633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B35jyv4avcFL8MHY9TBz/uuWWDKMpdG+5zfFG7jXyP8=;
        b=GmtPQeljfgJJvzlqmNKVXVCN0nXOfeYBt19lJeW6eF1cOXpS+LWlJJp18kGtVGPvrQyCEx
        3lzuqVKtrPzZ19RupRBpR5RixYaZBZC0UW9QwEElTOQSkRe5BIw1SS4qcsdQg6oJcChHLd
        i2cUK9kxEQKFwnKzy5ui7kO0P1VO0Y8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-rBs-_hZFNCy9D37rwOzziQ-1; Mon, 10 Oct 2022 04:13:52 -0400
X-MC-Unique: rBs-_hZFNCy9D37rwOzziQ-1
Received: by mail-pj1-f72.google.com with SMTP id oo18-20020a17090b1c9200b0020bdba475afso4577784pjb.4
        for <linux-raid@vger.kernel.org>; Mon, 10 Oct 2022 01:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B35jyv4avcFL8MHY9TBz/uuWWDKMpdG+5zfFG7jXyP8=;
        b=3ZuTOQg1u0IuPoG0j/oKnkfSZw0TlYON3Hmoq3tbPRZTJF2WPIxsaMdDcRgzYcm3S1
         N+7RI+yHpGNz6qYP6RoKfuYlje8rvHxu/yCGkGmiYPpS1LQ+FAGyGLopeC8jU/EccF4y
         oyQimqw0BPdC9MU5E3jC7eOE/OpDeVtSvqxvHazi0nlznadDf2REmx5aO87KZGiDE2B9
         Z3JV4a5jYfhuA+zdetFFjRcYWUXGQWBt+FFx081opaSJaWsJYiJP9FTZm11IGTO6WpIO
         E+S29oXJEtlNnFEI8lnS61awGI5SgynnrxU9SxINzCVM0wpZ06fecvQoicFirmhcucep
         BwCg==
X-Gm-Message-State: ACrzQf1X4elWFYc2wmHBAMFKLjAbNkdUz/B8/FNaaysQvXY6PUyMAKU2
        JDniR7TeE+LfUjmT4gkMNMR8O2FAJ2arraRJayfPgxsBA/Hz9AaP7Hy9hO515uURoJO9hc5YF+w
        5TSOIHbYFVv/0mfuMdCXNlHKyNZfPOQnkrNCfyw==
X-Received: by 2002:a17:903:240a:b0:180:a7ff:78b7 with SMTP id e10-20020a170903240a00b00180a7ff78b7mr12446484plo.48.1665389631005;
        Mon, 10 Oct 2022 01:13:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM570r86mSL87en//MDT+FajY7w6FhVTeHu9ZIxhDPSWgZlgXK+DS1cvxLCi5B00JLlliYsrQc7yW7Cv9BTyJN4=
X-Received: by 2002:a17:903:240a:b0:180:a7ff:78b7 with SMTP id
 e10-20020a170903240a00b00180a7ff78b7mr12446473plo.48.1665389630723; Mon, 10
 Oct 2022 01:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww2-EAeM6aKeZbZ2udTwS5RFwNWfF9uag=npewB9j0H51Hw@mail.gmail.com>
 <35f4a626-7f83-56c5-4cad-73ede197ccbf@linux.dev> <CALTww2_jaUVEk-zeobWSn9+yDYfkESKEX6hAKZ+-O+dMzQS+Hg@mail.gmail.com>
In-Reply-To: <CALTww2_jaUVEk-zeobWSn9+yDYfkESKEX6hAKZ+-O+dMzQS+Hg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 10 Oct 2022 16:13:39 +0800
Message-ID: <CALTww2-LVHQdaq-5DQSH13z1aCcLUjN1o4aE-XcfoAnU0pSFbQ@mail.gmail.com>
Subject: Re: Memory leak when raid10 takeover raid0
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

How about something like this?

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 857c49399c28..c263173a142f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -393,6 +393,9 @@ static int raid0_run(struct mddev *mddev)
                mddev->private = conf;
        }
        conf = mddev->private;
+
+       init_waitqueue_head(&conf->wait_for_quiescent);
+
        if (mddev->queue) {
                struct md_rdev *rdev;

@@ -512,6 +515,18 @@ static void raid0_handle_discard(struct mddev
*mddev, struct bio *bio)
        bio_endio(bio);
 }

+static void raid0_end_request(struct bio *bio)
+{
+       struct bio *orig_bio = bio->bi_private;
+       struct gendisk *disk = orig_bio->bi_bdev->bd_disk;
+       struct mddev *mddev = disk->private;
+       struct r0conf *conf = mddev->private;
+
+       atomic_dec(&conf->bios);
+       bio_put(bio);
+       bio_endio(orig_bio);
+}
+
 static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 {
        struct r0conf *conf = mddev->private;
@@ -522,6 +537,7 @@ static bool raid0_make_request(struct mddev
*mddev, struct bio *bio)
        sector_t orig_sector;
        unsigned chunk_sects;
        unsigned sectors;
+       struct bio *r0_bio;

        if (unlikely(bio->bi_opf & REQ_PREFLUSH)
            && md_flush_request(mddev, bio))
@@ -575,15 +591,20 @@ static bool raid0_make_request(struct mddev
*mddev, struct bio *bio)
                return true;
        }

-       bio_set_dev(bio, tmp_dev->bdev);
-       bio->bi_iter.bi_sector = sector + zone->dev_start +
+       r0_bio = bio_alloc_clone(tmp_dev->bdev, bio, GFP_NOIO,
+                                       &mddev->bio_set);
+
+       r0_bio->bi_private = bio;
+       r0_bio->bi_end_io = raid0_end_request;
+       r0_bio->bi_iter.bi_sector = sector + zone->dev_start +
                tmp_dev->data_offset;

        if (mddev->gendisk)
-               trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
+               trace_block_bio_remap(r0_bio, disk_devt(mddev->gendisk),
                                      bio_sector);
-       mddev_check_write_zeroes(mddev, bio);
-       submit_bio_noacct(bio);
+       mddev_check_write_zeroes(mddev, r0_bio);
+       atomic_inc(&conf->bios);
+       submit_bio_noacct(r0_bio);
        return true;
 }

@@ -754,6 +775,10 @@ static void *raid0_takeover(struct mddev *mddev)

 static void raid0_quiesce(struct mddev *mddev, int quiesce)
 {
+       struct r0conf *conf = mddev->private;
+
+       if (quiesce)
+               wait_event(&conf->wait_for_quiescent,
atomic_read(&conf->bios)==0);
 }

 static struct md_personality raid0_personality=
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 3816e5477db1..a0ec5c235962 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -27,6 +27,9 @@ struct r0conf {
                                            * by strip_zone->dev */
        int                     nr_strip_zones;
        enum r0layout           layout;
+       atomic_t                bios;   /* The bios that submit to
+                                        * member disks */
+       struct wait_queue_head_t        wait_for_quiescent;
 };

Regards
Xiao

