Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CF6C433ED
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 07:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E7216108B
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 07:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhEUHeY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 May 2021 03:34:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:30857 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233932AbhEUHeX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 May 2021 03:34:23 -0400
IronPort-SDR: m8hhE5ywQ9pkcg7gbGoQffuHrc89EaWGagEEB6kQ9a9OQ3MXiWUgErD/JN1rcCtb5PKfoKkqv4
 88+jM4+GUJzQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="198344978"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="198344978"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 00:33:01 -0700
IronPort-SDR: Dp1pltPo6Eo4TpexZYbqdudBwcCI8ksY3YMGmg2AzzXJJopOqawGjKwbY6UM8qXxuJl3yyaiTa
 rUm0U7sHbMWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="406525757"
Received: from apaszkie-desk.igk.intel.com ([10.102.102.225])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2021 00:33:00 -0700
Subject: Re: [PATCH V2 3/7] md: the latest try for improve io stats accounting
To:     Guoqing Jiang <jgq516@gmail.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
 <20210521005521.713106-4-jiangguoqing@kylinos.cn>
From:   Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Message-ID: <83d02180-27ee-f8c2-7a41-f9b587324536@intel.com>
Date:   Fri, 21 May 2021 09:32:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521005521.713106-4-jiangguoqing@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> @@ -2340,9 +2383,12 @@ int md_integrity_register(struct mddev *mddev)
>                              bdev_get_integrity(reference->bdev));
>  
>       pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
> -     if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
> +     if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
> +         bioset_integrity_create(&mddev->md_io_bs, BIO_POOL_SIZE)) {
>               pr_err("md: failed to create integrity pool for %s\n",
>                      mdname(mddev));
> +             bioset_exit(&mddev->bio_set);
> +             bioset_exit(&mddev->md_io_bs);
>               return -EINVAL;

Are you sure bioset_exit() here is correct? This is always called from
pers->run() and the cleanup in case of error is handled in md_run().
