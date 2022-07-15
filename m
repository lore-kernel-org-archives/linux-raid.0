Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C562DC43334
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jul 2022 09:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiGOJCo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jul 2022 05:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiGOJCm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Jul 2022 05:02:42 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD0B78DC9;
        Fri, 15 Jul 2022 02:02:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657875760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aGK5SB/6T9qrJYhGg5fGhFJpq52XN8nE6d4BW8QyEaM=;
        b=scBpDYfDicEzB9o+wlsEmz7N42cAJvOFfDm75JYC4mzGfZWB0Zw3G1ukXbKVCnf7NG1dLh
        /UGSppJt4WiDav1uYz5fRrykZ2Jvzkdz1/g4bZ6/RPsN3RQRWPK6N3tv/ZcLLX2b8Lgs2G
        AEDfqzw0Ah4W4yypmFaeN5AQbdp1Azg=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 6/9] md: stop using for_each_mddev in md_notify_reboot
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220713113125.2232975-1-hch@lst.de>
 <20220713113125.2232975-7-hch@lst.de>
Message-ID: <6fa6e045-eb3e-9c72-723d-6e0fe571c728@linux.dev>
Date:   Fri, 15 Jul 2022 17:02:35 +0800
MIME-Version: 1.0
In-Reply-To: <20220713113125.2232975-7-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 7/13/22 7:31 PM, Christoph Hellwig wrote:
> Just do a simple list_for_each_entry_safe on all_mddevs, and only grab a
> reference when we drop the lock.
>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

I suppose it actually means SoB 😉

Thanks,
Guoqing
