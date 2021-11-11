Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80731C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 11 Nov 2021 13:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C6716120D
	for <linux-raid@archiver.kernel.org>; Thu, 11 Nov 2021 13:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhKKNNC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Nov 2021 08:13:02 -0500
Received: from group.wh-serverpark.com ([159.69.170.92]:35568 "EHLO
        group.wh-serverpark.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhKKNNB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Nov 2021 08:13:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 74D0BEEBA42;
        Thu, 11 Nov 2021 14:10:11 +0100 (CET)
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id IFyBJUOXbI1H; Thu, 11 Nov 2021 14:10:11 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 02994EEBA49;
        Thu, 11 Nov 2021 14:10:11 +0100 (CET)
X-Virus-Scanned: amavisd-new at valiant.wh-serverpark.com
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KeDl7YZQq4XW; Thu, 11 Nov 2021 14:10:10 +0100 (CET)
Received: from enterprise.localnet (unknown [93.189.159.254])
        by group.wh-serverpark.com (Postfix) with ESMTPSA id D7399EEBA42;
        Thu, 11 Nov 2021 14:10:10 +0100 (CET)
From:   Markus Hochholdinger <Markus@hochholdinger.net>
To:     Neil Brown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, Chris Webb <chris@arachsys.com>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running arrays.
Date:   Thu, 11 Nov 2021 14:10:04 +0100
Message-ID: <5424512.plDBMOIIcH@enterprise>
User-Agent: KMail/5.2.3 (Linux/4.19.0-0.bpo.6-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <1941952.8ZYzkbqb7V@enterprise>
References: <20080627164503.9671.patches@notabene> <1930539.SuHy7v25Ye@enterprise> <1941952.8ZYzkbqb7V@enterprise>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Am Mittwoch, 10. November 2021, 18:51:19 CET schrieb Markus Hochholdinger:
> It is working es (I) expected till at least kernel 5.4.158.
> It is not working with 5.10.x till 5.15.1.

it is working with
  5.8.18
and is not working with
  5.9.16

Currently I'm looking into the diff md.c between these two kernel versions to 
find the error (I'll try to figure this out):

@@ -2184,13 +2212,22 @@ super_1_rdev_size_change(struct md_rdev *rdev, 
sector_t num_sectors)
                return 0;
        } else {
                /* minor version 0; superblock after data */
-               sector_t sb_start;
-               sb_start = (i_size_read(rdev->bdev->bd_inode) >> 9) - 8*2;
+               sector_t sb_start, bm_space;
+               sector_t dev_size = i_size_read(rdev->bdev->bd_inode) >> 9;
+
+               /* 8K is for superblock */
+               sb_start = dev_size - 8*2;
                sb_start &= ~(sector_t)(4*2 - 1);
-               max_sectors = rdev->sectors + sb_start - rdev->sb_start;
+
+               bm_space = super_1_choose_bm_space(dev_size);
+
+               /* Space that can be used to store date needs to decrease
+                * superblock bitmap space and bad block space(4K)
+                */
+               max_sectors = sb_start - bm_space - 4*2;
+
                if (!num_sectors || num_sectors > max_sectors)
                        num_sectors = max_sectors;
-               rdev->sb_start = sb_start;
        }
        sb = page_address(rdev->sb_page);
        sb->data_size = cpu_to_le64(num_sectors);


-- 
Mfg

Markus Hochholdinger
