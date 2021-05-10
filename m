Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3909EC43460
	for <linux-raid@archiver.kernel.org>; Mon, 10 May 2021 19:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08A5761424
	for <linux-raid@archiver.kernel.org>; Mon, 10 May 2021 19:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhEJTui (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 May 2021 15:50:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:39012 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhEJTuh (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 10 May 2021 15:50:37 -0400
IronPort-SDR: t+DQSuiIOcHY5/rKDv88rZxhaBvvKArrageHTZxOgbpelKyJehgSpPWYfxiAtIouB+t8AmuQWN
 +1Ym/Ha2vS2w==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="198951468"
X-IronPort-AV: E=Sophos;i="5.82,288,1613462400"; 
   d="scan'208";a="198951468"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 12:49:32 -0700
IronPort-SDR: 9X8UdaOzsCJpo3/+LJoiS1E/Bb5vW/ytxdYL3PwWIOvxQYojGkBJSY0tPCv0qsOfTGol+Tu9LI
 HEtxFGpqFP1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,288,1613462400"; 
   d="scan'208";a="468443102"
Received: from apaszkie-desk.igk.intel.com ([10.102.102.225])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2021 12:49:29 -0700
From:   Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] md: don't account io stat for split bio
To:     Guoqing Jiang <jgq516@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, pawel.wiejacha@rtbhouse.com
References: <20210508034815.123565-1-jgq516@gmail.com>
 <YJjL6AQ+mMgzmIqM@infradead.org>
 <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com>
Message-ID: <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
Date:   Mon, 10 May 2021 21:49:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/10/21 9:46 AM, Guoqing Jiang wrote:
> On 5/10/21 2:00 PM, Christoph Hellwig wrote:
>> On Sat, May 08, 2021 at 11:48:15AM +0800, Guoqing Jiang wrote:
>>> It looks like stack overflow happened for split bio, to fix this,
>>> let's keep split bio untouched in md_submit_bio.
>>>
>>> As a side effect, we need to export bio_chain_endio.
>> Err, no.  The right answer is to not change ->bi_end_io of bios that
>> you do not own instead of using a horrible hack to skip accounting for
>> bios that have no more or less reason to be accounted than others bios.
> 
> Thanks for the reply. I suppose that md needs to revert current
> implementation of accounting io stats, then re-implement it.
> 
> Song and Artur, what are your opinion?

In the initial version of the io accounting patch the bio was cloned instead
of just overriding bi_end_io and bi_private. Would this be the right approach?

https://lore.kernel.org/linux-raid/20200601161256.27718-1-artur.paszkiewicz@intel.com/
