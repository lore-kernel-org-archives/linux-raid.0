Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65A3ECAAA2
	for <linux-raid@archiver.kernel.org>; Thu, 25 Aug 2022 22:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244341AbiHYWUC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Aug 2022 18:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244414AbiHYWTr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 Aug 2022 18:19:47 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90080C59D7;
        Thu, 25 Aug 2022 15:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:From:Cc:To:MIME-Version:Date:Message-ID
        :references:content-disposition:in-reply-to;
        bh=j5DvIPz+Xj4DPIqyLR8g5oRUclTxtSnyrrcCMGtVKXk=; b=WpXQ0jaJi6RMaCqt2ndLThxBEy
        h2cIADkkEtlz08++oNzbSZy8Jin+b+5EBctI+5kH6lHe+oemU3lzXjTu50q9u11zzyI/gUyghs3ax
        j5wT/yHBeUgAw+mruDNjoFynbfa9VGsu9+/Kt69oeNVataloJphO28EDhPKCVgEtlI1SCcI9iiG+o
        Qvlqk4eV2AiNMbDC7njXib4LEH2BgJiGFCNAks83jhEO+KYBaOYsgVpZeTCdAiE5aRt9iCeeCaZII
        okl6U8TmXW5HjavT3/mrPlMhaC/jcEZ86DSJNE678MDttTsP2MfxC7Wnu7YEkqIS3466HvZXku3jR
        0Zwz8UVQ==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oRLCM-008CAf-1Z; Thu, 25 Aug 2022 16:19:39 -0600
Message-ID: <7f3b87b6-b52a-f737-51d7-a4eec5c44112@deltatee.com>
Date:   Thu, 25 Aug 2022 16:19:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>
From:   Logan Gunthorpe <logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: axboe@kernel.dk, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Deadlock Issue with blk-wbt and raid5+journal
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

While testing md/raid5 with the journal option using loop devices, I've
found an easily reproducible hang on my system. Simply running an fio
write job with the md threadcnt set to 4 can hit it. However, curiously,
it is not hit without the journal being used.

I'm running on the current md/md-next branch; however I've seen this bug
for a couple months now on recent kernels and have no idea how long it's
been in the kernel for.

I end up seeing multiple hung tasks with the following stack trace:

   schedule+0x9e/0x140
  io_schedule+0x70/0xb0
  rq_qos_wait+0x153/0x210
  wbt_wait+0x127/0x1f0
  __rq_qos_throttle+0x38/0x60
  blk_mq_submit_bio+0x589/0xcd0
  __submit_bio+0xe6/0x100
  submit_bio_noacct_nocheck+0x42e/0x470
  submit_bio_noacct+0x4c2/0xbb0
  ops_run_io+0x46b/0x1a30
  handle_stripe+0xcd3/0x36c0
  handle_active_stripes.constprop.0+0x6f6/0xa60
  raid5_do_work+0x177/0x330
  process_one_work+0x609/0xb00
  worker_thread+0x2d4/0x710
  kthread+0x18c/0x1c0
  ret_from_fork+0x1f/0x30

When this happens, I find 1 to 10ish inflight IO on the WBT of the
underlying loop devices as seen in
'/sys/kernel/debug/block/loop[0-3]/rqos/wbt/inflight'.

I've done some debugging in this area and this is what I'm seeing:

There are a few IO in the WBT that start scheduling when the inflight
counter reaches the limit (96 in my case). Then, a number of IO tasks
are scheduled after the limit gets exceeded. So far that makes sense. I
put some tracing in wbt_rqw_done() and can see that the inflight counts
back down to a low number as other IO are completed, but then it hangs
before reaching zero. However, wbt_rqw_done() never wakes up any other
threads  because, for some reason, wb_recent_wait(rwb) always returns
false and thus the limit is always zero, and the conditional:

        if (inflight && inflight >= limit)
                return;

always gets hit because inflight is always greater than the zero limit
(as some inflight IO are sleeping waiting to be worken up). Thus the
sleeping tasks remain sleeping forever. I've also verified that
rwb_wake_all() never gets called in this scenario as well.

Given the conditions of hitting the bug, I fully expected this to be an
issue in the raid code, but unless I'm missing something, it sure looks
to me like a deadlock issue in the wbt code, which makes me wonder why
nobody else has hit it. Is there something else I'm missing that are
supposed to be waking up these processes? Or something weird about the
raid5+journal+loop code that is causing wb_recent_wait() to always be false?

Any thoughts?

Thanks,

Logan
