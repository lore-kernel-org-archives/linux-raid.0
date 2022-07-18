Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E5CC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 20:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiGRUDB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiGRUDA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 16:03:00 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596C31E3C0;
        Mon, 18 Jul 2022 13:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=MmKJ8JbSCPnkHS0R07LcqLAlcsYpAinDhk7UwVYf5KA=; b=UWwFmWFfPb/oIEH3hTfBvU5aSV
        0Ae1lqbHQTV5COtsEd/w8eCCM4tMZH7BXukx4rjZDy6NsVmz6qKGmQBl7QNKNRpEpzoVcmj7qUT7W
        usCIUxGsaqORtA8qHZq55+tTceX1cARUYaJKh7OmhEZVa+L0xTxl1EzkSBFpC7wNhE/J5WIJprw4k
        KTwRW58f0u5I21j1zlKBhCf/6hCTeLr9nzp8CDGdMN2T1SoVqWO2HfOmQbA3AmeGXPvjnW9S+hm1F
        jJPkpCCyHdbPOCY3iAmjlMqRgpQ8VLz+DM+cZzvLpXCaQmlwAl8JmQ7sT/UDeKUL898p7ZvScE/KF
        mRIK3f3g==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDWxF-000iZD-SE; Mon, 18 Jul 2022 14:02:58 -0600
Message-ID: <8887e756-f98d-2b96-7de2-fcf0c83514ca@deltatee.com>
Date:   Mon, 18 Jul 2022 14:02:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-7-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220718063410.338626-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 06/10] md: stop using for_each_mddev in md_do_sync
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-18 00:34, Christoph Hellwig wrote:
> Just do a plain list_for_each that only grabs a mddev reference in
> the case where the thread sleeps and restarts the list iteration.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
