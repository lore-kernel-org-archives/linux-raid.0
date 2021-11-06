Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745DEC433F5
	for <linux-raid@archiver.kernel.org>; Sat,  6 Nov 2021 15:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A01611EE
	for <linux-raid@archiver.kernel.org>; Sat,  6 Nov 2021 15:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhKFP1f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 Nov 2021 11:27:35 -0400
Received: from out2.migadu.com ([188.165.223.204]:36040 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhKFP1f (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 6 Nov 2021 11:27:35 -0400
Subject: Re: [PATCH v3 2/2] md: raid1 add nowait support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1636212293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YlLfmKd11z68Zaj+DiMQDGUVqLR15zRbfImYmEB7RjM=;
        b=jLuDXqeHMPOYAVbKXt1rWy8s5Fo5/DEPrkt55SkV1gHfRBpwAqB/SrMd8eSZlRgfiFKjk6
        v5VqplMAcKHxeb9BJH37fcQPI8Q1J3QgiUH0Jtl6EBqi8B+pJDf7RwPty/0lDXuAuKVp70
        Mq6PctxzmwndjPEpVvdsu+ah45IC00c=
To:     Vishal Verma <vverma@digitalocean.com>, song@kernel.org,
        linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <595ad3d1-ea04-c04a-50ed-3385b44d0d40@linux.dev>
Date:   Sat, 6 Nov 2021 23:24:48 +0800
MIME-Version: 1.0
In-Reply-To: <20211104045149.9599-1-vverma@digitalocean.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/4/21 12:51 PM, Vishal Verma wrote:
> This adds nowait support to the RAID1 driver.

What about raid10 and raid456?

Thanks,
Guoqing
