Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CADC433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 08:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A95611BF
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 08:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239564AbhESIDq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 04:03:46 -0400
Received: from mailgw.kylinos.cn ([123.150.8.42]:42601 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237902AbhESIDq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 04:03:46 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2021 04:03:45 EDT
X-UUID: 6fa816de7d49418c9788e601971b3b0d-20210519
X-UUID: 6fa816de7d49418c9788e601971b3b0d-20210519
X-User: jiangguoqing@kylinos.cn
Received: from [172.30.60.82] [(111.207.174.14)] by nksmu.kylinos.cn
        (envelope-from <jiangguoqing@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 1706070496; Wed, 19 May 2021 15:57:26 +0800
From:   Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: Re: [PATCH] md/raid5: remove an incorect assert in in_chunk_boundary
To:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     song@kernel.org, axboe@kernel.dk, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, "Florian D ." <spam02@dazinger.net>
References: <20210519062215.4111256-1-hch@lst.de>
 <YKSvDeWqtmYOl/ua@infradead.org>
Message-ID: <ce47915c-4439-95ca-1a5a-6e4759b77bfa@kylinos.cn>
Date:   Wed, 19 May 2021 15:57:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YKSvDeWqtmYOl/ua@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/19/21 2:24 PM, Christoph Hellwig wrote:
> s/incorect/incorrect/ in the subject, sorry.
>
> On Wed, May 19, 2021 at 08:22:15AM +0200, Christoph Hellwig wrote:
>> Now that the original bdev is stored in the bio this assert is incorrect
>> and will trigge for any partitioned raid5 device.

Maybe s/trigge/trigger/? Anyway

Reviewed-by:  Guoqing Jiang <jiangguoqing@kylinos.cn>

Thanks,
Guoqing
