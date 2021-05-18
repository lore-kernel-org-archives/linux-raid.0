Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E875BC433B4
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 10:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3AA261185
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 10:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348391AbhERKNz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 06:13:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:20544 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348381AbhERKNv (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 May 2021 06:13:51 -0400
IronPort-SDR: OAATtMXLcyosq5C1tX92DXrfVHuU1oXwJo/FzFNekOLF3v0/Wm5pT3O3/yndYiR+M7SeexosNO
 K+kSM90VCVkA==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="200369677"
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="200369677"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 03:12:32 -0700
IronPort-SDR: 1HYWhlPeVIXzRVfq/lSjWLVlGIEXSeq3qnXuXMO4sbHoIZ8ZWyH2Cu5TCvWaYtohHVMv9bqXXx
 LrX7stpkMLLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="541687879"
Received: from apaszkie-desk.igk.intel.com ([10.102.102.225])
  by fmsmga001.fm.intel.com with ESMTP; 18 May 2021 03:12:31 -0700
From:   Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 2/5] md: the latest try for improve io stats accounting
To:     Guoqing Jiang <jgq516@gmail.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, Guoqing Jiang <jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-3-jiangguoqing@kylinos.cn>
Message-ID: <2887bc44-dd0b-0b24-ee97-b0a95f0c4936@intel.com>
Date:   Tue, 18 May 2021 12:12:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210518053225.641506-3-jiangguoqing@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18.05.2021 07:32, Guoqing Jiang wrote:
> +     /*
> +      * We don't clone bio for multipath, raid1 and raid10 since we can reuse
> +      * their clone infrastructure.
> +      */
> +     if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue) &&
> +         (bio->bi_pool != &mddev->md_io_bs) &&
> +         (mddev->level != 1) && (mddev->level != 10) &&
> +         (mddev->level != LEVEL_MULTIPATH)) {

Maybe add a flag to struct md_personality and check it here? Something
that will be set only for the personalities which clone the bio
themselves.

Doesn't this need to check the bio->bi_pool also against mddev->bio_set
to skip the bios split by md? Similarly to the check against 
bio_chain_endio which you did before.

Thanks,
Artur
