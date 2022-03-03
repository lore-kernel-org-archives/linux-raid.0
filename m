Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E85C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  3 Mar 2022 01:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiCCBlQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Mar 2022 20:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiCCBlP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Mar 2022 20:41:15 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170961B5120
        for <linux-raid@vger.kernel.org>; Wed,  2 Mar 2022 17:40:30 -0800 (PST)
Subject: Re: Raid5 Batching Question
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1646271627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s+353RJDliQSNJ1I68AzwRrOWID0IdI3YGve6KLbKwA=;
        b=U2IdOrtnUMgBj4v9/HpCabxZ8NYkEr9aP8GCJomz5w1ys0Z5pISThL+YlIFHPll1epAk6j
        4H8x2n3u8zw6fmL/e1w+GYSM2/B5YswD9SUH8iEkWuqxBMq4IbxkKtgn/Xe/ze3/2k0kbc
        yksIGEdMwp/sJJWkCzIiTkUetgI+QJk=
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
Cc:     Shaohua Li <shli@kernel.org>, Shaohua Li <shli@fb.com>,
        Song Liu <song@kernel.org>
References: <11cfe3aa-b778-b3e5-a152-50abc6c054ac@deltatee.com>
 <34a8b64a-37d3-9966-1fe8-d57c432600d7@deltatee.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <806cdd27-8633-09dd-6942-12437c8b9818@linux.dev>
Date:   Thu, 3 Mar 2022 09:40:20 +0800
MIME-Version: 1.0
In-Reply-To: <34a8b64a-37d3-9966-1fe8-d57c432600d7@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/3/22 7:24 AM, Logan Gunthorpe wrote:
> So I'm back to square one trying to find some performance improvements
> on the write path.

Did you try with group_thread_cnt?

/sys/block/md0/md/group_thread_cnt

Thanks,
Guoqing
