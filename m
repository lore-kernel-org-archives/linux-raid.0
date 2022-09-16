Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05410ECAAA1
	for <linux-raid@archiver.kernel.org>; Fri, 16 Sep 2022 18:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiIPSgo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Sep 2022 14:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiIPSgd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Sep 2022 14:36:33 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63CCB81EC;
        Fri, 16 Sep 2022 11:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=PHd6kjLnJ0eKhdd4fw/gC/C7d0LeZYsJWCumoJ4LYDY=; b=SqFbAwCBJ+aLnzqE/IAGgf9qjk
        I3bRLpsEs5GvSkVyfDD4ftjJQ18I8JpnT+LippC9e751+OoSsdi56VoDucXZLWlFK+mLrvrPi2r8N
        dr7vuFsqKrWarj+YpWDj6kdZF0srp7IdxT78KK9riADKPBJ5neJUBxmtfb9ibnFJjqfZSFJlgzMYx
        F4QOW5EXqNuEXEeXod1IguibisyTljzFZWcA87RpA7h6zZRpjl/MuU/XfdKbrlkQ0Fdx+6Vnv58oS
        2XLG0BV/v6Im84usR2nPaODigeGH7kvjDhF99thqje5M+yKLeqS1nEQkD9QtfH/2CSe/vqcFaUCuA
        pbLQqzug==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oZGCR-003JPg-1M; Fri, 16 Sep 2022 12:36:27 -0600
Message-ID: <c3bc7107-2efd-4d82-6efa-b819aa055def@deltatee.com>
Date:   Fri, 16 Sep 2022 12:36:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
        guoqing.jiang@linux.dev, pmenzel@molgen.mpg.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com
References: <20220916113428.774061-1-yukuai1@huaweicloud.com>
 <20220916113428.774061-5-yukuai1@huaweicloud.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220916113428.774061-5-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: yukuai1@huaweicloud.com, song@kernel.org, guoqing.jiang@linux.dev, pmenzel@molgen.mpg.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v3 4/5] md/raid10: fix improper BUG_ON() in
 raise_barrier()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-16 05:34, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> 'conf->barrier' is protected by 'conf->resync_lock', reading
> 'conf->barrier' without holding the lock is wrong.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

