Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAFCC25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344830AbjJZVlU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjJZVlT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:41:19 -0400
X-Greylist: delayed 907 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Oct 2023 14:41:17 PDT
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039F2128
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:41:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698355518; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=O9oIfEO9OBo1ICjBaTrkKQiPdnHh8LkDS3CNkwhv/uM9pASzR23GusoXxI7jGSgvge39BbcY9e/4X5w4Cl+T9c7d4GlRrxUx7R51qo7gl6Hy2FCa4rdnORknPrZf51DRJClK2+8DuvoTqpOvw/61MEiVaCMdbdETcpa2Vy4AArw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698355518; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=Wo/MIgqo/AZ9yzJv6KfqbERlZJ9DV73FHRNkLQWYUM0=; 
        b=eHXbmy/rR7SjWypH96hF/JuOXh1fKrTm+Bon9JWtnpV8eon64jRBzPjC+2kCyYOx3ia54Ud1R/7JsYhsR1v6MaFhjiLT0Yo4gALpA1o9QB9MXMyg/15oUZN43McgHbtS5w9CqFW6Eu+1qpmsPxF+TiNllkil4xJ+jPKvZOvX3AE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698355512996680.2185422634632; Thu, 26 Oct 2023 23:25:12 +0200 (CEST)
Message-ID: <7c04183c-b596-ee4b-0e74-3d61806912af@trained-monkey.org>
Date:   Thu, 26 Oct 2023 17:25:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH tests v2 0/8] tests: add some regression tests
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com, pmenzel@molgen.mpg.de,
        logang@deltatee.com, song@kernel.org, guoqing.jiang@linux.dev
Cc:     yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/29/23 09:28, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Total 7 regression test is added:
> 
>  - 23rdev-lifetime
>  - 25raid456-recovery-while-reshape
>  - 25raid456-reshape-corrupt-data
>  - 25raid456-reshape-deadlock
> fixed patches is applied for above tests.
> 
>  - 25raid456-reshape-while-recovery
>  - 24raid10deadlock
>  - 24raid456deadlock
> fixed patches is not merged yet, and they're still in maillist.
> 
> Changes in v2:
>  - use new way to judge if test failed for patch 1,34
>  - add four new tests, patch 5-8

All applied!

Thanks,
Jes


